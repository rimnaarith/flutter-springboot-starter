# Flutter Spring Boot Starter 🚀

A complete full-stack starter template combining a **Flutter mobile application** with a **Spring Boot REST API** backend, featuring secure JWT authentication, clean architecture, and production-ready project structure.

## 📋 Overview

This starter project provides a professional foundation for building modern applications with:
- **Frontend**: Flutter mobile app with onboarding, authentication, and user management
- **Backend**: Spring Boot REST API with JWT-based security and token refresh mechanism
- **Database**: PostgreSQL with Docker Compose setup

## ✨ Features

### Backend Features
- ✅ User registration with email validation
- ✅ Login with email & password
- ✅ JWT access tokens with configurable expiry
- ✅ Refresh tokens for automatic token renewal
- ✅ Global exception handling
- ✅ Validation
- ✅ Swagger/OpenAPI documentation
- ✅ Docker Compose setup for PostgreSQL
- ✅ Spring Security configuration

### Mobile Features
- ✅ Complete onboarding flow with interactive screens
- ✅ Secure user authentication (registration & login)
- ✅ JWT token management with automatic refresh
- ✅ Secure token storage using Flutter Secure Storage
- ✅ Home dashboard and profile screens
- ✅ State management with Riverpod
- ✅ Declarative routing with GoRouter
- ✅ Robust HTTP client with Dio and interceptors
- ✅ Logging and error handling

## 🏗️ Tech Stack

### Backend
- **Framework**: Spring Boot 4.x
- **Language**: Java 21+
- **Build Tool**: Maven 3.9+
- **Database**: PostgreSQL
- **Security**: Spring Security + JWT
- **API Docs**: Swagger/OpenAPI
- **Containerization**: Docker & Docker Compose

### Mobile
- **Framework**: Flutter 3.10.4+
- **Language**: Dart 3.10.4+
- **State Management**: Riverpod
- **HTTP Client**: Dio
- **Routing**: GoRouter
- **Secure Storage**: Flutter Secure Storage
- **Local Storage**: SharedPreferences

## 📁 Project Structure

```
flutter-springboot-starter/
├── backend/                    # Spring Boot REST API
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/naarith/fsp/
│   │   │   │   ├── common/           # Shared components
│   │   │   │   ├── user/             # User management
│   │   │   │   └── auth/             # Authentication & JWT
│   │   │   └── resources/            # Configuration files
│   │   └── test/
│   ├── docker-compose.yml      # PostgreSQL setup
│   ├── pom.xml                 # Maven configuration
│   └── README.md               # Backend documentation
│
├── mobile/                     # Flutter mobile application
│   ├── lib/
│   │   ├── main.dart           # App entry point
│   │   ├── app.dart            # Main app widget
│   │   ├── core/               # Shared utilities & configuration
│   │   │   ├── routing/        # GoRouter setup
│   │   │   ├── network/        # HTTP client & interceptors
│   │   │   ├── storage/        # Secure & local storage
│   │   │   ├── constants/      # App constants
│   │   │   └── widgets/        # Reusable widgets
│   │   └── features/           # Feature modules
│   │       ├── auth/           # Authentication
│   │       ├── onboarding/     # Onboarding flow
│   │       ├── home/           # Home dashboard
│   │       └── profile/        # User profile
│   ├── pubspec.yaml            # Flutter dependencies
│   ├── android/                # Android native code
│   ├── ios/                    # iOS native code
│   └── README.md               # Mobile documentation
│
└── README.md                   # This file
```

## 🚀 Getting Started

### Prerequisites

#### Common
- Git

#### Backend Requirements
- Java 21 or higher
- Maven 3.9 or higher
- Docker & Docker Compose

#### Mobile Requirements
- Flutter SDK (^3.10.4)
- Dart SDK (^3.10.4)

### Backend Setup

1. **Start PostgreSQL Database**
   ```bash
   cd backend
   docker-compose up -d
   ```
   PostgreSQL will be accessible at `localhost:5432`. Update credentials in `src/main/resources/application.yaml` if needed.

2. **Build the Project**
   ```bash
   ./mvnw clean package
   ```

3. **Run the Application**
   ```bash
   ./mvnw spring-boot:run
   ```
   The server listens on `http://localhost:8222` by default.

4. **Access Swagger Documentation**
   ```
   http://localhost:8222/swagger-ui/index.html
   ```

### Mobile Setup

1. **Get Dependencies**
   ```bash
   cd mobile
   flutter pub get
   ```

2. **Run the App**
   ```bash
   flutter run
   ```

3. **Build for Production**
   ```bash
   flutter build apk   # Android
   flutter build ios   # iOS
   flutter build web   # Web
   ```

## 💻 API Endpoints

### Authentication Routes
- **Register**: `POST /api/v1/auth/register`
  - Body: `{ email, password, ... }`
  
- **Login**: `POST /api/v1/auth/login`
  - Body: `{ email, password }`
  - Response: `{ accessToken, refreshToken }`

- **Refresh Token**: `POST /api/v1/auth/refresh`
  - Body: `{ refreshToken }`
  - Response: `{ accessToken, refreshToken }`

### Protected Endpoints
All authenticated endpoints require:
```
Authorization: Bearer <accessToken>
```

## 🔐 Authentication Flow

1. User registers or logs in via mobile app
2. Backend validates credentials and returns JWT tokens (access + refresh)
3. Mobile app stores tokens securely
4. For API requests, mobile app includes access token in `Authorization` header
5. If access token expires, mobile app automatically uses refresh token to get a new one
6. Auth interceptor handles token refresh transparently

## 🏛️ Architecture

### Backend Architecture
- **REST API**: Spring Boot with Spring Security
- **Database**: PostgreSQL with JPA/Hibernate
- **Exception Handling**: Global exception handler with custom error responses
- **Security**: JWT-based stateless authentication

### Mobile Architecture
- **Presentation Layer**: Riverpod notifiers + Flutter widgets
- **Data Layer**: Repositories for API calls and local storage
- **Core Layer**: Network client, routing, storage, and shared utilities
- **Clean Architecture**: Clear separation of concerns

## 📚 Documentation

- [Backend README](./backend/README.md) - Detailed backend documentation
- [Mobile README](./mobile/README.md) - Detailed mobile documentation

## 🔧 Configuration

### Backend Configuration
Edit `backend/src/main/resources/application.yaml`:
- Server port
- Database credentials
- JWT expiration times
- Logging levels

### Mobile Configuration
Edit `mobile/lib/core/constants/` and `mobile/pubspec.yaml`:
- API base URL
- Route constants
- Storage keys

## 📝 Notes

- Tokens automatically refresh without user intervention
- All sensitive data (tokens) stored securely on mobile
- Both platforms follow industry best practices for security
- Database and API are containerized for easy deployment

## 🤝 Next Steps

1. Configure database credentials for your environment
2. Update API endpoints in mobile app configuration
3. Customize authentication flows as needed
4. Add your business logic features
5. Deploy to production

---

**Happy coding!** 🎉
