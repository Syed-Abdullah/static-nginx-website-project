#!/usr/bin/env bash
# Run this on your LOCAL machine (WSL/laptop) to push the site/ folder
# to the server and drop it into Nginx's web root.
#
# Usage: ./deploy-site.sh <path-to-pem-key> <server-ip> [remote-user]
set -euo pipefail

KEY="${1:?Usage: ./deploy-site.sh <key.pem> <server-ip> [user]}"
IP="${2:?Usage: ./deploy-site.sh <key.pem> <server-ip> [user]}"
USER="${3:-ubuntu}"
LOCAL_SITE_DIR="$(dirname "$0")/../site"

echo "==> Copying site files to $USER@$IP:/tmp/site/"
ssh -i "$KEY" "$USER@$IP" "mkdir -p /tmp/site"
scp -i "$KEY" -r "$LOCAL_SITE_DIR"/* "$USER@$IP:/tmp/site/"

echo "==> Moving files into /var/www/html on the server"
ssh -i "$KEY" "$USER@$IP" bash -s <<'EOF'
sudo rm -rf /var/www/html/*
sudo cp -r /tmp/site/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html
sudo systemctl reload nginx
EOF

echo "==> Done. Visit http://$IP to verify."
