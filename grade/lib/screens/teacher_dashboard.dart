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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.secondaryTeal,
        body: Row(
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
  @override bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("مرحباً م.خديجة!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textprimary)),
              SizedBox(height: 4),
              Text("تحقق من إحصائياتك", style: TextStyle(color: AppColors.textseccondary)),
            ],
          ),
          Row(children: [_iconButton(Icons.notifications_none), const SizedBox(width: 10), _iconButton(Icons.person_outline)])
        ],
      ),
    );
  }
  Widget _iconButton(IconData icon) => Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: AppColors.secondaryTeal, shape: BoxShape.circle), child: Icon(icon, color: AppColors.primaryTeal));
}

class TopStatsGrid extends StatelessWidget {
  const TopStatsGrid({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statCard("الطلاب", "340", AppColors.accentYellow, Icons.people),
        _statCard("الأوراق المصححة", "780", AppColors.primaryTeal, Icons.description),
        _statCard("الاختبارات المنشئة", "13", AppColors.primaryTeal, Icons.create),
        _statCard("المسودات", "5", AppColors.primaryTeal, Icons.edit_note),
      ],
    );
  }
  Widget _statCard(String title, String value, Color color, IconData icon) => Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 8), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: const TextStyle(color: AppColors.textWhite, fontSize: 24, fontWeight: FontWeight.bold)), Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14))]), Icon(icon, color: Colors.white54, size: 40)])));
}

class MonthlyAverageChart extends StatelessWidget {
  const MonthlyAverageChart({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> chartData = [
      {"label": "ديسمبر", "value": 0.45, "special": false}, {"label": "نوفمبر", "value": 0.53, "special": false},
      {"label": "أكتوبر", "value": 0.45, "special": false}, {"label": "سبتمبر", "value": 0.72, "special": true}, 
      {"label": "أغسطس", "value": 0.82, "special": true}, {"label": "يوليو", "value": 0.95, "special": true}, 
      {"label": "يونيو", "value": 0.55, "special": false}, {"label": "مايو", "value": 0.28, "special": false},
      {"label": "أبريل", "value": 0.20, "special": false}, {"label": "مارس", "value": 0.35, "special": false},
      {"label": "فبراير", "value": 0.45, "special": false}, {"label": "يناير", "value": 0.65, "special": false},
    ];
    return Container(
      height: 300, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: AppColors.textprimary.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))]),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("متوسط درجات الطلاب شهرياً", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textprimary)),
          Row(children: [Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.accentYellow, shape: BoxShape.circle)), const SizedBox(width: 5), const Text("أفضل 3 أشهر", style: TextStyle(fontSize: 11, color: AppColors.accentYellow))]),
        ]),
        const SizedBox(height: 30),
        Expanded(child: Row(children: [
          Expanded(child: LayoutBuilder(builder: (context, constraints) => Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.end, children: chartData.map((data) => _bar(constraints.maxHeight, data['value'], data['label'], isSpecial: data['special'])).toList()))),
          const SizedBox(width: 10),
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: ["100%", "80%", "60%", "40%", "20%", "0%"].map((l) => Text(l, style: const TextStyle(fontSize: 9, color: AppColors.textseccondary))).toList()),
        ])),
      ]),
    );
  }
  Widget _bar(double h, double v, String l, {bool isSpecial = false}) => Column(mainAxisAlignment: MainAxisAlignment.end, children: [Container(width: 18, height: (h - 30) * v, decoration: BoxDecoration(color: isSpecial ? AppColors.accentYellow : AppColors.primaryTeal, borderRadius: BorderRadius.circular(4))), const SizedBox(height: 8), Text(l, style: const TextStyle(fontSize: 8, color: AppColors.textseccondary))]);
}

class BottomStatsRow extends StatelessWidget {
  const BottomStatsRow({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(children: [_statusCircleCard(), _gaugeCard("نسبة اكتمال مراجعة الأوراق المصححة", 0.8, AppColors.primaryTeal, "80%"), _gaugeCard("نسبة اكتمال نشر النتائج", 0.6, AppColors.accentYellow, "60%")]);
  }
  Widget _statusCircleCard() => Expanded(child: Container(height: 190, margin: const EdgeInsets.symmetric(horizontal: 8), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(children: [const Text("حالة نتائج الطلاب", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), const Spacer(), const SizedBox(width: 85, height: 85, child: CircularProgressIndicator(value: 0.7, strokeWidth: 10, color: AppColors.primaryTeal, backgroundColor: AppColors.accentYellow)), const Spacer(), Row(mainAxisAlignment: MainAxisAlignment.center, children: [_dot(AppColors.primaryTeal, "نجاح"), const SizedBox(width: 18), _dot(AppColors.accentYellow, "فشل")])])));
  Widget _gaugeCard(String title, double percent, Color color, String text) => Expanded(child: Container(height: 190, margin: const EdgeInsets.symmetric(horizontal: 8), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(children: [Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), const Spacer(), CustomPaint(size: const Size(130, 65), painter: OpenArcPainter(percent: percent, color: color, background: AppColors.scaffoldBg), child: SizedBox(width: 130, height: 65, child: Center(child: Text(text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))))), const Spacer()])));
  Widget _dot(Color c, String t) => Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle)), const SizedBox(width: 6), Text(t, style: const TextStyle(fontSize: 11))]);
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