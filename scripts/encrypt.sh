#!/bin/bash

# Configuration
RAW_DIR="./.local/secrets"
DEST_DIR="./secrets"

# Ensure destination exists
mkdir -p "$DEST_DIR"

echo "🔐 Starting secret encryption..."

# Loop through dev and prod
for env in dev prod; do
    INPUT="$RAW_DIR/$env.secret.yaml"
    OUTPUT="$DEST_DIR/$env.secret.enc.yaml"

    if [ -f "$INPUT" ]; then
        # SOPS will automatically pick up rules from .sops.yaml
        sops --encrypt "$INPUT" > "$OUTPUT"
        
        if [ $? -eq 0 ]; then
            echo "✅ Successfully encrypted $env -> $OUTPUT"
        else
            echo "❌ Failed to encrypt $env"
        fi
    else
        echo "⚠️  File not found: $INPUT"
    fi
done

echo "---"
echo "Check your 'secrets/' folder. 'kind: Secret' should now be readable."