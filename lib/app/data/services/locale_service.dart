import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's language choice ('en' or 'th') across app restarts.
/// Defaults to English when nothing has been saved yet.
class LocaleService {
  static const _prefsKey = 'app_language_code';

  static const Locale defaultLocale = Locale('en', 'US');

  static const Map<String, Locale> supportedLocales = {
    'en': Locale('en', 'US'),
    'th': Locale('th', 'TH'),
  };

  static Future<Locale> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefsKey);
    return supportedLocales[code] ?? defaultLocale;
  }

  static Future<void> saveLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, languageCode);
  }
}
