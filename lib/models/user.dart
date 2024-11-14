import 'dart:convert';

class User {
  final String id;
  final String username;
  final String token;

  User({
    required this.id,
    required this.username,
    required this.token,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['email'],
        token: json['token'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': username,
        'token': token,
      };
}
