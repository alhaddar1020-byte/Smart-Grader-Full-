import 'package:flutter/material.dart';
import 'screens/start.dart'; // ينادي ملف صديقتك
import 'screens/student_dashboard.dart'; // ينادي ملف صديقتك

void main() {
  runApp(const GradeAI());
}

class GradeAI extends StatelessWidget {
  const GradeAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // هنا حددنا "الخط" و "الصفحة الأولى" بس
      theme: ThemeData(fontFamily: 'Arimo'),
      home: const start(),
    );
  }
}
