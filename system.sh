#!/bin/bash

# Fungsi untuk menampilkan teks hijau
green_text() {
    echo -e "\033[32m$1\033[0m"
}

# Fungsi untuk menampilkan teks merah
red_text() {
    echo -e "\033[31m$1\033[0m"
}

clear

green_text "Menghapus data sistem yang tidak penting..."

# Cek apakah perangkat sudah ter-root
if [ "$(id -u)" -eq 0 ]; then
    root_status="root"
else
    root_status="non-root"
fi

# Direktori yang akan dibersihkan
directories=(
    "/cache"               # Cache sistem
    "/data/dalvik-cache"   # Dalvik cache
    "/data/system"         # Data sistem
    "/data/app"             # Aplikasi yang tidak terpakai
    "/data/data/*/cache"    # Cache aplikasi
    "/data/media"           # Data media yang bisa dibersihkan
)

# Menyimpan total ukuran data sebelum dihapus
total_size_before=0
for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        size=$(du -s $dir 2>/dev/null | awk '{sum += $1} END {print sum}')
        total_size_before=$(expr $total_size_before + $size)
    fi
done

# Proses penghapusan data
for dir in "${directories[@]}"; do
    green_text "Menghapus data di $dir ..."
    
    if [ -d "$dir" ]; then
        rm -rf $dir/* 2>/dev/null
    fi
done

# Menghitung total ukuran data setelah dihapus
total_size_after=0
for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        size=$(du -s $dir 2>/dev/null | awk '{sum += $1} END {print sum}')
        total_size_after=$(expr $total_size_after + $size)
    fi
done

# Menghitung data yang berhasil dihapus
total_size_removed=$(expr $total_size_before - $total_size_after)

if [ "$total_size_removed" -gt 0 ]; then
    green_text "Data sistem yang tidak penting sebesar ${total_size_removed} KB telah berhasil dihapus!"
else
    red_text "Tidak ada data yang dapat dihapus atau data terlalu kecil untuk dihitung!"
fi


echo "Download lagi kalo mau run"

> $0