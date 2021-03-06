(require 'haskell)
(require 'lpy-soap)
(require 'company-dabbrev)

(defun ora-haskell-comment-insert ()
  (insert "-- "))

(defun ora-haskell-completion-at-point ()
  (let* ((bnd (bounds-of-thing-at-point 'symbol))
         (prefix (buffer-substring-no-properties (car bnd) (cdr bnd)))
         (cands (save-excursion
                  (delete-dups
                   (all-completions
                    prefix
                    (company-dabbrev--search "\\(?:\\sw\\)+" company-dabbrev-time-limit 'all))))))
    (when cands
      (list (car bnd) (cdr bnd) cands))))

;;;###autoload
(defun ora-haskell-hook ()
  (setq comment-insert-comment-function #'ora-haskell-comment-insert)
  (cl-pushnew #'ora-haskell-completion-at-point completion-at-point-functions)
  ;; (setq haskell-literate 'bird)
  (company-mode))

(defun ora-haskell-colon ()
  (interactive)
  (cond ((looking-back ":")
         (delete-char -1)
         (insert " :: "))
        (t
         (insert ":"))))

(dolist (k '("=" "+" "-" "<" ">" "," "^"))
  (define-key haskell-mode-map k 'lpy-soap-command))

(define-key haskell-mode-map ":" 'ora-haskell-colon)

(require 'pora-haskell nil t)

(provide 'ora-haskell)
