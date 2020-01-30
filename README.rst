==========
 xtermrc
==========

My xterm configuration, including a script to grab URL's and launch them using dmenu.

Install & Configure
--------------------
Clone to ``~/.config/xterm``::

  git clone https://github.com/xantoz/xtermrc $HOME/.config/xterm

Make sure ``~/.Xresources`` exists and gets loaded at start using any applicable
method (your distro might already do this automatically if the file exists).

In your ``~/.Xresources`` file `#define` commands you would want to launch using
the URL grabber, and `#include ~/.config/xterm/Xresources`. The URL grabber will
replace instances of ``%URL%`` with the selected URL. E.g::

  #define XTERM_URL_COMMANDS           \
        "webmacs '%URL%'"              \
        "firefox '%URL%'"              \
        "mpv '%URL%'"                  \
        "echo -n '%URL%' | xsel -b"    \
        "xterm -e \\\"youtube-dl -o '/tmp/%(title)s.%(ext)s' '%URL%'\\\""
  #include "~/.config/xterm/Xresources"

The URL grabber is launched by pressing *Alt+U*. This triggers the
`printEverything(noFormFeed)` xterm command, which will pipe the terminal
contents to ``xterm-find-urls-dmenu.sh``.
