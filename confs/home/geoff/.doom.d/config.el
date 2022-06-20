;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq user-full-name "Geoff deRosenroll"
      user-mail-address "geoffderosenroll@gmail.com")

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-molokai t))

(setq org-directory "~/org/")

(setq display-line-numbers-type 'relative)

;; org-mode related settings
(load! "org-config")

;; font related settings
(load! "fonts")

;; transparency with toggle function (bound in bindings.el)
(load! "transparency")

;; Config related to remote editing / ssh
(load! "remote")

;; Personal bindings file
(load! "bindings")

;; Set cursor colour (explicitly) to solve issue with emacsclient
(load! "daemon-cursor-fix")

;; Paint hex colour codes with the colour the represent (in some modes).
(load! "hexcolour-font-lock")

(add-hook! '(csharp-mode-hook
             elixir-mode-hook
             emacs-lisp-mode-hook
             fsharp-mode-hook
             haskell-mode-hook
             python-mode-hook
             sh-mode-hook
             tuareg-mode-hook
             reason-mode-hook)
           '((lambda () (text-scale-set 1))           ;; zoom one level
             (lambda () (size-indication-mode -1))    ;; de-clutter from modeline
             display-fill-column-indicator-mode  ;; vertical rule
             trim-prettify-rules))               ;; remove some symbols

;; Reminder to keep lines short. (display-fill-column-indicator-mode)
(setq fill-column 80)

;; Automatic physical wrapping of lines longer than fill-column in select modes.
;; (add-hook! '(markdown-mode-hook
;;              ;; text-mode-hook
;;              latex-mode-hook)
;;            '(lambda () (auto-fill-mode t)))
(add-hook 'markdown-mode-hook '(lambda () (auto-fill-mode t)))
(add-hook 'text-mode-hook '(lambda () (auto-fill-mode t)))
;; (add-hook 'org-mode-hook '(lambda () (auto-fill-mode t)))

;; might make this pair a defun and add to the general coding mode hooks above

(add-to-list 'auto-mode-alist '("\\.mld\\'" . tuareg-mode))

;; TODO: check if the wrap already exists, since I might need to add the advice to
;; some additional functions to make sure this happens more reliably (avoid nested wrapping)
(defun is-mld ()
  (string-equal "mld" (file-name-extension buffer-file-name)))

(defun doc-wrap ()
  (save-excursion
    (goto-char (point-min))
    (insert "(** ")
    (goto-char (point-max))
    (insert " *)")))

(defun doc-unwrap ()
  (save-excursion
    (goto-char (point-min))
    (delete-char 4)
    (goto-char (point-max))
    (delete-char -3)))

(defun doc-wrapping-advice (fontify &rest args)
  (if (is-mld)
     (progn
       (doc-wrap)
       (apply fontify args)
       (doc-unwrap))
     (apply fontify args)))

(add-hook 'before-save-hook
          (lambda ()
            (when (and (eq major-mode 'tuareg-mode)
                       (not (is-mld)))
              (ocamlformat))))

(add-hook 'lsp-mode-hook
          (lambda ()
            (when (and (eq major-mode 'tuareg-mode)
                      lsp-mode
                      (is-mld))
              (lsp-disconnect))))

(add-hook! '(tuareg-mode-hook)
           '((lambda ()
               (auto-fill-mode t)
               (setq-local comment-auto-fill-only-comments t)
               ;; (setq-local comment-continue "   ")
               (setq-local fill-prefix "   ")
               (setq-local comment-multi-line t)
               ;; (advice-add 'font-lock-fontify-region :around #'doc-wrapping-advice)
               (advice-add 'jit-lock--run-functions :around #'doc-wrapping-advice))))

(use-package org-tempo
  :ensure nil) ;; tell use-package not to try to install org-tempo since it's already there.

;; Remove buffer encoding format from modeline (never need to know)
(setq doom-modeline-buffer-encoding nil)

;; Only cycle through currently visible tabs
(setq centaur-tabs-cycle-scope 'tabs)
;; Match tab bar coloru with rest of theme.
(after! centaur-tabs (centaur-tabs-headline-match))

(use-package! hideshow
  :config
  ;; extra folding support for more languages
  (setq hs-special-modes-alist
        (append
         '((fsharp-mode "\\(=\\|{\\|->\\)"
                        "\\(}\\)"
                        "//"
                        +fold-hideshow-forward-block-by-indent-fn
                        nil)
           (tuareg-mode "\\(struct\\|: sig\\|=\\|{\\)"
                        "\\(end\\|in\\|}\\)"
                        nil
                        nil
                        nil))
         hs-special-modes-alist)))

;; Autocompletion config
(setq company-idle-delay 0.1)
(setq company-minimum-prefix-length 2)
(set-company-backend!
  '(csharp-mode python-mode fsharp-mode haskell-mode sh-mode)
  'company-files)

(require 'company-lsp)
(push 'company-lsp company-backends)

(add-hook! 'before-save-hook '(delete-trailing-whitespace))
(add-hook 'dune-mode-hook 'dune-format-on-save-mode)

(after! projectile
  (setq projectile-globally-ignored-directories
        (append '("**/_build/" "*_build") projectile-globally-ignored-directories)))

;; (require 'eglot-fsharp)  ;; if lsp is not working.
;; (add-hook 'fsharp-mode-hook 'eglot-ensure)
(setq inferior-fsharp-program "/usr/bin/fsharpi --readline-")
(setq-default fsharp-indent-offset 2)
;; NOTE: Attempting to use all-the-icons font for the tab-line in fsharp-mode
;; buffers causes huge slowdowns when navigating or inserting, I imagine due to
;; those actions triggering redraws.
;; Disabling column-number-mode and line-number-mode restores speed in normal
;; mode navigation, but this fixes both normal and insert modes.
(add-hook 'fsharp-mode-hook '(lambda () (setq-local centaur-tabs-set-icons nil)))

;; Add match! to font-lock's keyword list for F#
(add-hook 'fsharp-mode-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("match!" (0 font-lock-keyword-face))))))

(custom-set-variables
 '(conda-anaconda-home "/home/geoff/miniconda3"))

;; Add python buffer directories to import path vector of the mspy lsp
(setq lsp-python-ms-extra-paths [])
(defun get-dir () (substring default-directory 0 -1))
(add-hook 'python-mode-hook
          (lambda ()
            (setq lsp-python-ms-extra-paths
                  (vconcat lsp-python-ms-extra-paths (vector (get-dir))))))

;; Qtile does not live in conda, so adding the system-wide packages to path
;; when working on it's config
(add-hook 'python-mode-hook
          (lambda ()
            (if (string-equal (get-dir) "/home/geoff/.config/qtile")
                (setq lsp-python-ms-extra-paths
                      (vconcat
                       lsp-python-ms-extra-paths
                       (vector "/usr/lib/python3.9/site-packages"))))))

;; Replace the hs-special-modes-alist entry that python-mode creates.
(require 'seq)
(defun replace-python-hs-rules ()
  (interactive)
  (setq hs-special-modes-alist
        (append '((python-mode "\\(?:def.*:\\|class\\|{\n\\|if.*:\\|for.*:\\|):\n\\)"
                               "\\(}\\)"
                               "#"
                               +fold-hideshow-forward-block-by-indent-fn
                               nil))
                (seq-filter (lambda (l) (not (eq (car l) 'fsharp-mode)))
                            hs-special-modes-alist))))

(add-hook! 'python-mode-hook 'replace-python-hs-rules)

;; autoformatting for python
;; (set-formatter! 'yapf '("yapf" "-q"
;;   "--style={\
;; based_on_style: facebook,\
;; column_limit: 90,\
;; }"))
;; (after! format-all (advice-add 'format-all-buffer :around #'envrc-propagate-environment))
;; (setq-hook! 'python-mode-hook +format-with 'yapf)

;; OCaml automatic block closing pairs.
(use-package! smartparens-config
  :config
  (add-hook 'tuareg-mode-hook (lambda () (setq-local sp-max-pair-length 8)))
  (sp-local-pair 'tuareg-mode "begin"  "\nend")
  (sp-local-pair 'tuareg-mode "struct\n" "\nend")
  (sp-local-pair 'tuareg-mode "sig\n" "\nend"))

(load! "esy-mode")
(add-hook 'tuareg-mode-hook 'esy-mode)

;; Support for reason-ml
;; Requires { ... "@opam/merlin": "*", } in esy package.json dependencies.

(defun my-reason-font-lock ()
  (interactive)
  (font-lock-add-keywords
   nil
   '(("let%" 0 font-lock-keyword-face)
     ;; Apply highlighting to second group (1)
     ("\\(?:let%\\)\\([a-z]+\\)" 1 font-lock-type-face))))

(after! reason-mode
  (add-hook! reason-mode #'lsp)
  (add-hook! 'reason-mode-hook '(esy-mode my-reason-font-lock)))

(require 'lsp-mode)

(defcustom lsp-ocaml-lsp-server-command
  '("ocamllsp")
  "Command to start ocaml-language-server."
  :group 'lsp-ocaml
  :type '(choice
          (string :tag "Single string value")
          (repeat :tag "List of string values"
                  string)))

(after! lsp-mode
  (lsp-register-client
   (make-lsp-client
    :new-connection
    (lsp-stdio-connection (lambda () lsp-ocaml-lsp-server-command))
    :major-modes '(caml-mode tuareg-mode)
    :priority 0
    :server-id 'ocaml-lsp-server))
  ;; not sure why this is necessary, I guess it doesn't like that extensions are different
  (lsp-register-client
   (make-lsp-client
    :new-connection
    (lsp-stdio-connection (lambda () lsp-ocaml-lsp-server-command))
    :major-modes '(reason-mode)
    :priority 1
    :server-id 'reason-lsp-server))

  ;; (add-hook 'tuareg-mode-hook (lambda () (lsp-lens-mode -1))))
  (setq lsp-lens-enable nil))


;; prevent auto-format in qmk configs
(add-hook 'c-mode-hook
  (lambda () (if (string-match-p (regexp-quote "qmk_firmware") (file-name-directory buffer-file-name))
      (setq-local +format-with-lsp nil
                  +format-with :none))))
