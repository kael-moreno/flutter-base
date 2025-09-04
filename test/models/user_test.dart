import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/models/user.dart';

void main() {
  group('User Model Tests', () {
    const mockUserJson = {
      'id': 1,
      'name': 'John Doe',
      'username': 'johndoe',
      'email': 'john@example.com',
      'address': {
        'street': 'Main St',
        'suite': 'Suite 1',
        'city': 'New York',
        'zipcode': '10001',
        'geo': {'lat': '40.7128', 'lng': '-74.0060'},
      },
      'phone': '1-555-123-4567',
      'website': 'johndoe.com',
      'company': {
        'name': 'ACME Corp',
        'catchPhrase': 'Innovation first',
        'bs': 'synergize solutions',
      },
    };

    test('should create User from JSON', () {
      final user = User.fromJson(mockUserJson);

      expect(user.id, 1);
      expect(user.name, 'John Doe');
      expect(user.username, 'johndoe');
      expect(user.email, 'john@example.com');
      expect(user.phone, '1-555-123-4567');
      expect(user.website, 'johndoe.com');
    });

    test('should create JSON from User', () {
      final user = User.fromJson(mockUserJson);
      final json = user.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'John Doe');
      expect(json['username'], 'johndoe');
      expect(json['email'], 'john@example.com');
      expect(json['phone'], '1-555-123-4567');
      expect(json['website'], 'johndoe.com');
      expect(json['address'], isA<Map<String, dynamic>>());
      expect(json['company'], isA<Map<String, dynamic>>());
    });

    test('should handle Address nested object', () {
      final user = User.fromJson(mockUserJson);
      final address = user.address;

      expect(address.street, 'Main St');
      expect(address.suite, 'Suite 1');
      expect(address.city, 'New York');
      expect(address.zipcode, '10001');
      expect(address.fullAddress, 'Main St, Suite 1, New York 10001');
    });

    test('should handle Company nested object', () {
      final user = User.fromJson(mockUserJson);
      final company = user.company;

      expect(company.name, 'ACME Corp');
      expect(company.catchPhrase, 'Innovation first');
      expect(company.bs, 'synergize solutions');
    });

    test('should handle Geo nested object', () {
      final user = User.fromJson(mockUserJson);
      final geo = user.address.geo;

      expect(geo.lat, '40.7128');
      expect(geo.lng, '-74.0060');
    });

    test('should implement equality correctly', () {
      final user1 = User.fromJson(mockUserJson);
      final user2 = User.fromJson(mockUserJson);
      final user3 = User.fromJson({...mockUserJson, 'id': 2});

      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
      expect(user1.hashCode, equals(user2.hashCode));
      expect(user1.hashCode, isNot(equals(user3.hashCode)));
    });
  });

  group('Address Model Tests', () {
    test('should create fullAddress correctly', () {
      const addressJson = {
        'street': 'Main Street',
        'suite': 'Apt. 123',
        'city': 'Anytown',
        'zipcode': '12345',
        'geo': {'lat': '0.0', 'lng': '0.0'},
      };

      final address = Address.fromJson(addressJson);
      expect(address.fullAddress, 'Main Street, Apt. 123, Anytown 12345');
    });
  });
}
