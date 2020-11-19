(require 'lsp-mode)

(defun register-esy-ocaml-lsp ()
  (interactive)
(lsp-register-client
 (make-lsp-client
  :new-connection
  (lsp-stdio-connection (executable-find "ocamllsp"))
  :major-modes '(caml-mode tuareg-mode)
  :priority 0
  :server-id 'esy-ocaml-lsp-server)))
