(require 'exwm)
(require 'windower)
(require 'exwm-mff)
(require 'dmenu)
(require 'exwm-systemtray)
(require 'exwm-randr)
(require 'doom-modeline)

;; randr mode
(exwm-randr-mode 1)

;; use 10 workspaces (0–9)
(setq exwm-workspace-number 10)

;; allow certain keys to pass through/be global
(setq exwm-input-prefix-keys
      '(?\C-x ?\C-u ?\C-h ?\M-x ?\M-` ?\M-& ?\M-:
        [XF86AudioLowerVolume] [XF86AudioRaiseVolume]
        [XF86AudioMute] [XF86AudioPlay]
        [XF86AudioNext] [XF86AudioPrev]
        [XF86MonBrightnessUp] [XF86MonBrightnessDown]))

;; helper to spawn shell commands
(defun my/spawn (cmd)
  (start-process-shell-command cmd nil cmd))

;; call `program` with `args` and return output
;; see also `'process-lines`
(defun my/call-process-to-string (program &rest args)
  (with-output-to-string
    (with-current-buffer standard-output
      (apply 'process-file program nil t nil args))))

;; set environment variables
(setenv "BROWSER" "firefox")
(setenv "LIBREBROWSER" "icecat")
(setenv "TERM" "kitty")

;; set browse-url program
(setq browse-url-generic-program
      (or
       (executable-find (or (getenv "BROWSER") ""))
       (when (executable-find "xdg-mime")
         (let ((desktop-browser (my/call-process-to-string "xdg-mime" "query" "default" "text/html")))
           (substring desktop-browser 0 (string-match "\\.desktop" desktop-browser))))
       (executable-find browse-url-chrome-program)))

;; workspace switching (Alt+1..0)
(dotimes (i 10)
  (exwm-input-set-key
   (kbd (format "M-%d" (if (= i 9) 0 (1+ i))))
   `(lambda ()
      (interactive)
      (exwm-workspace-switch ,i))))
(dotimes (i 10)
  (exwm-input-set-key
   (kbd (format "M-S-%d" (if (= i 9) 0 (1+ i))))
   `(lambda ()
      (interactive)
      (exwm-workspace-move-window ,i))))

;; keybinds
(setq exwm-input-global-keys
      (append exwm-input-global-keys
              `(
                ;; move windows
                ; arrows
                (,(kbd "M-<left>") . #'windmove-left)
                (,(kbd "M-<right>") . #'windmove-right)
                (,(kbd "M-<up>") . #'windmove-up)
                (,(kbd "M-<down>") . #'windmove-down)
                ; letters
                (,(kbd "M-e") . #'windmove-right)
                (,(kbd "M-b") . #'windmove-left)
                (,(kbd "M-n") . #'windmove-down)
                (,(kbd "M-p") . #'windmove-up)
                ;; warp mouse to selected
                (,(kbd "M-S-w") . #'exwm-mff-warp-to-selected)
                ;; windower
                (,(kbd "M-S-<left>") . #'windower-swap-left)
                (,(kbd "M-S-<right>") . #'windower-swap-right)
                (,(kbd "M-S-<down>") . #'windower-swap-below)
                (,(kbd "M-S-<up>") . #'windower-swap-above)
                ;; kill
                (,(kbd "M-S-q") . #'kill-buffer)
                ;; refresh xrandr
                (,(kbd "M-S-p") . #'exwm-randr-refresh)
                ;; fullscreen & maximize column
                (,(kbd "M-S-t") . #'exwm-layout-toggle-fullscreen)
                (,(kbd "M-S-m") . (lambda () (interactive)
                                    (delete-other-windows)))
                ;; launchers
                ; vicinae
                (,(kbd "M-t") . (lambda () (interactive)
                                  (start-process "vicinae" nil "vicinae" "open")))
                ; wofi
                (,(kbd "M-C-t") . (lambda () (interactive)
                                    (start-process "wofi" nil "wofi" "--show" "drun" "-I")))
                (,(kbd "s-S-t") . (lambda () (interactive)
                                    (start-process "wofi" nil "wofi" "--show" "run")))
                ; emacs-dmenu
                (,(kbd "M-C-S-t") . dmenu)
                (,(kbd "M-&") . dmenu)
                ;; screenshots
                ; flameshot
                (,(kbd "M-a") . (lambda () (interactive)
                                  (start-process "flameshot" nil "flameshot" "gui")))
                ; hyprshot
                (,[print] . (lambda () (interactive)
                              (start-process "hyprshot" nil "hyprshot" "-m" "region" "--clipboard-only" "--freeze")))
                (,(kbd "s-S-a") . (lambda () (interactive)
                                    (start-process "hyprshot" nil "hyprshot" "-m" "region" "--clipboard-only" "--freeze")))
                ;; programs
                ; terminal
                (,(kbd "M-S-<return>") . (lambda () (interactive)
                                           (start-process "kitty" nil "kitty")))
                ; emacs(client)
                (,(kbd "M-S-f") . (lambda () (interactive)
                                    (start-process "emacsclient" nil "emacsclient" "-c" "--alternate-editor=\"\"")))
                ; explorer
                (,(kbd "s-e") . (lambda () (interactive)
                                  (start-process "thunar" nil "thunar")))
                ; text editor
                (,(kbd "s-t") . (lambda () (interactive)
                                  (start-process "marker" nil "marker")))
                ; firefox
                (,(kbd "M-s") . (lambda () (interactive)
                                  (start-process "firefox" nil "firefox")))
                ; edge
                (,(kbd "M-S-s") . (lambda () (interactive)
                                    (start-process "microsoft-edge" nil "microsoft-edge")))
                ; icedove
                (,(kbd "s-d") . (lambda () (interactive)
                                  (start-process "icedove" nil "icedove")))
                ;; bars
                (,(kbd "s-S-b") . (lambda () (interactive)
                                    (my/spawn "~/.scripts/waybar.sh")))
                (,(kbd "s-b") . (lambda () (interactive)
                                  (start-process "dms" nil "dms" "ipc" "bar" "toggle" "index" "0")))
                ;; brightness
                (,[XF86MonBrightnessUp] . (lambda () (interactive)
                                            (my/spawn "brightnessctl s +5% && notify-send -t 1000 'Brightness' \"$(brightnessctl g)\"")))
                (,[XF86MonBrightnessDown] . (lambda () (interactive)
                                              (my/spawn "brightnessctl s 5%- && notify-send -t 1000 'Brightness' \"$(brightnessctl g)\"")))
                ;; media
                (,[XF86AudioRaiseVolume] . (lambda () (interactive)
                                             (my/spawn "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && notify-send -t 1000 'Volume' \"\"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2)\"\"")))
                (,[XF86AudioLowerVolume] . (lambda () (interactive)
                                             (my/spawn "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify-send -t 1000 'Volume' \"\"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2)\"\"")))
                (,[XF86AudioMute] . (lambda () (interactive)
                                      (start-process "mute" nil "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle")))
                (,[XF86AudioPlay] . (lambda () (interactive)
                                      (my/spawn "playerctl play-pause && notify-send -t 1000 'Media' \"$(playerctl status): $(playerctl metadata title)\"")))
                (,[XF86AudioNext] . (lambda () (interactive)
                                      (start-process "next" nil "playerctl" "next")))
                (,[XF86AudioPrev] . (lambda () (interactive)
                                      (start-process "prev" nil "playerctl" "previous")))
                )))

;; autostart
(defun my/exwm-init ()
  ;; background services
  (start-process "wl-paste" nil "wl-paste" "--watch" "cliphist" "store")
  (start-process "dunst" nil "dunst")
  (start-process "vicinae" nil "vicinae" "server")
  (start-process "dex" nil "dex" "--autostart" "--environment" "exwm")
  (start-process "nm-applet" nil "nm-applet")
  ;; wallpaper
  (start-process "wallpaper" nil "swaybg" "-i" "/home/puppy/Pictures/Wallpapers/guix_wp_02.png" "-m" "fill")
  (start-process "wallpaper" nil "feh" "--bg-fill" "/home/puppy/Pictures/Wallpapers/guix_wp_02.png")
  ;; desktop
  ;(start-process "dms" nil "dms" "run")
  (start-process "redshift" nil "redshift" "-l" "52.520008:13.404954" "-t" "4000:4000")
  ;(start-process "gammastep" nil "gammastep" "-l" "52.520008:13.404954" "-t" "4000:4000")
  ;; monitor
  ;(start-process-shell-command "xrandr" nil "xrandr --output HDMI-0 --primary --mode 1920x1080 --rate 144.00 --output DP-0 --mode 2560x1440 --right-of HDMI-0")
  ;; mouse
  (start-process-shell-command "xinput" nil "xinput set-prop 'Mad Catz Global MADCATZ R.A.T. 8+ gaming mouse' 'libinput Accel Profile Enabled' 0 1 0")
  (start-process-shell-command "xinput" nil "xinput set-prop 'Mad Catz Global MADCATZ R.A.T. 8+ gaming mouse' 'libinput Accel Speed' 0.3")
  (start-process-shell-command "xinput" nil "xinput set-prop 'Mad Catz Global' 'libinput Accel Profile Enabled' 0 1 0")
  (start-process-shell-command "xinput" nil "xinput set-prop 'Mad Catz Global' 'libinput Accel Speed' 0.3")
  ;; xmodmap
  (start-process-shell-command "xmodmap" nil "xmodmap ~/.guixmacs/exwm/Xmodmap"))

;; mouse follow focus
(exwm-mff-mode 1)

;; bar
; time
(display-time-mode 1)
(setq display-time-format "%d.%m.%Y %H:%M")
; doom-modeline
(defun my/doom-modeline-exwm-workspaces ()
  (when (and (boundp 'exwm-workspace-current-index)
             (boundp 'exwm-workspace-number))
    (mapconcat
     (lambda (i)
       (if (= i exwm-workspace-current-index)
           (propertize (format "[%d]" i) 'face 'doom-modeline-buffer-major-mode)
         (propertize (format " %d " i) 'face 'doom-modeline-inactive)))
     (number-sequence 0 (1- exwm-workspace-number))
     "")))
(doom-modeline-def-segment exwm-workspaces
  (my/doom-modeline-exwm-workspaces))
(doom-modeline-def-modeline 'main
  '(bar exwm-workspaces buffer-info)
  '(misc-info time))
(doom-modeline-set-modeline 'main 'default)
(defun my/exwm-refresh-modeline ()
  (force-mode-line-update t))
(add-hook 'exwm-workspace-switch-hook #'my/exwm-refresh-modeline)
; systemtray
(exwm-systemtray-mode 1)

;; add init hook
(add-hook 'exwm-init-hook #'my/exwm-init)

;; enable exwm
;(exwm-enable)
(exwm-wm-mode)
