;;; conf.d/dired.el --- 文件树 -*- lexical-binding: t; -*-
;;
;; 对应 Vim 的 vim-dir / coc-explorer。

(use-package nerd-icons :ensure t)

(use-package dired
  :ensure nil
  :init
  (setenv "LC_ALL" "C")
  :config
  (setq dired-listing-switches
        "-l -A --human-readable --group-directories-first --no-group ")
  (add-hook 'dired-mode-hook #'dired-hide-details-mode)
  (add-hook 'dired-mode-hook #'dired-omit-mode))

(require 'dired-x)
(setq dired-omit-files "^\\.\\|^\\.\\.$")
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))

(use-package dirvish
  :ensure t
  :defer t
  :commands (dirvish-side dirvish-override-dired-mode)
  :hook (dired-mode . dirvish-override-dired-mode)
  :init
  (setenv "LC_ALL" "C")
  (set-selection-coding-system 'utf-8)
  (set-next-selection-coding-system 'utf-8)
  (setq-default process-coding-system '((utf-8 . utf-8)))
  :config
  (setq dirvish-side-width 25)
  (setq dirvish-side-header-line-format nil)
  (setq dirvish-side-mode-line-format nil)
  (setq dirvish-side-attributes '(vc-state nerd-icons collapse))

  (with-eval-after-load 'evil
    (evil-define-key 'normal 'global (kbd "\\") #'dirvish-side)
    (evil-define-key 'normal dirvish-mode-map
      (kbd "h") #'my-stuff/dirvish-h-action
      (kbd "l") #'my-stuff/dirvish-l-action
      (kbd "j") #'evil-next-line
      (kbd "k") #'evil-previous-line
      (kbd "TAB") #'dirvish-subtree-toggle
      (kbd "<backspace>") #'dired-up-directory
      (kbd ".") #'dired-omit-mode
      (kbd "s") (lambda () (interactive)
                  (dirvish-ls-switches-modify "-X" 'toggle)
                  (dirvish-revert))
      (kbd "<") #'dirvish-side-decrease-width
      (kbd ">") #'dirvish-side-increase-width
      (kbd "e") #'dired-find-file-other-window
      (kbd "E") (lambda () (interactive)
                  (let ((split-width-threshold 0)
                        (split-height-threshold nil))
                    (dired-find-file-other-window)))
      (kbd "q") #'dirvish-quit
      (kbd "R") #'dired-do-rename
      (kbd "?") #'dirvish-dispatch))

  (dirvish-side-follow-mode 1))

;; Vim: <leader>ft 文件树。
(my-leader-def
  "ft" '(dirvish-side :which-key "file tree"))

(provide 'conf.d/dired)
;;; conf.d/dired.el ends here
