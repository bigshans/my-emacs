;;; conf.d/terminal.el --- 终端 -*- lexical-binding: t; -*-
;;
;; 对应 Vim 的 vim-floaterm。使用纯 Elisp 的 eat，不需要编译 libvterm。
;; eat 延迟到第一次 <leader>t* 时再加载。

(defun my/eat-buffer-name ()
  (or (bound-and-true-p eat-buffer-name) "*eat*"))

(defun my/toggle-eat ()
  "切换 eat 终端窗口。"
  (interactive)
  (let ((buf (get-buffer (my/eat-buffer-name))))
    (if (and buf (get-buffer-window buf))
        (delete-window (get-buffer-window buf))
      (eat))))

(defun my/new-eat ()
  "新建一个 eat 会话。"
  (interactive)
  ;; 非数字前缀参数让 eat 创建新会话。
  (eat nil '(4)))

(defun my/kill-eat ()
  "关闭当前 eat 会话。"
  (interactive)
  (if (eq major-mode 'eat-mode)
      (kill-buffer)
    (when (get-buffer (my/eat-buffer-name))
      (kill-buffer (my/eat-buffer-name)))))

(use-package eat
  :ensure t
  :defer t
  :commands (eat))
(my-leader-def
  "t" '(:ignore t :which-key "terminal")
  "tt" '(my/toggle-eat :which-key "toggle terminal")
  "tn" '(my/new-eat :which-key "new terminal")
  "tk" '(my/kill-eat :which-key "kill terminal"))

(provide 'conf.d/terminal)
;;; conf.d/terminal.el ends here
