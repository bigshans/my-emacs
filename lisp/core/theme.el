;;; core/theme.el --- 主题与启动面板 -*- lexical-binding: t; -*-
;;
;; 对应 ~/.vim/core/theme.vim。Vim 默认用 inkstone（宣纸/苍海），
;; Emacs 这边继续使用 doom-dracula；后续可换成 catppuccin。

(use-package doom-themes
  :ensure t
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (load-theme 'doom-dracula t)
  (doom-themes-visual-bell-config)
  (doom-themes-neotree-config)
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

;; 专门针对 emacs-lisp-mode 的注释/字符串着色。
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (font-lock-add-keywords
             nil
             '(("\\(;.*\\)" 1 '(:foreground "#E67E22" :slant italic) t)
               ("\\(\".*?\"\\)" 0 '(:foreground "#E67E22") t)))))

;;; Dashboard -----------------------------------------------------------

(use-package dashboard
  :ensure t
  :config
  (add-to-list 'dashboard-item-generators
               '(my-easysession . my-stuff/dashboard-insert-easysessions))
  (setq dashboard-items '((recents . 5)
                          (projects . 5)
                          (my-easysession . 5)))

  ;; 显式指定 dashboard 页面的快捷键，避免 evil 的 r/p/e 抢占。
  (setq dashboard-item-shortcuts
        '((recents . "r")
          (projects . "p")
          (my-easysession . "s")))
  (dashboard-setup-startup-hook))

(defun my/dashboard-empty-buffer ()
  "新建一个空 buffer，对应 Vim dashboard 的 [e] empty buffer。"
  (interactive)
  (let ((buf (generate-new-buffer "*new*")))
    (with-current-buffer buf
      (fundamental-mode))
    (switch-to-buffer buf)
    (message "已新建空 buffer")))

(defun my/dashboard-setup-keys ()
  "Dashboard 页面的 r/p/s/e/q 键位。"
  (keymap-set dashboard-mode-map "r"
              (dashboard-cycle-section-forward 'recents))
  (keymap-set dashboard-mode-map "p"
              (dashboard-cycle-section-forward 'projects))
  (keymap-set dashboard-mode-map "s"
              (lambda () (interactive)
                (dashboard--goto-section 'my-easysession)))
  (keymap-set dashboard-mode-map "e" #'my/dashboard-empty-buffer)
  (keymap-set dashboard-mode-map "q" #'my-stuff/smart-quit)
  (with-eval-after-load 'evil
    (evil-define-key 'normal dashboard-mode-map
      "r" (lookup-key dashboard-mode-map "r")
      "p" (lookup-key dashboard-mode-map "p")
      "s" (lookup-key dashboard-mode-map "s")
      "e" (lookup-key dashboard-mode-map "e")
      "q" #'my-stuff/smart-quit)))

(add-hook 'dashboard-mode-hook #'my/dashboard-setup-keys)

;; evil-collection 会把 q 绑成 quit-window，加载后重新覆盖。
(with-eval-after-load 'evil-collection
  (my/dashboard-setup-keys))

(provide 'core/theme)
;;; core/theme.el ends here
