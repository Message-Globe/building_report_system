import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'building.dart';
import '../../../utils/context_extensions.dart';

import 'app_user.dart';

enum UserRole {
  operator,
  reporter,
  admin,
}

extension UserRoleLocalization on UserRole {
  String toLocalizedString(BuildContext context) {
    switch (this) {
      case UserRole.operator:
        return context.loc.operator;
      case UserRole.reporter:
        return context.loc.reporter;
      case UserRole.admin:
        return UserRole.admin.name;
    }
  }
}

class UserProfile {
  // Dati base dell'utente (da AppUser)
  final AppUser appUser;

  // Dati specifici del profilo
  final String name;
  final List<Building> assignedBuildings;
  final UserRole role;
  final bool isMaintenanceLead;

  const UserProfile({
    required this.appUser,
    required this.name,
    required this.assignedBuildings,
    required this.role,
    required this.isMaintenanceLead,
  });

  UserProfile copyWith({
    AppUser? appUser,
    String? name,
    List<Building>? assignedBuildings,
    UserRole? role,
    bool? isMaintenanceLead,
  }) {
    return UserProfile(
      appUser: appUser ?? this.appUser,
      name: name ?? this.name,
      assignedBuildings: assignedBuildings ?? this.assignedBuildings,
      role: role ?? this.role,
      isMaintenanceLead: isMaintenanceLead ?? this.isMaintenanceLead,
    );
  }

  @override
  String toString() {
    return 'UserProfile(appUser: $appUser, name: $name, assignedBuildings: $assignedBuildings, role: $role, isMaintenanceLead: $isMaintenanceLead)';
  }

  @override
  bool operator ==(covariant UserProfile other) {
    if (identical(this, other)) return true;

    return other.appUser == appUser &&
        other.name == name &&
        listEquals(other.assignedBuildings, assignedBuildings) &&
        other.role == role &&
        other.isMaintenanceLead == isMaintenanceLead;
  }

  @override
  int get hashCode {
    return appUser.hashCode ^
        name.hashCode ^
        assignedBuildings.hashCode ^
        role.hashCode ^
        isMaintenanceLead.hashCode;
  }
}
