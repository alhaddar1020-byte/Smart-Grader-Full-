import 'package:flutter/material.dart';

class AppColors {
  // دالة مساعدة لتعرف حالة النظام (فاتح أو داكن)
  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  // 1. اللون التركواز الأساسي
  static Color primaryTeal(BuildContext context) {
    return _isDark(context)
        ? const Color.fromARGB(255, 23, 87, 86)
        : const Color(0xFF4FB7B5);
  }

  // 2. اللون التركواز الفاتح (الخلفيات)
  static Color secondaryTeal(BuildContext context) {
    return _isDark(context)
        ? const Color.fromARGB(255, 7, 7, 7)
        : const Color(0xFFE8F4F2);
  }

  // 3. اللون الأصفر/الخردلي
  static Color accentYellow(BuildContext context) {
    return _isDark(context)
        ? const Color.fromARGB(255, 106, 79, 23)
        : const Color(0xFFF6AD55);
  }

  // 4. لون الخط الأساسي (يصير أبيض في الداكن)
  static Color textPrimary(BuildContext context) {
    return _isDark(context) ? Colors.white : const Color(0xFF000000);
  }

  // 5. لون خلفية التطبيق (يصير رمادي غامق جداً في الداكن)
  static Color scaffoldBg(BuildContext context) {
    return _isDark(context)
        ? const Color.fromARGB(255, 16, 16, 16)
        : const Color(0xFFF3F4F6);
  }

  // 6. لون النصوص الثانوية
  static Color textSecondary(BuildContext context) {
    return _isDark(context)
        ? const Color.fromARGB(255, 174, 182, 196)
        : const Color(0xFF6A7282);
  }

  // 7. لون الأبيض (للبطاقات والعناصر)
  static Color cardBg(BuildContext context) {
    return _isDark(context)
        ? const Color.fromARGB(255, 40, 40, 40)
        : Colors.white;
  }

  static Color TherdTeal(BuildContext context) {
    return _isDark(context)
        ? const Color.fromARGB(255, 0, 0, 0)
        : const Color(0xFFE8F4F2);
  }

  static Color ForthTeal(BuildContext context) {
    return _isDark(context) ? const Color(0xFF6A7282) : const Color(0xFFE8F4F2);
  }
}
