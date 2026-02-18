#!/usr/bin/env sh

if echo "Checking for Guix, then running shell exec hook..." && [ -z "$GUIX_ENVIRONMENT" ] && command -v guix >/dev/null 2>&1 && guix shell util-linux grep gawk coreutils findutils -- true >/dev/null 2>&1; then
    echo "Found Guix, running guix shell exec hook..."
    export IN_GUIX_SHELL=1
    exec guix shell util-linux grep gawk coreutils findutils -- bash "$0" "$@"
fi

if ! command -v guix >/dev/null 2>&1 && echo "Guix not found, checking for Nix, then running shell exec hook..." && [ -z "$IN_NIX_SHELL" ] && command -v nix-shell >/dev/null 2>&1 && nix-shell -p coreutils gawk gnugrep util-linux findutils --run true >/dev/null 2>&1; then
    echo "Found Nix, running nix shell exec hook..."
    exec nix-shell -p coreutils gawk gnugrep util-linux findutils --run "bash "$0" "$@""
fi

if ! command -v guix >/dev/null 2>&1 && ! command -v nix-shell >/dev/null 2>&1 && echo -e "[ERR] Neither Guix nor Nix found, continue?"; then
    printf "Continue running despite errors? (y/n): "
    read -r missingContinuePost
    if [[ "$missingContinuePost" != *y* ]]; then
        echo "Aborting..."
        exit 1
    fi
fi

if [ ! -z "$GUIX_ENVIRONMENT" ]; then
    echo -e "[INFO] Currently inside Guix Shell"
elif [ ! -z "$IN_NIX_SHELL" ]; then
    echo -e "[INFO] Currently inside Nix Shell"
fi

echo "Testing for escalation utility..."
if command -v doas >/dev/null 2>&1; then
    export escalationUtil="doas"
elif command -v sudo >/dev/null 2>&1; then
    export escalationUtil="sudo"
else
    export escalationUtil="su"
fi

if [ ! -z "$escalationUtil" ]; then
    echo "Pinned escalation utility to '$escalationUtil'..."
fi

checkMount() {
    if mountpoint -q /mnt; then
        echo "'/mnt' is already mounted, testing '/Mount'..."
        export mntUsed="yes"
    else
        echo "[INFO] '/mnt' free, pinning..."
        export mountPoint="/mnt"
        return 1
    fi
    if [[ "$mntUsed" == "yes" ]]; then
        if mountpoint -q /Mount; then
            echo "'/Mount' is already mounted, aborting..."
            exit 1
        fi
        mkdir -p /Mount
        export mountPoint="/Mount"
        echo "[INFO] '/Mount' free, pinning..."
    fi
}
legacyCheckMount() {
    if awk '$2 == "/mnt"' /proc/self/mounts | grep -q .; then
        echo "'/mnt' is already mounted, testing '/Mount'..."
        export mntUsed="yes"
    else
        echo "[INFO] '/mnt' free, pinning..."
        export mountPoint="/mnt"
        return 1
    fi
    if [[ "$mntUsed" == "yes" ]]; then
        if awk '$2 == "/Mount"' /proc/self/mounts | grep -q .; then
            echo "'/Mount' is already mounted, aborting..."
            exit 1
        fi
        mkdir -p /Mount
        export mountPoint="/Mount"
        echo "[INFO] '/Mount' free, pinning..."
    fi
}
findMount() {
    if findmnt /mnt >/dev/null 2>&1; then
        echo "'/mnt' is already mounted, testing '/Mount'..."
        export mntUsed="yes"
    else
        echo "[INFO] '/mnt' free, pinning..."
        export mountPoint="/mnt"
        return 1
    fi
    if [[ "$mntUsed" == "yes" ]]; then
        if findmnt /Mount >/dev/null 2>&1; then
            echo "'/Mount' is already mounted, aborting..."
            exit 1
        fi
        mkdir -p /Mount
        export mountPoint="/Mount"
        echo "[INFO] '/Mount' free, pinning..."
    fi
}

echo "Scanning for mount status utility..."
if command -v mountpoint >/dev/null 2>&1; then
    checkMount
elif command -v findmnt >/dev/null 2>&1; then
    findMount
else
    legacyCheckMount
fi

if [ ! -z "$mountPoint" ]; then
    echo "Pinned mount point to '$mountPoint'..."
fi

echo "Calculating missing commands..."
export missingCommandCount=0
for cmd in lsblk grep awk tr; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Missing required binary: $cmd" >&2
        export missingCommandCount=$(($missingCommandCount + 1))
    fi
done

echo "Finding and exporting disk properties..."
diskList="$(lsblk -r -f)"
echo "Fetched disk list"
ventoyDisk="$(find /dev/disk/by-label/Ventoy -type l 2>/dev/null)"
if [ ! -z "$ventoyDisk" ]; then
    echo "Found ventoy disk..."
else
    echo "[ERR] No ventoy disk found, aborting..."
    exit 1
fi
partName="$(readlink -f "$ventoyDisk")"
if [ ! -z "$partName" ]; then
    echo "Pinning part name to '$partName'..."
else
    echo "[ERR] Error in discovering part name, aborting..."
    exit 1
fi

if [ "$missingCommandCount" == 0 ]; then
    echo "All commands present, continuing..."
else
    printf "[ERR] Missing '$missingCommandCount' commands, possible failure, continue? (y/n): "
    read -r commandMissingError
    if [[ "$commandMissingError" != *y* ]]; then
        echo "Aborting..."
        exit 1
    fi
fi

echo "Running main mount logic..."
if [ "$escalationUtil" != "su" ]; then
    if $escalationUtil mount $partName $mountPoint; then
        echo "Mounted '$partName' to '$mountPoint'"
    else
        echo "Error mounting '$partName' to '$mountPoint', aborting..."
        exit 1
    fi
else
    if partName=$partName mountPoint=$mountPoint $escalationUtil -c 'mount $partName $mountPoint'; then
        echo "Mounted '$partName' to '$mountPoint'"
    else
        echo "Error mounting '$partName' to '$mountPoint', aborting..."
        exit 1
    fi
fi
