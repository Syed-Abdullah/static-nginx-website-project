#!/usr/bin/env bash
# Run this ON the Ubuntu server (via SSH).
# Installs and starts Nginx, opens firewall if ufw is active.
set -euo pipefail

echo "==> Updating packages"
sudo apt update && sudo apt upgrade -y

echo "==> Installing nginx"
sudo apt install nginx -y

echo "==> Enabling nginx on boot"
sudo systemctl enable nginx
sudo systemctl start nginx

if command -v ufw >/dev/null 2>&1 && sudo ufw status | grep -q "Status: active"; then
  echo "==> ufw active, allowing HTTP"
  sudo ufw allow 'Nginx HTTP'
fi

echo "==> Done. Status:"
sudo systemctl status nginx --no-pager
echo
echo "Visit http://<your-server-ip> to confirm the default Nginx page loads."
