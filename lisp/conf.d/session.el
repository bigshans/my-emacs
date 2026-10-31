;;; conf.d/session.el --- 会话、项目 -*- lexical-binding: t; -*-
;;
;; 对应 Vim 的 vim-session / vim-project。
;; 注意：Vim 的 <leader>p 管 project + session，这里沿用同一语义；
;; 切换会话从旧的 SPC op 改为 SPC po，把 SPC op 留给「打开插件配置」。

(use-package easysession
  :ensure t
  :demand t
  :custom
  (easysession-switch-to-save-session t)
  (easysession-switch-to-exclude-current nil)
  (easysession-save-mode-lighter-show-session-name t)
  :config
  (global-set-key (kbd "C-c sl") #'easysession-switch-to)
  (global-set-key (kbd "C-c ss") #'easysession-save)
  (global-set-key (kbd "C-c sL") #'easysession-switch-to-and-restore-geometry)
  (global-set-key (kbd "C-c sr") #'easysession-rename)
  (global-set-key (kbd "C-c sR") #'easysession-reset)
  (global-set-key (kbd "C-c su") #'easysession-unload)
  (global-set-key (kbd "C-c sd") #'easysession-delete)

  (my-leader-def
    "p" '(:ignore t :which-key "project/session")
    "ps" '(easysession-save :which-key "save session")
    "po" '(easysession-switch-to :which-key "open session")
    "pr" '(easysession-rename :which-key "rename session")
    "pd" '(easysession-delete :which-key "delete session")
    "pc" '(easysession-unload :which-key "close session")
    "sp" '(project-switch-project :which-key "switch project")
    "pa" '(my/remember-current-project :which-key "add current project"))

  (setq easysession-setup-load-session nil))

;; projectile 保持停用，使用内置 project.el。
(use-package projectile
  :ensure t
  :disabled t
  :init (projectile-mode +1))

(provide 'conf.d/session)
;;; conf.d/session.el ends here
