# Deployment Guide - BookStore

This guide covers deploying BookStore to production environments.

## ⚠️ Pre-Deployment Checklist

- [ ] All tests pass
- [ ] No hardcoded secrets in code
- [ ] Environment variables documented
- [ ] Database backups configured
- [ ] SSL certificate obtained
- [ ] Domain name configured
- [ ] CDN setup (optional)
- [ ] Monitoring/logging setup

## 🔐 Security Hardening

### 1. Backend (.env)

```env
# Change to production
APP_ENV=production
APP_DEBUG=false

# Use strong key
APP_KEY=base64:GENERATE_NEW_KEY_WITH_php_artisan_key:generate

# Use HTTPS
APP_URL=https://yourdomain.com

# Restrict CORS
CORS_ALLOWED_ORIGINS=https://yourdomain.com

# Secure Sanctum
SANCTUM_STATEFUL_DOMAINS=yourdomain.com

# Strong database credentials
DB_PASSWORD=USE_STRONG_PASSWORD_HERE

# Use environment-specific email service
MAIL_MAILER=smtp
MAIL_HOST=mail.yourserver.com
MAIL_USERNAME=secure@yourdomain.com
MAIL_PASSWORD=SECURE_PASSWORD
```

### 2. Frontend

```env
NUXT_PUBLIC_API_BASE=https://api.yourdomain.com
```

### 3. Web Server Configuration

#### Nginx Configuration

```nginx
server {
    listen 443 ssl http2;
    server_name yourdomain.com;

    ssl_certificate /path/to/certificate.crt;
    ssl_certificate_key /path/to/key.key;

    # Security headers
    add_header Strict-Transport-Security "max-age=31536000" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Laravel backend
    location /api {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Frontend
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Redirect HTTP to HTTPS
}

server {
    listen 80;
    server_name yourdomain.com;
    return 301 https://$server_name$request_uri;
}
```

#### Apache Configuration

```apache
<VirtualHost *:443>
    ServerName yourdomain.com
    DocumentRoot /var/www/html/bookstore

    SSLEngine on
    SSLCertificateFile /path/to/certificate.crt
    SSLCertificateKeyFile /path/to/key.key

    # Enable mod_rewrite
    <Directory /var/www/html/bookstore>
        AllowOverride All
        Require all granted
        
        RewriteEngine On
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule ^ index.php [L]
    </Directory>

    # Security headers
    Header set Strict-Transport-Security "max-age=31536000"
    Header set X-Frame-Options "SAMEORIGIN"
    Header set X-Content-Type-Options "nosniff"
    Header set X-XSS-Protection "1; mode=block"

    ProxyPreserveHost On
    ProxyPass /api http://localhost:8000/api
    ProxyPassReverse /api http://localhost:8000/api
    
    ProxyPass / http://localhost:3000/
    ProxyPassReverse / http://localhost:3000/
</VirtualHost>

<VirtualHost *:80>
    ServerName yourdomain.com
    Redirect permanent / https://yourdomain.com/
</VirtualHost>
```

## 🚀 Deployment Strategies

### Strategy 1: Shared Hosting (cPanel/Plesk)

1. Create database
   ```sql
   CREATE DATABASE bookstore_prod;
   CREATE USER 'bookstore'@'localhost' IDENTIFIED BY 'STRONG_PASSWORD';
   GRANT ALL PRIVILEGES ON bookstore_prod.* TO 'bookstore'@'localhost';
   ```

2. Upload backend files to `public_html/api`
3. Run setup commands
   ```bash
   composer install --no-dev --optimize-autoloader
   php artisan migrate --force
   php artisan cache:clear
   ```

4. Deploy frontend
   ```bash
   npm install
   npm run build
   # Copy .output/public to public_html/
   ```

### Strategy 2: VPS/Dedicated Server

#### Using Supervisor for Queue

```ini
[program:bookstore-queue]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/bookstore/backend/bookstore-api/artisan queue:work
autostart=true
autorestart=true
numprocs=4
redirect_stderr=true
stdout_logfile=/var/log/bookstore/queue.log
```

#### Using Systemd for Services

Create `/etc/systemd/system/bookstore-api.service`:

```ini
[Unit]
Description=BookStore API Service
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/var/www/bookstore/backend/bookstore-api
ExecStart=/usr/bin/php artisan serve --host=0.0.0.0 --port=8000
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Start service:
```bash
sudo systemctl enable bookstore-api
sudo systemctl start bookstore-api
```

### Strategy 3: Docker Deployment

Create `docker-compose.yml`:

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_DATABASE: bookstore_prod
      MYSQL_ROOT_PASSWORD: STRONG_PASSWORD
    volumes:
      - ./data/mysql:/var/lib/mysql
    networks:
      - bookstore

  backend:
    build:
      context: ./backend/bookstore-api
      dockerfile: Dockerfile
    environment:
      APP_ENV: production
      DB_HOST: mysql
      DB_DATABASE: bookstore_prod
      DB_USERNAME: root
      DB_PASSWORD: STRONG_PASSWORD
    ports:
      - "8000:8000"
    depends_on:
      - mysql
    networks:
      - bookstore

  frontend:
    build:
      context: ./frontend/bookstore-web
      dockerfile: Dockerfile
    environment:
      NUXT_PUBLIC_API_BASE: https://yourdomain.com/api
    ports:
      - "3000:3000"
    networks:
      - bookstore

networks:
  bookstore:
    driver: bridge
```

Create `backend/bookstore-api/Dockerfile`:

```dockerfile
FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    composer \
    libpq-dev \
    && docker-php-ext-install pdo_mysql pdo

WORKDIR /app

COPY . .

RUN composer install --no-dev --optimize-autoloader

CMD ["php-fpm"]
```

### Strategy 4: Cloud Platforms

#### Heroku
```bash
# Install Heroku CLI
# Login to Heroku
heroku login

# Create app
heroku create bookstore

# Add buildpacks
heroku buildpacks:add heroku/php
heroku buildpacks:add heroku/nodejs

# Set config
heroku config:set APP_ENV=production
heroku config:set APP_KEY=base64:YOUR_KEY

# Deploy
git push heroku main

# Run migrations
heroku run php artisan migrate
```

#### AWS Elastic Beanstalk
```bash
# Install EB CLI
eb init -p php-8.2 bookstore

# Create environment
eb create bookstore-prod

# Deploy
eb deploy

# Configure environment
eb setenv APP_ENV=production
```

#### DigitalOcean App Platform
1. Connect GitHub repository
2. Configure build commands
3. Set environment variables
4. Deploy

## 📊 Monitoring & Logging

### 1. Application Logs

```bash
# Monitor Laravel logs
tail -f /var/log/bookstore/laravel.log

# Monitor web server logs
tail -f /var/log/nginx/error.log
tail -f /var/log/apache2/error.log
```

### 2. Error Tracking (Sentry)

Add to `.env`:
```env
SENTRY_LARAVEL_DSN=https://YOUR_DSN@sentry.io/PROJECT_ID
```

### 3. Performance Monitoring

Monitor key metrics:
- Response time
- CPU usage
- Memory usage
- Database queries
- API request count

### 4. Database Monitoring

```bash
# Backup database daily
mysqldump -u bookstore -p bookstore_prod > /backups/bookstore_$(date +%Y%m%d).sql

# Create cron job for automated backups
0 2 * * * mysqldump -u bookstore -p password bookstore_prod > /backups/bookstore_$(date +\%Y\%m\%d).sql
```

## 🔄 Continuous Deployment

### GitHub Actions Example

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Deploy to server
      uses: appleboy/ssh-action@master
      with:
        host: ${{ secrets.SERVER_HOST }}
        username: ${{ secrets.SERVER_USER }}
        key: ${{ secrets.SERVER_KEY }}
        script: |
          cd /var/www/bookstore
          git pull origin main
          composer install --no-dev
          npm ci
          npm run build
          php artisan migrate --force
```

## 🆘 Rollback Procedure

In case of issues:

```bash
# Rollback to previous version
git revert HEAD
git push origin main

# Or rollback database
php artisan migrate:rollback

# Clear caches
php artisan cache:clear
php artisan config:clear
php artisan view:clear
```

## 📋 Post-Deployment Checklist

- [ ] Test all features work
- [ ] Email sending verified
- [ ] API endpoints tested
- [ ] File uploads work
- [ ] PDF generation works
- [ ] Excel export works
- [ ] Database backups running
- [ ] Monitoring alerts configured
- [ ] SSL certificate valid
- [ ] Performance acceptable

## 🚨 Emergency Contacts

- Server Administrator: [contact]
- Database Administrator: [contact]
- On-call Support: [phone]

---

For questions or issues, contact your DevOps team.
