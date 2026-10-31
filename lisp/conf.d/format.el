;;; conf.d/format.el --- 代码格式化 -*- lexical-binding: t; -*-
;;
;; 对应 Vim 的 vim-autoformat。Vim 里是手动 ;=，这里保持一致；
;; 不默认开启 apheleia-global-mode（保存时自动格式化）。
;; apheleia 延迟到第一次按 ;= 时加载。

(use-package apheleia
  :ensure t
  :defer t
  :commands (apheleia-format-buffer))

(general-define-key
  :states '(normal visual motion)
  :keymaps 'override
  ";=" #'apheleia-format-buffer)

(provide 'conf.d/format)
;;; conf.d/format.el ends here
