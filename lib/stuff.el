(defun my-stuff/open-init-file ()
  "打开配置文件 init.el"
  (interactive)
  (find-file user-init-file))

(defun my-stuff/open-config-dir ()
  "快速打开 Emacs 配置目录。"
  (interactive)
  (dired user-emacs-directory))

(defun my-stuff/neotree-smart-enter ()
  "如果是目录，设置为根节点；如果是文件，直接打开。"
  (interactive)
  (let ((full-path (neo-buffer--get-filename-current-line)))
    (if (and full-path (file-directory-p full-path))
	(neotree-change-root)
      (neotree-enter))))

(defun my-stuff/smart-quit ()
  "如果是最后一个窗口则直接退出 Emacs，否则关闭当前窗口。"
  (interactive)
  (if (one-window-p)
      (kill-emacs)
    (delete-window)))

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

(defun my-stuff/dirvish-h-action ()
  "智能 h：如果是已展开的子树，则折叠它。"
  (interactive)
  (when (and (file-directory-p (dired-get-filename nil t))
             (dirvish-subtree--expanded-p))
    (dirvish-subtree-toggle)))

(provide 'stuff)
