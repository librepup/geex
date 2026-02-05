(define-module (home-config)
  ; GNU
  #:use-modules (gnu)
  #:use-modules (gnu home)
  #:use-modules (gnu home services)
  #:use-modules (gnu home services shells)
  #:use-modules (gnu packages)
  #:use-modules (gnu packages emacs)
  #:use-modules (gnu packages emacs-xyz)
  #:use-modules (gnu services)
  ; Guix
  #:use-modules (guix packages)
  #:use-modules (guix gexp)
  #:use-modules (guix git-download)
  #:use-modules (guix build-system emacs)
  ; Jonabron
  #:use-modules (jonabron packages emacs))

(define zsh (specification->package "zsh"))
(define zsh-autosuggestions (specification->package "zsh-autosuggestions"))

(home-environment
 (packages (specifications->packages
            (list "zsh"
                  "zsh-autosuggestions"
                  "zsh-syntax-highlighting"
                  "zsh-completions"
                  "git"
                  "emacs"
                  "emacs-fancy-dabbrev" ; Local Jonabron Package
                  "emacs-hoon-mode" ; Local Jonabron Package
                  "emacs-emms"
                  "emacs-erc"
                  "emacs-erc-image"
                  "emacs-company"
                  "emacs-corfu"
                  "emacs-corfu-terminal"
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
                  "emacs-rust-mode"
                  "emacs-rustic"
                  "emacs-wttrin"
                  "emacs-hydra"
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
                  )))

 (services (list
            ; ZSH Configuration
            (service home-zsh-service-type
                     (home-zsh-configuration
                      (environment-variables '(("PS1" . "  %~ ")
                                               ("PROMPT" . "  %~ ")
                                               ("HISTFILE" . "$XDG_STATE_HOME/zsh/history")
                                               ("HISTSIZE" . "10000")
                                               ("SAVEHIST" . "10000")
                                               ("EDITOR" . "emacs")))
                      (zshrc
                       (list
                        (local-file (string-append (current-source-directory) "/files/config/zshrc"))
                        (file-append zsh-autosuggestions "/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh")))
                            ))

                 ; Environment Variables
                 (simple-service 'environment-variables-config
                                 home-environment-variables-service-type
                                 `(("PAGER" . "LESS")
                                   ("TERMINAL" . "kitty")
                                   ("EDITOR" . "emacs")
                                   ("VISUAL" . "emacs")
                                   ("WAYLAND_DISPLAY" . "wayland-0")
                                   ("SDL_VIDEODRIVER" . "wayland")
                                   ("ELECTRON_OZONE_PLATFORM_HINT" . "wayland")
                                   ("MOZ_ENABLE_WAYLAND" . "1")
                                   ("GBM_BACKEKD" . "nvidia-drm")
                                   ("__GLX_VENDOR_LIBRARY_NAME" . "nvidia")
                                   ("DISPLAY" . "0")
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
                                   ("SDL_VIDEODRIVER" . "wayland")
                                   ("GSK_RENDERER" . "gl")
                                   ("SHELL" . ,(file-append zsh "/bin/zsh"))
                                   ("LESSHISTFILE" . "$XDG_CACHE_HOME/.lesshst")))

                 ; Dotfile Symlink Guix Home Setup
                 (simple-service 'mpv-config
                                 home-files-service-type
                                 `((".config/mpv" ,(local-file (string-append (current-source-directory) "/files/config/mpv"
                                                                              #:recursive? #t)))))
                 (simple-service 'dot-emacs-config
                                 home-files-service-type
                                 `((".emacs" ,(local-file (string-append (current-source-directory) "/files/config/guixmacs/emacs")))))
                 (simple-service 'guixmacs-themes-config
                                 home-files-service-type
                                 `((".guixmacs/themes" ,(local-file (string-append (current-source-directory) "/files/config/guixmacs/themes"
                                                                                   #:recursive? #t)))))
                 (simple-service 'guixmacs-logo-config
                                 home-files-service-type
                                 `((".guixmacs/files/nix_emacs_logo_small.png" ,(local-file (string-append (current-source-directory) "/files/config/guixmacs/files/nix_emacs_logo_small.png")))))
                 (simple-service 'discord-config
                                 home-files-service-type
                                 `((".config/vesktop" ,(local-file (string-append (current-source-directory) "/files/config/discord"
                                                                   #:recursive? #t)))))
                 (simple-service 'fastfetch-config
                                 home-files-service-type
                                 `((".config/fastfetch" ,(local-file (string-append (current-source-directory) "/files/config/fastfetch"
                                                                     #:recursive? #t)))))
                 (simple-service 'hyprlock-config
                                 home-files-service-type
                                 `((".config/hyprlock" ,(local-file (string-append (current-source-directory) "/files/config/hyprlock"
                                                                    #:recursive? #t)))))
                 (simple-service 'kitty-config
                                 home-files-service-type
                                 `((".config/kitty" ,(local-file (string-append (current-source-directory) "/files/config/kitty"
                                                                 #:recursive? #t)))))
                 (simple-service 'waybar-config
                                 home-files-service-type
                                 `((".config/waybar" ,(local-file (string-append (current-source-directory) "/files/config/waybar"
                                                                  #:recursive? #t)))))
                 (simple-service 'zathura-config
                                 home-files-service-type
                                 `((".config/zathura" ,(local-file (string-append (current-source-directory) "/files/config/zathura"
                                                                   #:recursive? #t)))))
                 (simple-service 'btop-config
                                 home-files-service-type
                                 `((".config/btop" ,(local-file (string-append (current-source-directory) "/files/config/btop"
                                                                               #:recursive? #t)))))
                 (simple-service 'scripts-config
                                 home-files-service-type
                                 `((".scripts" ,(local-file (string-append (current-source-directory) "/files/scripts"
                                                                           #:recursive? #t)))))
                 (simple-service 'wallpapers-config
                                 home-files-service-type
                                 `(("Pictures/Wallpapers" ,(local-file (string-append (current-source-directory) "/files/pictures"
                                                                                      #:recursive? #t)))))
                 ))
 )
