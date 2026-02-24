#!/usr/bin/env sh

echo -e "\n================\n"
echo -e "  Create Wifi.conf"
echo -e "\n================\n"

printf "[ Network SSID/Name ]: "
read -r networkSSID

if [[ "$networkSSID" == "" ]] || [[ -z "$networkSSID" ]]; then
    echo "[ Error ]: No name provided, aborting..."
    exit 1
fi

printf "[ Is Network Protected? ] (y/n): "
read -r networkProtection

if [[ "$networkProtection" == *y* ]]; then
    keyManagement="WPA-PSK"
elif [[ "$networkProtection" == "" ]] || [[ -z "$networkProtection" ]]; then
    echo "[ Error ]: No protection type specified, assuming no protection..."
    export keyManagement="NONE"
else
    keyManagement="NONE"
fi

if [[ "$keyManagement" != "NONE" ]]; then
    printf "[ Network Password ]: "
    read -r networkPassword
    if [[ "$networkPassword" == "" ]] || [[ -z "$networkPassword" ]]; then
        echo "[ Error ]: No password specified, aborting..."
        exit 1
    fi
fi

randomString=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)
confName="wifi-${randomString}.conf"
echo -e "network={\n  ssid=\"${networkSSID}\"\n  key_mgmt=${keyManagement}\n  priority=1" >> /tmp/${confName}

if [[ "$networkPassword" != "" ]] || [[ -n "$networkPassword" ]]; then
    echo -e "  psk=\"${networkPassword}\"\n}" >> /tmp/${confName}
else
    echo -e "}" >> /tmp/${confName}
fi

echo -e "\n[ Status ]: Done, at '/tmp/${confName}'.\n"
