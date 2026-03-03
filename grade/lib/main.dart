// import 'package:flutter/material.dart';
// import 'screens/start.dart'; // ينادي ملف صديقتك
// import 'screens/student_dashboard.dart'; // ينادي ملف صديقتك
// import 'screens/teacher_dashboard.dart';
// import 'screens/Material.dart';
// import 'screens/student_dashboard.dart'; // تأكد أن المسار واسم الملف صحيحان
// import 'widgets/slider.dart';


// void main() {
//   runApp(const GradeAI());
// }

// class GradeAI extends StatelessWidget {
//   const GradeAI({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // هنا حددنا "الخط" و "الصفحة الأولى" بس
//       theme: ThemeData(fontFamily: 'Arimo'),
//       home:  Material1(),
//       title: 'Grade AI',
//       // إعداد الثيم العام
//       theme: ThemeData(
//         fontFamily: 'Arimo', // تأكد من إضافة الخط في ملف pubspec.yaml
//         useMaterial3: true,
//       ),
//       // تشغيل واجهة لوحة تحكم الطالب كشاشة رئيسية
//       home: const StudentDashboardScreen(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'screens/start.dart';
import 'screens/student_dashboard.dart';
import 'screens/teacher_dashboard.dart';
import 'screens/Material.dart';
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
      theme: ThemeData(
        fontFamily: 'Arimo',
        useMaterial3: true,
      ),

      // 👇 اختاري الصفحة اللي تبغوها كبداية
      home: const StudentDashboardScreen(),
      // لو تبغي:
      // home: TeacherDashboard(),
      // home: Material1(),
    );
  }
}