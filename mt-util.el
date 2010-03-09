;;; mt-util.el --- utility settings and functions for writing MT code, esp plugins

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

(defcustom mt-home "~/mte"
  "MT_HOME directory"
  :type 'string
  :group 'MT)

(defcustom mt-config "~/mte/mt-config.cgi" 
  "MT_CONFIG value"
  :type 'string
  :group 'MT)

(defun is-perl-file (file-name)
  "Return t if the file is a perl (.pm, .pl) file."
  (if (string-match "\\(\\.pm\\|\\.pl\\)$" file-name)
      t
    nil))

(defun mt-rel-path (file-name)
  "Determine a file's path relative to mt-home"
  (message file-name)
  (cond ((string-match mt-home file-name)
	 (substring file-name (+ (length mt-home) 1)))
	((is-plugin-file file-name)
	 (substring file-name (string-match "plugins" file-name)))
	))

(defun is-plugin-file (file-name)
  "Return t if the path represents a plugin file.
   Return t if the path contains 'plugins' - simple but effective for now."
  (if (string-match "plugins" file-name)
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


(defun is-mt-file (file-name)
 "Return t if the file can be determined to be an MT file.
      Return t if the file is a plugin file, or can be determined to be located under an MT installation"
 (if (mt-rel-path file-name)
     t
   nil))

(defun load-mt-mode-conditionally ()
  (message (concat "checking is-mt-file... " buffer-file-name))
  (if (is-mt-file buffer-file-name)
      (mt-mode)))

(defun load-mt-test-mode-conditionally ()
  (if (string-match "\\.t$" buffer-file-name)
      (mt-test-mode)))

(provide 'mt-util)