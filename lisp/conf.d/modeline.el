;;; conf.d/modeline.el --- Doom modeline -*- lexical-binding: t; -*-
;;
;; 对应 Vim 的 airline。默认布局信息太少，这里自定义为：
;;   左：evil 状态 / 文件 / 行:列 / 搜索计数 / 字数
;;   右：项目 / Git / LSP / 诊断 / 编译 / 文件大小 / 编码 / 缩进 / 模式 / 时间

(use-package doom-modeline
  :ensure t
  :config
  (setq doom-modeline-height 24
        doom-modeline-window-width-limit 70
        doom-modeline-bar-width 3
        doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-major-mode-color-icon t
        doom-modeline-buffer-state-icon t
        doom-modeline-buffer-modification-icon t
        doom-modeline-lsp-icon t
        doom-modeline-vcs-icon t
        doom-modeline-check-icon t
        doom-modeline-buffer-file-name-style 'relative-to-project
        doom-modeline-minor-modes nil
        doom-modeline-enable-word-count t
        doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode)
        doom-modeline-buffer-encoding t
        doom-modeline-default-coding-system 'utf-8
        doom-modeline-enable-buffer-position t
        doom-modeline-indent-info t
        doom-modeline-column-zero-based nil
        doom-modeline-total-line-number t
        doom-modeline-github nil
        doom-modeline-battery nil
        doom-modeline-time-icon t
        doom-modeline-time-live-icon t
        doom-modeline-project-name t)

  (setq display-time-24hr-format t
        display-time-default-load-average nil)
  (size-indication-mode 1)
  (display-time-mode 1)

  ;; Evil 状态用文字显示，比单纯图标更明确。
  (doom-modeline-def-segment my-evil-state
    (when (bound-and-true-p evil-local-mode)
      (let* ((state (symbol-name evil-state))
             (face (intern (format "doom-modeline-evil-%s-state" state))))
        (propertize (format " %s " (upcase state))
                    'face (doom-modeline-face
                           (if (facep face) face 'doom-modeline))
                    'help-echo (format "Evil state: %s" state)))))

  ;; 更紧凑、更有信息量的布局。
  (doom-modeline-def-modeline 'main
    '(bar my-evil-state matches buffer-info remote-host
          buffer-position word-count selection-info)
    '(project-name vcs lsp check compilation
      buffer-encoding indent-info major-mode process time))

  ;; Dashboard 也有自己的 modeline，不要用包默认的极简版。
  (doom-modeline-def-modeline 'dashboard
    '(bar my-evil-state buffer-default-directory-simple remote-host)
    '(project-name vcs lsp check compilation
      buffer-encoding major-mode process time))

  (doom-modeline-mode 1)

  ;; 确保 Dashboard buffer 使用上面的 dashboard 布局。
  (add-hook 'dashboard-mode-hook
            (lambda () (doom-modeline-set-modeline 'dashboard))))

(provide 'conf.d/modeline)
;;; conf.d/modeline.el ends here
