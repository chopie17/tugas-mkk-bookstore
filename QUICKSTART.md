# 🚀 Panduan Singkat - BookStore

Panduan cepat untuk memulai development BookStore dalam 5 menit.

## ⚡ Prasyarat

Pastikan sudah install:
- PHP 8.2+ dengan MySQL
- Composer
- Node.js 18+
- Git

## 1️⃣ Clone Repository

```bash
git clone https://github.com/yourusername/bookstore.git
cd sekolah
```

## 2️⃣ Backend Setup (2 menit)

```bash
cd backend/bookstore-api

# Copy environment
cp .env.example .env

# Install dependencies
composer install

# Generate key
php artisan key:generate
```

**Edit `.env` dan update:**
```env
DB_DATABASE=bookstore_db
DB_USERNAME=root
DB_PASSWORD=your_password

MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD="your-app-password"
```

**Buat database:**
```bash
mysql -u root -p -e "CREATE DATABASE bookstore_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

**Run migrations:**
```bash
php artisan migrate
```

## 3️⃣ Frontend Setup (1 menit)

Di terminal baru:

```bash
cd frontend/bookstore-web

# Copy environment
cp .env.example .env.local

# Install dependencies
npm install
```

## 4️⃣ Jalankan Aplikasi

**Terminal 1 - Backend:**
```bash
cd backend/bookstore-api
php artisan serve
# Runs on http://localhost:8000
```

**Terminal 2 - Frontend:**
```bash
cd frontend/bookstore-web
npm run dev
# Runs on http://localhost:3000
```

Atau jalankan semuanya di satu command:
```bash
cd backend/bookstore-api
composer run dev
```

## 5️⃣ Akses Aplikasi

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000

## 🔐 Akun Test

Buat akun baru di aplikasi atau gunakan:

```bash
php artisan tinker
>>> App\Models\User::factory()->create(['email' => 'admin@test.com'])
>>> exit
```

## 📧 Email Setup (Gmail)

1. Enable 2-Factor Authentication: https://myaccount.google.com/security
2. Buat App Password: https://myaccount.google.com/apppasswords
3. Copy password ke `.env`:
   ```env
   MAIL_USERNAME=your-email@gmail.com
   MAIL_PASSWORD="xxxx xxxx xxxx xxxx"
   ```

## 🐛 Troubleshooting

### "Connection refused"
```bash
# Start MySQL
sudo systemctl start mysql    # Linux
brew services start mysql     # macOS
# On Windows, start MySQL from Services
```

### "CORS error"
Update `.env`:
```env
CORS_ALLOWED_ORIGINS=http://localhost:3000
SANCTUM_STATEFUL_DOMAINS=localhost:3000
```

### "No application encryption key has been defined"
```bash
php artisan key:generate
```

### Database error
```bash
php artisan migrate:reset
php artisan migrate
```

## 📚 Selanjutnya

- Baca [README.md](./README.md) untuk dokumentasi lengkap
- Baca [CONTRIBUTING.md](./CONTRIBUTING.md) untuk konvensi code
- Lihat API docs di http://localhost:8000/api

## 🎯 Struktur Project

```
sekolah/
├── backend/bookstore-api/        # Laravel API
│   ├── app/Http/Controllers/Api/ # API Controllers
│   ├── app/Models/               # Database Models
│   ├── database/migrations/      # Database Migrations
│   └── routes/api.php            # API Routes
│
└── frontend/bookstore-web/       # Nuxt 3 App
    ├── pages/                    # Halaman
    ├── components/               # Komponen reusable
    ├── stores/                   # State management
    └── composables/              # Fungsi reusable
```

## 💡 Tips Development

```bash
# Clear all caches (jika ada masalah)
php artisan cache:clear
php artisan config:clear
php artisan view:clear

# Buat model+migration+controller sekaligus
php artisan make:model ModelName -mrc

# Generate API resource
php artisan make:resource ModelNameResource

# Jalankan tinker (PHP REPL)
php artisan tinker

# Database seeding
php artisan db:seed

# Check database schema
php artisan tinker
>>> Schema::getTables()
```

## 📞 Need Help?

- GitHub Issues: [Create issue]
- Email: [your-email@gmail.com]
- Lihat README.md untuk dokumentasi lengkap

---

**Happy coding! 🎉**
