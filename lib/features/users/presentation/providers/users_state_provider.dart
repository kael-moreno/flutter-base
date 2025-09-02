import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/get_user_by_id.dart';
import 'user_providers.dart';

/// State for the users feature
class UsersState {
  final List<User> users;
  final bool isLoading;
  final String? error;

  const UsersState({
    this.users = const [],
    this.isLoading = false,
    this.error,
  });

  UsersState copyWith({
    List<User>? users,
    bool? isLoading,
    String? error,
  }) {
    return UsersState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing users state
class UsersNotifier extends StateNotifier<UsersState> {
  final GetUsers getUsers;
  final GetUserById getUserById;

  UsersNotifier({
    required this.getUsers,
    required this.getUserById,
  }) : super(const UsersState());

  /// Load all users from the API
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

  /// Refresh users data
  Future<void> refreshUsers() async {
    await loadUsers();
  }

  /// Get a specific user by ID
  Future<User?> getUser(int id) async {
    final result = await getUserById(GetUserByIdParams(id: id));
    return result.fold(
      (failure) {
        // Handle error if needed
        return null;
      },
      (user) => user,
    );
  }
}

/// Provider for the users state notifier
final usersNotifierProvider = StateNotifierProvider<UsersNotifier, UsersState>((ref) {
  return UsersNotifier(
    getUsers: ref.read(getUsersUseCaseProvider),
    getUserById: ref.read(getUserByIdUseCaseProvider),
  );
});
