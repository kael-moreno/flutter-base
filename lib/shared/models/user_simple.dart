// Example: How to create a complete API integration in just a few lines

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_service.dart';

/// Simple User model - no need for separate entity/model files
class User {
  final int id;
  final String name;
  final String email;
  final String? phone;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (phone != null) 'phone': phone,
    };
  }
}

/// Helper function to get user ID
int _getUserId(User user) => user.id;

/// Helper function for toJson
Map<String, dynamic> _userToJson(User user) => user.toJson();

/// API configuration - this is all you need to define!
final userApiConfig = ApiConfig<User>(
  endpoint: '/users',
  fromJson: User.fromJson,
  toJson: _userToJson, // Optional: only needed for POST/PUT operations
  getId: _getUserId, // Optional: only needed for UPDATE/DELETE operations
);

/// Providers - created with minimal boilerplate
final usersProvider = ApiServiceFactory.createListProvider(userApiConfig);
final userByIdProvider = (int id) =>
    ApiServiceFactory.createItemProvider(userApiConfig, id);

/// Optional: Direct API service if you need custom operations
final userApiServiceProvider = Provider<ApiService<User>>((ref) {
  return ApiServiceFactory.createCRUD(userApiConfig);
});

/*
THAT'S IT! 🎉

Now you can use it in your UI like this:

```dart
class UsersPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(usersProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: usersState.isLoading
          ? Center(child: CircularProgressIndicator())
          : usersState.error != null
              ? Center(child: Text('Error: ${usersState.error}'))
              : RefreshIndicator(
                  onRefresh: () => ref.read(usersProvider.notifier).refresh(),
                  child: ListView.builder(
                    itemCount: usersState.items.length,
                    itemBuilder: (context, index) {
                      final user = usersState.items[index];
                      return ListTile(
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserDetailPage(user.id),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create new user
          ref.read(usersProvider.notifier).create({
            'name': 'New User',
            'email': 'new@example.com',
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

To add a new API (e.g., Posts):

1. Create your model class with fromJson/toJson
2. Create an ApiConfig
3. Create providers using ApiServiceFactory
4. Use in your UI

No more:
- ❌ Separate data sources
- ❌ Repository implementations  
- ❌ Use cases for each operation
- ❌ Multiple provider files
- ❌ Complex dependency injection setup

Just pure simplicity! 🚀
*/
