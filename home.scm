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
             (jonabron packages communication)
             (jonabron packages games)
             (jonabron packages wm)
             (nongnu packages video)
             (nongnu packages game-client)
             (emacs packages melpa))

;---
; To specify the channel a package should be pulled from, define the name like so:
; + (use-modules (jonabron packages emacs) #:rename (emacs-fancy-dabbrev jonabron-emacs-fancy-dabbrev))
; + (use-modules (emacs packages melpa) #:rename (emacs-fancy-dabbrev melpa-emacs-fancy-dabbrev))
; And then add the renamed package to the packages list:
; + (home-environment
; +  (packages (specifications->packages
; +             (list "jonabron-emacs-fancy-dabbrev") ; or: "melpa-emacs-fancy-dabbrev"
; +  ))
; + )
;---

(define zsh (specification->package "zsh"))
(define zsh-autosuggestions (specification->package "zsh-autosuggestions"))

(home-environment
 (packages (specifications->packages
           (list "git"
                 ; Desktop Applications
                 "discord"
                 "element-desktop"
                 "osu-lazer-bin"
                 "vicinae"
                 "naitre"
                 "icecat"
                 "icedove"
                 "icedove-wayland"
                 "firefox"
                 "librewolf"
                 "torbrowser"
                 "feh"
                 "zathura"
                 "krita"
                 "thunar"
                  ;"mpv"
                 "mpv-nvidia"
                 "steam-nvidia"
                 "protonup"
                 ; ZSH
                 "zsh"
                 "zsh-autosuggestions"
                 "zsh-syntax-highlighting"
                 ; Emacs
                 ;"emacs" ; X11 Emacs
                 "emacs-pgtk" ; Wayland Emacs
                 "emacs-fancy-dabbrev" ; From Jonabron Channel
                 "emacs-hoon-mode" ; From Jonabron Channel
                 "emacs-emms"
                 "emacs-impatient-mode"
                 "emacs-vim-tab-bar" ; From Emacs Channel
                 "emacs-erc"
                 "emacs-erc-image"
                 "emacs-company"
                 "emacs-corfu-terminal"
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
                 ; Tools
                 "xinput"
                 "jami"
                 "gsettings-desktop-schemas"
                 "setxkbmap"
                 "dmenu"
                 "keepassxc"
                 "eza"
                 "bat"
                 "zoxide"
                 "ripgrep"
                 "grep"
                 "libnotify"
                 "gnucash"
                 "rofi"
                 "xset"
                 "coreutils"
                 "glibc-locales"
                 "ncurses"
                 "nix"
                 "nixfmt"
                 "opendoas"
                 "xmonad"
                 "fzf"
                 "guile"
                 "ghc-xmonad-contrib"
                 "gammastep"
                 "pipewire"
                 "wireplumber"
                 "flatpak"
                 "polybar"
                 "btop"
                 "wpa-supplicant"
                 "curl"
                 "nss-certs"
                 "guix-backgrounds"
                 "dunst"
                 "texlive-scheme-full"
                 "rsync"
                 "bottom"
                 "redshift"
                 "flameshot"
                 "mpvpaper"
                 "dmidecode"
                 "sway-audio-idle-inhibit"
                 "imv"
                 "cmus"
                 "alsa-utils"
                 "pavucontrol"
                 "pulseaudio"
                 "pulsemixer"
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
                 "7zip"
                 "openssl"
                 "tumbler"
                 "dbus"
                 "ntfs-3g"
                 "cryptsetup"
                 "testdisk"
                 "encfs"
                 "usbutils"
                 "pamixer"
                 "node"
                 "gcc-toolchain"
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
                 "progress"
                 "gnunet"
                 ; Fonts
                 "font-jonafonts"
                 "font-dejavu"
                 "font-google-noto-emoji"
                 ; Terminal
                 "kitty"
                 ; Fetchers
                 "hyfetch"
                 "neofetch"
                 "fastfetch"
                 "pfetch"
                 "ufetch"
                 )))

 (services (list
            ;;; PipeWire
            (service home-dbus-service-type)
            (service home-pipewire-service-type
                     (home-pipewire-configuration
                      (enable-pulseaudio? #t)))
            ;;; ZSH Configuration
            (service home-zsh-service-type
                     (home-zsh-configuration
                      (environment-variables '(("PS1" . "  %~ ")
                                               ("PROMPT" . "  %~ ")
                                               ("TERMINFO_DIRS" . "$HOME/.guix-home/profile/share/terminfo")
                                               ("TERM" . "kitty")
                                               ;("TERM" . "xterm-256color")
                                               ("LANG" . "en_US.UTF-8")
                                               ("LC_CTYPE" . "en_US.UTF-8")
                                               ("LC_ALL" . "en_US.UTF-8")
                                               ("GUIX_LOCPATH" . "$HOME/.guix-home/profile/lib/locale:$HOME/.guix-profile/lib/locale:/guix/current/lib/locale")
                                               ("EDITOR" . "emacs")))
                      (zshrc
                       (list
                        (local-file "files/config/zshrc")
                      ))))

                 ;;; Environment Variables
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
                                   ("SHELL" . ,(file-append zsh "/bin/zsh"))
                                   ("LESSHISTFILE" . "$XDG_CACHE_HOME/.lesshst")))

                 ;;; Dotfile Guix Home Setup, Symlinked as well as Mutable (~/.config/naitre/main.conf)
                 ; Before:
                 ;  `((".config/directory" ,(local-file (string-append (current-source-directory) "/files/config/directory" #:recursive? #t))))
                 ; ... but (current-source-directory) was removed, as it is unnecessary (according to ChatGPT), and could cause breakage.
                 (simple-service 'mpv-config
                                 home-files-service-type
                                 `((".config/mpv" ,(local-file "files/config/mpv" #:recursive? #t))))
                 (simple-service 'dot-emacs-config
                                 home-files-service-type
                                 `((".emacs" ,(local-file "files/config/guixmacs/emacs"))))
                 (simple-service 'guixmacs-themes-config
                                 home-files-service-type
                                 `((".guixmacs/themes" ,(local-file "files/config/guixmacs/themes" #:recursive? #t))))
                 (simple-service 'guixmacs-logo-config
                                 home-files-service-type
                                 `((".guixmacs/files" ,(local-file "files/config/guixmacs/files" #:recursive? #t))))
                 (simple-service 'guixmacs-config
                                 home-files-service-type
                                 `((".guixmacs/config" ,(local-file "files/config/guixmacs/config" #:recursive? #t))))
                 (simple-service 'discord-config
                                 home-files-service-type
                                 `((".config/vesktop" ,(local-file "files/config/discord" #:recursive? #t))))
		 (simple-service 'dunst-config
				 home-files-service-type
				 `((".config/dunst" ,(local-file "files/config/dunst" #:recursive? #t))))
                 (simple-service 'fastfetch-config
                                 home-files-service-type
                                 `((".config/fastfetch" ,(local-file "files/config/fastfetch" #:recursive? #t))))
                 (simple-service 'hyprlock-config
                                 home-files-service-type
                                 `((".config/hyprlock" ,(local-file "files/config/hyprlock" #:recursive? #t))))
                 (simple-service 'kitty-config
                                 home-files-service-type
                                 `((".config/kitty" ,(local-file "files/config/kitty" #:recursive? #t))))
                 (simple-service 'waybar-config
                                 home-files-service-type
                                 `((".config/waybar" ,(local-file "files/config/waybar" #:recursive? #t))))
                 (simple-service 'zathura-config
                                 home-files-service-type
                                 `((".config/zathura" ,(local-file "files/config/zathura" #:recursive? #t))))
                 (simple-service 'btop-config
                                 home-files-service-type
                                 `((".config/btop" ,(local-file "files/config/btop" #:recursive? #t))))
		 (simple-service 'polybar-config
				 home-files-service-type
				 `((".config/polybar" ,(local-file "files/config/polybar" #:recursive? #t))))
                 (simple-service 'scripts-config
                                 home-files-service-type
                                 `((".scripts" ,(local-file "files/scripts" #:recursive? #t))))
                 (simple-service 'wallpapers-config
                                 home-files-service-type
                                 `(("Pictures/Wallpapers" ,(local-file "files/pictures/Wallpapers" #:recursive? #t))))
                 (simple-service 'icons-config
                                 home-files-service-type
                                 `(("Pictures/Icons" ,(local-file "files/pictures/Icons" #:recursive? #t))))
                 (simple-service 'stallman-config
                                 home-files-service-type
                                 `(("Pictures/Stallman" ,(local-file "files/pictures/Stallman" #:recursive? #t))))
                 (simple-service 'naitre-config
                                 home-files-service-type
                                 `((".config/naitre" ,(local-file "files/config/naitre" #:recursive? #t))))
                 ))
 )
