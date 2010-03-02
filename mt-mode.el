;; mt-mode.el
;; functions useful to writing MT code, esp plugins

;; TODO: mt-perl-compile
;; -- figure out what file we're working on
;;   -- is it a plugin?
;; -- find mt root
;; -- run perl -c with correct libs

; (message "loading mt-mode")

(define-minor-mode mt-mode
       "Toggle MT mode.
     With no argument, this command toggles the mode.
     Non-null prefix argument turns on the mode.
     Null prefix argument turns off the mode.
     
     MT mode is enabled, the control delete key
     gobbles all preceding whitespace except the last.
     See the command \\[hungry-electric-delete]."
      ;; The initial value.
      nil
      ;; The indicator for the mode line.
      " MT"
      ;; The minor mode bindings.
      '(("\C-\c?" . mt-perl-compile))
      :group 'MT)

(defun mt-perl-compile ()
  "Call perl -c. 
Runs 'perl -c' on the current buffer, first attempting to locate the file in an MT install and setup the -I libs properly."
  (let ((thisbuf (current-buffer)))
    (message buffer-file-name)))

(mt-perl-compile)