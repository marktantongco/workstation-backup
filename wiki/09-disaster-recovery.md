# 09 — Disaster Recovery

## Prerequisites

- Hardware: ThinkPad T16v Gen I (or equivalent x86_64 with NVIDIA GPU)
- Storage: 16TB NVMe RAID0 (or large SSD)
- Network: Ethernet (enp0s31f6) or WiFi
- Accounts: GitHub PAT, Cloudflare API key, OpenCode Zen key, OpenCode-Go key, YesCaptcha key
- Backup repo: `git@github.com:marktantongco/workstation-backup.git`

## Phase 1: Base System

### 1.1 Install Omarchy Linux
```bash
# Boot from Omarchy USB installer
# Follow installer prompts (minimal install, GNOME, Wayland)
# Post-install: reboot
```

### 1.2 NVIDIA Drivers
```bash
# Install NVIDIA drivers (580.x)
sudo pacman -S nvidia-utils cuda cudnn
# Reboot
nvidia-smi  # Verify
```

### 1.3 Docker
```bash
sudo pacman -S docker docker-compose
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
# Reboot for group membership
docker --version  # Verify
```

### 1.4 Node.js + pnpm
```bash
# Node 22.x
sudo pacman -S nodejs npm
# pnpm
corepack enable
corepack prepare pnpm@12.3.4 --activate
pnpm --version  # Verify
```

### 1.5 Python
```bash
sudo pacman -S python python-pip python-virtualenv
python3 --version  # Verify
```

### 1.6 Essential Tools
```bash
sudo pacman -S git curl wget ripgrep fd bat fzf htop tmux
```

## Phase 2: Core Infrastructure

### 2.1 Clone Backup Repo
```bash
cd /home/x3/workspace
git clone git@github.com:marktantongco/workstation-backup.git
cd workstation-backup
```

### 2.2 Restore Environment
```bash
# Copy env templates
cp env/ai-agent-tokens-full.env.template ~/.env-tokens/ai-agent-tokens-full.env
cp env/agent-env.template ~/.config/opencode/agent-env

# Fill in actual values (from secure backup or password manager)
vim ~/.env-tokens/ai-agent-tokens-full.env
vim ~/.config/opencode/agent-env

# Regenerate agent-env
# (Follow the env regeneration script if available)
```

### 2.3 Thermoptic
```bash
cd /home/x3/workspace/thermoptic
docker compose up -d
# Verify: docker compose ps (3 containers healthy)
```

### 2.4 PhantomSignal
```bash
cd /home/x3/workspace/phantomsignal
sudo /usr/bin/docker compose up -d
# Verify: docker compose ps (1 container healthy)
```

### 2.5 BlacklistedAIProxy
```bash
cd /home/x3/workspace/BlacklistedAIProxy
pnpm install
# Restore config
cp /path/to/backup/configs/config.json configs/config.json
cp /path/to/backup/configs/ensemble-synthesizer.json configs/ensemble-synthesizer.json

# Install systemd unit
sudo cp /path/to/backup/services/systemd/blacklisted-api.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now blacklisted-api
# Verify: curl http://127.0.0.1:3001/v1/models
```

## Phase 3: AI Gateway

### 3.1 AIClient2API
```bash
# Already installed as systemd service
sudo systemctl enable --now aiclient2api
# Verify: curl http://127.0.0.1:3002/v1/models
```

### 3.2 Freebuff Stack
```bash
sudo systemctl enable --now freebuff-proxy freebuff-unified freebuff2api freebuff2api-admin hermes-sidecar
# Verify: curl http://127.0.0.1:8787/health
```

### 3.3 KiroProxy
```bash
sudo systemctl enable --now kiroproxy
# Verify: curl http://127.0.0.1:3103/v1/models
```

### 3.4 OpenCode
```bash
# Install OpenCode CLI
# Restore config
cp /path/to/backup/opencode/opencode.jsonc ~/.config/opencode/opencode.jsonc
cp -r /path/to/backup/opencode/agents ~/.config/opencode/agents
cp -r /path/to/backup/opencode/commands ~/.config/opencode/commands
cp -r /path/to/backup/opencode/plugins ~/.config/opencode/plugins
# Verify: opencode models
```

## Phase 4: Grok Pipeline

### 4.1 grok-register
```bash
cd /home/x3/workspace
git clone git@github.com:aidil2105/grok-register.git
cd grok-register
pip install -r requirements.txt

# Configure
cp .env.example .env
vim .env  # Fill YESCAPTCHA_KEY, email provider

# Test registration
python3 grok.py --test
```

### 4.2 grokbuild-proxy
```bash
cd /home/x3/workspace
git clone git@github.com:GreyGunG/grokbuild-proxy.git
cd grokbuild-proxy
go build ./cmd/grokbuild-proxy

# Configure
cp .env.example .env
vim .env  # Import SSO tokens or auth JSON

# Run
./grokbuild-proxy
# Verify: curl http://127.0.0.1:8080/v1/models
```

### 4.3 Systemd Units
```bash
# Create and install 4 systemd units
# grok-replenish.service, grok-token-daemon.service, grokbuild-proxy.service
# (See 07-grok-lifecycle.md for unit definitions)
```

## Phase 5: Obsidian Stack

### 5.1 Docker Compose
```bash
cd /home/x3/workspace/obsidian-stack
sudo /usr/bin/docker compose up -d
# Verify: docker compose ps (4 containers healthy)
```

## Phase 6: Monitoring

### 6.1 OWL Stack
```bash
sudo systemctl enable --now owl-agent owl-dns-synergy owl-port-guardian
# Verify: curl http://127.0.0.1:3457/health
```

### 6.2 Prometheus + Grafana
```bash
# Already running in Docker
# Verify: curl http://127.0.0.1:9090/-/healthy
# Verify: curl http://127.0.0.1:3000/api/health
```

## Verification Checklist

```bash
# All services
systemctl list-units --type=service --state=running | grep -E "aiclient|blacklisted|freebuff|kiro|hermes|owl|autoclaw"
sudo /usr/bin/docker ps --format "{{.Names}} {{.Status}}"

# All ports
ss -tlnp | wc -l  # Should be ~61

# OpenCode
opencode models  # Should list all providers
opencode mcp list  # Should show 11 servers

# API endpoints
curl http://127.0.0.1:3001/v1/models  # BlacklistedAIProxy
curl http://127.0.0.1:3002/v1/models  # AIClient2API
curl http://127.0.0.1:8080/v1/models  # grokbuild-proxy
curl http://127.0.0.1:8787/health     # Freebuff
```

## Rollback

If any phase fails:
1. Stop the failed service
2. Restore config from backup
3. Re-run the phase
4. If persistent, check logs: `journalctl -u <service> -f`

## Backup After Recovery

After successful recovery:
```bash
cd /home/x3/workspace/workstation-backup
# Re-sync configs
# Re-run pre-commit secret scan
git add -A && git commit -m "chore: re-sync after recovery" && git push
```
