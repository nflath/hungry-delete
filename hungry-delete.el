;; hungry-delete.el - hungry delete minor mode
;;
;; Copyright (C) 2009 Nathaniel Flath <nflath@gmail.com>
;; Version: 1.0
;;
;; Commentary:
;;
;; This file contains all the necessary functions and macros, taken from
;; cc-mode, to implement hungry deletion without relying on cc-mode.  This
;; allows it to be used more easily in all modes, as it is now a minor mode in
;; it's own right.  global-hungry-delete-mode will turn on hungry-delete-mode in
;; all buffers.
;;
;; To use this mode, just put the following in your .emacs file:
;;
;; (require 'hungry-delete)
;; (global-hungry-delete-mode)
;;
;; Code:

(defvar hungry-delete-mode-map (make-keymap)
  "Keymap for hungry-delete-minor-mode.")
(define-key hungry-delete-mode-map (kbd "C-d") 'hungry-delete-forward)
(define-key hungry-delete-mode-map (kbd "DEL") 'hungry-delete-forward)
(define-key hungry-delete-mode-map (kbd "<backspace>") 'hungry-delete-backwards)

(defmacro hungry-delete-skip-ws-forward (&optional limit)
  "Skip over any whitespace following point.
This function skips over horizontal and vertical whitespace and line
continuations."
  (if limit
      `(let ((limit (or ,limit (point-max))))
         (while (progn
                  ;; skip-syntax-* doesn't count \n as whitespace..
                  (skip-chars-forward " \t\n\r\f\v" limit)
                  (when (and (eq (char-after) ?\\)
                             (< (point) limit))
                    (forward-char)
                    (or (eolp)
                        (progn (backward-char) nil))))))
    '(while (progn
              (skip-chars-forward " \t\n\r\f\v")
              (when (eq (char-after) ?\\)
                (forward-char)
                (or (eolp)
                    (progn (backward-char) nil)))))))

(defmacro hungry-delete-skip-ws-backward (&optional limit)
  "Skip over any whitespace preceding point.
This function skips over horizontal and vertical whitespace and line
continuations."
  (if limit
      `(let ((limit (or ,limit (point-min))))
         (while (progn
                  ;; skip-syntax-* doesn't count \n as whitespace..
                  (skip-chars-backward " \t\n\r\f\v" limit)
                  (and (eolp)
                       (eq (char-before) ?\\)
                       (> (point) limit)))
           (backward-char)))
    '(while (progn
              (skip-chars-backward " \t\n\r\f\v")
              (and (eolp)
                   (eq (char-before) ?\\)))
       (backward-char))))

(defun hungry-delete-forward ()
  "Delete the following character or all following whitespace up
to the next non-whitespace character.  See
\\[c-hungry-delete-backwards]."
  (interactive)
  (let ((here (point)))
    (hungry-delete-skip-ws-forward)
    (if (/= (point) here)
        (delete-region (point) here)
      (delete-char 1))))

(defun hungry-delete-backwards ()
  "Delete the preceding character or all preceding whitespace
back to the previous non-whitespace character.  See also
\\[c-hungry-delete-forward]."
  (interactive)
  (let ((here (point)))
    (c-skip-ws-backward)
    (if (/= (point) here)
        (delete-region (point) here)
      (delete-char 1))))

(define-minor-mode hungry-delete-mode
  "Minor mode to enable hungry deletion.  This will delete all
whitespace after or before point when the deletion command is
executed."
  :init-value nil
  :global t
  :group 'hungry-delete)

(defun turn-on-hungry-delete-mode ()
  "Turns on hungry delete mode if the buffer is appropriate."
  (unless (or (window-minibuffer-p (selected-window))
              (equal (substring (buffer-name) 0 1) " "))
    (hungry-delete-mode t)))

(easy-mmode-define-global-mode global-hungry-delete-mode hungry-delete-mode turn-on-hungry-delete-mode)

(provide 'hungry-delete)