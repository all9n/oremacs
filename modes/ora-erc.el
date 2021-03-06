(require 'erc)

(setq erc-fill-function 'erc-fill-static)
(setq erc-fill-static-center 22)
(setq erc-hide-list '("JOIN" "PART" "QUIT"))
(setq erc-lurker-hide-list '("JOIN" "PART" "QUIT"))
(setq erc-track-exclude-types '("JOIN" "KICK" "NICK" "PART" "QUIT" "MODE"
                                "324" "329" "332" "333" "353" "477"))

(add-to-list 'erc-modules 'notifications)
(add-to-list 'erc-modules 'spelling)
(add-to-list 'erc-modules 'dcc)
(add-to-list 'erc-modules 'keep-place)
(erc-update-modules)
(require 'erc-log)
(setq-default erc-enable-logging t)
(setq erc-log-channels-directory
      (file-name-as-directory
       (concat user-emacs-directory "erc")))
(setq erc-log-write-after-insert t)
(setq erc-log-write-after-send t)

(setq erc-server "localhost")
(setq erc-nick "oleh")
(setq erc-port 6667)
(setq erc-accidental-paste-threshold-seconds nil)
(setq erc-prompt-for-password nil)
(defvar ora-erc-buddies nil
  "An alist of buddies with the lanugage that they prefer.")

;; Bitlbee/Hangouts can handle this message length.  The default value
;; of 440 causes a split even in a simple 100 char Ukrainian message.
(setq erc-split-line-length 4000)

;;;###autoload
(defun ora-erc-hook ()
  (setq-local scroll-margin 1)
  (erc-log-mode 1)
  (unless (bound-and-true-p flyspell-mode)
    (let ((fly (assoc (buffer-name) ora-erc-buddies)))
      (when fly
        (activate-input-method
         default-input-method)
        (ispell-change-dictionary (cadr fly))
        (flyspell-mode 1)))))

;; don't change the modeline every time someone goes online/offline
(ora-advice-add 'erc-modified-channels-object :around #'ora-erc-modified-channels-object)
(defun ora-erc-modified-channels-object (_func strings)
  "Generate a new `erc-modified-channels-object' based on STRINGS."
  (if strings
      (concat (if (eq erc-track-position-in-mode-line 'after-modes)
                  "[" " [")
              (mapconcat 'identity (nreverse (delete "&" strings)) ",")
              (if (eq erc-track-position-in-mode-line 'before-modes)
                  "] " "]"))
    ""))

;;;###autoload
(defun bitlbee ()
  (interactive)
  (save-window-excursion
    (let ((b (get-buffer "localhost:6667")))
      (when b
        (kill-buffer b)))
    (erc
     :server "localhost"
     :nick "oleh")))

(defun ora-pcomplete-erc-all-nicks (old-fun)
  (append '() (funcall old-fun)))

(ora-advice-add 'pcomplete-erc-all-nicks :around 'ora-pcomplete-erc-all-nicks)

(require 'pora-erc nil t)
(provide 'ora-erc)
