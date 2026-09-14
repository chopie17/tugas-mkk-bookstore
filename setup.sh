#!/bin/bash

# BookStore - Automated Setup Script
# This script automates the entire setup process for BookStore application

set -e  # Exit on error

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                  BookStore - Setup Script                      ║"
echo "║          Automated Installation & Configuration                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_step() {
    echo -e "${BLUE}→${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check prerequisites
print_step "Checking prerequisites..."

# Check PHP
if ! command -v php &> /dev/null; then
    print_error "PHP is not installed"
    exit 1
fi
print_success "PHP $(php -v | head -n 1 | awk '{print $2}')"

# Check Composer
if ! command -v composer &> /dev/null; then
    print_error "Composer is not installed"
    exit 1
fi
print_success "Composer found"

# Check Node.js
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed"
    exit 1
fi
print_success "Node.js $(node -v)"

# Check npm
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed"
    exit 1
fi
print_success "npm $(npm -v)"

# Check MySQL
if ! command -v mysql &> /dev/null; then
    print_warning "MySQL not found in PATH (might not be needed if using docker)"
fi

echo ""
print_step "Starting setup process..."
echo ""

# Backend Setup
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  BACKEND SETUP${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

cd backend/bookstore-api

# Check if .env exists
if [ ! -f .env ]; then
    print_step "Creating .env file..."
    cp .env.example .env
    print_success ".env file created"
else
    print_warning ".env already exists, skipping"
fi

# Install PHP dependencies
print_step "Installing PHP dependencies (composer install)..."
composer install --no-progress
print_success "PHP dependencies installed"

# Generate application key
print_step "Generating Laravel application key..."
php artisan key:generate
print_success "Application key generated"

echo ""
print_warning "Manual steps required for backend:"
echo "1. Update .env file with your database credentials:"
echo "   - DB_HOST, DB_PORT, DB_DATABASE, DB_USERNAME, DB_PASSWORD"
echo "2. Update email configuration (Gmail SMTP):"
echo "   - MAIL_USERNAME, MAIL_PASSWORD"
echo "3. Create MySQL database:"
echo "   $ mysql -u root -p"
echo "   mysql> CREATE DATABASE bookstore_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
echo "   mysql> EXIT;"
echo "4. Run migrations:"
echo "   $ php artisan migrate"
echo ""

read -p "Press Enter when you've completed the manual backend steps..."

# Run migrations
print_step "Running database migrations..."
php artisan migrate --force
print_success "Database migrations completed"

# Go back to root
cd ../..

# Frontend Setup
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  FRONTEND SETUP${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

cd frontend/bookstore-web

# Check if .env.local exists
if [ ! -f .env.local ]; then
    print_step "Creating .env.local file..."
    cp .env.example .env.local
    print_success ".env.local file created"
else
    print_warning ".env.local already exists, skipping"
fi

# Install Node dependencies
print_step "Installing Node.js dependencies (npm install)..."
npm install --no-progress
print_success "Node.js dependencies installed"

echo ""
print_warning "Optional: Update .env.local if API runs on different IP/port"
echo ""

# Go back to root
cd ../..

# Summary
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  SETUP COMPLETED SUCCESSFULLY!${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

echo "📝 Next steps:"
echo ""
echo "1. Start the backend API:"
echo "   $ cd backend/bookstore-api"
echo "   $ php artisan serve"
echo ""
echo "2. In another terminal, start the frontend:"
echo "   $ cd frontend/bookstore-web"
echo "   $ npm run dev"
echo ""
echo "3. Or run everything at once from backend:"
echo "   $ cd backend/bookstore-api"
echo "   $ composer run dev"
echo ""
echo "4. Access the application:"
echo "   - Frontend: http://localhost:3000"
echo "   - Backend API: http://localhost:8000"
echo ""

echo "📖 For detailed setup instructions, see README.md"
echo ""
