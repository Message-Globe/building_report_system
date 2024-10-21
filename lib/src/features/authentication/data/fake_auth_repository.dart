import 'package:building_report_system/src/utils/delay.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/user_profile.dart';
import 'auth_repository.dart';
import 'test_users.dart';

class FakeAuthRepository with ChangeNotifier implements AuthRepository {
  // 1. Costanti statiche
  static const String _tokenKey = 'fake_auth_token';

  // 2. Variabili finali
  final bool addDelay;

  // Mappa di token e utenti per simulare l'associazione tra token e utenti
  final Map<String, UserProfile> _tokenUserMap = {
    'fakeToken123_reporter': kTestUsers[0], // reporter@example.com
    'fakeToken123_operator': kTestUsers[1], // operator@example.com
    'fakeToken123_admin': kTestUsers[2], // admin@example.com
  };

  // 3. Variabili di istanza
  UserProfile? _currentUser;
  String? _fakeToken;

  // 4. Costruttore
  FakeAuthRepository({this.addDelay = true});

  // 5. Getter
  @override
  UserProfile? get currentUser => _currentUser;

  // 6. Metodi pubblici
  @override
  Future<UserProfile?> checkToken() async {
    await delay(addDelay, 1000);

    // Carica il token dallo storage
    await _loadToken();

    if (_fakeToken != null && _tokenUserMap.containsKey(_fakeToken)) {
      // Recupera l'utente associato al token
      _currentUser = _tokenUserMap[_fakeToken];
      return _currentUser;
    } else {
      _currentUser = null;
      return null;
    }
  }

  @override
  Future<UserProfile?> signInWithEmailAndPassword(String email, String password) async {
    // Simula un ritardo
    await delay(addDelay, 1000);

    // Simula il login e assegna un token in base all'utente
    final user = kTestUsers.firstWhere(
      (profile) => profile.appUser.email == email,
      orElse: () => throw Exception('Invalid credentials'),
    );

    // Genera un token diverso per ogni utente
    _fakeToken = 'fakeToken123_${user.role.name}';
    await _saveToken(_fakeToken!); // Salva il token
    _currentUser = user;

    return _currentUser;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
    await _clearToken(); // Cancella il token dallo storage
  }

  // 7. Metodi privati
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _fakeToken = prefs.getString(_tokenKey);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    _fakeToken = token;
    await prefs.setString(_tokenKey, token);
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    _fakeToken = null;
    await prefs.remove(_tokenKey);
  }
}
