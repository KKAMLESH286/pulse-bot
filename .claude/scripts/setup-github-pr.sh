#!/bin/bash

# Install GitHub CLI if not present
if ! command -v gh &> /dev/null; then
    echo "Installing GitHub CLI..."
    # For macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install gh
    # For Linux
    else
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update && sudo apt install gh -y
    fi
fi

# Configure gh
echo "Configuring GitHub CLI..."
gh auth login

echo "Setup complete!"
