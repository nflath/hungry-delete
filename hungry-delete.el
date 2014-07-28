;;; hungry-delete.el --- hungry delete minor mode

;; Copyright (C) 2009 Nathaniel Flath <flat0103@gmail.com>

;; Author: Nathaniel Flath <flat0103@gmail.com>
;; URL: http://github.com/nflath/hungry-delete
;; Version: 1.0

;; This file is not part of GNU Emacs.

;;; Commentary:

;; cc-mode implements hungry deletion for its programming modes. This
;; package borrows its implementation in a minor mode, so that hungry
;; deletion can be used in all modes.

;;; Installation

;; To use this mode, put the following in your init.el:
;; (require 'hungry-delete)

;; You then need to enable hungry-delete-mode, either in
;; relevant hooks, with turn-on-hungry-delete-mode, or with
;; global-hungry-delete-mode.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(defvar hungry-delete-mode-map (make-keymap)
  "Keymap for hungry-delete-minor-mode.")
(define-key hungry-delete-mode-map [remap delete-forward-char] 'hungry-delete-forward)
(define-key hungry-delete-mode-map [remap delete-backward-char] 'hungry-delete-backward)
(define-key hungry-delete-mode-map [remap backward-delete-char-untabify] 'hungry-delete-backward)

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

;;;###autoload
(defun hungry-delete-forward ()
  "Delete the following character or all following whitespace up
to the next non-whitespace character.  See
\\[c-hungry-delete-backward].

Like delete-forward-char, hungry-delete-forward obeys Transient
Mark Mode: if the region is activate, it deletes the text in the
region."
  (interactive)
  (cond ((and (use-region-p)
	      delete-active-region)
	 ;; If a region is active, kill or delete it.
	 (if (eq delete-active-region 'kill)
	     (kill-region (region-beginning) (region-end))
	   (delete-region (region-beginning) (region-end))))
	;; Otherwise, call hungry-delete-forward-iter.
	(t (hungry-delete-forward-iter))))

(defun hungry-delete-forward-iter ()  
  (let ((here (point)))
    (hungry-delete-skip-ws-forward)
    (if (/= (point) here)
        (delete-region (point) here)
      (let ((hungry-delete-mode nil))
        (delete-char 1)))))

;;;###autoload
(defun hungry-delete-backward ()
  "Delete the preceding character or all preceding whitespace
back to the previous non-whitespace character.  See also
\\[c-hungry-delete-forward].

Like delete-backward-char, hungry-delete-backward obeys Transient
Mark Mode: if the region is activate, it deletes the text in the
region."
  (interactive)
  (cond ((and (use-region-p)
	      delete-active-region)
	 ;; If a region is active, kill or delete it.
	 (if (eq delete-active-region 'kill)
	     (kill-region (region-beginning) (region-end))
	   (delete-region (region-beginning) (region-end))))
	;; Otherwise, call hungry-delete-backward-iter.
	(t (hungry-delete-backward-iter))))

(defun hungry-delete-backward-iter ()
  (let ((here (point)))
    (hungry-delete-skip-ws-backward)
    (if (/= (point) here)
        (delete-region (point) here)
      (let ((hungry-delete-mode nil))
        (delete-char -1)))))

;;;###autoload
(define-minor-mode hungry-delete-mode
  "Minor mode to enable hungry deletion.  This will delete all
whitespace after or before point when the deletion command is
executed."
  :init-value nil
  :group 'hungry-delete)

;;;###autoload
(defun turn-on-hungry-delete-mode ()
  "Turns on hungry delete mode if the buffer is appropriate."
  (unless (or (window-minibuffer-p (selected-window))
              (equal (substring (buffer-name) 0 1) " ")
              (eq major-mode 'help-mode ))
    (hungry-delete-mode t)))

;;;###autoload
(define-globalized-minor-mode global-hungry-delete-mode hungry-delete-mode turn-on-hungry-delete-mode)

(provide 'hungry-delete)
;;; hungry-delete.el ends here
