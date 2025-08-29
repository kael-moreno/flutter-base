# Flutter Base Project

A beginner-friendly Flutter application template focused on mobile and web development.

## 📱 Project Overview

This is a Hello World Flutter project designed for beginners to learn cross-platform development. It includes:

- Clean project structure without path space issues
- Proper `.gitignore` and `.gitattributes` configuration
- Multi-platform support (Android, iOS, Web)
- VS Code configuration with Flutter extension

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [VS Code](https://code.visualstudio.com/) with Flutter extension
- [Android Studio](https://developer.android.com/studio) (for Android development)
- [Xcode](https://developer.apple.com/xcode/) (for iOS development on macOS)
- Git (for version control)

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/CoreProc/flutter-base.git
   cd flutter-base
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   # For Android
   flutter run -d android
   
   # For iOS (macOS only)
   flutter run -d ios
   
   # For Web
   flutter run -d chrome
   ```

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
```

## 📱 Platform Support

- ✅ **Android** - Full native Android app support
- ✅ **iOS** - Full native iOS app support  
- ✅ **Web** - Progressive Web App (PWA) support

## 📚 Learning Resources

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter documentation](https://docs.flutter.dev/)

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
