import '../domain/user_profile.dart';
import '../domain/app_user.dart';

const List<UserProfile> kTestUsers = <UserProfile>[
  UserProfile(
    appUser: AppUser(
      uid: '1',
      email: 'reporter@example.com',
    ),
    name: 'John Reporter',
    assignedBuildings: {
      '1': 'Scuola media',
      '2': 'Ospedale',
    },
    role: UserRole.reporter,
  ),
  UserProfile(
    appUser: AppUser(
      uid: '2',
      email: 'operator@example.com',
    ),
    name: 'Jane Operator',
    assignedBuildings: {
      '1': 'Scuola media',
      '2': 'Ospedale',
    },
    role: UserRole.operator,
  ),
  UserProfile(
    appUser: AppUser(
      uid: '3',
      email: 'admin@example.com',
    ),
    name: 'Alice Admin',
    assignedBuildings: {
      '1': 'Scuola media',
      '2': 'Ospedale',
    },
    role: UserRole.admin,
  ),
];

// Mappa che associa email alle password per i test
final Map<String, String> kTestUserPasswords = {
  'reporter@example.com': 'password123',
  'operator@example.com': 'password123',
  'admin@example.com': 'password123',
};
