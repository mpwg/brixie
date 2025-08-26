# 🧱Brixie

Brixie is an App for accessing [Rebrickable](https://rebrickable.com)

**Website:**

## Supported Platforms

- **Cross-Platform:** Flutter app supporting both iOS and Android
- **iOS:** Version 26+ (Xcode 26) - Native SwiftUI app (legacy)
- **Android:** Version 14+ (API Level 34) - Native Kotlin app (legacy)

## Technology Stack

### Flutter (Primary)
- **Languages:** Dart
- **UI Framework:** Flutter/Material Design
- **Async/Reactive:** Future/Stream
- **Networking:** HTTP/Dio
- **Persistence:** SQLite/SharedPreferences
- **State Management:** BLoC Pattern

### iOS (Legacy)
- **Languages:** Swift
- **UI Framework:** SwiftUI
- **Async/Reactive:** Combine/async-await
- **Networking:** URLSession
- **Persistence:** Core Data

### Android (Legacy)
- **Languages:** Kotlin
- **UI Framework:** Jetpack Compose
- **Async/Reactive:** Coroutines/Flow
- **Networking:** Ktor
- **Persistence:** Room

### CI/CD
- **GitHub Actions** for automated testing and builds

## Architecture & Design Principles

- **MVVM/Unidirectional Data Flow** for predictable state management
- **Modular architecture** for maintainability and testability
- **Comprehensive testing** across all layers
- **Accessibility-first design** following platform guidelines

## Features

- 🔍 **Search** sets, parts, and MOCs from Rebrickable
- 📱 **Set and part details** with comprehensive information
- ⭐ **Favorites management** for quick access to preferred items
- 📱 **Offline caching** for seamless browsing without connectivity
- 🎨 **Native platform UI** optimized for iOS and Android

## API & Privacy

- Integrates with the [Rebrickable API](https://rebrickable.com/api/)
- Only required data is stored locally
- Follows Rebrickable API terms of service and rate limits
- No personal data is collected beyond app functionality requirements

## Development Setup

### Prerequisites

- **Flutter Development (Primary):**
  - Flutter SDK 3.10.0+
  - Dart 3.0.0+
  - Android Studio or VS Code
  - iOS development requires macOS with Xcode

- **iOS Development (Legacy):**
  - Xcode 26 (current/latest)
  - macOS with latest version
  - Valid Apple Developer account (for device testing)

- **Android Development (Legacy):**
  - Android Studio (current/latest)
  - Java 17
  - Android SDK with API Level 34+

- **API Access:**
  - Rebrickable API key (required for data access)

### Flutter Build Steps (Primary)

1. Clone the repository
2. Navigate to the Flutter project: `cd flutter/`
3. Install dependencies: `flutter pub get`
4. Generate code: `dart run build_runner build`
5. Configure your Rebrickable API key: `export REBRICKABLE_API_KEY="your_key"`
6. Run the app: `flutter run`

### iOS Build Steps (Legacy)

1. Clone the repository
2. Open the Xcode workspace/project
3. Configure your Rebrickable API key in the app configuration
4. Select your target device or simulator
5. Build and run (⌘+R)

### Android Build Steps (Legacy)

1. Clone the repository
2. Open the project in Android Studio
3. Configure your Rebrickable API key in the app configuration
4. Sync project with Gradle files
5. Select your target device or emulator
6. Build and run

### Running Tests

#### Flutter (Primary)
```bash
cd flutter/
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

#### iOS (Legacy)
```bash
# Run unit tests
xcodebuild test -workspace Brixie.xcworkspace -scheme Brixie -destination 'platform=iOS Simulator,name=iPhone 15'

# Run UI tests
xcodebuild test -workspace Brixie.xcworkspace -scheme BrixieUITests -destination 'platform=iOS Simulator,name=iPhone 15'
```

#### Android (Legacy)
```bash
# Run unit tests
./gradlew test

# Run instrumented tests
./gradlew connectedAndroidTest
```

## Contributing

We welcome contributions! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) guide for details on our development process, coding standards, and how to submit pull requests.

## License

This project is licensed under the **AGPL-3.0 License** - see the [LICENSE](LICENSE) file for details.

The AGPL-3.0 is a copyleft license that requires derivative works to also be open source. If you use this code in a network service, the source code must be made available to users.

## Resources

- **Project Website:** [https://brixie.net](https://brixie.net)
- **Repository:** [https://github.com/mpwg/brixie](https://github.com/mpwg/brixie)
- **Rebrickable API:** [https://rebrickable.com/api/](https://rebrickable.com/api/)

## Screenshots & Assets

Screenshots and app assets will be available at [brixie.net](https://brixie.net) once the app is in development.

---

For questions, suggestions, or support, visit [brixie.net](https://brixie.net) or open an issue in this repository.
