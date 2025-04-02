#!/bin/bash

# Install Nginx and AWS CLI
sudo apt update
sudo apt install -y nginx aws-cli

# Create directory for website content
sudo mkdir -p /var/www/html

# Create health check endpoint
sudo mkdir -p /var/www/html/health
echo "OK" | sudo tee /var/www/html/health/index.html

# Download content from S3 (using the actual bucket name)
aws s3 sync s3://prog8830-g1-lab08-${random_id.bucket_suffix.hex}/webcontent/ /var/www/html/

# Configure Nginx
sudo tee /etc/nginx/sites-available/default << EOF
server {
    listen 80;
    server_name _;
    root /var/www/html;
    index index.html;

    # Health check endpoint
    location /health {
        access_log off;
        return 200 'OK';
        add_header Content-Type text/plain;
    }

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Restart Nginx
sudo systemctl restart nginx
