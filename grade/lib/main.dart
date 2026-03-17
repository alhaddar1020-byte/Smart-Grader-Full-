import 'package:flutter/material.dart';
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
      home:  DashboardScreen(),

      title: 'Grade AI',
    );
  }
}
