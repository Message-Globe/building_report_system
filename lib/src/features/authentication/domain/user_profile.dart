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
    required this.buildingsIds,
    required this.role,
  });

  // Dati base dell'utente (da AppUser)
  final AppUser appUser;

  // Dati specifici del profilo
  final String name;
  final List<String> buildingsIds; // Lista degli ID degli edifici associati
  final UserRole role;

  UserProfile copyWith({
    AppUser? appUser,
    String? name,
    List<String>? buildingsIds,
    UserRole? role,
  }) {
    return UserProfile(
      appUser: appUser ?? this.appUser,
      name: name ?? this.name,
      buildingsIds: buildingsIds ?? this.buildingsIds,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appUser': appUser.toMap(),
      'name': name,
      'buildingsIds': buildingsIds,
      'role': role.name,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      appUser: AppUser.fromMap(map['appUser'] as Map<String, dynamic>),
      name: map['name'] as String,
      buildingsIds: List<String>.from((map['buildingsIds'] as List<String>)),
      role: UserRole.values.byName(map['role']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserProfile(appUser: $appUser, name: $name, buildingsIds: $buildingsIds, role: $role)';
  }

  @override
  bool operator ==(covariant UserProfile other) {
    if (identical(this, other)) return true;

    return other.appUser == appUser &&
        other.name == name &&
        listEquals(other.buildingsIds, buildingsIds) &&
        other.role == role;
  }

  @override
  int get hashCode {
    return appUser.hashCode ^ name.hashCode ^ buildingsIds.hashCode ^ role.hashCode;
  }
}
