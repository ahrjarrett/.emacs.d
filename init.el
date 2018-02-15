(setq inhibit-startup-message t)

;; setup melpa
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

;; ## use-package
(unless (package-installed-p 'use-package)
  ;; "package-refresh-contents is like running "brew update"
  ;; and a good function to call if you're getting an error
  ;; trying to install a melpa package that you know exists:
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-always-ensure t)
(require 'use-package)

;; put custom stuff somewhere else
(setq custom-file "~/.emacs.d/custom.el")
;; load custom file & don't throw an error if empty
(load custom-file 'noerror)

;; use literate .org file for the rest of my config
(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))
