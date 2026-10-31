;;; conf.d/org.el --- Org mode -*- lexical-binding: t; -*-
;;
;; Org 基础设置 + org-modern（现代外观）+ org-appear（光标处显示标记）。

(use-package org
  :ensure nil
  :hook ((org-mode . visual-line-mode)
         (org-mode . org-indent-mode))
  :custom
  (org-startup-indented t)
  (org-hide-leading-stars t)
  (org-startup-folded 'content)
  (org-log-done 'time)
  (org-adapt-indentation nil)
  (org-return-follows-link t)
  (org-use-speed-commands t)
  (org-catch-invisible-edits 'show)
  (org-ellipsis " ▾")
  (org-src-preserve-indentation t)
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-confirm-babel-evaluate nil)
  (org-image-actual-width nil)
  (org-pretty-entities t)
  (org-export-backends '(html latex md))
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t)
     (C . t)
     (js . t)
     (latex . t)))
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("sh" . "src shell")))

(use-package org-modern
  :ensure t
  :hook (org-mode . org-modern-mode)
  :custom
  (org-modern-star 'replace)
  (org-modern-table t)
  (org-modern-list '((43 . "•") (45 . "–") (42 . "∗")))
  (org-modern-todo t)
  (org-modern-tag t)
  (org-modern-priority t)
  (org-modern-block-name t))

(use-package org-appear
  :ensure t
  :hook (org-mode . org-appear-mode)
  :custom
  (org-appear-autoemphasis t)
  (org-appear-autolinks t)
  (org-appear-autosubmarkers t)
  (org-appear-autoentities t)
  (org-appear-autokeywords t))

(provide 'conf.d/org)
;;; conf.d/org.el ends here
