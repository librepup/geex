# Guix Configuration
![Guix Banner](https://raw.githubusercontent.com/nixpup/geex/refs/heads/main/guixBanner.jpg)

# Information
This Guix configuration has *not* been tested yet, so take whatever you see here with a grain of salt. The configuration/setup included all necessary packages, sets up the **nonguix** channel, symlinks configuration files via **Guix Home**, installs Nvidia Drivers, and compiles the [NaitreHUD](https://github.com/nixpup/NaitreHUD) Wayland Window Manager and Compositor.

# Usage
Clone this repository via `git clone https://github.com/nixpup/geex`, then move the files to their respective destinations:
 - `cp channels/channels.scm ~/.config/guix/channels.scm`
 - `mv channels /etc/guix/channels`
 - `mv home /etc/guix/home`
 - `mv systems /etc/guix/systems`

Don't forget to import the [Nonguix](https://gitlab.com/nonguix/nonguix) Key via `sudo guix archive --authorize < /etc/guix/channels/nonguix.pub`.

Then you can update Guix and its Channels by invoking `guix pull`, and afterwards check whether all Channels were correctly set up with `guix describe`. Make sure that "~/.config/guix/channels.scm" is the **first** item in your "$PATH".

Update Bash's Guix binary and configuration with `hash guix` after `guix pull` is done.

To apply the system configuration, run `sudo guix system -L /etc/guix reconfigure`. Similarly, to reconfigure or apply the Guix Home configuration, run `guix home -L /etc/guix reconfigure`.
