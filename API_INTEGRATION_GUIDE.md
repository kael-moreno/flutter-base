# API Integration with Dio - Users Feature

## 🌐 Overview

This documentation covers the implementation of the **Users Feature** which demonstrates:
- **API integration** using Dio HTTP client
- **Clean Architecture** patterns for remote data
- **Error handling** for network operations
- **State management** with Riverpod for async data

## 🏗️ Architecture Implementation

### **API Endpoint Used**
```
https://jsonplaceholder.typicode.com/users
```

### **Data Flow**
```
UI (UsersPage) 
    ↓
State Provider (UsersNotifier) 
    ↓
Use Cases (GetUsers, GetUserById)
    ↓
Repository (UserRepositoryImpl)
    ↓
Data Source (UserRemoteDataSourceImpl)
    ↓
HTTP Client (Dio + ApiClient)
    ↓
External API
```

## 📁 Feature Structure

```
features/users/
├── data/
│   ├── datasources/
│   │   └── user_remote_data_source.dart     # Dio HTTP calls
│   ├── models/
│   │   ├── user_model.dart                  # JSON serialization
│   │   ├── address_model.dart               # Nested model
│   │   └── company_model.dart               # Nested model
│   └── repositories/
│       └── user_repository_impl.dart        # Repository implementation
├── domain/
│   ├── entities/
│   │   ├── user.dart                        # Business objects
│   │   ├── address.dart
│   │   └── company.dart
│   ├── repositories/
│   │   └── user_repository.dart             # Repository contract
│   └── usecases/
│       ├── get_users.dart                   # Fetch all users
│       └── get_user_by_id.dart             # Fetch single user
└── presentation/
    ├── pages/
    │   └── users_page.dart                  # UI screen
    ├── providers/
    │   ├── user_providers.dart              # Dependency injection
    │   └── users_state_provider.dart        # State management
    └── widgets/
        └── user_list_item.dart              # User display widget
```

## 🔧 Key Components

### **1. HTTP Client Setup (ApiClient)**
```dart
class ApiClient {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    _setupInterceptors();
  }
}
```

**Features:**
- ✅ **Timeout configuration** (10 seconds)
- ✅ **Base URL** centralization
- ✅ **Default headers** for JSON
- ✅ **Logging interceptor** for debugging
- ✅ **Error handling interceptor**

### **2. Remote Data Source**
```dart
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await apiClient.dio.get('/users');
      
      if (response.statusCode == 200) {
        final List<dynamic> usersJson = response.data;
        return usersJson.map((json) => UserModel.fromJson(json)).toList();
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
}
```

**Error Handling:**
- ✅ **Connection timeouts**
- ✅ **HTTP status codes** (404, 500, etc.)
- ✅ **SSL certificate errors**
- ✅ **Network connectivity issues**
- ✅ **Request cancellation**

### **3. JSON Models with Serialization**
```dart
class UserModel extends User {
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      address: AddressModel.fromJson(json['address']),
      phone: json['phone'] as String,
      website: json['website'] as String,
      company: CompanyModel.fromJson(json['company']),
    );
  }
}
```

**Features:**
- ✅ **Type-safe JSON parsing**
- ✅ **Nested object handling** (Address, Company)
- ✅ **Domain entity inheritance**
- ✅ **Bidirectional serialization** (toJson/fromJson)

### **4. Repository Implementation**
```dart
class UserRepositoryImpl implements UserRepository {
  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final users = await remoteDataSource.getUsers();
      return Right(users);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }
}
```

**Features:**
- ✅ **Either pattern** for error handling
- ✅ **Exception mapping** to domain failures
- ✅ **Clean separation** from data sources

### **5. State Management with Riverpod**
```dart
class UsersNotifier extends StateNotifier<UsersState> {
  Future<void> loadUsers() async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await getUsers();
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (users) => state = state.copyWith(
        isLoading: false,
        users: users,
        error: null,
      ),
    );
  }
}
```

**Features:**
- ✅ **Loading states** management
- ✅ **Error state** handling
- ✅ **Immutable state** updates
- ✅ **Reactive UI** updates

## 🎯 UI Features

### **Users List Page**
- ✅ **Pull-to-refresh** functionality
- ✅ **Loading indicators** during API calls
- ✅ **Error states** with retry buttons
- ✅ **User cards** with key information
- ✅ **Tap to view details** in dialog

### **User Details Dialog**
- ✅ **Complete user information**
- ✅ **Formatted address display**
- ✅ **Company details**
- ✅ **Contact information**

## 🧪 Testing Strategy

### **Unit Tests (Data Layer)**
```dart
test('should return users when API call is successful', () async {
  // Arrange
  final mockDio = MockDio();
  final dataSource = UserRemoteDataSourceImpl(apiClient: mockApiClient);
  
  when(mockDio.get('/users')).thenAnswer((_) async => Response(
    data: mockUsersJson,
    statusCode: 200,
    requestOptions: RequestOptions(path: '/users'),
  ));
  
  // Act
  final result = await dataSource.getUsers();
  
  // Assert
  expect(result, isA<List<UserModel>>());
  expect(result.length, equals(2));
});
```

### **Integration Tests**
```dart
testWidgets('should display users when API call succeeds', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userRepositoryProvider.overrideWith(() => mockRepository),
      ],
      child: MaterialApp(home: UsersPage()),
    ),
  );
  
  await tester.pump();
  
  expect(find.text('Leanne Graham'), findsOneWidget);
  expect(find.text('Sincere@april.biz'), findsOneWidget);
});
```

## 🔧 Configuration

### **Dependencies Added**
```yaml
dependencies:
  dio: ^5.3.4                # HTTP client
  flutter_riverpod: ^2.4.9   # State management
  dartz: ^0.10.1             # Functional programming
```

### **Network Permissions (Android)**
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET" />
```

## 🚀 Usage Examples

### **Basic API Call**
```dart
// Get all users
final usersResult = await getUsersUseCase();
usersResult.fold(
  (failure) => print('Error: ${failure.message}'),
  (users) => print('Loaded ${users.length} users'),
);
```

### **Riverpod Integration**
```dart
// In widget
final usersState = ref.watch(usersNotifierProvider);

if (usersState.isLoading) {
  return CircularProgressIndicator();
} else if (usersState.error != null) {
  return Text('Error: ${usersState.error}');
} else {
  return ListView.builder(
    itemCount: usersState.users.length,
    itemBuilder: (context, index) => UserListItem(
      user: usersState.users[index],
    ),
  );
}
```

## 🔍 Error Handling

### **Network Errors Mapped to Domain Failures**
- **Connection Timeout** → `NetworkFailure`
- **404 Not Found** → `NetworkFailure` (resource not found)
- **500 Server Error** → `NetworkFailure` (server error)
- **SSL Certificate** → `NetworkFailure` (security error)
- **No Internet** → `NetworkFailure` (connection error)

### **UI Error Display**
- ✅ **User-friendly messages**
- ✅ **Retry functionality**
- ✅ **Graceful degradation**
- ✅ **Loading state management**

## 🌟 Best Practices Demonstrated

1. **Separation of Concerns**: API logic separated from business logic
2. **Error Handling**: Comprehensive error mapping and user feedback
3. **Type Safety**: Strong typing throughout the data flow
4. **Testability**: Easy to mock and test each layer
5. **Performance**: Efficient state management with Riverpod
6. **User Experience**: Loading states, error handling, pull-to-refresh
7. **Maintainability**: Clear structure and consistent patterns

## 🔄 Extending the API Integration

To add more API endpoints:

1. **Add new methods** to `UserRemoteDataSource`
2. **Create corresponding use cases** in domain layer
3. **Update repository** implementation
4. **Add state management** in providers
5. **Update UI** to consume new data

Example for adding user creation:
```dart
// Data Source
Future<UserModel> createUser(UserModel user);

// Use Case
class CreateUser implements UseCase<User, CreateUserParams>

// Repository
Future<Either<Failure, User>> createUser(User user);

// State Provider
Future<void> createUser(User user) async { ... }
```

This API integration demonstrates how to properly implement external data sources while maintaining Clean Architecture principles! 🚀
