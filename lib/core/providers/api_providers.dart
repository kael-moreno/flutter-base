import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_service.dart';
import '../state/base_state.dart';
import '../../models/user.dart';
import '../../models/post.dart';

// --- Concrete Notifiers ---

class UsersNotifier extends DataListNotifier<User> {
  @override
  ApiConfig<User> get config => ApiConfig<User>(
    endpoint: '/users',
    fromJson: User.fromJson,
    toJson: (user) => user.toJson(),
    getId: (user) => user.id,
  );
}

class PostsNotifier extends DataListNotifier<Post> {
  @override
  ApiConfig<Post> get config => ApiConfig<Post>(
    endpoint: '/posts',
    fromJson: Post.fromJson,
    toJson: (post) => post.toJson(),
    getId: (post) => post.id,
  );
}

// --- Provider Registration ---

class ApiProviders {
  ApiProviders._();

  static final usersProvider =
      NotifierProvider<UsersNotifier, DataListState<User>>(UsersNotifier.new);

  static final postsProvider =
      NotifierProvider<PostsNotifier, DataListState<Post>>(PostsNotifier.new);

  static final userByIdProvider = FutureProvider.family<User, int>((ref, id) async {
    final service = ApiServiceFactory.createReadOnly(ApiConfig<User>(
      endpoint: '/users',
      fromJson: User.fromJson,
    ));
    final result = await service.getById(id);
    return result.fold((f) => throw Exception(f.message), (user) => user);
  });

  static final postByIdProvider = FutureProvider.family<Post, int>((ref, id) async {
    final service = ApiServiceFactory.createReadOnly(ApiConfig<Post>(
      endpoint: '/posts',
      fromJson: Post.fromJson,
    ));
    final result = await service.getById(id);
    return result.fold((f) => throw Exception(f.message), (post) => post);
  });
}

// --- Extension Methods ---

extension ApiProvidersExtension on WidgetRef {
  DataListState<User> get usersState => watch(ApiProviders.usersProvider);
  DataListState<Post> get postsState => watch(ApiProviders.postsProvider);
  UsersNotifier get usersNotifier => read(ApiProviders.usersProvider.notifier);
  PostsNotifier get postsNotifier => read(ApiProviders.postsProvider.notifier);
}
