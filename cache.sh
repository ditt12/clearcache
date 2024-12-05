#!/bin/bash

green_text() {
    echo -e "\033[32m$1\033[0m"
}

red_text() {
    echo -e "\033[31m$1\033[0m"
}

clear

grep "Hardware" /proc/cpuinfo | sed 's/.*/\x1b[32m&\x1b[0m/'

clear

green_text "Menghapus cache aplikasi..."

if [ "$(id -u)" -eq 0 ]; then
    root_status="root"
else
    root_status="non-root"
fi

cache_size_before=$(du -sh /storage/emulated/0/Android/data/*/cache/ 2>/dev/null | awk '{sum += $1} END {print sum}' | sed 's/[a-zA-Z]//g')
cache_size_before_ext=$(du -sh /data/data/*/cache/ 2>/dev/null | awk '{sum += $1} END {print sum}' | sed 's/[a-zA-Z]//g')

cache_size_extra=$(du -sh /data/data/*/app_cache/ 2>/dev/null | awk '{sum += $1} END {print sum}' | sed 's/[a-zA-Z]//g')

total_cache_before=$(echo "$cache_size_before + $cache_size_before_ext + $cache_size_extra" | bc)

if [ -z "$cache_size_before" ]; then
    cache_size_before=0
fi
if [ -z "$cache_size_before_ext" ]; then
    cache_size_before_ext=0
fi
if [ -z "$cache_size_extra" ]; then
    cache_size_extra=0
fi

green_text "Menghapus cache di /storage/emulated/0/Android/data/*/cache/ ..."
rm -rf /storage/emulated/0/Android/data/*/cache/* 2>/dev/null

green_text "Menghapus cache di /data/data/*/cache/ ..."
rm -rf /data/data/*/cache/* 2>/dev/null

green_text "Menghapus cache di /data/data/*/app_cache/ ..."
rm -rf /data/data/*/app_cache/* 2>/dev/null

cache_size_after=$(du -sh /storage/emulated/0/Android/data/*/cache/ 2>/dev/null | awk '{sum += $1} END {print sum}' | sed 's/[a-zA-Z]//g')
cache_size_after_ext=$(du -sh /data/data/*/cache/ 2>/dev/null | awk '{sum += $1} END {print sum}' | sed 's/[a-zA-Z]//g')
cache_size_after_extra=$(du -sh /data/data/*/app_cache/ 2>/dev/null | awk '{sum += $1} END {print sum}' | sed 's/[a-zA-Z]//g')

if [ -z "$cache_size_after" ]; then
    cache_size_after=0
fi
if [ -z "$cache_size_after_ext" ]; then
    cache_size_after_ext=0
fi
if [ -z "$cache_size_after_extra" ]; then
    cache_size_after_extra=0
fi

total_cache_after=$(echo "$cache_size_after + $cache_size_after_ext + $cache_size_after_extra" | bc)
total_cache_removed=$(echo "$total_cache_before - $total_cache_after" | bc)

if [ $(echo "$total_cache_removed > 0" | bc) -eq 1 ]; then
    green_text "Cache sebesar ${total_cache_removed} MB telah berhasil dihapus!"
else
    red_text "Tidak ada cache yang dapat dihapus atau cache terlalu kecil untuk dihitung!"
fi
