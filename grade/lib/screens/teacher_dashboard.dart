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

// ملف الألوان الذي زودتني به مع بعض الإضافات للتوافق
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
      theme: ThemeData(fontFamily: 'Cairo'), // يفضل استخدام خط Cairo للغة العربية
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: DashboardScreen(),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Row(
        children: [
          // 1. القائمة الجانبية (Sidebar)
          const SidebarWidget(),

          // 2. المحتوى الرئيسي (Main Content)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Header
                  const HeaderWidget(),
                  const SizedBox(height: 24),

                  // الإحصائيات العلوية (Cards)
                  const TopStatsGrid(),
                  const SizedBox(height: 24),

                  // الصف الأوسط (التقويم والرسم البياني)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(flex: 3, child: MonthlyAverageChart()),
                      const SizedBox(width: 20),
                      const Expanded(flex: 1, child: CalendarWidget()),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // الصف السفلي (العدادات الدائرية وحالة النتائج)
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

// --- مكونات القائمة الجانبية ---
class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: AppColors.primaryTeal,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const CircleAvatar(
            backgroundColor: Colors.white24,
            radius: 40,
            child: Icon(Icons.grading, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 10),
          const Text(
            "Intelligent Grading System",
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          _sidebarItem(Icons.dashboard, "لوحة التحكم", active: true),
          _sidebarItem(Icons.assignment, "إدارة الامتحانات"),
          _sidebarItem(Icons.book, "المواد"),
          _sidebarItem(Icons.check_circle_outline, "تصحيح"),
          _sidebarItem(Icons.rate_review, "مراجعة"),
          _sidebarItem(Icons.settings, "إعدادات"),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String title, {bool active = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        color: active ? Colors.white.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

// --- الهيدر (الترحيب) ---
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("مرحباً م.خديجة!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("تحقق من إحصائياتك", style: TextStyle(color: AppColors.textseccondary)),
          ],
        ),
        Row(
          children: [
            _iconButton(Icons.notifications_none),
            const SizedBox(width: 10),
            _iconButton(Icons.person_outline),
          ],
        )
      ],
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Icon(icon, color: AppColors.primaryTeal),
    );
  }
}

// --- البطاقات العلوية ---
class TopStatsGrid extends StatelessWidget {
  const TopStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statCard("الطلاب", "340", AppColors.accentYellow, Icons.people),
        _statCard("الأوراق المصححة", "780", AppColors.primaryTeal, Icons.description),
        _statCard("الاختبارات المنشئة", "13", AppColors.primaryTeal, Icons.quiz),
        _statCard("المسودات", "5", AppColors.primaryTeal, Icons.edit_note),
      ],
    );
  }

  Widget _statCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("متوسط درجات الطلاب شهرياً", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.accentYellow, shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  const Text("أفضل 3 أشهر", style: TextStyle(fontSize: 12, color: AppColors.textseccondary)),
                ],
              )
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _bar(40, "يناير"), _bar(60, "فبراير"), _bar(30, "مارس"),
                _bar(50, "ابريل"), _bar(70, "مايو"), _bar(90, "يونيو", isSpecial: true),
                _bar(85, "يوليو", isSpecial: true), _bar(75, "اغسطس", isSpecial: true),
                _bar(60, "سبتمبر"), _bar(55, "اكتوبر"), _bar(45, "نوفمبر"), _bar(35, "ديسمبر"),
              ],
            ),
          )
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
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textseccondary)),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          const Text("التقويم", style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          const Text("فبراير 2026", style: TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 7,
            children: List.generate(28, (index) => Center(
                child: Text("${index + 1}", style: TextStyle(fontSize: 12, color: (index + 1 == 3) ? Colors.white : Colors.black))),
            ).map((e) => Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: (e.child as Text).data == "3" ? AppColors.primaryTeal : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: e,
            )).toList(),
          )
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
        _gaugeCard("نسبة اكتمال مراجعة الأوراق", 0.8, AppColors.primaryTeal, "80%"),
        _gaugeCard("نسبة اكتمال نشر النتائج", 0.6, AppColors.accentYellow, "60%"),
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
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const Spacer(),
            CustomPaint(
              size: const Size(120, 60),
              painter: GaugePainter(percent: percent, color: color),
              child: Center(child: Padding(
                padding: const EdgeInsets.only(top: .0),
                child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              )),
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
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            const Text("حالة نتائج الطلاب", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80, height: 80,
                  child: CircularProgressIndicator(value: 0.7, strokeWidth: 10, color: AppColors.primaryTeal, backgroundColor: AppColors.accentYellow),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(AppColors.primaryTeal, "نجاح"),
                const SizedBox(width: 15),
                _dot(AppColors.accentYellow, "فشل"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _dot(Color c, String t) {
    return Row(children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
      const SizedBox(width: 5),
      Text(t, style: const TextStyle(fontSize: 10)),
    ]);
  }
}

// رسام مخصص للعدادات النصف دائرية
class GaugePainter extends CustomPainter {
  final double percent;
  final Color color;
  GaugePainter({required this.percent, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint bgPaint = Paint()..color = Colors.grey.shade200..style = PaintingStyle.stroke..strokeWidth = 12..strokeCap = StrokeCap.round;
    Paint activePaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 12..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromLTRB(0, 0, size.width, size.height * 2), math.pi, math.pi, false, bgPaint);
    canvas.drawArc(Rect.fromLTRB(0, 0, size.width, size.height * 2), math.pi, math.pi * percent, false, activePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}