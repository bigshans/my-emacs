;;; conf.d/editing.el --- 编辑体验 -*- lexical-binding: t; -*-
;;
;; 对应 Vim 的 undo-fu/undofile、auto-pairs、sandwich、rainbow、
;; vim-visual-multi 等编辑类插件。

;;; 持久撤销 -------------------------------------------------------------

(use-package undo-fu
  :ensure t)

(use-package undohist
  :ensure t
  :after evil
  :config
  (setq undohist-directory (expand-file-name "var/undohist" user-emacs-directory))
  (setq undohist-ignored-files '("/tmp/" "/COMMIT_EDITMSG\\'"))
  (undohist-initialize))

;;; smartparens（auto-pairs） -------------------------------------------

(use-package smartparens
  :ensure t
  :init
  (smartparens-global-mode 1)
  :config
  (require 'smartparens-config)
  (sp-with-modes 'emacs-lisp-mode
    (sp-local-pair "'" nil :actions nil))
  (sp-with-modes '(markdown-mode gfm-mode)
    (sp-local-pair "**" "**")
    (sp-local-pair "$" "$")
    (sp-local-pair "_" "_")
    (sp-local-pair "==" "==")
    (sp-local-pair "/*" "*/")))

;;; rainbow-delimiters --------------------------------------------------

(use-package rainbow-delimiters
  :ensure t
  :hook ((prog-mode emacs-lisp-mode markdown-mode) . rainbow-delimiters-mode)
  :config
  (let ((colors '("#FF5F5F" "#87D700" "#00AFFF"
                  "#D787FF" "#FFAF00" "#00FFD7"
                  "#FFFF00" "#AF5FFF" "#FF87D7")))
    (dotimes (i 9)
      (let ((face (intern (format "rainbow-delimiters-depth-%d-face" (1+ i))))
            (color (nth i colors)))
        (set-face-attribute face nil :foreground color :weight 'bold))))
  (set-face-attribute 'rainbow-delimiters-unmatched-face nil
                      :foreground "white" :background "#FF0000" :weight 'bold))

;;; vim-visual-multi -> evil-multiedit ----------------------------------

(use-package evil-multiedit
  :ensure t
  :after evil
  :config
  ;; Vim: C-n 启动多光标并选中下一个。
  (evil-define-key* '(normal visual) 'global
    (kbd "C-n") #'evil-multiedit-match-symbol-and-next)

  (evil-define-key* 'visual 'global
    "R"           #'evil-multiedit-match-all
    (kbd "M-d")   #'evil-multiedit-match-and-next
    (kbd "M-D")   #'evil-multiedit-match-and-prev
    (kbd "C-M-d") #'evil-multiedit-restore)

  (evil-define-key* '(normal insert) 'global
    (kbd "M-d") #'evil-multiedit-match-symbol-and-next
    (kbd "M-D") #'evil-multiedit-match-symbol-and-prev)

  (evil-define-key* 'insert 'global
    (kbd "C-M-d") #'evil-multiedit-toggle-marker-here)

  (evil-ex-define-cmd "ie[dit]" #'evil-multiedit-ex-match))

(provide 'conf.d/editing)
;;; conf.d/editing.el ends here
