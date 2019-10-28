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
(global-set-key [(hyper /)] 'comment-or-uncomment-region-or-line)
(global-set-key (kbd "H-[") 'config-edit)
(global-set-key (kbd "H-]") 'config-reload)

;;find_file rebind
(global-set-key [(hyper f)] 'find-file-other-window)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; backup settings                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://www.emacswiki.org/emacs/BackupFiles
(setq
 backup-by-copying t     ; don't clobber symlinks
 kept-new-versions 10    ; keep 10 latest versions
 kept-old-versions 0     ; don't bother with old versions
 delete-old-versions t   ; don't ask about deleting old versions
 version-control t       ; number backups
 vc-make-backup-files t) ; backup version controlled files

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; backup every save                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; http://stackoverflow.com/questions/151945/how-do-i-control-how-emacs-makes-backup-files
;; https://www.emacswiki.org/emacs/backup-each-save.el
(defvar bjm/backup-file-size-limit (* 5 1024 1024)
  "Maximum size of a file (in bytes) that should be copied at each savepoint.

If a file is greater than this size, don't make a backup of it.
Default is 5 MB")

(defvar bjm/backup-location (expand-file-name "~/emacs-backups")
  "Base directory for backup files.")

(defvar bjm/backup-trash-dir (expand-file-name "~/.Trash")
  "Directory for unwanted backups.")

(defvar bjm/backup-exclude-regexp "\\[Gmail\\]"
  "Don't back up files matching this regexp.

Files whose full name matches this regexp are backed up to `bjm/backup-trash-dir'. Set to nil to disable this.")

;; Default and per-save backups go here:
;; N.B. backtick and comma allow evaluation of expression
;; when forming list
(setq backup-directory-alist
      `(("" . ,(expand-file-name "per-save" bjm/backup-location))))

;; add trash dir if needed
(if bjm/backup-exclude-regexp
    (add-to-list 'backup-directory-alist `(,bjm/backup-exclude-regexp . ,bjm/backup-trash-dir)))

(defun bjm/backup-every-save ()
  "Backup files every time they are saved.

Files are backed up to `bjm/backup-location' in subdirectories \"per-session\" once per Emacs session, and \"per-save\" every time a file is saved.

Files whose names match the REGEXP in `bjm/backup-exclude-regexp' are copied to `bjm/backup-trash-dir' instead of the normal backup directory.

Files larger than `bjm/backup-file-size-limit' are not backed up."

  ;; Make a special "per session" backup at the first save of each
  ;; emacs session.
  (when (not buffer-backed-up)
    ;;
    ;; Override the default parameters for per-session backups.
    ;;
    (let ((backup-directory-alist
           `(("." . ,(expand-file-name "per-session" bjm/backup-location))))
          (kept-new-versions 3))
      ;;
      ;; add trash dir if needed
      ;;
      (if bjm/backup-exclude-regexp
          (add-to-list
           'backup-directory-alist
           `(,bjm/backup-exclude-regexp . ,bjm/backup-trash-dir)))
      ;;
      ;; is file too large?
      ;;
      (if (<= (buffer-size) bjm/backup-file-size-limit)
          (progn
            (message "Made per session backup of %s" (buffer-name))
            (backup-buffer))
        (message "WARNING: File %s too large to backup - increase value of bjm/backup-file-size-limit" (buffer-name)))))
  ;;
  ;; Make a "per save" backup on each save.  The first save results in
  ;; both a per-session and a per-save backup, to keep the numbering
  ;; of per-save backups consistent.
  ;;
  (let ((buffer-backed-up nil))
    ;;
    ;; is file too large?
    ;;
    (if (<= (buffer-size) bjm/backup-file-size-limit)
        (progn
          (message "Made per save backup of %s" (buffer-name))
          (backup-buffer))
      (message "WARNING: File %s too large to backup - increase value of bjm/backup-file-size-limit" (buffer-name)))))

;; add to save hook
(add-hook 'before-save-hook 'bjm/backup-every-save)

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

;;control window split direction
(setq split-height-threshold nil)
(setq split-width-threshold 0)

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

(setq ido-enable-flex-matching t)
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

(use-package php-mode :ensure t)

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

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(setq web-mode-engines-alist
      '(("php"    . "\\.phtml\\'")
        ("blade"  . "\\.blade\\."))
)

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
