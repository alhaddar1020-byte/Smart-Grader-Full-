import 'package:flutter/material.dart';
import 'screens/start.dart'; // ينادي ملف صديقتك
import 'screens/student_dashboard.dart'; // ينادي ملف صديقتك
import 'screens/teacher_dashboard.dart';
import 'screens/teacher_matearial.dart';
import 'screens/student_matearial.dart';
import 'widgets/slider.dart';

void main() {
  runApp(const GradeAI());
}

class GradeAI extends StatelessWidget {
  const GradeAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Arimo'),
      home: const IntelligentGradingApp(), // تأكدي من إضافة const إذا لزم الأمر
      title: 'Grade AI',
    );
  }
}
