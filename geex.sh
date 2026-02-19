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

dialog --clear

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
    (timezone "Europe/Berlin")
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
                                           "tty"
                                           "nixbld"))
                   (shell (file-append zsh "/bin/zsh"))) %base-user-accounts))

    ;; Packages
    (packages (append (map specification->package
                           '("eza" "bat"
                             "zoxide"
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
                             "kitty"))))

    ;; Services
    (services
     (append (list (service alsa-service-type)
                   (service gnome-desktop-service-type)
                   (service nix-service-type)
                   (simple-service 'doas-config etc-service-type
                                   (list `("doas.conf" ,(plain-file
                                                         "doas.conf"
                                                         "permit nopass keepenv root
permit persist keepenv setenv :wheel"))))
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
                                                      ;; Authorize via 'sudo guix archive --authorize < /etc/guix/files/keys/nonguix.pub'
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
        sed -i 's/GEEX_KEYBOARD_LAYOUT/"us"/g' /tmp/geex.config.${stager}.dd
    else
        echo "No '/tmp/geex.config.${stager}.dd' found..."
        export keyboardUsFeedback="[ Layout (US) ]: '/tmp/geex.config.${stager}.dd' absent."
    fi
}
setKeyboardColemak() {
    echo "Keyboard: English (Colemak)"
    if [ -f "/tmp/geex.config.${stager}.dd" ]; then
        sed -i 's/GEEX_KEYBOARD_LAYOUT/"us" "colemak"/g' /tmp/geex.config.${stager}.dd
    else
        echo "No '/tmp/geex.config.${stager}.dd' found..."
        export keyboardColemakFeedback="[ Layout (Colemak) ]: '/tmp/geex.config.${stager}.dd' absent."
    fi
}
setKeyboardDe() {
    echo "Keyboard: German (DE)"
    if [ -f "/tmp/geex.config.${stager}.dd" ]; then
        sed -i 's/GEEX_KEYBOARD_LAYOUT/"de"/g' /tmp/geex.config.${stager}.dd
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
            sudo mount ${diskPrefixed}1 /mnt
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
            sudo mount ${diskPrefixed}2 /mnt
            sudo mkdir -p /mnt/boot
            sudo mount ${diskPrefixed}1 /mnt/boot
            echo -e "\nFinished (U)EFI Formatting and Mounting\n"
            export formattedDisksStatus=1
        fi
    fi
}
customStage2() {
    echo "Entered Custom System Setup Stage 2"
}
filesystemHook() {
    if [ "$bios" == "uefi" ]; then
        export efiPartName=$(ls /dev/disk/by-label/ | grep -x -e 'guix-efi' -e 'GUIX-EFI')
        if [[ "$efiPartName" == "" ]]; then
            export efiPartName="guix-efi"
        fi
        export filesystemBlock="$(echo -e "    (file-systems (cons* (file-system\n                           (mount-point \"/\")\n                           (device (file-system-label \"guix-root\"))\n                           (type \"ext4\"))\n                         (file-system\n                           (mount-point \"/boot/efi\")\n                           (device (file-system-label \"$efiPartName\"))\n                           (type \"vfat\")) %base-file-systems))\n")"
    else
        export filesystemBlock="$(echo -e "    (file-systems (cons* (file-system\n                           (mount-point \"/\")\n                           (device (file-system-label \"guix-root\"))\n                           (type \"ext4\")) %base-file-systems))\n")"
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
        #sed -i "/GEEX_FILESYSTEM_OPTIONAL/r /tmp/geex.filesystem.block.dd" \
        #-e "/GEEX_FILESYSTEM_OPTIONAL/d" \
        #/tmp/geex.config.${stager}.dd
        #sed -i "s/GEEX_FILESYSTEM_OPTIONAL/$filesystemBlock/g" /tmp/geex.config.${stager}.dd
        export wroteFilesystemBlock=1
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
}
biosLegacyEditHook() {
    legacyBlock="$(echo -e "    (bootloader (bootloader-configuration\n              (keyboard-layout keyboard-layout)\n              (bootloader grub-bootloader)\n              (targets '(\"${diskPrefixed}1\"))))\n")"
    legacyBlockVerify=$(dialog --backtitle "Geex Installer" --title "Verify BIOS Block" --menu "$legacyBlock" 32 50 10 \
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
        #sed -i "/GEEX_BIOS_OPTIONAL/r /tmp/geex.bios.block.dd" \
        #-e "/GEEX_BIOS_OPTIONAL/d" \
        #/tmp/geex.config.${stager}.dd
        #sed -i "s/GEEX_BIOS_OPTIONAL/$legacyBlock/g" /tmp/geex.config.${stager}.dd
        successMessage=$(dialog --backtitle "Geex Installer" --title "Success" --menu "Successfully wrote BIOS hook into '/tmp/geex.config.${stager}.dd'." 32 50 10 \
                                continue "Continue" \
                                abort "Abort" \
                                3>&1 1>&2 2>&3) || exit 1
        if [ "$successMessage" == "abort" ]; then
            echo "[ Status ] Aborting..."
            exit 1
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
    uefiBlock="$(echo -e "    (bootloader (bootloader-configuration\n              (keyboard-layout keyboard-layout)\n              (bootloader grub-efi-bootloader)\n              (targets '(\"/boot/efi\"))))\n")"
    uefiBlockVerify=$(dialog --backtitle "Geex Installer" --title "Verify BIOS Block" --menu "$uefiBlock" 32 50 10 \
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
        #sed -i "/GEEX_BIOS_OPTIONAL/r /tmp/geex.bios.block.dd" \
        #-e "/GEEX_BIOS_OPTIONAL/d" \
        #/tmp/geex.config.${stager}.dd
        #sed -i "s/GEEX_BIOS_OPTIONAL/$uefiBlock/g" /tmp/geex.config.${stager}.dd
        successMessage=$(dialog --backtitle "Geex Installer" --title "Success" --menu "Successfully wrote BIOS hook into '/tmp/geex.config.${stager}.dd'." 32 50 10 \
                                continue "Continue" \
                                abort "Abort" \
                                3>&1 1>&2 2>&3) || exit 1
        if [ "$successMessage" == "abort" ]; then
            echo "[ Status ] Aborting..."
            exit 1
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
            herd start cow-store /mnt
            cp /tmp/geex.config.${stager}.dd /tmp/geex.config.${stager}.scm
            mkdir -p /mnt/etc/guix
            cp /tmp/geex.config.${stager}.scm /mnt/etc/guix/config.scm
            if [ -f "/mnt/etc/guix/config.scm" ]; then
                guix system init /mnt/etc/guix/config.scm /mnt
                export installationStatus=1
            elif [ -f "/tmp/geex.config.${stager}.scm" ]; then
                guix system init /tmp/geex.config.${stager}.scm /mnt
                export installationStatus=1
            else
                errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "The Installer encountered an error: neither the '/mnt/etc/guix/config.scm', nor the '/tmp/geex.config.${stager}.scm' files are present.\n\nThe Installer must have failed the copying process, please investigate.\n\nThe Installer cannot continue meaningfully, still proceed in the broken installation process?" 32 50 10 \
                                      continue "Yes, still Continue" \
                                      abort "Abort" \
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
passwordHook() {
    if [ -n "$GEEX_DEBUG" ] || [ -n "$GEEX_DEBUG_MODE" ]; then
        echo "[ Debug ]: Pretending to set passwords..."
    else
        echo "[ Status ]: Please enter 'root' password:"
        passwd -R /mnt root
        echo "[ Status ]: Please enter '$username' password:"
        passwd -R /mnt $username
    fi
}
homeHook() {
    homeQuestion=$(dialog --backtitle "Geex Installer" --title "Home Setup" --menu "The Geex Installer offers the option to copy the generic Geex GNU Guix Home Configuration (home.scm) to your newly installed System.\n\nDo you want to copy the Geex GNU Guix Home Configuration to your system?\n\n(You can edit the '/mnt/etc/guix/home.scm' before or after rebooting to make changes.)" 32 50 10 \
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
    else
        if [ "$homeQuestion" == "yes" ]; then
            if [ -f "/tmp/geex.home.scm" ]; then
                cp /tmp/geex.home.scm /mnt/etc/guix/home.scm
                export copiedHome=1
            elif command -v git >/dev/null; then
                mkdir -p /tmp/geex.git.storage
                git clone https://github.com/librepup/geex.git /tmp/geex.git.storage/geex
                cp /tmp/geex.git.storage/geex/home.scm /mnt/etc/guix/home.scm
                export copiedHome=1
            else
                export copiedHome=0
                errorMessage=$(dialog --backtitle "Geex Installer" --title "Error" --menu "The Installer encountered an error while trying to copy the Geex GNU Guix Home Configuration File(s):\n  Neither '/tmp/geex.home.scm', nor the 'git' command were present.\n\nSkipping Guix Home configuration hook." 32 50 10 \
                                      okay "Okay" \
                                      3>&1 1>&2 2>&3) || exit 1
            fi
            export systemFinished=1
        else
            export copiedHome=0
            export systemFinished=1
            notice=$(dialog --backtitle "Geex Installer" --title "Notice" --menu "You have aborted the copying of Geex GNU Guix Home Configuration Files, the Installer will continue on as if the home configuration hook were never called." 32 50 10 \
                            okay "Okay" \
                            3>&1 1>&2 2>&3) || exit 1
        fi
    fi
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
    if [ "$wroteBiosBlock" == 0 ]; then
        export wroteBiosBlock="No"
    else
        export wroteBiosBlock="Yes"
    fi
    filesystemHook
    summaryTextContents="$(echo -e "[!] Read Carefully [!]\n\nUsername: $username\nHostname: $hostname\nDisk: $disk (Part Format: ${diskPrefixed}1, ${diskPrefixed}2, ... )\nBIOS: $bios (Detected: $detectedBios)\nKeyboard: $keyboard\nSystemchoice: $systemchoice\nStager: $stager\nStagerfile: '/tmp/geex.config.${stager}.dd'\nWrote BIOS Block?: ${wroteBiosBlock}")"
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
    if [ "$installationStatus" == 1 ]; then
        success=$(dialog --backtitle "Geex Installer" --title "Success" --menu "The Installer successfully installed your GNU Guix System ($systemchoice) to '/mnt'. Please verify the installation process actually succeeded. The Installer will now continue on to the Password Setup phase, and then ask for your Guix Home preferences." 32 50 10 \
                         continue "Continue" \
                         abort "Abort" \
                         3>&1 1>&2 2>&3) || exit 1
        if [ "$success" == "abort" ]; then
            echo "[ Status ]: Aborting..."
            exit 1
        fi
        passwordHook
        homeHook
    else
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
        if [ -n "$GEEX_DEBUG" ] || [ -n "$GEEX_DEBUG_MODE" ]; then
            noticePopup=$(dialog --backtitle "Geex Installer" --title "Notice" --menu "Debug Mode has been detected by the Installer. Your installation has either failed, or been runningin Debug Mode the entire time.\n\nThe Installer will now continue with a mock installation success hook." 32 50 10 \
                                 okay "Okay" \
                                 abort "Abort" \
                                 3>&1 1>&2 2>&3) || exit 1
            if [ "$noticePopup" == "okay" ]; then
                passwordHook
                homeHook
                if [ "$formattedDisksStatus" == 1 ]; then
                    export formattedDisksStatus="Yes"
                elif [ "$formattedDisksStatus" == 2 ]; then
                    export formattedDisksStatus="Mock Yes"
                else
                    export formattedDisksStatus="No"
                fi
                if [ "$copiedHome" == 1 ]; then
                    export homeStatus="Yes"
                elif [ "$copiedHome" == 2 ]; then
                    export homeStatus="Mock Yes"
                else
                    export homeStatus="No"
                fi
                if [ "$systemFinished" == 1 ]; then
                    export finishedMessage="$(echo -e "Final Report\n============\nCopied Home?: $homeStatus\nInstallation Path: '/mnt'\nWrote BIOS Block?: $wroteBiosBlock\nFormatted Disks?: $formattedDisksStatus\n")"
                    finishedNotice=$(dialog --backtitle "Geex Installer" --title "Finalization" --menu "$finishedMessage" 32 50 10 \
                                            finish "Finish" \
                                            abort "Abort" \
                                            3>&1 1>&2 2>&3) || exit 1
                    if [ "$finishedNotice" == "abort" ]; then
                        echo "[ Status ]: Aborting..."
                        exit 1
                    else
                        dialog --clear
                        clear
                        echo -e "[ Status ]: Success! Geex (GNU Guix) was installed to your '$disk' Drive, and mounted at '/mnt'.\n[ Info ]: You may want to know about these useful Commands:\n - Rebuild System\n   - guix system reconfigure /etc/guix/config.scm\n - Rebuild Home\n   - guix home reconfigure /etc/guix/home.scm\n - Describe Generation\n   - guix describe\n - Pull Channels\n   - guix pull\n\nThank you for using Geex!"
                    fi
                else
                    export finishedMessage="$(echo -e "Final Report\n============\nCopied Home?: $homeStatus\nInstallation Path: '/mnt'\nWrote BIOS Block?: $wroteBiosBlock\nFormatted Disks?: $formattedDisksStatus\n")"
                    finishedNotice=$(dialog --backtitle "Geex Installer" --title "Finalization" --menu "$finishedMessage" 32 50 10 \
                                            finish "Finish" \
                                            abort "Abort" \
                                            3>&1 1>&2 2>&3) || exit 1
                    if [ "$finishedNotice" == "abort" ]; then
                        echo "[ Status ]: Aborting..."
                        exit 1
                    else
                        dialog --clear
                        clear
                        echo -e "[ Status ]: Success! Geex (GNU Guix) was installed to your '$disk' Drive, and mounted at '/mnt'.\n[ Info ]: You may want to know about these useful Commands:\n - Rebuild System\n   - guix system reconfigure /etc/guix/config.scm\n - Rebuild Home\n   - guix home reconfigure /etc/guix/home.scm\n - Describe Generation\n   - guix describe\n - Pull Channels\n   - guix pull\n\nThank you for using Geex!"
                    fi
                fi
            else
                echo "[ Status ]: Aborting..."
                exit 1
                fi
            fi

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
