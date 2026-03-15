;;; simple-outshine.el -*- lexical-binding: t; -*-

(require 'outline)

(defun my-outline-setup-engine (heading-regexp level-regexp configs &optional face-name-template)
  "通用大纲引擎（修复版：防止重复叠加导致字体变大）。"
  (let* ((case-fold-search nil)
         (template (or face-name-template "outline-%d")))
    
    ;; --- 新增：清除当前 buffer 之前可能的重映射记录 ---
    (setq-local face-remapping-alist (copy-tree (default-value 'face-remapping-alist)))

    ;; 1. 局部变量设置
    (setq-local outline-regexp heading-regexp)
    (setq-local outline-level 
                (lambda () 
                  (save-excursion 
                    (looking-at level-regexp)
                    (length (match-string 1)))))

    ;; 2. 局部样式定制
    (dolist (conf configs)
      (let* ((level (car conf))
             (attrs (cdr conf))
             (base-face (intern (format template level)))
             ;; 使用固定的符号名，避免产生无数匿名 Face
             (local-face-sym (intern (format "my-local-face-%s-%d" 
                                             (symbol-name major-mode) level))))
        (make-face local-face-sym)
        ;; 核心：使用 :height 1.0 或具体的绝对像素值，如果担心缩放，这里直接写 1.0
        (apply #'set-face-attribute local-face-sym nil :inherit nil :underline nil attrs)
        (face-remap-add-relative base-face local-face-sym)))

    ;; 3. 注入 Font-lock
    (font-lock-add-keywords nil 
      `((,heading-regexp (0 (let ((lvl (length (match-string 1))))
                              (intern (format ,template (min lvl 6)))) prepend))) t)
    
    (outline-minor-mode 1)

    ;; 4. Evil 绑定
    (when (fboundp 'evil-define-key)
      (evil-define-key 'normal 'local (kbd "<tab>") 
        (lambda () (interactive)
          (if (save-excursion (beginning-of-line) (looking-at outline-regexp))
              (outline-cycle)
            (indent-for-tab-command)))))
    
    (font-lock-flush)))

(defun my-outline/setup-elisp ()
  (my-outline-setup-engine 
    "^;;\\s-+\\(\\*\\{1,6\\}\\)\\s-+.*$" 
    "^;;\\s-+\\(\\*+\\)" 
    '((1 :foreground "#bd93f9" :height 1.50 :weight bold :inherit default) ; 强行继承 default
      (2 :foreground "#8be9fd" :height 1.25 :weight bold :inherit default)
      (3 :foreground "#ff79c6" :height 1.15 :weight bold :inherit default)
      (4 :foreground "#50fa7b" :height 1.05 :weight bold :inherit default)
      (5 :foreground "#f1fa8c" :height 1.0  :weight bold :inherit default)
      (6 :foreground "#ffb86c" :height 1.0  :weight bold :inherit default))))

(defun my-outline/setup-markdown ()
  "Markdown 专属配置：完全还原 custom-set-faces 的视觉效果。"
  (my-outline-setup-engine 
   "^\\(#\\{1,6\\}\\)\\s-+.*$"         ; 标题正则
   "^\\(#+\\)"                        ; 层级正则
   ;; 1. 样式列表：还原你提供的颜色和高度
   '((1 :foreground "#A3BE8C" :height 0.9 :weight bold)
     (2 :foreground "#EBCB8B" :height 0.9 :weight bold)
     (3 :foreground "#D08770" :height 0.9 :weight bold)
     (4 :foreground "#BF616A" :height 0.9 :weight bold)
     (5 :foreground "#b48ead" :height 0.9 :weight bold)
     (6 :foreground "#5e81ac" :height 0.9 :weight bold))
   "markdown-header-face-%d")          ; 使用 Markdown 原生 Face 前缀
    (face-remap-add-relative 'markdown-header-delimiter-face '(:foreground "#616161") :height 0.85)
  )

(provide 'simple-outshine)
