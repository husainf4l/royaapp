import 'refresh_token.dart';

class User {
  String id;
  String email;
  String password;
  String? firstName;
  String? lastName;
  String role;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;
  List<RefreshToken> refreshTokens;

  User({
    required this.id,
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.refreshTokens,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    password: json['password'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    role: json['role'],
    isActive: json['isActive'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    refreshTokens:
        (json['refreshTokens'] as List)
            .map((e) => RefreshToken.fromJson(e))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'password': password,
    'firstName': firstName,
    'lastName': lastName,
    'role': role,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'refreshTokens': refreshTokens.map((e) => e.toJson()).toList(),
  };
}
