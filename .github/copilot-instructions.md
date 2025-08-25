# 🧱 Brixie Mobile App Development Instructions

Brixie is a mobile application for accessing Rebrickable, built with native iOS (Swift/SwiftUI) and Android (Kotlin/Compose) platforms.

**ALWAYS reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## Working Effectively

### Android Development Setup
```bash
# Navigate to Android project
cd android/

# Fix AGP/Gradle version compatibility (REQUIRED FIRST STEP)
# The project has version mismatches that must be resolved before building
# Note: This requires network access to download Android Gradle Plugin

# Check current versions
cat android/gradle/libs.versions.toml
cat android/gradle/wrapper/gradle-wrapper.properties

# Build debug APK -- Network required for first build. Takes 5-10 minutes first time. NEVER CANCEL. Set timeout to 20+ minutes.
# Note: Will fail in environments without access to Google repositories
./gradlew assembleDebug --no-daemon --stacktrace

# Run unit tests -- takes 2-5 minutes. NEVER CANCEL. Set timeout to 15+ minutes.
./gradlew test --no-daemon --stacktrace

# Run instrumented tests (requires emulator/device)
./gradlew connectedAndroidTest --no-daemon --stacktrace

# Lint code
./gradlew ktlintCheck --no-daemon --stacktrace
```

### iOS Development Setup
```bash
# Navigate to iOS project
cd ios/

# Install CocoaPods dependencies (if Podfile exists)
pod install --repo-update

# Build iOS app -- takes 3-5 minutes. NEVER CANCEL. Set timeout to 15+ minutes.
xcodebuild -project ios.xcodeproj -scheme ios -destination 'platform=iOS Simulator,name=iPhone 15' clean build

# Run unit tests -- takes 2-3 minutes. NEVER CANCEL. Set timeout to 10+ minutes.
xcodebuild test -project ios.xcodeproj -scheme ios -destination 'platform=iOS Simulator,name=iPhone 15'

# Run UI tests -- takes 5-10 minutes. NEVER CANCEL. Set timeout to 20+ minutes.
xcodebuild test -project ios.xcodeproj -scheme iosUITests -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Critical Prerequisites

### iOS Development Requirements
- **macOS** with latest version
- **Xcode 26** (current/latest) - Download from App Store or Apple Developer
- **Valid Apple Developer account** (for device testing)
- **iOS Simulator** configured for iPhone 15 (primary test target)

### Android Development Requirements
- **Java 17** - Install with `apt-get install openjdk-17-jdk` or download from Oracle
- **Android SDK with API Level 34+** - Install via Android Studio or CLI tools
- **Android Studio** (current/latest) - Download from developer.android.com
- **Emulator or physical device** with Android 14+ (API Level 34)

### API Access Requirements
- **Rebrickable API key** - Register at https://rebrickable.com/api/
- Configure API key in app configuration files before building

## Validation

### Manual Testing Scenarios
**ALWAYS run through at least one complete end-to-end scenario after making changes:**

#### Android App Testing
**Note**: The Android app is in early development.

1. Launch app in emulator: `./gradlew installDebug` then launch from app drawer
2. Test core app functionality (once implemented):
   - Search for LEGO sets (when Rebrickable integration is complete)
   - Navigate through app screens
   - Test favorites functionality
   - Test offline mode capabilities

**Current Implementation Status:**
- Android project structure is set up with basic template
- Jetpack Compose UI framework configured
- Not yet integrated with Rebrickable API
- Basic unit test example in place

#### iOS App Testing  
**Note**: The iOS app is currently in initial development with template content.

1. Launch app in simulator: Use Xcode or command line build
2. Test basic functionality: Add/remove items from the list
3. Test SwiftData persistence: Add items, close app, reopen and verify data persists
4. Test navigation: Tap on items to view detail screen
5. Test platform-specific UI: Edit button, toolbar, navigation split view

**Current Implementation Status:**
- iOS app uses SwiftData for persistence (not Core Data as in README)
- App has basic list/detail navigation with item management
- Placeholder content for development - not yet integrated with Rebrickable API

### Pre-commit Validation
**ALWAYS run these commands before committing changes:**

#### Android
```bash
cd android/
./gradlew ktlintCheck --no-daemon
./gradlew test --no-daemon
```

#### iOS
```bash
cd ios/
# Run SwiftLint if configured
swiftlint lint
# Run unit tests
xcodebuild test -project ios.xcodeproj -scheme ios -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Build Timing and Timeouts

### Android Build Times
- **Initial Gradle sync**: 2-5 minutes - NEVER CANCEL
- **Clean build**: 5-10 minutes - NEVER CANCEL, timeout: 20+ minutes  
- **Incremental build**: 1-3 minutes - timeout: 10+ minutes
- **Unit tests**: 2-5 minutes - NEVER CANCEL, timeout: 15+ minutes
- **Instrumented tests**: 10-20 minutes - NEVER CANCEL, timeout: 30+ minutes
- **Lint check**: 1-2 minutes - timeout: 5+ minutes

### iOS Build Times  
- **Clean build**: 3-5 minutes - NEVER CANCEL, timeout: 15+ minutes
- **Incremental build**: 30 seconds - 2 minutes - timeout: 5+ minutes
- **Unit tests**: 2-3 minutes - NEVER CANCEL, timeout: 10+ minutes
- **UI tests**: 5-10 minutes - NEVER CANCEL, timeout: 20+ minutes

## Repository Structure

### Key Project Directories
```
/android/               # Android Kotlin project
  /app/                 # Main Android application module
    /src/main/          # Application source code
    /src/test/          # Unit tests
    /src/androidTest/   # Instrumented tests
  /gradle/              # Gradle configuration
  build.gradle.kts      # Main build configuration
  settings.gradle.kts   # Project settings

/ios/                   # iOS Swift project  
  /ios/                 # Main iOS app target
  /iosTests/            # Unit tests
  /iosUITests/          # UI tests
  ios.xcodeproj/        # Xcode project file

/pages/                 # GitHub Pages site (placeholder)
  .gitignore            # Jekyll gitignore for future web content

/.github/
  /workflows/           # CI/CD automation
    android.yml         # Android build pipeline
    ios.yml             # iOS build pipeline
  dependabot.yml        # Automated dependency updates
  copilot-instructions.md # This file
```

### Important Configuration Files
- `android/gradle/libs.versions.toml` - Android dependency versions
- `android/gradle/wrapper/gradle-wrapper.properties` - Gradle version
- `android/app/build.gradle.kts` - Android app configuration
- `ios/ios.xcodeproj/project.pbxproj` - iOS project configuration

## Known Issues and Workarounds

### Android Configuration Issues  
⚠️ **CRITICAL**: The project has AGP/Gradle version compatibility issues that MUST be fixed before building:

1. **Symptom**: Build fails with "Plugin [id: 'com.android.application'] was not found"
2. **Root cause**: Initial setup uses incompatible Gradle/AGP versions and network access to Google repositories may be limited
3. **Fix**: Update `android/gradle/libs.versions.toml` to use compatible AGP version and ensure Gradle wrapper uses compatible version
4. **Network dependency**: Android builds require internet access to download AGP from Google repositories - builds will fail in offline environments
5. **Workaround**: Ensure network connectivity or use a pre-configured environment with cached dependencies

### iOS Configuration
- iOS builds require macOS environment - cannot be tested on Linux
- Xcode simulator must be properly configured before running tests
- Check for Podfile and run `pod install` if using CocoaPods

### Network and Dependencies
- Android builds require network access to Google repositories for AGP and dependencies
- Builds will fail in environments with limited internet access or firewall restrictions  
- First-time builds download significant dependencies (500MB+)
- Use `--offline` flag only after initial dependency download
- Dependabot automatically updates dependencies daily for all platforms

## CI/CD Integration

The repository uses GitHub Actions for automated builds:

### Android CI (`.github/workflows/android.yml`)
- Runs on Ubuntu with Java 17
- Caches Gradle dependencies for faster builds
- Builds debug APK, runs tests, and performs lint checks
- Uploads artifacts for test results and APK

### iOS CI (`.github/workflows/ios.yml`) 
- Runs on macOS with latest Xcode
- Caches Swift Package Manager and CocoaPods dependencies
- Builds iOS app for simulator
- Uploads build logs on failure

### Local validation matches CI
**ALWAYS run the same commands locally that CI runs:**
- Android: `./gradlew assembleDebug test ktlintCheck`
- iOS: Build and test via xcodebuild commands

## Quick Reference Commands

### Most Common Operations
```bash
# Android: Full build and test cycle
cd android && ./gradlew clean assembleDebug test ktlintCheck --no-daemon

# iOS: Full build and test cycle  
cd ios && xcodebuild clean build test -project ios.xcodeproj -scheme ios -destination 'platform=iOS Simulator,name=iPhone 15'

# Check repository status
git status && git diff --name-only

# View build configuration
cat android/gradle/libs.versions.toml
cat android/gradle/wrapper/gradle-wrapper.properties
```

### Troubleshooting Commands
```bash
# Android: Clear Gradle cache
cd android && ./gradlew clean --no-daemon
rm -rf ~/.gradle/caches/

# Android: Check configuration
./gradlew --version
./gradlew projects

# iOS: Check Xcode setup
xcodebuild -version
xcrun simctl list devices
```

Remember: **NEVER CANCEL** long-running builds or tests. Mobile app builds are inherently time-consuming, especially clean builds and comprehensive test suites.