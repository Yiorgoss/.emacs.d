;; Mac global keybinds
 (global-set-key [(hyper a)] 'mark-whole-buffer)
 (global-set-key [(hyper v)] 'yank)
 (global-set-key [(hyper c)] 'kill-ring-save)
 (global-set-key [(hyper s)] 'save-buffer)
 (global-set-key [(hyper l)] 'goto-line)
 (global-set-key [(hyper w)]
                 (lambda () (interactive) (delete-window)))
 (global-set-key [(hyper z)] 'undo)
 (global-set-key [(hyper backspace)] '(lambda () (interactive) (kill-line 0)) )

;;emacs terminal
(global-set-key (kbd "H-;") 'eshell)


;;multiple-cursors
(global-set-key [(hyper >)] 'mc/mark-next-like-this)
(global-set-key [(hyper <)] 'mc/mark-previous-like-this)

;Ivy
(global-set-key (kbd "H-b") 'ivy-switch-buffer)

;Avy
(global-set-key (kbd "H-e") 'avy-goto-char-2)

;swiper
(global-set-key (kbd "H-t") 'swiper)

;;custom functions
(global-set-key [(hyper u)] 'comment-or-uncomment-region-or-line)
(global-set-key (kbd "H-[") 'config-edit)
(global-set-key (kbd "H-]") 'config-reload)

;;windows
(global-set-key (kbd "H-m") 'split-and-follow-horizontal)
(global-set-key (kbd "H-k") 'split-and-follow-vertical)

(global-set-key (kbd "H-,") 'delete-window)
(global-set-key (kbd "H-.") 'delete-other-windows)

(global-set-key (kbd "H-o") 'switch-window)

;;UNBIND MAC SYS SHORTCUTS

;highlight key
(global-set-key [(hyper h)] 'set-mark-command)

;; mac switch meta key
(defun mac-swich-meta nil
  ;; "switch meta between Option and Command"
  (interactive)
  (if (eq mac-option-modifier nil)
      (progn
        (setq mac-option-modifier 'meta)
        (setq mac-command-modifier 'hyper)
        )
    (progn
      (setq mac-option-modifier nil)
      (setq mac-command-modifier 'meta)
      )
    )
  )

(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'hyper)

(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)
        (next-line)))

(defun config-edit ()
  (interactive)
  (find-file "~/.emacs.d/config.org"))

(defun config-reload ()
  (interactive)
  (org-babel-load-file (expand-file-name "~/.emacs.d/config.org")))

(defun split-and-follow-horizontal ()
  (interactive)
  (split-window-below)
  (balance-window)
  (other-window 1))

(defun split-and-follow-vertical ()
  (interactive)
  (split-window-right)
  (balance-window)
  (other-window 1))

(add-to-list 'custom-theme-load-path' "~/.emacs.d/themes")
(load-theme 'dracula t)

(setq inhibit-startup-message t)

(menu-bar-mode -1)
(tool-bar-mode -1)

(global-display-line-numbers-mode)

(fset 'yes-or-no-p 'y-or-n-p)

(winner-mode 1)

(setq scroll-conservatively 100)
(setq ring-bell-function 'ignore)

(when window-system (global-hl-line-mode t ))

(server-start)

(setq auto-save-file-name-transforms
    `((".*" "~/.emacs-saves/" t)))

(setq backup-directory-alist
    `(("." . ,(concat user-emacs-directory "backups"))))

(setq default-frame-alist
      '(
        (left . 0) 
        (width . 141) 
        (fullscreen . fullheight)))

;; Set default font
(set-face-attribute 'default nil
                    :family "Input Mono"
                    :height 150
                    :width 'normal
                    )

(defvar my-terminal-shell "/bin/bash")
(defadvice ansi-term (before force-bash)
  (interactive (list my-terminal-shell)))
(ad-activate 'ansi-term)

(setq indo-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;;buffer navigation
(use-package avy
  :ensure t
  :bind ("H-e" . avy-goto-char))

(use-package beacon
  :ensure t
  :init
  (beacon-mode 1))

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

;;autocompleete
;;Buffer Sh!t
(use-package ivy
  :ensure t
  :diminish (ivy-mode)
  :config
  (ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-display-style 'fancy))

(setq ido-enable-flex-matching t)
  ;;(setq ido-create-new-buffer 'always)
  (setq ido-everywhere t)

(defalias 'list-buffers 'ibuffer)

(use-package multiple-cursors
    :ensure t)

(require 'multiple-cursors)

;; Org-mode settings
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-font-lock-mode 1)

;;nicer bullets
(use-package org-bullets
:ensure t
:config
(add-hook 'org-mode-hook (lambda () (org-bullet-mode 1))))

;;global keys
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
;;(global-set-key "\C-cl" 'org-store-link)
;;(global-set-key "\C-ca" 'org-agenda)

(use-package rainbow-mode
  :ensure t
  :init
  (rainbow-mode 1))

(use-package smex
  :ensure t
  :init (smex-initialize)
  :bind ("M-x" . smex))

(use-package switch-window
  :ensure t
  :config
  (setq switch-window-input-style 'minibuffer)
  (setq switch-window-increase 4)
  (setq switch-window-threshold 2)
  (setq switch-window-shortcut-style 'qwerty)
  (setq switch-window-qwerty-shortcuts
        '("t" "s" "r" "a" "z"))
  :bind
  ([remap other-window] . switch-window))

(use-package swiper
  :ensure t)
 ;; :bind ("H-t" . swiper))

(use-package try
    :ensure t)

;;what combinations are possbible
(use-package which-key
 :ensure t
 :config
 (which-key-mode))

(use-package yasnippet
  :ensure t
  :config
  (use-package yasnippet-snippets
    :ensure t)
  (yas-reload-all))
