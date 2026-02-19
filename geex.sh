#!/usr/bin/env sh

# Check if Commands are Missing
export missingCommandCount=0
for cmd in cp awk dialog git grep parted lsblk find; do
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
  if [ -z "$GUIX_ENVIRONMENT" ] && echo "[ Status ]: Checking for Guix, then running shell exec hook..." && command -v guix >/dev/null 2>&1 && guix shell coreutils bash gawk grep parted findutils util-linux git-minimal dialog -- true >/dev/null 2>&1; then
      echo "[ Guix ]: Found Guix, running guix shell exec hook..."
      export IN_GUIX_SHELL=1
      exec guix shell coreutils bash gawk grep parted findutils util-linux git-minimal dialog -- bash "$0" "$@"
  elif [ -z "$IN_NIX_SHELL" ] && echo "[ Warning ]: Guix not found, checking for Nix, then running shell exec hook..." && command -v nix-shell >/dev/null 2>&1 && nix-shell -p coreutils gawk bash gnugrep parted findutils util-linux git dialog --run true >/dev/null 2>&1; then
      echo "[ Nix ]: Found Nix, running nix shell exec hook..."
      exec nix-shell -p coreutils bash gawk gnugrep parted findutils util-linux git dialog --run "bash "$0" "$@""
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

# Setup Hooks
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
setKeyboardUs() {
    echo "Keyboard: English (US)"
    if [ -f "/tmp/geex.config.${stager}.dd" ]; then
        sed -i 's/GEEX_KEYBOARD_LAYOUT/"us"/g' /tmp/geex.config.dd
    else
        echo "No '/tmp/geex.config.${stager}.dd' found..."
        export keyboardUsFeedback="[ Layout (US) ]: '/tmp/geex.config.${stager}.dd' absent."
    fi
}
setKeyboardColemak() {
    echo "Keyboard: English (Colemak)"
    if [ -f "/tmp/geex.config.${stager}.dd" ]; then
        sed -i 's/GEEX_KEYBOARD_LAYOUT/"us" "colemak"/g' /tmp/geex.config.dd
    else
        echo "No '/tmp/geex.config.${stager}.dd' found..."
        export keyboardColemakFeedback="[ Layout (Colemak) ]: '/tmp/geex.config.${stager}.dd' absent."
    fi
}
setKeyboardDe() {
    echo "Keyboard: German (DE)"
    if [ -f "/tmp/geex.config.${stager}.dd" ]; then
        sed -i 's/GEEX_KEYBOARD_LAYOUT/"de"/g' /tmp/geex.config.dd
    else
        echo "No '/tmp/geex.config.${stager}.dd' found..."
        export keyboardDeFeedback="[ Layout (DE) ]: '/tmp/geex.config.${stager}.dd' absent."
    fi
}
keyboardStatusHook() {
    if [ "$keyboard" == "us" ]; then
        export keyboardStatusText="$(echo -e "Keyboard Layout US reported:\n\n$keyboardUsFeedback\n")"
    elif [ "$keyboard" == "colemak" ]; then
        export keyboardStatusText="$(echo -e "Keyboard Layout Colemak reported:\n\n$keyboardColemakFeedback\n")"
    else
        export keyboardStatusText="$(echo -e "Keyboard Layout DE reported:\n\n$keyboardDeFeedback\n")"
    fi
    echo "$keyboardStatusText" >> /tmp/geex.keyboardstatus.dd
    keyboardStatusNotice=$(dialog --backtitle "Geex Installer" --title "Keyboard Status" --textbox "/tmp/geex.keyboardstatus.dd" 22 75 3>&1 1>&2 2>&3) || exit 1
}
biosHook() {
    if [[ -d /sys/firmware/efi ]]; then
        export detectedBios="(U)EFI"
    else
        export detectedBios="Legacy"
    fi
    detectedBiosNoticeText="$(echo -e "The Installer has detected that you are using:\n\n$detectedBios\n\nas your BIOS type. You may want to select this type at the next questionnaire.")"
    echo -e "$detectedBiosNoticeText" >> /tmp/geex.detectedbios.dd
    detectedBiosNotice=$(dialog --backtitle "Geex Installer" --title "BIOS Auto-Detection" --textbox "/tmp/geex.detectedbios.dd" 22 75 3>&1 1>&2 2>&3) || exit 1
    bios=$(dialog --backtitle "Geex Installer" --title "BIOS" --menu "Are you using (U)EFI or Legacy BIOS?" 32 50 10 \
                  uefi "(U)EFI" \
                  legacy "Legacy" \
                  3>&1 1>&2 2>&3) || exit 1
    export bios=$bios
}
disksHook() {
    detectedDisksNoticeText="The Installer has detected the following Disks in your Device:"
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
}
disksSetup() {
    echo "Formatting disks ($disk)..."
    if [ "$bios" == "legacy" ]; then
        echo "sudo parted $disk --script \\"
        echo "  mklabel msdos \\"
        echo "  mkpart primary ext4 1MiB 100% \\"
        echo -e "  set 1 boot on\n\n"
        echo "sudo mkfs.ext4 ${diskPrefixed}1"
        echo "sudo mount ${diskPrefixed}1 /mnt"
        echo -e "\nFinished Legacy Formatting and Mounting\n"
    else
        echo "sudo parted $disk --script \\"
        echo "  mklabel gpt \\"
        echo "  mkpart ESP fat32 1MiB 2048MiB \\"
        echo "  set 1 esp on \\"
        echo -e "  mkpart primary ext4 2048MiB 100%\n\n"
        echo "sudo mkfs.fat -F32 ${diskPrefixed}1"
        echo "sudo mkfs.ext4 ${diskPrefixed}2"
        echo "sudo mount ${diskPrefixed}2 /mnt"
        echo "sudo mkdir -p /mnt/boot"
        echo "sudo mount ${diskPrefixed}1 /mnt/boot"
        echo -e "\nFinished (U)EFI Formatting and Mounting\n"
    fi
}
customStage2() {
    echo "Entered Custom System Setup Stage 2"
}
desktopStage2() {
    echo "Entered Desktop System Setup Stage 2"
}
laptopStage2() {
    echo "Entered Laptop System Setup Stage 2"
}
libreStage2() {
    echo "Entered Libre System Setup Stage 2"
}
minimalStage2() {
    echo "Entered Minimal System Setup Stage 2"
}
biosLegacyEditHook() {
    legacyBlock="$(echo -e " (bootloader (bootloader-configuration\n              (keyboard-layout keyboard-layout)\n              (bootloader grub-bootloader)\n              (targets '(\"${diskPrefixed}1\"))))\n")"
    legacyBlockVerify=$(dialog --backtitle "Geex Installer" --title "Verify BIOS Block" --menu "$legacyBlock" 32 50 10 \
                             continue "Continue" \
                             abort "Abort" \
                             3>&1 1>&2 2>&3) || exit 1
    if [ "$legacyBlockVerify" == "abort" ]; then
        echo "[ Status ]: Aborting..."
        exit 1
    fi
    if [ -f "/tmp/geex.config.${stager}.dd" ]; then
        sed -i 's/GEEX_BIOS_OPTIONAL/$uefiBlock/g' /tmp/geex.config.${stager}.dd
        successMessage=$(dialog --backtitle "Geex Installer" --title "Success" --menu "Successfully wrote BIOS hook into '/tmp/geex.config.${stager}.dd'." 32 50 10 \
                                continue "Continue" \
                                abort "Abort" \
                                3>&1 1>&2 2>&3) || exit 1
        if [ "$successMessage" == "abort" ]; then
            echo "[ Status ] Aborting..."
            exit 1
        fi
    else
        errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "The Installer encountered an error: '/tmp/geex.config.${stager}.dd' was not found, thus the BIOS hook did not finish writing.\n\nContinue anyways?" 32 50 10 \
                              continue "Continue" \
                              abort "Abort" \
                              3>&1 1>&2 2>&3) || exit 1
        if [ "$errorMessage" == "abort" ]; then
            echo "[ Status ]: Aborting..."
            exit 1
        fi
    fi
}
biosUefiEditHook() {
    uefiBlock="$(echo -e " (bootloader (bootloader-configuration\n              (keyboard-layout keyboard-layout)\n              (bootloader grub-efi-bootloader)\n              (targets '(\"/boot/efi\"))))\n")"
    uefiBlockVerify=$(dialog --backtitle "Geex Installer" --title "Verify BIOS Block" --menu "$uefiBlock" 32 50 10 \
                             continue "Continue" \
                             abort "Abort" \
                             3>&1 1>&2 2>&3) || exit 1
    if [ "$uefiBlockVerify" == "abort" ]; then
        echo "[ Status ]: Aborting..."
        exit 1
    fi
    if [ -f "/tmp/geex.config.${stager}.dd" ]; then
        sed -i 's/GEEX_BIOS_OPTIONAL/$uefiBlock/g' /tmp/geex.config.${stager}.dd
        successMessage=$(dialog --backtitle "Geex Installer" --title "Success" --menu "Successfully wrote BIOS hook into '/tmp/geex.config.${stager}.dd'." 32 50 10 \
                                continue "Continue" \
                                abort "Abort" \
                                3>&1 1>&2 2>&3) || exit 1
        if [ "$successMessage" == "abort" ]; then
            echo "[ Status ] Aborting..."
            exit 1
        fi
    else
        errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "The Installer encountered an error: '/tmp/geex.config.${stager}.dd' was not found, thus the BIOS hook did not finish writing.\n\nContinue anyways?" 32 50 10 \
                              continue "Continue" \
                              abort "Abort" \
                              3>&1 1>&2 2>&3) || exit 1
        if [ "$errorMessage" == "abort" ]; then
            echo "[ Status ]: Aborting..."
            exit 1
        fi
    fi
}
systemInstallHook() {
    echo "[ Status ]: Beginning formal GNU Guix installation..."
}

# Installer Hooks
installerHook() {
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
    username=$(dialog --backtitle "Geex Installer" --title "Username" --inputbox "Enter your Username:" 8 40 \
                      3>&1 1>&2 2>&3) || exit 1
    if [ "$username" == "" ]; then
        echo "[ Error ]: No Username provided, aborting..."
        exit 1
    else
        if [ -f "/tmp/geex.config.${stager}.dd" ]; then
            sed -i 's/GEEX_USERNAME/$username/g' /tmp/geex.config.${stager}.dd
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
            sed -i 's/GEEX_HOSTNAME/$hostname/g' /tmp/geex.config.${stager}.dd
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
    disksHook
    biosHook
    if [ "$bios" == "legacy" ]; then
        biosLegacyEditHook
    else
        biosUefiEditHook
    fi
    keyboard=$(dialog --backtitle "Geex Installer" --title "Keyboard Layout" --menu "Select your preferred Keyboard Layout:" 12 40 5 \
                      us "English (US)" \
                      colemak "English (Colemak)" \
                      de "Germane (DE)" \
                      3>&1 1>&2 2>&3) || exit 1
    case "$keyboard" in
        us)
            setKeyboardUs
            ;;
        colemak)
            setKeyboardColemak
            ;;
        de)
            setKeyboardDe
            ;;
    esac
    keyboardStatusHook
    disksSetup
    summaryTextContents="$(echo -e "[!] Read Carefully [!]\n\nUsername: $username\nHostname: $hostname\nDisk: $disk (Part Format: ${diskPrefixed}1, ${diskPrefixed}2, ... )\nBIOS: $bios (Detected: $detectedBios)\nKeyboard: $keyboard\nSystemchoice: $systemchoice\nStager: $stager\nStagerfile: '/tmp/geex.config.${stager}.dd'")"
    echo "$summaryTextContents" >> /tmp/geex.summary.dd
    summary=$(dialog --backtitle "Geex Installer" --title "Summary" --textbox "/tmp/geex.summary.dd" 22 75 3>&1 1>&2 2>&3)
    confirmation=$(dialog --backtitle "Geex Installer" --title "Confirmation" --menu "Have you confirmed whether or not all the information provided is correct? If so, would you like to begin the installation now?" 32 50 10 \
                          yes "Yes, begin Installation" \
                          no "No, Abort" \
                          3>&1 1>&2 2>&3) || exit 1
    if [ "$confirmation" == "yes" ]; then
        systemInstallHook
    else
        echo "[ Status ]: Aborting..."
        exit 1
    fi
    exit 1
}

# Check for Help Argument
if [ "$1" == "h" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo -e \
         "geex - Geex Systems Configuration Utility
  options:
    arguments:
      - [i/-i/--i] [install/-install/--install] => Start interactive Installer
      - [g/-g/--g] [git/-git/--git] [github/-github/--github] => Print Geex's GitHub Repository URL
    environment variables:
      - GEEX_DEBUG/GEEX_DEBUG_MODE => Do not perform any operations, just pretend.
      - GEEX_IGNORE_MISSING => Ignore Missing Packages, try to Continue Anyways
      - GEEX_DEBUG_MISSING_ENABLE => Pretend as if Packages were Missing"
    exit 1
elif [ "$1" == "g" ] || [ "$1" == "git" ] || [ "$1" == "-g" ] || [ "$1" == "--g" ] || [ "$1" == "-git" ] || [ "$1" == "--git" ] || [ "$1" == "github" ] || [ "$1" == "-github" ] || [ "$1" == "--github" ]; then
    echo -e \
         "Geex GitHub Repository:
  - URL: https://github.com/librepup/geex

LibrePup E-Mail (for questions):
  - E-Mail: librepup@member.fsf.org"
    exit 1
elif [ "$1" == "i" ] || [ "$1" == "-i" ] || [ "$1" == "--i" ] || [ "$1" == "install" ] || [ "$1" == "-install" ] || [ "$1" == "--install" ]; then
    installerHook
fi

# Create Randomized Backup Name
export randFunc="$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)"
export randFuncString="$(echo $randFunc)"
export randEtcName="$(echo guix.backup-etc.$randFuncString)"
export randCfgName="$(echo guix.backup-cfg.$randFuncString)"

# Check for Debug Mode - if not set, Backup Files - else Pretend
if [ -n "$GEEX_DEBUG" ] || [ -n "$GEEX_DEBUG_MODE" ]; then
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
