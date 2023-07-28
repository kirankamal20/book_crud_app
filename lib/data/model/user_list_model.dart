import 'dart:convert';

class Userlistmodel {
  final int id;
  final String email;
  final String password;
  final String name;
  final String role;
  final String avatar;
  final String creationAt;
  final String updatedAt;
  Userlistmodel({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    required this.avatar,
    required this.creationAt,
    required this.updatedAt,
  });

  Userlistmodel copyWith({
    int? id,
    String? email,
    String? password,
    String? name,
    String? role,
    String? avatar,
    String? creationAt,
    String? updatedAt,
  }) {
    return Userlistmodel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
      creationAt: creationAt ?? this.creationAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'role': role,
      'avatar': avatar,
      'creationAt': creationAt,
      'updatedAt': updatedAt,
    };
  }

  factory Userlistmodel.fromMap(Map<String, dynamic> map) {
    return Userlistmodel(
      id: map['id'].toInt() as int,
      email: map['email'] as String,
      password: map['password'] as String,
      name: map['name'] as String,
      role: map['role'] as String,
      avatar: map['avatar'] as String,
      creationAt: map['creationAt'] as String,
      updatedAt: map['updatedAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Userlistmodel.fromJson(String source) =>
      Userlistmodel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Userlistmodel(id: $id, email: $email, password: $password, name: $name, role: $role, avatar: $avatar, creationAt: $creationAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Userlistmodel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.password == password &&
        other.name == name &&
        other.role == role &&
        other.avatar == avatar &&
        other.creationAt == creationAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        password.hashCode ^
        name.hashCode ^
        role.hashCode ^
        avatar.hashCode ^
        creationAt.hashCode ^
        updatedAt.hashCode;
  }
}
