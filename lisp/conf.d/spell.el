;;; conf.d/spell.el --- 拼写检查 -*- lexical-binding: t; -*-
;;
;; 对应 Vim 的 spelllang=en,cjk。Vim 默认 nospell，这里也保持关闭，
;; 用 <leader>ts 手动切换当前 buffer。jinx 延迟到第一次使用时加载。

(defun my/toggle-spell ()
  "切换当前 buffer 的拼写检查。"
  (interactive)
  (if (bound-and-true-p jinx-mode)
      (jinx-mode -1)
    (jinx-mode 1)))

(use-package jinx
  :ensure t
  :defer t
  :commands (jinx-mode)
  :config
  (setq jinx-languages "en_US"))

(my-leader-def
  "ts" '(my/toggle-spell :which-key "toggle spell"))

(provide 'conf.d/spell)
;;; conf.d/spell.el ends here
