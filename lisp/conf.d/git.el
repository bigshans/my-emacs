;;; conf.d/git.el --- Git -*- lexical-binding: t; -*-
;;
;; 对应 Vim 的 vim-fugitive。键位保持 <leader>g* 语义。

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  :init
  (my-leader-def
    "g" '(:ignore t :which-key "git")
    "ga" '(magit-stage-modified :which-key "git add all")
    "gb" '(magit-blame :which-key "git blame")
    "gc" '(magit-commit :which-key "git commit")
    "gd" '(magit-diff :which-key "git diff")
    "gr" '(magit-discard-file :which-key "git restore file")
    "gg" '(magit-status :which-key "git status")
    "gps" '(magit-push :which-key "git push")
    "gpl" '(magit-pull :which-key "git pull")
    "gx" '(diff-hl-mode :which-key "toggle diff highlight")
    "gw" '(magit-save-repository-buffers :which-key "git write")))

;; Vim: GitGutter，用 diff-hl 代替。
(use-package diff-hl
  :ensure t
  :defer 1
  :config
  (global-diff-hl-mode 1)
  (diff-hl-flydiff-mode 1))

(provide 'conf.d/git)
;;; conf.d/git.el ends here
