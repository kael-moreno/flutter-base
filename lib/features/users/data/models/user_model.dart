import '../../domain/entities/user.dart';
import 'address_model.dart';
import 'company_model.dart';

/// Data model for user with JSON serialization
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.username,
    required super.email,
    required super.address,
    required super.phone,
    required super.website,
    required super.company,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
      phone: json['phone'] as String,
      website: json['website'] as String,
      company: CompanyModel.fromJson(json['company'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'address': (address as AddressModel).toJson(),
      'phone': phone,
      'website': website,
      'company': (company as CompanyModel).toJson(),
    };
  }
}
