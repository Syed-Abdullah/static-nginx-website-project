# Static Website Deployment with Nginx

A basic hands-on DevOps project: spin up an Ubuntu server, install Nginx,
and deploy a static website to it — validated over the server's public IP.

**Stack:** Ubuntu 22.04 · Nginx · AWS EC2 · SCP

---

## What this project demonstrates

| # | Task | Concept |
|---|------|---------|
| 1 | Spin up an Ubuntu EC2 instance | Linux / AWS |
| 2 | SSH in and install Nginx | Linux / Webserver |
| 3 | Download static HTML site | Web hosting basics |
| 4 | SCP files to Nginx web root | Secure file transfer |
| 5 | Validate via public IP | HTTP smoke test |

---

## Step-by-step walkthrough

### 1. Spin up an Ubuntu server
AWS Console → EC2 → Launch Instance:
- AMI: **Ubuntu 22.04 LTS**
- Instance type: `t2.micro` (free tier eligible)
- Region: `ap-south-1` (Mumbai) or whatever's closest to you
- Key pair: create/download a `.pem` key
- Security Group: allow inbound **22 (SSH), 80 (HTTP)**
- Allocate and associate an **Elastic IP** so the IP is stable across reboots.

### 2. SSH in and install Nginx
```bash
chmod 400 your-key.pem
ssh -i your-key.pem ubuntu@<ELASTIC_IP>

sudo apt update && sudo apt upgrade -y
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl status nginx
```
Or run [`scripts/install-nginx.sh`](scripts/install-nginx.sh) on the server.

### 3. Download HTML website files
Use the sample site in [`site/`](site/) in this repo, or grab any free
HTML template.
```bash
git clone <this-repo-url>
```

### 4. Copy files to the server with SCP
From your local machine:
```bash
scp -i your-key.pem -r site/* ubuntu@<ELASTIC_IP>:/tmp/site/
```
Then on the server:
```bash
sudo rm -rf /var/www/html/*
sudo cp -r /tmp/site/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html
```
Or use [`scripts/deploy-site.sh`](scripts/deploy-site.sh) to do steps 3–4
from your local machine in one command.

### 5. Validate via IP
```
http://<ELASTIC_IP>
```
If it doesn't load: check the security group (port 80 open?) and
`sudo systemctl status nginx`.

---

## Troubleshooting notes

- **Nginx installed but site not loading over IP** → check security group
  inbound rules, and `sudo ufw status` (disable or allow 80 if ufw is on).
- **Permission denied on `/var/www/html`** → make sure you're using `sudo`
  for the copy/chown steps.
- **SCP connection refused** → check the security group allows port 22 from
  your IP, and you're using the right key/user (`ubuntu` for Ubuntu AMIs).

## Repo structure
```
.
├── README.md
├── site/                 # sample static site to deploy
│   ├── index.html
│   └── style.css
└── scripts/
    ├── install-nginx.sh
    └── deploy-site.sh
```
