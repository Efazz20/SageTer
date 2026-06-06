#!/bin/bash
# setup-tailscale.sh - Connects SageMaker Studio Lab to your Tailscale tailnet
# Usage: bash setup-tailscale.sh YOUR_AUTH_KEY

set -e

AUTH_KEY="$1"
if [ -z "$AUTH_KEY" ]; then
    echo "❌ Usage: $0 YOUR_TAILSCALE_AUTH_KEY"
    exit 1
fi

# Install SSH server if missing
if ! pgrep -f "sshd" > /dev/null; then
    echo ">>> Setting up SSH server..."
    sudo apt-get update -qq
    sudo apt-get install -y -qq openssh-server
    sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    sudo systemctl restart ssh
fi

# Install Tailscale if missing
if ! command -v tailscale &> /dev/null; then
    echo ">>> Installing Tailscale..."
    curl -fsSL https://tailscale.com/install.sh | sh
fi

# Connect to tailnet
echo ">>> Connecting to your Tailnet..."
sudo tailscale up --ssh --auth-key "$AUTH_KEY"

echo "✅ Connected! Tailscale IP: $(tailscale ip -4)"
