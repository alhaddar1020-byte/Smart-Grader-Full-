
import 'package:flutter/material.dart';

// الألوان المستخدمة بناءً على الهوية البصرية في الصور
class AppColors {
  static const Color primaryTeal = Color(0xFF4FB7B5);
  static const Color lightTealBg = Color(0xFFDEF6F5);
  static const Color accentOrange = Color(0xFFF6AD55);
  static const Color textGray = Color(0xFF6A7282);
  static const Color cardBg = Colors.white;
}

class Material1 extends StatelessWidget {
  const Material1({super.key}); // تم إصلاح هذا السطر (إضافة اسم الكلاس)

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // لضمان ظهور الواجهة باللغة العربية بشكل صحيح
      child: Scaffold(
        backgroundColor: const Color(0xFFF3FBFB),
        body: Row(
          children: [
            // 1. القائمة الجانبية (Sidebar)
            const SidebarWidget(),
            
            // 2. منطقة المحتوى الرئيسية
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الهيدر العلوي
                    const HeaderWidget(),
                    const SizedBox(height: 20),
                    
                    // صف الإحصائيات العلوية
                    const StatsTopRow(),
                    const SizedBox(height: 30),
                    
                    const Text(
                      "المواد الدراسية",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    
                    // شبكة المواد
                    const SubjectsGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// كود القائمة الجانبية
class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white24,
            child: Icon(Icons.auto_graph, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 10),
          const Text("Intelligent Grading System", 
            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          _buildMenuItem(Icons.dashboard, "لوحة التحكم"),
          _buildMenuItem(Icons.assignment, "إدارة الامتحانات"),
          _buildMenuItem(Icons.book, "المواد", active: true),
          _buildMenuItem(Icons.check_circle, "تصحيح"),
          _buildMenuItem(Icons.rate_review, "مراجعة"),
          _buildMenuItem(Icons.settings, "إعدادات"),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool active = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: active ? Colors.white.withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }
}

// كود الهيدر
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("المواد الدراسية", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("قم بإدارة جميع المواد والامتحانات الخاصة بك", style: TextStyle(color: AppColors.textGray)),
          ],
        ),
        Row(
          children: [
            _headerIcon(Icons.notifications_none),
            const SizedBox(width: 10),
            _headerIcon(Icons.person_outline),
          ],
        )
      ],
    );
  }

  Widget _headerIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Icon(icon, color: AppColors.primaryTeal),
    );
  }
}

// كود الإحصائيات
class StatsTopRow extends StatelessWidget {
  const StatsTopRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statCard("الطلاب", "340", Icons.people, AppColors.accentOrange),
        _statCard("الأوراق المصححة", "780", Icons.description, AppColors.primaryTeal),
        _statCard("الاختبارات المنشئة", "13", Icons.quiz, AppColors.primaryTeal),
        _statCard("المسودات", "5", Icons.edit_note, AppColors.primaryTeal),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
            Icon(icon, color: Colors.white54, size: 30),
          ],
        ),
      ),
    );
  }
}

// شبكة المواد
class SubjectsGrid extends StatelessWidget {
  const SubjectsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        _subjectCard("discrete - المستوى الأول", "علوم حاسوب", "1", "340"),
        _subjectCard("فيزياء عملي - المستوى الأول", "تقنية معلومات", "0", "101"),
        _subjectCard("تفاضل - المستوى الأول", "تقنية معلومات", "9", "101"),
        _subjectCard("تكامل - المستوى الأول", "تقنية معلومات", "0", "101"),
        _addSubjectCard(),
      ],
    );
  }

  Widget _subjectCard(String title, String dept, String exams, String students) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.book_outlined, color: AppColors.primaryTeal),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.lightTealBg, borderRadius: BorderRadius.circular(10)),
                child: Text(dept, style: const TextStyle(fontSize: 10, color: AppColors.primaryTeal)),
              )
            ],
          ),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoTile("الامتحانات", exams),
              _infoTile("عدد الطلاب", students),
            ],
          )
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textGray, fontSize: 10)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _addSubjectCard() {
    return Container(
      width: 250,
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.lightTealBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryTeal.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline, color: AppColors.primaryTeal, size: 40),
          SizedBox(height: 10),
          Text("إضافة مادة", style: TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
