import '../../../exceptions/app_exception.dart';
import '../../../utils/delay.dart';
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
  final Map<String, UserProfile> _userTokenMap = {
    'fakeToken123_reporter': kTestUsers[0], // reporter@example.com
    'fakeToken123_operator': kTestUsers[1], // operator@example.com
    'fakeToken123_admin': kTestUsers[2], // admin@example.com
  };

  // 3. Variabili di istanza
  UserProfile? _currentUser;
  String? _fakeUserToken;

  // 4. Costruttore
  FakeAuthRepository({this.addDelay = true});

  // 5. Getter / Setter
  @override
  UserProfile? get currentUser => _currentUser;

  @override
  String get userToken => _fakeUserToken!;

  @override
  set fcmToken(String fcmToken) {}
  @override
  set deviceType(String deviceType) {}
  @override
  set deviceId(String? deviceId) {}

  // 6. Metodi privati
  Future<void> _loadUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    _fakeUserToken = prefs.getString(_tokenKey);
  }

  Future<void> _saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    _fakeUserToken = token;
    await prefs.setString(_tokenKey, token);
  }

  Future<void> _clearUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    _fakeUserToken = null;
    await prefs.remove(_tokenKey);
  }

  // 7. Metodi pubblici
  @override
  Future<UserProfile?> checkUserToken() async {
    await delay(addDelay, 1000);

    // Carica il token dallo storage
    await _loadUserToken();

    if (_fakeUserToken != null && _userTokenMap.containsKey(_fakeUserToken)) {
      // Recupera l'utente associato al token
      _currentUser = _userTokenMap[_fakeUserToken];
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

    // Verifica se l'utente esiste
    final user = kTestUsers.firstWhere(
      (profile) => profile.appUser.email == email,
      orElse: () => throw UserNotFoundException(),
    );

    // Controlla se la password corrisponde
    if (kTestUserPasswords[email] != password) {
      throw WrongPasswordException();
    }

    // Genera un token diverso per ogni utente
    _fakeUserToken = 'fakeToken123_${user.role.name}';
    await _saveUserToken(_fakeUserToken!); // Salva il token
    _currentUser = user;

    return _currentUser;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
    await _clearUserToken();
  }
}
