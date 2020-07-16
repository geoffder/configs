;; When running Emacs in daemon mode, cursor colour is altered by Xresources
;; This changes it back.
(require 'frame)
(defun set-cursor-hook (frame)
(modify-frame-parameters
  frame (list (cons 'cursor-color "#fb2874"))))  ;; molokai magenta

(add-hook 'after-make-frame-functions 'set-cursor-hook)
