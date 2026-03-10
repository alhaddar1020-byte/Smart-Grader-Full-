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

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const GradeAI(),
    ),
  );
}

class GradeAI extends StatelessWidget {
  const GradeAI({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // استدعاء المزود

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grade AI',
      themeMode: themeProvider.themeMode, // ربط وضع الثيم بالمزود
      theme: ThemeData(brightness: Brightness.light, fontFamily: 'Arimo'),
      darkTheme: ThemeData(brightness: Brightness.dark, fontFamily: 'Arimo'),
      home: const StudentDashboardScreen(),
    );
  }
}
