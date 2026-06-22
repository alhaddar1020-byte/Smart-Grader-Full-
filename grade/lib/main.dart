import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:grade/core/app_config.dart';

// --- استدعاءات نظام الترجمة (Localization) ---
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

// --- استدعاءات الـ Providers والملفات الأساسية ---
import 'core/theme_provider.dart';
import 'core/locale_provider.dart';
import 'core/main_layout.dart';
import 'provider/student_dashboard_controller.dart';

// --- استدعاءات شاشات الإدارة ومزودي البيانات (Admin Providers) ---
import 'screens/Admin_interface/admin_dashboard_provider.dart';
import 'screens/Admin_interface/admin_settings_provider.dart';
import 'screens/Admin_interface/users_management_provider.dart';
import 'screens/Admin_interface/add_users_provider.dart';
import 'screens/Admin_interface/dashboard_report_provider.dart';
import 'screens/Admin_interface/system_logs_provider.dart';
import 'screens/Admin_interface/backup_provider.dart';

// --- استدعاءات الشاشات (Screens) ---
import 'screens/homepage.dart'; // تأكدي أن هذا يحتوي على SmartCorrectorUI أو شاشة تسجيل الدخول
import 'screens/student_dashboard.dart';
import 'screens/teacher_dashboard.dart';
import 'screens/create_ai_exam_screen.dart';
import 'screens/quiz_details_page.dart';
import 'screens/review_exam_screen.dart';
import 'screens/exam_page.dart';
import 'screens/exam_page2.dart';
import 'screens/ExamManagementPage.dart';
import 'screens/Admin_interface/admin_dashboard_screen.dart';
import 'screens/Admin_interface/users_management_screen.dart';
import 'screens/Admin_interface/add_user_screen.dart';
import 'screens/Admin_interface/dashboard_report_screen.dart';
import 'screens/Admin_interface/system_logs_screen.dart';
import 'screens/Admin_interface/backup_screen.dart';

// 🌟 تعريفات مزودي بيانات الطالب (Student Controllers)
import 'package:grade/provider/settings_controller.dart';
import 'package:grade/provider/student_dashboard_controller.dart';
import 'package:grade/provider/subject_screen_controller.dart';
import 'package:grade/provider/subject_details_controller.dart';
import 'package:grade/provider/exam_details_controller.dart';

// ==========================================
// 1. دالة جلب الإعدادات الحية من السيرفر
// ==========================================
Future<Map<String, dynamic>> loadSettings(
  int userId,
  String cachedLang,
  bool cachedIsDark,
) async {
  try {
    final url = Uri.parse('${AppConfig.baseUrl}/settings/profile/$userId');
    final res = await http.get(url).timeout(const Duration(seconds: 3));

    if (res.statusCode == 200) {
      final decodedData = jsonDecode(utf8.decode(res.bodyBytes));
      if (decodedData is List && decodedData.isNotEmpty) {
        return decodedData[0] as Map<String, dynamic>;
      } else if (decodedData is Map<String, dynamic>) {
        return decodedData;
      }
    }
  } catch (e) {
    debugPrint("⚠️ السيرفر مطفأ أو معلق، سيتم استخدام الكاش المحلي: $e");
  }
  return {"language_code": cachedLang, "is_dark_mode": cachedIsDark};
}

// ==========================================
// 2. الدالة الرئيسية (Main)
// ==========================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // قراءة القيم المحفوظة من الذاكرة
  bool isDark = prefs.getBool('theme_mode') ?? false;
  String lang = prefs.getString('language_code') ?? 'ar';

  // التحقق من حالة تسجيل الدخول وصلاحية المستخدم
  final bool isLoggedIn =
      prefs.containsKey('user_id') || prefs.containsKey('student_id');
  final int userId = prefs.getInt('user_id') ?? prefs.getInt('student_id') ?? 1;
  final int? roleId = prefs.getInt('role_id');

  // المزامنة الحية مع السيرفر وتحديث القيم
  if (isLoggedIn) {
    final serverSettings = await loadSettings(userId, lang, isDark);

    // 1. تحديث اللغة
    lang = serverSettings['language_code'] ?? lang;

    // 2. فحص وتحديث الثيم (الكود الذكي الجديد)
    var fetchedTheme = serverSettings['is_dark_mode'];
    print(
      "🌍 قيمة الثيم الجاية من السيرفر: $fetchedTheme | نوعها: ${fetchedTheme.runtimeType}",
    );

    if (fetchedTheme != null) {
      if (fetchedTheme is bool) {
        isDark = fetchedTheme;
      } else if (fetchedTheme is int) {
        isDark = (fetchedTheme == 1);
      } else if (fetchedTheme is String) {
        isDark = (fetchedTheme.toLowerCase() == 'true' || fetchedTheme == '1');
      }
    }

    // 3. حفظ القيم النهائية في الذاكرة المحلية
    await prefs.setBool('theme_mode', isDark);
    await prefs.setString('language_code', lang);
  }

  // تهيئة الكنترولر الخاص بالطالب
  // final dashboardController = Get.put(StudentDashboardController());
  // if (isLoggedIn) {
  //   dashboardController.initController(userId);
  // }

  // التوجيه الذكي: تحديد شاشة البداية تلقائياً
  Widget startingScreen;
  if (!isLoggedIn) {
    startingScreen = const SmartCorrectorUI(); // شاشة البداية / تسجيل الدخول
  } else if (roleId == 1) {
    startingScreen = const MainLayout(); // واجهة الإدارة
  } else if (roleId == 2) {
    startingScreen = const DashboardScreen(); // واجهة المعلم
  } else {
    startingScreen = const StudentDashboardScreen(); // واجهة الطالب
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(isDark)),
        ChangeNotifierProvider(
          create: (_) => LocaleProvider()..setInitialLocale(lang),
        ),

        // ==========================================
        // مزودي بيانات الإدارة (Admin Providers)
        // ==========================================
        ChangeNotifierProvider(create: (_) => AdminDashboardProvider()),
        ChangeNotifierProvider(create: (_) => AdminSettingsProvider()),
        ChangeNotifierProvider(create: (_) => UsersManagementProvider()),
        ChangeNotifierProvider(create: (_) => AddUsersProvider()),
        ChangeNotifierProvider(create: (_) => DashboardReportProvider()),
        ChangeNotifierProvider(create: (_) => SystemLogsProvider()),
        ChangeNotifierProvider(create: (_) => BackupProvider()),

        // ==========================================
        // 🌟 مزودي بيانات الطالب (Student Providers) 🌟
        // ==========================================
        ChangeNotifierProvider(create: (_) => SettingsController()),
        ChangeNotifierProvider(create: (_) => StudentDashboardController()),
        ChangeNotifierProvider(create: (_) => SubjectScreenController()),
        ChangeNotifierProvider(create: (_) => SubjectDetailsController()),
        ChangeNotifierProvider(create: (_) => ExamDetailsController()),
      ],
      // ... تكملة الكود (child: MyApp(...))
      child: GradeAI(initialScreen: startingScreen),
    ),
  );
}

// ==========================================
// 3. بناء واجهة التطبيق (MaterialApp)
// ==========================================
class GradeAI extends StatelessWidget {
  final Widget initialScreen;
  const GradeAI({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp(
      navigatorKey: Get.key,
      debugShowCheckedModeBanner: false,
      title: 'Grade AI',

      locale: localeProvider.locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Arimo',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        primarySwatch: Colors.teal,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Arimo',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primarySwatch: Colors.teal,
      ),

      home: initialScreen,
    );
  }
}

  // FinalExamPage
  // StudentDashboardScreen
  // DashboardScreen
  // cd grading_system/intelligent-grading
//       home: initialScreen,
// aryjth953@gmail.com

