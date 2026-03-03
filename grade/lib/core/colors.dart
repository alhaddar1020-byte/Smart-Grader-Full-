import 'package:flutter/material.dart';

class AppColors {
  // اللون التركواز الأساسي (المستخدم في القائمة الجانبية والأزرار الرئيسية)
  // تم استخراجه من الهوية البصرية في الصور
  static const Color primaryTeal = Color(0xFF4FB7B5);

  // اللون التركواز الفاتح جداً (المستخدم كخلفية للبطاقات في صفحة المواد)
  // يظهر بوضوح في تصميم لوحة التحكم
  static const Color secondaryTeal = Color(0xFFDEF6F5);

  // اللون الأصفر/الخردلي (المستخدم للتنبيهات والدرجات والإحصائيات)
  // كما في خانة "المواد الدراسية"
  static const Color accentYellow = Color(0xFFF6AD55);

  //اللون الاسود لون الخط الاساسي
  static const Color textprimary = Color.fromARGB(255, 0, 0, 0);

  // لون    (رمادي فاتح جداً يميل للبياض)
  static const Color scaffoldBg = Color(0xFFF3F4F6);

  // لون النصوص الداكنة ( للرمادي)
  static const Color textseccondary = Color(0xFF6A7282);

  // لون الأبيض الناصع (للنصوص داخل العناصر الملونة و للبطاقات)
  static const Color textWhite = Colors.white;
}
