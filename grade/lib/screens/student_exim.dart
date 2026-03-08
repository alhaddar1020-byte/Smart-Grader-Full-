import 'package:flutter/material.dart';
import '../core/colors.dart'; // تأكد من المسار
import 'student_dashboard.dart'; // لاستدعاء الـ Sidebar والـ Header إذا كانت عامة

import 'package:flutter/material.dart';
import '../core/colors.dart';

class StudentExamScreen extends StatelessWidget {
  final String subjectName;
  final VoidCallback onBack;
  final Function(int) onItemSelected;

  const StudentExamScreen({
    super.key,
    required this.subjectName,
    required this.onBack,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    // استخدمنا Directionality لضمان أن الترتيب يبدأ من اليمين
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          // 1. الهيدر المحدث مع دعم الـ RTL
          _buildFixedHeader(),

          // 2. محتوى الصفحة
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Text(
                    "محتوى الاختبار لـ $subjectName",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // أضف محتوى الاختبار هنا
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedHeader() {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          // الترتيب الآن سيبدأ من اليمين بفضل الـ Directionality
          children: [
            // 1. الرابط الأول: المواد
            // داخل _buildFixedHeader في ملف StudentExamScreen
            _breadcrumbItem("المواد", () {
              // أخبر الداشبورد أن يصفر المادة ويرجع لصفحة المواد
              onItemSelected(1);
            }),

            _dividerIcon(),

            // الرابط الثاني: اسم المادة (مثل الرياضيات)
            _breadcrumbItem(subjectName, () {
              // هنا نكتفي بالعودة فقط دون تصفير الاسم
              onBack();
            }),

            _dividerIcon(),

            // 3. الصفحة الحالية
            const Text(
              "عرض التفاصيل",
              style: TextStyle(
                color: Color(0xFF009689),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),

            const Spacer(), // يدفع الأيقونة لليسار
            // زر العودة (أيقونة السهم الآن ستكون جهة اليسار في العربي)
            IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_forward_ios, // نستخدم forward لأننا في اتجاه RTL
                size: 16,
                color: Color(0xFF009689),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _breadcrumbItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF6A7282),
            fontSize: 14,
            fontFamily: "Arimo", // تأكد من استخدام نفس خطك
          ),
        ),
      ),
    );
  }

  Widget _dividerIcon() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.chevron_left, // في RTL هذا سيشير للاتجاه الصحيح للتسلسل
        color: Colors.grey,
        size: 18,
      ),
    );
  }
}
