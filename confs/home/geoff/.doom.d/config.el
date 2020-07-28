;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq user-full-name "Geoff deRosenroll"
      user-mail-address "geoffderosenroll@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; test
(setq doom-font (font-spec :family "Fira Code" :size 14)
      doom-variable-pitch-font (font-spec :family "Roboto"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-molokai t))

(set-face-attribute 'font-lock-comment-face nil :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil :weight 'semi-bold)

;; transparency with toggle function (bound in bindings.el)
(load! "transparency")

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/org/")

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)

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

;; Config related to remote editing / ssh
(load! "remote")

;; Personal bindings file
(load! "bindings")

;; Enable FiraCode ligatures.
(load! "pretty-fira")

;; Set cursor colour (explicitly) to solve issue with emacsclient
(load! "daemon-cursor-fix")

;; Start one level zoomed in for some buffers.
(add-hook! '(csharp-mode-hook
             elixir-mode-hook
             emacs-lisp-mode-hook
             fsharp-mode-hook
             haskell-mode-hook
             python-mode-hook
             sh-mode-hook
             tuareg-mode-hook)
           '((lambda () (text-scale-set 1))))

(setq fill-column 80)
(setq display-line-numbers-type 'relative)

;; Only cycle through currently visible tabs
(setq centaur-tabs-cycle-scope 'tabs)

(use-package! hideshow
  :config
  ;; extra folding support for more languages
  (setq hs-special-modes-alist
        (append
         '((fsharp-mode "\\s-*\\_<\\(?:[^(?:=|{)]+\\)\\_>"
                        "(?:|})"
                        "//"
                        +fold-hideshow-forward-block-by-indent-fn
                        nil)
           (tuareg-mode "\\(struct\\|=\\|{\\)"
                        "\\(end\\|in\\|}\\)"
                        nil
                        nil
                        nil)
           )
         hs-special-modes-alist)))

;; Autocompletion config
(setq company-idle-delay 0.1)
(setq company-minimum-prefix-length 2)
(set-company-backend!
  '(csharp-mode python-mode fsharp-mode haskell-mode sh-mode)
  'company-files)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; (require 'eglot-fsharp)  ;; if lsp is not working.
;; (add-hook 'fsharp-mode-hook 'eglot-ensure)
(setq inferior-fsharp-program "/usr/bin/fsharpi --readline-")
(setq-default fsharp-indent-offset 2)

;; Add match! to font-lock's keyword list for F#
(add-hook 'fsharp-mode-hook
         (lambda ()
          (font-lock-add-keywords nil
           '(("match!" 0
              font-lock-keyword-face t)))))

(custom-set-variables
 '(conda-anaconda-home "/home/geoff/miniconda3"))

;; Add python buffer directories to import path vector of the mspy lsp
(setq lsp-python-ms-extra-paths [])
(defun get-dir () (substring default-directory 0 -1))
(add-hook 'python-mode-hook
          (lambda ()
            (setq lsp-python-ms-extra-paths
                  (vconcat lsp-python-ms-extra-paths (vector (get-dir))))))
