import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  // 🔐 Récupérer le token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // 👤 Récupérer l'ID utilisateur
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  // 🧼 Supprimer les infos (ex: logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
  }
}
