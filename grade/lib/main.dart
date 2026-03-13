import 'package:flutter/material.dart';
import 'screens/start.dart'; // ينادي ملف صديقتك
import 'screens/student_dashboard.dart'; // ينادي ملف صديقتك
import 'screens/teacher_dashboard.dart';
import 'screens/teacher_matearial.dart';
import 'screens/student_matearial.dart';
import 'screens/grading.dart';
import 'screens/material_detail.dart';
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
      // هنا حددنا "الخط" و "الصفحة الأولى" بس
      theme: ThemeData(fontFamily: 'Arimo'),
      home:  IntelligentGradingApp(),
      title: 'Grade AI',
      // إعداد الثيم العام
      
      // تشغيل واجهة لوحة تحكم الطالب كشاشة رئيسية
    );
  }
}
