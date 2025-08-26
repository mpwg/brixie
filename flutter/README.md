# Brixie Flutter App

This is the Flutter version of Brixie, providing cross-platform support for both iOS and Android platforms.

## Features

- 🔍 **Search LEGO Sets and Parts** - Browse Rebrickable database
- 📱 **Cross-Platform** - Single codebase for iOS and Android
- 🎨 **Material Design** - Native platform UI
- ⚡ **API Integration** - Complete Rebrickable API client
- 🛡️ **Type Safety** - Strongly typed Dart models
- 🚨 **Error Handling** - Comprehensive exception hierarchy

## Getting Started

### Prerequisites

- Flutter SDK 3.10.0 or higher
- Dart 3.0.0 or higher
- Rebrickable API key

### Setup

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Generate code:**
   ```bash
   flutter packages pub run build_runner build
   ```

3. **Configure API key:**
   Set the environment variable:
   ```bash
   export REBRICKABLE_API_KEY="your_api_key_here"
   ```

### Running the App

```bash
# Run on all available devices
flutter run

# Run on specific platform
flutter run -d android
flutter run -d ios
```

### Building

```bash
# Build APK for Android
flutter build apk

# Build for iOS
flutter build ios
```

### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## Architecture

The app follows Flutter best practices with:

- **BLoC Pattern** for state management
- **Repository Pattern** for data access
- **Clean Architecture** principles
- **Dependency Injection** for testability

### Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── lego_models.dart     # LEGO data classes
│   └── api_response.dart    # API response wrappers
├── services/                # Business logic
│   ├── rebrickable_api.dart # API client factory
│   └── rebrickable_*.dart   # API implementation
├── screens/                 # UI screens
│   └── home_screen.dart     # Main navigation
└── widgets/                 # Reusable UI components
```

## API Integration

The app integrates with the Rebrickable API v3 providing:

- Sets search and details
- Parts search and details  
- Themes and colors listing
- Comprehensive error handling
- Rate limiting support

### Usage Example

```dart
final apiClient = RebrickableApi.getInstance();
final result = await apiClient.getSets(search: "technic");

result.fold(
  onSuccess: (response) => print("Found ${response.count} sets"),
  onFailure: (error) => print("Error: $error"),
);
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

This project is licensed under the AGPL-3.0 License - see the [LICENSE](../LICENSE) file for details.