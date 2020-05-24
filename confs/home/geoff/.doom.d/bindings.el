;;; C-c as general purpose escape key sequence. (From evil wiki)
;;;
(defun my-esc (prompt)
  "Functionality for escaping generally.  Includes exiting Evil insert state and C-g binding. "
  (cond
   ;; If we're in one of the Evil states that defines [escape] key, return [escape] so as
   ;; Key Lookup will use it.
   ((or (evil-insert-state-p) (evil-normal-state-p) (evil-replace-state-p) (evil-visual-state-p)) [escape])
   ;; This is the best way I could infer for now to have C-c work during evil-read-key.
   ;; Note: As long as I return [escape] in normal-state, I don't need this.
   ;;((eq overriding-terminal-local-map evil-read-key-map) (keyboard-quit) (kbd ""))
   (t (kbd "C-g"))))
(define-key key-translation-map (kbd "C-c") 'my-esc)
;; Works around the fact that Evil uses read-event directly when in operator state, which
;; doesn't use the key-translation-map.
(define-key evil-operator-state-map (kbd "C-c") 'keyboard-quit)
;; Not sure what behavior this changes, but might as well set it, seeing the Elisp manual's
;; documentation of it.
(set-quit-char "C-c")

;;Vim like tab cycling for centaur tabs
(define-key evil-normal-state-map (kbd "g t") 'centaur-tabs-forward)
(define-key evil-normal-state-map (kbd "g T") 'centaur-tabs-backward)
;;Cycle between tab groups
(define-key evil-normal-state-map (kbd "g <left>") 'centaur-tabs-backward-group)
(define-key evil-normal-state-map (kbd "g <right>") 'centaur-tabs-forward-group)

(map! :leader
      :desc "transparency" "t t" #'toggle-transparency)

(map! :leader
        (:prefix-map ("z" . "folding")
         :desc "open all" "o" #'+fold/open-all
         :desc "close all" "c" #'+fold/close-all))
