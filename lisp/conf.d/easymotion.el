;;; conf.d/easymotion.el --- 类似 vim-easymotion 的跳转 -*- lexical-binding: t; -*-
;;
;; 对应 Vim 的 <leader>e* 组。evil-easymotion 延迟到第一次使用时加载。

(use-package evil-easymotion
  :ensure t
  :defer t
  :commands (evilem-motion-find-char
             evilem-motion-find-char-backward
             evilem-motion-forward-word-begin
             evilem-motion-backward-word-begin
             evilem-motion-next-line
             evilem-motion-previous-line))

(my-leader-def
  "e" '(:ignore t :which-key "easymotion")
  "ef" '(evilem-motion-find-char :which-key "jump to char")
  "eF" '(evilem-motion-find-char-backward :which-key "jump to char backward")
  "ew" '(evilem-motion-forward-word-begin :which-key "jump to word")
  "eb" '(evilem-motion-backward-word-begin :which-key "jump to word backward")
  "ej" '(evilem-motion-next-line :which-key "jump to line")
  "ek" '(evilem-motion-previous-line :which-key "jump to line backward"))

(provide 'conf.d/easymotion)
;;; conf.d/easymotion.el ends here
