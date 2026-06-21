import 'package:grade/core/app_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ThemeProvider extends ChangeNotifier {
  late ThemeMode _themeMode;

  ThemeProvider(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void setThemeFromDatabase(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleTheme(bool isOn, int studentId) async {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme_mode', isOn);
    String currentLang = prefs.getString('language_code') ?? 'ar';

    // منع استدعاء الـ API إذا لم يكن المستخدم مسجلاً للدخول
    if (studentId == 0) return;

    try {
      // 💡 تم توحيد مسار الـ IP ليتوافق مع الـ Localhost بشكل صحيح للويب
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
          'language_code': currentLang,
          'is_dark_mode': isOn,
        }),
      );
      print("✅ تم حفظ الثيم في قاعدة البيانات بنجاح");
    } catch (e) {
      print("❌ فشل الاتصال بالسيرفر لحفظ الثيم: $e");
    }
  }
}
