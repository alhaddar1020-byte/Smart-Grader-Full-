import 'package:flutter/material.dart';
import '../core/colors.dart'; // استدعاء الألوان يدوياً

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      // هنا نبدأ نبني الواجهة
      body: SafeArea(
        child: Column(
          children: [
            // 1. الجزء العلوي (الترحيب واسم الطالب)
            // 2. بطاقات الإحصائيات (المعدل، التنبيهات)
            // 3. قائمة المواد
          ],
        ),
      ),
    );
  }
}
