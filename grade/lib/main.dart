import 'package:flutter/material.dart';
import 'screens/start.dart'; // ينادي ملف صديقتك
import 'screens/student_dashboard.dart'; // ينادي ملف صديقتك
import 'screens/teacher_dashboard.dart';
import 'screens/teacher_matearial.dart';
import 'screens/student_matearial.dart';
import 'widgets/slider.dart';
import 'screens/student_exim.dart';
import '../core/colors.dart';
import 'package:provider/provider.dart';
import 'core/theme_provider.dart'; // تأكدي من المسار الصحيح للملف الذي أنشأتيه
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // 1. التأكد من تهيئة أدوات Flutter قبل تشغيل أي كود برمجي
  WidgetsFlutterBinding.ensureInitialized();

  // 2. قراءة الحالة المحفوظة قبل تشغيل التطبيق
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDark =
      prefs.getBool('theme_mode') ?? false; // إذا لم يجد شيئاً يفترض أنه فاتح

  runApp(
    ChangeNotifierProvider(
      // 3. نمرر القيمة التي قرأناها للـ Provider عند إنشائه
      create: (context) => ThemeProvider(isDark),
      child: const GradeAI(),
    ),
  );
}

class GradeAI extends StatelessWidget {
  const GradeAI({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grade AI',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Arimo',
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Arimo',
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const StudentDashboardScreen(),
    );
  }
}
