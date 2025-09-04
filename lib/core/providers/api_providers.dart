import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_service.dart';
import '../state/base_state.dart';
import '../../models/user.dart';
import '../../models/post.dart';

/// Centralized API providers for all entities
/// This file contains all the provider definitions to keep pages clean
class ApiProviders {
  // Private constructor to prevent instantiation
  ApiProviders._();

  /// Users API Provider
  /// Provides CRUD operations for User entities from JSONPlaceholder /users endpoint
  static final usersProvider = ApiServiceFactory.createListProvider<User>(
    ApiConfig<User>(
      endpoint: '/users123',
      fromJson: (json) => User.fromJson(json),
      toJson: (user) => user.toJson(),
      getId: (user) => user.id,
    ),
  );

  /// Posts API Provider
  /// Provides CRUD operations for Post entities from JSONPlaceholder /posts endpoint
  static final postsProvider = ApiServiceFactory.createListProvider<Post>(
    ApiConfig<Post>(
      endpoint: '/posts123',
      fromJson: (json) => Post.fromJson(json),
      toJson: (post) => post.toJson(),
      getId: (post) => post.id,
    ),
  );

  /// Individual User Provider Factory
  /// Creates a provider for fetching a single user by ID
  static StateNotifierProvider<DataItemNotifier<User>, DataItemState<User>>
  userByIdProvider(int id) {
    return ApiServiceFactory.createItemProvider<User>(
      ApiConfig<User>(
        endpoint: '/users',
        fromJson: (json) => User.fromJson(json),
        toJson: (user) => user.toJson(),
        getId: (user) => user.id,
      ),
      id,
    );
  }

  /// Individual Post Provider Factory
  /// Creates a provider for fetching a single post by ID
  static StateNotifierProvider<DataItemNotifier<Post>, DataItemState<Post>>
  postByIdProvider(int id) {
    return ApiServiceFactory.createItemProvider<Post>(
      ApiConfig<Post>(
        endpoint: '/posts',
        fromJson: (json) => Post.fromJson(json),
        toJson: (post) => post.toJson(),
        getId: (post) => post.id,
      ),
      id,
    );
  }
}

/// Extension methods for easy access to common operations
extension ApiProvidersExtension on WidgetRef {
  /// Get users state
  DataListState<User> get usersState => watch(ApiProviders.usersProvider);

  /// Get posts state
  DataListState<Post> get postsState => watch(ApiProviders.postsProvider);

  /// Get users notifier for operations
  DataListNotifier<User> get usersNotifier =>
      read(ApiProviders.usersProvider.notifier);

  /// Get posts notifier for operations
  DataListNotifier<Post> get postsNotifier =>
      read(ApiProviders.postsProvider.notifier);
}
