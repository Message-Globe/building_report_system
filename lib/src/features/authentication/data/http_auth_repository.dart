import 'dart:async';
import 'dart:convert';

import '../domain/building.dart';

import '../../../exceptions/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../domain/app_user.dart';
import '../domain/user_profile.dart';
import 'auth_repository.dart';

class HttpAuthRepository with ChangeNotifier implements AuthRepository {
  // 1. Costanti statiche
  static const String _baseUrl = "https://api.cooperativadoc.it";
  static const String _userTokenKey = 'auth_token';

  // 2. Variabili di istanza
  UserProfile? _currentUser;
  String? _userToken;

  late final String _fcmToken;
  late final String _deviceType;
  late final String? _deviceId;

  // 3. Getter / Setter
  @override
  UserProfile? get currentUser => _currentUser;

  @override
  String get userToken => _userToken!;

  @override
  set fcmToken(String fcmToken) => _fcmToken = fcmToken;
  @override
  set deviceType(String deviceType) => _deviceType = deviceType;
  @override
  set deviceId(String? deviceId) => _deviceId = deviceId;

  // 4. Metodi privati
  Future<void> _saveUserToken(String token) async {
    _userToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTokenKey, token);
  }

  Future<void> _loadUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    _userToken = prefs.getString(_userTokenKey);
  }

  Future<void> _clearUserToken() async {
    _userToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userTokenKey);
  }

  UserProfile _getUserProfileFromApiResponse(Map<String, dynamic> data) {
    // Supponendo che `data['structures']` sia una mappa in cui la chiave è l'ID e il valore è il nome dell'edificio.
    final List<Building> assignedBuildings = (data['structures'] as Map<String, dynamic>)
        .entries
        .map((entry) => Building(
              id: entry.key,
              name: entry.value,
            ))
        .toList();

    return UserProfile(
      appUser: AppUser(
        uid: data['uid'].toString(),
        email: data['email'],
      ),
      name: data['name'],
      assignedBuildings: assignedBuildings, // Assegna la mappa di edifici
      role: _mapRoleToUserRole(data['role']),
    );
  }

  UserRole _mapRoleToUserRole(String apiRole) {
    switch (apiRole) {
      case 'segnalatore':
        return UserRole.reporter;
      case 'manutentore':
        return UserRole.operator;
      default:
        return UserRole.admin;
    }
  }

  // 5. Metodi pubblici
  @override
  Future<UserProfile?> checkUserToken() async {
    await _loadUserToken();
    if (_userToken == null) {
      return null; // Token non presente
    }

    // API per verificare il token
    final url = Uri.parse("$_baseUrl/api/token/check");
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_userToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'fcm_token': _fcmToken,
        'device_id': _deviceId,
        'device_type': _deviceType,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      _currentUser = _getUserProfileFromApiResponse(data);
      return _currentUser;
    } else {
      // Token non valido o scaduto
      await _clearUserToken();
      return null;
    }
  }

  @override
  Future<UserProfile?> signInWithEmailAndPassword(String email, String password) async {
    final url = Uri.parse("$_baseUrl/api/login");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'fcm_token': _fcmToken,
        'device_id': _deviceId,
        'device_type': _deviceType
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];

      // Estrai il token
      final token = data['token'];

      // Salva il token in SharedPreferences
      await _saveUserToken(token);

      // Crea il profilo utente dall'API
      _currentUser = _getUserProfileFromApiResponse(data);

      return _currentUser;
    } else if (response.statusCode == 401) {
      throw WrongCredentials();
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
    await _clearUserToken();
  }
}
