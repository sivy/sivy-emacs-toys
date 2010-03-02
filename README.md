# mt-mode

This is an emacs minor mode with some useful functions for developing Movable Type plugins in perl. The easiest way to set it up is to do something like this in your `.emacs` file:

    ;; ------------------------------
    ;; make sure mt-mode.el is in your load path
    ;; mt-mode
    (message "loading mt-mode")
    (autoload 'mt-mode "mt-mode" nil t)
    (global-set-key (kbd "C-c c") 'mt-perl-compile)

### mt-perl-compile

The first useful command is `mt-perl-compile`, which runs the current buffer through perl -c. This can be done with compile-command, but I build it myself and run the command, sending the output to a temporary buffer so it can be reviewed. Also, this way we can find the lib directory in the plugin and make sure that it's included as a `-I` with `perl -c`.

#### Contact

Any questions, comments, or praise can be sent to <steveivy@gmail.com>.
