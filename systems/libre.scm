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
    (host-name "libreguix")
    (timezone "Europe/Berlin")
    (locale "en_US.utf8")
    (keyboard-layout (keyboard-layout "us" "colemak"))

    ;; Bootloader
    ;; - (U)EFI
    (bootloader (bootloader-configuration
                  (keyboard-layout keyboard-layout)
                  (bootloader grub-efi-bootloader)
                  (targets '("/boot/efi"))))
    ;; - Legacy/BIOS
    ;; (bootloader (bootloader-configuration
    ;; (keyboard-layout keyboard-layout)
    ;; (bootloader grub-bootloader)
    ;; (targets '("/dev/sda1"))))
    
    ;; File Systems
    ;; - Regular
    (file-systems (cons* (file-system
                           (mount-point "/")
                           (device (file-system-label "guix-root"))
                           (type "ext4"))
                         (file-system
                           (mount-point "/boot/efi")
                           (device (file-system-label "guix-efi"))
                           ;; or: (device (uuid "PARTITION_UUID" 'fat32))
                           (type "vfat")) %base-file-systems))
    ;; - Encrypted
    ;; (file-systems (append
    ;; (list (file-system
    ;; (device "/dev/mapper/cryptroot")
    ;; (mount-point "/")
    ;; (type "ext4")
    ;; (dependencies mapped-devices))
    ;; (file-system
    ;; (device (uuid "PARTITION_1_UUID" 'fat32))
    ;; (mount-point "/boot/efi")
    ;; (type "vfat")))
    ;; %base-file-systems))
    
    ;; Users
    (users (cons (user-account
                   (name "puppy")
                   (comment "Puppy")
                   (group "users")
                   (home-directory "/home/puppy")
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
                             "glibc-locales"
                             "ncurses"
                             "zsh"
                             "git-minimal"
                             "emacs-no-x"
                             "usbutils"
                             "pciutils"
                             "wpa-supplicant"
                             "dhcpcd"
                             "xmonad"
                             "ghc-xmonad-contrib"
                             "naitre"
                             "procps"
                             "wget"
                             "curl"
                             "nss-certs"
                             "bash"
                             "sed"
                             "kitty"))))

    ;; Services
    (services
     (append (list (service gnome-desktop-service-type)
                   (service nix-service-type)
                   (simple-service 'doas-config etc-service-type
                                   (list `("doas.conf" ,(plain-file
                                                         "doas.conf"
                                                         "permit nopass keepenv root
permit persist keepenv setenv :wheel"))))
                   (set-xorg-configuration
                    (xorg-configuration (keyboard-layout keyboard-layout))))

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
                                                               "puppy"))))))))

%guix-os
