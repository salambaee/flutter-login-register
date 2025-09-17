import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  Future<bool> checkLogin() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool("isLoggedIn") ?? false;
  }

  Future<String?> getUsername() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString("username");
  }
}