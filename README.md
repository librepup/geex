# Guix Configuration
![Guix Banner](https://raw.githubusercontent.com/nixpup/geex/refs/heads/main/guixBanner.jpg)

# Information
## Preface
This Guix configuration has *not* been tested yet, so take whatever you see here with a grain of salt. The configuration/setup included all necessary packages, sets up the **nonguix** channel, symlinks configuration files via **Guix Home**, installs Nvidia Drivers, and compiles the [NaitreHUD](https://github.com/nixpup/NaitreHUD) Wayland Window Manager and Compositor.

## Channels
This GNU Guix Configuration pre-configures a few useful channels to make certain Packages available that are otherwise missing in the official GNU Guix repository, these include:
- jack-faller, this channel provides a Discord package.
- nonguix, this channel provides nvidia drivers, firmware, and a full Linux kernel.
- jonabron, this channel provides games, emacs packages, and window managers.
- emacs, this channel provides melpa emacs packages.
- guix, this is the default and official guix channel.

# Usage
Clone this repository via `git clone https://github.com/nixpup/geex`, then move the files to their respective destinations:
 - `cp channels.scm ~/.config/guix/channels.scm`
 - `cp channels.scm /etc/guix/channels.scm`
 - `cp -r channels /etc/guix/channels`
 - `cp -r files /etc/guix/files`
 - `cp -r systems /etc/guix/systems`
 - `cp home.scm /etc/guix/home.scm`
 - `cp config.scm /etc/guix/config.scm`

Don't forget to import the [Nonguix](https://gitlab.com/nonguix/nonguix) Key via `sudo guix archive --authorize < /etc/guix/channels/nonguix.pub`.

Then you can update Guix and its Channels by invoking `guix pull`, and afterwards check whether all Channels were correctly set up with `guix describe`. Make sure that "~/.config/guix/channels.scm" is the **first** item in your "$PATH".

Update Bash's Guix binary and configuration with `hash guix` after `guix pull` is done.

Afterwards, you need to pick your systems configuration. For that, edit the `/etc/guix/config.scm` file and change the "%systemchoice" variable, for example like this:
```scm
(define %systemchoice "desktop") ; Available options: "desktop", "laptop".

; ... rest of the File.
```

This will then pick either the `/etc/guix/systems/desktop.scm` or `/etc/guix/systems/laptop.scm` system configuration file depending on your needs. The main difference is that the Laptop configuration does not come with Nvidia Drivers, unlike the Desktop Configuration.

To apply the system configuration, run `sudo guix system reconfigure /etc/guix/config.scm`. Similarly, to reconfigure or apply the Guix Home configuration, run `guix home reconfigure /etc/guix/home.scm`.
