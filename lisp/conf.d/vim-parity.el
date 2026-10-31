;;; conf.d/vim-parity.el --- 与 ~/.vim 的键位对齐 -*- lexical-binding: t; -*-
;;
;; 对应 Vim 的 core/builtin.vim 以及各 conf.d 的 leader 组。
;; 这里只放「Vim 有、Emacs 还缺」的键位；不重复已经配置过的项。

;;; 辅助函数 ------------------------------------------------------------

(defun my/select-window-n (n)
  "选择第 N 个窗口。"
  (let ((wins (window-list)))
    (if (<= n (length wins))
        (select-window (nth (1- n) wins))
      (user-error "只有 %d 个窗口" (length wins)))))

(defun my/move-line-down (&optional n)
  "把当前行向下移动 N 行。"
  (interactive "p")
  (dotimes (_ (or n 1))
    (unless (save-excursion (forward-line 1) (eobp))
      (let ((line (buffer-substring-no-properties
                   (line-beginning-position) (line-end-position)))
            (col (current-column)))
        (delete-region (line-beginning-position) (line-beginning-position 2))
        (end-of-line)
        (insert "\n" line)
        (beginning-of-line)
        (move-to-column col)))))

(defun my/move-line-up (&optional n)
  "把当前行向上移动 N 行。"
  (interactive "p")
  (dotimes (_ (or n 1))
    (when (> (line-number-at-pos) 1)
      (let ((line (buffer-substring-no-properties
                   (line-beginning-position) (line-end-position)))
            (col (current-column)))
        (delete-region (line-beginning-position) (line-beginning-position 2))
        (forward-line -1)
        (insert line "\n")
        (forward-line -1)
        (move-to-column col)))))

(defun my/clear-search-highlight ()
  "清除搜索高亮，对应 Vim 的 <C-g>。"
  (interactive)
  (when (fboundp 'evil-ex-nohighlight)
    (evil-ex-nohighlight))
  (when isearch-mode
    (isearch-cancel))
  (message ""))

(defun my/sudo-save-buffer ()
  "以 root 权限保存当前文件，对应 Vim 的 sudo_save。"
  (interactive)
  (unless buffer-file-name
    (user-error "当前 buffer 没有关联文件"))
  (if (file-writable-p buffer-file-name)
      (save-buffer)
    (find-alternate-file (concat "/sudo::" buffer-file-name))))

(defun my/remember-current-project ()
  "把当前项目加入 project.el 的项目列表，对应 Vim 的 AddCurrentProject。"
  (interactive)
  (let ((project (project-current t)))
    (project-remember-project project)
    (message "已记住项目：%s" (project-root project))))

;;; 核心行为（builtin.vim） ---------------------------------------------

(evil-define-key '(normal visual motion) 'global
  (kbd "zh") #'windmove-left
  (kbd "zj") #'windmove-down
  (kbd "zk") #'windmove-up
  (kbd "zl") #'windmove-right
  (kbd "C-g") #'my/clear-search-highlight
  (kbd "M-j") #'my/move-line-down
  (kbd "M-k") #'my/move-line-up)

(evil-define-key 'insert 'global
  (kbd "C-j") #'windmove-down
  (kbd "C-k") #'windmove-up
  (kbd "M-j") #'my/move-line-down
  (kbd "M-k") #'my/move-line-up)

(evil-define-key 'visual 'global
  (kbd "M-j") #'my/move-line-down
  (kbd "M-k") #'my/move-line-up)

;; Vim: F10 切换 quickfix。
(global-set-key (kbd "<f10>") #'consult-flymake)

;;; 窗口与 buffer（airline / builtin.vim） ------------------------------

(my-leader-def
  "w" '(:ignore t :which-key "window")
  "wc" '(delete-window :which-key "close window")
  "ws" '(split-window-below :which-key "split horizontal")
  "wv" '(split-window-right :which-key "split vertical")

  "b" '(:ignore t :which-key "buffers")
  "bn" '(next-buffer :which-key "next buffer")
  "bp" '(previous-buffer :which-key "previous buffer")
  "bd" '(kill-current-buffer :which-key "kill buffer"))

;; Vim: <leader>w1..9 跳转窗口；<leader>b1..9 跳转 buffer/tab。
;; 用 general-define-key（函数）而不是 evil-define-key，
;; 让 general 负责把 SPC 从 evil 的 forward-char 变成前缀键。
(dotimes (i 9)
  (let ((n (1+ i)))
    (general-define-key
      :states '(normal visual motion)
      :keymaps 'override
      (format "SPC w%d" n)
      (lambda () (interactive) (my/select-window-n n)))
    (general-define-key
      :states '(normal visual motion)
      :keymaps 'override
      (format "SPC b%d" n)
      (lambda () (interactive) (tab-bar-select-tab n)))))

;; 用 tab-bar 模拟 airline 的 buffer/tab 切换。
(tab-bar-mode 1)
;; 新 tab 默认打开空 buffer，而不是复制当前 buffer。
(setq tab-bar-new-tab-choice "*scratch*")

;;; 搜索 / 终端 / 异步 / 包管理 ----------------------------------------

(my-leader-def
  "y" '(consult-yank-from-kill-ring :which-key "yank history")

  "P" '(:ignore t :which-key "packages")
  "Pi" '(package-install :which-key "install package")
  "Pu" '(package-upgrade-all :which-key "upgrade packages")
  "Pg" '(package-refresh-contents :which-key "refresh packages")

  "a" '(:ignore t :which-key "async")
  "ar" '(async-shell-command :which-key "async run command")
  "ad" '(kill-compilation :which-key "async stop")
  "af" '(project-compile :which-key "async project task"))

(provide 'conf.d/vim-parity)
;;; conf.d/vim-parity.el ends here
