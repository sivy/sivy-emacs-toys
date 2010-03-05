;;; mt-test-mode.el --- minor mode for writing perl unit tests

;; Copyright (C) 2010 Steve Ivy, David Raynes

;; Author: Steve Ivy <sivy@sixapart.com>
;; Maintainer: Steve Ivy <sivy@sixapart.com>
;; Created: 03 Mar 2010
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

; mt-mode must be loaded first, as mt-test-mode depends on several variables from mt-mode.
; don't know how to best handle this dependency

(setq prove-bin (concat "cd " mt-home "; prove -v "));

(define-minor-mode mt-test-mode
      "Toggle MT-Test mode.
      With no argument, this command toggles the mode.
      Non-null prefix argument turns on the mode.
      Null prefix argument turns off the mode."
     
      ;; The initial value.
      nil
      ;; The indicator for the mode line.
      " MT-Test"
      ;; The minor mode bindings.
      '()
      :group 'MT)

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
	  (message prove-command)
	  (print (concat "prove -v output: " 
			 (shell-command-to-string prove-command))))
      (message "Cannot determine mt-rel-path for file"))))

(mt-run-test)
(mt-run-all-tests)