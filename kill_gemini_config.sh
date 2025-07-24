#!/bin/bash

# Path ke file dev.nix
DEV_NIX="$HOME/myapp/.idx/dev.nix"

# Periksa apakah file dev.nix ada
if [ ! -f "$DEV_NIX" ]; then
    echo "[❌] File dev.nix tidak ditemukan di: $DEV_NIX"
    exit 1
fi

# Hapus blok konfigurasi gemini = { ... };
sed -i '/gemini = {/,/};/d' "$DEV_NIX"

echo "[✔] Konfigurasi 'gemini' berhasil dihapus dari dev.nix."
