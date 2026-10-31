;;; conf.d/eglot.el --- LSP（替代 coc.nvim） -*- lexical-binding: t; -*-
;;
;; Emacs 31 内置 eglot + flymake + xref + eldoc，不需要额外装 LSP 客户端。
;; 键位对齐 Vim 的 coc.nvim 配置。
;;
;; 不在启动时 require eglot：键位放在 :init，服务器等打开编程 buffer
;; 触发 prog-mode-hook 时再懒加载。

;; K 在 GUI 下用 eldoc-box 的 childframe 浮窗显示文档；
;; 终端下退回 echo area 的 eldoc。
(defun my/show-doc-at-point ()
  "显示光标处符号的文档。GUI 下用 childframe 浮窗，终端下用 echo area。"
  (interactive)
  (if (display-graphic-p)
      (progn
        ;; 先让 eldoc 生成当前符号的文档，再交给 eldoc-box 显示浮窗。
        (eldoc-print-current-symbol-info)
        (condition-case err
            (eldoc-box-help-at-point)
          (error (message "没有可显示的文档：%s" (error-message-string err)))))
    (eldoc-print-current-symbol-info)))

(use-package eldoc-box
  :ensure t
  :defer t
  :commands (eldoc-box-help-at-point)
  :custom
  (eldoc-box-max-pixel-width 800)
  (eldoc-box-max-pixel-height 700))

(use-package eglot
  :ensure nil
  :hook (prog-mode . eglot-ensure)
  :init
  ;; coc: gd / gy / gi / gr / K / [g / ]g
  (evil-define-key '(normal visual motion) 'global
    (kbd "gd") #'xref-find-definitions
    (kbd "gy") #'eglot-find-typeDefinition
    (kbd "gi") #'eglot-find-implementation
    (kbd "gr") #'xref-find-references
    (kbd "K")  #'my/show-doc-at-point
    (kbd "[g") #'flymake-goto-prev-error
    (kbd "]g") #'flymake-goto-next-error)

  ;; coc: <leader>j* 组
  (my-leader-def
    "j" '(:ignore t :which-key "lsp")
    "ja" '(eglot-code-actions :which-key "code action")
    "jc" '(flymake-show-diagnostic :which-key "diagnostic at point")
    "jd" '(consult-flymake :which-key "diagnostics list")
    "jf" '(eglot-code-action-quickfix :which-key "fix current")
    "jF" '(eglot-code-action-organize-imports :which-key "organize imports")
    "jr" '(eglot-rename :which-key "rename symbol")
    "je" '(eglot-code-actions :which-key "refactor")
    "jl" '(eglot-code-actions :which-key "code lens")
    "jk" '(my/show-doc-at-point :which-key "show documentation (float)")
    "jo" '(consult-imenu :which-key "outline")
    "jD" '(flymake-mode :which-key "toggle diagnostics")
    "j=" '(eglot-format-buffer :which-key "format buffer")
    "jR" '(eglot-reconnect :which-key "reconnect server")
    "js" '(consult-eglot-symbols :which-key "workspace symbols")
    "jS" '(eglot-shutdown :which-key "shutdown server"))
  :config
  (setq eglot-autoshutdown t
        eglot-events-buffer-size 0
        eglot-sync-connect 1
        eglot-connect-timeout 30))

(provide 'conf.d/eglot)
;;; conf.d/eglot.el ends here
