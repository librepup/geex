#!/usr/bin/env bash

printf "[ Create New V-Disk-Image? ] (y/n) "
read -r createDiskImage
if [[ "$createDiskImage" == *y* ]]; then
    randomString=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)
    vhdisk="virtualHardDisk-${randomString}.img"
    qemu-img create -f qcow2 "$vhdisk" 10G
    echo "[ Created ${vhdisk} at 10GiB Size ]"
fi

printf "[ Specify ISO Path ]: "
read -r isoImgPath
if [[ -z "$isoImgPath" ]]; then
    echo "[ Error: No ISO Provided ]"
    exit 1
fi

if [[ -z "$vhdisk" ]]; then
    printf "[ Specify Virtual Hard-Disk Image Path ]: "
    read -r vhdisk
fi
if [[ -z "$vhdisk" ]]; then
    echo "[ Error: No Virtual Hard-Disk Path Provided ]"
    exit 1
fi

doas qemu-system-x86_64 \
     -enable-kvm \
     -m 4096 \
     -cdrom "$isoImgPath" \
     -drive "$vhdisk" \
     -netdev user,id=net0,hostfwd=tcp::2222-:22 \
     -device virtio-net-pci,netdev=net0
