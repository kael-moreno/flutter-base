import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/core/providers/api_providers.dart';

void main() {
  group('ApiProviders Tests', () {
    test('usersProvider should be defined', () {
      expect(ApiProviders.usersProvider, isNotNull);
      expect(ApiProviders.usersProvider, isA<StateNotifierProvider>());
    });

    test('postsProvider should be defined', () {
      expect(ApiProviders.postsProvider, isNotNull);
      expect(ApiProviders.postsProvider, isA<StateNotifierProvider>());
    });

    test('userByIdProvider should create provider for specific ID', () {
      final userProvider = ApiProviders.userByIdProvider(1);
      expect(userProvider, isNotNull);
      expect(userProvider, isA<StateNotifierProvider>());
    });

    test('postByIdProvider should create provider for specific ID', () {
      final postProvider = ApiProviders.postByIdProvider(1);
      expect(postProvider, isNotNull);
      expect(postProvider, isA<StateNotifierProvider>());
    });

    test('different ID providers should be different instances', () {
      final userProvider1 = ApiProviders.userByIdProvider(1);
      final userProvider2 = ApiProviders.userByIdProvider(2);

      expect(userProvider1, isNot(same(userProvider2)));
    });

    test('providers should have correct types', () {
      // Test that the provider types are correctly generic
      expect(ApiProviders.usersProvider.toString(), contains('User'));
      expect(ApiProviders.postsProvider.toString(), contains('Post'));
    });
  });
}
