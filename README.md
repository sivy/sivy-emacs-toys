# mt-modes

These are some emacs minor modes with some useful functions for developing Movable Type plugins in perl. The easiest way to set it up is to do something like this in your `.emacs` file:

	;; ------------------------------
	;; mt-modes
	;; mt-util.el defines the custom settings, and some common functions
	(require 'mt-util)

	;; autoload the mode functions
	(autoload 'mt-mode "mt-mode" nil t)
	(autoload 'mt-test-mode "mt-test-mode" nil t)

	;; my personal bindings for compile (c), test (t), and all tests (a)
	(global-set-key (kbd "C-c c") 'mt-perl-compile)
	(global-set-key (kbd "C-c t") 'mt-run-test)
	(global-set-key (kbd "C-c a") 'mt-run-all-tests)

	;; load MT mode for certain perl files, while keeping
	;; cperl-mode as the major
	(eval-after-load "cperl-mode"
	      '(add-hook 'cperl-mode-hook 'load-mt-mode-conditionally))
	;; load MT-Test mode for .t files
	(eval-after-load "cperl-mode"
	      '(add-hook 'cperl-mode-hook 'load-mt-test-mode-conditionally))

	;; set location of mt
	(setq mt-home "/path/to/your/mt")
	(setq mt-config (concat mt-home "/mt-config.cgi"))

	(add-to-list 'auto-mode-alist '("\\.tmpl$" . html-mode))

It's also important to set `mt-home` and `mt-config` in your `.emacs`. They default to "~/mte" and "mt-config.cgi" respectively.
    
     ; path to mt
    (setq mt-home "/path/to/your/mte")
    ; path to mt-config.cgi
    (setq mt-config (concat mt-home "/mt-config.cgi"))

## mt-mode Features

### mt-perl-compile

The first useful command is `mt-perl-compile`, which runs the current buffer through perl -c. This can be done with compile-command, but I build it myself and run the command, sending the output to a temporary buffer so it can be reviewed. Also, this way we can find the lib directory in the plugin and make sure that it's included as a `-I` with `perl -c`.

## mt-test-mode Features

### mt-run-test

Runs `prove -v` on the current buffer, after checking that it's a `.t` file.

### mt-run-all-tests

Runs `prove -v` on all tests in the same directory as the current buffer, after checking that the current buffer is a `.t` file.

## Contact

Any questions, comments, or praise can be sent to <sivy@sixapart.com>.

## License

This code is released under the MIT License:

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
