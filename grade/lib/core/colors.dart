// import 'package:flutter/material.dart';

// class AppColors {
//   // دالة مساعدة لتعرف حالة النظام (فاتح أو داكن)
//   static bool _isDark(BuildContext context) =>
//       Theme.of(context).brightness == Brightness.dark;

//   // 1. اللون التركواز الأساسي
//   static Color primaryTeal(BuildContext context) {
//     return _isDark(context)
//         ? const Color.fromARGB(255, 27, 102, 101)
//         : const Color(0xFF4FB7B5);
//   }

//   // 2. اللون التركواز الفاتح (الخلفيات)
//   static Color secondaryTeal(BuildContext context) {
//     return _isDark(context)
//         ? const Color.fromARGB(255, 7, 7, 7)
//         : const Color(0xFFE8F4F2);
//   }

//   // 3. اللون الأصفر/الخردلي
//   static Color accentYellow(BuildContext context) {
//     return _isDark(context)
//         ? const Color.fromARGB(255, 106, 79, 23)
//         : const Color(0xFFF6AD55);
//   }

//   // 4. لون الخط الأساسي (يصير أبيض في الداكن)
//   static Color textPrimary(BuildContext context) {
//     return _isDark(context) ? Colors.white : const Color(0xFF000000);
//   }

//   // 5. لون خلفية التطبيق (يصير رمادي غامق جداً في الداكن)
//   static Color scaffoldBg(BuildContext context) {
//     return _isDark(context)
//         ? const Color.fromARGB(255, 16, 16, 16)
//         : const Color(0xFFF3F4F6);
//   }

//   // 6. لون النصوص الثانوية
//   static Color textSecondary(BuildContext context) {
//     return _isDark(context)
//         ? const Color.fromARGB(255, 174, 182, 196)
//         : const Color(0xFF6A7282);
//   }

//   // 7. لون الأبيض (للبطاقات والعناصر)
//   static Color cardBg(BuildContext context) {
//     return _isDark(context)
//         ? const Color.fromARGB(255, 40, 40, 40)
//         : Colors.white;
//   }

//   static Color TherdTeal(BuildContext context) {
//     return _isDark(context)
//         ? const Color.fromARGB(255, 0, 0, 0)
//         : const Color(0xFFE8F4F2);
//   }

//   static Color ForthTeal(BuildContext context) {
//     return _isDark(context) ? const Color(0xFF6A7282) : const Color(0xFFE8F4F2);
//   }

//   //  Color.fromARGB(255, 83, 253, 145)  const Color(0xFF00A63E);
//   // if (score > 0) return const Color(0xFFD08700);
//   // return const Color(0xFFE7000B);
// }
// import 'package:flutter/material.dart';

// class AppColors {
//   // دالة مساعدة لتعرف حالة النظام (فاتح أو داكن)
//   static bool _isDark(BuildContext context) =>
//       Theme.of(context).brightness == Brightness.dark;

//   // ألوان ثابتة لا تحتاج context (لحل مشاكل الـ Getters)
//   static const Color textWhite = Colors.white;
//   static const Color textSeccondary = Color(0xFF8F959E); // المسمى بالخطأ الإملائي لحل المشكلة عندك

//   // 1. اللون التركواز الأساسي
//   static Color primaryTeal(BuildContext context) {
//     return _isDark(context)
//         ? const Color.fromARGB(255, 27, 102, 101)
//         : const Color(0xFF4FB7B5);
//   }

//   // 2. اللون التركواز الفاتح (الخلفيات)
//   static Color secondaryTeal(BuildContext context) {
//     return _isDark(context)
//         ? const Color.fromARGB(255, 7, 7, 7)
//         : const Color(0xFFE8F4F2);
//   }

//   // 3. اللون الأصفر/الخردلي
//   static Color accentYellow(BuildContext context) {
//     return _isDark(context)
//         ? const Color.fromARGB(255, 106, 79, 23)
//         : const Color(0xFFF6AD55);
//   }

//   // 4. لون الخط الأساسي
//   static Color textPrimary(BuildContext context) {
//     return _isDark(context) ? Colors.white : const Color(0xFF000000);
//   }

//   // 5. لون خلفية التطبيق
//   static Color scaffoldBg(BuildContext context) {
//     return _isDark(context)
//         ? const Color.fromARGB(255, 16, 16, 16)
//         : const Color(0xFFF3F4F6);
//   }

//   // 6. لون النصوص الثانوية (الصحيح)
//   static Color textSecondary(BuildContext context) {
//     return _isDark(context)
//         ? const Color.fromARGB(255, 174, 182, 196)
//         : const Color(0xFF6A7282);
//   }

//   // 7. لون الأبيض (للبطاقات والعناصر)
//   static Color cardBg(BuildContext context) {
//     return _isDark(context)
//         ? const Color.fromARGB(255, 40, 40, 40)
//         : Colors.white;
//   }

//   static Color therdTeal(BuildContext context) {
//     return _isDark(context)
//         ? const Color.fromARGB(255, 0, 0, 0)
//         : const Color(0xFFE8F4F2);
//   }

//   static Color forthTeal(BuildContext context) {
//     return _isDark(context) ? const Color(0xFF6A7282) : const Color(0xFFE8F4F2);
//   }
// }

import 'package:flutter/material.dart';

class AppColors {
  // دالة مساعدة لتعرف حالة النظام (فاتح أو داكن)
  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  // --- ألوان ثابتة (تُستدعى بدون context وبدون أقواس) ---
  // أضفت هذه الأسطر بنفس المسميات الموجودة في أخطائك لحلها فوراً
  static const Color textprimary = Color(0xFF000000);
  static const Color textseccondary = Color(0xFF8F959E); 
  static const Color textWhiteConstant = Colors.white;

  // 1. اللون التركواز الأساسي
  static Color primaryTeal(BuildContext context) {
    return _isDark(context)
        ? const Color.fromARGB(255, 27, 102, 101)
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

  // 4. لون الخط الأساسي (دالة بـ context)
  static Color textPrimary(BuildContext context) {
    return _isDark(context) ? Colors.white : const Color(0xFF000000);
  }

  // 5. لون خلفية التطبيق
  static Color scaffoldBg(BuildContext context) {
    return _isDark(context)
        ? const Color.fromARGB(255, 16, 16, 16)
        : const Color(0xFFF3F4F6);
  }

  // 6. لون النصوص الثانوية (دالة بـ context)
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

  static Color therdTeal(BuildContext context) {
    return _isDark(context)
        ? const Color.fromARGB(255, 0, 0, 0)
        : const Color(0xFFE8F4F2);
  }

  static Color forthTeal(BuildContext context) {
    return _isDark(context) ? const Color(0xFF6A7282) : const Color(0xFFE8F4F2);
  }

  // دالة للـ textWhite كـ Method لتجنب أي تعارض قديم
  static Color textWhite(BuildContext context) => Colors.white;
}