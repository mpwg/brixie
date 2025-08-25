# Contributing to Brixie

Thank you for your interest in contributing to Brixie! This document outlines our contribution process and coding standards to help ensure a smooth collaboration.

## Contribution Workflow

### Before Making Changes

1. **Open an issue first** for any major changes, new features, or architectural decisions
2. **Check existing issues** to avoid duplicating work
3. **Discuss your approach** with maintainers before starting development

### Making Contributions

1. **Fork the repository** and create your feature branch from `main`
2. **Follow branch naming conventions:**
   - Features: `feature/description` (e.g., `feature/offline-caching`)
   - Bug fixes: `fix/description` (e.g., `fix/search-crash`)
   - Documentation: `docs/description` (e.g., `docs/api-guide`)
   - CI/CD: `ci/description` (e.g., `ci/android-tests`)

3. **Create a pull request** with:
   - Clear description of changes
   - Reference to related issue(s)
   - Testing steps for reviewers
   - Screenshots for UI changes

4. **Run tests locally** before submitting your PR

## Coding Standards

### iOS (Swift)
- **Use SwiftLint** for code style enforcement
- **Follow Swift API Design Guidelines**
- **Prefer SwiftUI** over UIKit for new UI development
- **Use async/await** for asynchronous operations
- **Write unit tests** for business logic and ViewModels
- **Write UI tests** for critical user flows

### Android (Kotlin)
- **Use ktlint** for code style enforcement
- **Follow Kotlin coding conventions**
- **Prefer Jetpack Compose** for UI development
- **Use Coroutines and Flow** for asynchronous operations
- **Write unit tests** for business logic and ViewModels
- **Write instrumented tests** for critical functionality

### General Requirements
- **Tests are required** for all new features and bug fixes
- **Documentation updates** are required for API changes
- **Commit messages** should be clear and descriptive:
  - Use present tense: "Add feature" not "Added feature"
  - Capitalize first letter
  - Keep under 50 characters for the subject line
  - Include issue reference when applicable

### Example Commit Messages
```
Add offline caching for set details (#123)

Fix crash when searching with empty query (#456)

Update API documentation for favorites endpoint

Improve accessibility for search results screen
```

## Development Environment

### Running iOS Development Build
```bash
# Install dependencies
pod install  # if using CocoaPods

# Build and run
xcodebuild -workspace Brixie.xcworkspace -scheme Brixie -destination 'platform=iOS Simulator,name=iPhone 15' clean build

# Run tests
xcodebuild test -workspace Brixie.xcworkspace -scheme Brixie -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Running Android Development Build
```bash
# Build debug version
./gradlew assembleDebug

# Run tests
./gradlew test
./gradlew connectedAndroidTest

# Lint code
./gradlew ktlintCheck
```

## Review Process

### Pull Request Reviews
1. **All PRs require at least one approval** from a maintainer
2. **CI must pass** before merging
3. **Address feedback promptly** and update your PR accordingly
4. **Squash commits** if requested to maintain clean history

### Review Criteria
- Code follows established patterns and conventions
- Tests provide adequate coverage
- Documentation is updated if needed
- Performance implications are considered
- Accessibility guidelines are followed
- Privacy and security requirements are met

### Requesting Changes
- Reviewers will provide specific, actionable feedback
- Use GitHub's "Request Changes" feature for required modifications
- Re-request review after addressing feedback

## Getting Help

- **Questions about contribution process:** Open a discussion or issue
- **Technical questions:** Tag relevant maintainers in your PR or issue
- **General questions:** Check existing issues or start a new discussion

## Code of Conduct

We are committed to providing a welcoming and inclusive environment. Please:
- Be respectful and constructive in all interactions
- Focus on what is best for the community
- Show empathy towards other community members
- Accept responsibility and apologize when mistakes are made

Thank you for contributing to Brixie! 🚀