;; -- Emacs 个人配置 --

;; * 基础配置

;; ** 快速启动

(defvar file-name-handler-alist-original file-name-handler-alist)
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      file-name-handler-alist nil
      site-run-file nil)

(defvar my/gc-cons-threshold 100000000)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold my/gc-cons-threshold
                  gc-cons-percentage 0.1
                  file-name-handler-alist file-name-handler-alist-original)))

(add-hook 'minibuffer-setup-hook (lambda ()
                                   (setq gc-cons-threshold (* my/gc-cons-threshold 2))))
(add-hook 'minibuffer-exit-hook (lambda ()
                                  (garbage-collect)
                                  (setq gc-cons-threshold my/gc-cons-threshold)))
;; ** 路径与目录整理

;; 将包文件放入到 =~/.emacs.d/var=。

(setq package-user-dir (expand-file-name "var/elpa" user-emacs-directory))

;; 将包管理缓存放入到 =~/.emacs.d/var/eln-cache= 下。

(when (boundp 'native-comp-eln-load-path)
  (setq native-comp-eln-load-path
        (list (expand-file-name "var/eln-cache/" user-emacs-directory))))

;; 设置独立的 =custom.el=，保持 =init.el= 文件干净。如果 =custom.el= 存在，则加载 =custom.el= 。

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; 创建 undo 缓存文件夹。

(let ((undo-dir (expand-file-name "var/undo-history" user-emacs-directory)))
  (unless (file-exists-p undo-dir)
    (make-directory undo-dir t)))

;; 设置 `lib` ，放置自定义代码。

(add-to-list 'load-path (expand-file-name "lib" user-emacs-directory))

;; 加载工具函数。

(require 'stuff)

;; ** 行为与界面调整

;; *** 调整界面

;; 去除启动时的教程页。

(setq inhibit-startup-message t)

;; 关闭菜单栏、工具栏、滚动条。

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; 设置行号，并全局默认启用。

(setq column-number-mode t)
(global-display-line-numbers-mode t)

;; *** 设置字体

;; 分别设置中文与英文字体。中文用霞鹜文楷，英文随意。

(defun set-font (english chinese size-decipoints)
  "SIZE-DECIPOINTS 为十分之一点，例如 125 代表 12.5pt。"
  ;; 1. 设置西文：使用 :height 而非字符串格式化
  (set-face-attribute 'default nil 
                      :family english 
                      :height size-decipoints)
  
  ;; 2. 设置中文：保持不变，它会自动跟随 default 的缩放比例
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font t charset (font-spec :family chinese)))

  ;; 3. 视觉比例微调
  ;; 如果 12.5pt 下中英文还是不齐，微调这里的 1.06
  (setq face-font-rescale-alist `((,chinese . 1.08))))

(set-font "JetBrainsMono Nerd Font" "lxgw wenkai mono" 140)

;; 补充：增加一点行间距，防止姚体或文楷这类字体在视觉上挤压显扁。

(setq-default line-spacing 0.15)

;; 设置字体缓存。

(setq inhibit-compacting-font-caches t)

;; *** 行为优化

;; 禁止自动弹出原生编译的警告和错误窗口。
(setq native-comp-async-report-warnings-errors 'silent)


;; 去除烦人的铃声

(setq ring-bell-function 'ignore)

;; 将退出时的多次询问合并为一次（只针对有修改的 Buffer 列表确认一遍）

(setq confirm-kill-emacs #'yes-or-no-p)

;; 将所有的 yes/no 输入简化为 y/n

(fset 'yes-or-no-p 'y-or-n-p)

;; ** 设置包管理器

;; 引入内置的包管理器。

(require 'package)

;; 配置镜像源并初始化包管理器。

(setq package-archives '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

(package-initialize)

;; *** 自动安装并启用 `use-package`

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; 默认 ensure 为 =t= 。

(setq use-package-always-ensure t)

;; ** 配置主题

;; 主题为 dracula 。

(use-package doom-themes
  :ensure t
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (load-theme 'doom-dracula t)

  (doom-themes-visual-bell-config)
  (doom-themes-neotree-config)
  (doom-themes-treemacs-config)
  (doom-themes-org-config)
  )

;; 专门针对 emacs-lisp-mode

(add-hook 'emacs-lisp-mode-hook #'(lambda ()
  (font-lock-add-keywords nil
    '(("\\(;.*\\)"  1 '(:foreground "#E67E22" :slant italic) t)
      ("\\(\".*?\"\\)" 0 '(:foreground "#E67E22") t)))))

;; ** no-littering 规范配置目录结构

;; 整理目录文件，保持 =~/.emacs.d= 整洁

(use-package no-littering
  :config
  ;; 这会将所有的最近打开记录、历史等自动存入 ~/.emacs.d/var/ 和 ~/.emacs.d/etc/
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  (setq backup-directory-alist
      `(("." . ,(no-littering-expand-var-file-name "backups/")))))

;; ** outline 设置，文档化配置文件注释。

;; 设置 outline 折叠

(require 'simple-outshine)

(use-package outline
  :ensure nil
  :hook (
	 (emacs-lisp-mode . my-outline/setup-elisp)
	 )
  )

;; ** recentf

(use-package recentf
  :ensure nil ; 内置功能不需要下载
  :hook (after-init . recentf-mode)
  :config
  (setq recentf-max-saved-items 200     ; 设置保存最近文件的上限
        recentf-exclude '("/tmp/" "/ssh:" "/var/folders/" ".*-autoloads\\.el\\" ".*\\.gz\\") ; 排除掉不需要记录的路径
        recentf-auto-cleanup 'never)   ; 避免在启动时因为检查远程文件而卡顿
  
  ;; 自动保存 recentf 列表（默认是退出时才保存，容易丢失）
  (run-at-time nil 300 'recentf-save-list))

;; ** undo-fu

(use-package undo-fu
  :ensure t)
(use-package undohist
  :ensure t
  ;; 关键：确保在 Evil 加载之后再进行初始化，防止 void-variable 错误
  :after evil
  :config
  ;; 设置缓存路径
  (setq undohist-directory (expand-file-name "var/undohist" user-emacs-directory))
  
  ;; 排除不需要记录的文件
  (setq undohist-ignored-files '("/tmp/" "/COMMIT_EDITMSG\\'"))
  
  ;; 初始化
  (undohist-initialize))

;; * Evil

;; ** 引入 Evil

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-undo-system 'undo-fu)
  (setq evil-want-C-u-scroll t)
  ;; 禁止小写 y/p 自动关联系统剪贴板
  (setq evil-want-clipboard nil) 
  
  :config
  (evil-mode 1)
  (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
  (define-key evil-visual-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-visual-state-map (kbd "k") 'evil-previous-visual-line)
  ;; 强制大写 Y 复制到系统 (+ 寄存器)
  (evil-define-key '(normal visual) 'global (kbd "Y") 
    (lambda () (interactive) 
      (evil-use-register ?+) 
      (call-interactively 'evil-yank)))

  ;; 强制大写 P 从系统粘贴 (+ 寄存器)
  (evil-define-key '(normal visual) 'global (kbd "P") 
    (lambda () (interactive) 
      (evil-use-register ?+) 
      (call-interactively 'evil-paste-after)))

  ;; 让 Visual 模式下粘贴不覆盖寄存器
  (setq evil-kill-on-visual-paste nil)
  (define-key minibuffer-local-map [escape] 'abort-recursive-edit)
  (define-key minibuffer-local-map (kbd "ESC") 'abort-recursive-edit)
  (global-set-key (kbd "<escape>") 'keyboard-quit)
  (setq evil-disable-insert-state-bindings t)
  )

;; ** sis 输入法切换
(use-package sis
  :ensure t
  :config
  ;; 1. 配置输入法后端
  (sis-ism-lazyman-config "1" "2" 'fcitx5) 

  ;; 2. 核心功能：进入 Normal 模式自动切英文
  (sis-global-cursor-color-mode 1) ; 随输入法改变光标颜色（紫色系适配）
  (sis-global-respect-mode 1)      ; 核心：回到 Normal 模式切英文
  (sis-global-context-mode 1)      ; 智能记忆：回到 Insert 模式恢复上次状态
  
  ;; 3. 视觉美化：适配你的紫色美学
  (setq sis-cursor-color-zh "#bd93f9"   ; 中文时用紫色
        sis-cursor-color-en "#6272a4")) ; 英文时用暗蓝

;; ** which-key

(use-package which-key
  :defer 1
  :init (setq which-key-idle-delay 0.3)
  :config (which-key-mode))

;; ** general.el 快捷键管理

(use-package general
  :ensure t
  :after evil ; 确保在 collection 之后加载，才能覆盖它
  :init
  (setq general-override-states '(insert
				  emacs
				  hybird
				  visual
				  motion
				  operator
				  replace
				  ))
  :config
  (general-auto-unbind-keys)
  (general-evil-setup)
  )

;; ** evil-collection

;; 自动为 Emacs 其他界面（如 Dired, Magit）提供 Vim 快捷键
(use-package evil-collection
  :after evil 
  :ensure t
  :config
  ;; 不直接运行，而是等 Emacs 启动完成后再执行
  (evil-collection-init))

;; ** 调整行为，尽量与 vim 贴合

;; *** evil-numbers 数字自增/自减

(use-package evil-numbers
  :ensure t
  ;; 由于快捷键被占用，最好改换快捷键
  :bind (("C-c C-=" . evil-numbers/inc-at-pt)
         ("C-c C--" . evil-numbers/dec-at-pt))
  :config
  ;; 如果你希望支持二进制、八进制和十六进制，可以开启此项
  (setq evil-numbers/pad-at-point t))

;; *** evil-surround 模拟 vim-sandwich

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
    (kbd "sa") 'evil-surround-edit    ; 对应 ys
    (kbd "sd") 'evil-surround-delete  ; 对应 ds
    (kbd "sr") 'evil-surround-change) ; 对应 cs

  (evil-define-key 'visual 'global (kbd "s") 'evil-surround-region))

;; *** evil-simple-f 模仿 clever-f

(use-package evil-simple-f
  :load-path "lib"
  :after evil
  :bind (:map evil-normal-state-map
              ("f" . evil-simple-f-jump)
              ("F" . evil-simple-f-jump)))

;; *** nerdcommenter 快速注释

(use-package evil-nerd-commenter
  :ensure t)

;; *** Leader 键设置

(use-package general
  :config
  (general-create-definer my-leader-def
    :states '(normal visual motion)
    :keymaps 'override
    :no-normal-prefix "C-SPC")

  (my-leader-def
    :prefix "SPC"
    ;; --- 基础操作 ---
    "q" '(my-stuff/smart-quit :which-key "close window")
    "Q" '(kill-emacs :which-key "quit emacs")

    ;; --- 注释 (Commenter) ---
    "c" '(:ignore t :which-key "comment")
    "ci" '(evilnc-comment-or-uncomment-lines :which-key "toggle comment")

    ;; -- 打开文件 (open) --
    "o" '(:ignore t :which-key "open")
    "oi" '(my-stuff/open-init-file :which-key "open init.el")
    "oc" '(my-stuff/open-config-dir :which-key "open emacs config dir")

    ;; --- 文件操作 ---
    "f" '(:ignore t :which-key "files")
    "fs" '(save-buffer :which-key "save file")
    )
  )

;; * 搜索

;; ** vertico

(use-package vertico
  :init
  (vertico-mode)
  :config
  (setq vertico-cycle t)) ; 循环滚动选项

;; 记住搜索历史，下次自动排在前面
(use-package savehist
  :init
  (savehist-mode))

;; 核心：乱序模糊匹配 (Orderless)
(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))

;; ** consult 增强 vertico

;; 增强搜索功能 (类似 LeaderF 的功能集)
(use-package consult
  :after general
  :config
  ;; 绑定到你的 Leader 键
  (my-leader-def
    :prefix "SPC"
    "fr" '(consult-recent-file :which-key "最近文件")
    "ff" '(consult-find :which-key "找文件")
    "s" '(:ignore t :which-key "search")
    "sb" '(consult-buffer :which-key "切换 Buffer")
    "sl" '(consult-line :which-key "当前文件搜索")
    "sr" '(consult-ripgrep :which-key "项目全局搜索 (Ripgrep)")
    )
  )

;; * 编辑优化

;; ** Markdown 增强

(use-package markdown-mode
  :mode ("\\.md\\'" . gfm-mode)
  :custom
  ;; 默认关闭隐藏，确保编辑时源码可见
  (markdown-hide-markup nil)
  (markdown-hide-urls nil)
  (markdown-header-scaling t)
  (markdown-display-remote-images t)
  
  :hook
  (markdown-mode . (lambda ()
                     (setq line-spacing 0.3)      ; 舒适行间距
                     (visual-line-mode 1)))       ; 软折行

  :config
  (add-hook 'markdown-mode-hook
            (lambda ()
              (add-hook 'read-only-mode-hook #'my-stuff/markdown-toggle-view-logic nil t)))

  (custom-set-faces
   ;; 确保标题继承 default 的字体族，只改变高度和颜色
   '(markdown-link-face ((t (:foreground "#83a598" :underline t))))
   '(markdown-italic-face ((t (:slant italic :foreground "#b48ead")))))
  )

(use-package outline
  :ensure nil
  :hook (
	 (markdown-mode . my-outline/setup-markdown)
	 )
  )

;; *** math-preview

;; MathJax 实时渲染，需要 math-preview 。

(use-package math-preview
  :custom
  (math-preview-command "/home/aerian/.npm-packages/bin/math-preview")
  :hook (markdown-mode . math-preview-all)
  )

;; *** olivetti 沉浸式居中布局

;; 类似 vim 的 Goyo 。

(use-package olivetti
  :hook (markdown-mode . olivetti-mode) 
  :custom
  (olivetti-body-width 90))

;; ** 编辑体验

;; *** smartparens 自动配对。

(use-package smartparens
  :ensure t
  :init
  ;; 全局启用
  (smartparens-global-mode 1)
  :config
  (require 'smartparens-config) ; 加载官方预设的各语言配对规则
  
  ;; 针对 Elisp 的优化
  ;; Elisp 中单引号是特殊符号，通常不需要配对
  (sp-with-modes 'emacs-lisp-mode
    (sp-local-pair "'" nil :actions nil))
    
  ;; 针对 Markdown 的优化（如输入 * 自动补齐另一个 *）
  (sp-with-modes '(markdown-mode gfm-mode)
    (sp-local-pair "**" "**")
    (sp-local-pair "$" "$"))
  
  ;; 针对 Markdown 的特殊配对增强
  (sp-with-modes '(markdown-mode gfm-mode)
    (sp-local-pair "**" "**")
    (sp-local-pair "_" "_")
    (sp-local-pair "==" "==") ; 高亮标记
    (sp-local-pair "/*" "*/"))
)

;; *** rainbow-delimiters

;; 彩虹括号，不使之目眩。

(use-package rainbow-delimiters
  :ensure t
  ;; 确保在编程和 Markdown 模式下都开启
  :hook ((prog-mode emacs-lisp-mode markdown-mode) . rainbow-delimiters-mode)
  :config
  ;; 循环定义 9 层括号颜色，每一层都使用高对比度色彩并加粗
  (let ((colors '("#FF5F5F"   ; 1. 鲜红 (最外层，最醒目)
                  "#87D700"   ; 2. 柠檬绿
                  "#00AFFF"   ; 3. 天蓝
                  "#D787FF"   ; 4. 亮紫
                  "#FFAF00"   ; 5. 亮橙
                  "#00FFD7"   ; 6. 青绿
                  "#FFFF00"   ; 7. 纯黄
                  "#AF5FFF"   ; 8. 薰衣草紫
                  "#FF87D7"))) ; 9. 粉红
    (dotimes (i 9)
      (let ((face (intern (format "rainbow-delimiters-depth-%d-face" (+ i 1))))
            (color (nth i colors)))
        (set-face-attribute face nil :foreground color :weight 'bold))))
  
  ;; 针对那些无法匹配的孤儿括号（报错颜色）
  (set-face-attribute 'rainbow-delimiters-unmatched-face nil 
                      :foreground "white" :background "#FF0000" :weight 'bold))

;; ** 自动补全

;; *** yasnippet 配置

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets :ensure t)

(use-package yasnippet-capf
  :ensure t
  :after (yasnippet corfu))

;; *** kind-icon
(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; *** corfu 补全
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
    ;; 使用 add-hook 并在 append 位置设为 t，确保 yasnippet 不会顶掉原有的后端
    (add-hook 'completion-at-point-functions #'yasnippet-capf 100 t))
  ;; 在编程模式下加载
  (add-hook 'prog-mode-hook #'my/setup-corfu-backends)

  ;; 在文档模式下：禁用自动弹出，但保留后端
  (add-hook 'text-mode-hook
            (lambda ()
              (setq-local corfu-auto nil)
              (my/setup-corfu-backends)))

  ;; --- 快捷键与 UI (保持不变) ---
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

  (set-face-attribute 'corfu-border nil :background "#3d4451")

  ;; --- 自动展开 Snippet ---
  (advice-add 'corfu-insert :after
              (lambda (&rest _)
                (when (and (bound-and-true-p yas-minor-mode)
                           (looking-back yas-maybe-expand-abbrev-key-regexp (line-beginning-position)))
                  (yas-expand))))

  ;; --- Evil 适配 ---
  (with-eval-after-load 'evil
    (add-hook 'evil-insert-state-exit-hook #'corfu-quit)))

;; * 文件树

;; ** nerd-icons 文件图标
(use-package nerd-icons :ensure t)

;; ** dired

(use-package dired
  :ensure nil
  :init
  (setenv "LC_ALL" "C")
  :config
  ;; 关键：使用 -A 替代 -a 
  (setq dired-listing-switches "-l -A --human-readable --group-directories-first --no-group ")
  (add-hook 'dired-mode-hook 'dired-hide-details-mode)
  (add-hook 'dired-mode-hook 'dired-omit-mode)) ; 确保 omit 模式开启

(require 'dired-x)
(setq dired-omit-files "^\\.\\|^\\.\\.$") ; Optional: Hide all dotfiles except . and ..
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))

;; ** dirvish

;; 尽量模仿 neotree 。不使用 neotree 是因为 neotree 太拉了。

(use-package dirvish
  :ensure t
  :init
  ;; 彻底解决中文环境下“总计/total”行无法隐藏的问题
  (setenv "LC_ALL" "C")
  ;; 强制 Emacs 在与子进程通信时使用 UTF-8
  (set-selection-coding-system 'utf-8)
  (set-next-selection-coding-system 'utf-8)
  (setq-default process-coding-system '((utf-8 . utf-8)))
  (setenv "LC_ALL" "C")
  (dirvish-override-dired-mode)
  :config
  ;; --- 界面极简设置 ---
  (setq dirvish-side-width 25)
  (setq dirvish-side-header-line-format nil)
  (setq dirvish-side-mode-line-format nil)
  (setq dirvish-side-attributes '(vc-state nerd-icons collapse))
  
  ;; --- 快捷键适配 (Evil 风格) ---
  (with-eval-after-load 'evil
    ;; 在 Normal 模式下用 \ 呼出侧边栏
    (evil-define-key 'normal 'global (kbd "\\") 'dirvish-side)

    ;; 侧边栏内部快捷键绑定
    (evil-define-key 'normal dirvish-mode-map
      (kbd "h")          #'my-stuff/dirvish-h-action
      (kbd "l")          #'my-stuff/dirvish-l-action
      (kbd "j")          'evil-next-line
      (kbd "k")          'evil-previous-line
      (kbd "TAB")        'dirvish-subtree-toggle
      (kbd "<backspace>") 'dired-up-directory
      
      ;; 隐藏文件切换 ( . 或 zh )
      (kbd ".")          'dired-omit-mode
      
      ;; 排序：按扩展名切换
      (kbd "s")          (lambda () (interactive) 
                           (dirvish-ls-switches-modify "-X" 'toggle)
                           (dirvish-revert))
      
      ;; 宽度调整
      (kbd "<")          #'dirvish-side-decrease-width
      (kbd ">")          #'dirvish-side-increase-width
      
      ;; 分屏打开
      (kbd "e")          'dired-find-file-other-window
      (kbd "E")          (lambda () (interactive)
                           (let ((split-width-threshold 0) (split-height-threshold nil))
                             (dired-find-file-other-window)))
      
      (kbd "q")          'dirvish-quit
      (kbd "R")          'dirvish-revert
      (kbd "?")          'dirvish-dispatch))

  ;; 开启跟随模式
  (dirvish-side-follow-mode 1))

;; * 测量启动时间(废弃)

;; (add-hook 'emacs-startup-hook
;;           (lambda ()
;;             (message "Emacs 启动耗时: %.2fs，共触发了 %d 次垃圾回收。"
;;                      (float-time (time-subtract after-init-time before-init-time))
;;                      gcs-done)))
