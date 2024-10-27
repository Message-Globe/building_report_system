// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:building_report_system/src/features/authentication/domain/building.dart';

import 'app_user.dart';

enum UserRole {
  operator,
  reporter,
  admin,
}

class UserProfile {
  // Dati base dell'utente (da AppUser)
  final AppUser appUser;

  // Dati specifici del profilo
  final String name;
  final List<Building> assignedBuildings;
  final UserRole role;

  const UserProfile({
    required this.appUser,
    required this.name,
    required this.assignedBuildings,
    required this.role,
  });

  UserProfile copyWith({
    AppUser? appUser,
    String? name,
    List<Building>? assignedBuildings,
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
      'assignedBuildings': assignedBuildings.map((x) => x.toMap()).toList(),
      'role': role.name,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      appUser: AppUser.fromMap(map['appUser'] as Map<String, dynamic>),
      name: map['name'] as String,
      assignedBuildings: List<Building>.from(
        (map['assignedBuildings'] as List<int>).map<Building>(
          (x) => Building.fromMap(x as Map<String, dynamic>),
        ),
      ),
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
        listEquals(other.assignedBuildings, assignedBuildings) &&
        other.role == role;
  }

  @override
  int get hashCode {
    return appUser.hashCode ^ name.hashCode ^ assignedBuildings.hashCode ^ role.hashCode;
  }
}
