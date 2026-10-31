;;; stuff.el --- 自定义工具函数 -*- lexical-binding: t; -*-

(defun my-stuff/open-init-file ()
  "打开配置文件 init.el"
  (interactive)
  (find-file user-init-file))

(defun my-stuff/open-config-dir ()
  "快速打开 Emacs 配置目录。"
  (interactive)
  (dired user-emacs-directory))

(defun my-stuff/markdown-toggle-view-logic ()
  "根据只读状态动态调整 Markdown 的视觉呈现"
  (if buffer-read-only
      (progn
	;; 只读模式：进入预览效果
	(markdown-view-mode)
	(math-preview-all)
	)
    (progn
      ;; 编辑模式：恢复源码显示
      (markdown-mode)
      (math-preview-clear-all)
      ))
  ;; 必须调用这个函数来强制让隐藏标记的设置立即生效
  (font-lock-flush))

(defun my-stuff/neotree-smart-enter ()
  "如果是目录，设置为根节点；如果是文件，直接打开。"
  (interactive)
  (let ((full-path (neo-buffer--get-filename-current-line)))
    (if (and full-path (file-directory-p full-path))
	(neotree-change-root)
      (neotree-enter))))

(defun my-stuff/listed-buffer-p (buffer)
  "BUFFER 是否算作 Vim 意义上的 listed buffer。
排除隐藏 buffer、Dashboard、Messages、补全/帮助等内部 buffer。"
  (and (buffer-live-p buffer)
       (with-current-buffer buffer
         (let ((name (buffer-name)))
           (and (not (string-prefix-p " " name))
                (not (memq major-mode '(dashboard-mode
                                        messages-buffer-mode
                                        completion-list-mode
                                        help-mode
                                        profiler-report-mode))))))))

(defun my-stuff/listed-buffer-count ()
  "返回当前 listed buffer 的数量。"
  (length (seq-filter #'my-stuff/listed-buffer-p (buffer-list))))

(defun my-stuff/force-kill-current-buffer ()
  "强制删除当前 buffer，对应 Vim 的 :bdelete!。
如果当前窗口不是唯一窗口，也会像 Vim 一样关闭该窗口。"
  (let ((buffer (current-buffer)))
    (when (> (length (window-list)) 1)
      (delete-window))
    (when (buffer-live-p buffer)
      (with-current-buffer buffer
        (set-buffer-modified-p nil))
      (let ((kill-buffer-query-functions nil))
        (kill-buffer buffer)))))

(defun my-stuff/smart-quit ()
  "对应 Vim 的 utils#quit。
有多个 listed buffer 时强制删除当前 buffer；
否则关闭当前窗口，已经是最后一个窗口时退出 Emacs。"
  (interactive)
  (if (> (my-stuff/listed-buffer-count) 1)
      (my-stuff/force-kill-current-buffer)
    (if (one-window-p)
        (kill-emacs)
      (delete-window))))

(defun my-stuff/neotree-go-up-and-refresh ()
  "直接利用 neo-buffer--start-node 向上跳转。"
  (interactive)
  ;; 确保变量已定义且不为空
  (if (and (boundp 'neo-buffer--start-node) neo-buffer--start-node)
      (let* ((current-root (expand-file-name neo-buffer--start-node))
             ;; 获取父目录：剥离末尾斜杠 -> 取目录
             (parent-dir (file-name-directory (directory-file-name current-root))))
        (if (and parent-dir (file-directory-p parent-dir)
                 ;; 避免在根目录（如 / ）循环
                 (not (string= current-root parent-dir)))
            (neotree-dir parent-dir)
          (message "已经到达系统根目录")))
    (message "错误：无法获取 neo-buffer--start-node")))

(defun my-stuff/dirvish-l-action ()
  "智能 l：文件夹则展开/折叠子树，文件则打开。"
  (interactive)
  (let ((filename (dired-get-filename nil t)))
    (when filename
      (if (file-directory-p filename)
	  (dirvish-subtree-toggle)
	(dired-find-file)))))

(defun my-stuff/dirvish-find-file-other-tab ()
  "在文件树中把光标所在条目在新 tab 中打开。"
  (interactive)
  (find-file-other-tab (dired-get-file-for-visit)))

(defun my-stuff/dirvish-h-action ()
  "智能 h：如果是已展开的子树，则折叠它。"
  (interactive)
  (when (and (file-directory-p (dired-get-filename nil t))
             (dirvish-subtree--expanded-p))
    (dirvish-subtree-toggle)))

(defun my/get-easysession-list ()
  "从 easysession-directory 获取 session 文件名列表。"
  (let ((dir (expand-file-name (or (bound-and-true-p easysession-directory) 
                                  "~/.emacs.d/.easysessions/"))))
    (if (file-directory-p dir)
        (directory-files dir nil "^[^.]")
      nil)))

(defun my-stuff/dashboard-insert-easysessions (list-size)
  "完全适配提供的宏定义的 session 列表生成器。"
  (let ((sessions (my/get-easysession-list))) ; 获取 session 列表的函数保持不变
    (dashboard-insert-section
     "Sessions"                    ; section-name
     sessions                      ; list
     list-size                     ; list-size
     'my-easysession               ; shortcut-id
     "s"                            ; shortcut-char (标题旁会显示 [s])
     `(lambda (&rest _)            ; action: 点击时的执行逻辑
        (easysession-load ,el))
     ;; 以下是 widget-params: 
     ;; 根据 dashboard 惯例，这里通常直接传入显示在界面的字符串
     (format "%s" el))))           ; 这里的 el 会被宏内部的循环正确解析

;; 定义点击列表项后的动作
(defun dashboard-action-my-easysession (session)
  "点击 Dashboard 中的 session 时调用 easysession-load。"
  (message "正在加载 Session: %s" session)
  (easysession-load session)) ; 👈 调用 easysession 的加载命令

(provide 'stuff)
