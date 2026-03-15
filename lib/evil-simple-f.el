;;; evil-simple-f.el --- One line at a time & Case-sensitive
;;; -*- lexical-binding: t; -*-

(require 'evil)

(defun evil-simple-f--cleanup ()
  "清除所有高亮层"
  (remove-overlays nil nil 'category 'evil-simple-f))

(defvar-local evil-simple-f--last-char nil)
(defvar-local evil-simple-f--last-forward nil)

(defun evil-simple-f--highlight-current-line (char)
  "仅高亮当前行的目标字符"
  (evil-simple-f--cleanup)
  (let ((char-regexp (regexp-quote (char-to-string char)))
        (start (line-beginning-position))
        (end (line-end-position)))
    (save-excursion
      (goto-char start)
      ;; 强制区分大小写进行高亮匹配
      (let ((case-fold-search nil))
        (while (search-forward char-regexp end t)
          (let ((ov (make-overlay (match-beginning 0) (match-end 0))))
            (overlay-put ov 'category 'evil-simple-f)
            (overlay-put ov 'face '(:background "red" :foreground "white" :weight bold))
            (overlay-put ov 'priority 9999)))))))

(defun evil-simple-f--do-jump (char forward)
  "核心跳转逻辑：跨行搜索 + 区分大小写"
  (let ((char-str (char-to-string char))
        (limit (if forward (point-max) (point-min)))
        ;; 关键：设置 case-fold-search 为 nil 以区分大小写
        (case-fold-search nil))
    (when forward (forward-char 1))
    (if (search-forward char-str limit t (if forward 1 -1))
        (progn
          (goto-char (match-beginning 0))
          ;; 跳转完成后，立即更新当前行的高亮
          (evil-simple-f--highlight-current-line char))
      (when forward (backward-char 1)))))

;;;###autoload
(evil-define-command evil-simple-f-jump (count char)
  "仿 clever-f：逐行高亮，区分大小写，支持跨行跳转。"
  :repeat nil
  (interactive "<c><C>")
  (cond
   ((null char) nil)
   (t
    (evil-simple-f--cleanup)
    (setq evil-simple-f--last-char char)
    (setq evil-simple-f--last-forward (not (member last-command-event '(?F ?T))))
    
    ;; 1. 执行初始跳转
    (dotimes (_ (or count 1))
      (evil-simple-f--do-jump evil-simple-f--last-char evil-simple-f--last-forward))
    
    ;; 2. 初始高亮（此时已在 do-jump 中完成，但为了保险在此显式调用）
    (evil-simple-f--highlight-current-line char)

    ;; 3. 连跳逻辑
    (set-transient-map
     (let ((map (make-sparse-keymap)))
       (define-key map (kbd "f") 
         (lambda () (interactive) (evil-simple-f--do-jump evil-simple-f--last-char evil-simple-f--last-forward)))
       (define-key map (kbd "F") 
         (lambda () (interactive) (evil-simple-f--do-jump evil-simple-f--last-char (not evil-simple-f--last-forward))))
       map)
     t
     #'evil-simple-f--cleanup))))

(provide 'evil-simple-f)
