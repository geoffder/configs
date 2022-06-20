(add-hook 'org-mode-hook 'org-indent-mode)

(setq org-directory "~/Org/"
      org-agenda-files '("~/Org/agenda.org")
      org-default-notes-file (expand-file-name "notes.org" org-directory)
      org-ellipsis " ▼ "
      org-log-done 'time
      org-journal-dir "~/Org/journal/"
      org-journal-date-format "%B %d, %Y (%A) "
      org-journal-file-format "%Y-%m-%d.org"
      org-hide-emphasis-markers t)

(setq org-src-preserve-indentation nil
      org-src-tab-acts-natively t
      org-edit-src-content-indentation 0)

;; unicode bullets replace asterisks for headings
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; same syntax highlighting as in the native language files
(setq org-src-fontify-natively t
    org-src-tab-acts-natively t
    org-confirm-babel-evaluate nil
    org-edit-src-content-indentation 0)

;; table of contents generation
(use-package toc-org
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))

;; Make M-RET Not Add Blank Lines
(setq org-blank-before-new-entry (quote ((heading . nil)
                                         (plain-list-item . nil))))
