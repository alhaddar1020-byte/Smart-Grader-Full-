// import 'package:flutter/material.dart';
// import '../core/colors.dart';
// import 'dart:math';

// class AppColors {
//   static const Color primaryTeal = Color(0xFF4FB7B5);
//   static const Color secondaryTeal = Color(0xFFDEF6F5);
//   static const Color accentYellow = Color(0xFFF6AD55);
//   static const Color textprimary = Color(0xFF000000);
//   static const Color scaffoldBg = Color(0xFFF3F4F6);
//   static const Color textseccondary = Color(0xFF6A7282);
//   static const Color textWhite = Colors.white;
// }

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.secondaryTeal,
//       body: Row(
//         children: [
//           _buildMain(),
//           _buildSidebar(),
//         ],
//       ),
//     );
//   }

//   // ================= MAIN =================

//   Widget _buildMain() {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.all(30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             // Header Card
//             Container(
//               height: 80,
//               padding: const EdgeInsets.symmetric(horizontal: 25),
//               decoration: _cardDecoration(),
//               child: Row(
//                 children: [
//                   const CircleAvatar(
//                     backgroundColor: AppColors.secondaryTeal,
//                     child: Icon(Icons.person, color: AppColors.primaryTeal),
//                   ),
//                   const SizedBox(width: 10),
//                   const CircleAvatar(
//                     backgroundColor: AppColors.secondaryTeal,
//                     child: Icon(Icons.notifications_none,
//                         color: AppColors.primaryTeal),
//                   ),
//                   const Spacer(),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: const [
//                       Text("مرحباً م.خديجة!",
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold)),
//                       SizedBox(height: 4),
//                       Text("تحقق من إحصائياتك",
//                           style: TextStyle(
//                               color: AppColors.textseccondary,
//                               fontSize: 13))
//                     ],
//                   )
//                 ],
//               ),
//             ),

//             const SizedBox(height: 25),

//             // Stats
//             Row(
//               children: [
//                 _statCard("المسوّدات", "5"),
//                 _statCard("الاختبارات المنشأة", "13"),
//                 _statCard("الأوراق المصححة", "780"),
//                 _statCard("الطلاب", "340",
//                     color: AppColors.accentYellow),
//               ],
//             ),

//             const SizedBox(height: 25),

//             Expanded(
//               child: Row(
//                 children: [

//                   // Calendar
//                   Container(
//                     width: 260,
//                     decoration: _cardDecoration(),
//                     child: const Center(
//                       child: Text("📅 التقويم"),
//                     ),
//                   ),

//                   const SizedBox(width: 20),

//                   // Chart
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: _cardDecoration(),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("متوسط درجات الطلاب شهرياً",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold)),
//                           const SizedBox(height: 20),
//                           Expanded(
//                             child: CustomPaint(
//                               painter: BarChartPainter(),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 25),

//             Row(
//               children: [
//                 _gaugeCard(
//                     "نسبة اكتمال مراجعة الاوراق المصححة", 0.8),
//                 _gaugeCard(
//                     "نسبة اكتمال نشر النتائج", 0.6,
//                     color: AppColors.accentYellow),
//                 _resultCard(),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   // ================= SIDEBAR =================

//   Widget _buildSidebar() {
//     return Container(
//       width: 250,
//       padding: const EdgeInsets.all(30),
//       decoration: const BoxDecoration(
//         color: AppColors.primaryTeal,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(40),
//           bottomLeft: Radius.circular(40),
//         ),
//       ),
//       child: Column(
//         children: const [
//           SizedBox(height: 30),
//           Icon(Icons.task_alt,
//               color: Colors.white, size: 60),
//           SizedBox(height: 10),
//           Text("Intelligent Grading System",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold)),
//           SizedBox(height: 50),
//           _MenuItem(Icons.dashboard, "لوحة التحكم"),
//           _MenuItem(Icons.assignment, "إدارة الامتحانات"),
//           _MenuItem(Icons.menu_book, "المواد"),
//           _MenuItem(Icons.check_circle, "تصحيح"),
//           _MenuItem(Icons.rate_review, "مراجعة"),
//           _MenuItem(Icons.settings, "اعدادات"),
//         ],
//       ),
//     );
//   }

//   // ================= COMPONENTS =================

//   Widget _statCard(String title, String value,
//       {Color color = AppColors.primaryTeal}) {
//     return Expanded(
//       child: Container(
//         height: 100,
//         margin: const EdgeInsets.symmetric(horizontal: 8),
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(18),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title,
//                 style:
//                     const TextStyle(color: Colors.white, fontSize: 13)),
//             const Spacer(),
//             Text(value,
//                 style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white))
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _gaugeCard(String title, double value,
//       {Color color = AppColors.primaryTeal}) {
//     return Expanded(
//       child: Container(
//         height: 170,
//         margin: const EdgeInsets.all(8),
//         padding: const EdgeInsets.all(20),
//         decoration: _cardDecoration(),
//         child: Column(
//           children: [
//             Expanded(
//               child: CustomPaint(
//                 painter: GaugePainter(value, color),
//               ),
//             ),
//             Text(title,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 12))
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _resultCard() {
//     return Expanded(
//       child: Container(
//         height: 170,
//         margin: const EdgeInsets.all(8),
//         decoration: _cardDecoration(),
//         child: const Center(
//           child: Text("حالة نتائج الطلاب"),
//         ),
//       ),
//     );
//   }

//   BoxDecoration _cardDecoration() => BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 12,
//             offset: Offset(0, 5),
//           )
//         ],
//       );
// }

// // ================= MENU ITEM =================

// class _MenuItem extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   const _MenuItem(this.icon, this.title);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 14),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.white),
//           const SizedBox(width: 15),
//           Text(title,
//               style:
//                   const TextStyle(color: Colors.white, fontSize: 15)),
//         ],
//       ),
//     );
//   }
// }

// // ================= BAR CHART =================

// class BarChartPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = AppColors.primaryTeal
//       ..style = PaintingStyle.fill;

//     double barWidth = size.width / 15;
//     List<double> values = [60, 50, 40, 25, 30, 55, 90, 75, 70, 45, 55, 50];

//     for (int i = 0; i < values.length; i++) {
//       double left = i * (barWidth + 8);
//       double height = (values[i] / 100) * size.height;
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromLTWH(left, size.height - height, barWidth, height),
//           const Radius.circular(6),
//         ),
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// // ================= GAUGE =================

// class GaugePainter extends CustomPainter {
//   final double value;
//   final Color color;
//   GaugePainter(this.value, this.color);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final basePaint = Paint()
//       ..color = Colors.grey.shade200
//       ..strokeWidth = 15
//       ..style = PaintingStyle.stroke;

//     final valuePaint = Paint()
//       ..color = color
//       ..strokeWidth = 15
//       ..strokeCap = StrokeCap.round
//       ..style = PaintingStyle.stroke;

//     final center = Offset(size.width / 2, size.height);
//     final radius = size.width / 2.5;

//     canvas.drawArc(
//         Rect.fromCircle(center: center, radius: radius),
//         pi,
//         pi,
//         false,
//         basePaint);

//     canvas.drawArc(
//         Rect.fromCircle(center: center, radius: radius),
//         pi,
//         pi * value,
//         false,
//         valuePaint);

//     final textPainter = TextPainter(
//       text: TextSpan(
//           text: "${(value * 100).toInt()}%",
//           style: const TextStyle(
//               fontSize: 18, fontWeight: FontWeight.bold)),
//       textDirection: TextDirection.rtl,
//     );

//     textPainter.layout();
//     textPainter.paint(
//         canvas,
//         Offset(size.width / 2 - textPainter.width / 2,
//             size.height - radius - 20));
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
import 'package:flutter/material.dart';
import 'dart:math' as math;

// 1. ألوان التطبيق
class AppColors {
  static const Color primaryTeal = Color(0xFF4FB7B5);
  static const Color secondaryTeal = Color(0xFFDEF6F5);
  static const Color accentYellow = Color(0xFFF6AD55);
  static const Color textprimary = Color(0xFF000000);
  static const Color scaffoldBg = Color(0xFFF3F4F6);
  static const Color textseccondary = Color(0xFF6A7282);
  static const Color textWhite = Colors.white;
}

void main() {
  runApp(const IntelligentGradingApp());
}

class IntelligentGradingApp extends StatelessWidget {
  const IntelligentGradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Cairo'),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: DashboardScreen(),
      ),
    );
  }
}

// تم تحويلها إلى StatefulWidget لكي يعمل التنقل في القائمة الجانبية
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0; // المتغير المسؤول عن تحديد الخيار المختار
  final Map<String, dynamic> studentData = {
    "name": "أحمد محمد السعيد",
    "level": "الصف الثاني الثانوي - علمي",
    "badge": "85",
    "stats": {
      "highest_score": "95%",
      "gpa": "87.5%",
      "exams_count": "12",
      "subjects_count": "6",
    },
    "recent_results": [
      {
        "score": "98%",
        "label": "ممتاز",
        "title": "اختبار منتصف الفصل",
        "subject": "الرياضيات",
        "date": "2024-03-01",
      },
      {
        "score": "85%",
        "label": "جيد جداً",
        "title": "اختبار الوحدة الثانية",
        "subject": "الفيزياء",
        "date": "2024-02-25",
      },
      {
        "score": "85%",
        "label": "جيد جداً",
        "title": "اختبار الوحدة الثانية",
        "subject": "الفيزياء",
        "date": "2024-02-25",
      },
    ],
    "performance": {
      "graded_count": "10/12",
      "progress_value": 0.8,
      "success_rate": "92%",
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Row(
        children: [
          // 1. القائمة الجانبية
          // // CustSidebar(
          //   selectedIndex: selectedIndex,
          //   onItemSelected: (index) {
          //     setState(() {
          //       selectedIndex = index;
          //     });
          //   },
          // ),

          // 2. المحتوى الرئيسي
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                    child: _buildHeader(
                      studentData["name"],
                      studentData["level"],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const TopStatsGrid(),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(flex: 3, child: MonthlyAverageChart()),
                      const SizedBox(width: 20),
                      const Expanded(flex: 1, child: CalendarWidget()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const BottomStatsRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- الهيدر (الترحيب) ---
// --- Widgets الهيدر والإحصائيات (نفس كودك السابق دون تغيير) ---
Widget _buildHeader(String name, String level) {
  return Container(
    height: 101,
    padding: const EdgeInsets.symmetric(horizontal: 24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 2,
          offset: const Offset(0, 1),
          spreadRadius: -1,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "مرحباً ${name.split(' ')[0]}!",
              style: const TextStyle(
                fontFamily: "Arimo",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2939),
              ),
            ),
            const Text(
              "نتمنى لك يوماً دراسياً موفقاً",
              style: TextStyle(
                fontFamily: "Arimo",
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: "Arimo",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1E2939),
                    ),
                  ),
                  Text(
                    level,
                    style: TextStyle(
                      fontFamily: "Arimo",
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF4DB8AC),
                child: Icon(Icons.person, color: Colors.white, size: 24),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _iconButton(IconData icon) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: Icon(icon, color: AppColors.primaryTeal),
  );
}

// --- البطاقات العلوية ---
class TopStatsGrid extends StatelessWidget {
  const TopStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statCard("الطلاب", "340", AppColors.accentYellow, Icons.people),
        _statCard(
          "الأوراق المصححة",
          "780",
          AppColors.primaryTeal,
          Icons.description,
        ),
        _statCard(
          "الاختبارات المنشئة",
          "13",
          AppColors.primaryTeal,
          Icons.quiz,
        ),
        _statCard("المسودات", "5", AppColors.primaryTeal, Icons.edit_note),
      ],
    );
  }

  Widget _statCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            Icon(icon, color: Colors.white54, size: 40),
          ],
        ),
      ),
    );
  }
}

// --- الرسم البياني للأعمدة ---
class MonthlyAverageChart extends StatelessWidget {
  const MonthlyAverageChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "متوسط درجات الطلاب شهرياً",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.accentYellow,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "أفضل 3 أشهر",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textseccondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _bar(40, "يناير"),
                _bar(60, "فبراير"),
                _bar(30, "مارس"),
                _bar(50, "ابريل"),
                _bar(70, "مايو"),
                _bar(90, "يونيو", isSpecial: true),
                _bar(85, "يوليو", isSpecial: true),
                _bar(75, "اغسطس", isSpecial: true),
                _bar(60, "سبتمبر"),
                _bar(55, "اكتوبر"),
                _bar(45, "نوفمبر"),
                _bar(35, "ديسمبر"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar(double heightFactor, String label, {bool isSpecial = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 25,
          height: heightFactor,
          decoration: BoxDecoration(
            color: isSpecial ? AppColors.accentYellow : AppColors.primaryTeal,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textseccondary),
        ),
      ],
    );
  }
}

// --- التقويم ---
class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text("التقويم", style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          const Text(
            "فبراير 2026",
            style: TextStyle(
              color: AppColors.primaryTeal,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 7,
            children: List.generate(28, (index) {
              bool isSelected = (index + 1 == 3);
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryTeal
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// --- الصف السفلي (العدادات) ---
class BottomStatsRow extends StatelessWidget {
  const BottomStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _gaugeCard(
          "نسبة اكتمال مراجعة الأوراق",
          0.8,
          AppColors.primaryTeal,
          "80%",
        ),
        _gaugeCard(
          "نسبة اكتمال نشر النتائج",
          0.6,
          AppColors.accentYellow,
          "60%",
        ),
        _statusCircleCard(),
      ],
    );
  }

  Widget _gaugeCard(String title, double percent, Color color, String text) {
    return Expanded(
      child: Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            CustomPaint(
              size: const Size(120, 60),
              painter: GaugePainter(percent: percent, color: color),
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusCircleCard() {
    return Expanded(
      child: Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Text(
              "حالة نتائج الطلاب",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            const SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: 0.7,
                strokeWidth: 10,
                color: AppColors.primaryTeal,
                backgroundColor: AppColors.accentYellow,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(AppColors.primaryTeal, "نجاح"),
                const SizedBox(width: 15),
                _dot(AppColors.accentYellow, "فشل"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot(Color c, String t) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(t, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final double percent;
  final Color color;
  GaugePainter({required this.percent, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint bgPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    Paint activePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromLTRB(0, 0, size.width, size.height * 2),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );
    canvas.drawArc(
      Rect.fromLTRB(0, 0, size.width, size.height * 2),
      math.pi,
      math.pi * percent,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
  // }

  // // --- القائمة الجانبية (Custom Sidebar) ---
  // class CustSidebar extends StatelessWidget {
  //   final int selectedIndex;
  //   final Function(int) onItemSelected;

  //   const CustSidebar({
  //     super.key,
  //     required this.selectedIndex,
  //     required this.onItemSelected,
  //   });

  //   @override
  //   Widget build(BuildContext context) {
  //     return Container(
  //       width: 280,
  //       height: double.infinity,
  //       decoration: const BoxDecoration(
  //         color: AppColors.primaryTeal,
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(55),
  //           bottomLeft: Radius.circular(55),
  //         ),
  //       ),
  //       child: Column(
  //         children: [
  //           const SizedBox(height: 30),
  //           const Icon(
  //             Icons.check_circle_outline,
  //             size: 70,
  //             color: AppColors.textWhite,
  //           ),
  //           const Text(
  //             "Intelligent\nGrading System",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(color: AppColors.textWhite, fontSize: 16),
  //           ),
  //           const SizedBox(height: 50),
  //           _menuItem("لوحة التحكم", Icons.home_rounded, 0),
  //           _menuItem("المواد", Icons.library_books, 1),
  //           _menuItem("إعدادات", Icons.settings_rounded, 2),
  //           const Spacer(),
  //         ],
  //       ),
  //     );
  //   }

  //   Widget _menuItem(String title, IconData icon, int index) {
  //     bool isActive = selectedIndex == index;
  //     return Padding(
  //       padding: const EdgeInsets.only(bottom: 15),
  //       child: InkWell(
  //         onTap: () => onItemSelected(index),
  //         hoverColor: Colors.transparent,
  //         child: Stack(
  //           clipBehavior: Clip.none,
  //           alignment: Alignment.centerLeft,
  //           children: [
  //             if (isActive)
  //               Positioned(
  //                 left: 0,
  //                 top: -40,
  //                 bottom: -40,
  //                 width: 50,
  //                 child: CustomPaint(
  //                   painter: SidebarCurvePainter(const Color(0xFFDEF6F5)),
  //                 ),
  //               ),
  //             Container(
  //               height: 60,
  //               margin: EdgeInsets.only(left: isActive ? 0 : 25, right: 20),
  //               padding: const EdgeInsets.symmetric(horizontal: 20),
  //               decoration: BoxDecoration(
  //                 color: isActive ? const Color(0xFFDEF6F5) : Colors.transparent,
  //                 borderRadius: BorderRadius.only(
  //                   topRight: const Radius.circular(30),
  //                   bottomRight: const Radius.circular(30),
  //                   topLeft: Radius.circular(isActive ? 0 : 30),
  //                   bottomLeft: Radius.circular(isActive ? 0 : 30),
  //                 ),
  //               ),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Icon(icon, color: AppColors.accentYellow, size: 26),
  //                   const SizedBox(width: 15),

  //                   Text(
  //                     title,
  //                     style: TextStyle(
  //                       fontFamily: "Arimo",
  //                       color: isActive ? AppColors.primaryTeal : Colors.white,
  //                       fontSize: 23,
  //                       fontWeight: FontWeight.w900,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  // }

  // class SidebarCurvePainter extends CustomPainter {
  //   final Color bgColor;
  //   SidebarCurvePainter(this.bgColor);

  //   @override
  //   void paint(Canvas canvas, Size size) {
  //     Paint paint = Paint()
  //       ..color = bgColor
  //       ..style = PaintingStyle.fill;
  //     double radius = 35;
  //     double topY = 40;
  //     double bottomY = topY + 60;
  //     Path pathTop = Path();
  //     pathTop.moveTo(0, topY - radius);
  //     pathTop.quadraticBezierTo(0, topY, radius, topY);
  //     pathTop.lineTo(0, topY);
  //     pathTop.close();
  //     canvas.drawPath(pathTop, paint);
  //     Path pathBottom = Path();
  //     pathBottom.moveTo(0, bottomY + radius);
  //     pathBottom.quadraticBezierTo(0, bottomY, radius, bottomY);
  //     pathBottom.lineTo(0, bottomY);
  //     pathBottom.close();
  //     canvas.drawPath(pathBottom, paint);
  //   }

  //   @override
  //   bool shouldRepaint(CustomPainter oldDelegate) => false;
}
