import 'dart:convert';

import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  late Usuario usuario;
  bool _autenticando = false;

  // Crear storage
  final _storage = new FlutterSecureStorage();

  // get y set de autenticando
  bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  // Getters del token de forma estática
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token ?? 'No hay token';
  }

  // Método para eliminar el token de forma estática
  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;
    final data = {
      'email': email,
      'password': password,
    };

    final url = Uri.parse('${Environment.apiUrl}/login');

    final resp = await http.post(url,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    print(resp.body);
    autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      // Guardar token
      await _guardarToken(loginResponse.token);

      return true; // Login exitoso
    } else {
      return false; // Login fallido
    }
  }

  Future register(String nombre, String email, String password) async {
    autenticando = true;
    final data = {
      'nombre': nombre,
      'email': email,
      'password': password,
    };

    final url = Uri.parse('${Environment.apiUrl}/login/new');

    final resp = await http.post(url,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      // Guardar token
      await _guardarToken(loginResponse.token);

      return true; // Registro exitoso
    } else {
      final body = json.decode(resp.body);
      final mensaje = body['msg'] ?? 'Error desconocido';
      return mensaje; // Login fallido
    }
  }

  Future<bool?> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    final url = Uri.parse('${Environment.apiUrl}/login/renew');

    final resp = await http.get(url,
        headers: {'Content-Type': 'application/json', 'x-token': token ?? ''});


    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      // Guardar token
      await _guardarToken(loginResponse.token);

      return true; // Registro exitoso
    } else {
      logout(); // Eliminar token
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
