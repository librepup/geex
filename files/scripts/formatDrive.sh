#!/usr/bin/env sh

echo -e "\n===============\n"
lsblk -no NAME,LABEL
echo -e "\n===============\n"
printf "[ Enter Disk ] (/dev/sdX, /dev/nvme0nX): "
read -r selDisk

if [[ "$selDisk" == "" ]] || [[ -z "$selDisk" ]]; then
    echo "[ Error ]: No Disk provided, aborting..."
    exit 1
fi

printf "[ Create Swap ] (y/n): "
read -r makeSwap

printf "[ (U)EFI or Legacy ] (u/l): "
read -r uefiOrLegacy

if [[ "$uefiOrLegacy" == "" ]] || [[ -z "$uefiOrLegacy" ]]; then
    echo "[ Error ]: No BIOS Type provided, aborting..."
    exit 1
fi

printf "[ Really Format ] (yes: 'yes, really format'): "
read -r reallyFormat

if [[ "$reallyFormat" != "yes, really format" ]] || [[ -z "$reallyFormat" ]]; then
    echo "[ Error ]: Aborting..."
    exit 1
fi

if [[ "$selDisk" == *nvme* ]]; then
    export selDiskPart="${selDisk}p"
else
    export selDiskPart="${selDisk}"
fi

echo -e "\n===============\n"
echo -e "Summary:\n  Disk: ${selDisk}\n  Part Name: ${selDiskPart}\n  BIOS: ${uefiOrLegacy}\n  Make Swap: ${makeSwap}\n\nReally format? (yes, really format)"
echo -e "\n===============\n"
printf "Really Format?: "
read -r absolutelySureFormat
if [[ "$absolutelySureFormat" != "yes, really format" ]]; then
    echo "[ Error ]: Aborting..."
    exit 1
fi

if [[ "$FORMAT_REAL_WORK" == 1 ]] && [[ -n "$FORMAT_REAL_WORK" ]]; then
    if [[ "$makeSwap" == *y* ]]; then
        if [[ "$uefiOrLegacy" == *u* ]]; then
            sudo parted ${selDisk} --script \
                 mklabel gpt \
                 mkpart primary linux-swap 1MiB 4096MiB \
                 name 1 guix-swap \
                 mkpart ESP fat32 4096MiB 6144MiB \
                 name 2 guix-efi \
                 set 2 esp on \
                 mkpart primary ext4 6144MiB 100% \
                 name 3 guix-root
            sudo mkswap -L guix-swap ${selDiskPart}1
            sudo swapon ${selDiskPart}1
            sudo mkfs.fat -F32 -n guix-efi ${selDiskPart}2
            sudo mkfs.ext4 -L guix-root ${selDiskPart}3
            sudo mount ${selDiskPart}3 /mnt
            sudo mkdir -p /mnt/boot/efi
            sudo mount ${selDiskPart}2 /mnt/boot/efi
        else
            sudo parted ${selDisk} --script \
                 mklabel msdos \
                 mkpart primary linux-swap 1MiB 4096MiB \
                 mkpart primary ext4 4096MiB 100% \
                 set 2 boot on
            sudo mkswap -L guix-swap ${selDiskPart}1
            sudo swapon ${selDiskPart}1
            sudo mkfs.ext4 -L guix-root ${selDiskPart}2
            sudo mount ${selDiskPart}2 /mnt
        fi
    else
        if [[ "$uefiOrLegacy" == *u* ]]; then
            sudo parted ${selDisk} --script \
                 mklabel gpt \
                 mkpart ESP fat32 4096MiB 6144MiB \
                 name 1 guix-efi \
                 set 1 esp on \
                 mkpart primary ext4 6144MiB 100% \
                 name 2 guix-root
            sudo mkfs.fat -F32 -n guix-efi ${selDiskPart}1
            sudo mkfs.ext4 -L guix-root ${selDiskPart}2
            sudo mount ${selDiskPart}2 /mnt
            sudo mkdir -p /mnt/boot/efi
            sudo mount ${selDiskPart}1 /mnt/boot/efi
        else
            sudo parted ${selDisk} --script \
                 mklabel msdos \
                 mkpart primary ext4 1MiB 100% \
                 set 1 boot on
            sudo mkfs.ext4 -L guix-root ${selDiskPart}1
            sudo mount ${selDiskPart}1 /mnt
        fi
    fi
else
    echo -e "\nDisk: ${selDisk}\nPart: ${selDiskPart}\nSwap: ${makeSwap}\nBIOS: ${uefiOrLegacy}\n\nPretending since 'FORMAT_REAL_WORK' does not equal '1'.\n"
fi
