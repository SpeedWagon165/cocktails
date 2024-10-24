import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'user_language';

  static Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'rus'; // 'rus' по умолчанию
  }
}
