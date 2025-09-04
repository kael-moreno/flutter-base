# 🚀 Simplified API System

This new unified API system eliminates 90% of the boilerplate code while maintaining clean architecture principles.

## ❌ Before (Old System)
To add a single API endpoint, you needed to create:

```
features/my_feature/
├── data/
│   ├── datasources/
│   │   └── my_remote_data_source.dart       (50+ lines)
│   ├── models/
│   │   └── my_model.dart                    (30+ lines)
│   └── repositories/
│       └── my_repository_impl.dart          (60+ lines)
├── domain/
│   ├── entities/
│   │   └── my_entity.dart                   (20+ lines)
│   ├── repositories/
│   │   └── my_repository.dart               (15+ lines)
│   └── usecases/
│       ├── get_my_items.dart                (15+ lines)
│       ├── create_my_item.dart              (15+ lines)
│       └── delete_my_item.dart              (15+ lines)
└── presentation/
    ├── providers/
    │   ├── my_providers.dart                (40+ lines)
    │   └── my_state_provider.dart           (80+ lines)
    └── pages/
        └── my_page.dart                     (100+ lines)
```

**Total: ~12 files, 440+ lines of boilerplate code!** 😱

## ✅ After (New System)
Now you only need:

```dart
// 1. Define your model (20 lines)
class MyItem {
  final int id;
  final String name;
  
  MyItem({required this.id, required this.name});
  
  factory MyItem.fromJson(Map<String, dynamic> json) => MyItem(
    id: json['id'],
    name: json['name'],
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

// 2. Configure the API (5 lines)
final myApiConfig = ApiConfig<MyItem>(
  endpoint: '/my-items',
  fromJson: MyItem.fromJson,
  toJson: (item) => item.toJson(),
  getId: (item) => item.id,
);

// 3. Create providers (2 lines)
final myItemsProvider = ApiServiceFactory.createListProvider(myApiConfig);
final myItemProvider = (int id) => ApiServiceFactory.createItemProvider(myApiConfig, id);

// 4. Use in your UI (30 lines)
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myItemsProvider);
    
    return Scaffold(
      body: state.isLoading 
        ? CircularProgressIndicator()
        : ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(state.items[index].name),
              onTap: () => ref.read(myItemsProvider.notifier).delete(state.items[index]),
            ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(myItemsProvider.notifier).create({
          'name': 'New Item',
        }),
      ),
    );
  }
}
```

**Total: 1 file, ~57 lines of actual code!** 🎉

## 🎯 Key Benefits

### 1. **90% Less Boilerplate**
- No more data sources, repository implementations, use cases
- No more complex provider setup
- Just define your model and configuration

### 2. **Automatic CRUD Operations**
```dart
final notifier = ref.read(myItemsProvider.notifier);

// All these work automatically:
await notifier.loadData();        // GET /my-items
await notifier.refresh();         // GET /my-items (with refresh indicator)
await notifier.create(data);      // POST /my-items
await notifier.update(item, data); // PUT /my-items/{id}
await notifier.delete(item);      // DELETE /my-items/{id}
```

### 3. **Built-in State Management**
```dart
final state = ref.watch(myItemsProvider);

// Automatic state handling:
state.items;        // List of your items
state.isLoading;    // Loading indicator
state.isRefreshing; // Pull-to-refresh state
state.error;        // Error messages
```

### 4. **Type Safety**
Everything is fully type-safe with generics. No casting or runtime errors.

### 5. **Error Handling**
Automatic error handling with proper user-friendly messages:
- Network timeouts
- Server errors
- Connection issues
- Validation errors

### 6. **Flexible Configuration**
```dart
// Read-only API (GET operations only)
final readOnlyConfig = ApiConfig<MyItem>(
  endpoint: '/my-items',
  fromJson: MyItem.fromJson,
  // No toJson or getId needed
);

// Full CRUD API
final crudConfig = ApiConfig<MyItem>(
  endpoint: '/my-items',
  fromJson: MyItem.fromJson,
  toJson: (item) => item.toJson(),
  getId: (item) => item.id,
);
```

## 📚 Usage Examples

### Simple List Page
```dart
class ItemsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(itemsProvider);
    
    if (state.isLoading) return LoadingWidget();
    if (state.error != null) return ErrorWidget(state.error);
    
    return RefreshIndicator(
      onRefresh: () => ref.read(itemsProvider.notifier).refresh(),
      child: ListView.builder(
        itemCount: state.items.length,
        itemBuilder: (context, index) => ItemTile(state.items[index]),
      ),
    );
  }
}
```

### Create/Update Operations
```dart
// Create new item
ref.read(itemsProvider.notifier).create({
  'name': 'New Item',
  'description': 'Item description',
});

// Update existing item
ref.read(itemsProvider.notifier).update(item, {
  'name': 'Updated Name',
});

// Delete item
ref.read(itemsProvider.notifier).delete(item);
```

### Custom API Operations
```dart
// If you need custom operations beyond CRUD
final apiService = ref.read(itemApiServiceProvider);

// Custom endpoint call
final result = await apiService.getList(
  endpoint: '/my-items/featured',
  queryParams: {'limit': 10},
);
```

## 🔧 Migration Guide

### Step 1: Keep Your Current Code
Don't delete anything yet. The new system works alongside the old one.

### Step 2: Create New Models
For each feature, create a simple model with `fromJson`/`toJson` methods.

### Step 3: Add API Configs
Create `ApiConfig` instances for your endpoints.

### Step 4: Create New Providers
Use `ApiServiceFactory` to create providers with one line each.

### Step 5: Update Your UI
Replace old provider usage with new simplified providers.

### Step 6: Clean Up
Once everything works, delete the old feature folders.

## 🚀 Getting Started

1. Check out the example in `lib/pages/simple_users_page.dart`
2. Look at the model definition in `lib/shared/models/user_simple.dart`
3. Try creating your own API integration using the same pattern

The new system maintains all the benefits of clean architecture while dramatically reducing complexity!
