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
             (nongnu system linux-initrd)
             ;; Emacs
             (emacs packages melpa)
             ;; Jonabron
             (jonabron packages wm)
             (jonabron packages fonts)
             (jonabron packages communication)
             (jonabron packages games)
             (jonabron packages ai)
             (jonabron packages shells)
             (jonabron packages entertainment)
             (jonabron packages emacs))

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
   (keyboard-layout (keyboard-layout "us" "altgr-intl"))

   ;; Bootloader
   (bootloader (bootloader-configuration
                 (bootloader grub-bootloader)
                 (keyboard-layout keyboard-layout)
                 (targets '("/dev/sda"))))

   ;; File Systems
   (file-systems (cons* (file-system
                          (mount-point "/")
                          (device (file-system-label "guix-root"))
                          (type "ext4")) %base-file-systems))

   ;; Swap
   (swap-devices (list
                  (swap-space
                   (target (file-system-label "guix-swap")))))

   ;; Users
   (users (cons* (user-account
                  (name "puppy")
                  (comment "Puppy")
                  (group "users")
                  (password (crypt "netbsd" "$6$abc"))
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
                  (password (crypt "netbsd" "$6$abc"))
                  (home-directory "/home/labrat")
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
                            "file"
                            "grep"
                            "xset"
                            "coreutils"
                            "util-linux"
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
                            "xdg-desktop-portal-wlr"
                            "sway-audio-idle-inhibit"
                            "gammastep"
                            "shadow"
                            "fastfetch"
                            "plan9port"
                            "ffmpeg"
                            "kitty"))
                     %base-packages))

   ;; Services
   (services
    (append (list (service gnome-desktop-service-type)
                  (simple-service 'zsh-config etc-service-type
                                  `(("zshrc" ,(local-file "../files/config/zshrc"))))
                  (service nix-service-type)
                  (service tlp-service-type
                           (tlp-configuration (cpu-scaling-governor-on-ac '("performace"))
                                              (cpu-scaling-governor-on-bat '("powersave"))
                                              (sched-powersave-on-bat? #t)))
                  (simple-service 'doas-config etc-service-type
                                  `(("doas.conf" ,(local-file "../files/config/doas/doas.conf"))))
                  (set-xorg-configuration
                   (xorg-configuration
                    (keyboard-layout keyboard-layout))))

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

%guix-os
