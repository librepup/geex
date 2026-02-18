#!/usr/bin/env -S guix shell plan9port emacs-pgtk -- sh

9 rc -c \
  "fn l { eza --icons \$* };
   fn ls { eza --icons \$* };
   fn la { eza --icons -l -r -A -T -L=1 \$* };
   fn q { exit };
   fn l9 { 9 ls \$* };
   fn 9l { 9 ls \$* };
   fn cp { rsync -ah --progress \$* };
   fn ec { emacsclient -c -nw \$* };
   fn pwd { 9 pwd \$* };
   fn date { /run/current-system/sw/bin/date \$* };
   prompt='(9) % ';
   rc"
