;;; conf.d/markdown.el --- Markdown 与沉浸式写作 -*- lexical-binding: t; -*-
;;
;; 对应 Vim 的 vim-markdown / goyo / pencil。

(use-package markdown-mode
  :ensure t
  :mode ("\\.md\\'" . gfm-mode)
  :custom
  (markdown-hide-markup nil)
  (markdown-hide-urls nil)
  (markdown-header-scaling t)
  (markdown-display-remote-images t)
  :hook
  (markdown-mode . (lambda ()
                     (setq line-spacing 0.3)
                     (visual-line-mode 1)))
  :config
  (add-hook 'markdown-mode-hook
            (lambda ()
              (add-hook 'read-only-mode-hook
                        #'my-stuff/markdown-toggle-view-logic nil t)))
  (custom-set-faces
   '(markdown-link-face ((t (:foreground "#83a598" :underline t))))
   '(markdown-italic-face ((t (:slant italic :foreground "#b48ead"))))))

(use-package outline
  :ensure nil
  :hook (markdown-mode . my-outline/setup-markdown))

;; 视觉对齐 Markdown 表格，不修改文件内容。
;; valign 只对图形界面生效；终端下用 M-x markdown-table-align 真正改源码。
(use-package valign
  :ensure t
  :hook ((markdown-mode gfm-mode) .
         (lambda ()
           (when (display-graphic-p)
             (valign-mode 1)))))



(use-package math-preview
  :ensure t
  :custom
  (math-preview-command "/home/aerian/.npm-packages/bin/math-preview")
  :hook (markdown-mode . math-preview-all))

(use-package olivetti
  :ensure t
  :hook (markdown-mode . olivetti-mode)
  :custom
  (olivetti-body-width 90))

(provide 'conf.d/markdown)
;;; conf.d/markdown.el ends here
