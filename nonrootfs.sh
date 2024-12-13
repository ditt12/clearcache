#!/bin/bash

echo "Mengecek aplikasi yang berjalan di latar belakang..."

APPS=$(adb shell "pm list packages -3" | awk -F: '{print $2}')

for APP in $APPS; do
  adb shell "am force-stop $APP"
  echo "Menghentikan aplikasi: $APP"
done

echo "Semua aplikasi latar belakang telah dihentikan."

echo "Download lagi kalo mau run"

> $0