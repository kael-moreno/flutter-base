import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_service.dart';

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

/// Abstract base Notifier for list operations.
/// Concrete subclasses per entity provide [service] and [config].
abstract class DataListNotifier<T> extends Notifier<DataListState<T>> {
  ApiConfig<T> get config;

  late final ApiService<T> service = ApiServiceFactory.createCRUD(config);

  @override
  DataListState<T> build() {
    loadData();
    return DataListState<T>(isLoading: true);
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await service.getAll();
    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (items) =>
          state = state.copyWith(isLoading: false, items: items, error: null),
    );
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true);

    final result = await service.getAll();
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

  Future<void> create(Map<String, dynamic> data) async {
    if (config.toJson == null) return;

    final item = config.fromJson(data);
    final result = await service.create(item);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (newItem) {
        final updatedItems = <T>[...state.items, newItem];
        state = state.copyWith(items: updatedItems, error: null);
      },
    );
  }

  Future<void> update(T item, Map<String, dynamic> data) async {
    if (config.toJson == null || config.getId == null) return;

    final existingJson = config.toJson!(item);
    final mergedJson = {...existingJson, ...data};
    final mergedItem = config.fromJson(mergedJson);
    final result = await service.update(mergedItem);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (updatedItem) {
        final updatedItems = state.items
            .map((i) => i == item ? updatedItem : i)
            .toList();
        state = state.copyWith(items: updatedItems, error: null);
      },
    );
  }

  Future<void> delete(T item) async {
    if (config.getId == null) return;

    final result = await service.delete(item);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) {
        final updatedItems = state.items.where((i) => i != item).toList();
        state = state.copyWith(items: updatedItems, error: null);
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

