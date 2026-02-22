#!/usr/bin/env sh

if [ $# -eq 0 ]; then
    echo -e \
         "Usage: ENVIRONMENT geex OPTION
Run geex with OPTION, if given.

COMMAND must be one of the sub-commands listed below:

  main commands
    help                         display help message
    git                          display github repository url and developer contact information
    install                      start the interactive installer
    debug                        start application in debug mode
    clean                        clean up all possible leftovers
    live                         enable live preview mode
    mover                        start the mover mode

ENVIRONMENT can be one of the environment variables listed below:

  main environment variables
    GEEX_DEBUG                   start application in debug mode
    GEEX_DEBUG_MODE              start application in debug mode
    GEEX_VERBOSE_MODE            enable verbose mode for more feedback
    GEEX_IGNORE_MISSING          ignore if packages are missing
    GEEX_LIVE_MODE               enable live preview mode for the installer
    GEEX_DEBUG_MISSING_ENABLE    pretend as if packages were missing

EXAMPLES that you may consider running yourself listed below:

  main examples
    ./geex.sh d v i              run installer in debug and verbose mode
    ./geex.sh d v i l            run installer in debug, verbose, and live mode
    ./geex.sh d m                run mover in debug mode
    ./geex.sh i                  run installer (this will modify your system and try to install gnu guix)
    ./geex.sh i d                run installer in debug mode

NOTICE for you to consider:

  installer notices
    if you run the installer without debug mode, it will try to install gnu guix on your system or one
    of your disks, please be aware of this and ALWAYS run the installer in DEBUG MODE before deciding
    to actually use it to install an operating system (GNU Guix).

  mover notices
    if you run the mover without debug mode, it will try to move and copy files into your system without
    warning. there are backup hooks to try and prevent accidental file deletion, but it is better to check
    and back up your own files FIRST, before running the mover in non-debug mode."
    exit 1
fi

for arg in "$@"; do
    case "$arg" in
        l|-l|--l|live|-live|--live)
            export GEEX_LIVE_MODE=1
            ;;
    esac
done

for arg in "$@"; do
    case "$arg" in
        g|-g|--g|git|-git|--git|github|-github|--github)
            echo -e \
                 "Information: REPO and CONTACT

  REPO
    https://github.com/librepup/geex"
            exit 1
            ;;
    esac
done

for arg in "$@"; do
    case "$arg" in
        copyright|-copyright|--copyright|credits|-credits|--credits|credit|-credit|--credit)
            echo -e \
                 "Credits: Geex Installer

CREATOR
  librepup

CONTACT
  librepup@member.fsf.org"
            exit 1
            ;;
    esac
done

for arg in "$@"; do
    case "$arg" in
        c|-c|--c|clean|-clean|--clean)
            if [ -f "/tmp/geex.extra.packages.insertable.dd" ]; then
                rm /tmp/geex.extra.packages.insertable.dd
            fi
            if [ -f "/tmp/geex.guix.channel.pull.check.file.dd" ]; then
                rm /tmp/geex.guix.channel.pull.check.file.dd
            fi
            if [ -f "/tmp/geex.guix.system.init.check.file.dd" ]; then
                rm /tmp/geex.guix.system.init.check.file.dd
            fi
            if [ -f "/tmp/geex.guix.style.check.file.dd" ]; then
                rm /tmp/geex.guix.style.check.file.dd
            fi
            if [ -f "/tmp/geex.keyboard.variants.dd" ]; then
                rm /tmp/geex.keyboard.variants.dd
            fi
            if [ -f "/tmp/geex.keyboard.layout.variants.dd" ]; then
                rm /tmp/geex.keyboard.layout.variants.dd
            fi
            if [ -f "/tmp/geex.disk.prefixed.text.block.dd" ]; then
                rm /tmp/geex.disk.prefixed.text.block.dd
            fi
            if [ -f "/tmp/geex.timezone.success.dd" ]; then
                rm /tmp/geex.timezone.success.dd
            fi
            if [ -f "/tmp/geex.timezone.notice.dd" ]; then
                rm /tmp/geex.timezone.notice.dd
            fi
            if [ -f "/tmp/geex.config.desktop.dd" ]; then
                rm /tmp/geex.config.desktop.dd
            fi
            if [ -f "/tmp/geex.config.laptop.dd" ]; then
                rm /tmp/geex.config.laptop.dd
            fi
            if [ -f "/tmp/geex.config.libre.dd" ]; then
                rm /tmp/geex.config.libre.dd
            fi
            if [ -f "/tmp/geex.config.minimal.dd" ]; then
                rm /tmp/geex.config.minimal.dd
            fi
            if [ -f "/tmp/geex.config.desktop.template.dd" ]; then
                rm /tmp/geex.config.desktop.template.dd
            fi
            if [ -f "/tmp/geex.config.laptop.template.dd" ]; then
                rm /tmp/geex.config.laptop.template.dd
            fi
            if [ -f "/tmp/geex.config.libre.template.dd" ]; then
                rm /tmp/geex.config.libre.template.dd
            fi
            if [ -f "/tmp/geex.config.minimal.template.dd" ]; then
                rm /tmp/geex.config.minimal.template.dd
            fi
            if [ -f "/tmp/geex.summary.dd" ]; then
                rm /tmp/geex.summary.dd
            fi
            if [ -f "/tmp/geex.keyboardstatus.dd" ]; then
                rm /tmp/geex.keyboardstatus.dd
            fi
            if [ -f "/tmp/geex.detecteddisks.dd" ]; then
                rm /tmp/geex.detecteddisks.dd
            fi
            if [ -f "/tmp/geex.detectedbios.dd" ]; then
                rm /tmp/geex.detectedbios.dd
            fi
            if [ -f "/tmp/geex.home.scm" ]; then
                rm /tmp/geex.home.scm
            fi
            if [ -f "/tmp/geex.bios.block.dd" ]; then
                rm /tmp/geex.bios.block.dd
            fi
            if [ -f "/tmp/geex.filesystem.block.dd" ]; then
                rm /tmp/geex.filesystem.block.dd
            fi
            if [ -f "/tmp/geex.service.hurd.block.dd" ]; then
                rm /tmp/geex.service.hurd.block.dd
            fi
            if [ -f "/tmp/geex.service.nix.block.dd" ]; then
                rm /tmp/geex.service.nix.block.dd
            fi
            if [ -f "/tmp/geex.group.nix.block.dd" ]; then
                rm /tmp/geex.group.nix.block.dd
            fi
            if [ -f "/tmp/geex.package.doas.block.dd" ]; then
                rm /tmp/geex.package.doas.block.dd
            fi
            if [ -f "/tmp/geex.service.doas.block.dd" ]; then
                rm /tmp/geex.service.doas.block.dd
            fi
            if [ -f "/tmp/geex.wm.i3.packages.dd" ]; then
                rm /tmp/geex.wm.i3.packages.dd
            fi
            if [ -f "/tmp/geex.wm.gnome.service.dd" ]; then
                rm /tmp/geex.wm.gnome.service.dd
            fi
            if [ -f "/tmp/geex.wm.naitre.packages.dd" ]; then
                rm /tmp/geex.wm.naitre.packages.dd
            fi
            if [ -f "/tmp/geex.wm.xmonad.packages.dd" ]; then
                rm /tmp/geex.wm.xmonad.packages.dd
            fi
            if [ -d "/tmp/geex.git.storage" ]; then
                rm -rf /tmp/geex.git.storage
            fi
            if [ -f "/tmp/geex.channels.dd" ]; then
                rm /tmp/geex.channels.dd
            fi
            if [ -f "/tmp/channels.scm" ]; then
                rm /tmp/channels.scm
            fi
            if [ -f "/tmp/geex.config.desktop.template.dd" ]; then
                rm /tmp/geex.config.desktop.template.dd
            fi
            if [ -f "/tmp/geex.config.minimal.template.dd" ]; then
                rm /tmp/geex.config.minimal.template.dd
            fi
            if [ -f "/tmp/geex.config.libre.template.dd" ]; then
                rm /tmp/geex.config.libre.template.dd
            fi
            if [ -f "/tmp/geex.config.laptop.template.dd" ]; then
                rm /tmp/geex.config.laptop.template.dd
            fi
            echo -e "Successfully cleaned up all possible leftovers."
            exit 1
            ;;
    esac
done

for arg in "$@"; do
    case "$arg" in
        h|-h|--h|help|-help|--help)
            echo -e \
                 "Usage: ENVIRONMENT geex OPTION
Run geex with OPTION, if given.

COMMAND must be one of the sub-commands listed below:

  main commands
    help                         display help message
    git                          display github repository url and developer contact information
    install                      start the interactive installer
    debug                        start application in debug mode
    clean                        clean up all possible leftovers
    live                         enable live preview mode
    mover                        start the mover mode

ENVIRONMENT can be one of the environment variables listed below:

  main environment variables
    GEEX_DEBUG                   start application in debug mode
    GEEX_DEBUG_MODE              start application in debug mode
    GEEX_VERBOSE_MODE            enable verbose mode for more feedback
    GEEX_IGNORE_MISSING          ignore if packages are missing
    GEEX_LIVE_MODE               enable live preview mode for the installer
    GEEX_DEBUG_MISSING_ENABLE    pretend as if packages were missing

EXAMPLES that you may consider running yourself listed below:

  main examples
    ./geex.sh d v i              run installer in debug and verbose mode
    ./geex.sh d v i l            run installer in debug, verbose, and live mode
    ./geex.sh d m                run mover in debug mode
    ./geex.sh i                  run installer (this will modify your system and try to install gnu guix)
    ./geex.sh i d                run installer in debug mode

NOTICE for you to consider:

  installer notices
    if you run the installer without debug mode, it will try to install gnu guix on your system or one
    of your disks, please be aware of this and ALWAYS run the installer in DEBUG MODE before deciding
    to actually use it to install an operating system (GNU Guix).

  mover notices
    if you run the mover without debug mode, it will try to move and copy files into your system without
    warning. there are backup hooks to try and prevent accidental file deletion, but it is better to check
    and back up your own files FIRST, before running the mover in non-debug mode."
            exit 1
            ;;
    esac
done

moverFunction() {
    # Create Randomized Backup Name
    export randFunc="$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)"
    export randFuncString="$(echo $randFunc)"
    export randEtcName="$(echo guix.backup-etc.$randFuncString)"
    export randCfgName="$(echo guix.backup-cfg.$randFuncString)"

    if [[ -z "$GEEX_DEBUG" ]] || [[ -z "$GEEX_DEBUG_MODE" ]]; then
        if command -v printf >/dev/null; then
            printf "[ Mover ]: You are running the Mover without Debug Mode, this will move files, make backups, and possibly\ntamper with your system configuration. Are you sure you want to proceed? (y/n): "
            read -r moverProceed
            export moverProceedAnswer=$moverProceed
        else
            echo -e "[ Mover ]: You are running the Mover without Debug Mode, this will move files, make backups, and possibly\ntamper with your system configuration. Are you sure you want to proceed? (y/n): "
            read -r moverProceed
            export moverProceedAnswer=$moverProceed
        fi
        if [[ "$moverProceedAnswer" == *n* ]]; then
            export GEEX_DEBUG=1
            export GEEX_DEBUG_MODE=1
            export GEEX_MOVER_FORCE_DEBUG=1
        fi
    fi
    # Check for Debug Mode - if not set, Backup Files - else Pretend
    if [ -n "$GEEX_DEBUG" ] || [ -n "$GEEX_DEBUG_MODE" ] || [ -n "$GEEX_MOVER_FORCE_DEBUG" ]; then
        echo "[ Debug ]: Debug Mode Detected, pretending to Backup Files..."
    else
        # Backup '/etc/guix'
        if [ -d /etc/guix ]; then
            cp -r /etc/guix /tmp/$randEtcName
            cp -r /etc/guix $HOME/$randEtcName
            echo "[ Backup ]: Created Backups of your '/etc/guix' at '/tmp/$randEtcName' and '$HOME/$randEtcName'."
            export backedUpEtc="yes"
        else
            echo "[ Status ]: '/etc/guix' not found - not backing up."
        fi
        # Backup '~/.config/guix'
        if [ -d ~/.config/guix ]; then
            cp -r ~/.config/guix /tmp/$randCfgName
            cp -r ~/.config/guix $HOME/$randCfgName
            echo "[ Backup ]: Created Backups of your '~/.config/guix' at '/tmp/$randCfgName' and '$HOME/$randCfgName'."
            export backedUpCfg="yes"
        else
            echo "[ Status ]: '~/.config/guix' not found - not backing up."
        fi
    fi

    # Declaring Escalation Utility
    if command -v doas >/dev/null 2>&1; then
        export escalationUtil="doas"
    elif command -v sudo >/dev/null 2>&1; then
        export escalationUtil="sudo"
    else
        export escalationUtil="su"
    fi
    echo "[ Status ]: Pinned Escalation Utility to '$escalationUtil'..."

    # Pin Username
    export userName="$(echo $USER)"
    if [ "$userName" == "root" ]; then
        echo "[ Warning ]: Cannot create Backups for User 'root'"
        printf "[ Input ]: Please enter Username: "
        read -r manualUserName
        if [ "$manualUserName" == "" ]; then
            export userGuess="$(users | awk '{print $1}')"
            echo "[ Warning ]: Input was Empty, guessing User as '$userGuess'..."
            export manualUserName="$(echo $userGuess)"
        fi
        export userName=$manualUserName
    fi
    echo "[ Status ]: Pinned Username to '$userName'..."

    if [ "$HOME" == "/root" ]; then
        echo "[ Warning ]: Cannot copy Files to 'root' Home"
        printf "[ Input ]: Please enter '$userName' Home Path: "
        read -r manualHomeDirectory
        if [ "$manualHomeDirectory" = "" ]; then
            echo "[ Warning ]: Input was Empty, guessing Home as '/home/$userName'..."
            export manualHomeDirectory="$(echo /home/$userName)"
        fi
        export homeDirectory=$manualHomeDirectory
    else
        export homeDirectory=$HOME
    fi
    echo "[ Status ]: Pinned Home to '$homeDirectory'..."

    # Check for Debug Mode - if not set, Copy Files - else, Pretend
    if [ -n "$GEEX_DEBUG" ] || [ -n "$GEEX_DEBUG_VAR" ]; then
        echo "[ Debug ]: Mode Detected, pretending to Copy Files..."
        export copyState="pretended to copy"
        echo "[ Debug ]: Copied Geex Files to respective Directories"
    else
        echo "[ Notice ]: Please be ready to enter your Super User/Root Password soon."
        if [ "$escalationUtil" != "su" ]; then
            # Copy Channels
            $escalationUtil cp channels.scm $homeDirectory/.config/guix/channels.scm
            $escalationUtil cp channels.scm /etc/guix/channels.scm
            # Copy Directories
            $escalationUtil cp -r files /etc/guix/files
            $escalationUtil cp -r systems /etc/guix/systems
            $escalationUtil cp -r containers /etc/guix/containers
            # Copy Configs
            $escalationUtil cp home.scm /etc/guix/home.scm
            $escalationUtil cp config.scm /etc/guix/config.scm
            # Set Copy Status Variable
            export copyState="copied"
            echo "[ Creation ]: Copied Geex Files to respective Directories"
        else
            # Copy Channels
            $escalationUtil -c 'cp channels.scm $homeDirectory/.config/guix/channels.scm'
            $escalationUtil -c 'cp channels.scm /etc/guix/channels.scm'
            # Copy Directories
            $escalationUtil -c 'cp -r files /etc/guix/files'
            $escalationUtil -c 'cp -r systems /etc/guix/systems'
            $escalationUtil -c 'cp -r containers /etc/guix/containers'
            # Copy Configs
            $escalationUtil -c 'cp home.scm /etc/guix/home.scm'
            $escalationUtil -c 'cp config.scm /etc/guix/config.scm'
            # Set Copy Status Variable
            export copyState="copied"
            echo "[ Creation ]: Copied Geex Files to respective Directories"
        fi
    fi

    # Evaluate Backup Status
    if [[ "$backedUpEtc" == "yes" ]] && [[ "$backedUpCfg" == "yes" ]]; then
        export backupState="your '/etc/guix', as well as your '~/.config/guix'"
    elif [[ "$backedUpEtc" == "yes" ]] && [[ "$backedUpCfg" != "yes" ]]; then
        export backupState="your '/etc/guix'"
    elif [[ "$backedUpEtc" != "yes" ]] && [[ "$backedUpCfg" == "yes" ]]; then
        export backupState="your '~/.config/guix'"
    else
        export backupState="nothing"
    fi

    # Print Results
    echo -e \
    "
[ Geex ]
We have backed up $backupState, and $copyState over the Geex configuration files to their appropriate destination directories.

[ Configuration ]
To switch the system configuration between 'laptop', 'desktop', 'libre', or 'minimal', change the '%systemchoice' variable in the '/etc/guix/config.scm' file.

[ Commands ]
To rebuild your system, run:
 - guix system reconfigure /etc/guix/config.scm

To rebuild your guix home, run:
 - guix home reconfigure /etc/guix/home.scm

To start a home container, run:
 - guix home container /etc/guix/containers/<home-container>.scm

To start a system container, run:
 - guix system build /etc/guix/containers/<system-container>.scm
 - /gnu/store/<hash>-system
 - guix container exec <PID> /run/current-system/profile/bin/bash --login
"
    if [ -n "$GEEX_DEBUG" ]; then
        echo -e "\n[ Debug Status Report ]: The Mover has been run in Debug mode."
        if [ "$GEEX_MOVER_FORCE_DEBUG" == 1 ]; then
            echo -e "\n[ Mover Status Report ]: You ran the Mover without Debug Mode, but decided to retroactively enable it through the safety question."
        fi
    fi
    export moverFinished=1
}

for arg in "$@"; do
    case "$arg" in
        m|-m|--m|mover|-mover|--mover)
            export filteredArgs=$(echo -e "$arg" | sed "s/d/1/g" | sed "s/D/1/g")
            export filteredArgsOrig=$(echo -e "$@" | sed "s/d/1/g" | sed "s/D/1/g")
            export filterResult="$(echo -e "$filteredArgs $filteredArgsOrig")"
            if [[ "$filterResult" == *1* ]]; then
                export GEEX_DEBUG=1
                export GEEX_DEBUG_MODE=1
            fi
            export GEEX_MOVER_MODE=1
            unset filteredArgs
            unset filteredArgsOrig
            unset filterResult
            ;;
    esac
done

# Check if Commands are Missing
export missingCommandCount=0
for cmd in cp awk dialog git grep parted lsblk find tzselect ps; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "[ Warning ]: Missing required binary: $cmd" >&2
        export missingCommandCount=$(($missingCommandCount + 1))
    fi
done

# If Missing Command Debug is Enabled, pretend to be Missing Commands
if [ -n "$GEEX_DEBUG_MISSING_ENABLE" ]; then
    if [ ! -n "$GEEX_IGNORE_MISSING" ]; then
        echo -e "[ Debug ]: Missing Debug Enabled, pretending to have missing Packages.\n[ Warning ]: Commands missing, but found no way to retrieve them temporarily.\nAborting unless Variable 'GEEX_IGNORE_MISSING' is set."
        if [ ! -n "$GEEX_IGNORE_MISSING" ]; then
            echo "[ Status ]: Variable 'GEEX_IGNORE_MISSING' not set, aborting Process..."
            exit 1
        fi
    fi
fi

# If Commands are Missing, Open a Guix Shell with them Present
if [[ "$missingCommandCount" != 0 ]]; then
  if [ -z "$GUIX_ENVIRONMENT" ] && echo "[ Status ]: Checking for Guix, then running shell exec hook..." && command -v guix >/dev/null 2>&1 && guix shell coreutils bash gawk grep parted findutils util-linux git-minimal dialog tzdata procps -- true >/dev/null 2>&1; then
      echo "[ Guix ]: Found Guix, running guix shell exec hook..."
      export IN_GUIX_SHELL=1
      export GEEX_RUNNING_IN="guix"
      exec guix shell coreutils bash gawk grep parted findutils util-linux git-minimal dialog tzdata procps -- bash "$0" "$@"
  elif [ -z "$IN_NIX_SHELL" ] && echo "[ Warning ]: Guix not found, checking for Nix, then running shell exec hook..." && command -v nix-shell >/dev/null 2>&1 && nix-shell -p coreutils gawk bash gnugrep parted findutils util-linux git dialog tzdata procps --run true >/dev/null 2>&1; then
      echo "[ Nix ]: Found Nix, running nix shell exec hook..."
      export GEEX_RUNNING_IN="nix"
      exec nix-shell -p coreutils bash gawk gnugrep parted findutils util-linux git dialog tzdata procps --run "bash "$0" "$@""
  else
      echo -e "[ Warning ]: Commands missing, but found no way to retrieve them temporarily.\nAborting unless Variable 'GEEX_IGNORE_MISSING' is set."
      if [ ! -n "$GEEX_IGNORE_MISSING" ]; then
          echo "[ Status ]: Variable 'GEEX_IGNORE_MISSING' not set, aborting Process..."
          exit 1
      fi
  fi
else
    echo "[ Status ]: All required Commands present, continuing..."
fi

if [ ! -z "$GUIX_ENVIRONMENT" ]; then
    echo "[ Status ]: Running inside Guix Shell for Command Compatibility"
fi
if [ ! -z "$IN_NIX_SHELL" ]; then
    echo "[ Status ]: Running inside Nix Shell for Command Compatibility"
fi

if leftoverFileReport=$(ls -l -a /tmp | grep "geex") >/dev/null; then
    export verboseFoundLeftoverFiles="Yes"
else
    export verboseFoundLeftoverFiles="No"
fi

cat > /tmp/geex.channels.dd <<'EOF'
(append (list
         (channel
          (name 'jonabron)
          (branch "master")
          (url "https://github.com/librepup/jonabron.git"))
         (channel
          (name 'nonguix)
          (url "https://gitlab.com/nonguix/nonguix")
          (commit "48a8706d44040cc7014f36873dbd834c048aadd3")
          (introduction
           (make-channel-introduction
            "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
            (openpgp-fingerprint
             "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
         (channel
           (name 'guix)
           (url "https://git.guix.gnu.org/guix.git")
           (commit "4baa120b8b298bec155c5b12c8068dda3c07df40")
           (branch "master")
           (introduction
             (make-channel-introduction
               "9edb3f66fd807b096b48283debdcddccfea34bad"
               (openpgp-fingerprint
                "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))
         (channel
          (name 'emacs)
          (url "https://github.com/garrgravarr/guix-emacs")
          (commit "6601278b9ec901e20cfe5fd9caee3d9ce6e6d0c9")
          (introduction
           (make-channel-introduction
            "d676ef5f94d2c1bd32f11f084d47dcb1a180fdd4"
            (openpgp-fingerprint
             "2DDF 9601 2828 6172 F10C  51A4 E80D 3600 684C 71BA")))))
        %default-channels)
EOF

cat > /tmp/geex.config.desktop.template.dd <<'EOF'
(use-modules (gnu)
             (gnu system)
             (gnu system nss)
             (gnu packages)
             (gnu packages xorg)
             (gnu packages certs)
             (gnu packages shells)
             (gnu packages admin)
             (gnu packages base)
             (gnu services)
             (gnu services xorg)
             (gnu services desktop)
             (gnu services nix)
             (gnu services sound)
             (gnu services audio)
             (gnu services networking)
             (gnu services virtualization)
             (guix)
             (guix utils)
             ;; Nongnu & Nonguix
             (nongnu packages linux)
             (nongnu packages nvidia)
             (nongnu services nvidia)
             (nongnu system linux-initrd)
             (nonguix transformations)
             ;; Jonabron
             (jonabron packages wm)
             (jonabron packages fonts)
             (jonabron packages games)
             (jonabron packages communication))

(use-service-modules desktop
                     sound
                     audio
                     networking
                     ssh
                     xorg
                     dbus)
(use-package-modules wm
                     bootloaders
                     certs
                     shells
                     version-control
                     xorg)

(define %guix-os
  (operating-system
    (kernel linux)
    (initrd microcode-initrd)
    (firmware (append (list intel-microcode linux-firmware) %base-firmware))
    (host-name "GEEX_HOSTNAME")
    (timezone "GEEX_TIMEZONE")
    (locale "en_US.utf8")
    (keyboard-layout (keyboard-layout GEEX_KEYBOARD_LAYOUT))

    ;; Bootloader
    GEEX_BIOS_OPTIONAL

    GEEX_FILESYSTEM_OPTIONAL

    ;; Users
    (users (cons (user-account
                   (name "GEEX_USERNAME")
                   (comment "GEEX_USERNAME User")
                   (group "users")
                   (home-directory "/home/GEEX_USERNAME")
                   (supplementary-groups '("wheel" "netdev"
                                           "audio"
                                           "video"
                                           "input"
                                           GEEX_NIX_GROUP_OPTIONAL
                                           "tty"))
                   (shell (file-append zsh "/bin/zsh"))) %base-user-accounts))

    ;; Packages
    (packages (append (map specification->package
                           '("eza" "bat"
                             "zoxide"
                             GEEX_DOAS_PACKAGE_OPTIONAL
                             GEEX_I3_PACKAGE_OPTIONAL
                             GEEX_NAITRE_PACKAGE_OPTIONAL
                             GEEX_XMONAD_PACKAGE_OPTIONAL
                             "ripgrep"
                             "grep"
                             "coreutils"
                             "file"
                             "glibc-locales"
                             "ncurses"
                             "zsh"
                             "git-minimal"
                             "emacs-no-x"
                             "usbutils"
                             "pciutils"
                             "wpa-supplicant"
                             "dhcpcd"
                             "naitre"
                             "xmonad"
                             "ghc-xmonad-contrib"
                             "procps"
                             "wget"
                             "curl"
                             "nss-certs"
                             "bash"
                             "sed"
                             GEEX_EXTRA_PACKAGE_LIST_OPTIONAL
                             "kitty"))))

    ;; Services
    (services
     (append (list (service alsa-service-type)
                   GEEX_NIX_SERVICE_OPTIONAL
                   GEEX_HURD_SERVICE_OPTIONAL
                   GEEX_GNOME_SERVICE_OPTIONAL
                   GEEX_DOAS_SERVICE_OPTIONAL
                   (set-xorg-configuration
                    (xorg-configuration (keyboard-layout keyboard-layout)
                                        (modules (cons nvidia-driver
                                                       %default-xorg-modules))
                                        (drivers '("nvidia")))))

             (modify-services %desktop-services
               (gdm-service-type config =>
                                 (gdm-configuration (inherit config)
                                                    (wayland? #t)))
               (guix-service-type config =>
                                  (guix-configuration (inherit config)
                                                      (substitute-urls (append
                                                                        (list
                                                                         "https://ci.guix.gnu.org"
                                                                         "https://berlin.guix.gnu.org"
                                                                         "https://bordeaux.guix.gnu.org"
                                                                         "https://substitutes.nonguix.org"
                                                                         "https://hydra-guix-129.guix.gnu.org"
                                                                         "https://substitutes.guix.gofranz.com")
                                                                        %default-substitute-urls))
                                                      (authorized-keys (append
                                                                        (list (local-file
                                                                               "/etc/guix/files/keys/nonguix.pub"))
                                                                        %default-authorized-guix-keys))))
               (mingetty-service-type config =>
                                      (mingetty-configuration (inherit config)
                                                              (auto-login
                                                               "GEEX_USERNAME"))))))))

((compose (nonguix-transformation-nvidia))
 %guix-os)
EOF

cat > /tmp/geex.config.minimal.template.dd <<'EOF'
(use-modules (gnu)
             (gnu system)
             (gnu system nss)
             (gnu packages)
             (gnu packages xorg)
             (gnu packages certs)
             (gnu packages shells)
             (gnu packages admin)
             (gnu packages base)
             (gnu services)
             (gnu services xorg)
             (gnu services desktop)
             (gnu services nix)
             (gnu services sound)
             (gnu services audio)
             (gnu services networking)
             (guix)
             (guix utils)
             ;; Jonabron
             (jonabrok packages wm)
             ;; Nongnu & Nonguix
             (nongnu packages linux)
             (nongnu system linux-initrd))

(use-service-modules desktop
                     sound
                     audio
                     networking
                     ssh
                     xorg
                     dbus)
(use-package-modules wm bootloaders certs shells version-control)

(define %guix-os
  (operating-system
    (kernel linux)
    (initrd microcode-initrd)
    (firmware (append (list intel-microcode linux-firmware) %base-firmware))
    (host-name "GEEX_HOSTNAME")
    (timezone "GEEX_TIMEZONE")
    (locale "en_US.utf8")
    (keyboard-layout (keyboard-layout GEEX_KEYBOARD_LAYOUT))

    ;; Bootloader
    GEEX_BIOS_OPTIONAL

    GEEX_FILESYSTEM_OPTIONAL

    ;; Users
    (users (cons (user-account
                   (name "GEEX_USERNAME")
                   (comment "GEEX_USERNAME User")
                   (group "users")
                   (home-directory "/home/GEEX_USERNAME")
                   (supplementary-groups '("wheel" "netdev"
                                           "audio"
                                           "video"
                                           GEEX_NIX_GROUP_OPTIONAL
                                           "input"
                                           "tty"))
                   (shell (file-append zsh "/bin/zsh"))) %base-user-accounts))

    ;; Packages
    (packages (append (map specification->package
                           '("grep" "coreutils"
                             "glibc-locales"
                             "ncurses"
                             "zsh"
                             "git-minimal"
                             "emacs-no-x"
                             "usbutils"
                             GEEX_I3_PACKAGE_OPTIONAL
                             GEEX_NAITRE_PACKAGE_OPTIONAL
                             GEEX_DOAS_PACKAGE_OPTIONAL
                             GEEX_XMONAD_PACKAGE_OPTIONAL
                             "pciutils"
                             "wpa-supplicant"
                             "procps"
                             "wget"
                             "curl"
                             "nss-certs"
                             "bash"
                             "sed"
                             GEEX_EXTRA_PACKAGE_LIST_OPTIONAL
                             "dhcpcd"))))

    ;; Services
    (services
     (append (list (service alsa-service-type)
                   GEEX_DOAS_SERVICE_OPTIONAL
                   GEEX_NIX_SERVICE_OPTIONAL
                   GEEX_HURD_SERVICE_OPTIONAL
                   GEEX_GNOME_SERVICE_OPTIONAL
              )

                   (modify-services %desktop-services
                     (guix-service-type config =>
                                        (guix-configuration (inherit config)
                                                            (substitute-urls (append
                                                                              (list
                                                                               "https://ci.guix.gnu.org"
                                                                               "https://berlin.guix.gnu.org"
                                                                               "https://bordeaux.guix.gnu.org"
                                                                               "https://substitutes.nonguix.org"
                                                                               "https://hydra-guix-129.guix.gnu.org"
                                                                               "https://substitutes.guix.gofranz.com")
                                                                              %default-substitute-urls))
                                                            (authorized-keys (append
                                                                              (list
                                                                               (local-file
                                                                                "/etc/guix/files/keys/nonguix.pub"))
                                                                              %default-authorized-guix-keys))))))))))

%guix-os
EOF

cat > /tmp/geex.config.libre.template.dd <<'EOF'
(use-modules (gnu)
             (gnu system)
             (gnu system nss)
             (gnu packages)
             (gnu packages xorg)
             (gnu packages certs)
             (gnu packages shells)
             (gnu packages admin)
             (gnu packages base)
             (gnu services)
             (gnu services xorg)
             (gnu services desktop)
             (gnu services nix)
             (gnu services sound)
             (gnu services audio)
             (gnu services networking)
             (guix)
             (guix utils)
             (jonabron packages wm))

(use-service-modules desktop
                     sound
                     audio
                     networking
                     ssh
                     xorg
                     dbus)
(use-package-modules wm
                     bootloaders
                     certs
                     shells
                     version-control
                     xorg)

(define %guix-os
  (operating-system
    (host-name "GEEX_HOSTNAME")
    (timezone "GEEX_TIMEZONE")
    (locale "en_US.utf8")
    (keyboard-layout (keyboard-layout GEEX_KEYBOARD_LAYOUT))

    ;; Bootloader
    GEEX_BIOS_OPTIONAL

    GEEX_FILESYSTEM_OPTIONAL

    ;; Users
    (users (cons (user-account
                   (name "GEEX_USERNAME")
                   (comment "GEEX_USERNAME User")
                   (group "users")
                   (home-directory "/home/GEEX_USERNAME")
                   (supplementary-groups '("wheel" "netdev"
                                           "audio"
                                           "video"
                                           "input"
                                           GEEX_NIX_GROUP_OPTIONAL
                                           "tty"))
                   (shell (file-append zsh "/bin/zsh"))) %base-user-accounts))

    ;; Packages
    (packages (append (map specification->package
                           '("eza" "bat"
                             "zoxide"
                             "ripgrep"
                             "grep"
                             "file"
                             "coreutils"
                             "glibc-locales"
                             "ncurses"
                             "zsh"
                             "git-minimal"
                             "emacs-no-x"
                             "usbutils"
                             "pciutils"
                             "wpa-supplicant"
                             "dhcpcd"
                             GEEX_I3_PACKAGE_OPTIONAL
                             GEEX_XMONAD_PACKAGE_OPTIONAL
                             GEEX_NAITRE_PACKAGE_OPTIONAL
                             GEEX_DOAS_PACKAGE_OPTIONAL
                             "procps"
                             "wget"
                             "curl"
                             "nss-certs"
                             "bash"
                             GEEX_EXTRA_PACKAGE_LIST_OPTIONAL
                             "sed"
                             "kitty"))))

    ;; Services
    (services
     (append (list (set-xorg-configuration
                    (xorg-configuration (keyboard-layout keyboard-layout)))
                   GEEX_GNOME_SERVICE_OPTIONAL
                   GEEX_NIX_SERVICE_OPTIONAL
                   GEEX_DOAS_SERVICE_OPTIONAL
                   GEEX_HURD_SERVICE_OPTIONAL
             )
             (modify-services %desktop-services
               (gdm-service-type config =>
                                 (gdm-configuration (inherit config)
                                                    (wayland? #t)))
               (delete pulseaudio-service-type)
               (guix-service-type config =>
                                  (guix-configuration (inherit config)
                                                      (substitute-urls (append
                                                                        (list
                                                                         "https://ci.guix.gnu.org"
                                                                         "https://berlin.guix.gnu.org"
                                                                         "https://bordeaux.guix.gnu.org"
                                                                         "https://hydra-guix-129.guix.gnu.org"
                                                                         "https://substitutes.guix.gofranz.com")
                                                                        %default-substitute-urls))))
               (mingetty-service-type config =>
                                      (mingetty-configuration (inherit config)
                                                              (auto-login
                                                               "GEEX_USERNAME"))))))))

%guix-os
EOF

cat > /tmp/geex.config.laptop.template.dd <<'EOF'
(use-modules (gnu)
             (gnu system)
             (gnu system nss)
             (gnu packages)
             (gnu packages xorg)
             (gnu packages certs)
             (gnu packages shells)
             (gnu packages admin)
             (gnu packages base)
             (gnu services)
             (gnu services xorg)
             (gnu services desktop)
             (gnu services nix)
             (gnu services sound)
             (gnu services audio)
             (gnu services networking)
             (guix)
             (guix utils)
             ;; Nongnu & Nonguix
             (nongnu packages linux)
             (nongnu system linux-initrd)
             ;; Jonabron
             (jonabron packages wm)
             (jonabron packages fonts)
             (jonabron packages communication)
             (jonabron packages games))

(use-service-modules desktop
                     sound
                     audio
                     networking
                     ssh
                     xorg
                     dbus
                     pm)
(use-package-modules wm
                     bootloaders
                     certs
                     shells
                     version-control
                     xorg)

(define %guix-os
  (operating-system
    (kernel linux)
    (initrd microcode-initrd)
    (firmware (append (list intel-microcode linux-firmware) %base-firmware))
    (host-name "GEEX_HOSTNAME")
    (timezone "GEEX_TIMEZONE")
    (locale "en_US.utf8")
    (keyboard-layout (keyboard-layout GEEX_KEYBOARD_LAYOUT))

    ;; Bootloader
    GEEX_BIOS_OPTIONAL

    GEEX_FILESYSTEM_OPTIONAL

    ;; Users
    (users (cons (user-account
                   (name "GEEX_USERNAME")
                   (comment "GEEX_USERNAME User")
                   (group "users")
                   (home-directory "/home/GEEX_USERNAME")
                   (supplementary-groups '("wheel" "netdev"
                                           "audio"
                                           "video"
                                           "input"
                                           GEEX_NIX_GROUP_OPTIONAL
                                           "tty"))
                   (shell (file-append zsh "/bin/zsh"))) %base-user-accounts))

    ;; Packages
    (packages (append (map specification->package
                           '("eza" "bat"
                             "zoxide"
                             GEEX_DOAS_PACKAGE_OPTIONAL
                             GEEX_I3_PACKAGE_OPTIONAL
                             GEEX_NAITRE_PACKAGE_OPTIONAL
                             GEEX_XMONAD_PACKAGE_OPTIONAL
                             "ripgrep"
                             "grep"
                             "coreutils"
                             "file"
                             "glibc-locales"
                             "ncurses"
                             "zsh"
                             "git-minimal"
                             "emacs-no-x"
                             "usbutils"
                             "pciutils"
                             "wpa-supplicant"
                             "dhcpcd"
                             "naitre"
                             "xmonad"
                             GEEX_EXTRA_PACKAGE_LIST_OPTIONAL
                             "ghc-xmonad-contrib"
                             "procps"
                             "wget"
                             "curl"
                             "nss-certs"
                             "bash"
                             "sed"
                             "kitty"))))

    ;; Services
    (services
     (append (list (service alsa-service-type)
                   (service tlp-service-type
                            (tlp-configuration (cpu-scaling-governor-on-ac '("performace"))
                                               (cpu-scaling-governor-on-bat '("powersave"))
                                               (sched-powersave-on-bat? #t)))
                   GEEX_NIX_SERVICE_OPTIONAL
                   GEEX_HURD_SERVICE_OPTIONAL
                   GEEX_GNOME_SERVICE_OPTIONAL
                   GEEX_DOAS_SERVICE_OPTIONAL
                   (set-xorg-configuration
                    (xorg-configuration (keyboard-layout keyboard-layout))))

             (modify-services %desktop-services
               (gdm-service-type config =>
                                 (gdm-configuration (inherit config)
                                                    (wayland? #t)))
               (guix-service-type config =>
                                  (guix-configuration (inherit config)
                                                      (substitute-urls (append
                                                                        (list
                                                                         "https://ci.guix.gnu.org"
                                                                         "https://berlin.guix.gnu.org"
                                                                         "https://bordeaux.guix.gnu.org"
                                                                         "https://substitutes.nonguix.org"
                                                                         "https://hydra-guix-129.guix.gnu.org"
                                                                         "https://substitutes.guix.gofranz.com")
                                                                        %default-substitute-urls))
                                                      (authorized-keys (append
                                                                        (list (local-file
                                                                               "/etc/guix/files/keys/nonguix.pub"))
                                                                        %default-authorized-guix-keys))))
               (mingetty-service-type config =>
                                      (mingetty-configuration (inherit config)
                                                              (auto-login
                                                               "GEEX_USERNAME"))))))))

%guix-os
EOF



# Setup Hooks
checkMountPointHook() {
    export randomMountNum=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)
    export longRandomString=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 64)
    if mountpoint -q /mnt; then
        if mountpoint -q /Mount; then
            if mountpoint -q /Geex; then
                if mountpoint -q /UniqueMountPointFromGeex; then
                    export geexMount="$(echo -e "/mnt${randomMountNum}")"
                    if [[ ! -d "$geexMount" ]]; then
                        mkdir -p $geexMount
                    fi
                    if mountpoint -q $geexMount; then
                        unset geexMount
                        export geexMount="$(echo -e "/tmp/geex.emergency.mount-${longRandomString}")"
                        if [[ ! -d "$geexMount" ]]; then
                            mkdir -p $geexMount
                        fi
                    fi
                else
                    if [[ ! -d "/UniqueMountPointFromGeex" ]]; then
                        mkdir -p /UniqueMountPointFromGeex
                    fi
                    export geexMount=/UniqueMountPointFromGeex
                fi
            else
                if [[ ! -d "/Geex" ]]; then
                    mkdir -p /Geex
                fi
                export geexMount=/Geex
            fi
        else
            if [[ ! -d "/Mount" ]]; then
                mkdir -p /Mount
            fi
            export geexMount=/Mount
        fi
    else
        if [[ ! -d "/mnt" ]]; then
            mkdir -p /mnt
        fi
        export geexMount=/mnt
    fi
    if [ -n "$GEEX_VERBOSE_MODE" ] || [ "$GEEX_VERBOSE_MODE" == 1 ]; then
        verboseNotice=$(dialog --backtitle "Geex Installer" --title "Verbose Notice" --msgbox "The Installer has analized your systems mount-points and determined that:\n\n$geexMount\n\nis the appropriate, free mount-point to use for systems initialization.\n\nThe Installer tested '/mnt', '/Mount', '/Geex', '/UniqueMountPointFromGeex', and '/mnt${randomMountNum}' for available mount-points.\n\nIn worst-case scenarios, the installer would have fell back to mount to '/tmp/geex.emergency.mount-${longRandomString}'." 34 68 3>&1 1>&2 2>&3)
    fi
}
channelPullHook() {
    if [ -f "/tmp/geex.channels.dd" ]; then
        cp /tmp/geex.channels.dd /tmp/channels.scm
        if [ -n "$GEEX_VERBOSE_MODE" ] || [ "$GEEX_VERBOSE_MODE" == 1 ]; then
            verboseNotice=$(dialog --backtitle "Geex Installer" --title "Verbose Notice" --msgbox "The Installer has successfully copied the '/tmp/geex.channels.dd' file to '/tmp/channels.scm', and is now ready to pull the required Guix Channels." 24 40 3>&1 1>&2 2>&3)
        fi
        if [ -d "${geexMount}/etc/guix" ]; then
            cp /tmp/channels.scm ${geexMount}/etc/guix/channels.scm
            if [ -n "$GEEX_VERBOSE_MODE" ] || [ "$GEEX_VERBOSE_MODE" == 1 ]; then
                verboseNotice=$(dialog --backtitle "Geex Installer" --title "Verbose Notice" --msgbox "The Installer has successfully copied the '/tmp/channels.scm' file to '${geexMount}/etc/guix/channels.scm', and is now ready to pull the required Guix Channels." 24 40 3>&1 1>&2 2>&3)
            fi
            export pullFrom="mnt"
        elif [ -n "$GEEX_DEBUG" ] || [ -n "$GEEX_DEBUG_MODE" ]; then
            export pullFrom="Mock"
        else
            if [ -n "$GEEX_VERBOSE_MODE" ] || [ "$GEEX_VERBOSE_MODE" == 1 ]; then
                verboseNotice=$(dialog --backtitle "Geex Installer" --title "Verbose Notice" --msgbox "The Installer has not been able to set up the 'channels.scm' file to be copied to/appear in '${geexMount}/etc/guix/channels.scm', and will now continue to pull the channels from '/tmp/channels.scm'." 24 40 3>&1 1>&2 2>&3)
            fi
            export pullFrom="tmp"
        fi
        if [ "$pullFrom" == "mnt" ]; then
            export GEEX_GUIX_CHANNEL_PULL_CHECKFILE=/tmp/geex.guix.channel.pull.check.file.dd
            if [ -f "$GEEX_GUIX_CHANNEL_PULL_CHECKFILE" ]; then
                rm $GEEX_GUIX_CHANNEL_PULL_CHECKFILE
            fi
            guix pull --channels=${geexMount}/etc/guix/channels.scm && touch $GEEX_GUIX_CHANNEL_PULL_CHECKFILE
            if [ -f "$GEEX_GUIX_CHANNEL_PULL_CHECKFILE" ]; then
                export finPull=1
            else
                errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "The Installer has failed to pull in the new and required channels in '${geexMount}/etc/guix/channels.scm'. This error is un-recoverable, and the installer would recommend you to abort the installation process now, and investigate this error. Possible causes are:\n\n - 'guix' Command is not Available\n - Installer Failed to write the Channels File ('${geexMount}/etc/guix/channels.scm')\n - Your Filesystem was not correctly Mounted to '${geexMount}'.\n\nIf you still want to continue, which is NOT RECOMMENDED, select 'Ignore and Continue Anyways', otherwise investigate the error and try again later." 40 120 10 \
                                      abort "Abort" \
                                      ignore "Ignore and Continue Anyways" \
                                      3>&1 1>&2 2>&3) || exit 1
                if [ "$errorMessage" == "abort" ]; then
                    echo "[ Status ]: Aborting..."
                    exit 1
                else
                    export finPull=0
                fi
            fi
        elif [ "$pullFrom" == "tmp" ]; then
            export GEEX_GUIX_CHANNEL_PULL_CHECKFILE=/tmp/geex.guix.channel.pull.check.file.dd
            if [ -f "$GEEX_GUIX_CHANNEL_PULL_CHECKFILE" ]; then
                rm $GEEX_GUIX_CHANNEL_PULL_CHECKFILE
            fi
            guix pull --channels=/tmp/channels.scm && touch $GEEX_GUIX_CHANNEL_PULL_CHECKFILE
            if [ -f "$GEEX_GUIX_CHANNEL_PULL_CHECKFILE" ]; then
                export finPull=1
            else
                errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "The Installer has failed to pull in the new and required channels in '/tmp/channels.scm'. This error is un-recoverable, and the installer would recommend you to abort the installation process now, and investigate this error. Possible causes are:\n\n - 'guix' Command is not Available\n - Installer Failed to write the Channels File ('/tmp/channels.scm')\n - Your Filesystem was not correctly Mounted to '${geexMount}'.\n - Your '/tmp' Directory is not Writeable/Read-Only\n\nIf you still want to continue, which is NOT RECOMMENDED, select 'Ignore and Continue Anyways', otherwise investigate the error and try again later." 40 120 10 \
                                      abort "Abort" \
                                      ignore "Ignore and Continue Anyways" \
                                      3>&1 1>&2 2>&3) || exit 1
                if [ "$errorMessage" == "abort" ]; then
                    echo "[ Status ]: Aborting..."
                    exit 1
                else
                    export finPull=0
                fi
            fi
        elif [ "$pullFrom" == "Mock" ]; then
            if [ -n "$GEEX_VERBOSE_MODE" ] || [ "$GEEX_VERBOSE_MODE" == 1 ]; then
                verboseNotice=$(dialog --backtitle "Geex Installer" --title "Verbose Notice" --msgbox "The Installer has set your Guix Channel Pull-Method (pullFrom=$pullFrom) to 'Mock', this probably happened because you are running in Debug Mode.\n\nThe Installer will now pretend to have pulled the required Channels correctly and continue with a Mock Installation Process." 24 40 3>&1 1>&2 2>&3)
            fi
            echo "[ Debug ]: Pretending to have pulled channels..."
            export finPull=1
        else
            export finPull=0
        fi
    else
        if [ -n "$GEEX_VERBOSE_MODE" ] || [ "$GEEX_VERBOSE_MODE" == 1 ]; then
            verboseNotice=$(dialog --backtitle "Geex Installer" --title "Verbose Notice" --msgbox "The Installer has encountered one or more errors trying to correctly set-up your 'channels.scm' Guix Channels File on both your '${geexMount}', as well as your '/tmp' directories.\n\nIt will now try to pull the 'channels.scm' file directly from GitHub in a last attempt to recover and continue with the installation process as intended." 24 40 3>&1 1>&2 2>&3)
        fi
        mkdir -p /tmp/geex.git.storage
        git clone https://github.com/librepup/geex.git /tmp/geex.git.storage/geex
        cp /tmp/geex.git.storage/geex/channels.scm /tmp/geex.git.channels.scm
        export GEEX_GUIX_CHANNEL_PULL_CHECKFILE=/tmp/geex.guix.channel.pull.check.file.dd
        if [ -f "$GEEX_GUIX_CHANNEL_PULL_CHECKFILE" ]; then
            rm $GEEX_GUIX_CHANNEL_PULL_CHECKFILE
        fi
        guix pull /tmp/geex.git.channels.scm && touch $GEEX_GUIX_CHANNEL_PULL_CHECKFILE
        if [ -f "$GEEX_GUIX_CHANNEL_PULL_CHECKFILE" ]; then
            export finPull=1
        else
            errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "The Installer has failed to pull in the new and required channels in '/tmp/geex.git.channels.scm'. This error is un-recoverable, and the installer would recommend you to abort the installation process now, and investigate this error. Possible causes are:\n\n - 'git' Command is not Available\n - The Repository URL Changed and is now Outdated (Unlikely)\n - 'guix' Command is not Available\n - Installer Failed to write the Channels File ('/tmp/geex.git.channels.scm')\n - Your Filesystem was not correctly Mounted to '${geexMount}'.\n - Your '/tmp' Directory is not Writeable/Read-Only\n\nIf you still want to continue, which is NOT RECOMMENDED, select 'Ignore and Continue Anyways', otherwise investigate the error and try again later." 40 120 10 \
                                  abort "Abort" \
                                  ignore "Ignore and Continue Anyways" \
                                  3>&1 1>&2 2>&3) || exit 1
            if [ "$errorMessage" == "abort" ]; then
                echo "[ Status ]: Aborting..."
                exit 1
            else
                export finPull=0
            fi
        fi
    fi
    if [ "$finPull" == 0 ]; then
        errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "The Installer failed to pull the appropriate Guix channels, due to one of the following issues:\n1. Connection issue - check your internet connection.\n2. File mismatch - cannot find channels.scm occurrence anywhere.\n3. Guix binary missing - if this is the issue, make sure you have the command 'guix' available.\n\nContinue anyways?" 32 50 10 \
                              abort "Abort" \
                              continue "Continue Anyways" \
                              3>&1 1>&2 2>&3) || exit 1
        if [ "$errorMessage" == "abort" ]; then
            echo "[ Status ]: Aborting..."
            exit 1
        else
            export channelReport="No"
        fi
    elif [ -n "$GEEX_DEBUG" ] || [ -n "$GEEX_DEBUG_MODE" ]; then
        if [ -n "$GEEX_VERBOSE_MODE" ] || [ "$GEEX_VERBOSE_MODE" == 1 ]; then
            successMessage=$(dialog --backtitle "Geex Installer" --title "Channels" --menu "Debug Mode Detected, pretending as if channels were pulled successfully.\n\nYour Mock Installation will now continue as planned." 32 50 10 \
                            continue "Continue" \
                            abort "Abort" \
                            3>&1 1>&2 2>&3) || exit 1
            if [ "$successMessage" == "abort" ]; then
                echo "[ Status ]: Aborting..."
                exit 1
            fi
        fi
        export channelReport="Mock"
    else
        successMessage=$(dialog --backtitle "Geex Installer" --title "Channels" --menu "Successfully pulled in the latest channels! Installation will now continue as planned." 32 50 10 \
                                continue "Continue" \
                                abort "Abort" \
                                3>&1 1>&2 2>&3) || exit 1
        if [ "$successMessage" == "abort" ]; then
            echo "[ Status ]: Aborting..."
            exit 1
        fi
        export channelReport="Yes"
    fi
}
desktopEnvironmentsHook() {
    deSelection=$(dialog --checklist "Select Desktop(s):" 15 50 5 \
                         gnome "Gnome" on \
                         naitre "NaitreHUD" on \
                         xmonad "XMonad" off \
                         i3wm "i3wm" off \
                         3>&1 1>&2 2>&3) || exit 1
    # i3wm
    i3PackageBlock="$(echo -e "                             \"i3-wm\"\n                             \"i3-autotiling\"\n                             \"dmenu\"\n                             \"i3status\"")"
    if [ -f "/tmp/geex.wm.i3.packages.dd" ]; then
        rm /tmp/geex.wm.i3.packages.dd
    fi
    echo "$i3PackageBlock" >> /tmp/geex.wm.i3.packages.dd
    # Gnome
    gnomeServiceBlock="$(echo -e "                   (service gnome-desktop-service-type)")"
    if [ -f "/tmp/geex.wm.gnome.service.dd" ]; then
        rm /tmp/geex.wm.gnome.service.dd
    fi
    echo "$gnomeServiceBlock" >> /tmp/geex.wm.gnome.service.dd
    # NaitreHUD
    naitrePackageBlock="$(echo -e "                             \"naitre\"\n                             \"vicinae\"\n                             \"waybar\"\n                             \"dankmaterialshell\"\n                             \"swaybg\"\n                             \"wl-clipboard\"")"
    if [ -f "/tmp/geex.wm.naitre.packages.dd" ]; then
        rm /tmp/geex.wm.naitre.packages.dd
    fi
    echo "$naitrePackageBlock" >> /tmp/geex.wm.naitre.packages.dd
    # XMonad
    xmonadPackageBlock="$(echo -e "                             \"xmonad\"\n                             \"ghc-xmonad-contrib\"\n                             \"xmobad\"")"
    if [ -f "/tmp/geex.wm.xmonad.packages.dd" ]; then
        rm /tmp/geex.wm.xmonad.packages.dd
    fi
    echo "$xmonadPackageBlock" >> /tmp/geex.wm.xmonad.packages.dd
    # Replace if Selected
    if [ -f "/tmp/geex.config.${stager}.dd" ]; then
        if [[ "$deSelection" == *i3wm* ]]; then
            sed -i "/GEEX_I3_PACKAGE_OPTIONAL/{
                   r /tmp/geex.wm.i3.packages.dd
                   d
                   }" /tmp/geex.config.${stager}.dd
            export installedDesktopi3=1
        else
            sed -i 's/GEEX_I3_PACKAGE_OPTIONAL//g' /tmp/geex.config.${stager}.dd
            export installedDesktopi3=0
        fi
        if [[ "$deSelection" == *gnome* ]]; then
            sed -i "/GEEX_GNOME_SERVICE_OPTIONAL/{
                   r /tmp/geex.wm.gnome.service.dd
                   d
                   }" /tmp/geex.config.${stager}.dd
            export installedDesktopGnome=1
        else
            sed -i 's/GEEX_GNOME_SERVICE_OPTIONAL//g' /tmp/geex.config.${stager}.dd
            export installedDesktopGnome=0
        fi
        if [[ "$deSelection" == *naitre* ]]; then
            sed -i "/GEEX_NAITRE_PACKAGE_OPTIONAL/{
                   r /tmp/geex.wm.naitre.packages.dd
                   d
                   }" /tmp/geex.config.${stager}.dd
            export installedDesktopNaitre=1
        else
            sed -i 's/GEEX_NAITRE_PACKAGE_OPTIONAL//g' /tmp/geex.config.${stager}.dd
            export installedDesktopNaitre=0
        fi
        if [[ "$deSelection" == *xmonad* ]]; then
            sed -i "/GEEX_XMONAD_PACKAGE_OPTIONAL/{
                   r /tmp/geex.wm.xmonad.packages.dd
                   d
                   }" /tmp/geex.config.${stager}.dd
            export installedDesktopXmonad=1
        else
            sed -i 's/GEEX_XMONAD_PACKAGE_OPTIONAL//g' /tmp/geex.config.${stager}.dd
            export installedDesktopXmonad=0
        fi
        export finishedDesktopSetup=1
    else
        export finishedDesktopSetup=0
    fi
}
serviceSetupHook() {
    serviceSelection=$(dialog --checklist "Select Services:" 15 50 5 \
                              hurd "GNU Hurd" off \
                              nix "Nix" off \
                              doas "doas" on \
                              3>&1 1>&2 2>&3) || exit 1
    read -r -a serviceSelectionArray <<< "$serviceSelection"
    serviceSelectionCount="${#serviceSelectionArray[@]}"
    serviceSelectionSummaryText=$(printf '%s\n' "${serviceSelectionArray[@]}")
    # Nix Service
    nixServiceBlock="$(echo -e "                   (service nix-service-type)\n")"
    nixGroupBlock="$(echo -e "                                           \"nixbld\"")"
    if [ -f "/tmp/geex.service.nix.block.dd" ]; then
        rm /tmp/geex.service.nix.block.dd
    fi
    if [ -f "/tmp/geex.group.nix.block.dd" ]; then
        rm /tmp/geex.group.nix.block.dd
    fi
    echo -e "$nixServiceBlock" >> /tmp/geex.service.nix.block.dd
    echo -e "$nixGroupBlock" >> /tmp/geex.group.nix.block.dd
    # Doas Service
    doasPackageBlock="$(echo -e "                             \"opendoas\"")"
    doasServiceBlock="$(echo -e "                   (simple-service 'doas-config etc-service-type\n                                   (list \`(\"doas.conf\" ,(plain-file\n                                                         \"doas.conf\"\n                                                         \"permit nopass keepenv root\npermit persist keepenv setenv :wheel\"))))")"
    if [ -f "/tmp/geex.service.doas.block.dd" ]; then
        rm /tmp/geex.service.doas.block.dd
    fi
    if [ -f "/tmp/geex.package.doas.block.dd" ]; then
        rm /tmp/geex.package.doas.block.dd
    fi
    echo "$doasServiceBlock" >> /tmp/geex.service.doas.block.dd
    echo "$doasPackageBlock" >> /tmp/geex.package.doas.block.dd
    # Hurd Service
    hurdServiceBlock="$(echo -e "                   (service hurd-vm-service-type\n                                       (hurd-vm-configuration (memory-size 2048)\n                                                              (secret-directory \"/etc/guix/hurd-secrets\")))")"
    if [ -f "/tmp/geex.service.hurd.block.dd" ]; then
        rm /tmp/geex.service.hurd.block.dd
    fi
    echo -e "$hurdServiceBlock" >> /tmp/geex.service.hurd.block.dd
    # Replace if Selected
    if [ -f "/tmp/geex.config.${stager}.dd" ]; then
        if [[ "$serviceSelection" == *doas* ]]; then
            sed -i "/GEEX_DOAS_SERVICE_OPTIONAL/{
                   r /tmp/geex.service.doas.block.dd
                   d
                   }" /tmp/geex.config.${stager}.dd
            sed -i "/GEEX_DOAS_PACKAGE_OPTIONAL/{
                   r /tmp/geex.package.doas.block.dd
                   d
                   }" /tmp/geex.config.${stager}.dd
            export installedServiceDoas=1
        else
            sed -i 's/GEEX_DOAS_SERVICE_OPTIONAL//g' /tmp/geex.config.${stager}.dd
            sed -i 's/GEEX_DOAS_PACKAGE_OPTIONAL//g' /tmp/geex.config.${stager}.dd
            export installedServiceDoas=0
        fi
        if [[ "$serviceSelection" == *nix* ]]; then
            sed -i "/GEEX_NIX_SERVICE_OPTIONAL/{
                   r /tmp/geex.service.nix.block.dd
                   d
                   }" /tmp/geex.config.${stager}.dd
            sed -i "/GEEX_NIX_GROUP_OPTIONAL/{
                   r /tmp/geex.group.nix.block.dd
                   d
                   }" /tmp/geex.config.${stager}.dd
            export installedServiceNix=1
        else
            sed -i 's/GEEX_NIX_SERVICE_OPTIONAL//g' /tmp/geex.config.${stager}.dd
            sed -i 's/GEEX_NIX_GROUP_OPTIONAL//g' /tmp/geex.config.${stager}.dd
            export installedServiceNix=0
        fi
        if [[ "$serviceSelection" == *hurd* ]]; then
            sed -i "/GEEX_HURD_SERVICE_OPTIONAL/{
                   r /tmp/geex.service.hurd.block.dd
                   d
                   }" /tmp/geex.config.${stager}.dd
            export installedServiceHurd=1
        else
            sed -i 's/GEEX_HURD_SERVICE_OPTIONAL//g' /tmp/geex.config.${stager}.dd
            export installedServiceHurd=0
        fi
        export finishedServiceSetup=1
    else
        export finishedServiceSetup=0
    fi
}
systemsSelection() {
    systemchoice=$(dialog --backtitle "Geex Installer" --title "Systemchoice" --menu "Please choose one of the following available pre-made Systems Configurations, or select 'Custom' to create your own Configuration.\n\nOptions:\n  - desktop -> Nvidia-Enabled Desktop Configuration\n  - laptop -> Portable (No Nvidia) Configuration\n  - libre -> Fully Libre (Linux-Libre Kernel) Configuration\n  - minimal -> Minimalistic Server Configuration" 32 50 10 \
                          desktop "Desktop" \
                          laptop "Laptop" \
                          libre "Libre" \
                          minimal "Minimal" \
                          custom "Custom" \
                          3>&1 1>&2 2>&3) || exit
    export systemchoice=$systemchoice
}
biosHook() {
    if [[ -d /sys/firmware/efi ]]; then
        export detectedBios="(U)EFI"
    else
        export detectedBios="Legacy"
    fi
    detectBiosNotice=$(dialog --backtitle "Geex Installer" --title "BIOS Auto-Detection" --menu "The Installer has detected that you are using '$detectedBios' as your BIOS type. You may want to select this option/BIOS type at the next questionnaire/menu selection." 32 50 10 \
                              okay "Okay" \
                    3>&1 1>&2 2>&3) || exit 1
    if [ -f "/tmp/geex.detectedbios.dd" ]; then
        rm /tmp/geex.detectedbios.dd
    fi
    #detectedBiosNotice=$(dialog --backtitle "Geex Installer" --title "BIOS Auto-Detection" --textbox "/tmp/geex.detectedbios.dd" 22 75 3>&1 1>&2 2>&3) || exit 1
    if [ "$detectedBios" == "Legacy" ]; then
        bios=$(dialog --backtitle "Geex Installer" --title "BIOS" --menu "Select BIOS Type" 32 50 10 \
                  legacy "Legacy" \
                  uefi "(U)EFI" \
                  3>&1 1>&2 2>&3) || exit 1
        export bios=$bios
    else
        bios=$(dialog --backtitle "Geex Installer" --title "BIOS" --menu "Select BIOS Type" 32 50 10 \
                  uefi "(U)EFI" \
                  legacy "Legacy" \
                  3>&1 1>&2 2>&3) || exit 1
        export bios=$bios
    fi
}
disksHook() {
    if [ "$OLD_DISK_HOOK" == 1 ]; then
        detectedDisksNoticeText="The Installer has detected the following Disks available to your Device:"
        detectedDisks="$(lsblk -o NAME,LABEL,UUID,FSTYPE)"
        echo -e "$detectedDisksNoticeText\n\n$detectedDisks" >> /tmp/geex.detecteddisks.dd
        detectedDisksNotice=$(dialog --backtitle "Geex Installer" --title "Disk Auto-Detection" --textbox "/tmp/geex.detecteddisks.dd" 22 75 3>&1 1>&2 2>&3) || exit 1
        disk=$(dialog --backtitle "Geex Installer" --title "Disk" --inputbox "Enter your Disk Name (e.g. '/dev/sda', '/dev/sdb', '/dev/nvme0n1'):" 8 40 \
                      3>&1 1>&2 2>&3) || exit 1
        if [ "$disk" == "" ]; then
            echo "[ Error ]: No Disk provided, aborting..."
            exit 1
        fi
        if [[ "$disk" == /dev/nvme* ]]; then
            export diskPrefixed="${disk}p"
        else
            export diskPrefixed="$disk"
        fi
        export disk=$disk
    else
        PARTS_WITH_LABELS=$(ls -l /dev/disk/by-label/ | awk '{print $11 " " $9"\\n"}' | sed "s|../../|\n/dev/|g")
        if [[ "$PARTS_WITH_LABELS" == "" ]] || [[ -z "$PARTS_WITH_LABELS" ]]; then
            echo "[ Status ]: No partitions with labels found, skipping notice message..."
        else
            partitionsNotice=$(dialog --backtitle "Geex Installer" --title "Partitions Notice" --msgbox "The Installer has detected the following Partitions with a Label assigned to them, you may want to watch out and make sure you do not overwrite the Disk they are a Part of, if these Partitions are important to you.\n\n$PARTS_WITH_LABELS" 15 50 3>&1 1>&2 2>&3) || exit 1
        fi
        DISK_LIST=$(lsblk -dno NAME,SIZE | awk '{print "/dev/"$1, "("$2")"}')
        SELECTED_DISK=$(dialog --menu "Select Disk" 15 50 10 $DISK_LIST 3>&1 1>&2 2>&3) || exit 1
        if [[ -z "$SELECTED_DISK" ]]; then
            errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "You have not selected a valid (or any) disk, the installer cannot continue and will now abort the installation process." 32 50 10 \
                                  okay "Okay" \
                                  3>&1 1>&2 2>&3) || exit 1
            if [ "$errorMessage" == "okay" ]; then
                echo "[ Status ]: Aborting..."
                exit 1
            else
                echo "[ Status ]: You have somehow selected a non-existent option in the error message, this is not intended - please verify that the Geex installer's code has not been tampered with.\n[ Status ]: Aborting..."
                exit 1
            fi
        fi
        export disk=$SELECTED_DISK
        if [[ "$disk" == /dev/nvme* ]]; then
            export diskPrefixed="${disk}p"
        else
            export diskPrefixed="$disk"
        fi
    fi
}
disksSetup() {
    echo "Formatting disks ($disk)..."
    if [ -n "$GEEX_DEBUG" ] || [ -n "$GEEX_DEBUG_MODE" ]; then
        echo "[ Status ]: Debug Mode Detected, pretending to format and mount disks..."
        export formattedDisksStatus=2
    else
        if [ "$bios" == "legacy" ]; then
            sudo parted $disk --script \
              mklabel msdos \
              mkpart primary ext4 1MiB 100% \
              set 1 boot on
            sudo mkfs.ext4 -L guix-root ${diskPrefixed}1
            sudo mount ${diskPrefixed}1 ${geexMount}
            echo -e "\nFinished Legacy Formatting and Mounting\n"
            export formattedDisksStatus=1
        else
            sudo parted $disk --script \
              mklabel gpt \
              mkpart ESP fat32 1MiB 2048MiB \
              name 1 guix-efi \
              set 1 esp on \
              mkpart primary ext4 2048MiB 100% \
              name 2 guix-root
            sudo mkfs.fat -F32 -n guix-efi ${diskPrefixed}1
            sudo mkfs.ext4 -L guix-root ${diskPrefixed}2
            sudo mount ${diskPrefixed}2 ${geexMount}
            sudo mkdir -p ${geexMount}/boot
            sudo mount ${diskPrefixed}1 ${geexMount}/boot
            echo -e "\nFinished (U)EFI Formatting and Mounting\n"
            export formattedDisksStatus=1
        fi
    fi
}
customStage2() {
    echo "[ Status ]: Entered Custom System Setup Stage 2"
    echo "[ Info ]: The complete customization stage is not yet finished, please use one of the existing configuration templates."
    exit 1
}
filesystemHook() {
    export rootPartName=$(ls /dev/disk/by-label/ | grep -x -e 'guix-root' -e 'GUIX-ROOT')
    if [[ "$rootPartName" == "" ]]; then
        export rootPartName="guix-root"
    fi
    if [ "$bios" == "uefi" ]; then
        export efiPartName=$(ls /dev/disk/by-label/ | grep -x -e 'guix-efi' -e 'GUIX-EFI')
        if [[ "$efiPartName" == "" ]]; then
            export efiPartName="guix-efi"
        fi
        export filesystemBlock="$(echo -e "    (file-systems (cons* (file-system\n                           (mount-point \"/\")\n                           (device (file-system-label \"$rootPartName\"))\n                           (type \"ext4\"))\n                         (file-system\n                           (mount-point \"/boot/efi\")\n                           (device (file-system-label \"$efiPartName\"))\n                           (type \"vfat\")) %base-file-systems))\n")"
    else
        export filesystemBlock="$(echo -e "    (file-systems (cons* (file-system\n                           (mount-point \"/\")\n                           (device (file-system-label \"$rootPartName\"))\n                           (type \"ext4\")) %base-file-systems))\n")"
    fi
    if [ -f "/tmp/geex.filesystem.block.dd" ]; then
        rm /tmp/geex.filesystem.block.dd
    fi
    echo "$filesystemBlock" >> /tmp/geex.filesystem.block.dd
    if [ -f "/tmp/geex.config.${stager}.dd" ]; then
        sed -i "/GEEX_FILESYSTEM_OPTIONAL/{
        r /tmp/geex.filesystem.block.dd
        d
        }" /tmp/geex.config.${stager}.dd
        export wroteFilesystemBlock=1
        export verboseFilesystemBlockText=$filesystemBlock
    else
        errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "The Installer failed to write the File-System Block to '/tmp/geex.config.${stager}.dd'. Do you still want to continue?\n\n(!) Warning (!)\nThis may make your system unable to boot, unless you manually write a file-system block into the resulting, final config." 32 50 10 \
                              continue "Continue" \
                              abort "Abort" \
                              3>&1 1>&2 2>&3) || exit 1
        if [ "$errorMessage" == "abort" ]; then
            echo "[ Status ]: Aborting..."
            exit 1
        fi
        export wroteFilesystemBlock=0
    fi
    if [ -n "$GEEX_VERBOSE_MODE" ] || [ "$GEEX_VERBOSE_MODE" == 1 ]; then
        if [ "$wroteFilesystemBlock" == 1 ]; then
            verboseWasFilesystemBlockWritten="Yes"
        else
            verboseWasFilesystemBlockWritten="No"
        fi
        if [ "$verboseWasFilesystemBlockWritten" == "Yes" ]; then
            verboseNotice=$(dialog --backtitle "Geex Installer" --title "Verbose Notice" --msgbox "The Installer has successfully written your filesystems block into your '/tmp/geex.config.${stager}.dd' configuration file. Below is the full written block for verbosity:\n\nFilesystem Block:\n\`\`\`\n$verboseFilesystemBlockText\n\`\`\`" 34 68 3>&1 1>&2 2>&3)
        else
            verboseNotice=$(dialog --backtitle "Geex Installer" --title "Verbose Notice" --msgbox "The Installer failed to write your filesystems block into the appropriate '/tmp/geex.config.${stager}.dd' file for unknown reasons.\n\nPlease investigate this!" 34 68 3>&1 1>&2 2>&3)
        fi
    fi
}
biosLegacyEditHook() {
    export diskPrefixed=$diskPrefixed
    legacyBlock="$(echo -e "    (bootloader (bootloader-configuration\n              (keyboard-layout keyboard-layout)\n              (bootloader grub-bootloader)\n              (targets '(\"${diskPrefixed}1\"))))\n")"
    legacyBlockVerify=$(dialog --backtitle "Geex Installer" --title "Verify BIOS Block" --menu "Please verify that the BIOS Block below is correct and can be written:\n\n\`\`\`\n$legacyBlock\n\`\`\`\n\n\n  " 28 50 10 \
                               continue "Continue" \
                               abort "Abort" \
                               3>&1 1>&2 2>&3) || exit 1
    if [ "$legacyBlockVerify" == "abort" ]; then
        echo "[ Status ]: Aborting..."
        exit 1
    fi
    if [ -f "/tmp/geex.bios.block.dd" ]; then
        rm /tmp/geex.bios.block.dd
    fi
    echo "$legacyBlock" >> /tmp/geex.bios.block.dd
    if [ -f "/tmp/geex.config.${stager}.dd" ]; then
        sed -i "/GEEX_BIOS_OPTIONAL/{
        r /tmp/geex.bios.block.dd
        d
        }" /tmp/geex.config.${stager}.dd
        if [ "$GEEX_VERBOSE_MODE" == 1 ]; then
            successMessage=$(dialog --backtitle "Geex Installer" --title "Success" --menu "Successfully wrote BIOS hook into '/tmp/geex.config.${stager}.dd'." 32 50 10 \
                                    continue "Continue" \
                                    abort "Abort" \
                                    3>&1 1>&2 2>&3) || exit 1
            if [ "$successMessage" == "abort" ]; then
                echo "[ Status ] Aborting..."
                exit 1
            fi
        fi
        export wroteBiosBlock=1
    else
        errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "The Installer encountered an error: '/tmp/geex.config.${stager}.dd' was not found, thus the BIOS hook did not finish writing.\n\nContinue anyways?" 32 50 10 \
                              continue "Continue" \
                              abort "Abort" \
                              3>&1 1>&2 2>&3) || exit 1
        if [ "$errorMessage" == "abort" ]; then
            echo "[ Status ]: Aborting..."
            exit 1
        fi
        export wroteBiosBlock=0
    fi
}
biosUefiEditHook() {
    export diskPrefixed=$diskPrefixed
    uefiBlock="$(echo -e "    (bootloader (bootloader-configuration\n              (keyboard-layout keyboard-layout)\n              (bootloader grub-efi-bootloader)\n              (targets '(\"/boot/efi\"))))\n")"
    uefiBlockVerify=$(dialog --backtitle "Geex Installer" --title "Verify BIOS Block" --menu "Please verify that the BIOS Block below is correct and can be written:\n\n\`\`\`\n$uefiBlock\n\`\`\`\n\n\n  " 28 50 10 \
                             continue "Continue" \
                             abort "Abort" \
                             3>&1 1>&2 2>&3) || exit 1
    if [ "$uefiBlockVerify" == "abort" ]; then
        echo "[ Status ]: Aborting..."
        exit 1
    fi
    if [ -f "/tmp/geex.bios.block.dd" ]; then
        rm /tmp/geex.bios.block.dd
    fi
    echo "$uefiBlock" >> /tmp/geex.bios.block.dd
    if [ -f "/tmp/geex.config.${stager}.dd" ]; then
        sed -i "/GEEX_BIOS_OPTIONAL/{
        r /tmp/geex.bios.block.dd
        d
        }" /tmp/geex.config.${stager}.dd
        if [ "$GEEX_VERBOSE_MODE" == 1 ]; then
            successMessage=$(dialog --backtitle "Geex Installer" --title "Success" --menu "Successfully wrote BIOS hook into '/tmp/geex.config.${stager}.dd'." 32 50 10 \
                                    continue "Continue" \
                                    abort "Abort" \
                                    3>&1 1>&2 2>&3) || exit 1
            if [ "$successMessage" == "abort" ]; then
                echo "[ Status ] Aborting..."
                exit 1
            fi
        fi
        export wroteBiosBlock=1
    else
        errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "The Installer encountered an error: '/tmp/geex.config.${stager}.dd' was not found, thus the BIOS hook did not finish writing.\n\nContinue anyways?" 32 50 10 \
                              continue "Continue" \
                              abort "Abort" \
                              3>&1 1>&2 2>&3) || exit 1
        if [ "$errorMessage" == "abort" ]; then
            echo "[ Status ]: Aborting..."
            exit 1
        fi
        export wroteBiosBlock=0
    fi
}
systemInstallHook() {
    echo "[ Status ]: Beginning formal GNU Guix installation..."
    if [ -n "$GEEX_DEBUG" ] || [ -n "$GEEX_DEBUG_MODE" ]; then
        echo "[ Status ]: Debug Mode Detected, pretending to install system..."
    else
        if ! command -v herd >/dev/null; then
            echo "[ Error ]: Herd Missing, asking how to continue..."
            errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "The Installer encountered an error: the 'herd' binary is missing. Do you still want to continue?\n\n(!) Warning (!)\nThe system may not install correctly if the cow-store is not initialized correctly, continue at your own risk!" 32 50 10 \
                                  continue "Continue" \
                                  abort "Abort" \
                                  3>&1 1>&2 2>&3) || exit 1
            if [[ "$errorMessage" != "continue" ]]; then
                echo "[ Status ]: Aborting..."
                exit 1
            fi
        else
            herd start cow-store ${geexMount}
            cp /tmp/geex.config.${stager}.dd /tmp/geex.config.${stager}.scm
            mkdir -p ${geexMount}/etc/guix
            cp /tmp/geex.config.${stager}.scm ${geexMount}/etc/guix/config.scm
            if [ -f "${geexMount}/etc/guix/config.scm" ]; then
                export GEEX_GUIX_SYSTEM_INIT_CHECKFILE=/tmp/geex.guix.system.init.check.file.dd
                export GEEX_GUIX_STYLE_CHECKFILE=/tmp/geex.guix.style.check.file.dd
                if [ -f "$GEEX_GUIX_STYLE_CHECKFILE" ]; then
                    rm $GEEX_GUIX_STYLE_CHECKFILE
                fi
                if [ -f "$GEEX_GUIX_SYSTEM_INIT_CHECKFILE" ]; then
                    rm $GEEX_GUIX_SYSTEM_INIT_CHECKFILE
                fi
                guix style -f ${geexMount}/etc/guix/config.scm && touch $GEEX_GUIX_STYLE_CHECKFILE
                guix system init ${geexMount}/etc/guix/config.scm ${geexMount} && touch $GEEX_GUIX_SYSTEM_INIT_CHECKFILE
                if [[ ! -f "$GEEX_GUIX_STYLE_CHECKFILE" ]]; then
                    errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --msgbox "The Installer failed to style the '/tmp/geex.config.${stager}.scm' file. This is either caused by the fact this file does not exist, or a problem with Guix itself (likely to happen if you do not have the 'guix' command available on your system).\n\nThis is not a fatal error, but it could pre-destine the installer to also fail at later stages that invole the 'guix' command, or other file operations.\n\nPlease investigate this error!" 34 75 3>&1 1>&2 2>&3) || exit 1
                fi
                if [ -f "$GEEX_GUIX_SYSTEM_INIT_CHECKFILE" ]; then
                    export installationStatus=1
                else
                    fatalSystemErrorMessage="$(echo -e "The Installer has encountered a Fatal Error, it was not able to initialize the Guix System on your '${geexMount}' via the selected configuration file ('${geexMount}/etc/guix/config.scm').\n\nThis error is un-recoverable, and the installer will now quit, unless you force it to continue running.\n\nSelect 'Okay' to abort the installation process, and 'No, Ignore and Keep Going' to continue anyways (not recommended).")"
                    errorMessage=$(dialog --backtitle "Geex Installer" --title "Fatal Error" --menu "$fatalSystemErrorMessage" 40 124 10 \
                                          okay "Okay" \
                                          ignore "No, Ignore and Keep Going" \
                                          3>&1 1>&2 2>&3) || exit 1
                    if [ "$errorMessage" == "okay" ]; then
                        echo "[ Status ]: Aborting..."
                        exit 1
                    fi
                    export installationStatus=0
                fi
            elif [ -f "/tmp/geex.config.${stager}.scm" ]; then
                export GEEX_GUIX_SYSTEM_INIT_CHECKFILE=/tmp/geex.guix.system.init.check.file.dd
                export GEEX_GUIX_STYLE_CHECKFILE=/tmp/geex.guix.style.check.file.dd
                if [ -f "$GEEX_GUIX_STYLE_CHECKFILE" ]; then
                    rm $GEEX_GUIX_STYLE_CHECKFILE
                fi
                if [ -f "$GEEX_GUIX_SYSTEM_INIT_CHECKFILE" ]; then
                    rm $GEEX_GUIX_SYSTEM_INIT_CHECKFILE
                fi
                guix style -f /tmp/geex.config.${stager}.scm && touch $GEEX_GUIX_STYLE_CHECKFILE
                guix system init /tmp/geex.config.${stager}.scm ${geexMount} && touch $GEEX_GUIX_SYSTEM_INIT_CHECKFILE
                if [[ ! -f "$GEEX_GUIX_STYLE_CHECKFILE" ]]; then
                    errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --msgbox "The Installer failed to style the '/tmp/geex.config.${stager}.scm' file. This is either caused by the fact this file does not exist, or a problem with Guix itself (likely to happen if you do not have the 'guix' command available on your system).\n\nThis is not a fatal error, but it could pre-destine the installer to also fail at later stages that invole the 'guix' command, or other file operations.\n\nPlease investigate this error!" 34 75 3>&1 1>&2 2>&3) || exit 1
                fi
                if [ -f "$GEEX_GUIX_SYSTEM_INIT_CHECKFILE" ]; then
                    export installationStatus=1
                else
                    fatalSystemErrorMessage="$(echo -e "The Installer has encountered a Fatal Error, it was not able to initialize the Guix System on your '${geexMount}' via the selected configuration file ('/tmp/geex.config.${stager}.scm').\n\nThis error is un-recoverable, and the installer will now quit, unless you force it to continue running.\n\nSelect 'Okay' to abort the installation process, and 'No, Ignore and Keep Going' to continue anyways (not recommended).")"
                    errorMessage=$(dialog --backtitle "Geex Installer" --title "Fatal Error" --menu "$fatalSystemErrorMessage" 40 124 10 \
                                          okay "Okay" \
                                          ignore "No, Ignore and Keep Going" \
                                          3>&1 1>&2 2>&3) || exit 1
                    if [ "$errorMessage" == "okay" ]; then
                        echo "[ Status ]: Aborting..."
                        exit 1
                    fi
                    export installationStatus=0
                fi
            elif [ -n "$GEEX_DEBUG" ] || [ -n "$GEEX_DEBUG_MODE" ]; then
                export installationStatus=2
            else
                errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "The Installer encountered an error: neither the '${geexMount}/etc/guix/config.scm', nor the '/tmp/geex.config.${stager}.scm' files are present. Or, the 'guix' command is not available to your system and thus not available to the installer.\n\nThe Installer must have failed the copying process, or errorer at a different stage. Please investigate.\n\nThe Installer cannot continue meaningfully, still proceed with the broken installation process?" 32 50 10 \
                                      abort "Abort" \
                                      continue "Yes, still Continue" \
                                      3>&1 1>&2 2>&3) || exit 1
                if [ "$errorMessage" == "abort" ]; then
                    echo "[ Status ]: Aborting..."
                    exit 1
                fi
                export installationStatus=0
            fi
        fi
    fi
}
passwordFunction() {
    while true; do
        password=$(dialog --backtitle "Geex Installer" --title "Password" --passwordbox "Enter 'root' Password" 10 50 \
                          3>&1 1>&2 2>&3) || exit 1
        if [[ -n "$password" ]]; then
            passwordConfirm=$(dialog --backtitle "Geex Installer" --title "Confirm Password" --passwordbox "Confirm 'root' Password" 10 50 \
                                     3>&1 1>&2 2>&3) || exit 1
            if [[ -n "$passwordConfirm" ]] && [ "$password" == "$passwordConfirm" ]; then
                export password=$password
                return 0
            fi
        fi
        dialog --backtitle "Geex Installer" --title "Error" --msgbox "You have either not specified a password, or your password confirmation mismatches the password you entered first.\n\nPlease try again.." 32 50
    done
}
userPasswordFunction() {
    while true; do
        userPassword=$(dialog --backtitle "Geex Installer" --title "User Password" --passwordbox "Enter '$username' Password" 10 50 \
                              3>&1 1>&2 2>&3) || exit 1
        if [[ -n "$userPassword" ]]; then
            userPasswordConfirm=$(dialog --backtitle "Geex Installer" --title "Confirm User Password" --passwordbox "Confirm '$username' Password" 10 50 \
                                     3>&1 1>&2 2>&3) || exit 1
            if [[ -n "$userPasswordConfirm" ]] && [ "$userPassword" == "$userPasswordConfirm" ]; then
                export userPassword=$userPassword
                return 0
            fi
        fi
        dialog --backtitle "Geex Installer" --title "Error" --msgbox "You have either not specified a password, or your password confirmation mismatches the password you entered first.\n\nPlease try again.." 32 50
    done
}
passwordHook() {
    passwordFunction
    uniqueUserPass=$(dialog --backtitle "Geex Installer" --title "User Password" --menu "Do you want to use the same password for the '$username' account?" 32 50 10 \
                            yes "Yes" \
                            no "No" \
                            3>&1 1>&2 2>&3) || exit 1
    if [ "$uniqueUserPass" == "yes" ]; then
        export userPassword=$password
        export reUsedRootPassword=1
    else
        userPasswordFunction
        export reUsedRootPassword=0
    fi
    if [[ -n "$password" ]] && [[ -n "$userPassword" ]]; then
        if [[ -n "$GEEX_DEBUG" ]] || [[ -n "$GEEX_DEBUG_MODE" ]]; then
            export configuredPasswords=2
            if [[ -n "$GEEX_VERBOSE_MODE" ]]; then
                verbosePopup=$(dialog --backtitle "Geex Installer" --title "Password Setup" --msgbox "Debug Mode Detected, pretending to have set passwords. You have entered the following passwords and options:\n\nRoot Password: $password\n$username Password: $userPassword\nRe-Use Root Password: $uniqueUserPass" 24 40 3>&1 1>&2 2>&3)
            fi
        else
            export configuredPasswords=1
            if [[ -n "$GEEX_VERBOSE_MODE" ]]; then
                verbosePopup=$(dialog --backtitle "Geex Installer" --title "Password Setup" --msgbox "Verbose Mode Detected, informing you on the state of the password configuration process. You have entered the following passwords and options:\n\nRoot Password: $password\n\n$username Password: $userPassword\n\nRe-Use Root Password: $uniqueUserPass" 24 40 3>&1 1>&2 2>&3) || exit 1
            fi
        fi
    else
        export configuredPasswords=0
    fi
}
passwordApplyHook() {
    if [[ -n "$GEEX_DEBUG" ]] || [[ -n "$GEEX_DEBUG_MODE" ]]; then
        echo "[ Status ]: Debug Mode Detected, pretending to set passwords..."
    else
        printf "%s\n%s\n" "$password" "$password" | passwd -R ${geexMount} root
        printf "%s\n%s\n" "$userPassword" "$userPassword" | passwd -R ${geexMount} $username
    fi
    if [[ -n "$GEEX_VERBOSE_MODE" ]]; then
        verbosePopup=$(dialog --backtitle "Geex Installer" --title "Password Setup" --msgbox "Verbose Mode Detected, informing you that the installer has successfully applied your password settings and configuration to your GNU Guix System installation." 24 40 3>&1 1>&2 2>&3) || exit 1
    fi
}
# Old Password Hook
passwordHookOld() {
    export passwordTryAgain=0
    if [ -n "$GEEX_DEBUG" ] || [ -n "$GEEX_DEBUG_MODE" ]; then
        echo "[ Debug ]: Pretending to set passwords..."
        export CONFIGURED_PASSWORDS=2
    else
        export passwordTryAgain=0
        passwordInputBoxHook
        if [[ -z "$password" ]]; then
            errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "You either did not provide a password, or the password you provided was un-parseable. Do you want to skip the password setup section, or do you want to try again?\n\nWarning: If you skip the password setup stage, you have to either manually set the password yourself, or risk booting into a system that has no users that you can actually log in to.)" 32 50 10 \
                                  again "Try Again" \
                                  skip "Skip Password Setup" \
                                  3>&1 1>&2 2>&3) || exit 1
            if [ "$errorMessage" == "again" ]; then
                export passwordTryAgain=1
            else
                export passwordTryAgain=0
            fi
        fi
        if [[ -z "$password" ]]; then
            export passwordTryAgain=1
        else
            export passwordTryAgain=0
        fi
        while [[ -z "$password" ]] || [ "$password" == "" ] || [ "$passwordTryAgain" == 1 ]; do
            passwordInputBoxHook
        done
        export password=$password
        export userPasswordTryAgain=0
        userPassQuestion=$(dialog --backtitle "Geex Installer" --title "User Password" --menu "Do you want to use the same password for the '$username' account?" 32 50 10 \
                                  yes "Yes" \
                                  no "No" \
                                  3>&1 1>&2 2>&3) || exit 1
        if [ "$userPassQuestion" == "no" ]; then
            userPasswordInputBoxHook
            if [[ -z "$userPassword" ]]; then
                export userPasswordTryAgain=1
            else
                export userPasswordTryAgain=0
            fi
            while [[ -z "$userPassword" ]] || [ "$userPassword" == "" ] || [ "$userPasswordTryAgain" == 1 ]; do
                export userPasswordTryAgain=1
                userPasswordInputBoxHook
            done
            export userPassword=$userPassword
        else
            export userPassword=$password
        fi
        #echo "[ Status ]: Please enter 'root' password:"
        #passwd -R /mnt root
        #echo "[ Status ]: Please enter '$username' password:"
        #passwd -R /mnt $username
        #export CONFIGURED_PASSWORDS=1
    fi
}
homeHook() {
    homeQuestion=$(dialog --backtitle "Geex Installer" --title "Home Setup" --menu "The Geex Installer offers the option to copy the generic Geex GNU Guix Home Configuration (home.scm) to your newly installed System.\n\nDo you want to copy the Geex GNU Guix Home Configuration to your system?\n\n(You can edit the '${geexMount}/etc/guix/home.scm' before or after rebooting to make changes.)" 32 50 10 \
                          yes "Yes, Copy the Files" \
                          no "No, don't Copy the Files" \
                          3>&1 1>&2 2>&3) || exit 1
    if [ -n "$GEEX_DEBUG" ] || [ -n "$GEEX_DEBUG_MODE" ]; then
        echo "[ Status ]: Debug Mode Detected, continuing with mock installation..."
        if [ "$homeQuestion" == "yes" ]; then
            export copiedHome=2
            echo "[ Status ]: Mock-copied Guix Home files..."
        else
            export copiedHome=0
            echo "[ Status ]: Mock-denied the Guix Home File copying process..."
        fi
        export systemFinished=1
        export homeGetMethod="Mock"
    else
        if [ "$homeQuestion" == "yes" ]; then
            if [ -f "/tmp/geex.home.scm" ]; then
                cp /tmp/geex.home.scm ${geexMount}/etc/guix/home.scm
                if [ -d "/tmp/geex.files" ] && [ -d "/tmp/geex.container" ]; then
                    cp -r /tmp/geex.files ${geexMount}/etc/guix/files
                    cp -r /tmp/geex.containers ${geexMount}/etc/guix/containers
                    export copiedHome=1
                    export homeGetMethod="local"
                else
                    mkdir -p /tmp/geex.git.storage
                    git clone https://github.com/librepup/geex.git /tmp/geex.git.storage/geex
                    cp -r /tmp/geex.git.storage/geex/files ${geexMount}/etc/guix/files
                    cp -r /tmp/geex.git.storage/geex/containers ${geexMount}/etc/guix/containers
                    export copiedHome=1
                    export homeGetMethod="local+git"
                fi
                if [ "$copiedHome" == 0 ] || [ -z "$copiedHome" ]; then
                    errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "The Installer has encountered an error trying to copy the necessary directories needed for the Guix Home Configuration Setup. This is unexpected, as the installer did not expect it to be possible to encounter an error at this specific stage, as every possibility has been accounted for, so this error is either due to someone having tampered with the Geex Installers Code (do NOT do this), or another un-recoverable error.\n\nThe Installer will now pretend as if you have not selected the option to copy Guix Home Configuration Files at all." 32 50 10 \
                                          okay "Okay" \
                                          abort "Abort" \
                                          3>&1 1>&2 2>&3) || exit 1
                    if [ "$errorMessage" == "abort" ]; then
                        echo "[ Status ]: Aborting..."
                        exit 1
                    fi
                    export homeGetMethod="broken"
                    export copiedHome=0
                    export systemFinished=1
                fi
            elif command -v git >/dev/null; then
                mkdir -p /tmp/geex.git.storage
                git clone https://github.com/librepup/geex.git /tmp/geex.git.storage/geex
                cp /tmp/geex.git.storage/geex/home.scm ${geexMount}/etc/guix/home.scm
                cp -r /tmp/geex.git.storage/geex/files ${geexMount}/etc/guix/files
                cp -r /tmp/geex.git.storage/geex/containers ${geexMount}/etc/guix/containers
                export copiedHome=1
                export homeGetMethod="git"
            else
                export copiedHome=0
                errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "The Installer encountered an error while trying to copy the Geex GNU Guix Home Configuration File(s):\n  Neither '/tmp/geex.home.scm', nor the 'git' command were present.\n\nSkipping Guix Home configuration hook." 32 50 10 \
                                      okay "Okay" \
                                      3>&1 1>&2 2>&3) || exit 1
                export homeGetMethod="none"
            fi
            export systemFinished=1
        elif [ "$homeQuestion" == "no" ]; then
            export homeGetMethod="none"
            export copiedHome=0
            export systemFinished=1
            notice=$(dialog --backtitle "Geex Installer" --title "Notice" --menu "You have aborted the copying of Geex GNU Guix Home Configuration Files, the Installer will continue on as if the home configuration hook were never called." 32 50 10 \
                            okay "Okay" \
                            3>&1 1>&2 2>&3) || exit 1
        else
            errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --msgbox "The Installer has encountered an unrecoverable error trying to set up (or decide whether to set up or not) your Guix Home Configuration Files. The installer will now exit, please verify that you have not made any changes to the installer's code, or changed the content of files midway through the installation process yourself (unless you are asked/prompted to)." 34 75 3>&1 1>&2 2>&3) || exit 1
            if [[ -n "$GEEX_DEBUG" ]] || [[ -n "$GEEX_DEBUG_MODE" ]]; then
                debugNotice=$(dialog --backtitle "Geex Installer" --title "Debug Notice" --msgbox "The Installer has detected that you are running inside Debug Mode, thus it will pretend to continue with a Mock Installation Process, and ignore the present Error.\n\nHowever, the occurrence of this Error is not intended, and this is not supposed to happen at all.\n\n(!) Important (!)\nPLEASE verify the integrity of the Geex Installer's Code, as well as your System, your Internet Connection, and other possible factors of failure." 34 75 3>&1 1>&2 2>&3) || exit 1
                export ignoredHomeErrorDueToDebug=1
                export systemFinished=2
            else
                echo "[ Status ]: Aborting..."
                exit 1
            fi
        fi
    fi
}
timezoneHook() {
    if [ "$GEEX_RUNNING_IN" == "guix" ]; then
        export ZONEINFO_DIR=$(guix build tzdata)/share/zoneinfo
    elif [ "$GEEX_RUNNING_IN" == "nix" ]; then
        export ZONEINFO_DIR=$(nix-build --no-out-link '<nixpkgs>' -A tzdata)/share/zoneinfo
    elif [ -d "/usr/share/zoneinfo" ]; then
        export ZONEINFO_DIR="/usr/share/zoneinfo"
    elif [ -d "/etc/zoneinfo" ]; then
        export ZONEINFO_DIR="/etc/zoneinfo"
    else
        errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "Unable to find any way to fetch timezones/zoneinfo. The installer will use a fallback timezone that it hopes will be available at install time, or quit if you select 'Abort' in this menu." 32 50 10 \
                              continue "Continue" \
                              abort "Abort" \
                              3>&1 1>&2 2>&3) || exit 1
        if [ "$errorMessage" == "abort" ]; then
            echo "[ Status ]: Aborting..."
            exit 1
        fi
        export zoneinfoError=1
    fi
    if [ "$zoneinfoError" == 1 ]; then
        if [ -f "/tmp/geex.timezone.notice.dd" ]; then
            rm /tmp/geex.timezone.notice.dd
        fi
        echo -e "Since the installer has encountered a timezone/zoneinfo error:\n\nGuix is not present, Nix is not present, and the directories '/usr/share/zoneinfo' as well as '/etc/zoneinfo' do not exist.\n\nThe installer will now set your timezone to a fallback timezone automatically set up in case of zoneinfo errors.\nThe default fallback timezone is:\n\nEurope/Berlin\n\nThe installer will now continue with the setup, configuraiton, and installation process as if it had not encountered an error." >> /tmp/geex.timezone.notice.dd
        noticePopup=$(dialog --backtitle "Geex Installer" --title "Notice" --textbox "/tmp/geex.timezone.notice.dd" 22 75 3>&1 1>&2 2>&3)
        export TIMEZONE="Europe/Berlin"
    else
        REGION=$(find "$ZONEINFO_DIR" -maxdepth 1 -type d -printf "%f\n" | \
                     grep -E 'Africa|America|Antarctica|Arctic|Asia|Atlantic|Australia|Europe|Indian|Pacific' | \
                     sort | xargs -I {} echo {} {} | \
                     xargs dialog --menu "Select Region" 15 50 10 3>&1 1>&2 2>&3 >/dev/tty)
        export REGION=$REGION
        if [[ -z "$REGION" ]]; then
            export REGION="Europe"
            export fallbackRegion=1
        else
            export fallbackRegion=0
        fi
        ZONE=$(find "$ZONEINFO_DIR/$REGION" -type f -printf "%P\n" | \
                   sort | xargs -I {} echo {} {} | \
                   xargs dialog --menu "Select Timezone in $REGION" 15 50 10 3>&1 1>&2 2>&3 >/dev/tty)
        export ZONE=$ZONE
        if [[ -z "$ZONE" ]]; then
            export ZONE="Berlin"
            export fallbackZone=1
        else
            export fallbackZone=0
        fi
        export TIMEZONE="$REGION/$ZONE"
        if [ "$fallbackRegion" == 1 ]; then
            if [ "$fallbackZone" == 1 ]; then
                export fellBackOnTimezone="Region and Zone"
                export fellBackNum=1
            else
                export fellBackOnTimezone="Region"
                export fellbackNum=1
            fi
        else
            export fellBackNum=0
        fi
        if [[ -z "$REGION" ]] || [[ -z "$ZONE" ]] || [[ -z "$TIMEZONE" ]] || [[ "$TIMEZONE" == "" ]] || [[ "$fellBackNum" == 1 ]]; then
            errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "You have not selected a valid Timezone, the installer will use the default fallback $fellBackOnTimezone, and export this as your chosen timezone.\n\nContinue?" 32 50 10 \
                                  continue "Continue" \
                                  abort "Abort" \
                                  3>&1 1>&2 2>&3) || exit 1
            if [ "$errorMessage" == "abort" ]; then
                echo "[ Status ]: Aborting..."
                exit 1
            fi
            if [[ -z "$REGION" ]]; then
                export REGION="Europe"
            fi
            if [[ -z "$ZONE" ]]; then
                export ZONE="Berlin"
            fi
            export TIMEZONE="$REGION/$ZONE"
        fi
    fi
    export TIMEZONE=$TIMEZONE
    sed -i "s|GEEX_TIMEZONE|$TIMEZONE|g" /tmp/geex.config.${stager}.dd
    if [ -n "$TIMEZONE" ]; then
        if [ "$fellBackNum" == 0 ]; then
            export wroteTimezoneBlock="Yes"
        else
            export wroteTimezoneBlock="Yes (Fallback)"
        fi
    else
        export wroteTimezoneBlock="No"
    fi
    if [ -n "$GEEX_VERBOSE_MODE" ] || [ "$GEEX_VERBOSE_MODE" == 1 ]; then
        export verboseTimezoneBlockText=$(cat /tmp/geex.config.${stager}.dd | grep "$TIMEZONE" | sed "s/^[ \t]*//g")
    fi
}
keyboardSelectVariantHook() {
    while true; do
        SELECTED_KEYBOARD_VARIANT=$(xargs -a "$TMP_VARIANTS" dialog --menu "Select Variant for $selectedLayout" 20 70 12 \
                                          3>&1 1>&2 2>&3) || exit 1

        if [ "$SELECTED_KEYBOARD_VARIANT" == "default" ]; then
            export keyboard="\"$selectedLayout\""
            export keyboardInfo="$selectedLayout"
            return 1
        else
            export selectedVariant=$SELECTED_KEYBOARD_VARIANT
            export keyboard="\"$selectedLayout\" \"$selectedVariant\""
            export keyboardInfo="$selectedLayout ($selectedVariant)"
            return 1
        fi
        dialog --backtitle "Geex Installer" --title "Error" --msgbox "Please select a valid (or any) keyboard layout variant for your selected layout '$SELECTED_KEYBOARD_LAYOUT', or choose the default variant option (first option in the list) to not choose any special/specific layout." 32 50
    done
}
keyboardSelectLayoutHook() {
    while true; do
        SELECTED_KEYBOARD_LAYOUT=$(dialog --menu "Select Layout" 20 60 12 \
                     $LAYOUT_LIST \
                     3>&1 1>&2 2>&3) || exit 1
        if [[ -n "$SELECTED_KEYBOARD_LAYOUT" ]]; then
            export selectedLayout=$SELECTED_KEYBOARD_LAYOUT
            export TMP_VARIANTS="/tmp/geex.keyboard.variants.dd"
            if [ -f "/tmp/geex.keyboard.variants.dd" ]; then
                rm /tmp/geex.keyboard.variants.dd
            fi
            echo "default \"Standard layout ($SELECTED_KEYBOARD_LAYOUT)\"" > "$TMP_VARIANTS"
            awk -v lay="$SELECTED_KEYBOARD_LAYOUT" '
                /! variant/ {flag=1; next}
                /^!/ {flag=0}
                flag && $2 ~ lay":" {
                    tag = $1;
                    # Find the first colon and take everything after it as description
                    desc = substr($0, index($0, ":") + 1);
                    # Remove leading spaces
                    gsub(/^[ \t]+/, "", desc);
                    # Print tag then description in quotes
                    printf "%s \"%s\"\n", tag, desc;
                }' "$LST_FILE" >> "$TMP_VARIANTS"
            return 0
        fi
        dialog --backtitle "Geex Installer" --title "Error" --msgbox "Please select a valid (or any) keyboard layout from the provided list/installer selection window." 32 50
    done
}
keyboardHook() {
    if [ "$GEEX_RUNNING_IN" == "guix" ]; then
        export XKB_BASE=$(guix build xkeyboard-config)/share/X11/xkb
    elif [ "$GEEX_RUNNING_IN" == "nix" ]; then
        export XKB_BASE=$(nix-build --no-out-link '<nixpkgs>' -A xkeyboard-config)/share/X11/xkb
    elif [ -d "/usr/share/X11/xkb" ]; then
        export XKB_BASE="/usr/share/X11/xkb"
    elif [ -d "/etc/X11/xkb" ]; then
        export XKB_BASE="/etc/X11/xkb"
    else
        errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "Unable to find any way to fetch keyboard layouts. The installer will use a fallback layout that it hopes will be available at install time, or quit if you select 'Abort' in this menu." 32 50 10 \
                              continue "Continue" \
                              abort "Abort" \
                              3>&1 1>&2 2>&3) || exit 1
        if [ "$errorMessage" == "abort" ]; then
            echo "[ Status ]: Aborting..."
            exit 1
        fi
        export keyboardLayoutError=1
    fi

    export LST_FILE="$XKB_BASE/rules/base.lst"
    export LAYOUT_LIST=$(awk '/! layout/ {flag=1; next} /^!/ {flag=0} flag {print $1, $2}' "$LST_FILE")
    export TMP_VARIANTS="/tmp/geex.keyboard.variants.dd"

    if [ "$keyboardLayoutError" == 1 ]; then
        export keyboard="$(echo -e "\"us\"")"
    else
        keyboardSelectLayoutHook
        keyboardSelectVariantHook
    fi

    if [ -f "/tmp/geex.config.${stager}.dd" ]; then
        sed -i "s|GEEX_KEYBOARD_LAYOUT|$keyboard|g" /tmp/geex.config.${stager}.dd
        export wroteKeyboardBlock="Yes"
        if grep "(keyboard-layout $keyboard)" /tmp/geex.config.${stager}.dd &>/dev/null; then
            export foundKeyboardBlock="Yes"
        else
            export foundKeyboardBlock="No"
        fi
    else
        echo "No '/tmp/geex.config.${stager}.dd' found..."
        errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "The Installer encountered an error when trying to set your keyboard layout and variant. This may have occurred because the '/tmp/geex.config.${stager}.dd' is absent, unwriteable, or someone has tinkered with the code of this installer.\n\nPlease verify the installers integrity. The Installer will now quit unless specifically instructed not to." 32 60 10 \
                              okay "Okay" \
                              continue "Continue despite Errors" \
                              3>&1 1>&2 2>&3) || exit 1
        if [ "$errorMessage" == "okay" ]; then
            echo "[ Status ]: Aborting..."
            exit 1
        fi
    fi
}
livePreviewHook() {
    if command -v kitty >/dev/null; then
        kitty --title "geexLive" --app-id=geexLive --os-window-tag=geexLive watch -n 1 "cat /tmp/geex.config.${stager}.dd" &>/dev/null &
        kitty --title "geexLive" --app-id=geexLive --os-window-tag=geexLive watch -n 1 "cat /tmp/geex.config.${stager}.dd | tail -n 50" &>/dev/null &
    elif command -v alacritty >/dev/null; then
        alacritty --title geexLive --class geexLive -e watch -n 1 "cat /tmp/geex.config.${stager}.dd" &>/dev/null &
        alacritty --title geexLive --class geexLive -e watch -n 1 "cat /tmp/geex.config.${stager}.dd | tail -n 50" &>/dev/null &
    elif command -v xterm >/dev/null; then
        xterm -class geexLive -tn geexLive -name geexLive -e watch -n 1 "cat /tmp/geex.config.${stager}.dd" &>/dev/null &
        xterm -class geexLive -tn geexLive -name geexLive -e watch -n 1 "cat /tmp/geex.config.${stager}.dd | tail -n 50" &>/dev/null &
    elif command -v ghostty >/dev/null; then
        ghostty --class=geexLive --x11-instance-name=geexLive -e watch -n 1 "cat /tmp/geex.config.${stager}.dd" &>/dev/null &
        ghostty --class=geexLive --x11-instance-name=geexLive -e watch -n 1 "cat /tmp/geex.config.${stager}.dd | tail -n 50" &>/dev/null &
    elif command -v st >/dev/null; then
        st -c geexLive -T geexLive -t geexLive -e watch -n 1 "cat /tmp/geex.config.${stager}.dd" &>/dev/null &
        st -c geexLive -T geexLive -t geexLive -e watch -n 1 "cat /tmp/geex.config.${stager}.dd | tail -n 50" &>/dev/null &
    elif command -v xfce4-terminal >/dev/null; then
        xfce4-terminal --role=geexLive --class=geexLive --startup-id=geexLive --command='watch -n 1 "cat /tmp/geex.config.${stager}.dd"' &>/dev/null &
        xfce4-terminal --role=geexLive --class=geexLive --startup-id=geexLive --command='watch -n 1 "cat /tmp/geex.config.${stager}.dd | tail -n 50"' &>/dev/null &
    else
        errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --msgbox "The Installer has encountered an error. You have enabled the live preview mode, however the installer could not find a supported terminal emulator installed on your machine.\n\nSupported Terminals are:\n - kitty\n - alacritty\n - xterm\n - ghostty\n - st\n - xfce4-terminal\n\nThe Live Setting will be ignored for now." 34 75 3>&1 1>&2 2>&3) || exit 1
    fi
}
liveKillHook() {
    while findInstance=$(ps aux | grep "[g]eexLive" | awk '{print $2}' | head -n 1) && [ -n "$findInstance" ]; do
        kill "$findInstance"
    done
    if pgrep -f "geexLive" >/dev/null; then
        pkill -9 -f "geexLive"
    fi
}
searchForPackageFunction() {
    local pkgName=$(echo "$1" | tr -d '[:space:]')
    [[ -z "$pkgName" ]] && return 1
    if guix search "$pkgName" | grep -qx "name: $pkgName"; then
        echo "$pkgName"
        return 0
    else
        return 1
    fi
}
addCustomPackageHook() {
    userPkgList=$(dialog --backtitle "Geex Installer" --title "Extra Packages" --inputbox "Enter Packages Separated by a Comma\n\nExample:\n\`\`\`\npackage-1, package-2, package-3\n\`\`\`\n" 20 64 3>&1 1>&2 2>&3) || exit 1
    confirmedPkgList=""
    IFS=',' read -ra ADDR <<< "$userPkgList"
    for i in "${ADDR[@]}"; do
        verified=$(searchForPackageFunction "$i")
        if [[ $? -eq 0 ]]; then
            if [ "$confirmedPkgList" == "" ] || [ -z "$confirmedPkgList" ]; then
                confirmedPkgList="$verified"
            else
                confirmedPkgList="$confirmedPkgList $verified"
            fi
        fi
    done
    echo "[ Status ]: Final Package List: $confirmedPkgList"
    export finalCustomPkgListWithCommas="$confirmedPkgList"
    export finalCustomPkgListWithoutCommas=$(echo -e "$finalCustomPkgListWithCommas" | sed "s/, / /g" | sed "s/,/ /g")
    export finalCustomPkgListCleanup=$(echo "$finalCustomPkgListWithoutCommas" | tr ' ' '\n' | sort -u | xargs)
    export finalCustomPkgList=$(echo ${finalCustomPkgListCleanup//$'\n'/ })
    pkgListConfirmationText="$(echo -e "Please confirm that the list below contains all of the custom packages you selected (filtered through a 'guix search' to determine whether each package exists or not):\n\n$finalCustomPkgList\n\nNote that at this stage, the installer does not check whether a package you defined is already present in your system configuration file, please make sure you do not add duplicate packages.")"
    pkgListConfirmation=$(dialog --backtitle "Geex Installer" --title "Confirm Packages" --yesno "$pkgListConfirmationText" 34 75 3>&1 1>&2 2>&3)
    pkgListConfirmation_RESPONSE_CODE=$?
    if [ "$pkgListConfirmation_RESPONSE_CODE" -eq 0 ]; then
        export pkgListWasConfirmed=1
    else
        export pkgListWasConfirmed=0
    fi
    if [ "$pkgListWasConfirmed" == 1 ]; then
        export extraPackageList="$(echo -e "$finalCustomPkgList\"")"
        echo -e "[ Status ]: List was Confirmed, full List:\n'$extraPackageList'"
        if [[ "$extraPackageList" != "" ]] || [[ -n "$extraPackageList" ]]; then
            export extraPackageListInsertable="$(echo -e "\nUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWUUWU\"$extraPackageList" | sed "s/ /\"\n                             \"/g" | sed "s/UWU/ /g")"
            if [ -f "/tmp/geex.extra.packages.insertable.dd" ]; then
                rm /tmp/geex.extra.packages.insertable.dd
            fi
            echo -e "$extraPackageListInsertable" >> /tmp/geex.extra.packages.insertable.dd
            sed -i "/GEEX_EXTRA_PACKAGE_LIST_OPTIONAL/{
                   r /tmp/geex.extra.packages.insertable.dd
                   d
                   }" /tmp/geex.config.${stager}.dd
        else
            sed -i "s/GEEX_EXTRA_PACKAGE_LIST_OPTIONAL//g" /tmp/geex.config.${stager}.dd
        fi
        #sed "s|GEEX_EXTRA_PACKAGE_LIST_OPTIONAL|$extraPackageListInsertable|g" /tmp/geex.config.${stager}.dd
    else
        echo -e "[ Error ]: Error with List Confirmation"
        sed "s|GEEX_EXTRA_PACKAGE_LIST_OPTIONAL||g" /tmp/geex.config.${stager}.dd
    fi
    if [ "$extraPackageListInsertable" == "" ] || [ -z "$extraPackageListInsertable" ]; then
        sed -i "s/GEEX_EXTRA_PACKAGE_LIST_OPTIONAL//g" /tmp/geex.config.${stager}.dd
    fi
}

# Installer Hooks
installerHook() {
    if [ -n "$GEEX_VERBOSE_MODE" ]; then
        verboseNotice=$(dialog --backtitle "Geex Installer" --title "Verbose Notice" --msgbox "The Installer has detected that you are running in Verbose Mode!\n\nYou will now see more popups and status messages as is the default, for the sake of debugging." 24 40 3>&1 1>&2 2>&3)
    fi
    checkMountPointHook
    if [ "$GEEX_MOVER_MODE" == 1 ]; then
        echo "[ Mover ]: Running Mover inside Installer Hook"
        moverFunction
        exit 1
    fi
    if [ "$GEEX_LIVE_MODE" == 1 ]; then
        liveMessage="$(echo -e "The Installer has detected that you are running in Live Mode, thus, once you have made a system choice, two live windows will open automatically, one display the entire configuration file while the installer is working on it (in full length), and one displaying the same file, but exclusive to the last 50 lines.\n\nIf you want to disable this, do not use the 'l', 'live', or '--live' flags. If you did not use those flags and Live Mode was still activated, make sure to unset the GEEX_LIVE_MODE variable before running the Geex Installer again.\n\nDo you want to continue using Live Mode, then select the 'Yes' option. If you did not want to or intend to use Live Mode, please select the 'No' option.")"
        livePopup=$(dialog --backtitle "Geex Installer" --title "Live Notice" --yesno "$liveMessage" 24 60 \
                           3>&1 1>&2 2>&3)
        LIVE_ANSWER_RESPONSE_CODE=$?
        if [ $LIVE_ANSWER_RESPONSE_CODE -eq 0 ]; then
            export liveAnswer="yes"
        else
            export liveAnswer="no"
        fi
        if [ "$liveAnswer" == "no" ]; then
            unset GEEX_LIVE_MODE
            export GEEX_LIVE_OVERRIDE=1
        else
            if [ -z "$GEEX_LIVE_MODE" ]; then
                export GEEX_LIVE_MODE=1
            fi
        fi
    fi
    if [ -n "$GEEX_DEBUG" ] || [ -n "$GEEX_DEBUG_MODE" ]; then
        debugNotice=$(dialog --backtitle "Geex Installer" --title "Debug Notice" --msgbox "The Installer has detected that you are running in Debug Mode!\n\nCommands will now not actually install anything, copy anything, make changes to your disks, or initialize the GNU Guix System." 24 40 3>&1 1>&2 2>&3)
    fi
    if [ -n "$GEEX_VERBOSE_MODE" ] || [ "$GEEX_VERBOSE_MODE" == 1 ]; then
        if [ -f "/tmp/geex.channels.dd" ]; then
            export verboseWroteChannelsFile="Yes"
        else
            export verboseWroteChannelsFile="No"
        fi
        if [ -f "/tmp/geex.config.desktop.template.dd" ]; then
            export verboseWroteDesktopTemplateFile="Yes"
        else
            export verboseWroteDesktopTemplateFile="No"
        fi
        if [ -f "/tmp/geex.config.laptop.template.dd" ]; then
            export verboseWroteLaptopTemplateFile="Yes"
        else
            export verboseWroteLaptopTemplateFile="No"
        fi
        if [ -f "/tmp/geex.config.minimal.template.dd" ]; then
            export verboseWroteMinimalTemplateFile="Yes"
        else
            export verboseWroteMinimalTemplateFile="No"
        fi
        if [ -f "/tmp/geex.config.libre.template.dd" ]; then
            export verboseWroteLibreTemplateFile="Yes"
        else
            export verboseWroteLibreTemplateFile="No"
        fi
        verboseDefaultFileWriteStatusText="$(echo -e "Verbose Mode Detected, informing you of all default systems template files that were created, as well as checking for any leftover files from possible previous installation procedures.\n\n - Found Leftovers?: $verboseFoundLeftoverFiles\n\nThe Installer Wrote the following Files:\n\n - Channels?: $verboseWroteChannelsFile\n - Desktop Template?: $verboseWroteDesktopTemplateFile\n - Laptop Template?: $verboseWroteLaptopTemplateFile\n - Libre Template?: $verboseWroteLibreTemplateFile\n - Minimal Template?: $verboseWroteMinimalTemplateFile")"
        verboseNotice=$(dialog --backtitle "Geex Installer" --title "Verbose Notice" --msgbox "$verboseDefaultFileWriteStatusText" 34 68 3>&1 1>&2 2>&3)
    fi
    welcome=$(dialog --backtitle "Geex Installer" --title "Welcome" --menu "Welcome to the (still experimental) Geex Installer, this Installer will help you to install the Geex Configuration Files onto real Hardware, or install a custom version of Guix, with your very own Configuration Files, to a system of your choice.\n\nThis Installer is pre-alpha code, so please follow instructions carefully when given, and verify everything worked after the installation finishes.\n\nTo begin, click 'I agree'." 32 50 10 \
                                agree "I agree" \
                                abort "Abort" \
                                3>&1 1>&2 2>&3) || exit 1
    if [[ "$welcome" != "agree" ]]; then
        echo "[ Status ]: Aborting..."
        exit 1
    fi
    if [ -f "/tmp/geex.keyboardstatus.dd" ]; then
        rm /tmp/geex.keyboardstatus.dd
    fi
    if [ -f "/tmp/geex.summary.dd" ]; then
        rm /tmp/geex.summary.dd
    fi
    if [ -f "/tmp/geex.detecteddisks.dd" ]; then
        rm /tmp/geex.detecteddisks.dd
    fi
    if [ -f "/tmp/geex.detectedbios.dd" ]; then
        rm /tmp/geex.detectedbios.dd
    fi
    systemsSelection
    if [[ "$systemchoice" == "custom" ]]; then
        export stager="custom"
        if [ -f "/tmp/geex.config.${stager}.dd" ]; then
            rm /tmp/geex.config.${stager}.dd
        fi
        if [ -f "/tmp/geex.config.${stager}.template.dd" ]; then
            cp /tmp/geex.config.${stager}.template.dd /tmp/geex.config.${stager}.dd
            echo "[ Status ]: Created writeable Stager Config"
        else
            echo "[ Warning ]: Stager Template not found."
        fi
        customStage2
    else
        export stager="$systemchoice"
        if [ -f "/tmp/geex.config.${stager}.dd" ]; then
            rm /tmp/geex.config.${stager}.dd
        fi
        if [ -f "/tmp/geex.config.${stager}.template.dd" ]; then
            cp /tmp/geex.config.${stager}.template.dd /tmp/geex.config.${stager}.dd
            echo "[ Status ]: Created writeable Stager Config"
        else
            echo "[ Warning ]: Stager Template not found."
        fi
        "${systemchoice}Stage2"
    fi
    if [ "$GEEX_LIVE_MODE" == 1 ] && [ -z "$GEEX_LIVE_OVERRIDE" ]; then
        livePreviewHook
    fi
    username=$(dialog --backtitle "Geex Installer" --title "Username" --inputbox "Enter your Username:" 8 40 \
                      3>&1 1>&2 2>&3) || exit 1
    if [ "$username" == "" ]; then
        echo "[ Error ]: No Username provided, aborting..."
        exit 1
    else
        if [ -f "/tmp/geex.config.${stager}.dd" ]; then
            sed -i "s/GEEX_USERNAME/$username/g" /tmp/geex.config.${stager}.dd
        else
            errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "File '/tmp/geex.config.${stager}.dd' was not found, thus the Installer did NOT set the Username to '$username'." 32 50 10 \
                                  continue "Continue anyways" \
                                  abort "Abort" \
                                  3>&1 1>&2 2>&3) || exit 1
            if [ "$errorMessage" == "abort" ]; then
                echo "[ Status ]: Aborting..."
                exit 1
            fi
        fi
    fi
    hostname=$(dialog --backtitle "Geex Installer" --title "Hostname" --inputbox "Enter your Hostname:" 8 40 \
                      3>&1 1>&2 2>&3) || exit 1
    if [ "$hostname" == "" ]; then
        echo "[ Error ]: No Hostname provided, aborting..."
        exit 1
    else
        if [ -f "/tmp/geex.config.${stager}.dd" ]; then
            sed -i "s/GEEX_HOSTNAME/$hostname/g" /tmp/geex.config.${stager}.dd
        else
            errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "File '/tmp/geex.config.${stager}.dd' was not found, thus the Installer did NOT set the Hostname to '$hostname'." 32 50 10 \
                                  continue "Continue anyways" \
                                  abort "Abort" \
                                  3>&1 1>&2 2>&3) || exit 1
            if [ "$errorMessage" == "abort" ]; then
                echo "[ Status ]: Aborting..."
                exit 1
            fi
        fi
    fi
    if [ -n "$GEEX_VERBOSE_MODE" ] || [ "$GEEX_VERBOSE_MODE" == 1 ]; then
        verboseUsernameBlock=$(cat /tmp/geex.config.${stager}.dd | grep "name" | grep "$username" | sed "s/^[ \t]*//g")
        verboseHostnameBlock=$(cat /tmp/geex.config.${stager}.dd | grep "$hostname" | sed "s/^[ \t]*//g")
        verboseNotice=$(dialog --backtitle "Geex Installer" --title "Verbose Notice" --msgbox "The Installer has successfully set and wrote the following variables based on your input/selection:\n\n - Username: $username\n - Hostname: $hostname\n\nUsername Block:\n\`\`\`\n$verboseUsernameBlock\n\`\`\`\n\nHostname Block:\n\`\`\`\n$verboseHostnameBlock\n\`\`\`" 34 68 3>&1 1>&2 2>&3)
    fi
    timezoneHook
    keyboardHook
    if [ -n "$GEEX_VERBOSE_MODE" ] || [ "$GEEX_VERBOSE_MODE" == 1 ]; then
        verboseKeyboardBlockText=$(cat /tmp/geex.config.${stager}.dd | grep "$keyboard" | sed "s/^[ \t]*//g")
        verboseNotice=$(dialog --backtitle "Geex Installer" --title "Verbose Notice" --msgbox "The Installer has written and set up the following options and code-blocks for your Region, Timezone, Keyboard Layout and Layout Variant:\n\nSettings:\n - Keyboard: $keyboardInfo\n - Region/Timezone: $TIMEZONE\n - Wrote Keyboard Block?: $wroteKeyboardBlock\n - Wrote Timezone Block?: $wroteTimezoneBlock\n\nTimezone Block:\n\`\`\`\n$verboseTimezoneBlockText\n\`\`\`\n\nKeyboard Block:\n\`\`\`\n$verboseKeyboardBlockText\n\`\`\`" 34 68 3>&1 1>&2 2>&3)
    fi
    if [ -f "/tmp/geex.timezone.success.dd" ]; then
        rm /tmp/geex.timezone.success.dd
    fi
    if [[ -z "$TIMEZONE" ]]; then
        noticePopup=$(dialog --backtitle "Geex Installer" --title "Timezone Notice" --menu "There was an unrecoverable error setting your timezone. This means that either the timezoneHook function was never called, or a different error prohibited the installer from interacting with your system, its own temporary files, and your general environment.\n\nIf you have made any manual code changes to this installer, that could be the cause of an error like this, please verify the installers code integrity and make sure you have NOT changed anything about the timezoneHook or installerHook.\n\nStill continue? (This means the timezone variable in your Guix Configuration will remain as the 'GEEX_TIMEZONE' placeholder - change this manually if you still want to continue!)" 12 40 5 \
                             continue "Continue" \
                             abort "Abort" \
                             3>&1 1>&2 2>&3) || exit 1
        if [ "$noticePopup" == "abort" ]; then
            echo "[ Status ]: Aborting..."
            exit 1
        fi
    fi
    disksHook
    biosHook
    if [ "$bios" == "legacy" ]; then
        biosLegacyEditHook
    else
        biosUefiEditHook
    fi
    disksSetup
    if [ "$wroteBiosBlock" == 0 ]; then
        export wroteBiosBlock="No"
    else
        export wroteBiosBlock="Yes"
    fi
    filesystemHook
    serviceSetupHook
    if [ "$wroteFilesystemBlock" == 0 ]; then
        export isFilesystemWritten="No"
    else
        export isFilesystemWritten="Yes"
    fi
    if [ "$finishedServiceSetup" == 0 ]; then
        export areServicesWritten="No"
        export serviceSelection="None"
    else
        export areServicesWritten="Yes"
    fi
    desktopEnvironmentsHook
    if [ "$finishedDesktopSetup" == 0 ]; then
        export areDesktopsWritten="No"
        export deSelection="None"
    else
        export areDesktopsWritten="Yes"
    fi
    passwordHook
    if [ "$configuredPasswords" == 1 ]; then
        export areAllPasswordsSet="Yes"
    elif [ "$configuredPasswords" == 2 ]; then
        export areAllPasswordsSet="Mock"
    else
        export areAllPasswordsSet="No"
    fi
    if [ "$reUsedRootPassword" == 1 ]; then
        export wasPasswordReUsed="Yes"
    else
        export wasPasswordReUsed="No"
    fi
    if [ "$bios" == "legacy" ]; then
        export diskPrefixedPartNameTextblock="${diskPrefixed}1 (guix-root)"
    else
        export diskPrefixedPartNameTextblock="${diskPrefixed}1 (guix-efi), ${diskPrefixed}2 (guix-root)"
    fi
    addCustomPackageHook
    summaryTextContents="$(echo -e "Please verify all the information below is accurate and exactly as you selected/want it:\n - Username: $username\n - $username Password Set?: $areAllPasswordsSet\n - Root Password Set?: $areAllPasswordsSet\n - Root and $username Password Match?: $wasPasswordReUsed\n - Hostname: $hostname\n - Timezone: $TIMEZONE\n - Disk: $disk\n - Disk Parts: $diskPrefixedPartNameTextblock\n - BIOS: $bios\n - Auto-Detected BIOS: $detectedBios\n - Keyboard: $keyboardInfo\n - Services: $serviceSelection\n - Desktops: $deSelection\n\nInternal Statistics:\n - Systemchoice: $systemchoice\n - Stager: $stager\n - Stagerfile: '/tmp/geex.config.${stager}.dd'\n\nWrote Blocks Status (Did the Installer Write ... X?):\n - BIOS Block?: ${wroteBiosBlock}\n - Filesystems?: $isFilesystemWritten\n - Services?: $areServicesWritten\n - Desktops?: $areDesktopsWritten\n - Keyboard?: $wroteKeyboardBlock (Found?: $foundKeyboardBlock)")"
    if [ -f "/tmp/geex.summary.dd" ]; then
        rm /tmp/geex.summary.dd
    fi
    echo "$summaryTextContents" >> /tmp/geex.summary.dd
    summary=$(dialog --backtitle "Geex Installer" --title "Summary" --msgbox "$summaryTextContents" 34 75 3>&1 1>&2 2>&3) || exit 1
    configDisplay=$(dialog --backtitle "Geex Installer" --title "Written Configuration" --textbox "/tmp/geex.config.${stager}.dd" 34 75 3>&1 1>&2 2>&3) || exit 1
    if [ "$GEEX_LIVE_MODE" == 1 ]; then
        liveNotice=$(dialog --backtitle "Geex Installer" --title "Live Notice" --msgbox "You have been using Live Mode for the duration of this installation process. However, the install process is nearing its end, the Live Preview Windows will now be selectively killed, and the installation procedure will continue." 34 75 3>&1 1>&2 2>&3) || exit 1
        liveKillHook
    fi
    confirmation=$(dialog --backtitle "Geex Installer" --title "Confirmation" --menu "Have you confirmed whether or not all the information provided is correct? If so, would you like to begin the installation now?" 32 50 10 \
                          yes "Yes, begin Installation" \
                          no "No, Abort" \
                          3>&1 1>&2 2>&3) || exit 1
    if [ "$confirmation" == "yes" ]; then
        channelPullHook
        systemInstallHook
    else
        echo "[ Status ]: Aborting..."
        exit 1
    fi
    if [ "$installationStatus" == 1 ]; then
        success=$(dialog --backtitle "Geex Installer" --title "Success" --menu "The Installer successfully installed your GNU Guix System ($systemchoice) to '${geexMount}'. Please verify the installation process actually succeeded. The Installer will now continue on to the Password Setup phase, and then ask for your Guix Home preferences." 32 50 10 \
                         continue "Continue" \
                         abort "Abort" \
                         3>&1 1>&2 2>&3) || exit 1
        if [ "$success" == "abort" ]; then
            echo "[ Status ]: Aborting..."
            exit 1
        fi
        if [ "$configuredPasswords" == 1 ]; then
            passwordApplyHook
        fi
        homeHook
    else
        if [ -n "$GEEX_DEBUG" ] || [ -n "$GEEX_DEBUG_MODE" ]; then
            noticePopup=$(dialog --backtitle "Geex Installer" --title "Debug Notice" --menu "Debug Mode has been detected by the Installer. Your installation has been running in Debug Mode the entire time.\n\nThe Installer will now continue with a Mock installation success hook." 32 50 10 \
                                 okay "Okay" \
                                 abort "Abort" \
                                 3>&1 1>&2 2>&3) || exit 1
            if [ "$noticePopup" == "okay" ]; then
                if [ "$configuredPasswords" == 1 ]; then
                    passwordApplyHook
                fi
                homeHook
                if [ "$formattedDisksStatus" == 1 ]; then
                    export formattedDisksStatus="Yes"
                elif [ "$formattedDisksStatus" == 2 ]; then
                    export formattedDisksStatus="Mock"
                else
                    export formattedDisksStatus="No"
                fi
                if [ "$copiedHome" == 1 ]; then
                    export homeStatus="Yes"
                elif [ "$copiedHome" == 2 ]; then
                    export homeStatus="Mock"
                else
                    export homeStatus="No"
                fi
                if [ "$finishedDesktopSetup" == 0 ]; then
                    desktopsExist="No"
                else
                    desktopsExist="Yes"
                fi
                if [ "$systemFinished" == 1 ]; then
                    export finishedMessage="$(echo -e "Final Report\n============\n(Use Arrow Keys to Scroll)\n\nInformation:\n - Username: $username\n - $username Password Set?: $areAllPasswordsSet\n - Root Password Set?: $areAllPasswordsSet\n - Root and $username Password Match?: $wasPasswordReUsed\n - Hostname: $hostname\n - Timezone: $TIMEZONE\n - Disk: $disk\n - Disk Parts: $diskPrefixedPartNameTextblock\n - BIOS: $bios\n - Auto-Detected BIOS: $detectedBios\n - Keyboard: $keyboardInfo\n - Services: $serviceSelection\n - Desktops: $deSelection\n\nInternal Statistics:\n - Systemchoice: $systemchoice\n - Stager: $stager\n - Stagerfile: '/tmp/geex.config.${stager}.dd'\n\nWrote Blocks Status (Did the Installer Write ... X?):\n - BIOS Block?: ${wroteBiosBlock}\n - Filesystems?: $isFilesystemWritten\n - Services?: $areServicesWritten\n - Desktops?: $areDesktopsWritten\n - Keyboard?: $wroteKeyboardBlock (Found?: $foundKeyboardBlock)\n\nOther:\n - Pulled Channels?: $channelReport\n - Copied Home?: $homeStatus\n - Home-Get Method?: $homeGetMethod\n - Formatted Disks?: $formattedDisksStatus\n - Installation Path: '${geexMount}'\n\nFinish Installation?")"
                    finishedNotice=$(dialog --backtitle "Geex Installer" --title "Finalization" --yesno "$finishedMessage" 40 124 \
                                            3>&1 1>&2 2>&3)
                    FINISHED_NOTICE_RESPONSE_CODE=$?

                    if [ $FINISHED_NOTICE_RESPONSE_CODE -eq 0 ]; then
                        export finishedNoticeAnswer="yes"
                    else
                        export finishedNoticeAnswer="no"
                    fi
                    if [ "$finishedNoticeAnswer" == "no" ]; then
                        echo "[ Status ]: Aborting..."
                        exit 1
                    else
                        dialog --clear
                        clear
                        echo -e "[ Status ]: Success! Geex (GNU Guix) was installed to your '$disk' Drive, and mounted at '${geexMount}'.\n[ Result ]: Here are your Files\n  - 'config.scm' -> ${geexMount}/etc/guix/config.scm (and) /tmp/geex.config.${stager}.scm\n - 'home.scm' -> ${geexMount}/etc/guix/home.scm\n[ Info ]: You may want to know about these useful Commands:\n - Rebuild System\n   - guix system reconfigure /etc/guix/config.scm\n - Rebuild Home\n   - guix home reconfigure /etc/guix/home.scm\n - Describe Generation\n   - guix describe\n - Pull Channels\n   - guix pull\n\nThank you for using Geex!"
                    fi
                elif [ "$systemFinished" == 2 ]; then
                    export finishedMessage="$(echo -e "Final Report\n============\n(Use Arrow Keys to Scroll)\n\nInformation:\n - Username: $username\n - $username Password Set?: $areAllPasswordsSet\n - Root Password Set?: $areAllPasswordsSet\n - Root and $username Password Match?: $wasPasswordReUsed\n - Hostname: $hostname\n - Timezone: $TIMEZONE\n - Disk: $disk\n - Disk Parts: $diskPrefixedPartNameTextblock\n - BIOS: $bios\n - Auto-Detected BIOS: $detectedBios\n - Keyboard: $keyboardInfo\n - Services: $serviceSelection\n - Desktops: $deSelection\n\nInternal Statistics:\n - Systemchoice: $systemchoice\n - Stager: $stager\n - Stagerfile: '/tmp/geex.config.${stager}.dd'\n\nWrote Blocks Status (Did the Installer Write ... X?):\n - BIOS Block?: ${wroteBiosBlock}\n - Filesystems?: $isFilesystemWritten\n - Services?: $areServicesWritten\n - Desktops?: $areDesktopsWritten\n - Keyboard?: $wroteKeyboardBlock (Found?: $foundKeyboardBlock)\n\nOther:\n - Pulled Channels?: $channelReport\n - Copied Home?: $homeStatus\n - Home-Get Method?: $homeGetMethod\n - Formatted Disks?: $formattedDisksStatus\n - Installation Path: '${geexMount}'\n\nFinish Installation?")"
                    finishedNotice=$(dialog --backtitle "Geex Installer" --title "Finalization" --yesno "$finishedMessage" 40 124 \
                                            3>&1 1>&2 2>&3)
                    FINISHED_NOTICE_RESPONSE_CODE=$?

                    if [ $FINISHED_NOTICE_RESPONSE_CODE -eq 0 ]; then
                        export finishedNoticeAnswer="yes"
                    else
                        export finishedNoticeAnswer="no"
                    fi
                    if [ "$finishedNoticeAnswer" == "no" ]; then
                        echo "[ Status ]: Aborting..."
                        exit 1
                    else
                        dialog --clear
                        clear
                        echo -e "[ Status ]: Success! Geex (GNU Guix) was installed to your '$disk' Drive, and mounted at '${geexMount}'.\n[ Result ]: Here are your Files\n  - 'config.scm' -> ${geexMount}/etc/guix/config.scm (and) /tmp/geex.config.${stager}.scm\n - 'home.scm' -> ${geexMount}/etc/guix/home.scm\n[ Info ]: You may want to know about these useful Commands:\n - Rebuild System\n   - guix system reconfigure /etc/guix/config.scm\n - Rebuild Home\n   - guix home reconfigure /etc/guix/home.scm\n - Describe Generation\n   - guix describe\n - Pull Channels\n   - guix pull\n\nThank you for using Geex!"
                        if [[ ! -n "$GEEX_DEBUG_MODE" ]] || [[ "$GEEX_DEBUG_MODE" != 1 ]]; then
                            if mountpoint -q ${geexMount}; then
                                umount ${geexMount}
                                if [[ "$geexMount" != "/mnt" ]] && [[ "$geexMount" != "/Mount" ]]; then
                                    rm -rf $geexMount
                                fi
                            fi
                        fi
                    fi
                elif [ "$systemFinished" == 0 ]; then
                    if [[ -n "$GEEX_DEBUG" ]] || [[ -n "$GEEX_DEBUG_MODE" ]]; then
                        debugNotice=$(dialog --backtitle "Geex Installer" --title "Debug Notice" --msgbox "The Installer has detected Debug Mode, all though it will no longer force-exit/quit the installation procedure, you have STILL encountered an error that is not supposed to ever occur under any circumstances, please verify this!\n\nActions to take:\n - Fetch the Official Geex Installer from 'https://github.com/librepup/geex'\n - Verify your '/tmp' Directory is Writeable\n\nContinuing due to Debug Setting." 34 75 3>&1 1>&2 2>&3) || exit 1
                    else
                        errorMessage=$(dialog  --backtitle "Geex Installer" --title "Error" --msgbox "The Installer has encountered one (or more) errors due to which the 'systemFinished' state could not be reached.\n\nPlease debug this error yourself. Possible causes are:\n - Faulty Internet Connection\n - Entire (Selected) Disk is Read-Only\n - The Geex Installer's Code was Tampered With\n - Files or Processes were Modified (or Killed) while the Geex Installer was not Done with them.\n\nThe Installer will now quit, but may have still been working on and with your disk(s), filesystem, written configuration files, copied or fetched remote sources, and more.\n\nPLEASE verify this yourself!" 34 75 3>&1 1>&2 2>&3) || exit 1
                        echo "[ Status ]: Aborting..."
                        exit 1
                    fi
                else
                    errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --msgbox "The Installer has experienced and unknown (and supposed to be impossible to reach) state due to an unknown error. This is pretty much only possible if you or someone else has tampered with the Geex Installer's Code beforehand, and you are not running an original copy of this Installer.\n\nPlease verify you are running the official Geex Installer from the following repository:\n - https://github.com/librepup/geex\n\nThe Installer cannot continue. If you are not inside Debug Mode, the installer may still have formatted and worked with your disk(s), as well as written files, and possibly taken other actions as well.\n\nPlease check this yourself." 34 75 3>&1 1>&2 2>&3) || exit 1
                    echo "[ Status ]: Aborting..."
                    exit 1
                fi
            fi
            exit 1
        fi
        error=$(dialog --backtitle "Geex Installer" --title "Error" --menu "The Installer has encountered one or more errors during the system installation phase. Your system was NOT installed. Disks may still have been partitioned, formatted, and mounted - CHECK THIS!\n\nThe installer will now quit." 32 50 10 \
                       okay "Okay" \
                       3>&1 1>&2 2>&3) || exit 1

        if [ -n "$GEEX_DEBUG" ] || [ -n "$GEEX_DEBUG_MODE" ]; then
            if [ "$error" == "okay" ]; then
                echo "[ Status ]: Debug Mode Detected, ignoring Exit Call..."
            fi
        else
            if [ "$error" == "okay" ]; then
                echo "[ Status ]: Quitting..."
                exit 1
            fi
        fi
        exit 1
    fi
}

for arg in "$@"; do
    case "$arg" in
        v|-v|--v|verbose|-verbose|--verbose)
            export GEEX_VERBOSE_MODE=1
            ;;
    esac
done

for arg in "$@"; do
    case "$arg" in
        d|-d|--d|debug|-debug|--debug)
            export GEEX_DEBUG=1
            export GEEX_DEBUG_MODE=1
            ;;
    esac
done

for arg in "$@"; do
    case "$arg" in
        p|-p|--p|package|-package|--package|pkgtest|-pkgtest|--pkgtest)
            export GEEX_PKG_TEST_MODE=1
            export GEEX_DEBUG_MODE=1
            ;;
        pi|-pi|--pi|packageinstall|-packageinstall|--packageinstall|pkgtestinstall|-pkgtestinstall|--pkgtestinstall)
            export GEEX_PKG_TEST_MODE=1
            export GEEX_DEBUG_MODE=1
            installerHook
            ;;
    esac
done

for arg in "$@"; do
    case "$arg" in
        i|-i|--i|install|-install|--install)
            installerHook
            ;;
    esac
done

if [ "$GEEX_MOVER_MODE" == 1 ]; then
    installerHook
fi

# Unset Exported Variables
unset missingCommandCount
unset IN_GUIX_SHELL
unset randFunc
unset randFuncString
unset randEtcName
unset randCfgName
unset backedUpCfg
unset backedUpEtc
unset backupState
unset copyState
unset userName
unset homeDirectory
unset manualHomeDirectory
unset manualUserName
unset userGuess
