;;; early-init.el --- 启动最早期设置 -*- lexical-binding: t; -*-
;;
;; 对应 ~/.vim/_vimrc 的头部。这里的东西必须在 init.el 之前生效：
;; GC、包目录、native-comp 缓存、界面开关。

(defvar file-name-handler-alist-original file-name-handler-alist)
(defvar my/gc-cons-threshold 100000000)

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      file-name-handler-alist nil
      site-run-file nil
      inhibit-startup-screen t
      inhibit-startup-message t
      package-user-dir (expand-file-name "var/elpa" user-emacs-directory)
      custom-file (expand-file-name "custom.el" user-emacs-directory)
      native-comp-async-report-warnings-errors 'silent)

;; 启动完成后恢复 GC 和 file-name-handler-alist（否则 TRAMP/压缩包会失效）。
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold my/gc-cons-threshold
                  gc-cons-percentage 0.1
                  file-name-handler-alist file-name-handler-alist-original)))

;; 将 native-comp 缓存放入 var/eln-cache。
(when (boundp 'native-comp-eln-load-path)
  (setq native-comp-eln-load-path
        (list (expand-file-name "var/eln-cache/" user-emacs-directory))))

;; 关闭菜单栏、工具栏、滚动条（GUI 下有效）。
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(provide 'early-init)
;;; early-init.el ends here
