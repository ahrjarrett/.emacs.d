
(use-package evil
   :ensure t
   :init (setq evil-want-C-i-jump nil)
   :config
   (evil-mode 1))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1))

(use-package clojure-mode
  :ensure t
  :config)

(use-package paredit
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
