#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "Root akses diperlukan. Jalankan script ini dengan akses root."
  exit 1
fi

echo "Mengecek semua proses yang berjalan..."

PIDS=$(ps -A | awk '{print $1}' | tail -n +2)  

for PID in $PIDS; do
  kill -9 $PID
  echo "Menghentikan proses dengan PID: $PID"
done

echo "Semua proses latar belakang telah dihentikan."

echo "Download lagi kalo mau run"

> $0