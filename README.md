# Guix Configuration
![Guix Banner](https://raw.githubusercontent.com/nixpup/geex/refs/heads/main/guixBanner.jpg)

# Information
## Channels
This GNU Guix Configuration pre-configures a few useful channels to make certain Packages available that are otherwise missing in the official GNU Guix repository, these include:
- guix, this is the default and official guix channel.
- nonguix, this channel provides nvidia drivers, firmware, and a full Linux kernel.
- jonabron, this channel provides games, emacs packages, window managers, discord, and more.
- emacs, this channel provides melpa emacs packages.

# Usage
## Setup
Clone this repository via `git clone https://github.com/nixpup/geex`, enter the cloned directory (`cd geex`), then run the mover and installer script (`geex.sh`), or move the files to their respective destinations manually:
### Mover and Installer
 - `chmod a+x ./geex.sh`
 - `./geex.sh -h`

The installer allows you to pick from 4 pre-made system configurations, and tweak them to your liking. For example by defining which services to use, which desktops to install, and setting up your bootloader and filesystems. The installer also automatically formats your drive according to your setup (with permission only, of course).

**Tip**: A full graphical (TUI - Terminal User Interface) and textual installer for the `geex.sh` script is in the works, and, mostly functional (State: **19.2.26@22:14**). You can test the installer functionality by running `GEEX_DEBUG=1 ./geex.sh -i` or `./geex.sh d i` (omit `GEEX_DEBUG=1`/`d` if you want the installer to *actually* move, configure, and install files - Debug Mode only pretends to work for testing purposes).

### Manual
 - `cp channels.scm ~/.config/guix/channels.scm`
 - `cp channels.scm /etc/guix/channels.scm`
 - `cp -r files /etc/guix/files`
 - `cp -r systems /etc/guix/systems`
 - `cp home.scm /etc/guix/home.scm`
 - `cp config.scm /etc/guix/config.scm`

## Importing Keys
Don't forget to import the [Nonguix](https://gitlab.com/nonguix/nonguix) Key via `sudo guix archive --authorize < /etc/guix/files/keys/nonguix.pub`.

Then you can update Guix and its Channels by invoking `guix pull`, and afterwards check whether all Channels were correctly set up with `guix describe`. If you are currently logged in as the `root` user, run `guix pull --channels=/path/to/channels.scm`, as the `root` user does not have a native home directory. Make sure that `~/.config/guix/channels.scm` is the **first** item in your "$PATH".

Update Bash's Guix binary and configuration with `hash guix` after `guix pull` is done.

## System Configuration
Afterwards, you need to pick your systems configuration. For that, edit the `/etc/guix/config.scm` file and change the "%systemchoice" variable, for example like this:
```scm
(define %systemchoice "desktop") ; Available options: "desktop", "laptop", "minimal", "libre".

; ... rest of the File.
```

This will then pick one of the following systems files:
- "desktop" -> `/etc/guix/systems/desktop.scm`
- "laptop" -> `/etc/guix/systems/laptop.scm`
- "minimal" -> `/etc/guix/systems/minimal.scm`
- "libre" -> `/etc/guix/systems/libre.scm`

The main difference between these systems configurations, is that the Laptop configuration does not come with Nvidia Drivers, unlike the Desktop Configuration. The minimal configuration has as little packages, services, and options set as possible, while still maintaining a proper working system. While the libre configuration does not come with `nonguix`, and ships the default GNU Guix **linux-libre** kernel.

The systemchoices that are most maintained and tested are `"desktop"` and `"laptop"`, as these are the ones I personally use and rely on. The others are usually functional, but not as deeply though out and configured. They are supposed to be more of a base configuration for other applications of my GNU Guix configuration, than anything else.

To apply the system configuration, run `sudo guix system reconfigure /etc/guix/config.scm`. Similarly, to reconfigure or apply the Guix Home configuration, run `guix home reconfigure /etc/guix/home.scm`.

## Testing Guix Home
If you copied all the files of this repository to their respective target directories, you can test the Guix Home environment this configuration sets up for you inside a container via `guix home container /etc/guix/home.scm`. This gives you a minimal environment with only the packages, configuration files, variables, and settings provided by the `home.scm` file.

## Testing Guix System
You can run a dry-build of the entire Guix System via `guix system build /etc/guix/config.scm`. This will build the entire system configuration, but not install it anywhere. You get a resulting `/gnu/store` path for your built system. This is useful to check whether the system configuration you wrote actually works/builds correctly, before running into issues when you're trying to install on real hardware/bare metal.

# Notes
You can view all of my Notes on GNU Guix, which include various code snippets, useful commands to remember, command combinations that you can turn into shell functions, and other information by clicking on the link below this text:
## [GNU Guix Notes (Click Here)](https://github.com/librepup/geex/blob/main/NOTES.org)

## Testing Guix Home
If you copied all the files of this repository to their respective target directories, you can test the Guix Home environment this configuration sets up for you inside a container via `guix home container /etc/guix/home.scm`. This gives you a minimal environment with only the packages, configuration files, variables, and settings provided by the `home.scm` file.

## Testing Guix System
You can run a dry-build of the entire Guix System via `guix system build /etc/guix/config.scm`. This will build the entire system configuration, but not install it anywhere. You get a resulting `/gnu/store` path for your built system. This is useful to check whether the system configuration you wrote actually works/builds correctly, before running into issues when you're trying to install on real hardware/bare metal.

## Verification of Functionality
The system configuration for `%systemchoice "desktop"` ( ... set in `config.scm`) has been tested via `guix system build`:
```
successfully built /gnu/store/33whk4r85fdnnqxajcd5ajf1a3sp6z6h-profile.drv
building /gnu/store/yrnxy79agdxnggy3apkdrzwr4c1615dj-activate-service.scm.drv...
successfully built /gnu/store/yrnxy79agdxnggy3apkdrzwr4c1615dj-activate-service.scm.drv
building /gnu/store/fi1bjspmj0w8d7d95v4rs01qpp71w279-activate.scm.drv...
successfully built /gnu/store/fi1bjspmj0w8d7d95v4rs01qpp71w279-activate.scm.drv
building /gnu/store/f72wivwc82r0f2s02xppbyb32ffahzil-boot.drv...
successfully built /gnu/store/f72wivwc82r0f2s02xppbyb32ffahzil-boot.drv
building /gnu/store/5fy6ckc0rsj1240ylvvf65cal1ps02h5-system.drv...
successfully built /gnu/store/5fy6ckc0rsj1240ylvvf65cal1ps02h5-system.drv
/gnu/store/x72dc187zwnyzsm758pbyf1x2gm1qjgf-system
```
and successfully builds every package, module, and service - including Nvidia Drivers.

The Guix Home configuration (`home.scm`) builds as well:
```
building /gnu/store/9w5ns912bkkd28hpy66swbh9j87fg0ai-provenance.drv...
building CA certificate bundle...
listing Emacs sub-directories...
building /gnu/store/0xgpl2vcv5jp2wfq7lk9psrfv6zp9k1h-files.drv...
building fonts directory...
generating GdkPixbuf loaders cache...
building GHC package cache...
generating GLib schema cache...
creating GTK+ icon theme cache...
building cache files for GTK+ input methods...
building directory of Info manuals...
building database for manual pages...
building XDG desktop file cache...
building XDG MIME database...
building profile with 149 packages...
building /gnu/store/zp9sz0ycg7rqxalchm1lpv2z1ylk7v80-home.drv...
```

Update **[10.2.26@17:04]**: Pinned the commits of the Guix and Nonguix channel, so now we have valid substitutes available and can build packages like `steam-nvidia` and the full `linux` kernel.

Update **[17.2.26@17:20]**: If you are to remove the pinned commits from the `channels.scm` file, make sure to check whether the `linux` package, and any other `*-nvidia` packages (like `steam-nvidia` or `mpv-nvidia`) have available substitutes. You can do this by running `guix weather <package> --substitute-urls="https://substitutes.nonguix.org"`. (Replace `<package>` with the package you want to check for substitutes, obviously.)
