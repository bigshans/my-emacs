;;; conf.d/evil.el --- Evil 与 Vim 行为 -*- lexical-binding: t; -*-
;;
;; 对应 ~/.vim 中 evil/vim 核心行为：
;;   evil, sis(fcitx), which-key, evil-collection,
;;   evil-numbers, evil-surround, evil-simple-f, evil-nerd-commenter.

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-undo-system 'undo-fu)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1)

  (define-key evil-normal-state-map (kbd "j") #'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "k") #'evil-previous-visual-line)
  (define-key evil-visual-state-map (kbd "j") #'evil-next-visual-line)
  (define-key evil-visual-state-map (kbd "k") #'evil-previous-visual-line)

  ;; 强制大写 Y 复制到系统 (+ 寄存器)
  (evil-define-key '(normal visual) 'global (kbd "Y")
    (lambda () (interactive)
      (evil-use-register ?+)
      (call-interactively #'evil-yank)))

  ;; 强制大写 P 从系统粘贴 (+ 寄存器)
  (evil-define-key '(normal visual) 'global (kbd "P")
    (lambda () (interactive)
      (evil-use-register ?+)
      (call-interactively #'evil-paste-after)))

  (setq evil-disable-insert-state-bindings t)

  (defun my-evil-exit-hook ()
    (setq select-enable-clipboard (eq evil-state 'emacs)))
  (add-hook 'evil-state-change-hook #'my-evil-exit-hook)
  (my-evil-exit-hook))

;;; sis：fcitx 输入法切换 ------------------------------------------------

(use-package sis
  :ensure t
  :config
  (sis-ism-lazyman-config "1" "2" 'fcitx5)
  (sis-global-cursor-color-mode 1)
  (sis-global-respect-mode 1)
  (sis-global-context-mode 1)
  (setq sis-cursor-color-zh "#c08eaf"
        sis-cursor-color-en "#66a9c9"))

;;; which-key -----------------------------------------------------------

(use-package which-key
  :defer 1
  :init
  (setq which-key-idle-delay 0.3
        which-key-idle-secondary-delay 0.05
        which-key-prefix-prefix "+"
        which-key-separator " → "
        which-key-max-description-length 42
        which-key-add-column-padding 1
        which-key-sort-order #'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-show-early-on-C-h t)
  :config
  (which-key-mode 1)
  ;; 底部 side window，不遮挡当前编辑区域。
  (which-key-setup-side-window-bottom))

;;; evil-collection -----------------------------------------------------

(use-package evil-collection
  :after evil
  :ensure t
  :defer 1
  :config
  (evil-collection-init))

;;; evil-numbers --------------------------------------------------------

(use-package evil-numbers
  :ensure t
  :bind (("C-c C-=" . evil-numbers/inc-at-pt)
         ("C-c C--" . evil-numbers/dec-at-pt))
  :config
  (setq evil-numbers/pad-at-point t))

;;; evil-surround（vim-sandwich） ---------------------------------------

(use-package evil-surround
  :ensure t
  :config
  (setq-default evil-surround-pairs-alist
                '((?\( . ("(" . ")"))
                  (?\[ . ("[" . "]"))
                  (?\{ . ("{" . "}"))
                  (?\) . ("(" . ")"))
                  (?\] . ("[" . "]"))
                  (?\} . ("{" . "}"))))
  (define-key evil-normal-state-map (kbd "s") nil)
  (evil-define-key 'normal 'global
    (kbd "sa") #'evil-surround-edit
    (kbd "sd") #'evil-surround-delete
    (kbd "sr") #'evil-surround-change)
  (evil-define-key 'visual 'global (kbd "s") #'evil-surround-region))

;;; evil-simple-f（clever-f） -------------------------------------------

(use-package evil-simple-f
  :load-path "lib"
  :after evil
  :bind (:map evil-normal-state-map
              ("f" . evil-simple-f-jump)
              ("F" . evil-simple-f-jump)))

;;; evil-nerd-commenter（tcomment/nerdcommenter） -----------------------

(use-package evil-nerd-commenter
  :ensure t)

(provide 'conf.d/evil)
;;; conf.d/evil.el ends here
