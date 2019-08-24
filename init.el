(require 'package)
(setq package-enable-at-startup nil)

(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

;;(setq inhibit-startup-message t)

;;(setq mac-command-modifier 'control)


(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;  (progn
;;    (setq initial-frame-alist '( (tool-bar-lines . 0)))
;;    (setq default-frame-alist '( (tool-bar-lines . 0)))))

(require 'org)
 (org-babel-load-file
  (expand-file-name (concat user-emacs-directory "config.org")))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (yasnippet-snippets yasnippet yasnippets swiper 0blayout rainbow-mode switch-window smex ido-vertical-mode dracula-theme avy which-key use-package try smartparens org-bullets ordinal multiple-cursors ivy flycheck))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
