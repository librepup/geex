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
             (emacs packages melpa))

(define zsh
  (specification->package "zsh"))
(define zsh-autosuggestions
  (specification->package "zsh-autosuggestions"))

(home-environment
  (packages (specifications->packages (list "emacs-pgtk"
                                            "zsh"
                                            "zsh-autosuggestions"
                                            "tzdata"
                                            "zsh-syntax-highlighting"
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
                                            "emacs-dmenu"
                                            "eza"
                                            "bat"
                                            "zoxide"
                                            "ripgrep"
                                            "grep"
                                            "coreutils"
                                            "glibc-locales"
                                            "ncurses"
                                            "fzf"
                                            "procps"
                                            "nss-certs"
                                            "rsync"
                                            "dmidecode"
                                            "pciutils"
                                            "fd"
                                            "util-linux"
                                            "imagemagick"
                                            "openssl"
                                            "tumbler"
                                            "dbus"
                                            "usbutils"
                                            "gcc-toolchain"
                                            "fastfetch"
                                            "sudo"
                                            "font-jonafonts"
                                            "font-dejavu"
                                            "font-google-noto-emoji")))

  (services
   (list
    ;; services
    ;; dbus
    (service home-dbus-service-type)
    ;; zsh
    (service home-zsh-service-type
             (home-zsh-configuration (environment-variables '(("PS1" . "\uf325  %~ ")
                                                              ("PROMPT" . "\uf325  %~ ")
                                                              ("TERMINFO_DIRS" . "$HOME/.guix-home/profile/share/terminfo")
                                                              ("TERM" . "kitty")
                                                              ("LANG" . "en_US.UTF-8")
                                                              ("LC_CTYPE" . "en_US.UTF-8")
                                                              ("LC_ALL" . "en_US.UTF-8")
                                                              ("GUIX_LOCPATH" . "$HOME/.guix-home/profile/lib/locale:$HOME/.guix-profile/lib/locale:/guix/current/lib/locale")
                                                              ("EDITOR" . "emacs")))
                                     (zshrc (list (local-file
                                                   "../files/config/zshrc")))))

    ;; evironment variables
    (simple-service 'environment-variables-config
                    home-environment-variables-service-type
                    `(("PAGER" . "LESS") ("TERMINAL" . "kitty")
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
                      ("SHELL" unquote
                       (file-append zsh "/bin/zsh"))
                      ("LESSHISTFILE" . "$XDG_CACHE_HOME/.lesshst")))
    ;; dotfiles
    ;; others
    (simple-service 'fastfetch-config home-files-service-type
                    `((".config/fastfetch" ,(local-file
                                             "../files/config/fastfetch"
                                             #:recursive? #t))))
    ;; emacs
    (simple-service 'dot-emacs-config home-files-service-type
                    `((".emacs" ,(local-file "../files/config/guixmacs/emacs"))))
    (simple-service 'guixmacs-themes-config home-files-service-type
                    `((".guixmacs/themes" ,(local-file
                                            "../files/config/guixmacs/files/themes"
                                            #:recursive? #t))))
    (simple-service 'guixmacs-logo-config home-files-service-type
                    `((".guixmacs/files" ,(local-file
                                           "../files/config/guixmacs/files/images"
                                           #:recursive? #t))))
    (simple-service 'guixmacs-config home-files-service-type
                    `((".guixmacs/config" ,(local-file
                                            "../files/config/guixmacs/config"
                                            #:recursive? #t))))
    (simple-service 'guixmacs-exwm-config home-files-service-type
                    `((".guixmacs/exwm" ,(local-file
                                          "../files/config/guixmacs/files/exwm"
                                          #:recursive? #t)))))))
