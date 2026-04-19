# Dependency Update Design

## Goal

Update all outdated libraries in the Flutter base project, one at a time, verifying the build after each. Remove unused dependencies. Replace unmaintained ones.

## Current State

- Flutter 3.41.7 / Dart 3.11.5
- 12 direct/dev dependencies, several with major version gaps
- 3 unused dependencies (`get_it`, `freezed`, `freezed_annotation`)
- 1 unmaintained dependency (`dartz`)
- Core architecture: Riverpod `StateNotifier` + Dio + dartz `Either`

## Changes

### Phase 1: Remove Unused Dependencies

Remove from `pubspec.yaml`:
- `get_it` (constraint `^7.6.4`) — not imported anywhere; Riverpod handles DI
- `freezed` (constraint `^2.4.7`) — not used in any code
- `freezed_annotation` (constraint `^2.4.1`) — not used in any code

**Keep** `json_annotation`, `json_serializable`, `build_runner` — will convert existing models to use `@JsonSerializable()`.

Build and run tests after removal.

### Phase 2: Convert Models to json_serializable

Do this before the high-risk Riverpod migration so issues are easier to isolate.

**Files affected (all 5 classes need `@JsonSerializable()`):**
- `lib/models/user.dart` — `User`, `Address`, `Geo`, `Company` (4 classes, single `part` directive)
- `lib/models/post.dart` — `Post` (1 class)

**Migration per file:**
1. Add `import 'package:json_annotation/json_annotation.dart';`
2. Add `part '<filename>.g.dart';` directive
3. Add `@JsonSerializable()` annotation on every class in the file
4. Replace manual `fromJson` body with `=> _$<ClassName>FromJson(json)`
5. Replace manual `toJson` body with `=> _$<ClassName>ToJson(this)`
6. Preserve custom `==`/`hashCode` overrides on `User` and `Post` (json_serializable does not touch these)
7. Preserve `Address.fullAddress` getter (unaffected by json_serializable)

**Code generation command:** `dart run build_runner build --delete-conflicting-outputs`

Run tests after — existing model tests should pass unchanged since serialization behavior is identical.

### Phase 3: Minor/Patch Updates (Low Risk)

Update constraints in `pubspec.yaml` one at a time, run `flutter pub get`, build and test after each:

1. **`cupertino_icons`** `^1.0.8` -> `^1.0.9` — icon asset update, no code changes
2. **`dio`** `^5.3.4` -> `^5.9.2` — bug fixes, no API changes
3. **`mockito`** `^5.4.4` -> `^5.6.4` — test tooling, no production impact
4. **`json_annotation`** `^4.8.1` -> `^4.11.0` — minor, no breaking changes
5. **`json_serializable`** `^6.7.1` -> `^6.13.1` — minor, no breaking changes
6. **`build_runner`** `^2.4.7` -> `^2.13.1` — build tooling update

### Phase 4: Replace dartz with fpdart

**Why:** dartz is unmaintained (~2 years no commits). fpdart is actively maintained and nearly API-compatible.

**Target version:** `fpdart: ^1.1.0`

**Files affected:**
- `lib/core/data/base_repository.dart` — imports `dartz`, uses `Either`, `Left`, `Right`
- `lib/core/state/base_state.dart` — imports `dartz`, uses `Either` in function signatures and `.fold()`
- `lib/core/api/api_service.dart` — imports `dartz`, uses `Either`, `Left` in return types

**Migration:**
- Remove `dartz: ^0.10.1` from pubspec, add `fpdart: ^1.1.0`
- Change imports from `package:dartz/dartz.dart` to `package:fpdart/fpdart.dart`
- `Left(value)` -> `Either.left(value)`
- `Right(value)` -> `Either.right(value)`
- `const Right(true)` (line 161 of base_repository.dart) -> `Either.right(true)` (not const-constructible in fpdart)
- `.fold()` stays the same — fpdart supports it

Build and run all tests after.

### Phase 5: flutter_lints 5 -> 6

**Why major:** New lint rules may flag existing code.

**Approach:**
- Update constraint `^5.0.0` -> `^6.0.0` in pubspec
- Verify `analysis_options.yaml` include path still works (check if package name or include path changed)
- Run `flutter analyze`
- Fix any new lint warnings
- Build and run tests

### Phase 6: flutter_riverpod 2 -> 3 (Largest Change)

**Target version:** `flutter_riverpod: ^3.3.1`

**Why major:** Riverpod 3 deprecates `StateNotifier` and `StateNotifierProvider` in favor of `Notifier` and `NotifierProvider`.

**Files affected (all StateNotifier usage):**
- `lib/core/state/base_state.dart` — `DataListNotifier<T> extends StateNotifier`, `DataItemNotifier<T> extends StateNotifier`
- `lib/core/api/api_service.dart` — `ApiServiceFactory` creates `StateNotifierProvider`s
- `lib/core/providers/api_providers.dart` — type annotations reference `StateNotifierProvider`, `DataListNotifier`, `DataItemNotifier`
- `test/core/providers/api_providers_test.dart` — tests use `isA<StateNotifierProvider>()` assertions (must change to `isA<NotifierProvider>()`)

**Pages:**
- `lib/pages/users_page.dart` — `ConsumerWidget`, `ref.watch()`, `ref.read().notifier` (no changes needed)
- `lib/pages/posts_page.dart` — `ConsumerWidget`, `ref.watch()`, **`ref.refresh()` on line 24 needs attention** (in Riverpod 3, `ref.refresh()` returns the new state value; verify the call site still works correctly since it's used as `onRetry` callback)
- `lib/main.dart` — `ProviderScope` (no changes needed)

#### Concrete Migration Pattern for Generic Notifiers

The core challenge: `DataListNotifier<T>` currently takes function parameters (`fetchList`, `createItem`, etc.) in its constructor. Riverpod 3's `Notifier` does not support constructor parameters — initial setup happens in `build()`.

**Solution: Abstract generic base + concrete subclasses per entity.**

**base_state.dart — Abstract base notifier:**
```dart
abstract class DataListNotifier<T> extends Notifier<DataListState<T>> {
  // Subclasses provide the API service
  ApiService<T> get service;
  ApiConfig<T> get config;

  @override
  DataListState<T> build() {
    // Fire-and-forget async load — widget briefly sees empty initial state,
    // then loading state, then data. Same UX as current behavior.
    loadData();
    return DataListState<T>();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await service.getAll();
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (items) => state = state.copyWith(isLoading: false, items: items, error: null),
    );
  }

  Future<void> refresh() async { /* same pattern */ }
  Future<void> create(Map<String, dynamic> data) async { /* same pattern */ }
  Future<void> update(T item, Map<String, dynamic> data) async { /* same pattern */ }
  Future<void> delete(T item) async { /* same pattern */ }
  void clearError() { state = state.copyWith(error: null); }
}

abstract class DataItemNotifier<T> extends Notifier<DataItemState<T>> {
  Future<Either<Failure, T>> fetchItem();

  @override
  DataItemState<T> build() {
    loadData();
    return DataItemState<T>();
  }

  Future<void> loadData() async { /* same pattern */ }
  void clearError() { state = state.copyWith(error: null); }
}
```

**api_providers.dart — Concrete notifiers (tiny):**
```dart
class UsersNotifier extends DataListNotifier<User> {
  @override
  ApiConfig<User> get config => ApiConfig<User>(
    endpoint: '/users',
    fromJson: User.fromJson,
    toJson: (user) => user.toJson(),
    getId: (user) => user.id,
  );

  @override
  ApiService<User> get service => ApiServiceFactory.createCRUD(config);
}

class PostsNotifier extends DataListNotifier<Post> {
  @override
  ApiConfig<Post> get config => ApiConfig<Post>(
    endpoint: '/posts',
    fromJson: Post.fromJson,
    toJson: (post) => post.toJson(),
    getId: (post) => post.id,
  );

  @override
  ApiService<Post> get service => ApiServiceFactory.createCRUD(config);
}
```

**Provider registration:**
```dart
class ApiProviders {
  ApiProviders._();

  static final usersProvider =
      NotifierProvider<UsersNotifier, DataListState<User>>(UsersNotifier.new);

  static final postsProvider =
      NotifierProvider<PostsNotifier, DataListState<Post>>(PostsNotifier.new);
}
```

**Impact on "2 files per API feature":** Becomes "2 files + 1 small notifier class" per feature. The notifier class is ~10 lines and lives alongside the provider registration in `api_providers.dart`, so it's still effectively 2 files.

**ApiServiceFactory changes:** Remove `createListProvider` and `createItemProvider` methods (no longer needed — providers are created directly). Keep `createReadOnly` and `createCRUD` as utility methods.

**Test changes:**
- `api_providers_test.dart`: Change `isA<StateNotifierProvider>()` -> `isA<NotifierProvider>()`
- `base_state_test.dart`: Update any direct `DataListNotifier` instantiation to use concrete subclass or test helper

Build and run all tests after migration.

### Phase 7: Update CLAUDE.md

Update the project documentation to reflect:
- Removed dependencies (get_it, freezed, freezed_annotation)
- dartz replaced with fpdart
- Riverpod 3 Notifier pattern (abstract base + concrete subclasses)
- json_serializable model pattern with `dart run build_runner build`
- Updated dependency versions

## Update Order (Sequential)

| Step | Package(s) | Risk | Verify |
|------|-----------|------|--------|
| 1 | Remove `get_it`, `freezed`, `freezed_annotation` | None | Build + Tests |
| 2 | Convert models to `@JsonSerializable` | Medium | Build + Tests + Build Runner |
| 3 | `cupertino_icons` ^1.0.9 | None | Build + Tests |
| 4 | `dio` ^5.9.2 | None | Build + Tests |
| 5 | `mockito` ^5.6.4 | None | Build + Tests |
| 6 | `json_annotation` ^4.11.0 | None | Build + Tests |
| 7 | `json_serializable` ^6.13.1 | None | Build + Tests |
| 8 | `build_runner` ^2.13.1 | Low | Build + Tests |
| 9 | `dartz` -> `fpdart` ^1.1.0 | Medium | Build + Tests |
| 10 | `flutter_lints` ^6.0.0 | Medium | Build + Analyze + Tests |
| 11 | `flutter_riverpod` ^3.3.1 | High | Build + Analyze + Tests |
| 12 | Update `CLAUDE.md` | None | N/A |

## Testing Strategy

- Run `flutter analyze` after every step
- Run `flutter test` after every step
- Run `flutter build apk` after steps 1, 2, 9, 11 (key milestones)
- All 6 existing test files must pass at every step
