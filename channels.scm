;---
; Copy this Channel File to '/etc/guix/channels.scm' and '~/.config/guix/channels.scm'
;---
(append (list
         (channel
          (name 'jonabron)
          (branch "master")
          (url "https://github.com/librepup/jonabron.git"))
         ; PantherX is temporarily disabled, due to it being
         ; broken and thus preventing Guix Pull and Guix Home from succeeding.
         ;(channel
         ; (name 'pantherx)
         ; (url "https://codeberg.org/gofranz/panther.git")
         ; (introduction
         ;  (make-channel-introduction
         ;   "54b4056ac571611892c743b65f4c47dc298c49da"
         ;   (openpgp-fingerprint
         ;    "A36A D41E ECC7 A871 1003  5D24 524F EB1A 9D33 C9CB"))))
         (channel
          (name 'nonguix)
          (url "https://gitlab.com/nonguix/nonguix")
          (commit "6c0ea215e0bd089bf3b2097e5c59dd726fbbe304")
          ;; Enable signature verification:
          (introduction
           (make-channel-introduction
            "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
            (openpgp-fingerprint
             "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
         (channel
           (name 'guix)
           (url "https://git.guix.gnu.org/guix.git")
           (commit "fa6b510864828b618064ec9368c69e3a97965b45")
           (branch "master")
           (introduction
             (make-channel-introduction
               "9edb3f66fd807b096b48283debdcddccfea34bad"
               (openpgp-fingerprint
                "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))
         (channel
          (name 'emacs)
          (url "https://github.com/garrgravarr/guix-emacs")
          (commit "6601278b9ec901e20cfe5fd9caee3d9ce6e6d0c9")
          (introduction
           (make-channel-introduction
            "d676ef5f94d2c1bd32f11f084d47dcb1a180fdd4"
            (openpgp-fingerprint
             "2DDF 9601 2828 6172 F10C  51A4 E80D 3600 684C 71BA")))))
        %default-channels)
