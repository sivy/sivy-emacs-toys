;;; mt-mode.el --- minor mode for writing MT code, esp plugins

;; Copyright (C) 2010 Steve Ivy, David Raynes

;; Author: Steve Ivy <sivy@sixapart.com>
;;    David Raynes <rayners@sixapart.com>
;; Maintainer: Steve Ivy <sivy@sixapart.com>
;; Created: 01 Mar 2010
;; Version: 0.2
;; Keywords: movabletype

;; The latest version of this file can be found at: http://github.com/sivy/sivy-emacs-toys/

;; LICENSE

;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in
;; all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
;; THE SOFTWARE.

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
  '()
  :group 'MT)

(setq perl-compile-bin (concat "cd " mt-home "; perl -c -Ilib -Iextlib -Iaddons/Commercial.pack/lib -Iaddons/Community.pack/lib -Iaddons/Enterprise.pack/lib "))
(setq prove-bin (concat "cd " mt-home "; prove -v "));

(defun is-perl-file (file-name)
  "Return t if the file is a perl (.pm, .pl) file."
  (if (string-match "\\(\\.pm\\|\\.pl\\)$" file-name)
      t
    nil))

(defun mt-rel-path (file-name)
  "Determine a file's path relative to mt-home"
  (message file-name)
  (cond ((string-match ( regexp-quote mt-home) file-name)
	 (substring file-name (+ (length mt-home) 1)))
	((is-plugin-file file-name)
	 (substring file-name (string-match "plugins" file-name)))
	))

(defun is-mt-file (file-name)
  "Return t if the file can be determined to be an MT file.
      Return t if the file is a plugin file, or can be determined to be located under an MT installation"
  (if (mt-rel-path file-name)
      t
    nil))

(defun is-plugin-file (file-name)
  "Return t if the path represents a plugin file.
   Return t if the path contains 'plugins' - simple but effective for now."
  (if (string-match (regexp-quote "plugins") file-name)
      t
    nil))

(defun plugin-lib-dir (file-name)
  "Return an mt-relative path to a plugin's lib directory"
  (if (is-plugin-file file-name)
      (substring file-name 0 
		 (+ 
		  (string-match "lib" file-name) 
		  3))
    nil))

(defun load-mt-mode-conditionally ()
  (message (concat "checking is-mt-file... " buffer-file-name))
  (if (is-mt-file buffer-file-name)
      (mt-mode)))

(defun mt-perl-compile ()
  "Call perl -c. 
Runs 'perl -c' on the current buffer, first attempting to locate the file in an MT install and setup the -I libs properly."
  (interactive)
  (message (concat "mt-perl-compile buffer: " buffer-file-name))
  (setq buffer-rel-path (mt-rel-path buffer-file-name))
  (message (concat "mt-perl-compile: " buffer-rel-path))
  (unless (string-equal "" buffer-rel-path)
    (setq perl-compile-command  
	  (concat 
	   perl-compile-bin
	   "-I"
	   (plugin-lib-dir buffer-rel-path)
	   " "
	   buffer-rel-path))
    
    (if (not (is-perl-file buffer-file-name))
      (message (concat "file " (file-name-nondirectory buffer-file-name) " is not a perl file!"))
    (with-output-to-temp-buffer "perl-c" 
      (message perl-compile-command)
      (print (concat "perl -c output: " (shell-command-to-string 
					 perl-compile-command)))))))

(defun is-test-file (file-name)
  "Return t if the file is a unit test (.t) file."
  (if (string-match "\\.t$" file-name)
      t
    nil))

(defun mt-run-test ()
  "Call prove on test file.
   Runs 'prove -v' on the current buffer, after checking that it's a unit test (.t) file"
  (interactive)
  (if (not (is-test-file buffer-file-name))
      (message (concat "file " (file-name-nondirectory buffer-file-name) " is not a test file!"))
    (if (mt-rel-path buffer-file-name)
	(with-output-to-temp-buffer "prove-v" 
	  (setq prove-command (concat prove-bin (mt-rel-path buffer-file-name)))
	  (message prove-command)
	  (print (concat "prove -v output: " 
			 (shell-command-to-string prove-command))))
      (message "Cannot determine mt-rel-path for file"))))

(defun mt-run-all-tests ()
  "Call prove on test file.
   Runs 'prove -v' on the current buffer, after checking that it's a unit test (.t) file"
  (interactive)
  (if (not (is-test-file buffer-file-name))
      (message (concat "file " (file-name-nondirectory buffer-file-name) " is not a test file!"))
    (if (mt-rel-path buffer-file-name)
	(with-output-to-temp-buffer "prove-v all"
	  (setq prove-command 
		(concat prove-bin 
			(substring
			 (mt-rel-path buffer-file-name) 
			 0
			 (+
			  (string-match "\/t\/" (mt-rel-path buffer-file-name))
			  3))
			"*.t"))
					;(message prove-command)
	  (print (concat "prove -v output: " 
			 (shell-command-to-string prove-command))))
      (message "Cannot determine mt-rel-path for file"))))

(message "loaded mt-mode")

					; Notes
					; "Symbol's function definition is void"
;  -- you may have wrapped a variable arg to a function in (), so it's trying to call the var as a function
;  -- i.e. (length (some-var)) ; some-var is not a function