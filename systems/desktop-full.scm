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
             (guix packages)
             (guix gexp)
             (ice-9 ftw)
             (ice-9 rdelim)
             (srfi srfi-1)
             (guix git-download)
             (guix build utils)
             (guix build-system emacs)
             ;; Nongnu & Nonguix
             (nongnu packages linux)
             (nongnu packages nvidia)
             (nongnu services nvidia)
             (nongnu system linux-initrd)
             (nonguix transformations)
             ;; Emacs
             (emacs packages melpa)
             ;; Jonabron
             (jonabron packages wm)
             (jonabron packages fonts)
             (jonabron packages ai)
             (jonabron packages shells)
             (jonabron packages entertainment)
             (jonabron packages terminals)
             (jonabron packages emacs)
             (jonabron packages games)
             (jonabron packages communication))

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

;; Definitions
(define zsh
  (specification->package "zsh"))
(define zsh-autosuggestions
  (specification->package "zsh-autosuggestions"))
(define bash
  (specification->package "bash"))

;; Operating System
(define %guix-os
  (operating-system
    (kernel linux)
    (initrd microcode-initrd)
    (firmware (append (list intel-microcode linux-firmware) %base-firmware))
    (host-name "guix")
    (timezone "Europe/Berlin")
    (locale "en_US.utf8")
    (keyboard-layout (keyboard-layout "us" "colemak"))

    ;; Bootloader
    (bootloader (bootloader-configuration
                  (keyboard-layout keyboard-layout)
                  (bootloader grub-efi-bootloader)
                  (targets '("/boot/efi"))))

    ;; File Systems
    (file-systems (cons* (file-system
                           (mount-point "/")
                           (device (file-system-label "guix-root"))
                           (type "ext4"))
                         (file-system
                           (mount-point "/boot/efi")
                           (device (file-system-label "guix-efi"))
                           (type "vfat")) %base-file-systems))

    ;; Swap
    (swap-devices (list
                   (swap-space
                    (target (file-system-label "guix-swap")))))

    ;; Users
    (users (cons* (user-account
                   (name "puppy")
                   (comment "Puppy")
                   (group "users")
                   (home-directory "/home/puppy")
                   (supplementary-groups '("wheel"
                                           "netdev"
                                           "audio"
                                           "video"
                                           "input"
                                           "tty"
                                           "nixbld"))
                   (shell (file-append zsh "/bin/zsh")))
                  (user-account
                   (name "labrat")
                   (comment "Labrat User")
                   (group "users")
                   (supplementary-groups '("wheel"
                                           "netdev"
                                           "audio"
                                           "video"
                                           "input"
                                           "tty"
                                           "nixbld"))
                   (shell (file-append bash "/bin/bash")))
                  %base-user-accounts))

    ;; Packages
    (packages (append (map specification->package
                           '("eza"
                             "bat"
                             "zoxide"
                             "opendoas"
                             "naitre"
                             "vicinae"
                             "wofi"
                             "waybar"
                             "dank-material-shell"
                             "swaybg"
                             "wl-clipboard"
                             "ripgrep"
                             "grep"
                             "xset"
                             "coreutils"
                             "util-linux"
                             "file"
                             "qemu"
                             "virt-manager"
                             "glibc-locales"
                             "ncurses"
                             "zsh"
                             "zsh-autosuggestions"
                             "zsh-syntax-highlighting"
                             "git-minimal"
                             "xinput"
                             "xmodmap"
                             "gsettings-desktop-schemas"
                             "setxkbmap"
                             "dmenu"
                             "libnotify"
                             "emacs-pgtk"
                             "usbutils"
                             "pciutils"
                             "wpa-supplicant"
                             "isc-dhcp"
                             "network-manager"
                             "dhcpcd"
                             "procps"
                             "wget"
                             "curl"
                             "bash"
                             "sed"
                             "font-jonafonts"
                             "font-dejavu"
                             "font-google-noto-emoji"
                             "font-bitstream-vera"
                             "unrar-free"
                             "unzip"
                             "7zip"
                             "nix"
                             "fzf"
                             "rsync"
                             "redshift"
                             "flameshot"
                             "grim"
                             "grimblast"
                             "openssl"
                             "tumbler"
                             "dbus"
                             "dmidecode"
                             "alsa-utils"
                             "pavucontrol"
                             "pamixer"
                             "pulseaudio"
                             "pulsemixer"
                             "imagemagick"
                             "swayidle"
                             "wlsunset"
                             "xwayland-satellite"
                             "xwayland-run"
                             "cliphist"
                             "wlr-randr"
                             "xdg-desktop-portal-wlr"
                             "sway-audio-idle-inhibit"
                             "gammastep"
                             "shadow"
                             "fastfetch"
                             "plan9port"
                             "plan9-rc-shell"
                             "plan9-rio-session"
                             "plan9-acme"
                             "plan9-term"
                             "ffmpeg"
                             "kitty"))
                      %base-packages))

    ;; Services
    (services
     (append (list (service hurd-vm-service-type
                            (hurd-vm-configuration (memory-size 2048)
                                                   (secret-directory
                                                    "/etc/guix/hurd-secrets")))
                   (service gnome-desktop-service-type)
                   (service libvirt-service-type)
                   (service virtlog-service-type)
                   (service nix-service-type)
                   (simple-service 'zsh-config etc-service-type
                                   `(("zshrc" ,(local-file "../files/config/zshrc"))))
                   (simple-service 'doas-config etc-service-type
                                   `(("doas.conf" ,(local-file "../files/config/doas/doas.conf"))))
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
                                                                               "../files/keys/nonguix.pub"))
                                                                        %default-authorized-guix-keys))))
               (mingetty-service-type config =>
                                      (mingetty-configuration (inherit config)
                                                              (auto-login
                                                               "puppy"))))))))

((compose (nonguix-transformation-nvidia))
 %guix-os)
