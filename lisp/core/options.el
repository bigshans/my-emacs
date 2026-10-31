;;; core/options.el --- 基础选项、字体与行为 -*- lexical-binding: t; -*-
;;
;; 对应 ~/.vim/core/options.vim。

;;; 路径与目录 ----------------------------------------------------------

;; 独立的 custom.el，保持 init.el 干净（custom-file 已在 early-init 设置）。
(when (file-exists-p custom-file)
  (load custom-file))

;; 创建 undo 缓存文件夹。
(let ((undo-dir (expand-file-name "var/undo-history" user-emacs-directory)))
  (unless (file-exists-p undo-dir)
    (make-directory undo-dir t)))

;; 自定义代码目录。
(add-to-list 'load-path (expand-file-name "lib" user-emacs-directory))
(require 'stuff)

;;; 界面 ----------------------------------------------------------------

(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq column-number-mode t)
(global-display-line-numbers-mode t)

;;; 字体 ----------------------------------------------------------------

(defun set-font (english chinese size-decipoints)
  "SIZE-DECIPOINTS 为十分之一点，例如 125 代表 12.5pt。"
  (set-face-attribute 'default nil
                      :family english
                      :height size-decipoints)
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font t charset (font-spec :family chinese)))
  (setq face-font-rescale-alist `((,chinese . 1.08))))

(set-font "JetBrainsMono Nerd Font" "lxgw wenkai mono" 130)

(setq-default line-spacing 0.15)
(setq inhibit-compacting-font-caches t)

;;; 行为优化 ------------------------------------------------------------

(setq native-comp-async-report-warnings-errors 'silent)
(setq ring-bell-function 'ignore)
(setq confirm-kill-emacs #'yes-or-no-p)

;; 对应 Vim 的 y/n 确认。
(setq use-short-answers t)

;;; 对齐 Vim options.vim -----------------------------------------------

(setq-default tab-width 4
              indent-tabs-mode nil      ; expandtab
              fill-column 120           ; colorcolumn=120
              truncate-lines nil)       ; wrap

(global-hl-line-mode 1)                 ; cursorline
(show-paren-mode 1)                     ; matchup 的一半
(delete-selection-mode 1)
(electric-pair-mode 1)                  ; auto-pairs
(blink-cursor-mode -1)

;; Vim: set nobackup / noswapfile / writebackup
(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil
      version-control 'never)

;; 滚动与导航手感。
(setq scroll-conservatively 101
      scroll-margin 0
      mouse-wheel-progressive-speed nil)

;; 与 Vim 的 backspace=indent,eol,start 对齐。
(setq backward-delete-char-untabify-method 'hungry)

;; 常用现代默认值。
(setq sentence-end-double-space nil
      kill-ring-max 200
      mark-ring-max 64)

(provide 'core/options)
;;; core/options.el ends here
