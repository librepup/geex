#!/usr/bin/env bash

term rc -c "fn l { 9 ls $* }; fn ls { 9 ls $* }; fn q { exit $* }; fn gf { $HOME/.scripts/gfetch-linux-compat.rc $* }; rc"
