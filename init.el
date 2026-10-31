;;; init.el --- Emacs 配置入口 -*- lexical-binding: t; -*-
;;
;; 结构对齐 ~/.vim：
;;   _vimrc          -> early-init.el + init.el
;;   core/*.vim      -> lisp/core/*.el
;;   core/conf.d/*   -> lisp/conf.d/*.el
;;   bundle/         -> var/elpa/
;;
;; init.el 只负责按顺序加载，具体配置都在 lisp/ 下。

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; core：基础设施（对应 _vimrc 里 call s:load 的顺序）
(require 'core/options)
(require 'core/packages)
(require 'core/builtin)
(require 'core/theme)
(require 'conf.d/evil)
(require 'core/keymaps)

;; conf.d：一个功能一个文件
(require 'conf.d/editing)
(require 'conf.d/completion)
(require 'conf.d/markdown)
(require 'conf.d/dired)
(require 'conf.d/git)
(require 'conf.d/session)
(require 'conf.d/easymotion)
(require 'conf.d/terminal)
(require 'conf.d/format)
;; (require 'conf.d/spell)   ; 暂时不需要拼写检查
(require 'conf.d/eglot)

;; 最后加载：把 Vim 的键位语义补齐
(require 'conf.d/vim-parity)

;;; init.el ends here
