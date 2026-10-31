;;; core/keymaps.el --- leader 键基础设施与基础键位 -*- lexical-binding: t; -*-
;;
;; 对应 ~/.vim/core/builtin.vim 的 leader 部分。
;; 其它 conf.d 文件会继续往 my-leader-def 里追加键位。

(use-package general
  :ensure t
  :after evil
  :init
  (setq general-override-states '(insert
                                  emacs
                                  hybrid
                                  visual
                                  motion
                                  operator
                                  replace))
  :config
  (general-evil-setup)
  (general-auto-unbind-keys)

  (general-create-definer my-leader-def
    :states '(normal visual motion)
    :keymaps 'override
    :prefix "SPC"
    :no-normal-prefix "C-SPC")

  (my-leader-def
    ;; 基础操作
    "q" '(my-stuff/smart-quit :which-key "close buffer / quit")
    "Q" '(kill-emacs :which-key "quit emacs")

    ;; 注释
    "c" '(:ignore t :which-key "comment")
    "ci" '(evilnc-comment-or-uncomment-lines :which-key "toggle comment")

    ;; 打开
    "o" '(:ignore t :which-key "open")
    "oi" '(my-stuff/open-init-file :which-key "open init.el")
    "op" '(my-stuff/open-init-file :which-key "open plugins/init")
    "oc" '(my-stuff/open-config-dir :which-key "open config dir")
    "oC" '(lambda () (interactive) (find-file custom-file)
          :which-key "open custom.el")

    ;; 文件
    "f" '(:ignore t :which-key "files")
    "fs" '(save-buffer :which-key "save file")
    "fS" '(my/sudo-save-buffer :which-key "save as root")))

;;; 与 Vim 对齐的零散键位 ------------------------------------------------

;; <C-s> 保存。
(global-set-key (kbd "C-s") #'save-buffer)

;; Vim: noremap j gj / k gk（已在 evil 中设置，这里不重复）。

;; 退出 minibuffer。
(define-key minibuffer-local-map [escape] #'abort-recursive-edit)
(define-key minibuffer-local-map (kbd "ESC") #'abort-recursive-edit)
(global-set-key (kbd "<escape>") #'keyboard-quit)

;; 让 which-key 对 leader 组显示更清晰的标签。
(with-eval-after-load 'which-key
  ;; 各分组已经有 :which-key 标签，这里只补 SPC 本身和数字键。
  (which-key-add-key-based-replacements "SPC" "leader")
  (dotimes (i 9)
    (let ((n (1+ i)))
      (which-key-add-key-based-replacements
        (format "SPC w%d" n) (format "window %d" n)
        (format "SPC b%d" n) (format "buffer %d" n)))))

(provide 'core/keymaps)
;;; core/keymaps.el ends here
