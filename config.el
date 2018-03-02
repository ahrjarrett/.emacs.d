
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
              (kbd "C-d")     'evil-scroll-down
              (kbd "C-u")     'evil-scroll-up)))

(setq gc-cons-threshold 20000000)

(setq user-full-name "Andrew Jarrett"
      user-email-address "ahrjarrett@gmail.com")
;; where to put emacs backup files
(setq backup-directory-alist `(("." . "~/.saves")))

;; set font
(add-to-list 'default-frame-alist '(font . "mononoki 14"))
(set-face-attribute 'default t :font "mononoki 14")
(set-frame-font "mononoki 14" nil t)
(set-face-attribute 'default nil :height 140)

;; get rid of Emacs GUI shit
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

;;(use-package color-theme
;;  :ensure t)

(use-package zenburn-theme
  :ensure t
  :init
  (load-theme 'zenburn t))

(global-set-key (kbd "C-s") 'swiper)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1))

(use-package counsel
  :ensure t)

;; allow me to open a file/dir in dired w/o creating another buffer by hitting `a`
(put 'dired-find-alternate-file 'disabled nil)

(use-package try
  :ensure t)

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
  ;; use ivy for pattern matching and completion
  (setq projectile-completion-system 'ivy))

(use-package magit
  :ensure t
  :bind (("C-c g" . magit-status)))

(use-package git-gutter
  :ensure t
  :init
  (global-git-gutter-mode +1))

(setq org-ellipsis "  ⋱ ")
(setq org-startup-indented t)

(use-package htmlize
  :ensure t)

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook #'org-bullets-mode))

(setq org-directory "~/Dropbox/orgfiles")

(use-package quoted-scratch
  :load-path "~/.emacs.d/quoted-scratch/"
  :demand t
  :config
  (progn
    (setq initial-scratch-message nil)
    (add-hook 'emacs-startup-hook
              (lambda ()
                (run-with-timer 1 nil 'qs-refresh-scratch-buffer)
                (qs-refresh-quote-when-idle)))))

;; display “lambda” as “λ”
(global-prettify-symbols-mode 1)

(use-package clojure-mode
  :ensure t
  :config)

(use-package cider
  :ensure t)

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

;;(use-package paredit
;;  :ensure t
;;  :init
;;    (autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
;;    (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
;;    (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
;;    (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
;;    (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
;;    (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
;;    (add-hook 'scheme-mode-hook           #'enable-paredit-mode)

;;    ;; turn on paredit for clojure:
;;    (add-hook 'clojure-mode-hook #'paredit-mode))

(use-package macrostep
  :ensure t
  :bind ("C-c e m" . macrostep-expand)
        ("C-c e c" . macrostep-collapse))

(use-package js2-mode
  :ensure t
  :mode (("\\.js$" . js2-mode)) ;; makes sure we don't use for jsx files, too
  :interpreter ("node" . js2-mode)
  :config
  (setq-default js2-strict-missing-semi-warning nil)
  (add-hook 'js2-mode-hook (lambda () (setq js2-basic-offset 2))))

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
  :ensure t
  :init
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  (add-hook 'web-mode-hook 'prettier-js-mode)
  (setq prettier-js-args
        '("--trailing-comma" "all"
          "--single-quote" "true")))

(use-package sunshine
  :ensure t
  :commands sunshine-forecast
  :config
  (defun echo-file-contents (file-path)
    "Return FILE-PATH's contents."
    (with-temp-buffer
      (insert-file-contents file-path)
      (buffer-string)))
  (setq sunshine-appid (echo-file-contents
                        (expand-file-name "sunshine.key" user-emacs-directory)))
  (setq sunshine-location "Denver, CO, USA")
  (setq sunshine-show-icons t))
