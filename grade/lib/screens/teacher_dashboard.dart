import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/colors.dart'; 
import 'teacher_matearial.dart';
import 'grading.dart';
import 'exam_page.dart';
import '../generated/l10n.dart'; // تأكدي من مسار كلاس S
import 'review_exam_screen.dart';
import 'teacer_setting.dart';
import 'ExamManagementPage.dart';
import 'teacher_profile_settings_page.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    // استخدمنا الترتيب الأصلي (السايد بار أولاً ثم الـ Expanded) لضمان بقائه في اليسار
    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 800;
      bool isTablet = constraints.maxWidth >= 800 && constraints.maxWidth < 1150;

      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.secondaryTeal(context),
        drawer: isMobile
            ? Drawer(
                width: 260,
                backgroundColor: AppColors.primaryTeal(context),
                child: SafeArea(
                  child: CustSidebar(
                    selectedIndex: _selectedIndex,
                    isCompact: false, 
                    onItemSelected: _handleNavigation,
                  ),
                ),
              )
            : null,
        body: Row(
          children: [
            // السايد بار هنا في البداية (يعني في اليسار دائماً)
            if (!isMobile)
              CustSidebar(
                selectedIndex: _selectedIndex,
                isCompact: isTablet, 
                onItemSelected: _handleNavigation,
              ),
            Expanded(
              child: Column(
                children: [
                  if (isMobile) _buildMobileHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeaderWidget(),
                          const SizedBox(height: 24),
                          TopStatsGrid(isMobile: isMobile, isTablet: isTablet),
                          const SizedBox(height: 24),
                          _buildResponsiveCharts(isMobile, isTablet),
                          const SizedBox(height: 24),
                          _buildResponsiveBottomStats(isMobile),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMobileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            const Spacer(),
            Text(S.of(context).dashboard_title, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal(context))),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);

    if (index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Material1()));
    } else if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ExamManagementPage()));
    } else if (index == 3) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GradingPage()));
    }
    else if (index == 4) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ReviewExamPage()));
    }
    else if (index == 5) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
    }
  }

  Widget _buildResponsiveCharts(bool isMobile, bool isTablet) {
    if (isMobile) {
      return Column(children: [const MonthlyAverageChart(), const SizedBox(height: 24), CalendarWidget(isMobile: isMobile)]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(flex: 3, child: MonthlyAverageChart()),
        const SizedBox(width: 20),
        Expanded(flex: 1, child: CalendarWidget(isMobile: isMobile)), 
      ],
    );
  }

  Widget _buildResponsiveBottomStats(bool isMobile) {
    if (isMobile) {
      return Column(children: [
        StatusCircleCard(isMobile: isMobile),
        const SizedBox(height: 16),
        GaugeCardWidget(title: S.of(context).papers_review_completion_rate_mobile, percent: 0.8, text: "80%", colorKey: 1, isMobile: isMobile),
        const SizedBox(height: 16),
        GaugeCardWidget(title: S.of(context).results_publishing_completion_rate_mobile, percent: 0.6, text: "60%", colorKey: 2, isMobile: isMobile),
      ]);
    }
    return const BottomStatsRow();
  }
}




class CustSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool isCompact;

  const CustSidebar({super.key, required this.selectedIndex, required this.onItemSelected, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isCompact ? 90 : 260,
      decoration: BoxDecoration(
        color: AppColors.primaryTeal(context),
        borderRadius: BorderRadius.only(
          // في العربي التقوس يسار، وفي الإنجليزي التقوس يمين (يواجه المحتوى دائماً)
          topLeft: Radius.circular(isRtl ? 40 : 0), 
          bottomLeft: Radius.circular(isRtl ? 40 : 0),
          topRight: Radius.circular(isRtl ? 0 : 40),
          bottomRight: Radius.circular(isRtl ? 0 : 40),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Image.asset(
            'assets/emaige/logo.PNG',
            height: isCompact ? 70 : 110,
            width: isCompact ? 70 : 110,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),
          _menuItem(context, S.of(context).dashboard_title, Icons.dashboard_rounded, 0),
          _menuItem(context, S.of(context).exam_management, Icons.assignment_rounded, 1),
          _menuItem(context, S.of(context).materials, Icons.library_books_rounded, 2),
          _menuItem(context, S.of(context).correction, Icons.spellcheck_rounded, 3),
          _menuItem(context, S.of(context).review, Icons.rate_review_rounded, 4),
          _menuItem(context, S.of(context).settings, Icons.settings_rounded, 5),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _menuItem(BuildContext context, String title, IconData icon, int index) {
    bool isActive = selectedIndex == index;
    bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return InkWell(
      onTap: () => onItemSelected(index),
      child: Stack(
        clipBehavior: Clip.none,
        // في العربي يحاذي لليسار، وفي الإنجليزي لليمين
        alignment: isRtl ? Alignment.centerLeft : Alignment.centerRight,
        children: [
          if (isActive && !isCompact) 
            Positioned(
              // المنحنى يمين أو يسار حسب اللغة
              left: isRtl ? 0 : null, 
              right: isRtl ? null : 0, 
              top: 0, 
              width: 45, 
              child: CustomPaint(painter: SidebarCurvePainter(AppColors.secondaryTeal(context), isRtl))
            ),
          Container(
            height: 55,
            margin: EdgeInsets.only(
              // ضبط المسافات الأصلية بطريقة ذكية تعكس نفسها
              left: isRtl ? (isCompact ? 10 : (isActive ? 0 : 20)) : 15, 
              right: isRtl ? 15 : (isCompact ? 10 : (isActive ? 0 : 20)), 
              bottom: 8
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: isActive ? AppColors.secondaryTeal(context) : Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isRtl ? (isActive && !isCompact ? 0 : 25) : 25), 
                bottomLeft: Radius.circular(isRtl ? (isActive && !isCompact ? 0 : 25) : 25),
                topRight: Radius.circular(isRtl ? 25 : (isActive && !isCompact ? 0 : 25)), 
                bottomRight: Radius.circular(isRtl ? 25 : (isActive && !isCompact ? 0 : 25))
              ),
            ),
            child: Row(
              mainAxisAlignment: isCompact ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Icon(icon, color: isActive ? AppColors.primaryTeal(context) : AppColors.accentYellow(context), size: 22),
                if (!isCompact) ...[
                  const SizedBox(width: 12),
                  Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text(title, style: TextStyle(color: isActive ? AppColors.primaryTeal(context) : Colors.white, fontSize: 16, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)))),
                ]
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
  final bool isRtl;
  SidebarCurvePainter(this.bgColor, this.isRtl);
  
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = bgColor..style = PaintingStyle.fill;
    double r = 25; double h = 55;
    Path pathTop = Path();
    Path pathBottom = Path();

    if (isRtl) {
      // الرسم لكودك الأصلي تماماً (للعربي)
      pathTop..moveTo(0, -r)..quadraticBezierTo(0, 0, r, 0)..lineTo(0, 0)..close();
      pathBottom..moveTo(0, h + r)..quadraticBezierTo(0, h, r, h)..lineTo(0, h)..close();
    } else {
      // الرسم المعكوس (للإنجليزي)
      pathTop..moveTo(size.width, -r)..quadraticBezierTo(size.width, 0, size.width - r, 0)..lineTo(size.width, 0)..close();
      pathBottom..moveTo(size.width, h + r)..quadraticBezierTo(size.width, h, size.width - r, h)..lineTo(size.width, h)..close();
    }

    canvas.drawPath(pathTop, paint);
    canvas.drawPath(pathBottom, paint);
  }
  @override bool shouldRepaint(CustomPainter oldDelegate) => false;
}
/* =========================================================
   باقي مكونات الصفحة (Stats, Header, Charts)
========================================================= */

class TopStatsGrid extends StatelessWidget {
  final bool isMobile, isTablet;
  const TopStatsGrid({super.key, required this.isMobile, required this.isTablet});
  @override
  Widget build(BuildContext context) {
    if (isMobile || isTablet) {
      double cardWidth = 220; 
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(children: [
          _statCardFixed(context, S.of(context).students, "340", AppColors.accentYellow(context), Icons.people, cardWidth),
          _statCardFixed(context, S.of(context).corrected_papers, "780", AppColors.primaryTeal(context), Icons.description, cardWidth),
          _statCardFixed(context, S.of(context).created_exams, "13", AppColors.primaryTeal(context), Icons.create, cardWidth),
          _statCardFixed(context, S.of(context).drafts, "5", AppColors.primaryTeal(context), Icons.edit_note, cardWidth),
        ]),
      );
    }
    return Row(children: [
      _statCardExpanded(context, S.of(context).students, "340", AppColors.accentYellow(context), Icons.people),
      _statCardExpanded(context, S.of(context).corrected_papers, "780", AppColors.primaryTeal(context), Icons.description),
      _statCardExpanded(context, S.of(context).created_exams, "13", AppColors.primaryTeal(context), Icons.create),
      _statCardExpanded(context, S.of(context).drafts, "5", AppColors.primaryTeal(context), Icons.edit_note),
    ]);
  }
  Widget _statCardFixed(context, t, v, c, i, w) => Container(width: w, margin: const EdgeInsets.only(left: 16), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(15)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(v, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)), Text(t, style: const TextStyle(color: Colors.white70, fontSize: 14))]), Icon(i, color: Colors.white54, size: 40)]));
  Widget _statCardExpanded(context, t, v, c, i) => Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 8), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(15)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(v, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)), Text(t, style: const TextStyle(color: Colors.white70, fontSize: 14))]), Icon(i, color: Colors.white54, size: 40)])));
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(S.of(context).welcome_engineer, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))), const SizedBox(height: 4), Text(S.of(context).check_your_stats, style: TextStyle(color: AppColors.textSecondary(context)))]),
Row(
  children: [
    // أيقونة التنبيهات
    MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // هنا يمكنك إضافة أكشن التنبيهات لاحقاً
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.secondaryTeal(context),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.notifications_none, color: AppColors.primaryTeal(context)),
        ),
      ),
    ),
    
    const SizedBox(width: 10),
    
    // رمز البروفايل (الذي ينقل لصفحة الإعدادات)
    MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileSettingsPage()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.secondaryTeal(context),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person_outline, color: AppColors.primaryTeal(context)),
        ),
      ),
    ),
  ],
)      ]),
    );
  }
}

class MonthlyAverageChart extends StatelessWidget {
  const MonthlyAverageChart({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> chartData = [
      {"label": S.of(context).december, "value": 0.45, "special": false}, {"label": S.of(context).november, "value": 0.53, "special": false},
      {"label": S.of(context).october, "value": 0.45, "special": false}, {"label": S.of(context).september, "value": 0.72, "special": true}, 
      {"label": S.of(context).august, "value": 0.82, "special": true}, {"label": S.of(context).july, "value": 0.95, "special": true}, 
      {"label": S.of(context).june, "value": 0.55, "special": false}, {"label": S.of(context).may, "value": 0.28, "special": false},
      {"label": S.of(context).april, "value": 0.20, "special": false}, {"label": S.of(context).march, "value": 0.35, "special": false},
      {"label": S.of(context).february, "value": 0.45, "special": false}, {"label": S.of(context).january, "value": 0.65, "special": false},
    ];
    return Container(
      height: 300, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: AppColors.textPrimary(context).withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))]),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(S.of(context).students_average_grades_monthly, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary(context))), Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.accentYellow(context), shape: BoxShape.circle)), const SizedBox(width: 5), Text(S.of(context).top_3_months, style: TextStyle(fontSize: 11, color: AppColors.accentYellow(context)))] )]),
        const SizedBox(height: 30),
        Expanded(child: Row(children: [
          Expanded(child: LayoutBuilder(builder: (context, constraints) => Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.end, children: chartData.map((data) => Column(mainAxisAlignment: MainAxisAlignment.end, children: [Container(width: 15, height: (constraints.maxHeight - 30) * data['value'], decoration: BoxDecoration(color: data['special'] ? AppColors.accentYellow(context) : AppColors.primaryTeal(context), borderRadius: BorderRadius.circular(4))), const SizedBox(height: 8), Text(data['label'], style: TextStyle(fontSize: 8, color: AppColors.textSecondary(context)))])).toList()))),
          const SizedBox(width: 10),
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: ["100%", "80%", "60%", "40%", "20%", "0%"].map((l) => Text(l, style: TextStyle(fontSize: 9, color: AppColors.textSecondary(context)))).toList()),
        ])),
      ]),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  final bool isMobile;
  const CalendarWidget({super.key, this.isMobile = false}); 
  @override
  Widget build(BuildContext context) {
    final List<String> days = ["27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"];
    final List<String> weekDays = [S.of(context).sunday, S.of(context).monday, S.of(context).tuesday, S.of(context).wednesday, S.of(context).thursday, S.of(context).friday, S.of(context).saturday];
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: AppColors.textPrimary(context).withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))]),
      child: Column(children: [
        Align(alignment: Alignment.centerRight, child: Text(S.of(context).calendar, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isMobile ? 15 : 18, color: AppColors.textPrimary(context)))),
        const SizedBox(height: 15),
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(10)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textSecondary(context)), const SizedBox(width: 5), Text(S.of(context).february_2026, style: TextStyle(fontSize: 13, color: AppColors.textSecondary(context)))] )),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: weekDays.map((d) => Expanded(child: Center(child: Text(d, style: TextStyle(color: AppColors.textSecondary(context), fontSize: isMobile ? 10 : 12))))).toList()),
        const SizedBox(height: 10),
        GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: days.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 5, crossAxisSpacing: 5), itemBuilder: (context, index) {
          final day = days[index]; bool isToday = day == "3" && index == 7; bool isGrey = index < 5 || index > 32;
          return Container(decoration: BoxDecoration(color: isToday ? AppColors.primaryTeal(context) : Colors.transparent, shape: BoxShape.circle), child: Center(child: Text(day, style: TextStyle(fontSize: isMobile ? 10 : 12, fontWeight: isToday ? FontWeight.bold : FontWeight.normal, color: isToday ? Colors.white : (isGrey ? AppColors.textSecondary(context).withValues(alpha: 0.3) : AppColors.textPrimary(context))))));
        })
      ]),
    );
  }
}

class BottomStatsRow extends StatelessWidget {
  const BottomStatsRow({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Expanded(child: StatusCircleCard(isMobile: false)),
      const SizedBox(width: 16),
      Expanded(child: GaugeCardWidget(title: S.of(context).papers_review_completion_rate, percent: 0.8, text: "80%", colorKey: 1, isMobile: false)), 
      const SizedBox(width: 16),
      Expanded(child: GaugeCardWidget(title: S.of(context).results_publishing_completion_rate, percent: 0.6, text: "60%", colorKey: 2, isMobile: false))
    ]);
  }
}

class StatusCircleCard extends StatelessWidget {
  final bool isMobile;
  const StatusCircleCard({super.key, required this.isMobile});
  @override
  Widget build(BuildContext context) => Container(width: isMobile ? double.infinity : null, height: 190, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(children: [Text(S.of(context).students_results_status, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), const Spacer(), SizedBox(width: 85, height: 85, child: CircularProgressIndicator(value: 0.7, strokeWidth: 10, color: AppColors.primaryTeal(context), backgroundColor: AppColors.accentYellow(context))), const Spacer(), Row(mainAxisAlignment: MainAxisAlignment.center, children: [Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.primaryTeal(context), shape: BoxShape.circle)), const SizedBox(width: 6), Text(S.of(context).pass, style: const TextStyle(fontSize: 11))]), const SizedBox(width: 18), Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.accentYellow(context), shape: BoxShape.circle)), const SizedBox(width: 6), Text(S.of(context).fail, style: const TextStyle(fontSize: 11))])])]));
}

class GaugeCardWidget extends StatelessWidget {
  final String title, text; final double percent; final int colorKey; final bool isMobile;
  const GaugeCardWidget({required this.title, required this.percent, required this.text, required this.colorKey, required this.isMobile, super.key});
  @override
  Widget build(BuildContext context) {
    Color c = colorKey == 1 ? AppColors.primaryTeal(context) : AppColors.accentYellow(context);
    return Container(width: isMobile ? double.infinity : null, height: 190, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(children: [Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), const Spacer(), CustomPaint(size: const Size(130, 65), painter: OpenArcPainter(percent: percent, color: c, background: AppColors.scaffoldBg(context)), child: SizedBox(width: 130, height: 65, child: Center(child: Text(text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))))), const Spacer()]));
  }
}

class OpenArcPainter extends CustomPainter {
  final double percent; final Color color, background;
  OpenArcPainter({required this.percent, required this.color, required this.background});
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    canvas.drawArc(rect, math.pi * 1.15, math.pi * 0.7, false, Paint()..color = background..style = PaintingStyle.stroke..strokeWidth = 16..strokeCap = StrokeCap.round);
    canvas.drawArc(rect, math.pi * 1.15, (math.pi * 0.7) * percent, false, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 16..strokeCap = StrokeCap.round);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}