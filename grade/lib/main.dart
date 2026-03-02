import 'package:flutter/material.dart';
import 'screens/start.dart';
import 'screens/student_dashboard.dart';

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

      // الـ builder هو "الغلاف" اللي بيطبق على كل الصفحات
      builder: (context, child) {
        return Scaffold(
          // لون خلفية اختياري يظهر فقط لو الشاشة كانت أكبر من 1440
          backgroundColor: const Color(0xFFF5F5F5),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1440, // المقاس اللي اعتمدتيه في فيجما
              ),
              child: Container(
                color: Colors.white, // لون خلفية التطبيق الأساسي
                child:
                    child, // هنا يتم عرض الصفحة الحالية (StudentDashboardScreen)
              ),
            ),
          ),
        );
      },

      home: const StudentDashboard(),
    );
  }
}
