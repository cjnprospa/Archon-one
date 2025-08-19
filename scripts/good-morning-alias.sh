#!/bin/bash

# Create alias for /init command
# Add this to your shell profile (.bashrc, .zshrc, etc.)

echo "Adding Archon good-morning alias to your shell profile..."

ARCHON_DIR="/Users/cjnv3/Documents/Archon-one/Archon-one"
ALIAS_LINE="alias good-morning='$ARCHON_DIR/scripts/good-morning.sh'"

# Detect shell and add to appropriate profile
if [[ $SHELL == *"zsh"* ]]; then
    PROFILE="$HOME/.zshrc"
elif [[ $SHELL == *"bash"* ]]; then
    PROFILE="$HOME/.bashrc"
else
    PROFILE="$HOME/.profile"
fi

# Add alias if it doesn't exist
if ! grep -q "good-morning" "$PROFILE" 2>/dev/null; then
    echo "" >> "$PROFILE"
    echo "# Archon good morning startup command" >> "$PROFILE"
    echo "$ALIAS_LINE" >> "$PROFILE"
    echo "✅ Added good-morning alias to $PROFILE"
    echo "   Run 'source $PROFILE' or restart your terminal to use it"
else
    echo "ℹ️ good-morning alias already exists in $PROFILE"
fi

echo ""
echo "Usage:"
echo "  good-morning        # Start Archon services"
echo "  /good-morning       # Use as Claude Code command"