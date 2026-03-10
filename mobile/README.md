# 📱 Flutter Starter

A Flutter application that provides a complete user onboarding experience followed by secure authentication with JWT token management, including automatic token refresh functionality.

## Features

- **Onboarding Flow**: Interactive onboarding screens to introduce users to the app.
- **User Authentication**: Full registration and login system with secure JWT-based authentication.
- **JWT Token Management**: Automatic refresh of expired access tokens to maintain seamless user sessions.
- **Home Screen**: Main dashboard after login.
- **Profile Screen**: User profile management.
- **State Management**: Uses Riverpod for efficient state management.
- **Network Layer**: Robust HTTP client with Dio, including interceptors for authentication and logging.
- **Secure Storage**: JWT tokens stored securely using Flutter Secure Storage.
- **Routing**: Declarative routing with GoRouter.

## Getting Started

### Prerequisites

- Flutter SDK (^3.10.4)
- Dart SDK (^3.10.4)

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd fsp_starter
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Build

To build for production:

```bash
flutter build apk  # For Android
flutter build ios  # For iOS
flutter build web  # For Web
```

## Project Structure

```
lib
├───main.dart                    # App entry point, initializes providers and checks onboarding status
├───app.dart                     # Main app widget with MaterialApp and router configuration
│
├───core                         # Core application components
│   │   core_providers.dart      # Exports core providers for network, storage, and auth
│   │
│   ├───routing
│   │       app_router.dart      # GoRouter configuration with routes for all screens
│   │
│   ├───constants
│   │       app_routes.dart      # String constants for route paths
│   │       storage_keys.dart    # String constants for storage keys
│   │
│   ├───widgets
│   │       app_button.dart      # Reusable button widget
│   │       app_text_field.dart  # Reusable text field widget
│   │       app_widgets.dart     # Collection of common app widgets
│   │
│   ├───network
│   │       api_exception.dart   # Custom exception classes for API errors
│   │       dio_provider.dart    # Dio HTTP client provider with interceptors
│   │       api_client.dart      # API client wrapper for HTTP requests
│   │       auth_interceptor.dart # Interceptor for JWT auth and token refresh
│   │
│   └───storage
│           secure_storage.dart  # Provider for Flutter Secure Storage
│           shared_prefs.dart    # Provider for SharedPreferences
│           jwt_storage.dart     # JWT token storage and retrieval logic
│
└───features                    # Feature-based architecture
    ├───home
    │   ├───view
    │   │   ├───pages
    │   │   │       home_screen.dart     # Main home screen after login
    │   │   │       main_scaffold.dart   # Scaffold with bottom navigation
    │   │   │
    │   │   └───widgets
    │   │           home_banner.dart     # Banner widget for home screen
    │   │
    │   └───model                    # Home-related data models (if any)
    ├───profile
    │   └───view
    │       └───pages
    │               profile_screen.dart  # User profile screen
    │
    ├───auth
    │   │   auth_provider.dart      # Auth-related providers and state
    │   │
    │   ├───data
    │   │   ├───models
    │   │   │       auth_request.dart   # Request models for auth API
    │   │   │       login_response.dart # Response models for login API
    │   │   │
    │   │   └───repository
    │   │           auth_repository.dart # Repository for auth API calls
    │   │
    │   └───presentation
    │       ├───view_models
    │       │       register_notifier.dart # State management for registration
    │       │       login_notifier.dart    # State management for login
    │       │
    │       └───views
    │               login_screen.dart     # Login UI screen
    │               signup_screen.dart    # Registration UI screen
    │
    └───onboarding
        │   onboarding_provider.dart # Onboarding-related providers
        │
        ├───presentation
        │   ├───views
        │   │       onboarding_screen.dart # Onboarding UI screens
        │   │
        │   └───view_models
        │           onboarding_notifier.dart # State management for onboarding
        │
        └───data
            └───repository
                    onboarding_repository.dart # Repository for onboarding data
```

## Key Components Description

### Core Layer
- **main.dart**: Initializes the app, sets up shared preferences and cookie storage, determines initial route based on onboarding completion.
- **app.dart**: Configures the MaterialApp with theme and router.
- **Routing**: Uses GoRouter for navigation with shell routes for bottom navigation.
- **Network**: Dio-based HTTP client with auth interceptor that automatically refreshes JWT tokens on 401 errors.
- **Storage**: Secure storage for JWT tokens, shared preferences for app state.

### Features
- **Auth**: Complete authentication flow with login/register screens, JWT handling, and automatic token refresh.
- **Onboarding**: Introductory screens shown on first app launch.
- **Home**: Main app screen with banner and navigation.
- **Profile**: User profile management screen.

## Dependencies

- `flutter_riverpod`: State management
- `go_router`: Declarative routing
- `dio`: HTTP client
- `flutter_secure_storage`: Secure token storage
- `shared_preferences`: Local app preferences
- `cookie_jar`: Cookie management
- `smooth_page_indicator`: Onboarding page indicators

## Architecture

This app follows a clean architecture pattern with:
- **Presentation Layer**: UI screens and view models using Riverpod notifiers
- **Data Layer**: Repositories handling API calls and local storage
- **Core Layer**: Shared utilities, network, routing, and storage

<!-- ## Contributing

1. Follow the existing project structure
2. Use Riverpod for state management
3. Implement proper error handling
4. Add tests for new features

## License

This project is private and not intended for publication. -->