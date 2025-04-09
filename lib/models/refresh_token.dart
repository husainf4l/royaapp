class RefreshToken {
  String id;
  String token;
  DateTime expiresAt;
  DateTime createdAt;
  String userId;
  bool revoked;

  RefreshToken({
    required this.id,
    required this.token,
    required this.expiresAt,
    required this.createdAt,
    required this.userId,
    required this.revoked,
  });

  factory RefreshToken.fromJson(Map<String, dynamic> json) => RefreshToken(
    id: json['id'],
    token: json['token'],
    expiresAt: DateTime.parse(json['expiresAt']),
    createdAt: DateTime.parse(json['createdAt']),
    userId: json['userId'],
    revoked: json['revoked'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'token': token,
    'expiresAt': expiresAt.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'userId': userId,
    'revoked': revoked,
  };
}
