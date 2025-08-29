# Flutter Base Project

A foundational Flutter application template designed to serve as a starting point for future mobile and web projects.

## 📱 Project Overview

This repository serves as a **base template** for all future Flutter projects. It provides a clean, well-structured foundation that can be cloned and customized for specific project requirements. 

**Key Features:**
- Clean project structure without path space issues
- Proper `.gitignore` and `.gitattributes` configuration  
- Multi-platform support (Android, iOS, and Web)
- VS Code configuration with Flutter extension
- Comprehensive documentation and setup instructions
- Repository-ready configuration following best practices

## 🎯 Purpose

This base project eliminates the repetitive setup work for new Flutter applications by providing:
- ✅ **Standardized project structure**
- ✅ **Pre-configured development environment**
- ✅ **Clean Git configuration** 
- ✅ **Documentation templates**
- ✅ **Platform-specific optimizations**

Use this as your starting point, then customize it for your specific project needs.

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [VS Code](https://code.visualstudio.com/) with Flutter extension
- [Android Studio](https://developer.android.com/studio) (for Android development)
- [Xcode](https://developer.apple.com/xcode/) (for iOS development on macOS)
- Git (for version control)

### Installation

1. **Use this template** for a new project:
   ```bash
   git clone https://github.com/CoreProc/flutter-base.git your-new-project
   cd your-new-project
   ```

2. **Customize for your project**:
   ```bash
   # Remove existing git history
   rm -rf .git
   
   # Initialize new git repository
   git init
   
   # Update project name in pubspec.yaml
   # Update README.md with your project details
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   # For Android
   flutter run -d android
   
   # For iOS (macOS only)
   flutter run -d ios
   
   # For Web
   flutter run -d chrome
   ```

## 🛠️ Customization

When using this base for a new project:

1. **Update Project Details**:
   - Modify `pubspec.yaml` with your project name and details
   - Update `README.md` with your project description
   - Customize app icons and splash screens

2. **Configure Platforms**:
   - Update Android package name in `android/app/build.gradle.kts`
   - Update iOS bundle identifier in `ios/Runner.xcodeproj/project.pbxproj`
   - Modify web title and description in `web/index.html`

3. **Add Dependencies**:
   - Add required packages to `pubspec.yaml`
   - Configure any platform-specific dependencies

## 🛠️ Development

### Available Commands

- `flutter run` - Run the app on connected device
- `flutter run -d chrome` - Run on web browser
- `flutter test` - Run tests
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app (macOS only)
- `flutter build web` - Build for web deployment
- `flutter clean` - Clean build files

### Project Structure

```
lib/
  main.dart          # Main application entry point
test/
  widget_test.dart   # Widget tests
android/             # Android-specific code
ios/                 # iOS-specific code
web/                 # Web-specific code
.github/             # GitHub workflows and configurations
```

## 📱 Platform Support

- ✅ **Android** - Full native Android app support
- ✅ **iOS** - Full native iOS app support  
- ✅ **Web** - Progressive Web App (PWA) support

## 🔄 Using as Template

This repository is designed to be used as a template:

1. **For new projects**: Clone this repo and customize it
2. **For learning**: Study the structure and configuration
3. **For teams**: Use as a consistent starting point across projects

### Template Benefits

- ⚡ **Fast project setup** - Skip repetitive configuration
- 🎯 **Consistent structure** - All projects follow same patterns  
- 🔒 **Security ready** - Proper `.gitignore` prevents sensitive data commits
- 📚 **Well documented** - Clear instructions and examples
- 🧪 **Testing ready** - Test framework pre-configured

## 📚 Learning Resources

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter documentation](https://docs.flutter.dev/)

## 🤝 Contributing

This base template welcomes improvements and enhancements:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/TemplateImprovement`)
3. Commit your changes (`git commit -m 'Add template enhancement'`)
4. Push to the branch (`git push origin feature/TemplateImprovement`)
5. Open a Pull Request

### Areas for Contribution
- Additional platform configurations
- Improved documentation
- Development workflow enhancements
- Testing framework improvements

## 📄 License

This project template is open source and available under the [MIT License](LICENSE).
