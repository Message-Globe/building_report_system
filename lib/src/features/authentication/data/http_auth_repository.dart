import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../domain/app_user.dart';
import '../domain/user_profile.dart';
import 'auth_repository.dart';

class HttpAuthRepository with ChangeNotifier implements AuthRepository {
  // 1. Costanti statiche
  static const String _baseUrl = "https://api.cooperativadoc.it";
  static const String _tokenKey = 'auth_token';

  // 2. Variabili di istanza
  UserProfile? _currentUser;
  String? _token;

  // 3. Getter
  @override
  UserProfile? get currentUser => _currentUser;

  // 4. Metodi pubblici
  @override
  Future<UserProfile?> checkToken() async {
    await _loadToken(); // Carica il token da SharedPreferences
    if (_token == null) {
      return null; // Token non presente
    }

    // TODO: change with check token api
    // API per verificare il token
    final url = Uri.parse("$_baseUrl/api/verify-token");
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      _currentUser = _getUserProfileFromApiResponse(data);
      return _currentUser;
    } else {
      // Token non valido o scaduto
      await _clearToken(); // Cancella il token
      return null;
    }
  }

  @override
  Future<UserProfile?> signInWithEmailAndPassword(String email, String password) async {
    final url = Uri.parse("$_baseUrl/api/login?email=$email&password=$password");
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];

      // Estrai il token
      final token = data['token'];

      // Salva il token in SharedPreferences
      await _saveToken(token);

      // Crea il profilo utente dall'API
      _currentUser = _getUserProfileFromApiResponse(data);

      return _currentUser;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
    await _clearToken();
  }

  // 5. Metodi privati
  Future<void> _saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
  }

  Future<void> _clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  UserProfile _getUserProfileFromApiResponse(Map<String, dynamic> data) {
    final Map<String, dynamic> structuresMap = data['structures'] as Map<String, dynamic>;
    final List<String> buildingsIds =
        structuresMap.values.map((e) => e.toString()).toList();

    return UserProfile(
      appUser: AppUser(
        uid: data['uid'].toString(),
        email: data['email'],
      ),
      name: data['name'],
      buildingsIds: buildingsIds,
      role: _mapRoleToUserRole(data['role']),
    );
  }

  UserRole _mapRoleToUserRole(String apiRole) {
    switch (apiRole) {
      case 'segnalatore':
        return UserRole.reporter;
      case 'manutentore':
        return UserRole.operator;
      case 'admin':
        return UserRole.admin;
      default:
        throw Exception('Unknown role: $apiRole');
    }
  }
}
