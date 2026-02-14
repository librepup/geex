(use-modules (gnu)
             (gnu packages)
             (gnu services dbus)
             (jonabron packages games))

(operating-system
  (host-name "guix-test-lab")
  (timezone "Europe/Berlin")
  (locale "en_US.utf8")

  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets '("/dev/null"))))

  (packages (append
             (map specification->package
                  '("emacs-no-x"
                    "coreutils"
                    "grep"
                    "bash"
                    "procps"))
             ))

  (file-systems %base-file-systems)

  (services
   (append (list (service dbus-root-service-type)
                 (service gamemode-service-type))
           %base-services)))
