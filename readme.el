(defun load-packages (package-list)
  (dolist (package package-list)
    (unless (package-installed-p package)
      (package-install package))))

(defun echo-file-contents (file-path)
  "Return FILE-PATH's contents."
  (with-temp-buffer
    (insert-file-contents file-path)
    (buffer-string)))

(defun insert-file-name ()
  (insert (buffer-file-name (window-buffer (minibuffer-selected-window)))))

;; Set frame size on startup:
(add-to-list 'default-frame-alist '(height . 56))
(add-to-list 'default-frame-alist '(width . 177))

(setq gc-cons-threshold 20000000)

;; get rid of Emacs GUI shit
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(add-to-list 'default-frame-alist '(font . "mononoki Nerd Font" ))
(set-face-attribute 'default t :font "mononoki Nerd Font" )

;; font scaling
(use-package default-text-scale
  :ensure t
  :bind ("C-M-=" . default-text-scale-increase)
  ("C-M--" . default-text-scale-decrease))

(use-package nord-theme
  :disabled
  :ensure t
  :defer t
  :init (load-theme 'nord-theme))

(use-package zenburn-theme
  :ensure t
  :defer t)

(use-package leuven-theme
  :ensure t
  :defer t
)

(use-package sublime-themes
  :ensure t
  :defer t)

(use-package spacemacs-theme
  :ensure t
  :defer t
  :init (load-theme 'spacemacs-dark t))

;; highlight line at point
(global-hl-line-mode)
;; highlight opposite paren
(show-paren-mode t)

(setenv "PATH" (concat "/usr/local/smlnj/bin:" (getenv "PATH")))
(setq exec-path (cons "/usr/local/smlnj/bin"  exec-path))

;; Snippet to load a directory, making al .el files available to require
(defun load-directory (dir)
  (let ((load-it (lambda (f)
                  (load-file (concat (file-name-as-directory dir) f)))))

      (mapc load-it (directory-files dir nil "\\.el$"))))

 ;;add =vendor= to default directory
(load-directory "~/.emacs.d/vendor/")

(setq user-full-name "Andrew Jarrett"
      user-email-address "ahrjarrett@gmail.com")
;; where to put emacs backup files
(setq backup-directory-alist `(("." . "~/.saves")))

(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "<C-M-up>") 'enlarge-window-horizontally)
(global-set-key (kbd "<C-M-down>") 'shrink-window-horizontally)

;; allow me to open a file/dir in dired w/o creating another buffer by hitting `a`
(put 'dired-find-alternate-file 'disabled nil)

;; display “lambda” as “λ”
;; (global-prettify-symbols-mode 1)

(use-package quoted-scratch
  :load-path "~/.emacs.d/quoted-scratch/"
  :demand t
  :config
  (progn
    (setq initial-scratch-message nil
          qs-show-auroville-quality nil)
    (add-hook 'emacs-startup-hook
              (lambda ()
                (run-with-timer 1 nil 'qs-refresh-scratch-buffer)
                (qs-refresh-quote-when-idle)))))

(use-package macrostep
  :ensure t
  :bind ("C-c e m" . macrostep-expand)
        ("C-c e c" . macrostep-collapse))

(use-package parinfer
  :ensure t
  :bind
  (("C-," . parinfer-toggle-mode))
  :init
  (progn
    (setq parinfer-extensions
          '(defaults       ; should be included.
            pretty-parens  ; different paren styles for different modes.
            evil           ; If you use Evil.
            ;; lispy          ; If you use Lispy. With this extension, you should install Lispy and do not enable lispy-mode directly.
            ;; paredit        ; Introduce some paredit commands.
            smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
            smart-yank))   ; Yank behavior depend on mode.
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))

(use-package clojure-mode
  :ensure t
  :config)

(use-package cider
  :ensure t)

(add-hook 'python-mode-hook
          (lambda ()
            (setq-default indent-tabs-mode t)
            (setq-default tab-width 2)
            (setq-default py-indent-tabs-mode t)
            (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

(use-package sml-mode
  :ensure t
  :mode (("\\.sml\\'" . sml-mode)))

(use-package reason-mode
  :ensure t
  :init
  (add-hook 'reason-mode-hook (lambda ())
          (add-hook 'before-save-hook 'refmt-before-save))
  :mode ("\\.rei?'" . reason-mode))

(use-package tuareg
  :mode ("\\.ml[ily]?$" . tuareg-mode)
  :ensure t)

(use-package elm-mode
  :mode ("\\.elm\\'" . elm-mode)
  :init (setq elm-format-on-save t))

(use-package js2-mode
  :ensure t
  :mode (("\\.js$" . js2-mode)) ;; makes sure we don't use for jsx files, too
  :interpreter ("node" . js2-mode)
  :config
  (setq-default js2-strict-missing-semi-warning nil)
  (setq-default js2-strict-trailing-comma-warning nil)
  (add-hook 'js2-mode-hook (lambda () (setq js2-basic-offset 2))))

(use-package rjsx-mode
  :ensure t)

(use-package web-mode
  :ensure t
  :mode (("\\.html\\'" . web-mode ))
  :mode (("\\.css\\'" . web-mode ))
  :init
  (progn
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-code-indent-offset 2)
    (setq web-mode-css-indent-offset 2)

    (setq web-mode-enable-auto-pairing t)
    (setq web-mode-enable-css-colorization t)))

(use-package less-css-mode
  :ensure t
  ;:commands less-css-mode
  ;:config
  ;(use-package js2-mode)
  ;(use-package skewer-less)
  )

(use-package prettier-js
  :disabled
  :ensure t
  :init
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  (add-hook 'web-mode-hook 'prettier-js-mode)
  (setq prettier-js-args
        '("--trailing-comma" "all"
          "--single-quote" "true")))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;(setq eshell-prompt-function
;  (lambda ()
;    (concat (format-time-string "%Y-%m-%d %H:%M" (current-time))
;      (if (= (user-uid) 0) " # " " $ "))))

(setq org-ellipsis "  ▼")
(setq org-startup-indented t)
(setq org-table-convert-region-max-lines 3000)

;; turn on visual line mode automatically for .org files
(add-hook 'org-mode-hook #'turn-on-visual-line-mode)

(use-package htmlize
  :ensure t)

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook #'org-bullets-mode))

;; Custom variables
(custom-set-variables
 '(org-directory "~/Dropbox/orgfiles")
 '(org-default-notes-file (concat org-directory "/notes.org")))

(setq org-agenda-files (list "~/Dropbox/org/ownlocal"))

;; org-mode agenda config from Home computer, changed for Work 08/01/18
;;(setq org-agenda-files (list (concat org-directory "/google-calendar.org")
;;                             (concat org-directory "/index.org"))))



;(require 'ob-sml nil 'noerror)

(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   ;;(sml . t)
   ;;(ocaml . t)
  ))

;; According to this
;;(setq shell-command-switch "-lc")


;; after installing ocp-indent:
;;(add-to-list 'load-path "/Users/aj/.opam/default/share/emacs/site-lisp"
;;             (require 'ocp-indent))

;; removes annoying numbering from headers when exporting to HTML.
;; (the equivalent of putting #OPTIONS: num:nil  at the top of an org file)
(setq org-export-with-section-numbers nil)

;; don't confirm evaluating source blocks on export:
(setq org-confirm-babel-evaluate nil)

(use-package ox-gfm
  :ensure t)

(eval-after-load "org"
  '(require 'ox-gfm nil t))

(add-to-list 'org-structure-template-alist
             `("P" ,(concat "#+TITLE: ?" "\n" "#+AUTHOR: " user-full-name "\n" "#+EMAIL:" user-email-address "\n" "#+DATE: " (format-time-string "%m/%d/%Y"))))

(use-package org-ac
  :disabled
  :ensure t
  ;; why is this require in init necessary? is it?
  :init (progn
         (require 'org-ac)
         (org-ac/config-default)))

;; Go into Insert state after org-capture
(add-hook 'org-capture-mode-hook 'evil-insert-state)

;; NOTE: %i allows you to mark a block of text anywhere in Emacs,
;; run Org-Capture, and it will drop that text into the capture.
(setq org-capture-templates
      '(("a" "Appointment" entry (file+headline  (concat org-directory "/google-calendar.org") "Appointments")
             "* TODO %?\n:PROPERTIES:\n\n:END:\nDEADLINE: %^T \n %i\n")
        ("b" "Bookmark" entry (file+headline     (concat org-directory "/index.org") "Bookmarks")
             "* %^L %^g \n%T" :prepend t)
        ("j" "Journal" entry (file+datetree      (concat org-directory "/journal.org"))
             "* %?\nEntered on %U\n  %i\n  %a")
        ("n" "Note:" entry (file+headline         (concat org-directory "/notes.org") "Notes")
             "* Note %? %^g \n%i\n%T")
        ("t" "Todo Item" entry (file+headline    (concat org-directory "/todo.org") "Todo Items")
             "* TODO %?\n%T" :prepend t)))

;;(load-packages '(org-trello))
;;(require 'org-trello)
;;(setq org-trello-files
;;  (directory-files "~/Dropbox/org/ownlocal/trello" ".*\.org$"))

(use-package evil
   :ensure t
   :init (setq evil-want-C-i-jump nil)
   :config
   (evil-mode 1))

(add-hook 'occur-mode-hook
    (lambda ()
      (evil-add-hjkl-bindings occur-mode-map 'emacs
        (kbd "/")       'evil-search-forward
        (kbd "n")       'evil-search-next
        (kbd "N")       'evil-search-previous
        (kbd "C-d")     'evil-scroll-down)))
        ;; This line conflicts with Emacs' built in modifier key
        ;;(kbd "C-u")     'evil-scroll-up

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package org-evil
  :disabled
  :ensure t)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package helm
  :disabled
  :ensure t)

(use-package ivy
  :ensure t
  :init
  ;; This line is necessary to disable ligatures in Ivy
  ;; (otherwise it crashes)
  (add-hook 'ivy-mode
            (lambda ()
              (setq auto-composition-mode nil)))

  :config
  (ivy-mode 1)

  (use-package counsel
    :ensure t))

(use-package try
  :ensure t)

(use-package company
  :ensure t
  :defer t
  :init (global-company-mode)
  :config
  (progn
    ;; Use Company for completion
    (bind-key [remap completion-at-point] #'company-complete company-mode-map)

    (setq company-tooltip-align-annotations t
          ;; Easy navigation to candidates with M-<n>
          ;; Does this also work in reverse with M-<p>?
          company-show-numbers t)
    (setq company-dabbrev-downcase nil))
  :diminish company-mode)

(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)))

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode)
  (add-to-list 'projectile-globally-ignored-directories "node_modules")
  ;; use ivy for pattern matching and completion
  (setq projectile-completion-system 'ivy))

(use-package magit
  :ensure t
  :bind (("C-c g" . magit-status)))

(use-package git-gutter
  :disabled
  :ensure t
  :init
  (global-git-gutter-mode +1))

(use-package sunshine
  :disabled
  :ensure t
  :commands sunshine-forecast
  :config
  (setq sunshine-appid (echo-file-contents
                        (expand-file-name "sunshine.key" user-emacs-directory)))
  (setq sunshine-location "Denver, CO, USA")
  (setq sunshine-show-icons t))

(use-package paredit
  :disabled
  :ensure t
  :init
    (autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
    (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
    (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
    (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
    (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
    (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
    (add-hook 'scheme-mode-hook           #'enable-paredit-mode)

    ;; turn on paredit for clojure:
    (add-hook 'clojure-mode-hook #'paredit-mode))

(use-package indium
  :disabled
  :ensure t)
