import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String loginKey = 'isLoggedIn';
  static const String usernameKey = 'username';

  static Future<void> saveLogin(String username) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(loginKey, true);
    await prefs.setString(usernameKey, username);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(loginKey) ?? false;
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(usernameKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(loginKey);
    await prefs.remove(usernameKey);
  }
}
