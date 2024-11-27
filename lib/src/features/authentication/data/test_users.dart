import '../domain/building.dart';
import '../domain/user_profile.dart';
import '../domain/app_user.dart';

// Definizione degli edifici
final Building schoolBuilding = Building(id: '1', name: 'Scuola Media');
final Building hospitalBuilding = Building(id: '2', name: 'Ospedale');

List<UserProfile> kTestUsers = <UserProfile>[
  UserProfile(
    appUser: AppUser(
      uid: '1',
      email: 'reporter@example.com',
    ),
    name: 'John Reporter',
    assignedBuildings: [
      schoolBuilding,
      hospitalBuilding,
    ],
    role: UserRole.reporter,
    isMaintenanceLead: false,
  ),
  UserProfile(
    appUser: AppUser(
      uid: '2',
      email: 'operator@example.com',
    ),
    name: 'Jane Operator',
    assignedBuildings: [
      schoolBuilding,
      hospitalBuilding,
    ],
    role: UserRole.operator,
    isMaintenanceLead: false,
  ),
  UserProfile(
    appUser: AppUser(
      uid: '3',
      email: 'admin@example.com',
    ),
    name: 'Alice Admin',
    assignedBuildings: [
      schoolBuilding,
      hospitalBuilding,
    ],
    role: UserRole.admin,
    isMaintenanceLead: false,
  ),
];

// Mappa che associa email alle password per i test
final Map<String, String> kTestUserPasswords = {
  'reporter@example.com': 'password123',
  'operator@example.com': 'password123',
  'admin@example.com': 'password123',
};
