import 'package:grade/core/app_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar');
  Locale get locale => _locale;

  void setInitialLocale(String langCode) {
    _locale = Locale(langCode);
    notifyListeners();
  }

  // 💡 قمنا بإضافة باراميتر الـ studentId هنا للمزامنة
  Future<void> updateLanguage(String newLang, int studentId) async {
    _locale = Locale(newLang);
    notifyListeners();

    // 1. حفظ محلي
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', newLang);
    bool currentTheme = prefs.getBool('theme_mode') ?? false;

    // 2. المزامنة مع قاعدة البيانات (Supabase) عبر الباكيند
    try {
      final String url =
          '${AppConfig.baseUrl}/settings/update-display-preferences';
      final token = prefs.getString('auth_token') ?? '';
      await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': studentId,
          'language_code': newLang,
          'is_dark_mode': currentTheme,
        }),
      );
      print("✅ تم حفظ اللغة في قاعدة البيانات بنجاح");
    } catch (e) {
      print("❌ فشل الاتصال بالسيرفر لحفظ اللغة: $e");
    }
  }
}
