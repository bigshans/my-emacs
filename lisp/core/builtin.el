;;; core/builtin.el --- 内置功能配置 -*- lexical-binding: t; -*-
;;
;; 对应 ~/.vim/core/builtin.vim 中「不依赖插件」的部分。

;;; recentf -------------------------------------------------------------

(use-package recentf
  :ensure nil
  :hook (after-init . recentf-mode)
  :config
  (setq recentf-max-saved-items 200
        recentf-exclude '("/tmp/" "/ssh:" "/var/folders/"
                          ".*-autoloads\\.el\\" ".*\\.gz\\")
        recentf-auto-cleanup 'never)
  (run-at-time nil 300 'recentf-save-list))

;;; outline -------------------------------------------------------------

(require 'simple-outshine)

(use-package outline
  :ensure nil
  :hook (emacs-lisp-mode . my-outline/setup-elisp))

;;; 杂项 ---------------------------------------------------------------

(save-place-mode 1)

(provide 'core/builtin)
;;; core/builtin.el ends here
