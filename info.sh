#!/bin/bash

bit=$(uname -m | grep -q "64" && echo "64-bit" || echo "32-bit")
device_name=$(getprop ro.product.model)
available_storage=$(df -h /data | awk 'NR==2 {print $4}')

type_text() {
    local text="$1"
    i=0
    while [ $i -lt ${#text} ]; do
        printf "%s" "$(echo $text | cut -c $((i+1))-$((i+1)))"
        sleep 0.05
        i=$((i+1))
    done
    printf "\n"
}

type_text "\033[32mDeveloper:\033[0m Asrv"
type_text "\033[32mdevice name:\033[0m $device_name"
type_text "\033[32mphone bit:\033[0m $bit"
type_text "\033[32mavailable storage:\033[0m $available_storage"