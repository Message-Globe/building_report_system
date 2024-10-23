// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'app_user.dart';

enum UserRole {
  operator,
  reporter,
  admin,
}

class UserProfile {
  const UserProfile({
    required this.appUser,
    required this.name,
    required this.assignedBuildings,
    required this.role,
  });

  // Dati base dell'utente (da AppUser)
  final AppUser appUser;

  // Dati specifici del profilo
  final String name;
  final Map<String, String> assignedBuildings;
  final UserRole role;

  UserProfile copyWith({
    AppUser? appUser,
    String? name,
    Map<String, String>? assignedBuildings,
    UserRole? role,
  }) {
    return UserProfile(
      appUser: appUser ?? this.appUser,
      name: name ?? this.name,
      assignedBuildings: assignedBuildings ?? this.assignedBuildings,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appUser': appUser.toMap(),
      'name': name,
      'assignedBuildings': assignedBuildings,
      'role': role.name,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      appUser: AppUser.fromMap(map['appUser'] as Map<String, dynamic>),
      name: map['name'] as String,
      assignedBuildings:
          Map<String, String>.from((map['assignedBuildings'] as Map<String, String>)),
      role: UserRole.values.byName(map['role']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserProfile(appUser: $appUser, name: $name, assignedBuildings: $assignedBuildings, role: $role)';
  }

  @override
  bool operator ==(covariant UserProfile other) {
    if (identical(this, other)) return true;

    return other.appUser == appUser &&
        other.name == name &&
        mapEquals(other.assignedBuildings, assignedBuildings) &&
        other.role == role;
  }

  @override
  int get hashCode {
    return appUser.hashCode ^ name.hashCode ^ assignedBuildings.hashCode ^ role.hashCode;
  }
}
