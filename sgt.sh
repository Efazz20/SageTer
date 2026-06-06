#!/bin/bash
# SageTer - Connect SageMaker Studio Lab to Tailscale (No Sudo Required)

AUTH_KEY="$1"
if [ -z "$AUTH_KEY" ]; then
    echo "❌ Error: Please provide your Tailscale auth key."
    echo "Usage: $0 YOUR_AUTH_KEY"
    exit 1
fi

# Create a working directory
mkdir -p ~/tailscale && cd ~/tailscale

# Download static binaries (no sudo required)
echo ">>> Downloading Tailscale static binaries..."
wget -q https://pkgs.tailscale.com/stable/tailscale_1.84.0_amd64.tgz
tar -xzf tailscale_1.84.0_amd64.tgz
mv tailscale_1.84.0_amd64/* . && rm -r tailscale_1.84.0_amd64*

# Start tailscaled daemon in userspace mode (no root)
echo ">>> Starting tailscaled daemon..."
./tailscaled --tun=userspace-networking --socket=/tmp/tailscaled.sock &

# Give it a moment to initialize
sleep 2

# Authenticate and connect to your tailnet
echo ">>> Connecting to your tailnet..."
./tailscale --socket=/tmp/tailscaled.sock up --auth-key="$AUTH_KEY"

# Get the assigned Tailscale IP
tailscale_ip=$(./tailscale --socket=/tmp/tailscaled.sock ip -4)

echo "✅ Success! Your VM is now on your Tailnet."
echo "   Tailscale IP: $tailscale_ip"
echo ""
echo "🔑 In Termius, create a new host with:"
echo "   Address: $tailscale_ip"
echo "   Username: $(whoami)"
echo "   Port: 22"
echo ""
echo "⚠️  Note: Keep this terminal session open to maintain the connection."
echo "   To run in background, consider using 'screen' or 'tmux'."
