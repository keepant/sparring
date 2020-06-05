import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> getToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('token') ?? null;
  } 

  Future<bool> setToken(String value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString('token', value);
  }
  
  Future<bool> clearToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.clear();
  }

  Future<bool> checkValue() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.containsKey('token') ?? false;
  }
}

Prefs prefs = Prefs();
