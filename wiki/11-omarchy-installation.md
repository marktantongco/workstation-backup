# Omarchy Linux Workstation — Complete Installation Prompt

## System Requirements

- **Hardware**: ThinkPad T16v Gen I (or equivalent x86_64 with NVIDIA GPU)
- **CPU**: Intel Core Ultra 9 285HX (or equivalent)
- **GPU**: NVIDIA RTX Pro 3500 Blackwell (or equivalent, 16GB+ VRAM)
- **RAM**: 93GB+ (2x 48GB DDR5)
- **Storage**: 16TB NVMe RAID0 (or 4TB+ SSD)
- **Network**: Ethernet (enp0s31f6) or WiFi
- **USB**: 8GB+ for installer

## Phase 0: Pre-Installation

### 0.1 Backup Current System
```bash
# If migrating from another system
# Export passwords, SSH keys, GPG keys
# Backup important data
# Document current service configurations
```

### 0.2 Download Omarchy
```bash
# Download latest Omarchy ISO
# Write to USB: sudo dd if=omarchy.iso of=/dev/sdX bs=4M status=progress
# Boot from USB (F12 for boot menu on ThinkPad)
```

## Phase 1: Base System Installation

### 1.1 Omarchy Installer
```
1. Boot from USB
2. Select "Install Omarchy"
3. Language: English
4. Keyboard: US (or your layout)
5. Timezone: Asia/Jakarta (or your timezone)
6. Partitions:
   - /boot/efi: 512MB FAT32
   - /: 16TB ext4 (or your RAID array)
   - swap: 32GB (or match RAM)
7. User: x3 (or your username)
8. Password: (set strong password)
9. Install and reboot
```

### 1.2 Post-Install Update
```bash
sudo pacman -Syu
sudo reboot
```

## Phase 2: NVIDIA + CUDA

### 2.1 Install NVIDIA Drivers
```bash
# Install NVIDIA drivers (580.x)
sudo pacman -S nvidia-utils

# Install CUDA toolkit
sudo pacman -S cuda cudnn

# Reboot
sudo reboot

# Verify
nvidia-smi
# Should show: NVIDIA RTX Pro 3500 Blackwell, CUDA 13.0
```

### 2.2 CUDA Environment
```bash
# Add to ~/.bashrc
echo 'export PATH=/opt/cuda/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc

# Verify
nvcc --version
```

## Phase 3: Core Dependencies

### 3.1 System Tools
```bash
sudo pacman -S \
  git curl wget \
  ripgrep fd bat fzf \
  htop tmux neovim \
  base-devel \
  python python-pip python-virtualenv \
  nodejs npm \
  go rust \
  docker docker-compose \
  tlp thermald \
  Mullvad-vpn \
  tailscaled \
  gnome-tweaks \
  firefox \
  discord \
  obsidian
```

### 3.2 Docker
```bash
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
sudo reboot

# Verify
docker --version
docker compose version
```

### 3.3 Node.js + pnpm
```bash
corepack enable
corepack prepare pnpm@12.3.4 --activate

# Verify
node --version  # Should be v22.x
pnpm --version  # Should be 12.3.4
```

### 3.4 Python
```bash
# Create virtual environments for projects
python3 -m venv ~/.venvs/grok-register
source ~/.venvs/grok-register/bin/activate
pip install curl_cffi requests yes-captcha
```

## Phase 4: Network Configuration

### 4.1 Mullvad VPN
```bash
# Install Mullvad
sudo pacman -S Mullvad-vpn

# Login
mullvad account login

# Connect
mullvad connect

# Verify
mullvad status
```

### 4.2 Tailscale
```bash
sudo systemctl enable --now tailscaled
sudo tailscale up

# Verify
tailscale status
```

### 4.3 DNS
```bash
# Configure DNS resolution
# Mullvad handles DNS when connected
# Tailscale MagicDNS for mesh network
```

## Phase 5: AI Gateway Stack

### 5.1 Thermoptic (Chrome MITM Proxy)
```bash
cd /home/x3/workspace
git clone https://github.com/nicepkg/thermoptic.git
cd thermoptic
docker compose up -d

# Verify
docker compose ps
# Should show 3 containers: thermoptic, chrome, proxyrouter
```

### 5.2 PhantomSignal (Rotating Proxies)
```bash
cd /home/x3/workspace
git clone https://github.com/your-repo/phantomsignal.git
cd phantomsignal
sudo /usr/bin/docker compose up -d

# Verify
sudo /usr/bin/docker ps | grep phantomsignal
# Should show: phantomsignal Up (healthy)
```

### 5.3 BlacklistedAIProxy
```bash
cd /home/x3/workspace
git clone https://github.com/your-repo/BlacklistedAIProxy.git
cd BlacklistedAIProxy

# Install dependencies
pnpm install

# Configure
cp configs/config.json.example configs/config.json
cp configs/ensemble-synthesizer.json.example configs/ensemble-synthesizer.json

# Edit configs/config.json
# - SERVER_PORT: 3001
# - PROXY_URL: http://127.0.0.1:1234
# - PROXY_ENABLED_PROVIDERS: ["grok", "grok-custom"]

# Create systemd unit
sudo tee /etc/systemd/system/blacklisted-api.service << 'EOF'
[Unit]
Description=BlacklistedAIProxy
After=network.target docker.service

[Service]
Type=simple
User=x3
WorkingDirectory=/home/x3/workspace/BlacklistedAIProxy
ExecStart=/usr/bin/node src/core/master.js
Restart=always
RestartSec=5
Environment=MASTER_PORT=3101

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now blacklisted-api

# Verify
curl http://127.0.0.1:3001/v1/models
```

### 5.4 AIClient2API
```bash
# Already installed as systemd service
sudo systemctl enable --now aiclient2api

# Verify
curl http://127.0.0.1:3002/v1/models
```

### 5.5 Freebuff Stack
```bash
sudo systemctl enable --now \
  freebuff-proxy \
  freebuff-unified \
  freebuff2api \
  freebuff2api-admin \
  hermes-sidecar

# Verify
curl http://127.0.0.1:8787/health
```

### 5.6 KiroProxy
```bash
sudo systemctl enable --now kiroproxy

# Verify
curl http://127.0.0.1:3103/v1/models
```

## Phase 6: Grok Account Automation

### 6.1 grok-register
```bash
cd /home/x3/workspace
git clone https://github.com/aidil2105/grok-register.git
cd grok-register

# Install dependencies
pip install -r requirements.txt

# Configure
cp .env.example .env
vim .env
# Fill in:
# - YESCAPTCHA_KEY: your-yes-captcha-api-key
# - Email provider credentials

# Test registration
python3 grok.py --test
```

### 6.2 grokbuild-proxy
```bash
cd /home/x3/workspace
git clone https://github.com/GreyGunG/grokbuild-proxy.git
cd grokbuild-proxy

# Build
go build ./cmd/grokbuild-proxy

# Configure
cp .env.example .env
vim .env
# Import SSO tokens or auth JSON files

# Run
./grokbuild-proxy

# Verify
curl http://127.0.0.1:8080/v1/models
```

### 6.3 Systemd Units
```bash
# Create grok-replenish.service
sudo tee /etc/systemd/system/grok-replenish.service << 'EOF'
[Unit]
Description=Grok Account Replenishment Daemon
After=network.target

[Service]
Type=simple
User=x3
WorkingDirectory=/home/x3/workspace/grok-register
ExecStart=/home/x3/.venvs/grok-register/bin/python3 auto_replenish.py
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
EOF

# Create grok-token-daemon.service
sudo tee /etc/systemd/system/grok-token-daemon.service << 'EOF'
[Unit]
Description=Grok Token Refresh Daemon
After=network.target

[Service]
Type=simple
User=x3
WorkingDirectory=/home/x3/workspace/grok-register
ExecStart=/home/x3/.venvs/grok-register/bin/python3 token_daemon.py
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
EOF

# Create grokbuild-proxy.service
sudo tee /etc/systemd/system/grokbuild-proxy.service << 'EOF'
[Unit]
Description=Grok Build Proxy
After=network.target docker.service

[Service]
Type=simple
User=x3
WorkingDirectory=/home/x3/workspace/grokbuild-proxy
ExecStart=/home/x3/workspace/grokbuild-proxy/grokbuild-proxy
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now grok-replenish grok-token-daemon grokbuild-proxy
```

## Phase 7: Obsidian Stack

### 7.1 Docker Compose
```bash
cd /home/x3/workspace
git clone https://github.com/your-repo/obsidian-stack.git
cd obsidian-stack
sudo /usr/bin/docker compose up -d

# Verify
sudo /usr/bin/docker compose ps
# Should show: khoj, anythingllm, qdrant, khoj-db (all healthy)
```

## Phase 8: Monitoring

### 8.1 OWL Stack
```bash
sudo systemctl enable --now owl-agent owl-dns-synergy owl-port-guardian

# Verify
curl http://127.0.0.1:3457/health
```

### 8.2 Prometheus + Grafana
```bash
# Already running in Docker
# Verify
curl http://127.0.0.1:9090/-/healthy
curl http://127.0.0.1:3000/api/health
```

## Phase 9: OpenCode

### 9.1 Install OpenCode CLI
```bash
# Install OpenCode
# Follow official installation instructions

# Restore config
cp /path/to/backup/opencode/opencode.jsonc ~/.config/opencode/opencode.jsonc
cp -r /path/to/backup/opencode/agents ~/.config/opencode/agents
cp -r /path/to/backup/opencode/commands ~/.config/opencode/commands
cp -r /path/to/backup/opencode/plugins ~/.config/opencode/plugins

# Verify
opencode models
opencode mcp list
```

### 9.2 Environment
```bash
# Restore environment files
cp env/ai-agent-tokens-full.env.template ~/.env-tokens/ai-agent-tokens-full.env
cp env/agent-env.template ~/.config/opencode/agent-env

# Fill in actual values
vim ~/.env-tokens/ai-agent-tokens-full.env
vim ~/.config/opencode/agent-env
```

## Phase 10: Verification

### 10.1 All Services
```bash
# Systemd services
systemctl list-units --type=service --state=running | grep -E \
  "aiclient|blacklisted|freebuff|kiro|hermes|owl|autoclaw"

# Docker containers
sudo /usr/bin/docker ps --format "{{.Names}} {{.Status}}"
```

### 10.2 All Ports
```bash
# Should be ~61 listening ports
ss -tlnp | grep -v "^State" | wc -l

# Check for conflicts
ss -tlnp | awk '{print $4}' | sort -t: -k2 -n | uniq -d
```

### 10.3 API Endpoints
```bash
curl http://127.0.0.1:3001/v1/models  # BlacklistedAIProxy
curl http://127.0.0.1:3002/v1/models  # AIClient2API
curl http://127.0.0.1:8080/v1/models  # grokbuild-proxy
curl http://127.0.0.1:8787/health     # Freebuff
curl http://127.0.0.1:9090/-/healthy # Prometheus
curl http://127.0.0.1:3000/api/health # Grafana
```

### 10.4 OpenCode
```bash
opencode models          # Should list all providers
opencode mcp list        # Should show 11 servers
opencode debug config    # Should show resolved config
```

## Troubleshooting

### Docker Permission Denied
```bash
# If rtk docker fails
sudo /usr/bin/docker ps

# Or add user to docker group
sudo usermod -aG docker $USER
# Reboot for group membership
```

### Port Conflicts
```bash
# Find conflicting service
ss -tlnp | grep :<PORT>

# Stop conflicting service
sudo systemctl stop <service>
```

### NVIDIA Issues
```bash
# Check driver
nvidia-smi

# If not working
sudo pacman -S nvidia-utils
sudo reboot
```

### Service Won't Start
```bash
# Check logs
journalctl -u <service> -f

# Check config
cat /etc/systemd/system/<service>.service
```

## Post-Installation

### 1. Backup Recovery
```bash
cd /home/x3/workspace/workstation-backup
git remote -v  # Should point to your backup repo
```

### 2. Security Hardening
```bash
# Follow wiki/05-hardening.md
# Rotate all secrets
# Enable firewall
# Configure fail2ban
```

### 3. Documentation
```bash
# Read wiki for architecture details
ls /home/x3/workspace/workstation-backup/wiki/
```

## Estimated Time

| Phase | Time |
|-------|------|
| Phase 1: Base System | 30 min |
| Phase 2: NVIDIA + CUDA | 15 min |
| Phase 3: Core Dependencies | 20 min |
| Phase 4: Network | 10 min |
| Phase 5: AI Gateway | 30 min |
| Phase 6: Grok Pipeline | 20 min |
| Phase 7: Obsidian Stack | 10 min |
| Phase 8: Monitoring | 10 min |
| Phase 9: OpenCode | 15 min |
| Phase 10: Verification | 15 min |
| **Total** | **~3 hours** |

## Notes

- All commands assume user `x3`
- Docker commands may need `sudo /usr/bin/docker` depending on group membership
- Thermoptic MITM proxy returns empty body for HTTP (by design — use HTTPS)
- PhantomSignal Docker build requires `wheels→PyPI` fix in Dockerfile
- grok-register requires YesCaptcha API key (purchase from yes-captcha.com)
- grokbuild-proxy requires Go 1.24+ for build
