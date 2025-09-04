import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/core/state/base_state.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/models/post.dart';

void main() {
  group('DataListState Tests', () {
    test('should create initial loading state', () {
      const state = DataListState<User>();

      expect(state.isLoading, false);
      expect(state.items, isEmpty);
      expect(state.error, isNull);
    });

    test('should create success state with items', () {
      const users = [
        User(
          id: 1,
          name: 'Test User',
          username: 'testuser',
          email: 'test@example.com',
          address: Address(
            street: 'Main St',
            suite: 'Suite 1',
            city: 'City',
            zipcode: '12345',
            geo: Geo(lat: '0.0', lng: '0.0'),
          ),
          phone: '123-456-7890',
          website: 'test.com',
          company: Company(
            name: 'Test Corp',
            catchPhrase: 'Testing first',
            bs: 'test solutions',
          ),
        ),
      ];

      const state = DataListState<User>(items: users);

      expect(state.isLoading, false);
      expect(state.items, hasLength(1));
      expect(state.items.first.name, 'Test User');
      expect(state.error, isNull);
    });

    test('should create error state', () {
      const state = DataListState<User>(error: 'Network error');

      expect(state.isLoading, false);
      expect(state.items, isEmpty);
      expect(state.error, 'Network error');
    });

    test('should support copyWith functionality', () {
      const initialState = DataListState<User>();
      const users = [
        User(
          id: 1,
          name: 'Test User',
          username: 'testuser',
          email: 'test@example.com',
          address: Address(
            street: 'Main St',
            suite: 'Suite 1',
            city: 'City',
            zipcode: '12345',
            geo: Geo(lat: '0.0', lng: '0.0'),
          ),
          phone: '123-456-7890',
          website: 'test.com',
          company: Company(
            name: 'Test Corp',
            catchPhrase: 'Testing first',
            bs: 'test solutions',
          ),
        ),
      ];

      final successState = initialState.copyWith(
        isLoading: false,
        items: users,
      );

      expect(successState.isLoading, false);
      expect(successState.items, hasLength(1));
      expect(successState.error, isNull);

      final errorState = initialState.copyWith(
        isLoading: false,
        error: 'Test error',
      );

      expect(errorState.isLoading, false);
      expect(errorState.items, isEmpty);
      expect(errorState.error, 'Test error');
    });

    test('should work with different types', () {
      const userState = DataListState<User>();
      const postState = DataListState<Post>();

      expect(userState.isLoading, false);
      expect(postState.isLoading, false);
      expect(userState.items, isA<List<User>>());
      expect(postState.items, isA<List<Post>>());
    });
  });
}
