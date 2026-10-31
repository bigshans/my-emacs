;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(easysession-directory
   (expand-file-name "var/sessions" user-emacs-ensime-directory))
 '(package-selected-packages
   '(consult corfu dashboard dirvish doom-themes easysession
	     evil-collection evil-multiedit evil-nerd-commenter
	     evil-numbers evil-surround general kind-icon magit
	     markdown-mode math-preview multiple-cursors nerd-icons
	     no-littering olivetti orderless projectile
	     rainbow-delimiters sis smartparens undo-fu undohist
	     vertico yasnippet-capf yasnippet-snippets))
 '(package-vc-selected-packages
   '((lsp-bridge :url "https://github.com/manateelazycat/lsp-bridge"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(child-frame-border ((t (:background "#bd93f9"))))
 '(company-tooltip ((t (:background "#282a36"))))
 '(company-tooltip-match ((t (:foreground "#f1fa8c" :weight bold))))
 '(company-tooltip-selection ((t (:background "#44475a" :foreground "#8be9fd" :weight bold))))
 '(markdown-header-delimiter-face ((t (:foreground "#616161" :height 0.9))))
 '(markdown-header-face-1 ((t (:height 1.5 :weight bold :foreground "#83a598"))))
 '(markdown-header-face-2 ((t (:height 1.4 :foreground "#EBCB8B" :weight bold))))
 '(markdown-header-face-3 ((t (:height 1.2 :foreground "#D08770" :weight bold))))
 '(markdown-header-face-4 ((t (:height 1.1 :foreground "#BF616A" :weight bold))))
 '(markdown-italic-face ((t (:slant italic :foreground "#b16286"))))
 '(markdown-link-face ((t (:foreground "#458588" :underline t))))
 '(outline-1 ((t (:foreground "#bd93f9" :weight bold :height 1.2 :underline t))))
 '(outline-2 ((t (:foreground "#8be9fd" :weight bold))))
 '(outline-3 ((t (:foreground "#ff79c6" :weight bold)))))
