#!/bin/bash

# Quick update script for Retention dashboard

echo "📥 Updating Retention dashboard..."

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Pull latest changes
echo "🔄 Pulling latest changes..."
git pull

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Build the project
echo "🏗️ Building project..."
npm run build

# Deploy
echo "🚀 Deploying to server..."
sudo rm -rf /var/www/retention/*
sudo cp -r build/* /var/www/retention/
sudo chown -R www-data:www-data /var/www/retention

echo -e "${GREEN}✅ Retention Dashboard updated successfully!${NC}"

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}')
echo -e "🌐 Access at: ${GREEN}http://$SERVER_IP/retention/${NC}"
