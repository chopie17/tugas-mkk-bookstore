# BookStore - Online Bookstore Application

A full-stack online bookstore application built with Laravel (backend) and Nuxt 3 (frontend). Features include product catalog, shopping cart, orders management, admin dashboard, real-time chat, and comprehensive reporting.

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Installation & Setup](#installation--setup)
- [Configuration](#configuration)
- [Running the Application](#running-the-application)
- [Database Setup](#database-setup)
- [Email Configuration](#email-configuration)
- [API Documentation](#api-documentation)
- [Troubleshooting](#troubleshooting)

## ✨ Features

### User Features
- 📚 Browse book catalog with search and category filtering
- 🛒 Shopping cart with item selection
- 💳 Checkout system with multiple payment methods (Cash, Bank Transfer, E-Wallet)
- 📦 Order history with status tracking
- ⭐ Product reviews and ratings
- 💬 Real-time chat support with admin
- 🌙 Dark/Light mode theme toggle

### Admin Features
- 📊 Sales reports with PDF/Excel export
- 📈 Profit and revenue tracking
- 👥 User management
- 📚 Book inventory management
- 💬 Customer support chat
- 🧾 Order confirmation and payment processing (Kasir)
- 📋 Category management

### Technical Features
- 🔐 JWT Authentication with Sanctum
- 🚀 RESTful API with proper validation
- 📄 PDF invoice generation
- 📊 Excel report export
- 🎨 Dark/Light mode with Tailwind CSS
- 📱 Responsive mobile design
- 🔄 Real-time notifications with Toast system

## 🛠 Tech Stack

### Backend
- **Laravel 12** - PHP Framework
- **PHP 8.2+** - Server Language
- **MySQL 8.0+** - Database
- **Laravel Sanctum** - API Authentication
- **DomPDF** - PDF Generation
- **Maatwebsite Excel** - Excel Export
- **Intervention Image** - Image Processing

### Frontend
- **Nuxt 3** - Vue.js Framework
- **TypeScript** - Type Safety
- **Tailwind CSS** - Styling
- **Pinia** - State Management
- **Lucide Vue** - Icons
- **Vite** - Build Tool

## 📦 Prerequisites

Make sure you have installed:

- **PHP 8.2+** with extensions: curl, dom, fileinfo, mbstring, pdo_mysql
- **Composer** - PHP Package Manager
- **Node.js 18+** and npm/yarn
- **MySQL 8.0+** - Database
- **Git** - Version Control

### Verify Installation
```bash
php -v          # PHP version
composer -v     # Composer version
node -v         # Node version
npm -v          # NPM version
mysql --version # MySQL version
```

## 📁 Project Structure

```
sekolah/
├── backend/
│   └── bookstore-api/          # Laravel API
│       ├── app/
│       │   ├── Models/         # Database models
│       │   ├── Http/
│       │   │   ├── Controllers/
│       │   │   └── Resources/
│       │   ├── Exports/        # Excel export classes
│       │   └── Mail/           # Email templates
│       ├── database/
│       │   ├── migrations/     # Database migrations
│       │   └── factories/      # Data factories
│       ├── routes/
│       │   └── api.php         # API routes
│       ├── config/             # Configuration files
│       ├── .env               # Environment variables
│       └── composer.json
│
└── frontend/
    └── bookstore-web/          # Nuxt 3 Application
        ├── pages/              # Page components
        ├── components/         # Reusable components
        ├── composables/        # Composable functions
        ├── stores/             # Pinia stores
        ├── assets/             # Static assets
        ├── .env               # Environment variables
        └── package.json
```

## 🚀 Installation & Setup

### 1. Clone Repository

```bash
git clone https://github.com/yourusername/bookstore.git
cd sekolah
```

### 2. Backend Setup

Navigate to backend directory:
```bash
cd backend/bookstore-api
```

#### Install Dependencies
```bash
composer install
```

#### Setup Environment Variables
```bash
cp .env.example .env
```

#### Generate Application Key
```bash
php artisan key:generate
```

#### Create Database
```bash
# Login to MySQL
mysql -u root -p

# Create database (if not exists)
CREATE DATABASE bookstore_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EXIT;
```

#### Configure .env File
Edit `.env` and update:

```env
# App Configuration
APP_NAME=BookStore
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:8000

# Database Configuration
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=bookstore_db
DB_USERNAME=root
DB_PASSWORD=password123          # Change to your MySQL password

# CORS Configuration (Frontend URL)
SANCTUM_STATEFUL_DOMAINS=localhost:3000,127.0.0.1:3000
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000

# Email Configuration (Gmail SMTP)
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD="your-app-password"    # Use Gmail App Password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS="your-email@gmail.com"
MAIL_FROM_NAME="BookStore"
```

#### Run Migrations
```bash
php artisan migrate
```

This will create all necessary database tables.

#### (Optional) Seed Database with Sample Data
```bash
php artisan db:seed
```

#### Verify Backend Setup
```bash
php artisan tinker
# Test database connection
>>> DB::connection()->getPdo()
>>> exit
```

### 3. Frontend Setup

Navigate to frontend directory (in a new terminal):
```bash
cd frontend/bookstore-web
```

#### Install Dependencies
```bash
npm install
# or
yarn install
```

#### Create Environment File
```bash
cp .env.example .env.local
```

#### Configure .env.local
Edit `.env.local`:

```env
NUXT_PUBLIC_API_BASE=http://localhost:8000
```

If running on different IP:
```env
NUXT_PUBLIC_API_BASE=http://10.197.144.63:8000
```

#### Verify Frontend Setup
```bash
npm list
```

## ⚙️ Configuration

### Email Configuration

This application uses **Gmail SMTP** for sending emails (password reset, notifications).

#### Setup Gmail App Password

1. Enable 2-Factor Authentication in your Google Account:
   - Go to https://myaccount.google.com/security
   - Enable 2-Step Verification

2. Create App Password:
   - Go to https://myaccount.google.com/apppasswords
   - Select "Mail" and "Windows Computer"
   - Google will generate a 16-character password
   - Copy this password

3. Update `.env`:
```env
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD="xxxx xxxx xxxx xxxx"  # 16-char password with spaces
```

### Database Configuration

#### MySQL Settings
- Host: `127.0.0.1`
- Port: `3306` (default)
- Database: `bookstore_db`
- User: `root` (or your MySQL user)
- Password: Your MySQL password

#### Connection Test
```bash
php artisan tinker
>>> DB::connection()->getPdo()
>>> Schema::getTables()
>>> exit
```

### API Configuration

#### CORS Settings
Update in `.env`:
```env
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000
```

#### Sanctum Domains
```env
SANCTUM_STATEFUL_DOMAINS=localhost:3000,127.0.0.1:3000
```

## 🎯 Running the Application

### Option 1: Using Built-in Script (Recommended)

From the `backend/bookstore-api` directory:

```bash
# This runs everything in one command
composer run dev
```

This will start:
- ✅ PHP Development Server (port 8000)
- ✅ Queue Listener
- ✅ Application Logs
- ✅ Frontend Dev Server (port 3000)

### Option 2: Manual Setup (in Separate Terminals)

#### Terminal 1 - Backend API
```bash
cd backend/bookstore-api
php artisan serve
# Runs on http://localhost:8000
```

#### Terminal 2 - Frontend
```bash
cd frontend/bookstore-web
npm run dev
# Runs on http://localhost:3000
```

#### Terminal 3 - Queue (Optional, for jobs)
```bash
cd backend/bookstore-api
php artisan queue:listen --tries=1 --timeout=0
```

### Access Application

- **Frontend**: http://localhost:3000
- **API**: http://localhost:8000/api
- **API Docs** (if available): http://localhost:8000/api/docs

## 🗄️ Database Setup

### Tables Created

```
users                    # User accounts (customers & admins)
books                    # Book inventory
categories               # Book categories
orders                   # Customer orders
order_details            # Order line items
cart                     # Shopping cart items
reviews                  # Product reviews
chats                    # Real-time chat messages
chat_deletions          # Chat deletion tracking
personal_access_tokens  # Sanctum API tokens
```

### View Database Schema

```bash
php artisan migrate:status   # View all migrations
php artisan tinker
>>> Schema::getTables()
>>> exit
```

### Reset Database (Development Only)

⚠️ **WARNING**: This will delete all data!

```bash
php artisan migrate:reset    # Roll back all migrations
php artisan migrate          # Re-run migrations
php artisan db:seed         # (Optional) Seed sample data
```

## 📧 Email Configuration

### Features Using Email

1. **Password Reset**
   - User receives 6-digit OTP code
   - Valid for password reset

2. **Notifications**
   - Order confirmations
   - Payment reminders
   - Support messages

### Test Email Sending

```bash
php artisan tinker
>>> Mail::raw('Test email', function($message) {
    $message->to('your-email@gmail.com')->subject('Test');
});
>>> exit
```

### Troubleshooting Email

If emails aren't sending:

1. Check `.env` settings
   ```bash
   MAIL_MAILER=smtp
   MAIL_HOST=smtp.gmail.com
   MAIL_PORT=587
   ```

2. Verify Gmail credentials
   - Correct email and app password
   - 2FA enabled on Google Account

3. Check logs
   ```bash
   tail -f storage/logs/laravel.log
   ```

4. Test queue
   ```bash
   php artisan queue:listen
   ```

## 📡 API Documentation

### Authentication

All API requests (except public endpoints) require token in header:

```bash
Authorization: Bearer YOUR_TOKEN_HERE
```

### Public Endpoints

```
GET    /api/books              # List all books
GET    /api/books/{id}         # Get book details
GET    /api/categories         # List categories
GET    /api/books/{id}/reviews # Get book reviews
POST   /api/register           # User registration
POST   /api/login              # User login
POST   /api/forgot-password/send-code      # Send reset code
POST   /api/forgot-password/verify-code    # Verify reset code
POST   /api/forgot-password/reset          # Reset password
```

### Authenticated Endpoints

```
GET    /api/me                 # Get current user
GET    /api/cart               # Get shopping cart
POST   /api/cart               # Add to cart
PUT    /api/cart/{id}          # Update cart item
DELETE /api/cart/{id}          # Remove from cart
POST   /api/orders             # Create order
GET    /api/orders             # Get user orders
```

### Admin Endpoints

```
GET    /api/admin/users        # List users
POST   /api/admin/books        # Create book
PUT    /api/admin/books/{id}   # Update book
DELETE /api/admin/books/{id}   # Delete book
GET    /api/admin/reports      # Sales report
GET    /api/admin/reports/export-pdf      # Export PDF
GET    /api/admin/reports/export-excel    # Export Excel
```

## 🐛 Troubleshooting

### Backend Issues

#### 1. "SQLSTATE[HY000]: General error: 1030"
```bash
# Check database size and clean up logs
php artisan tinker
>>> DB::connection()->getPdo()
>>> exit
```

#### 2. "No application encryption key has been defined"
```bash
php artisan key:generate
```

#### 3. "Connection refused" error
```bash
# Check if MySQL is running
systemctl status mysql
# or
brew services list  # macOS
```

#### 4. "CORS error" from frontend
- Check `CORS_ALLOWED_ORIGINS` in `.env`
- Make sure frontend URL matches exactly

#### 5. Email not sending
- Verify Gmail app password (16 characters with spaces)
- Check 2FA is enabled
- Review `storage/logs/laravel.log`

### Frontend Issues

#### 1. "API not reachable"
- Check backend is running
- Verify `NUXT_PUBLIC_API_BASE` in `.env.local`
- Check CORS headers in browser console

#### 2. Page shows blank/not loading
```bash
npm run dev  # Restart dev server
```

#### 3. TypeScript errors
```bash
npm run build  # Check for build errors
npm run lint   # Run linter
```

### Network Issues

If running on different machines:

#### Backend `.env`:
```env
APP_URL=http://10.197.144.63:8000
CORS_ALLOWED_ORIGINS=http://10.197.144.63:3000
```

#### Frontend `.env.local`:
```env
NUXT_PUBLIC_API_BASE=http://10.197.144.63:8000
```

## 📚 Learning Resources

- [Laravel Documentation](https://laravel.com/docs)
- [Nuxt 3 Documentation](https://nuxt.com)
- [Tailwind CSS](https://tailwindcss.com)
- [Pinia Store](https://pinia.vuejs.org)

## 🔐 Security Notes

⚠️ **Important for Production**:

1. Change `APP_DEBUG=false` in `.env`
2. Use strong database passwords
3. Enable HTTPS
4. Store sensitive data in environment variables
5. Use `.env` for secrets, never commit to Git
6. Regular security audits

## 📝 License

This project is open source and available under the MIT License.

**Last Updated**: September 2026  
**Version**: 1.0.0
