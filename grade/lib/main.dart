
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // أضيفي هذا السطر
// import 'package:shared_preferences/shared_preferences.dart'; // أضيفي هذا السطر

// // المستوردات الخاصة بكِ
// import 'screens/start.dart'; 
// import 'screens/student_dashboard.dart';
// import 'screens/teacher_dashboard.dart';
// import 'screens/teacher_matearial.dart';
// import 'screens/student_matearial.dart';
// import 'screens/grading.dart';
// import 'screens/material_detail.dart';
// import 'widgets/slider.dart';
// import 'screens/exam_page.dart';
// import 'screens/exam_page2.dart';
// import 'core/theme_provider.dart'; 

// void main() async {
//   // 1. تأكيد تهيئة Flutter قبل استدعاء SharedPreferences
//   WidgetsFlutterBinding.ensureInitialized();

//   // 2. قراءة حالة الثيم المحفوظة من الجهاز
//   final prefs = await SharedPreferences.getInstance();
//   final isDark = prefs.getBool('theme_mode') ?? false;

//   runApp(
//     // 3. تغليف التطبيق بالـ Provider وتمرير القيمة الأولية
//     ChangeNotifierProvider(
//       create: (_) => ThemeProvider(isDark),
//       child: const GradeAI(),
//     ),
//   );
// }

// class GradeAI extends StatelessWidget {
//   const GradeAI({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // 4. استدعاء الـ Provider لمعرفة حالة الثيم الحالية (فاتح/داكن)
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Grade AI',
      
//       // 5. ربط الثيم بالـ Provider
//       themeMode: themeProvider.themeMode,
//       theme: ThemeData(
//         fontFamily: 'Arimo',
//         brightness: Brightness.light, // الثيم الفاتح
//         useMaterial3: true,
//       ),
//       darkTheme: ThemeData(
//         fontFamily: 'Arimo',
//         brightness: Brightness.dark, // الثيم الداكن
//         useMaterial3: true,
//       ),
      
//       home: DashboardScreen(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // أضيفي هذا السطر
import 'package:shared_preferences/shared_preferences.dart'; // أضيفي هذا السطر

// --- استدعاءات نظام الترجمة ---
import 'package:flutter_localizations/flutter_localizations.dart'; 
import 'generated/l10n.dart'; 
// -----------------------------

// المستوردات الخاصة بكِ
import 'screens/start.dart'; 
import 'screens/student_dashboard.dart';
import 'screens/teacher_dashboard.dart';
import 'screens/teacher_matearial.dart';
import 'screens/student_matearial.dart';
import 'screens/grading.dart';
import 'screens/material_detail.dart';
import 'widgets/slider.dart';
import 'screens/exam_page.dart';
import 'screens/exam_page2.dart';
import 'core/theme_provider.dart'; 

void main() async {
  // 1. تأكيد تهيئة Flutter قبل استدعاء SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  // 2. قراءة حالة الثيم المحفوظة من الجهاز
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('theme_mode') ?? false;

  runApp(
    // 3. تغليف التطبيق بالـ Provider وتمرير القيمة الأولية
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(isDark),
      child: const GradeAI(),
    ),
  );
}

class GradeAI extends StatelessWidget {
  const GradeAI({super.key});

  @override
  Widget build(BuildContext context) {
    // 4. استدعاء الـ Provider لمعرفة حالة الثيم الحالية (فاتح/داكن)
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grade AI',

      // --- إعدادات الترجمة ---
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: const Locale('ar'), // لفرض اللغة العربية كافتراضية
      // -----------------------
      
      // 5. ربط الثيم بالـ Provider
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        fontFamily: 'Arimo',
        brightness: Brightness.light, // الثيم الفاتح
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Arimo',
        brightness: Brightness.dark, // الثيم الداكن
        useMaterial3: true,
      ),
      
      home: const DashboardScreen(),
    );
  }
}