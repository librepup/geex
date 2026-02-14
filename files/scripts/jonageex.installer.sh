#!/usr/bin/env -S guix shell dialog -- sh

set -euo pipefail

dialog --clear

cleanup() {
    clear
}
trap cleanup EXIT

if [ -f "/tmp/dialogrc.jonageex.installer" ]; then
    rm /tmp/dialogrc.jonageex.installer
fi

if [ -f "/tmp/config.jonageex.scm" ]; then
    rm /tmp/config.jonageex.scm
fi

if [ -f "/tmp/channels.jonageex.scm" ]; then
    rm /tmp/channels.jonageex.scm
fi

cat > /tmp/home.jonageex.scm <<'EOF'
(use-modules (gnu)
             (gnu home)
             (gnu home services)
             (gnu home services shells)
             (gnu home services sound)
             (gnu home services admin)
             (gnu home services desktop)
             (gnu services)
             (gnu packages)
             (gnu packages shellutils)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (gnu packages xorg)
             (gnu packages certs)
             (gnu packages shells)
             (gnu packages admin)
             (gnu packages base)
             (guix)
             (guix utils)
             (guix packages)
             (guix gexp)
             (guix git-download)
             (guix build utils)
             (ice-9 ftw)
             (ice-9 rdelim)
             (guix build-system emacs)
             (jonabron packages emacs)
             (jonabron packages fonts)
             (jonabron packages communication)
             (jonabron packages games)
             (jonabron packages wm)
             (nongnu packages video)
             (nongnu packages game-client)
             (emacs packages melpa))

(define zsh (specification->package "zsh"))
(define zsh-autosuggestions (specification->package "zsh-autosuggestions"))

(home-environment
 (packages (specifications->packages
           (list "git"
                 ; Desktop Applications
                 "discord"
                 "element-desktop"
                 "osu-lazer-bin"
                 "vicinae"
                 "naitre"
                 "icecat"
                 "icedove"
                 "icedove-wayland"
                 "firefox"
                 "librewolf"
                 "torbrowser"
                 "feh"
                 "zathura"
                 "krita"
                 "thunar"
                  ;"mpv"
                 "mpv-nvidia"
                 "steam-nvidia"
                 "protonup"
                 ; ZSH
                 "zsh"
                 "zsh-autosuggestions"
                 "zsh-syntax-highlighting"
                 ; Emacs
                 ;"emacs" ; X11 Emacs
                 "emacs-pgtk" ; Wayland Emacs
                 "emacs-fancy-dabbrev" ; From Jonabron Channel
                 "emacs-hoon-mode" ; From Jonabron Channel
                 "emacs-emms"
                 "emacs-impatient-mode"
                 "emacs-vim-tab-bar" ; From Emacs Channel
                 "emacs-erc"
                 "emacs-erc-image"
                 "emacs-company"
                 "emacs-corfu-terminal"
                 "emacs-guix"
                 "emacs-simple-httpd"
                 "emacs-org"
                 "emacs-pabbrev"
                 "emacs-use-package"
                 "emacs-lsp-mode"
                 "emacs-lsp-ui"
                 "emacs-markdown-mode"
                 "emacs-multi-term"
                 "emacs-multiple-cursors"
                 "emacs-nix-mode"
                 "emacs-rainbow-mode"
                 "emacs-wttrin"
                 "emacs-hydra"
                 "emacs-major-mode-hydra"
                 "emacs-all-the-icons"
                 "emacs-all-the-icons-dired"
                 "emacs-haskell-mode"
                 "emacs-arduino-mode"
                 "emacs-flycheck"
                 "emacs-bongo"
                 "emacs-compat"
                 "emacs-xelb"
                 "emacs-iedit"
                 "emacs-anzu"
                 "emacs-visual-regexp"
                 "emacs-sudo-edit"
                 "emacs-pdf-tools"
                 "emacs-magit"
                 "emacs-beacon"
                 "emacs-doom-modeline"
                 "emacs-org-texlive-collection"
                 ; Tools
                 "xinput"
                 "jami"
                 "gsettings-desktop-schemas"
                 "setxkbmap"
                 "dmenu"
                 "keepassxc"
                 "eza"
                 "bat"
                 "zoxide"
                 "ripgrep"
                 "grep"
                 "libnotify"
                 "gnucash"
                 "rofi"
                 "xset"
                 "coreutils"
                 "glibc-locales"
                 "ncurses"
                 "nix"
                 "nixfmt"
                 "opendoas"
                 "xmonad"
                 "fzf"
                 "guile"
                 "ghc-xmonad-contrib"
                 "gammastep"
                 "pipewire"
                 "wireplumber"
                 "flatpak"
                 "polybar"
                 "btop"
                 "wpa-supplicant"
                 "curl"
                 "nss-certs"
                 "guix-backgrounds"
                 "dunst"
                 "texlive-scheme-full"
                 "rsync"
                 "bottom"
                 "redshift"
                 "flameshot"
                 "mpvpaper"
                 "dmidecode"
                 "sway-audio-idle-inhibit"
                 "imv"
                 "cmus"
                 "alsa-utils"
                 "pavucontrol"
                 "pulseaudio"
                 "pulsemixer"
                 "pciutils"
                 "fd"
                 "imagemagick"
                 "yt-dlp"
                 "wl-clipboard"
                 "dank-material-shell"
                 "grim"
                 "grimblast"
                 "unrar-free"
                 "unzip"
                 "7zip"
                 "openssl"
                 "tumbler"
                 "dbus"
                 "ntfs-3g"
                 "cryptsetup"
                 "testdisk"
                 "encfs"
                 "usbutils"
                 "pamixer"
                 "node"
                 "gcc-toolchain"
                 "wf-recorder"
                 "swaybg"
                 "waybar"
                 "swayidle"
                 "hyprlock"
                 "wlsunset"
                 "wofi"
                 "wtype"
                 "mako"
                 "xwayland-satellite"
                 "xwayland-run"
                 "slurp"
                 "grimshot"
                 "hyprpicker"
                 "cliphist"
                 "fuzzel"
                 "xdg-desktop-portal"
                 "xdg-desktop-portal-wlr"
                 "progress"
                 "gnunet"
                 ; Fonts
                 "font-jonafonts"
                 "font-dejavu"
                 "font-google-noto-emoji"
                 ; Terminal
                 "kitty"
                 ; Fetchers
                 "hyfetch"
                 "neofetch"
                 "fastfetch"
                 "pfetch"
                 "ufetch"
                 )))

 (services (list
            ;;; PipeWire
            (service home-dbus-service-type)
            (service home-pipewire-service-type
                     (home-pipewire-configuration
                      (enable-pulseaudio? #t)))
            ;;; ZSH Configuration
            (service home-zsh-service-type
                     (home-zsh-configuration
                      (environment-variables '(("PS1" . "  %~ ")
                                               ("PROMPT" . "  %~ ")
                                               ("TERMINFO_DIRS" . "$HOME/.guix-home/profile/share/terminfo")
                                               ("TERM" . "kitty")
                                               ;("TERM" . "xterm-256color")
                                               ("LANG" . "en_US.UTF-8")
                                               ("LC_CTYPE" . "en_US.UTF-8")
                                               ("LC_ALL" . "en_US.UTF-8")
                                               ("GUIX_LOCPATH" . "$HOME/.guix-home/profile/lib/locale:$HOME/.guix-profile/lib/locale:/guix/current/lib/locale")
                                               ("EDITOR" . "emacs")))
                      (zshrc
                       (list
                        (local-file "files/config/zshrc")
                      ))))

                 ;;; Environment Variables
                 (simple-service 'environment-variables-config
                                 home-environment-variables-service-type
                                 `(("PAGER" . "LESS")
                                   ("TERMINAL" . "kitty")
                                   ("EDITOR" . "emacs")
                                   ("VISUAL" . "emacs")
                                   ("WAYLAND_DISPLAY" . "wayland-0")
                                   ("SDL_VIDEODRIVER" . "wayland")
                                   ("ELECTRON_OZONE_PLATFORM_HINT" . "wayland")
                                   ("MOZ_ENABLE_WAYLAND" . "1")
                                   ("GBM_BACKEND" . "nvidia-drm")
                                   ("__GLX_VENDOR_LIBRARY_NAME" . "nvidia")
                                   ("DISPLAY" . ":0")
                                   ("XDG_CURRENT_DESKTOP" . "naitre")
                                   ("XDG_SESSION_TYPE" . "wayland")
                                   ("XDG_SESSION_DESKTOP" . "naitre")
                                   ("QT_QPA_PLATFORM" . "wayland")
                                   ("QT_QPA_PLATFORMTHEME" . "qt5ct")
                                   ("QT_WAYLAND_DISABLE_WINDOWDECORATION" . "1")
                                   ("NIXOS_OZONE_WL" . "1")
                                   ("OZONE_PLATFORM" . "wayland")
                                   ("GDK_BACKEND" . "wayland")
                                   ("WINDOW_MANAGER" . "naitre")
                                   ("DESKTOP_SESSION" . "naitre")
                                   ("GSK_RENDERER" . "gl")
                                   ("SHELL" . ,(file-append zsh "/bin/zsh"))
                                   ("LESSHISTFILE" . "$XDG_CACHE_HOME/.lesshst")))

                 ;;; Dotfile Guix Home Setup, Symlinked as well as Mutable (~/.config/naitre/main.conf)
                 ; Before:
                 ;  `((".config/directory" ,(local-file (string-append (current-source-directory) "/files/config/directory" #:recursive? #t))))
                 ; ... but (current-source-directory) was removed, as it is unnecessary (according to ChatGPT), and could cause breakage.
                 (simple-service 'mpv-config
                                 home-files-service-type
                                 `((".config/mpv" ,(local-file "files/config/mpv" #:recursive? #t))))
                 (simple-service 'dot-emacs-config
                                 home-files-service-type
                                 `((".emacs" ,(local-file "files/config/guixmacs/emacs"))))
                 (simple-service 'guixmacs-themes-config
                                 home-files-service-type
                                 `((".guixmacs/themes" ,(local-file "files/config/guixmacs/themes" #:recursive? #t))))
                 (simple-service 'guixmacs-logo-config
                                 home-files-service-type
                                 `((".guixmacs/files" ,(local-file "files/config/guixmacs/files" #:recursive? #t))))
                 (simple-service 'guixmacs-config
                                 home-files-service-type
                                 `((".guixmacs/config" ,(local-file "files/config/guixmacs/config" #:recursive? #t))))
                 (simple-service 'discord-config
                                 home-files-service-type
                                 `((".config/vesktop" ,(local-file "files/config/discord" #:recursive? #t))))
		 (simple-service 'dunst-config
				 home-files-service-type
				 `((".config/dunst" ,(local-file "files/config/dunst" #:recursive? #t))))
                 (simple-service 'fastfetch-config
                                 home-files-service-type
                                 `((".config/fastfetch" ,(local-file "files/config/fastfetch" #:recursive? #t))))
                 (simple-service 'hyprlock-config
                                 home-files-service-type
                                 `((".config/hyprlock" ,(local-file "files/config/hyprlock" #:recursive? #t))))
                 (simple-service 'kitty-config
                                 home-files-service-type
                                 `((".config/kitty" ,(local-file "files/config/kitty" #:recursive? #t))))
                 (simple-service 'waybar-config
                                 home-files-service-type
                                 `((".config/waybar" ,(local-file "files/config/waybar" #:recursive? #t))))
                 (simple-service 'zathura-config
                                 home-files-service-type
                                 `((".config/zathura" ,(local-file "files/config/zathura" #:recursive? #t))))
                 (simple-service 'btop-config
                                 home-files-service-type
                                 `((".config/btop" ,(local-file "files/config/btop" #:recursive? #t))))
		 (simple-service 'polybar-config
				 home-files-service-type
				 `((".config/polybar" ,(local-file "files/config/polybar" #:recursive? #t))))
                 (simple-service 'scripts-config
                                 home-files-service-type
                                 `((".scripts" ,(local-file "files/scripts" #:recursive? #t))))
                 (simple-service 'wallpapers-config
                                 home-files-service-type
                                 `(("Pictures/Wallpapers" ,(local-file "files/pictures/Wallpapers" #:recursive? #t))))
                 (simple-service 'icons-config
                                 home-files-service-type
                                 `(("Pictures/Icons" ,(local-file "files/pictures/Icons" #:recursive? #t))))
                 (simple-service 'stallman-config
                                 home-files-service-type
                                 `(("Pictures/Stallman" ,(local-file "files/pictures/Stallman" #:recursive? #t))))
                 (simple-service 'naitre-config
                                 home-files-service-type
                                 `((".config/naitre" ,(local-file "files/config/naitre" #:recursive? #t))))
                 ))
 )
EOF

cat > /tmp/channels.jonageex.scm <<'EOF'
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

cat > /tmp/config.jonageex.scm <<'EOF'
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
             JONAGEEX_NIX_SERVICE
             (gnu services sound)
             (gnu services audio)
             (gnu services networking)
             (gnu services virtualization)
             (guix)
             (guix utils)
             ; Nongnu & Nonguix
             (nongnu packages linux)
             (nongnu system linux-initrd)
             JONAGEEX_NVIDIA_OPTIONALS
             ; Jonabron
             (jonabron packages wm)
             (jonabron packages fonts)
             (jonabron packages games)
             (jonabron packages communication))

(use-service-modules desktop sound audio networking ssh xorg dbus)
(use-package-modules wm bootloaders certs shells version-control xorg)

JONAGEEX_OS_INTRO_BLOCK
 (kernel linux)
 (initrd microcode-initrd)
 (firmware (append (list intel-microcode linux-firmware) %base-firmware))
 (host-name "JONAGEEX_HOSTNAME")
 (timezone "Europe/Berlin")
 (locale "en_US.utf8")
 (keyboard-layout (keyboard-layout JONAGEEX_KEYBOARD_LAYOUT))

 (users (cons (user-account
               (name "JONAGEEX_USERNAME")
               (comment "JONAGEEX_USERNAME")
               (group "users")
               (home-directory "/home/JONAGEEX_USERNAME")
               (supplementary-groups '(JONAGEEX_SUPP_GROUPS))
               (shell (file-append zsh "/bin/zsh")))
              %base-user-accounts))

JONAGEEX_BOOTLOADER_BLOCK

 (packages (append
            (map specification->package
                '("eza"
                  "bat"
                  "zoxide"
                  "ripgrep"
                  "grep"
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
                  "naitre"
                  "xmonad"
                  "ghc-xmonad-contrib"
                  "procps"
                  "wget"
                  "curl"
                  "nss-certs"
                  "bash"
                  "sed"
                  )
                )
            ))

 (services
  (append
   (list
    JONAGEEX_HURD_OPTIONAL
    (service gnome-desktop-service-type)
    JONAGEEX_NIX_OPTIONAL
    JONAGEEX_DOAS_OPTIONAL
    (set-xorg-configuration
     (xorg-configuration
      (keyboard-layout keyboard-layout)
      JONAGEEX_NVIDIA_XORG
   )))

   (modify-services %desktop-services
                    JONAGEEX_WAYLAND_OPTIONAL
                    ;(delete pulseaudio-service-type)
                    (guix-service-type config =>
                                       (guix-configuration
                                        (inherit config)
                                        (substitute-urls
                                         (append (list "https://ci.guix.gnu.org"
                                               "https://berlin.guix.gnu.org"
                                               "https://bordeaux.guix.gnu.org"
                                               "https://substitutes.nonguix.org"
                                               "https://hydra-guix-129.guix.gnu.org"
                                               "https://substitutes.guix.gofranz.com")
                                                 %default-substitute-urls))
                                        ; Authorize via 'sudo guix archive --authorize < /etc/guix/channels/nonguix.pub'
                                        (authorized-keys
                                         (append (list (local-file "/etc/guix/files/keys/nonguix.pub"))
                                                 %default-authorized-guix-keys))
                                        ))
                    (mingetty-service-type config =>
                                           (mingetty-configuration
                                            (inherit config)
                                            (auto-login "JONAGEEX_USERNAME")))
                    )
   ))
 )


JONAGEEX_OS_EXIT_BLOCK
EOF

JONAGEEX_NIX_SERVICE_BLOCK="(gnu services nix)"
JONAGEEX_NIX_BLOCK="    (service nix-service-type)\n"
JONAGEEX_HURD_BLOCK="    (service hurd-vm-service-type\n	     (hurd-vm-configuration\n	      (memory-size 2048)\n	      (secret-directory \"/etc/guix/hurd-secrets\")))\n"
JONAGEEX_DOAS_BLOCK="    (simple-service 'doas-config etc-service-type\n                    (list\n                     \`(\"doas.conf\" ,(plain-file \"doas.conf\"\n\"permit nopass keepenv root\npermit persist keepenv setenv :wheel\"))))\n"
JONAGEEX_NVIDIA_XORG="   (modules (cons nvidia-driver %default-xorg-modules))\n      (drivers '(\"nvidia\"))\n"
JONAGEEX_WAYLAND_OPTIONAL="                    (gdm-service-type config =>\n                                      (gdm-configuration\n                                       (inherit config)\n                                       (wayland? #t)))\n"
JONAGEEX_SUPP_GROUPS_NIX="\"wheel\" \"netdev\" \"audio\" \"video\" \"input\" \"tty\" \"nixbld\""
JONAGEEX_SUPP_GROUPS_REGULAR="\"wheel\" \"netdev\" \"audio\" \"video\" \"input\" \"tty\""
OS_INTRO_BLOCK="(define %guix-os (operating-system"
NVIDIA_OS_EXIT_BLOCK=")\n\n((compose (nonguix-transformation-nvidia))\n %guix-os)"
NVIDIA_MODULES="(nongnu packages nvidia)\n             (nongnu services nvidia)\n             (nonguix transformations)"
OS_EXIT_BLOCK=")\n\n%guix-os"

cat > /tmp/dialogrc.jonageex.installer <<'EOF'
use_colors = ON
use_shadow = ON
screen_color = (WHITE,BLACK,ON)
dialog_color = (BLACK,WHITE,ON)
title_color = (BLACK,WHITE,ON)
border_color = (BLACK,WHITE,ON)
button_active_color = (BLACK,WHITE,ON)
button_inactive_color = (WHITE,WHITE,ON)
button_key_active_color = (BLACK,WHITE,ON)
button_key_inactive_color = (BLACK,BLACK,ON)
item_color = (BLACK,WHITE,ON)
item_selected_color = (BLACK,WHITE,ON)
tag_color = (BLACK,WHITE,ON)
inputbox_color = (BLACK,WHITE,ON)
inputbox_border_color = (WHITE,BLACK,ON)
gauge_color = (BLACK,WHITE,ON)
menubox_color = (BLACK,WHITE,ON)
menubox_border_color = (BLACK,WHITE,ON)
EOF

export DIALOGRC=/tmp/dialogrc.jonageex.installer

welcome=$(dialog --backtitle "Jonageex Installer" --title "Welcome" --menu "\nThis installer is in a state of pre-alpha, meaning it *can* cause issues. If you encounter any problems, please continue with a manual installation of Jonageex.\n\nA guide for manual installation of the Jonageex Configuration Suite and Distribution is provided to you at '/etc/jonageex.manual.org'.\n\nDo you accept?" 30 60 20 \
                 yes "Yes, I accept." \
                 no "No, I don't accept." \
                 3>&1 1>&2 2>&3) || exit 1

if [ "$welcome" == "no" ]; then
    echo "Aborting Installation..."
    exit
fi

username=$(dialog --backtitle "Jonageex Installer" --title "Username" --inputbox "What is your Username?" 8 40 \
              3>&1 1>&2 2>&3) || exit 1

hostname=$(dialog --backtitle "Jonageex Installer" --title "Hostname" --inputbox "What Name should your Machine have?" 8 40 \
        3>&1 1>&2 2>&3) || exit 1

nvidia=$(dialog --backtitle "Jonageex Installer" --title "Nvidia" --menu "Do you need Nvidia Drivers?" 12 40 5 \
                yes "Yes" \
                no "No" \
             3>&1 1>&2 2>&3) || exit 1

keyboardlayout=$(dialog --backtitle "Jonageex Installer" --title "Keyboard Layout" --menu "Select Keyboard Layout:" 12 40 5 \
                        us "English (US)" \
                        colemak "Colemak" \
                        de "German (DE)" \
                        3>&1 1>&2 2>&3) || exit 1

disk=$(dialog --backtitle "Jonageex Installer" --title "Disks" --inputbox "Please enter your Disks Name (e.g. /dev/sda, /dev/sdc, /dev/nvme0n1):" 8 40 \
              3>&1 1>&2 2>&3) || exit 1

if [[ "$disk" == /dev/nvme* ]]; then
    diskPrefixed="${disk}p"
else
    diskPrefixed="$disk"
fi

if [[ -d /sys/firmware/efi ]]; then
    IS_UEFI=true
    export IS_UEFI
    bios=$(dialog --backtitle "Jonageex Installer" --title "BIOS Boot Type" --menu "Do you use (U)EFI or Legacy Bios?\n\nINFO: Our BIOS Auto-Detection Script detected that you ARE using (U)EFI, you may want to select '(U)EFI' in this menu." 22 40 5 \
                  uefi "(U)EFI" \
                  legacy "Legacy" \
        3>&1 1>&2 2>&3) || exit 1
else
    IS_UEFI=false
    export IS_UEFI
    bios=$(dialog --backtitle "Jonageex Installer" --title "BIOS Boot Type" --menu "Do you use (U)EFI or Legacy Bios?\n\nINFO: Our BIOS Auto-Detection Script detected that you are using LEGACY, you may want to select 'Legacy' in this menu." 22 40 5 \
                  uefi "(U)EFI" \
                  legacy "Legacy" \
        3>&1 1>&2 2>&3) || exit 1
fi

warning=$(dialog --backtitle "Jonageex Installer" --title "Verification" --menu "Please verify that all the entered values are CORRECT! Once the installation procedure begins, YOU CANNOT REVERSE THIS PROCESS ANYMORE!" 12 40 5 \
       continue "Continue" \
       abort "Abort" \
       3>&1 1>&2 2>&3) || exit 1

optionalServices=$(dialog --checklist "Optional Services" 15 50 5 \
                          hurd "GNU Hurd" off \
                          doas "doas" on \
                          wayland "Wayland" on \
                          nix "Nix" off \
                          3>&1 1>&2 2>&3) || exit 1

read -r -a optionalServicesArray <<< "$optionalServices"
optionalServicesCount="${#optionalServicesArray[@]}"
optionalServicesSummaryText=$(printf '%s\n' "${optionalServicesArray[@]}")

legacyFormatting() {
    echo "sudo parted $disk --script \\"
    echo "mklabel msdos \\"
    echo "mkpart primary ext4 1MiB 100% \\"
    echo -e "set 1 boot on\n"
    echo -e "sudo mkfs.ext4 ${diskPrefixed}1\n"
    echo "sudo mount ${diskPrefixed}1 /mnt"
}

uefiFormatting() {
    echo "sudo parted $disk --script \\"
    echo "mklabel gpt \\"
    echo "mkpart ESP fat32 1MiB 2048MiB \\"
    echo "set 1 esp on \\"
    echo -e "mkpart primary ext4 2048MiB 100%\n"
    echo "sudo mkfs.fat -F32 ${diskPrefixed}1"
    echo -e "sudo mkfs.ext4 ${diskPrefixed}2\n"
    echo "sudo mount ${diskPrefixed}2 /mnt"
    echo "sudo mkdir -p /mnt/boot"
    echo "sudo mount ${diskPrefixed}1 /mnt/boot"
}

configUsername() {
    sed -i "s|JONAGEEX_USERNAME|$username|g" /tmp/config.jonageex.scm
}

configNvidia() {
    sed -i "s|JONAGEEX_NVIDIA_OPTIONALS|$NVIDIA_MODULES|g" /tmp/config.jonageex.scm
}

configOSIntroBlock() {
    sed -i "s|JONAGEEX_OS_INTRO_BLOCK|$OS_INTRO_BLOCK|g" /tmp/config.jonageex.scm
}

configOSExitBlock() {
    sed -i "s|JONAGEEX_OS_EXIT_BLOCK|$OS_EXIT_BLOCK|g" /tmp/config.jonageex.scm
}

configNvidiaOSExitBlock() {
    sed -i "s|JONAGEEX_OS_EXIT_BLOCK|$NVIDIA_OS_EXIT_BLOCK|g" /tmp/config.jonageex.scm
}

configKeyboardLayout() {
    if [[ "$keyboardlayout" == "colemak" ]]; then
        sed -i "s|JONAGEEX_KEYBOARD_LAYOUT|\"us\" \"$keyboardlayout\"|g" /tmp/config.jonageex.scm
    else
        sed -i "s|JONAGEEX_KEYBOARD_LAYOUT|\"$keyboardlayout\"|g" /tmp/config.jonageex.scm
    fi
}

configBootloaderBlock() {
    if [[ "$bios" == "uefi" ]]; then
        sed -i "s|JONAGEEX_BOOTLOADER_BLOCK|$BOOTLOADER_UEFI_BLOCK|" /tmp/config.jonageex.scm
    else
        sed -i "s|JONAGEEX_BOOTLOADER_BLOCK|$BOOTLOADER_LEGACY_BLOCK|" /tmp/config.jonageex.scm
    fi
}

configSuppGroups() {
    if [[ "$optionalServices" == *nix* ]]; then
        sed -i "s|JONAGEEX_SUPP_GROUPS|$JONAGEEX_SUPP_GROUPS_NIX|g" /tmp/config.jonageex.scm
    else
        sed -i "s|JONAGEEX_SUPP_GROUPS|$JONAGEEX_SUPP_GROUPS_REGULAR|g" /tmp/config.jonageex.scm
    fi
}

configWaylandOptional() {
    if [[ "$optionalServices" == *wayland* ]]; then
        sed -i "s|JONAGEEX_WAYLAND_OPTIONAL|$JONAGEEX_WAYLAND_OPTIONAL|g" /tmp/config.jonageex.scm
    else
        sed -i "s/JONAGEEX_WAYLAND_OPTIONAL//g" /tmp/config.jonageex.scm
    fi
}

configNvidiaXorg() {
    sed -i "s|JONAGEEX_NVIDIA_XORG|$JONAGEEX_NVIDIA_XORG|g" /tmp/config.jonageex.scm
}

configDoas() {
    sed -i "s|JONAGEEX_DOAS_OPTIONAL|$JONAGEEX_DOAS_BLOCK|g" /tmp/config.jonageex.scm
}

configHurd() {
    if [[ "$optionalServices" == *hurd* ]]; then
        sed -i "s|JONAGEEX_HURD_OPTIONAL|$JONAGEEX_HURD_BLOCK|g" /tmp/config.jonageex.scm
    else
        sed -i "s/JONAGEEX_HURD_OPTIONAL//" /tmp/config.jonageex.scm
    fi
}

configNix() {
    if [[ "$optionalServices" == *nix* ]]; then
        sed -i "s|JONAGEEX_NIX_OPTIONAL|$JONAGEEX_NIX_BLOCK|g" /tmp/config.jonageex.scm
    else
        sed -i "s/JONAGEEX_NIX_OPTIONAL//g" /tmp/config.jonageex.scm
    fi
    if [[ "$optionalServices" == *nix* ]]; then
        sed -i "s|JONAGEEX_NIX_SERVICE|$JONAGEEX_NIX_SERVICE_BLOCK|g" /tmp/config.jonageex.scm
    else
        sed -i "s/JONAGEEX_NIX_SERVICE//" /tmp/config.jonageex.scm
    fi
}

beginConfiguration() {
    configUsername
    if [[ "$nvidia" == "yes" ]]; then
        configNvidia
    else
        sed -i "s/JONAGEEX_NVIDIA_OPTIONALS//g" /tmp/config.jonageex.scm
    fi
    configOSIntroBlock
    if [[ "$nvidia" == "yes" ]]; then
        configNvidiaOSExitBlock
    else
        configOSExitBlock
    fi
    sed -i "s/JONAGEEX_HOSTNAME/$hostname/g" /tmp/config.jonageex.scm
    configKeyboardLayout
    configBootloaderBlock
    configSuppGroups
    configWaylandOptional
    if [[ "$nvidia" == "yes" ]]; then
        configNvidiaXorg
    else
        sed -i "s/JONAGEEX_NVIDIA_XORG//g" /tmp/config.jonageex.scm
    fi
    if [[ "$optionalServices" == *doas* ]]; then
        configDoas
    else
        sed -i "s/JONAGEEX_DOAS_OPTIONAL//g" /tmp/config.jonageex.scm
    fi
    configHurd
    configNix
}

passwordSetup() {
    echo "Please enter your desired 'root' Password:"
    echo "sudo passwd -R /mnt root"
    echo "Now enter your desired Password for the '$username' User:"
    echo "sudo passwd -R /mnt $username"
}

setupGuixHome() {
    echo "mkdir -p /tmp/jonageexWorker"
    echo "cd /tmp/jonageexWorker"
    echo "git clone https://github.com/librepup/geex.git"
    echo "mkdir -p /mnt/etc/guix"
    echo "cp -r /tmp/jonageexWorker/geex/* /mnt/etc/guix/"
    echo "mv /mnt/etc/guix/config.scm /mnt/etc/guix/geex.config.scm"
    echo "cp /tmp/config.jonageex.scm /mnt/etc/guix/config.scm"
    echo "Successfully copied librepup's Geex Configuration Files while preserving the 'config.scm' you just created."
    echo "After finishing the installation process and booting into your new Guix machine, make sure to run 'guix home /etc/guix/home.scm'."
}

beginInstallation() {
    clear
    echo "Pulling Channels from /tmp/channels.jonageex.scm..."
    echo "guix pull --channels=/tmp/channels.jonageex.scm"
    echo "Prepairing Installation..."
    if [[ "$bios" == "legacy" ]]; then
        echo "Formatting $disk as $bios..."
        legacyFormatting
    else
        echo "Formatting $disk as $bios..."
        uefiFormatting
    fi
    passwordSetup
    setupGuixHome
}

BOOTLOADER_UEFI_BLOCK=" (bootloader (bootloader-configuration\n              (keyboard-layout keyboard-layout)\n              (bootloader grub-efi-bootloader)\n              (targets '(\"/boot/efi\"))))\n"
BOOTLOADER_LEGACY_BLOCK=" (bootloader (bootloader-configuration\n              (keyboard-layout keyboard-layout)\n              (bootloader grub-bootloader)\n              (targets '(\"${diskPrefixed}1\"))))\n"

finalConfirmation() {
  userHasConfirmed=$(dialog --backtitle "Jonageex Installer" --title "Begin Installation?" --inputbox "Type 'yes, i confirm' to begin installation." 8 40 \
                            3>&1 1>&2 2>&3) || exit 1
  if [[ "$userHasConfirmed" == "yes, i confirm" ]]; then
      beginInstallation
  else
      echo "Aborting Installation..."
      exit
  fi
}

if [ "$warning" == "continue" ]; then
    dialog --backtitle "Jonageex Installer" --title "Summary" --msgbox "Summary:\n\nUsername: $username\nHostname: $hostname\nNvidia: $nvidia\nKeyboard: $keyboardlayout\nDisk: $disk\nBIOS: $bios\nOpt. Services: $optionalServicesSummaryText" 24 40
    beginConfiguration
    dialog --backtitle "Jonageex Installer" --title "Finalization | READ CAREFULLY\!" --textbox "/tmp/config.jonageex.scm" 22 75
    finalConfirmation
else
    echo "[ Aborted Installation ]"
    exit
fi
