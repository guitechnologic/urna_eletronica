import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _key = 'admin_password';

  Future<void> setPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, password);
  }

  Future<bool> validatePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    return saved == password;
  }

  Future<bool> hasPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_key);
  }
}
