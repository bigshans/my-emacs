;;; conf.d/modeline.el --- Doom modeline -*- lexical-binding: t; -*-
;;
;; 对应 Vim 的 airline，配色由 inkstone-canghai 主题提供。

(use-package doom-modeline
  :ensure t
  :config
  (setq doom-modeline-height 26
        doom-modeline-bar-width 4
        doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-major-mode-color-icon t
        doom-modeline-buffer-state-icon t
        doom-modeline-buffer-modification-icon t
        doom-modeline-lsp-icon t
        doom-modeline-vcs-icon t
        doom-modeline-check-icon t
        doom-modeline-buffer-file-name-style 'relative-from-project
        doom-modeline-minor-modes nil
        doom-modeline-enable-word-count t
        doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode)
        doom-modeline-buffer-encoding nil
        doom-modeline-unicode-fallback t
        doom-modeline-github nil
        doom-modeline-battery nil)
  (doom-modeline-mode 1))

(provide 'conf.d/modeline)
;;; conf.d/modeline.el ends here
