# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Development Commands

```bash
flutter pub get              # Install dependencies
flutter run                  # Run on connected device
flutter run -d chrome        # Run on web
flutter test                 # Run all tests
flutter test test/models/user_test.dart  # Run a single test file
flutter analyze              # Run linter (uses flutter_lints)
flutter build apk            # Build Android APK
flutter build web            # Build for web
flutter clean                # Clean build artifacts
flutter pub run build_runner build  # Code generation (freezed/json_serializable deps are installed but models currently use manual serialization)
```

## Architecture: Unified API Architecture

This project uses a **Unified API Architecture** built on Riverpod + Dio + dartz (Either pattern). The core idea: **2 files per API feature** (a model + a provider registration) instead of 12+ files in traditional Clean Architecture.

### Core Framework (`lib/core/`)

- **`api/api_service.dart`** — `ApiServiceFactory` creates Riverpod `StateNotifierProvider`s from an `ApiConfig<T>`. Provides full CRUD (GET list, GET single, POST, PUT, DELETE) with automatic state management.
- **`state/base_state.dart`** — Generic state classes: `DataListState<T>` and `DataItemState<T>` with loading/error/success transitions. `DataListNotifier<T>` and `DataItemNotifier<T>` are the corresponding StateNotifiers.
- **`data/base_repository.dart`** — Generic HTTP operations returning `Either<Failure, T>` via dartz.
- **`network/api_client.dart`** — Dio HTTP client configuration. Base URL: JSONPlaceholder (`https://jsonplaceholder.typicode.com`).
- **`providers/api_providers.dart`** — Centralized provider registry with extension methods on `WidgetRef` (e.g., `ref.usersState`, `ref.usersNotifier`).
- **`errors/failures.dart`** — Error type definitions.
- **`baseui/error_api.dart`** — Reusable `ErrorApiWidget` for consistent error display with retry.

### Adding a New API Feature

1. Create a model in `lib/models/` with `fromJson`/`toJson`
2. Register a provider in `lib/core/providers/api_providers.dart` using `ApiServiceFactory.createListProvider<T>(ApiConfig<T>(...))` and add extension methods on `WidgetRef`

### Key Patterns

- Pages extend `ConsumerWidget` (Riverpod) and live in `lib/pages/`
- State is accessed via `ref.watch()` on providers from `ApiProviders`
- Error handling flows through `Either<Failure, T>` from dartz
- App entry (`lib/main.dart`) wraps the app in `ProviderScope` with Material 3 theming

## Testing

Tests are in `test/` mirroring the `lib/` structure. Uses `flutter_test` and `mockito`. Tests cover model serialization, state transitions, provider definitions, widget rendering, and navigation. No integration tests or network mocking — tests focus on unit and widget levels.

## Project Context

- Flutter SDK `^3.8.0`, Dart SDK `^3.8.0`
- Template project using JSONPlaceholder as a demo API
- Multi-platform: Android, iOS, Web
- Main branch: `develop`
