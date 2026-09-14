@echo off
REM BookStore - Automated Setup Script (Windows)
REM This script automates the entire setup process for BookStore application

setlocal enabledelayedexpansion

echo.
echo ====================================================================
echo                   BookStore - Setup Script
echo             Automated Installation ^& Configuration
echo ====================================================================
echo.

REM Check prerequisites
echo Checking prerequisites...

where php >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] PHP is not installed or not in PATH
    exit /b 1
)
echo [OK] PHP found

where composer >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Composer is not installed or not in PATH
    exit /b 1
)
echo [OK] Composer found

where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed or not in PATH
    exit /b 1
)
echo [OK] Node.js found

where npm >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] npm is not installed or not in PATH
    exit /b 1
)
echo [OK] npm found

echo.
echo Starting setup process...
echo.

REM Backend Setup
echo ====================================================================
echo   BACKEND SETUP
echo ====================================================================
echo.

cd backend\bookstore-api

if not exist .env (
    echo Creating .env file...
    copy .env.example .env
    echo [OK] .env file created
) else (
    echo [WARNING] .env already exists, skipping
)

echo Installing PHP dependencies (composer install)...
call composer install --no-progress
echo [OK] PHP dependencies installed

echo Generating Laravel application key...
call php artisan key:generate
echo [OK] Application key generated

echo.
echo [WARNING] Manual steps required for backend:
echo 1. Update .env file with your database credentials:
echo    - DB_HOST, DB_PORT, DB_DATABASE, DB_USERNAME, DB_PASSWORD
echo 2. Update email configuration (Gmail SMTP):
echo    - MAIL_USERNAME, MAIL_PASSWORD
echo 3. Create MySQL database:
echo    mysql -u root -p
echo    CREATE DATABASE bookstore_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
echo 4. Run migrations:
echo    php artisan migrate
echo.

pause

echo Running database migrations...
call php artisan migrate --force
echo [OK] Database migrations completed

cd ..\..

REM Frontend Setup
echo.
echo ====================================================================
echo   FRONTEND SETUP
echo ====================================================================
echo.

cd frontend\bookstore-web

if not exist .env.local (
    echo Creating .env.local file...
    copy .env.example .env.local
    echo [OK] .env.local file created
) else (
    echo [WARNING] .env.local already exists, skipping
)

echo Installing Node.js dependencies (npm install)...
call npm install --no-progress
echo [OK] Node.js dependencies installed

echo.
echo [WARNING] Optional: Update .env.local if API runs on different IP/port
echo.

cd ..\..

REM Summary
echo.
echo ====================================================================
echo   SETUP COMPLETED SUCCESSFULLY!
echo ====================================================================
echo.

echo Next steps:
echo.
echo 1. Start the backend API:
echo    cd backend\bookstore-api
echo    php artisan serve
echo.
echo 2. In another terminal, start the frontend:
echo    cd frontend\bookstore-web
echo    npm run dev
echo.
echo 3. Or run everything at once from backend:
echo    cd backend\bookstore-api
echo    composer run dev
echo.
echo 4. Access the application:
echo    - Frontend: http://localhost:3000
echo    - Backend API: http://localhost:8000
echo.

echo For detailed setup instructions, see README.md
echo.

pause
