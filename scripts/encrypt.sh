#!/bin/bash

# 1. Config
SOURCE_DIR="./.local/secrets"
OUTPUT_DIR="./secrets"
# Use the default key file location or set SOPS_AGE_KEY_FILE env var elsewhere
# SOPS will automatically find your public key if you've already encrypted files in this repo

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

echo "🔐 Starting encryption..."

# 2. Function to encrypt safely
encrypt_file() {
    local src=$1
    local dest=$2
    
    if [ -f "$src" ]; then
        sops --encrypt "$src" > "$dest"
        echo "✅ Encrypted: $src -> $dest"
    else
        echo "⚠️  Warning: $src not found, skipping."
    fi
}

# 3. Process Environment Secrets
for env in dev prod; do
    encrypt_file "$SOURCE_DIR/$env.secret.yaml" "$OUTPUT_DIR/$env.secret.enc.yaml"
done

# 4. Process GHCR Tokens
# Note: kept your naming convention but aligned the 'prod' one for consistency
for env in dev prod; do
    encrypt_file "$SOURCE_DIR/$env.ghcr-token.yaml" "$OUTPUT_DIR/$env.ghcr-token.enc.yaml"
done

echo "🚀 All systems go. Ready for git push."