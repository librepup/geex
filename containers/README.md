# Geex Container
![Guix Banner](https://raw.githubusercontent.com/nixpup/geex/refs/heads/main/guixBanner.jpg)

# Information
## Commands
This directory contains ready-to-use definitions for Guix Home and Guix System container. You can run them by executing one of these two following commands:
 - `guix home container /path/to/geex/containers/<home-container>.scm`
 - `guix system build /path/to/geex/containers/<system-container>.scm`

## Containers
### Home Containers
 - `emacs.scm` - installs full emacs setup and symlinks emacs configuration files via guix home.

### System Containers

### Home Containers
Running the command `guix home container /path/to/geex/containers/<home-container>.scm` will build the home environment inside a container, and then log you in to the newly created container automatically.

### System Containers
After starting the build process of a Guix System build, run `/gnu/store/<hash>-system` in your terminal. This will start the built system as a container, and will output you a process PID. To enter the container, simple run `doas guix container exec <PID> /run/current-system/profile/bin/bash --login` (replace `doas` with `sudo` if you do not use/have not configured doas).
