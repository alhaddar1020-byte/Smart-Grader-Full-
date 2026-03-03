import 'package:flutter/material.dart';
import 'screens/student_dashboard.dart'; // تأكد أن المسار واسم الملف صحيحان
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
      title: 'Grade AI',
      // إعداد الثيم العام
      theme: ThemeData(
        fontFamily: 'Arimo', // تأكد من إضافة الخط في ملف pubspec.yaml
        useMaterial3: true,
      ),
      // تشغيل واجهة لوحة تحكم الطالب كشاشة رئيسية
      home: const StudentDashboardScreen(),
    );
  }
}
