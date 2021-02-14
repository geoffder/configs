(defun victor-font-settings ()
  (setq doom-font (font-spec :name "Victor Mono" :size 14 :weight 'semi-bold))
  (set-face-attribute 'font-lock-comment-face nil :slant 'italic)
  (set-face-attribute 'font-lock-keyword-face nil :weight 'bold :slant 'italic)
  (add-hook 'tuareg-mode-hook
            '(lambda () (set-face-attribute
                    'tuareg-font-lock-governing-face nil :slant 'italic))))

(defun fira-font-settings ()
  (setq doom-font (font-spec :family "Fira Code" :size 14))
  (set-face-attribute 'font-lock-keyword-face nil :weight 'semi-bold))

;; (fira-font-settings)
(victor-font-settings)
(setq doom-variable-pitch-font (font-spec :family "Roboto" :size 18))
(setq doom-unicode-extra-fonts (append '("PowerlineSymbols") doom-unicode-extra-fonts))

;; Helpers to remove some prettify rules that I don't like.
(require 'seq)
(defun assoc-delete-all-multi (keys alist)
  (seq-reduce (lambda (al key) (assoc-delete-all key al)) keys alist))

(defun trim-prettify-rules ()
  (interactive)
  (setq-local
   prettify-symbols-alist (assoc-delete-all-multi
                           '("and" "or" "&&" "||" "<-" "<=" ">=" "<>" "==" "!="
                             "<=>" "not" "->" ":=" "::")
                           prettify-symbols-alist)))
