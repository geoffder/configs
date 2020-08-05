;; https://www.emacswiki.org/emacs/HexColour
(defvar hexcolour-keywords
  '(("#[abcdefABCDEF[:digit:]]\\{6\\}"
     (0 (put-text-property (match-beginning 0)
                           (match-end 0)
                           'face (list :background
                                       (match-string-no-properties 0)))))))

(defun hexcolour-add-to-font-lock ()
  (font-lock-add-keywords nil hexcolour-keywords))

(add-hook! '(conf-colon-mode-hook
             conf-space-mode-hook
             css-mode-hook
             html-mode-hook)
           'hexcolour-add-to-font-lock)
