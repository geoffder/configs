(load! "dired-toggle-sudo")

;; remote access to shake server
(defun connect-shake ()
  (interactive)
  (dired "/ssh:geoff@162.213.253.153:/"))

(defun connect-shake-sudo ()
  (interactive)
  (dired "/sudo:geoff@162.213.253.153:/"))

;; tramp config
(setq tramp-default-method "ssh")
(eval-after-load 'tramp
 '(progn
    ;; Allow to use: /sudo:user@host:/path/to/file
    (add-to-list 'tramp-default-proxies-alist
                 '(".*" "\\`.+\\'" "/ssh:%h:"))))
