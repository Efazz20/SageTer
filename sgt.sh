#!/bin/bash
# SageTer - SSH into SageMaker Studio Lab from Android using Tailscale (no sudo required)

set -e

AUTH_KEY="$1"
if [ -z "$AUTH_KEY" ]; then
    echo "❌ Error: Please provide your Tailscale auth key."
    echo "Usage: $0 YOUR_AUTH_KEY"
    exit 1
fi

# Install Tailscale user-wide
echo ">>> Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh -s -- --user

# Add ~/.local/bin to PATH for this session
export PATH="$HOME/.local/bin:$PATH"

# Start Tailscale with SSH
echo ">>> Connecting to your Tailnet..."
~/.local/bin/tailscale up --ssh --auth-key="$AUTH_KEY"

echo "✅ Success! Your VM is now on your Tailnet."
echo "   Tailscale IP: $(~/.local/bin/tailscale ip -4)"
echo ""
echo "🔑 In Termius, create a new host with:"
echo "   Address: $(~/.local/bin/tailscale ip -4)"
echo "   Username: $(whoami)"
echo "   Port: 22"
