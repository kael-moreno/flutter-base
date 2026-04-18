import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../errors/failures.dart';

/// Generic state for any data list
class DataListState<T> {
  final List<T> items;
  final bool isLoading;
  final String? error;
  final bool isRefreshing;

  const DataListState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.isRefreshing = false,
  });

  DataListState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    String? error,
    bool? isRefreshing,
  }) {
    return DataListState<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

/// Generic state for single item
class DataItemState<T> {
  final T? item;
  final bool isLoading;
  final String? error;

  const DataItemState({this.item, this.isLoading = false, this.error});

  DataItemState<T> copyWith({T? item, bool? isLoading, String? error}) {
    return DataItemState<T>(
      item: item ?? this.item,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Generic StateNotifier for list operations
class DataListNotifier<T> extends StateNotifier<DataListState<T>> {
  final Future<Either<Failure, List<T>>> Function() _fetchList;
  final Future<Either<Failure, T>>? Function(Map<String, dynamic>)? _createItem;
  final Future<Either<Failure, T>>? Function(T, Map<String, dynamic>)?
  _updateItem;
  final Future<Either<Failure, bool>>? Function(T)? _deleteItem;

  DataListNotifier({
    required Future<Either<Failure, List<T>>> Function() fetchList,
    Future<Either<Failure, T>>? Function(Map<String, dynamic>)? createItem,
    Future<Either<Failure, T>>? Function(T, Map<String, dynamic>)? updateItem,
    Future<Either<Failure, bool>>? Function(T)? deleteItem,
  }) : _fetchList = fetchList,
       _createItem = createItem,
       _updateItem = updateItem,
       _deleteItem = deleteItem,
       super(DataListState<T>()) {
    loadData();
  }

  /// Load data from the source
  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _fetchList();
    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (items) =>
          state = state.copyWith(isLoading: false, items: items, error: null),
    );
  }

  /// Refresh data
  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true);

    final result = await _fetchList();
    result.fold(
      (failure) =>
          state = state.copyWith(isRefreshing: false, error: failure.message),
      (items) => state = state.copyWith(
        isRefreshing: false,
        items: items,
        error: null,
      ),
    );
  }

  /// Create a new item
  Future<void> create(Map<String, dynamic> data) async {
    final createFn = _createItem;
    if (createFn == null) return;

    final result = await createFn(data);
    result?.fold((failure) => state = state.copyWith(error: failure.message), (
      newItem,
    ) {
      final updatedItems = <T>[...state.items, newItem];
      state = state.copyWith(items: updatedItems, error: null);
    });
  }

  /// Update an existing item
  Future<void> update(T item, Map<String, dynamic> data) async {
    final updateFn = _updateItem;
    if (updateFn == null) return;

    final result = await updateFn(item, data);
    result?.fold((failure) => state = state.copyWith(error: failure.message), (
      updatedItem,
    ) {
      final updatedItems = state.items
          .map((i) => i == item ? updatedItem : i)
          .toList();
      state = state.copyWith(items: updatedItems, error: null);
    });
  }

  /// Delete an item
  Future<void> delete(T item) async {
    final deleteFn = _deleteItem;
    if (deleteFn == null) return;

    final result = await deleteFn(item);
    result?.fold((failure) => state = state.copyWith(error: failure.message), (
      _,
    ) {
      final updatedItems = state.items.where((i) => i != item).toList();
      state = state.copyWith(items: updatedItems, error: null);
    });
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Generic StateNotifier for single item operations
class DataItemNotifier<T> extends StateNotifier<DataItemState<T>> {
  final Future<Either<Failure, T>> Function() _fetchItem;

  DataItemNotifier({required Future<Either<Failure, T>> Function() fetchItem})
    : _fetchItem = fetchItem,
      super(DataItemState<T>());

  /// Load item data
  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _fetchItem();
    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (item) =>
          state = state.copyWith(isLoading: false, item: item, error: null),
    );
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}
