;;; conf.d/completion.el --- 补全与搜索 -*- lexical-binding: t; -*-
;;
;; 对应 Vim 的 LeaderF/fzf/coc 补全部分：
;;   vertico + orderless + consult + corfu + yasnippet。

;;; vertico -------------------------------------------------------------

(use-package vertico
  :ensure t
  :init
  (vertico-mode 1)
  :config
  (setq vertico-cycle t))

(use-package savehist
  :ensure nil
  :init (savehist-mode 1))

(use-package orderless
  :ensure t
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))

;;; consult（LeaderF/fzf） ----------------------------------------------

(use-package consult
  :ensure t
  :after general
  :config
  (my-leader-def
    "s" '(:ignore t :which-key "search")
    "sb" '(consult-buffer :which-key "switch buffer")
    "sd" '(consult-find :which-key "find file")
    "sh" '(consult-info :which-key "search help")
    "sl" '(consult-line :which-key "search lines")
    "sr" '(consult-ripgrep :which-key "ripgrep")
    "ss" '(consult-line :which-key "search lines")
    "sy" '(consult-yank-from-kill-ring :which-key "yank history")
    "fr" '(consult-recent-file :which-key "recent files")
    "ff" '(consult-find :which-key "find file")))

;;; yasnippet -----------------------------------------------------------

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets :ensure t)

(use-package yasnippet-capf
  :ensure t
  :after (yasnippet corfu))

;;; kind-icon -----------------------------------------------------------

(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;;; corfu ---------------------------------------------------------------

(use-package corfu
  :ensure t
  :if (display-graphic-p)
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 1)
  (corfu-cycle t)
  :config
  (defun my/setup-corfu-backends ()
    (add-hook 'completion-at-point-functions #'yasnippet-capf 100 t))

  (add-hook 'prog-mode-hook #'my/setup-corfu-backends)
  (add-hook 'text-mode-hook
            (lambda ()
              (setq-local corfu-auto nil)
              (my/setup-corfu-backends)))

  (keymap-set corfu-map "TAB" #'corfu-next)
  (keymap-set corfu-map "<tab>" #'corfu-next)
  (keymap-set corfu-map "S-TAB" #'corfu-previous)
  (keymap-set corfu-map "<backtab>" #'corfu-previous)
  (keymap-set corfu-map "<escape>" #'corfu-quit)
  (keymap-set corfu-map "RET" #'corfu-insert)

  (require 'corfu-popupinfo)
  (corfu-popupinfo-mode 1)
  (setq corfu-popupinfo-delay 0.3)

  (setq corfu-buffer-parameters
        '((internal-border-width . 1)
          (vertical-scroll-bars . nil)
          (no-accept-focus . t)))

  ;; 自动展开 snippet。
  (advice-add 'corfu-insert :after
              (lambda (&rest _)
                (when (and (bound-and-true-p yas-minor-mode)
                           (looking-back yas-maybe-expand-abbrev-key-regexp
                                         (line-beginning-position)))
                  (yas-expand))))

  (with-eval-after-load 'evil
    (add-hook 'evil-insert-state-exit-hook #'corfu-quit)))

;;; marginalia ----------------------------------------------------------

(use-package marginalia
  :ensure t
  :defer t
  :commands (marginalia-mode)
  :init (add-hook 'minibuffer-setup-hook #'marginalia-mode))

;;; embark -------------------------------------------------------------

(use-package embark
  :ensure t
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim))
  :config
  (setq embark-quit-after-action nil))

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook (embark-collect-mode . embark-consult-export-hier))

;; Evil 的 C-. 默认是 evil-repeat-pop，这里覆盖成 embark-act。
;; 直接绑定符号即可，embark 是 autoload，不需要先加载。
(evil-define-key '(normal visual motion) 'global
  (kbd "C-.") #'embark-act
  (kbd "C-;") #'embark-dwim)

;;; cape ---------------------------------------------------------------

(use-package cape
  :ensure t
  :defer t
  :commands (cape-dabbrev cape-file)
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file))

(provide 'conf.d/completion)
;;; conf.d/completion.el ends here
