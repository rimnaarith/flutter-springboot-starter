# 🌐 Spring Boot Starter

A Spring Boot starter project that implements user registration and login with JWT-based authentication including refresh tokens. Designed as a template to bootstrap new applications.

## Features
- Register new users
- Login with email & password
- JWT access tokens with expiry
- Refresh tokens to automatically renew expired access tokens
- Global exception handling
- Validation
- Swagger API documentation
- Docker Compose setup for PostgreSQL

## Getting Started

### Prerequisites
- Java 21+ / Maven 3.9+
- Docker & Docker Compose

### Running PostgreSQL with Docker Compose
The repository includes a `docker-compose.yml` which starts a PostgreSQL container. Run:

```bash
docker-compose up -d
```

This will create a PostgreSQL instance accessible at `localhost:5432`. Configure credentials in `src/main/resources/application.yaml` as needed.

### Building and Running
Build the project with Maven:

```bash
./mvnw clean package
```

Start the application:

```bash
./mvnw spring-boot:run
```

The server listens on port `8222` by default (configured in `application.yaml`).

### Swagger API Documentation
Once the application is running, browse the API docs at:

```
http://localhost:8222/swagger-ui/index.html
```

## Project Structure

```
com.naarith.fsp
│   FSPApplication.java                  # Main Spring Boot application
│
├───common
│   ├───exception
│   │       BaseException.java           # Base custom exception
│   │       GlobalExceptionHandler.java  # @ControllerAdvice
│   │       ApiError.java                # Error response DTO
│   └───config
│           OpenApiConfig.java           # Swagger / OpenAPI configuration
└───user
│   ├───entity
│   │       User.java                    # JPA entity representing a user
│   ├───repository
│   │       UserRepository.java          # Spring Data repository
│   ├───service
│   │       UserService.java             # Business logic for user operations
│   ├───exception
│   │       EmailAlreadyExistsException.java # Thrown on duplicate registration
│   └───controller
│           UserController.java          # REST endpoints for user actions
└───auth
    ├───controller
    │       AuthController.java          # Login / register endpoints
    ├───service
    │   │   AuthService.java             # Authentication flow
    │   │   JwtService.java              # JWT generation/validation
    │   └───model
    │           LoginResult.java         # DTO returned after login
    ├───dto
    │       LoginRequest.java            # Login payload
    │       LoginResponse.java           # Access/refresh tokens
    │       RegisterRequest.java         # Registration payload
    ├───mapper
    │       AuthMapper.java              # Map between entities and DTOs
    ├───security
    │       SecurityConfig.java          # Spring Security configuration
    │       UserPrincipal.java           # Principal wrapping User entity
    │       CustomUserDetailsService.java # Loads users for auth
    │       JwtAuthenticationFilter.java  # Filter for checking JWTs
    ├───enums
    │       TokenType.java               # Enum of access/refresh tokens
    └───exception
            InvalidCredentialsExceptions.java
            TokenExpiredException.java
            TokenInvalidException.java
```

## Usage

- **Register**: `POST /api/v1/auth/register` with JSON body containing `email`, `password`, etc.
- **Login**: `POST /api/v1/auth/login` with credentials; returns access and refresh tokens.
- **Refresh**: `GET /api/v1/auth/refresh` with a valid refresh token to obtain new access token.

All authenticated endpoints require an `Authorization: Bearer <token>` header.

## Notes

- Tokens expire after a configurable period; expired access tokens can be refreshed.
- Customize validation, error handling, and DTOs as needed.

---