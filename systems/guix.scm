(define-module (systems guix)
  #:use-modules (systems base-system)
  ; GNU
  #:use-modules (gnu)
  #:use-modules (gnu system)
  #:use-modules (gnu system nss)
  #:use-modules (gnu packages)
  #:use-modules (gnu packages xorg)
  #:use-modules (gnu packages certs)
  #:use-modules (gnu packages shells)
  #:use-modules (gnu packages admin)
  #:use-modules (gnu packages base)
  #:use-modules (gnu services)
  #:use-modules (gnu services xorg)
  #:use-modules (gnu services desktop)
  #:use-modules (gnu services nix)
  #:use-modules (gnu services sound)
  #:use-modules (gnu services audio)
  #:use-modules (gnu services networking)
  #:use-modules (gnu utils)
  ; Nongnu & Nonguix
  #:use-modules (nongnu packages linux)
  #:use-modules (nongnu packages nvidia)
  #:use-modules (nongnu services nvidia)
  #:use-modules (nongnu system linux-initrd)
  #:use-modules (nonguix transformations)
  ; Jonabron
  #:use-modules (jonabron packages wm)
  #:use-modules (jonabron packages fonts))

;(add-to-load-path (dirname (current-filename)))
(use-service-modules desktop networking ssh xorg dbus)
(use-package-modules wm bootloaders certs shells editors version-control xorg pipewire)

(define %guix-os (operating-system
 (kernel linux)
 (initrd microcode-initrd)
 (firmware (list intel-microcode linux-firmware %base-firmware))
 ;; Nvidia
 (kernel-arguments (append
                    '("modprobe.blacklist=nouveau")
                    %default-kernel-arguments))
 (kernel-loadable-modules (list nvidia-driver))
 (host-name "guix")
 (timezone "Europe/Berlin")
 (locale "en_US.utf8")
 (keyboard-layout (keyboard-layout "us" "colemak"))

 ;; Bootloader
 ;- (U)EFI
 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (targets '("/boot/efi"))))
 ;- Legacy/BIOS
 ;(bootloader (bootloader-configuration
 ;             (bootloader grub-bootloader)
 ;             (targets '("/dev/sda1"))))

 ;; File Systems
 ;- Regular
 (file-systems (cons* (file-system
                       (mount-point "/")
                       (device (file-system-label "guix-root"))
                       (type "ext4"))
                      (file-system
                       (mount-point "/boot/efi")
                       (device (file-system-label "guix-efi"))
                       ;; or: (device (uuid "PARTITION_UUID" 'fat32))
                       (type "vfat"))
                      %base-file-systems))
 ;- Encrypted
 ;(file-systems (append
 ;               (list (file-system
 ;                      (device "/dev/mapper/cryptroot")
 ;                      (mount-point "/")
 ;                      (type "ext4")
 ;                      (dependencies mapped-devices))
 ;                     (file-system
 ;                      (device (uuid "PARTITION_1_UUID" 'fat32))
 ;                      (mount-point "/boot/efi")
 ;                      (type "vfat")))
 ;               %base-file-systems))

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
                          "mpv-nvidia" ; From Nonguix Channel, .-nvidia Variant
                          "mpvpaper"
                          "sway-audio-idle-inhibit"
                          "imv"
                          "steam-nvidia" ; From Nonguix Channel, .-nvidia Variant
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
    (service nvidia-driver-service-type)
    (service kernel-module-loader-service-type
             '("ipmi_devintf"
               "nvidia"
               "nvidia_modeset"
               "nvidia_uvm"))
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
      (modules (cons nvidia-driver %default-xorg-modules))
      (drivers '("nvidia")))))

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

; Wayland Nvidia OS Transformation, as described by Nonguix Docs.
; https://gitlab.com/nonguix/nonguix - Section: NVIDIA graphics card -> System setup.
((compose (nonguix-transformation-nvidia))
 %guix-os)

; For Xorg, use the following code block:
; + ((nonguix-transformation-nvidia #:configure-xorg? #t)
; + %guix-os)
