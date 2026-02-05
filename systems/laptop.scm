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
             (gnu utils)
             (guix)
             ; Nongnu & Nonguix
             (nongnu packages linux)
             (nongnu system linux-initrd)
             ; Jonabron
             (jonabron packages wm)
             (jonabron packages fonts))

(use-service-modules desktop networking ssh xorg dbus)
(use-package-modules wm bootloaders certs shells editors version-control xorg pipewire)

(define %guix-os (operating-system
 (kernel linux)
 (initrd microcode-initrd)
 (firmware (list intel-microcode linux-firmware %base-firmware))
 (host-name "guixtop")
 (timezone "Europe/Berlin")
 (locale "en_US.utf8")
 (keyboard-layout (keyboard-layout "us"))

 ;; Bootloader
 (bootloader (bootloader-configuration
              (bootloader grub-bootloader)
              (targets '("/dev/sdb1"))))

 ;; File Systems
 (file-systems (cons* (file-system
                       (mount-point "/")
                       (device (file-system-label "guix-root"))
                       (type "ext4"))
                      %base-file-systems))

 ;; Users
 (users (cons (user-account
               (name "puppy")
               (comment "Puppy")
               (group "users")
               (home-directory "/home/puppy")
               (supplementary-groups '("wheel" "netdev" "audio" "video" "input" "tty" "nix-users"))
               (shell (file-append zsh "/bin/zsh")))
              %base-user-accounts))

 ;; Packages
 (packages (append (map specification->package+output
                        '("zsh"
                          "naitre" ; From Jonabron Channel
                          "nix"
                          "nixfmt"
                          "opendoas"
                          "xmonad"
                          "ghc-xmonad-contrib"
                          "pipewire"
                          "wireplumber"
                          "flatpak"
                          "polybar"
                          "btop"
                          "git"
                          "wpa-supplicant"
                          "curl"
                          "emacs"
                          "nss-certs"
                          "firefox"
                          "icecat"
                          "icedove"
                          "guix-backgrounds"
                          "icedove-wayland"
                          "kitty"
                          "font-bundle-synapsian-karamarea" ; From Jonabron Channel
                          "font-dejavu"
                          "dunst"
                          "feh"
                          "zathura"
                          "texlive"
                          "emacs-org-texlive-collection"
                          "rsync"
                          "eza"
                          "bat"
                          "zoxide"
                          "bottom"
                          "redshift"
                          "flameshot"
                          "mpv"
                          "mpvpaper"
                          "sway-audio-idle-inhibit"
                          "imv"
                          "steam" ; From Nonguix Channel
                          "cmus"
                          "alsa-utils"
                          "hyfetch"
                          "neofetch"
                          "fastfetch"
                          "pfetch"
                          "pavucontrol"
                          "pulseaudio"
                          "pulsemixer"
                          "krita"
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
                          "p7zip"
                          "openssl"
                          "coreutils"
                          "thunar"
                          "tumbler"
                          "dbus"
                          "ntfs-3g"
                          "cryptsetup"
                          "testdisk"
                          "encfs"
                          "usbutils"
                          "pamixer"
                          "node"
                          "glib"
                          "librewolf"
                          "torbrowser"
                          "rust"
                          "rust-analyzer"
                          "gcc"
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
                          "ripgrep"
                          "discord" ; From Git Repo Channel
                          ))))

 ;; Services
 (services
  (append
   (list
    (service gnome-desktop-service-type)
    (service gdm-service-type
             (gdm-configuration
             (wayland? #t)))
    (service nix-service-type)
    (service pipewire-service-type)
    (service alsa-service-type
             (alsa-configuration
              (jack? #t)))
    (service dhcpcd-service-type)
    (simple-service 'doas-config etc-service-type
                    (list
                     `("doas.conf" ,(plain-file "doas.conf"
"permit nopass keepenv root
permit persist keepenv setenv :wheel"))))
    (service network-manager-service-type)
    (set-xorg-configuration
     (xorg-configuration
      (keyboard-layout (keyboard-layout "us" "colemak"))
      )))

   (modify-services %desktop-services
                    (delete pulseaudio-service-type)
                    (guix-service-type config =>
                                       (guix-configuration
                                        (inherit config)
                                        (substitute-urls
                                         (append (list "https://ci.guix.gnu.org"
                                               "https://berlin.guix.gnu.org"
                                               "https://bordeaux.guix.gnu.org"
                                               "https://substitutes.nonguix.org"
                                               "https://hydra-guix-129.guix.gnu.org")
                                                 %default-substitute-urls))
                                        ; Authorize via 'sudo guix archive --authorize < /etc/guix/channels/nonguix.pub'
                                        (authorized-keys
                                         (append (list (local-file "/etc/guix/channels/nonguix.pub"))
                                                 %default-authorized-guix-keys))
                                        ))
                    (mingetty-service-type config =>
                                           (mingetty-configuration
                                            (inherit config)
                                            (auto-login "puppy")))
                    )
   ))
 )
)

%guix-os
