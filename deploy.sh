#!/bin/bash

# Retention Dashboard Deployment Script
# Deploys retention dashboard alongside existing dashboards

set -e

echo "🚀 Starting Retention Dashboard deployment..."

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Variables
PROJECT_DIR="retention-dashboard"
BUILD_DIR="build"
DEPLOY_DIR="/var/www/retention"
NGINX_SITE="dashboards"

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if running as root or with sudo
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root or with sudo"
   exit 1
fi

# Check system requirements
print_info "Checking system requirements..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_warning "Node.js not found. Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    apt-get install -y nodejs
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    print_error "npm not found. Please install npm."
    exit 1
fi

# Check if nginx is installed
if ! command -v nginx &> /dev/null; then
    print_warning "Nginx not found. Installing Nginx..."
    apt-get update
    apt-get install -y nginx
fi

print_status "System requirements checked"

# Install dependencies
print_status "Installing dependencies..."
npm install

# IMPORTANT: Set homepage for subfolder deployment
print_status "Setting homepage for subfolder deployment..."
# Add homepage to package.json for correct asset paths
sed -i '/"private": true,/a\  "homepage": "/retention",' package.json

# Build the project
print_status "Building React app..."
npm run build

# Create deployment directory
print_status "Creating deployment directory..."
mkdir -p $DEPLOY_DIR

# Backup existing deployment if it exists
if [ -d "$DEPLOY_DIR" ] && [ "$(ls -A $DEPLOY_DIR)" ]; then
    mv "$DEPLOY_DIR" "${DEPLOY_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$DEPLOY_DIR"
    print_status "Existing deployment backed up"
fi

# Copy build files
print_status "Copying build files..."
cp -r build/* $DEPLOY_DIR/

# Set permissions
print_status "Setting permissions..."
chown -R www-data:www-data $DEPLOY_DIR
chmod -R 755 $DEPLOY_DIR

# Update Nginx configuration
print_status "Updating Nginx configuration..."

# Create updated Nginx config with Retention dashboard
cat > "/etc/nginx/sites-available/${NGINX_SITE}" << 'EOF'
server {
    listen 80;
    server_name _;

    # Root directory for default content
    root /var/www/html;
    index index.html index.htm;

    # Default location
    location / {
        try_files $uri $uri/ =404;
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
        add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';
    }

    # INTRA Dashboard location (existing)
    location /intra {
        alias /var/www/intra;
        index index.html;
        try_files $uri $uri/ /intra/index.html;

        # CORS headers for dashboard
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
        add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';

        # Cache static assets
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }

    # Enterprise Lead Dashboard location (existing)
    location /enterprise {
        alias /var/www/enterprise;
        index index.html;
        try_files $uri $uri/ /enterprise/index.html;

        # Handle React Router for SPA
        location ~ ^/enterprise/(.*)$ {
            try_files $uri $uri/ /enterprise/index.html;
        }

        # CORS headers for dashboard
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
        add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';

        # Cache static assets
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }

    # LFM Dashboard location (existing)
    location /lfm {
        alias /var/www/lfm;
        index index.html;
        try_files $uri $uri/ /lfm/index.html;

        # Handle React Router for SPA
        location ~ ^/lfm/(.*)$ {
            try_files $uri $uri/ /lfm/index.html;
        }

        # CORS headers for dashboard
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
        add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';

        # Cache static assets
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }

    # Retention Dashboard location (new)
    location /retention {
        alias /var/www/retention;
        index index.html;
        try_files $uri $uri/ /retention/index.html;

        # Handle React Router for SPA
        location ~ ^/retention/(.*)$ {
            try_files $uri $uri/ /retention/index.html;
        }

        # CORS headers for dashboard
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
        add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';

        # Cache static assets
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }

    # Health check endpoint
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }

    # Dashboard status endpoint
    location /status {
        access_log off;
        return 200 '{"intra": "online", "enterprise": "online", "lfm": "online", "retention": "online"}';
        add_header Content-Type application/json;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private auth;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/x-javascript
        application/xml+rss
        application/javascript
        application/json;
}
EOF

print_status "Nginx configuration updated"

# Enable the site (if not already enabled)
if [ ! -L "/etc/nginx/sites-enabled/${NGINX_SITE}" ]; then
    ln -sf "/etc/nginx/sites-available/${NGINX_SITE}" "/etc/nginx/sites-enabled/"
    print_status "Nginx site enabled"
fi

# Remove default site if it exists
if [ -L "/etc/nginx/sites-enabled/default" ]; then
    rm "/etc/nginx/sites-enabled/default"
    print_status "Default Nginx site removed"
fi

# Test Nginx configuration
print_info "Testing Nginx configuration..."
nginx -t
if [ $? -ne 0 ]; then
    print_error "Nginx configuration test failed!"
    exit 1
fi
print_status "Nginx configuration is valid"

# Restart Nginx
print_info "Restarting Nginx service..."
systemctl restart nginx
if [ $? -ne 0 ]; then
    print_error "Failed to restart Nginx"
    exit 1
fi
print_status "Nginx restarted successfully"

# Create update script for future deployments
print_info "Creating update script..."
cat > "/usr/local/bin/update-retention-dashboard" << 'EOF'
#!/bin/bash

# Quick update script for Retention dashboard
echo "📥 Updating Retention dashboard..."

# Build and deploy
npm run build
sudo rm -rf /var/www/retention/*
sudo cp -r build/* /var/www/retention/
sudo chown -R www-data:www-data /var/www/retention

echo "✅ Retention Dashboard updated successfully!"
EOF

chmod +x "/usr/local/bin/update-retention-dashboard"
print_status "Update script created at /usr/local/bin/update-retention-dashboard"

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}')

echo ""
echo "=========================================="
echo -e "${GREEN}✅ All dashboards deployed successfully!${NC}"
echo "=========================================="
echo ""
echo "📊 Access your dashboards:"
echo -e "🏢 INTRA Dashboard: ${GREEN}http://$SERVER_IP/intra/${NC}"
echo -e "🏢 Enterprise Dashboard: ${GREEN}http://$SERVER_IP/enterprise/${NC}"
echo -e "🎯 LFM Dashboard: ${GREEN}http://$SERVER_IP/lfm/${NC}"
echo -e "📊 Retention Dashboard: ${GREEN}http://$SERVER_IP/retention/${NC}"
echo ""
echo "📝 Directory structure:"
echo "  - INTRA: /var/www/intra/"
echo "  - Enterprise: /var/www/enterprise/"
echo "  - LFM: /var/www/lfm/"
echo "  - Retention: /var/www/retention/"
echo ""
echo "🔄 To update Retention dashboard in future:"
echo "  sudo /usr/local/bin/update-retention-dashboard"
echo ""
echo "📋 Status endpoints:"
echo -e "  - Health: ${GREEN}http://$SERVER_IP/health${NC}"
echo -e "  - Status: ${GREEN}http://$SERVER_IP/status${NC}"
echo ""
print_status "Deployment completed successfully!"
