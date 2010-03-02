;; mt-mode.el
;; functions useful to writing MT code, esp plugins

(defvar mt-home "~/mte"
  "MT_HOME directory")
(defvar mt-config "~/mte/mt-config.cgi" 
  "MT_CONFIG value")

(setq perl-compile-bin (concat "cd " mt-home "; perl -c -Ilib -Iextlib -Iaddons/Commercial.pack/lib -Iaddons/Community.pack/lib "));

(define-minor-mode mt-mode
      "Toggle MT mode.
      With no argument, this command toggles the mode.
      Non-null prefix argument turns on the mode.
      Null prefix argument turns off the mode."
     
      ;; The initial value.
      nil
      ;; The indicator for the mode line.
      " MT"
      ;; The minor mode bindings.
      '(("\C-\c?" . mt-perl-compile))
      :group 'MT)

(defun is-perl-file (file-name)
  "Return t if the file is a perl (.pm, .pl, t) file"
  (if (string-match "\\(\\.pm\\|\\.pl\\|\\.t\\)$" file-name)
      t
    nil))

(defun is-plugin-file (file-name)
  "Return t if the path represents a plugin file (contains 'plugins' - simple but effective for now)"
  (if (and
       (is-perl-file file-name)
       (string-match "plugins" file-name))
      t
    nil))

(defun mt-rel-path (file-name)
  "return the path relative to mt-home"
  ; full file path - mt-home
  (if (string-match mt-home file-name)
      (substring file-name (length mt-home))
    (substring file-name (string-match "plugins" file-name))))

(defun mt-perl-compile ()
  "Call perl -c. 
Runs 'perl -c' on the current buffer, first attempting to locate the file in an MT install and setup the -I libs properly."
  (interactive)
  (setq perl-compile-command  (concat 
	perl-compile-bin
	(mt-rel-path buffer-file-name)))
  (if (not (is-perl-file buffer-file-name))
      (message (concat "file " (file-name-nondirectory buffer-file-name) " is not a perl file!"))
    (with-output-to-temp-buffer "perl-c" 
      (message perl-compile-command)
      (print (concat "perl- c output: " (shell-command-to-string 
       perl-compile-command))))))

; testing
; (mt-perl-compile)

; Notes
; "Symbol's function definition is void"
;  -- you may have wrapped a variable arg to a function in (), so it's trying to call the var as a function
;  -- i.e. (length (some-var)) ; some-var is not a function