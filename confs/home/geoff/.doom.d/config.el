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
(setq doom-font (font-spec :family "FiraCode" :size 14)
      doom-variable-pitch-font (font-spec :family "sans"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-molokai)

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

;; Personal bindings file
(load! "bindings")

;; Enable FiraCode ligatures. Add hooks for any buffer types I want them in
(load! "pretty-fira")
(add-hook 'csharp-mode-hook 'fira-code-mode)
(add-hook 'python-mode-hook 'fira-code-mode)
(add-hook 'elixir-mode-hook 'fira-code-mode)
(add-hook 'fsharp-mode-hook 'fira-code-mode)

(setq fill-column 80)

(custom-set-variables
 '(conda-anaconda-home "/home/geoff/miniconda3"))

;; (add-hook 'python-mode-hook #'+format|enable-on-save)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(require 'eglot-fsharp)
(add-hook 'fsharp-mode-hook 'eglot-ensure)
(setq inferior-fsharp-program "/usr/bin/fsharpi --readline-")
(setq-default fsharp-indent-offset 4)

;; Add match! to font-lock's keyword list for F#
(add-hook 'fsharp-mode-hook
         (lambda ()
          (font-lock-add-keywords nil
           '(("match!" 0
              font-lock-keyword-face t)))))
