import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/colors.dart'; 
import 'teacher_matearial.dart';
import 'grading.dart';
import 'exam_page.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  
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
            CustSidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                if (index == _selectedIndex) return;
                setState(() {
                  _selectedIndex = index;
                });

                if (index == 2) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Material1()),
                  );
                } 
                else if (index == 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const FinalExamPage()),
                  );
                }
                else if (index == 3) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const GradingPage()),
                  );
                }
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderWidget(),
                    const SizedBox(height: 24),
                    const TopStatsGrid(),
                    const SizedBox(height: 24),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: MonthlyAverageChart()),
                        SizedBox(width: 20),
                        Expanded(flex: 1, child: CalendarWidget()), // التقويم الأصلي هنا
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
      ),
    );
  }
}

// --- التقويم بتصميمه ومنطقه الأصلي ---
class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // الأيام والبيانات الأصلية كما كانت في كودك تماماً
    final List<String> days = ["27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"];
    final List<String> weekDays = ["ح", "ن", "ث", "ر", "خ", "ج", "س"];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.textprimary.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: Text("التقويم", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textprimary)),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.scaffoldBg, borderRadius: BorderRadius.circular(10)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textseccondary),
                SizedBox(width: 5),
                Text("فبراير 2026", style: TextStyle(fontSize: 13, color: AppColors.textprimary)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDays.map((d) => Expanded(child: Center(child: Text(d, style: const TextStyle(color: AppColors.textseccondary, fontSize: 12))))).toList(),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 5, crossAxisSpacing: 5),
            itemBuilder: (context, index) {
              final day = days[index];
              // المنطق الأصلي لتمييز اليوم الحالي والأيام الرمادية
              bool isToday = day == "3" && index == 7; 
              bool isGrey = index < 5 || index > 32;
              
              return Container(
                decoration: BoxDecoration(
                  color: isToday ? AppColors.primaryTeal : Colors.transparent, 
                  shape: BoxShape.circle
                ),
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday ? AppColors.textWhite : (isGrey ? AppColors.textseccondary.withOpacity(0.3) : AppColors.textprimary),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

// --- باقي الـ Widgets والـ Painter (نفس تصميمك الأصلي) ---

class CustSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustSidebar({super.key, required this.selectedIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: AppColors.primaryTeal,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.check_circle_outline, size: 60, color: AppColors.textWhite),
          const SizedBox(height: 10),
          const Text("Intelligent\nGrading System", textAlign: TextAlign.center, style: TextStyle(color: AppColors.textWhite, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          _menuItem("لوحة التحكم", Icons.dashboard_rounded, 0),
          _menuItem("إدارة الامتحانات", Icons.assignment_rounded, 1),
          _menuItem("المواد", Icons.library_books_rounded, 2),
          _menuItem("تصحيح", Icons.spellcheck_rounded, 3),
          _menuItem("مراجعة", Icons.rate_review_rounded, 4),
          _menuItem("إعدادات", Icons.settings_rounded, 5),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _menuItem(String title, IconData icon, int index) {
    bool isActive = selectedIndex == index;
    return InkWell(
      onTap: () => onItemSelected(index),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          if (isActive) Positioned(left: 0, top: 0, width: 45, child: CustomPaint(painter: SidebarCurvePainter(AppColors.secondaryTeal))),
          Container(
            height: 55,
            margin: EdgeInsets.only(left: isActive ? 0 : 20, right: 15, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: isActive ? AppColors.secondaryTeal : Colors.transparent,
              borderRadius: BorderRadius.only(topRight: const Radius.circular(25), bottomRight: const Radius.circular(25), topLeft: Radius.circular(isActive ? 0 : 25), bottomLeft: Radius.circular(isActive ? 0 : 25)),
            ),
            child: Row(
              children: [
                Icon(icon, color: isActive ? AppColors.primaryTeal : AppColors.accentYellow, size: 22),
                const SizedBox(width: 12),
                Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text(title, style: TextStyle(color: isActive ? AppColors.primaryTeal : AppColors.textWhite, fontSize: 16, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarCurvePainter extends CustomPainter {
  final Color bgColor;
  SidebarCurvePainter(this.bgColor);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = bgColor..style = PaintingStyle.fill;
    double r = 25; double h = 55;
    Path pathTop = Path()..moveTo(0, -r)..quadraticBezierTo(0, 0, r, 0)..lineTo(0, 0)..close();
    canvas.drawPath(pathTop, paint);
    Path pathBottom = Path()..moveTo(0, h + r)..quadraticBezierTo(0, h, r, h)..lineTo(0, h)..close();
    canvas.drawPath(pathBottom, paint);
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

class OpenArcPainter extends CustomPainter {
  final double percent; final Color color; final Color background;
  OpenArcPainter({required this.percent, required this.color, required this.background});
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    canvas.drawArc(rect, math.pi * 1.15, math.pi * 0.7, false, Paint()..color = background..style = PaintingStyle.stroke..strokeWidth = 16..strokeCap = StrokeCap.round);
    canvas.drawArc(rect, math.pi * 1.15, (math.pi * 0.7) * percent, false, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 16..strokeCap = StrokeCap.round);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}