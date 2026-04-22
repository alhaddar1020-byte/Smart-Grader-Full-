
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
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // أضيفي هذا السطر
// import 'package:shared_preferences/shared_preferences.dart'; // أضيفي هذا السطر

// // --- استدعاءات نظام الترجمة ---
// import 'package:flutter_localizations/flutter_localizations.dart'; 
// import 'generated/l10n.dart'; 
// // -----------------------------

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

//       // --- إعدادات الترجمة ---
//       localizationsDelegates: const [
//         S.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: S.delegate.supportedLocales,
//       locale: const Locale('en'), // لفرض اللغة العربية كافتراضية
//       // -----------------------
      
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
      
//       home: const StudentDashboardScreen(),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // الاستيرادات الخاصة بمشروعك
// import 'screens/student_dashboard.dart';
// import '../core/colors.dart';
// import 'core/theme_provider.dart';
// import 'core/locale_provider.dart';
// import 'generated/l10n.dart'; // كلاس S المولد تلقائياً

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   bool isDark = prefs.getBool('theme_mode') ?? false;
//   String savedLang = prefs.getString('language_code') ?? 'ar';

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => ThemeProvider(isDark)),
//         ChangeNotifierProvider(
//           create: (context) => LocaleProvider()..setInitialLocale(savedLang),
//         ),
//       ],
//       child: const GradeAI(),
//     ),
//   );
// }

// class GradeAI extends StatelessWidget {
//   const GradeAI({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = context.watch<ThemeProvider>();
//     final localeProvider = context.watch<LocaleProvider>();

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Grade AI',
//       themeMode: themeProvider.themeMode,

//       // إعدادات الثيم الفاتح
//       theme: ThemeData(
//         brightness: Brightness.light,
//         fontFamily: 'Arimo',
//         scaffoldBackgroundColor: const Color(0xFFF3F4F6),
//       ),

//       // إعدادات الثيم المظلم
//       darkTheme: ThemeData(
//         brightness: Brightness.dark,
//         fontFamily: 'Arimo',
//         scaffoldBackgroundColor: const Color(0xFF121212),
//       ),

//       // --- إعدادات اللغة والترجمة المحترفة ---
//       locale: localeProvider.locale, // اللغة الحالية من البروفايدر

//       localizationsDelegates: const [
//         S.delegate, // إخبار فلاتر باستخدام الكلاس S للترجمة
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],

//       // جلب اللغات المدعومة مباشرة من ملفات الـ ARB التي أنشأتها الإضافة
//       supportedLocales: S.delegate.supportedLocales,

//       // الـ Builder للتحكم باتجاه الشاشة (RTL/LTR)
//       builder: (context, child) {
//         return Directionality(
//           textDirection: localeProvider.locale.languageCode == 'ar'
//               ? TextDirection.rtl
//               : TextDirection.ltr,
//           child: child!,
//         );
//       },

//       home: const StudentDashboardScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/teacher_dashboard.dart';
import 'screens/student_dashboard.dart';
import 'screens/homepage.dart';
import 'screens/loginpage.dart';// --- استدعاءات نظام الترجمة (Localization) ---
import 'screens/create_electronic_exam.dart';
// import 'screens/exammanagepage.dart';
import 'screens/create_ai_exam_screen.dart';
import 'screens/quiz_details_page.dart';
import 'screens/review_exam_screen.dart';
import 'screens/Admin_interface/admin_dashboard_screen.dart';
import 'screens/Admin_interface/users_management_screen.dart';
import 'screens/Admin_interface/add_user_screen.dart';
import 'screens/Admin_interface/dashboard_report_screen.dart';
import 'screens/Admin_interface/system_logs_screen.dart';
import 'screens/Admin_interface/BackupScreen.dart';

// --- استدعاءات الـ Providers والملفات الخاصة بك ---
import 'core/theme_provider.dart'; 
import 'core/locale_provider.dart'; 
import 'package:flutter_localizations/flutter_localizations.dart'; 
import 'generated/l10n.dart'; 
import '/core/main_layout.dart'; 
import '/core/teacher_main_layout.dart';
void main() async {
  // 1. تأكيد تهيئة محرك Flutter قبل التعامل مع الذاكرة
  WidgetsFlutterBinding.ensureInitialized();

  // 2. قراءة القيم المحفوظة من ذاكرة الجهاز (SharedPreferences)
  final prefs = await SharedPreferences.getInstance();
  
  // قراءة الثيم (افتراضي فاتح false) واللغة (افتراضي عربي ar)
  final bool isDark = prefs.getBool('theme_mode') ?? false;
  final String savedLang = prefs.getString('language_code') ?? 'ar';

  runApp(
    // 3. دمج الـ Providers لتوفير الحالة للتطبيق بالكامل
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(isDark),
        ),
        ChangeNotifierProvider(
          create: (context) => LocaleProvider()..setInitialLocale(savedLang),
        ),
      ],
      child: const GradeAI(),
    ),
  );
}

class GradeAI extends StatelessWidget {
  const GradeAI({super.key});

  @override
  Widget build(BuildContext context) {
    // 4. مراقبة التغيرات في اللغة والثيم عبر البروفايدر
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grade AI',

      // --- 5. إعدادات اللغة (Locale) ---
      // ربط اللغة الحالية بالبروفايدر يضمن تغيير الاتجاه (RTL/LTR) تلقائياً
      locale: localeProvider.locale,

      localizationsDelegates: const [
        S.delegate, // كلاس الترجمة المولد تلقائياً
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // جلب اللغات المدعومة من ملفات الـ ARB
      supportedLocales: S.delegate.supportedLocales,

      // --- 6. إعدادات الثيم (Theme) ---
      themeMode: themeProvider.themeMode,
      
      // الثيم الفاتح
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Arimo',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        primarySwatch: Colors.teal,
      ),

      // الثيم الداكن
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Arimo',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primarySwatch: Colors.teal,
      ),

      // الشاشة الافتتاحية
      // home: SmartCorrectorUI(),
      // home:  MainLayout(),
      // home:  DashboardScreen(),
      home:StudentDashboardScreen(),
      // home:TeacherMainLayout(),
      
    );
  }
}