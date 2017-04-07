# Mac rxvt-unicode setup.
# http://rcrowley.org/articles/rxvt-unicode.html

# Install dependencies from MacPorts and CPAN.
sudo port install rxvt-unicode +xterm_colors_256
sudo port install terminus-font
sudo cpan install Mac::Pasteboard

# Run urxvt at X11 startup.
defaults write org.x.X11 app_to_run /opt/local/bin/urxvt

# Fix terminfo warnings.
sudo ln -s /opt/local/share/terminfo/72/rxvt-unicode /usr/share/terminfo/72/rxvt-unicode

# Append rcrowley's .Xdefaults to whatever's there.
wget -O - http://github.com/rcrowley/home/raw/master/.Xdefaults >>~/.Xdefaults
