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
             ; PantherX
             (px packages desktop-tools)
             ; Jonabron
             (jonabron packages wm)
             (jonabron packages fonts)
             (jonabron packages communication)
             (jonabron packages games))

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
 (packages (append
            (map specification->package+output %shared-packages)
            (map specification->package+output
                 '("naitre" ; From Jonabron Channel
                   "font-jonafonts" ; From Jonabron Channel
                   "steam" ; From Nonguix Channel
                   "mpv"
                   "vicinae" ; From Jonabron Channel
                   "osu-lazer-bin" ; From Jonabron Channel
                   "discord" ; From Jonabron Channel
                   ))
            ))

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
    (service tlp-service-type
             (tlp-configuration
              (cpu-scaling-governor-on-ac '("performace"))
              (cpu-scaling-governor-on-bat '("powersave"))
              (sched-powersave-on-bat? #t)))
    (simple-service 'doas-config etc-service-type
                    (list
                     `("doas.conf" ,(plain-file "doas.conf"
"permit nopass keepenv root
permit persist keepenv setenv :wheel"))))
    (service network-manager-service-type)
    (set-xorg-configuration
     (xorg-configuration
      (keyboard-layout (keyboard-layout "us"))
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
                                               "https://hydra-guix-129.guix.gnu.org"
                                               "https://substitutes.guix.gofranz.com")
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
