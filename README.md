# mt-mode

This is an emacs minor mode with some useful functions for developing Movable Type plugins in perl. The easiest way to set it up is to do something like this in your `.emacs` file:

    ;; ------------------------------
    ;; make sure mt-mode.el is in your load path
    ;; mt-mode
    (message "loading mt-mode")
    (autoload 'mt-mode "mt-mode" nil t)
    (global-set-key (kbd "C-c c") 'mt-perl-compile)
    (global-set-key (kbd "C-c t") 'mt-run-test)

It's also important to set `mt-home` and `mt-config` in your `.emacs`. They default to "~/mte" and "mt-config.cgi" respectively.
     ; path to mt
    (setq mt-home "/path/to/your/mte")
    ; path to mt-config.cgi
    (setq mt-config (concat mt-home "/mt-config.cgi"))

## Features

### mt-perl-compile

The first useful command is `mt-perl-compile`, which runs the current buffer through perl -c. This can be done with compile-command, but I build it myself and run the command, sending the output to a temporary buffer so it can be reviewed. Also, this way we can find the lib directory in the plugin and make sure that it's included as a `-I` with `perl -c`.

### mt-run-test

Runs `prove -v` on the current buffer, after checking that it's a `.t` file.

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
