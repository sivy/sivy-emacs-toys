;;; mt-mode.el --- minor mode for writing MT code, esp plugins

;; Copyright (C) 2010 Steve Ivy
;; Author: Steve Ivy <sivy@sixapart.com>
;;    David Raynes <rayners@sixapart.com>
;; Maintainer: Steve Ivy <sivy@sixapart.com>
;; Created: 01 Mar 2010
;; Version: 0.2
;; Keywords: movabletype

(defcustom mt-home "~/mte"
  "MT_HOME directory"
  :type 'string
  :group 'MT)

(defcustom mt-config "~/mte/mt-config.cgi" 
  "MT_CONFIG value"
  :type 'string
  :group 'MT)

(setq perl-compile-bin (concat "cd " mt-home "; perl -c -Ilib -Iextlib -Iaddons/Commercial.pack/lib -Iaddons/Community.pack/lib "));
(setq prove-bin (concat "cd " mt-home "; prove -v "));

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
  "Return t if the file is a perl (.pm, .pl) file."
  (if (string-match "\\(\\.pm\\|\\.pl\\)$" file-name)
      t
    nil))

(defun is-test-file (file-name)
  "Return t if the file is a unit test (.t) file."
  (if (string-match "\\.t$" file-name)
      t
    nil))

(defun is-plugin-file (file-name)
  "Return t if the path represents a plugin file.
   Return t is the path contains 'plugins' - simple but effective for now."
  (if (string-match "plugins" file-name)
      t
    nil))

(defun plugin-lib-dir (file-name)
  "Return an mt-relative path to a plugin's lib directory"
  (if (not (is-plugin-file file-name))
      nil
    (substring file-name 0 
	       (+ 
		(string-match "lib" file-name) 
		3))))

(defun mt-rel-path (file-name)
  "Determine a file's path relative to mt-home"
  (message file-name)
  (cond ((string-match mt-home file-name)
	 (substring file-name (+ (length mt-home) 1)))
	((is-plugin-file file-name)
	 (substring file-name (string-match "plugins" file-name)))
	))

(defun mt-perl-compile ()
  "Call perl -c. 
Runs 'perl -c' on the current buffer, first attempting to locate the file in an MT install and setup the -I libs properly."
  (interactive)
  (setq perl-compile-command  
	(concat 
	 perl-compile-bin
	 (plugin-lib-dir (mt-rel-path buffer-file-name))
	 " "
	 (mt-rel-path buffer-file-name)))
  
  (if (not (is-perl-file buffer-file-name))
      (message (concat "file " (file-name-nondirectory buffer-file-name) " is not a perl file!"))
    (with-output-to-temp-buffer "perl-c" 
      (message perl-compile-command)
      (print (concat "perl -c output: " (shell-command-to-string 
       perl-compile-command))))))

(defun mt-run-test ()
  "Call prove on test file.
   Runs 'prove -v' on the current buffer, after checking that it's a unit test (.t) file"
  (interactive)
  (setq prove-command (concat prove-bin (mt-rel-path buffer-file-name)))
   (if (not (is-test-file buffer-file-name))
      (message (concat "file " (file-name-nondirectory buffer-file-name) " is not a test file!"))
    (if (mt-rel-path buffer-file-name)
	(with-output-to-temp-buffer "prove-v" 
	  (message prove-command)
	  (print (concat "prove -v output: " 
			 (shell-command-to-string prove-command))))
      (message "Cannot determine mt-rel-path for file"))))

; TODO: work out a convention for finding a test file starting from a .pm file

; testing
; (mt-perl-compile)

; Notes
; "Symbol's function definition is void"
;  -- you may have wrapped a variable arg to a function in (), so it's trying to call the var as a function
;  -- i.e. (length (some-var)) ; some-var is not a function