(defun victor-mono-mode--make-alist (start list)
  "Generate prettify-symbols alist from LIST."
  (let ((idx -1))
    (mapcar
     (lambda (s)
       (setq idx (1+ idx))
       (let* ((code (+ start idx))
              (width (string-width s))
              (prefix ())
              (suffix '(?\s (Br . Br)))
              (n 1))
         (while (< n width)
           (setq prefix (append prefix '(?\s (Br . Bl))))
           (setq n (1+ n)))
         (cons s (append prefix suffix (list (decode-char 'ucs code))))))
     list)))

(defconst victor-mono-mode--ligatures
  '("-->" "-|" "->" "->>" "-<" "-<<" "-~" ".-" ".=" "::" ":=" ":>" ":<" ";;"
    "!=" "!==" "?=" "##" "###" "####" "/=" "/==" "/>" "/\\" "\\/" "__" "&&"
    "|-" "|->" "|-<" "|=" "|=>" "|>" "$>" "++" "+++" "+>" "=:=" "=!=" "=="
    "===" "==>" "=>" "=>>" "=<<" "=/=" ">-" ">-|" ">->" ">:" ">=" ">=>"
    ">>-" ">>=" "<-" "<--" "<-|" "<->" "<-<" "<!--" "<|" "<|>" "<$" "<$>"
    "<+" "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<-" "<<=" "<~" "<~>" "<~~" "</"
    "</>" "~-" "~@" "~>" "~~" "~~>"))

(defvar victor-mono-mode--old-prettify-alist)

(defun victor-mono-mode--enable ()
  "Enable Victor Mono ligatures in current buffer."
  (setq-local victor-mono-mode--old-prettify-alist prettify-symbols-alist)
  (setq-local prettify-symbols-alist
              (append
               (victor-mono-mode--make-alist #Xe100 victor-mono-mode--ligatures)
               victor-mono-mode--old-prettify-alist))
  (prettify-symbols-mode t))

(defun victor-mono-mode--disable ()
  "Disable Victor Mono ligatures in current buffer."
  (setq-local prettify-symbols-alist victor-mono-mode--old-prettify-alist)
  (prettify-symbols-mode -1))

(define-minor-mode victor-mono-mode
  "Victor Mono ligatures minor mode"
  :lighter "Victor Mono"
  (setq-local prettify-symbols-unprettify-at-point 'right-edge)
  (if victor-mono-mode
      (victor-mono-mode--enable)
    (victor-mono-mode--disable)))

(defun victor-mono-mode--setup ()
 "Setup Victor Mono Symbols"
 (set-fontset-font "fontset-default" '(#Xe100 . #Xe16f) "Victor Mono Symbol"))

(provide 'victor-mono-mode)

(defun maybe-victor-mode ()
  (interactive)
  (when (string-match "Victor" (format "%s" doom-font))
    (victor-mono-mode t)))

(add-hook! '(csharp-mode-hook
             elixir-mode-hook
             emacs-lisp-mode-hook
             fsharp-mode-hook
             haskell-mode-hook
             python-mode-hook
             sh-mode-hook
             tuareg-mode-hook
             reason-mode-hook)
           'maybe-victor-mode)
