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
             ; Nongnu & Nonguix
             (nongnu packages linux)
             (nongnu packages nvidia)
             (nongnu services nvidia)
             (nongnu system linux-initrd)
             (nonguix transformations)
             ; Jonabron
             (jonabron packages wm)
             (jonabron packages fonts)
             (jonabron packages games)
             (jonabron packages communication))

(use-service-modules desktop sound audio networking ssh xorg dbus)
(use-package-modules wm bootloaders certs shells version-control xorg)

(define %guix-os (operating-system
                  (kernel linux)
                  #| ; Use this to pin nonguix & guix channel to linux kernel 6.18.7 commit, so not every rebuild, rebuilds the kernel.
                  (kernel (let*
                              ((channels
                                (list (channel
                                       (name 'nonguix)
                                       (url "https://gitlab.com/nonguix/nonguix")
                                       (commit "6c0ea215e0bd089bf3b2097e5c59dd726fbbe3045"))
                                      (channel
                                       (name 'guix)
                                       (url "https://git.guix.gnu.org/guix.git")
                                       (commit "9e6705676ffb7568d03b2b6c9fa3944afa2341e7"))))
                               (inferior
                                (inferior-for-channels channels)))
                              (first (lookup-inferior-packages inferior "linux" "6.18.7"))))
                  |#
 (initrd microcode-initrd)
 (firmware (append (list intel-microcode linux-firmware) %base-firmware))
 (host-name "guix")
 (timezone "Europe/Berlin")
 (locale "en_US.utf8")
 (keyboard-layout (keyboard-layout "us" "colemak"))

 ;; Bootloader
 ;- (U)EFI
 (bootloader (bootloader-configuration
              (keyboard-layout keyboard-layout)
              (bootloader grub-efi-bootloader)
              (targets '("/boot/efi"))))
 ;- Legacy/BIOS
 ;(bootloader (bootloader-configuration
 ;             (keyboard-layout keyboard-layout)
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
               (supplementary-groups '("wheel" "netdev" "audio" "video" "input" "tty" "nixbld"))
               (shell (file-append zsh "/bin/zsh")))
              %base-user-accounts))

 ;; Packages
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
                  )
                )
            ))

 ;; Services
 (services
  (append
   (list
    ; Experimental GNU Hurd VM Service, disable if it causes issues.
    (service hurd-vm-service-type
	     (hurd-vm-configuration
	      (memory-size 2048)
	      (secret-directory "/etc/guix/hurd-secrets")))
    (service gnome-desktop-service-type)
    (service nix-service-type)
    (simple-service 'doas-config etc-service-type
                    (list
                     `("doas.conf" ,(plain-file "doas.conf"
"permit nopass keepenv root
permit persist keepenv setenv :wheel"))))
    (set-xorg-configuration
     (xorg-configuration
      (keyboard-layout keyboard-layout)
      (modules (cons nvidia-driver %default-xorg-modules))
      (drivers '("nvidia")))))

   (modify-services %desktop-services
                    (gdm-service-type config =>
                                      (gdm-configuration
                                       (inherit config)
                                       (wayland? #t)))
                    (delete pulseaudio-service-type)
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
                                         (append (list (local-file "/etc/guix/files/channels/nonguix.pub"))
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
