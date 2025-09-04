import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/models/post.dart';

void main() {
  group('Post Model Tests', () {
    const mockPostJson = {
      'userId': 1,
      'id': 1,
      'title': 'Test Post Title',
      'body': 'This is a test post body content.',
    };

    test('should create Post from JSON', () {
      final post = Post.fromJson(mockPostJson);

      expect(post.userId, 1);
      expect(post.id, 1);
      expect(post.title, 'Test Post Title');
      expect(post.body, 'This is a test post body content.');
    });

    test('should create JSON from Post', () {
      final post = Post.fromJson(mockPostJson);
      final json = post.toJson();

      expect(json['userId'], 1);
      expect(json['id'], 1);
      expect(json['title'], 'Test Post Title');
      expect(json['body'], 'This is a test post body content.');
    });

    test('should implement equality correctly', () {
      final post1 = Post.fromJson(mockPostJson);
      final post2 = Post.fromJson(mockPostJson);
      final post3 = Post.fromJson({...mockPostJson, 'id': 2});

      expect(post1, equals(post2));
      expect(post1, isNot(equals(post3)));
      expect(post1.hashCode, equals(post2.hashCode));
      expect(post1.hashCode, isNot(equals(post3.hashCode)));
    });

    test('should handle different data types correctly', () {
      const jsonWithStringNumbers = {
        'userId': '1',
        'id': '1',
        'title': 'Test Post Title',
        'body': 'This is a test post body content.',
      };

      // This should throw if JSON parsing is strict
      expect(
        () => Post.fromJson(jsonWithStringNumbers),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
