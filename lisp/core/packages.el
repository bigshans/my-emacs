;;; core/packages.el --- 包管理与目录规范 -*- lexical-binding: t; -*-
;;
;; 对应 ~/.vim/core/plugins.vim 的角色。这里只负责初始化 package.el
;; 和 use-package；具体插件在 conf.d 中声明。

(require 'package)

;; 清华源
(setq package-archives '(("gnu"          . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu"       . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa"        . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
                         ("stable-melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/stable-melpa/")))

(package-initialize)

;; 自动安装并启用 use-package。
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; 规范目录结构，保持 ~/.emacs.d 整洁。
(use-package no-littering
  :config
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  (setq backup-directory-alist
        `(("." . ,(no-littering-expand-var-file-name "backups/")))))

(provide 'core/packages)
;;; core/packages.el ends here
