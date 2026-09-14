# 📚 Documentation Index - BookStore Project

Panduan lengkap navigasi dokumentasi BookStore.

## 🚀 Mulai Cepat

### Untuk Developer Baru
1. **[QUICKSTART.md](./QUICKSTART.md)** ⚡
   - Setup dalam 5 menit
   - Perintah dasar
   - Troubleshooting cepat
   - Panduan dalam bahasa Indonesia

2. **[README.md](./README.md)** 📖
   - Dokumentasi lengkap
   - Instalasi step-by-step
   - Konfigurasi database & email
   - API documentation

## 👨‍💻 Development

### Setup & Configuration
- **[README.md - Installation & Setup](./README.md#installation--setup)**
  - Clone repository
  - Backend setup lengkap
  - Frontend setup lengkap
  - Database configuration

### Email Configuration
- **[README.md - Email Configuration](./README.md#email-configuration)**
  - Setup Gmail SMTP
  - Konfigurasi App Password
  - Test email sending
  - Troubleshooting email

### Running Application
- **[README.md - Running the Application](./README.md#running-the-application)**
  - Opsi menggunakan script built-in
  - Setup manual di terminal terpisah
  - Port dan akses URL

### Database
- **[README.md - Database Setup](./README.md#database-setup)**
  - Struktur database
  - Migrasi
  - Reset database
  - Schema exploration

## 🔧 API Development

### API Documentation
- **[README.md - API Documentation](./README.md#api-documentation)**
  - Public endpoints
  - Authenticated endpoints
  - Admin endpoints
  - Authentication headers

### Troubleshooting Development
- **[README.md - Troubleshooting](./README.md#troubleshooting)**
  - Backend issues
  - Frontend issues
  - Network issues
  - Email problems

## 🤝 Contributing

### Code Contribution
- **[CONTRIBUTING.md](./CONTRIBUTING.md)** 🎯
  - Bug reporting
  - Feature suggestions
  - Development setup
  - Code style guidelines
  - Testing procedures
  - Commit message format
  - Pull request process

## 🚀 Deployment

### Production Deployment
- **[DEPLOYMENT.md](./DEPLOYMENT.md)** 🌐
  - Pre-deployment checklist
  - Security hardening
  - Web server configuration (Nginx, Apache)
  - Deployment strategies:
    - Shared hosting (cPanel/Plesk)
    - VPS/Dedicated server
    - Docker deployment
    - Cloud platforms (Heroku, AWS, DigitalOcean)
  - Monitoring & logging
  - Continuous deployment
  - Rollback procedures

## 🛠️ Setup Scripts

### Automated Installation

#### Linux/macOS
```bash
./setup.sh
```
- Cek prasyarat
- Install dependencies
- Generate keys
- Setup database
- Run migrations

#### Windows
```bash
setup.bat
```
- Sama seperti setup.sh untuk Windows

## 📁 File Structure

```
sekolah/
├── README.md                      # Dokumentasi utama
├── QUICKSTART.md                  # Panduan cepat (5 menit)
├── CONTRIBUTING.md                # Kontribusi & coding standards
├── DEPLOYMENT.md                  # Deployment production
├── DOCUMENTATION_INDEX.md         # File ini
├── setup.sh                       # Automated setup (Linux/macOS)
├── setup.bat                      # Automated setup (Windows)
│
├── backend/
│   └── bookstore-api/
│       ├── .env.example           # Environment template
│       ├── README.md              # Laravel documentation
│       ├── composer.json          # PHP dependencies
│       ├── app/
│       ├── database/
│       ├── routes/api.php         # API routes
│       └── ...
│
└── frontend/
    └── bookstore-web/
        ├── .env.example           # Environment template
        ├── nuxt.config.ts         # Nuxt configuration
        ├── package.json           # Node dependencies
        ├── pages/                 # Route pages
        ├── components/            # Vue components
        ├── stores/                # Pinia stores
        └── ...
```

## 📖 Dokumentasi Per Module

### Backend (Laravel API)

**Controllers** - Business Logic
- `AuthController` - Registration, Login, Password Reset
- `BookController` - Book management
- `CartController` - Shopping cart
- `OrderController` - Order management & PDF
- `ReportController` - Sales reports & Excel/PDF export
- `ReviewController` - Product reviews
- `ChatController` - Real-time chat
- `UserController` - User management
- `CategoryController` - Book categories

**Models** - Database Structure
- `User` - Customer & admin users
- `Book` - Book catalog
- `Order` - Order header
- `OrderDetail` - Order line items
- `Cart` - Shopping cart
- `Review` - Product reviews
- `Chat` - Messages
- `Category` - Book categories

**Services & Helpers**
- `OrderCodeGenerator` - Generate unique order codes
- `ReportExport` - Excel export
- `ResetPasswordCodeMail` - Password reset emails

### Frontend (Nuxt 3)

**Pages** - Routes & Features
- `/` - Home page
- `/login` - Authentication
- `/register` - User registration
- `/katalog` - Book catalog
- `/books/[id]` - Book details
- `/keranjang` - Shopping cart
- `/checkout/pembayaran` - Checkout
- `/user/riwayat` - Order history
- `/admin/*` - Admin dashboard

**Components** - Reusable UI
- `Header` - Top navigation
- `Sidebar` - Left navigation
- `Navbar` - Mobile navigation
- `Toast` - Notifications
- Product cards
- Order list

**Stores (Pinia)** - State Management
- `auth` - User authentication
- `cart` - Shopping cart state
- `theme` - Dark/light mode

**Composables** - Reusable Logic
- `useApi` - API communication
- `useAuth` - Authentication
- `useTheme` - Theme management
- `useToast` - Toast notifications

## 🎯 Common Tasks

### Setup Project
1. [QUICKSTART.md](./QUICKSTART.md) - Fastest way (5 min)
2. [README.md - Installation](./README.md#installation--setup) - Detailed setup

### Configure Email
1. [README.md - Email Configuration](./README.md#email-configuration)
2. Gmail setup instructions included

### Deploy to Production
1. [DEPLOYMENT.md](./DEPLOYMENT.md)
2. Choose your deployment strategy
3. Follow security hardening checklist

### Contribute Code
1. [CONTRIBUTING.md](./CONTRIBUTING.md)
2. Follow code style & testing
3. Submit pull request

### Fix Issues
1. [README.md - Troubleshooting](./README.md#troubleshooting)
2. Check relevant section
3. Follow suggested fixes

## 🔍 Search by Topic

### 🗄️ Database Topics
- [Database Setup](./README.md#database-setup)
- [Migrations](./README.md#database-setup)
- [Connection Issues](./README.md#troubleshooting)

### 📧 Email Topics
- [Email Configuration](./README.md#email-configuration)
- [Gmail Setup](./README.md#email-configuration)
- [Email Troubleshooting](./README.md#troubleshooting)

### 🌐 API Topics
- [API Documentation](./README.md#api-documentation)
- [Authentication](./README.md#api-documentation)
- [Endpoints](./README.md#api-documentation)
- [CORS Configuration](./README.md#api-configuration)

### 🚀 Deployment Topics
- [Deployment Strategies](./DEPLOYMENT.md#deployment-strategies)
- [Docker](./DEPLOYMENT.md#strategy-3-docker-deployment)
- [Cloud Platforms](./DEPLOYMENT.md#strategy-4-cloud-platforms)
- [Monitoring](./DEPLOYMENT.md#monitoring--logging)

### 💻 Development Topics
- [Code Style](./CONTRIBUTING.md#code-style)
- [Testing](./CONTRIBUTING.md#testing)
- [Git Workflow](./CONTRIBUTING.md#development-setup)
- [Commit Messages](./CONTRIBUTING.md#commit-messages)

## 📋 Checklists

### Setup Checklist
- [ ] PHP 8.2+ installed
- [ ] MySQL installed
- [ ] Node.js installed
- [ ] Composer installed
- [ ] Git installed
- [ ] Repository cloned

### Backend Setup Checklist
- [ ] Dependencies installed (`composer install`)
- [ ] `.env` file created and configured
- [ ] Application key generated
- [ ] Database created
- [ ] Migrations run (`php artisan migrate`)
- [ ] Server starts (`php artisan serve`)

### Frontend Setup Checklist
- [ ] Dependencies installed (`npm install`)
- [ ] `.env.local` file created
- [ ] API URL configured
- [ ] Dev server starts (`npm run dev`)

### Deployment Checklist
- [ ] Production `.env` configured
- [ ] SSL certificate obtained
- [ ] Database backups setup
- [ ] Monitoring configured
- [ ] Email service configured
- [ ] Web server configured
- [ ] All tests pass

## 🆘 Getting Help

### Where to Find Answers
1. **This Index** - Navigation & structure
2. **QUICKSTART.md** - Fast answers (Indonesian)
3. **README.md** - Detailed documentation
4. **DEPLOYMENT.md** - Production questions
5. **CONTRIBUTING.md** - Development guidelines

### If You Get Stuck
1. Check Troubleshooting section
2. Search documentation index
3. Review commit messages
4. Ask in GitHub Issues

## 📞 Quick Links

| Document | Purpose | Read Time |
|----------|---------|-----------|
| [QUICKSTART.md](./QUICKSTART.md) | Get started in 5 minutes | 5 min |
| [README.md](./README.md) | Full documentation | 20 min |
| [CONTRIBUTING.md](./CONTRIBUTING.md) | Development standards | 15 min |
| [DEPLOYMENT.md](./DEPLOYMENT.md) | Production deployment | 15 min |
| [DOCUMENTATION_INDEX.md](./DOCUMENTATION_INDEX.md) | You are here | 10 min |

---

## 🎓 Reading Order

### For New Developers
1. [QUICKSTART.md](./QUICKSTART.md) - Get it running
2. [README.md - Features](./README.md#features) - Understand what it does
3. [README.md - Tech Stack](./README.md#tech-stack) - Know the technologies
4. [CONTRIBUTING.md](./CONTRIBUTING.md) - Learn standards

### For Maintainers
1. [README.md](./README.md) - Full understanding
2. [DEPLOYMENT.md](./DEPLOYMENT.md) - Production concerns
3. [CONTRIBUTING.md](./CONTRIBUTING.md) - Code review standards

### For DevOps/Infrastructure
1. [DEPLOYMENT.md](./DEPLOYMENT.md) - Deployment strategies
2. [DEPLOYMENT.md - Security Hardening](./DEPLOYMENT.md#security-hardening)
3. [DEPLOYMENT.md - Monitoring](./DEPLOYMENT.md#monitoring--logging)

---

**Last Updated**: September 2026  
**Total Documentation**: ~10,000 words across 5 comprehensive guides
