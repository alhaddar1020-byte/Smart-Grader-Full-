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

  // إزالة studentId من هنا
  void toggleTheme(bool isOn) async {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme_mode', isOn);
    String currentLang = prefs.getString('language_code') ?? 'ar';

    // 💡 الحل الجذري: سحب user_id الحقيقي مباشرة من الذاكرة
    int userId = prefs.getInt('user_id') ?? 0;

    // منع استدعاء الـ API إذا لم يكن المستخدم مسجلاً للدخول
    if (userId == 0) {
      print("⚠️ لم يتم العثور على user_id، تم حفظ الثيم محلياً فقط.");
      return;
    }

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
          'user_id': userId, // 👈 الآن نحن نرسل الـ ID الصحيح 100%
          'language_code': currentLang,
          'is_dark_mode': isOn,
        }),
      );
      print("✅ تم حفظ الثيم في قاعدة البيانات بنجاح للمستخدم رقم: $userId");
    } catch (e) {
      print("❌ فشل الاتصال بالسيرفر لحفظ الثيم: $e");
    }
  }
}
