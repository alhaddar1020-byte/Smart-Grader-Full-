import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeMode _themeMode;

  // كونستركتور يستقبل الحالة الأولية
  ThemeProvider(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) async {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    // حفظ الخيار فوراً
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme_mode', isOn);
  }
}
