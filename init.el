;; Remove cruft 
;;(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
;;(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(setq inhibit-startup-message t)


(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)


;;; backup/autosave
(defvar backup-dir (expand-file-name "~/.emacs.d/backup/"))
(defvar autosave-dir (expand-file-name "~/.emacs.d/autosave/"))
(setq backup-directory-alist (list (cons ".*" backup-dir)))
(setq auto-save-list-file-prefix autosave-dir)
(setq auto-save-file-name-transforms `((".*" ,autosave-dir t)))


;; Hippie Expand
(setq hippie-expand-try-functions-list 
      '(yas/hippie-try-expand 
 	try-expand-dabbrev 
	try-expand-dabbrev-all-buffers 
	try-expand-dabbrev-from-kill 
	try-complete-file-name-partially 
	try-complete-file-name 
	try-expand-all-abbrevs 
	try-expand-list 
	try-expand-line 
	try-complete-lisp-symbol-partially 
	try-complete-lisp-symbol))
(defun fancy-tab (arg)
  (interactive "P")
  (setq this-command last-command)
  (if (or (eq this-command 'hippie-expand) (looking-at "\\_>"))
      (progn
	(setq this-command 'hippie-expand)
	(hippie-expand arg))
    (setq this-command 'indent-for-tab-command)
    (indent-for-tab-command arg)))
(global-set-key (kbd "TAB") 'fancy-tab)


;; ido mode
(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-use-virtual-buffers t)
(ido-mode t)


;; default font
(when (window-system)
  (set-frame-font "Source Code Pro")
  (set-face-attribute 'default nil :font "Source Code Pro" :height 140)
  (set-face-font 'default "Source Code Pro"))


;; line numbers
(line-number-mode 1)
(global-linum-mode t)


;; indentation
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq js-indent-level 2)
(setq css-indent-offset 2)


;; show paren mode
(show-paren-mode t)


;;uniquify
(require 'uniquify)


(add-hook 'after-init-hook 'my-after-init-hook)
(defun my-after-init-hook ()
  ;; do things after package initialization
  
  ;;EMMET
  (add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
  (add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.

  ;;YASNIPPET
  (yas-global-mode 1)

  ;;web beautify
  (eval-after-load 'js
    '(define-key js-mode-map (kbd "C-c b") 'web-beautify-js))
  (eval-after-load 'js2-mode
    '(define-key js2-mode-map (kbd "C-c b") 'web-beautify-js))
  (eval-after-load 'json-mode
    '(define-key json-mode-map (kbd "C-c b") 'web-beautify-js))
  (eval-after-load 'sgml-mode
    '(define-key html-mode-map (kbd "C-c b") 'web-beautify-html))
  (eval-after-load 'css-mode
    '(define-key css-mode-map (kbd "C-c b") 'web-beautify-css))

  ;;expand-region
  (require 'expand-region)
  (global-set-key (kbd "C-+") 'er/expand-region)
  (global-set-key (kbd "C--") 'er/contract-region)

  ;;smart-forward
  (require 'smart-forward)  
  (global-set-key (kbd "M-<up>") 'smart-up)
  (global-set-key (kbd "M-<down>") 'smart-down)
  (global-set-key (kbd "M-<left>") 'smart-backward)
  (global-set-key (kbd "M-<right>") 'smart-forward)

  ;;dired-single
  ;;TODO add magic buffer
  (defun my-dired-init ()
    "Bunch of stuff to run for dired, either immediately or when it's
         loaded."
    ;; <add other stuff here>
    (define-key dired-mode-map [return] 'dired-single-buffer)
    (define-key dired-mode-map [mouse-1] 'dired-single-buffer-mouse)
    (define-key dired-mode-map "^"
      (function
       (lambda nil (interactive) (dired-single-buffer "..")))))
  ;; if dired's already loaded, then the keymap will be bound
  (if (boundp 'dired-mode-map)
      ;; we're good to go; just add our bindings
      (my-dired-init)
    ;; it's not loaded yet, so add our bindings to the load-hook
    (add-hook 'dired-load-hook 'my-dired-init))

  ;;sr-speedbar
  (require 'sr-speedbar)
  (global-set-key (kbd "C-p") 'sr-speedbar-toggle)

  ;;flycheck
  (global-flycheck-mode)

  ;;smex
  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands)
  ;; old M-x now:
  (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

  ;;rainbow-delimiters
  (require 'rainbow-delimiters)
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)


  ;;autopair
  (autopair-global-mode)
  ;;smartparens deleted
  ;;paredit & paredit-menu
  ;;using autopair for now
  (defun my-paredit-init ()
    (paredit-mode t)
    (global-set-key (kbd "{") 'paredit-open-curly)
    (global-set-key (kbd "}") 'paredit-close-curly)
    (require 'paredit-menu)

    (defun paredit-space-for-delimiter-p (endp delimiter)
      (and (not (if endp (eobp) (bobp)))
	   (memq (char-syntax (if endp (char-after) (char-before)))
		 (list ?\"  ;; REMOVED ?w ?_
		       (let ((matching (matching-paren delimiter)))
			 (and matching (char-syntax matching)))))))
    )
  ; (add-hook 'prog-mode-hook 'my-paredit-init)
  ; goodbye darkness my old friend
;;melpa packages required'
;; emmet-mode
;; w3m
;; web-beautify
;; yasnippet
;; dired-single
;; autopair
;; smex
;; sr-speedbar
;; expand-region
;; smart-forward
;; flycheck
;; rainbow-delimiters
)

;;personal key bindings
(global-set-key (kbd "s-d") 'kill-whole-line)
(global-set-key (kbd "C-x C-b") 'ibuffer)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(create-lockfiles nil)
 '(custom-enabled-themes (quote (wheatgrass)))
 '(custom-safe-themes (quote ("57ef2b763fe7cdecf5e3ad88367c7b45986faba30036830270fa20c3573aa919" default)))
 '(hl-paren-background-colors (quote ("#00FF99" "#CCFF99" "#FFCC99" "#FF9999" "#FF99CC" "#CC99FF" "#9999FF" "#99CCFF" "#99FFCC" "#7FFF00")))
 '(hl-paren-colors (quote ("#326B6B")))
 '(speedbar-default-position (quote left))
 '(speedbar-use-images nil)
 '(sr-speedbar-right-side nil)
 '(tool-bar-mode nil))
