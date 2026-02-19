#!/usr/bin/env sh

# Check for Help Argument
if [ "$1" == "h" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo -e \
         "geexMover - Geex Configuration Files Installer Script @ v1.0
  options:
    arguments:
      - [g/-g/--g] [git/-git/--git] [github/-github/--github] => Print Geex's GitHub Repository URL
    environment variables:
      - GEEX_DEBUG/GEEX_DEBUG_MODE => Do not perform any operations, just pretend.
      - GEEX_IGNORE_MISSING => Ignore Missing Packages, try to Continue Anyways
      - GEEX_DEBUG_MISSING_ENABLE => Pretend as if Packages were Missing"
    exit 1
elif [ "$1" == "g" ] || [ "$1" == "git" ] || [ "$1" == "-g" ] || [ "$1" == "--g" ] || [ "$1" == "-git" ] || [ "$1" == "--git" ] || [ "$1" == "github" ] || [ "$1" == "-github" ] || [ "$1" == "--github" ]; then
    echo -e \
         "Geex GitHub Repository:
  - URL: https://github.com/librepup/geex

LibrePup E-Mail (for questions):
  - E-Mail: librepup@member.fsf.org"
    exit 1
fi


# Check if Commands are Missing
export missingCommandCount=0
for cmd in cp awk; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "[ Warning ]: Missing required binary: $cmd" >&2
        export missingCommandCount=$(($missingCommandCount + 1))
    fi
done

# If Missing Command Debug is Enabled, pretend to be Missing Commands
if [ -n "$GEEX_DEBUG_MISSING_ENABLE" ]; then
    if [ ! -n "$GEEX_IGNORE_MISSING" ]; then
        echo -e "[ Debug ]: Missing Debug Enabled, pretending to have missing Packages.\n[ Warning ]: Commands missing, but found no way to retrieve them temporarily.\nAborting unless Variable 'GEEX_IGNORE_MISSING' is set."
        if [ ! -n "$GEEX_IGNORE_MISSING" ]; then
            echo "[ Status ]: Variable 'GEEX_IGNORE_MISSING' not set, aborting Process..."
            exit 1
        fi
    fi
fi

# If Commands are Missing, Open a Guix Shell with them Present
if [[ "$missingCommandCount" != 0 ]]; then
  if [ -z "$GUIX_ENVIRONMENT" ] && echo "[ Status ]: Checking for Guix, then running shell exec hook..." && command -v guix >/dev/null 2>&1 && guix shell coreutils bash gawk -- true >/dev/null 2>&1; then
      echo "[ Guix ]: Found Guix, running guix shell exec hook..."
      export IN_GUIX_SHELL=1
      exec guix shell coreutils bash gawk -- bash "$0" "$@"
  elif [ -z "$IN_NIX_SHILL" ] && echo "[ Warning ]: Guix not found, checking for Nix, then running shell exec hook..." && command -v nix-shell >/dev/null 2>&1 && nix-shell -p coreutils gawk bash --run true >/dev/null 2>&1; then
      echo "[ Nix ]: Found Nix, running nix shell exec hook..."
      exec nix-shell -p coreutils bash gawk --run "bash "$0" "$@""
  else
      echo -e "[ Warning ]: Commands missing, but found no way to retrieve them temporarily.\nAborting unless Variable 'GEEX_IGNORE_MISSING' is set."
      if [ ! -n "$GEEX_IGNORE_MISSING" ]; then
          echo "[ Status ]: Variable 'GEEX_IGNORE_MISSING' not set, aborting Process..."
          exit 1
      fi
  fi
else
    echo "[ Status ]: All required Commands present, continuing..."
fi

if [ ! -z "$GUIX_ENVIRONMENT" ]; then
    echo "[ Status ]: Running inside Guix Shell for Command Compatibility"
fi

# Create Randomized Backup Name
export randFunc="$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)"
export randFuncString="$(echo $randFunc)"
export randEtcName="$(echo guix.backup-etc.$randFuncString)"
export randCfgName="$(echo guix.backup-cfg.$randFuncString)"

# Check for Debug Mode - if not set, Backup Files - else Pretend
if [ -n "$GEEX_DEBUG" ] || [ -n "$GEEX_DEBUG_MODE" ]; then
    echo "[ Debug ]: Debug Mode Detected, pretending to Backup Files..."
else
    # Backup '/etc/guix'
    if [ -d /etc/guix ]; then
        cp -r /etc/guix /tmp/$randEtcName
        cp -r /etc/guix $HOME/$randEtcName
        echo "[ Backup ]: Created Backups of your '/etc/guix' at '/tmp/$randEtcName' and '$HOME/$randEtcName'."
        export backedUpEtc="yes"
    else
        echo "[ Status ]: '/etc/guix' not found - not backing up."
    fi
    # Backup '~/.config/guix'
    if [ -d ~/.config/guix ]; then
        cp -r ~/.config/guix /tmp/$randCfgName
        cp -r ~/.config/guix $HOME/$randCfgName
        echo "[ Backup ]: Created Backups of your '~/.config/guix' at '/tmp/$randCfgName' and '$HOME/$randCfgName'."
        export backedUpCfg="yes"
    else
        echo "[ Status ]: '~/.config/guix' not found - not backing up."
    fi
fi

# Declaring Escalation Utility
if command -v doas >/dev/null 2>&1; then
    export escalationUtil="doas"
elif command -v sudo >/dev/null 2>&1; then
    export escalationUtil="sudo"
else
    export escalationUtil="su"
fi
echo "[ Status ]: Pinned Escalation Utility to '$escalationUtil'..."


# Pin Username
export userName="$(echo $USER)"
if [ "$userName" == "root" ]; then
    echo "[ Warning ]: Cannot create Backups for User 'root'"
    printf "[ Input ]: Please enter Username: "
    read -r manualUserName
    if [ "$manualUserName" == "" ]; then
        export userGuess="$(users | awk '{print $1}')"
        echo "[ Warning ]: Input was Empty, guessing User as '$userGuess'..."
        export manualUserName="$(echo $userGuess)"
    fi
    export userName=$manualUserName
fi
echo "[ Status ]: Pinned Username to '$userName'..."

if [ "$HOME" == "/root" ]; then
    echo "[ Warning ]: Cannot copy Files to 'root' Home"
    printf "[ Input ]: Please enter '$userName' Home Path: "
    read -r manualHomeDirectory
    if [ "$manualHomeDirectory" = "" ]; then
        echo "[ Warning ]: Input was Empty, guessing Home as '/home/$userName'..."
        export manualHomeDirectory="$(echo /home/$userName)"
    fi
    export homeDirectory=$manualHomeDirectory
fi
echo "[ Status ]: Pinned Home to '$homeDirectory'..."

# Check for Debug Mode - if not set, Copy Files - else, Pretend
if [ -n "$GEEX_DEBUG" ] || [ -n "$GEEX_DEBUG_VAR" ]; then
    echo "[ Debug ]: Mode Detected, pretending to Copy Files..."
    export copyState="pretended to copy"
    echo "[ Debug ]: Copied Geex Files to respective Directories"
else
    echo "[ Notice ]: Please be ready to enter your Super User/Root Password soon."
    if [ "$escalationUtil" != "su" ]; then
        # Copy Channels
        $escalationUtil cp channels.scm $homeDirectory/.config/guix/channels.scm
        $escalationUtil cp channels.scm /etc/guix/channels.scm
        # Copy Directories
        $escalationUtil cp -r files /etc/guix/files
        $escalationUtil cp -r systems /etc/guix/systems
        $escalationUtil cp -r containers /etc/guix/containers
        # Copy Configs
        $escalationUtil cp home.scm /etc/guix/home.scm
        $escalationUtil cp config.scm /etc/guix/config.scm
        # Set Copy Status Variable
        export copyState="copied"
        echo "[ Creation ]: Copied Geex Files to respective Directories"
    else
        # Copy Channels
        $escalationUtil -c 'cp channels.scm $homeDirectory/.config/guix/channels.scm'
        $escalationUtil -c 'cp channels.scm /etc/guix/channels.scm'
        # Copy Directories
        $escalationUtil -c 'cp -r files /etc/guix/files'
        $escalationUtil -c 'cp -r systems /etc/guix/systems'
        $escalationUtil -c 'cp -r containers /etc/guix/containers'
        # Copy Configs
        $escalationUtil -c 'cp home.scm /etc/guix/home.scm'
        $escalationUtil -c 'cp config.scm /etc/guix/config.scm'
        # Set Copy Status Variable
        export copyState="copied"
        echo "[ Creation ]: Copied Geex Files to respective Directories"
    fi
fi

# Evaluate Backup Status
if [[ "$backedUpEtc" == "yes" ]] && [[ "$backedUpCfg" == "yes" ]]; then
    export backupState="your '/etc/guix', as well as your '~/.config/guix'"
elif [[ "$backedUpEtc" == "yes" ]] && [[ "$backedUpCfg" != "yes" ]]; then
    export backupState="your '/etc/guix'"
elif [[ "$backedUpEtc" != "yes" ]] && [[ "$backedUpCfg" == "yes" ]]; then
    export backupState="your '~/.config/guix'"
else
    export backupState="nothing"
fi

# Print Results
echo -e \
"
[ Geex ]
We have backed up $backupState, and $copyState over the Geex configuration files to their appropriate destination directories.

[ Configuration ]
To switch the system configuration between 'laptop', 'desktop', 'libre', or 'minimal', change the '%systemchoice' variable in the '/etc/guix/config.scm' file.

[ Commands ]
To rebuild your system, run:
 - guix system reconfigure /etc/guix/config.scm

To rebuild your guix home, run:
 - guix home reconfigure /etc/guix/home.scm

To start a home container, run:
 - guix home container /etc/guix/containers/<home-container>.scm

To start a system container, run:
 - guix system build /etc/guix/containers/<system-container>.scm
 - /gnu/store/<hash>-system
 - guix container exec <PID> /run/current-system/profile/bin/bash --login
"

# Unset Exported Variables
unset missingCommandCount
unset IN_GUIX_SHELL
unset randFunc
unset randFuncString
unset randEtcName
unset randCfgName
unset backedUpCfg
unset backedUpEtc
unset backupState
unset copyState
unset userName
unset homeDirectory
unset manualHomeDirectory
unset manualUserName
unset userGuess
