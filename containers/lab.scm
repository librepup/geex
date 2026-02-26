; System Container
(define-module (lab))

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
             (guix git-download)
             (guix build utils)
             (guix build-system emacs)
             ;; Emacs
             (emacs packages melpa)
             ;; Nongnu & Nonguix
             (nongnu packages linux)
             (nongnu system linux-initrd)
             (nongnu packages nvidia)
             (nongnu services nvidia)
             (nonguix transformations)
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
                     dbus)
(use-package-modules wm
                     bootloaders
                     certs
                     shells
                     version-control
                     xorg)

(define zsh
  (specification->package "zsh"))
(define zsh-autosuggestions
  (specification->package "zsh-autosuggestions"))

(define %guix-os
  (operating-system
   (kernel linux)
   (initrd microcode-initrd)
   (firmware (append (list intel-microcode linux-firmware) %base-firmware))
   (host-name "guixlab")
   (timezone "Europe/Berlin")
   (locale "en_US.utf8")
   (keyboard-layout (keyboard-layout "us"))

   (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets '("/dev/null"))))

   (file-systems %base-file-systems)

   (users (cons (user-account
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
                 (shell (file-append zsh "/bin/zsh"))) %base-user-accounts))

   (packages (append (map specification->package
                          '("eza"
                            "bat"
                            "opendoas"
                            "zoxide"
                            "shadow"
                            "grep"
                            "coreutils"
                            "util-linux"
                            "file"
                            "glibc-locales"
                            "ncurses"
                            "zsh"
                            "zsh-autosuggestions"
                            "zsh-syntax-highlighting"
                            "git-minimal"
                            "usbutils"
                            "pciutils"
                            "naitre"
                            "vicinae"
                            "procps"
                            "wget"
                            "curl"
                            "nss-certs"
                            "bash"
                            "sed"
                            "kitty"
                            "fastfetch"
                            "plan9port"
                            "emacs-pgtk"
                            "emacs-fancy-dabbrev"
                            "emacs-hoon-mode"
                            "emacs-emms"
                            "emacs-impatient-mode"
                            "emacs-esh-autosuggest"
                            "emacs-vim-tab-bar"
                            "emacs-erc"
                            "emacs-erc-image"
                            "emacs-windower"
                            "emacs-company"
                            "emacs-corfu-terminal"
                            "emacs-rc-mode"
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
                            "emacs-pipewire"
                            "emacs-exwm"
                            "emacs-exwm-x"
                            "emacs-desktop-environment"
                            "emacs-browse-url-dwim"
                            "emacs-exwm-surf"
                            "emacs-exwm-ss"
                            "emacs-exwm-modeline"
                            "emacs-exwm-float"
                            "emacs-exwm-firefox"
                            "emacs-exwm-edit"
                            "emacs-exwm-mff"
                            "emacs-dmenu"))))

   (services
    (append (list
             (simple-service 'zsh-config etc-service-type
                             `(("zshrc" ,(local-file "../files/config/zshrc"))))
             (service nix-service-type)
             (simple-service 'doas-config etc-service-type
                             (list `("doas.conf" ,(plain-file
                                                   "doas.conf"
                                                   "permit nopass keepenv root
permit persist keepenv setenv :wheel")))))
            (modify-services %desktop-services
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
                                                                    (authorized-keys (append
                                                                                      (list (local-file
                                                                                             "/etc/guix/files/keys/nonguix.pub"))
                                                                                      %default-authorized-guix-keys))
                                                                    ))
                             (mingetty-service-type config =>
                                                    (mingetty-configuration (inherit config)
                                                                            (auto-login
                                                                             "puppy"))))))))

%guix-os
