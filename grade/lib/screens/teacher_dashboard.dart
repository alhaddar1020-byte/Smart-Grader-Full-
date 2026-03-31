
// import 'package:flutter/material.dart';
// import 'dart:math' as math;
// import '../core/colors.dart';
// import 'teacher_matearial.dart';
// import 'grading.dart';
// import 'exam_page.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   int _selectedIndex = 0;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: LayoutBuilder(builder: (context, constraints) {
//         // تحديد حالة الشاشة: جوال (أقل من 800) أو تابلت/لاب توب
//         bool isMobile = constraints.maxWidth < 800;
//         bool isTablet = constraints.maxWidth >= 800 && constraints.maxWidth < 1100;

//         return Scaffold(
//           key: _scaffoldKey,
//           backgroundColor: AppColors.scaffoldBg(context),
//           // القائمة الجانبية للجوال (Drawer)
//           drawer: isMobile
//               ? Drawer(
//                   width: 260,
//                   backgroundColor: AppColors.primaryTeal(context),
//                   child: CustSidebar(
//                     selectedIndex: _selectedIndex,
//                     isCompact: false, // دائماً كامل في الجوال
//                     onItemSelected: _handleNavigation,
//                   ),
//                 )
//               : null,
//           body: Row(
//             children: [
//               // القائمة الجانبية الثابتة (لاب توب وتابلت)
//               if (!isMobile)
//                 CustSidebar(
//                   selectedIndex: _selectedIndex,
//                   isCompact: isTablet, // يتقلص حجمه في التابلت
//                   onItemSelected: _handleNavigation,
//                 ),
//               Expanded(
//                 child: Column(
//                   children: [
//                     if (isMobile) _buildMobileHeader(),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         padding: const EdgeInsets.all(24.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const HeaderWidget(),
//                             const SizedBox(height: 24),
//                             _buildResponsiveTopStats(isMobile),
//                             const SizedBox(height: 24),
//                             _buildResponsiveCharts(isMobile),
//                             const SizedBox(height: 24),
//                             _buildResponsiveBottomStats(isMobile),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   // --- دوال الاستجابة (Responsiveness) لضمان عدم تغير تصميم اللاب توب ---

//   Widget _buildMobileHeader() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       color: Colors.white,
//       child: SafeArea(
//         bottom: false,
//         child: Row(
//           children: [
//             IconButton(
//               icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)),
//               onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//             ),
//             const Spacer(),
//             Text("لوحة التحكم", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal(context))),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildResponsiveTopStats(bool isMobile) {
//     if (isMobile) {
//       return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: [
//             _statCardFixed("الطلاب", "340", AppColors.accentYellow(context), Icons.people),
//             _statCardFixed("الأوراق", "780", AppColors.primaryTeal(context), Icons.description),
//             _statCardFixed("الاختبارات", "13", AppColors.primaryTeal(context), Icons.create),
//             _statCardFixed("المسودات", "5", AppColors.primaryTeal(context), Icons.edit_note),
//           ],
//         ),
//       );
//     }
//     return const TopStatsGrid();
//   }

//   Widget _buildResponsiveCharts(bool isMobile) {
//     if (isMobile) {
//       return const Column(children: [MonthlyAverageChart(), SizedBox(height: 20), CalendarWidget()]);
//     }
//     return const Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(flex: 3, child: MonthlyAverageChart()),
//         SizedBox(width: 20),
//         Expanded(flex: 1, child: CalendarWidget()),
//       ],
//     );
//   }

//   Widget _buildResponsiveBottomStats(bool isMobile) {
//     if (isMobile) {
//       return const Column(
//         children: [
//           StatusCircleCard(),
//           SizedBox(height: 16),
//           GaugeCard(title: "مراجعة الأوراق", percent: 0.8, text: "80%"),
//           SizedBox(height: 16),
//           GaugeCard(title: "نشر النتائج", percent: 0.6, text: "60%"),
//         ],
//       );
//     }
//     return const BottomStatsRow();
//   }

//   void _handleNavigation(int index) {
//     if (index == _selectedIndex) return;
//     setState(() => _selectedIndex = index);
//     if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);

//     if (index == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Material1()));
//     if (index == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FinalExamPage()));
//     if (index == 3) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GradingPage()));
//   }

//   Widget _statCardFixed(String title, String value, Color color, IconData icon) {
//     return Container(
//       width: 170, margin: const EdgeInsets.only(left: 12), padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
//             Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11)),
//           ]),
//           Icon(icon, color: Colors.white54, size: 24),
//         ],
//       ),
//     );
//   }
// }

// // =========================================================
// // السايد بار (CustSidebar) - مدمج في نفس الملف
// // =========================================================
// class CustSidebar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemSelected;
//   final bool isCompact;

//   const CustSidebar({
//     super.key,
//     required this.selectedIndex,
//     required this.onItemSelected,
//     required this.isCompact,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       width: isCompact ? 85 : 260,
//       decoration: BoxDecoration(
//         color: AppColors.primaryTeal(context),
//         borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
//       ),
//       child: Column(
//         children: [
//           const SizedBox(height: 40),
//           Icon(Icons.check_circle_outline, size: isCompact ? 40 : 60, color: Colors.white),
//           if (!isCompact) ...[
//             const SizedBox(height: 10),
//             const Text("Intelligent\nGrading System", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
//           ],
//           const SizedBox(height: 40),
//           _menuItem(context, "لوحة التحكم", Icons.dashboard_rounded, 0),
//           _menuItem(context, "إدارة الامتحانات", Icons.assignment_rounded, 1),
//           _menuItem(context, "المواد", Icons.library_books_rounded, 2),
//           _menuItem(context, "تصحيح", Icons.spellcheck_rounded, 3),
//           _menuItem(context, "مراجعة", Icons.rate_review_rounded, 4),
//           _menuItem(context, "إعدادات", Icons.settings_rounded, 5),
//         ],
//       ),
//     );
//   }

//   Widget _menuItem(BuildContext context, String title, IconData icon, int index) {
//     bool isActive = selectedIndex == index;
//     return InkWell(
//       onTap: () => onItemSelected(index),
//       child: Stack(
//         alignment: Alignment.centerLeft,
//         children: [
//           if (isActive && !isCompact)
//             Positioned(left: 0, top: 0, width: 45, child: CustomPaint(painter: SidebarCurvePainter(AppColors.secondaryTeal(context)))),
//           Container(
//             height: 55,
//             margin: EdgeInsets.only(left: isCompact ? 10 : (isActive ? 0 : 20), right: isCompact ? 10 : 15, bottom: 8),
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             decoration: BoxDecoration(
//               color: isActive ? AppColors.secondaryTeal(context) : Colors.transparent,
//               borderRadius: BorderRadius.only(
//                 topRight: const Radius.circular(25), bottomRight: const Radius.circular(25),
//                 topLeft: Radius.circular(isActive && !isCompact ? 0 : 25), bottomLeft: Radius.circular(isActive && !isCompact ? 0 : 25),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: isCompact ? MainAxisAlignment.center : MainAxisAlignment.start,
//               children: [
//                 Icon(icon, color: isActive ? AppColors.primaryTeal(context) : AppColors.accentYellow(context), size: 22),
//                 if (!isCompact) ...[
//                   const SizedBox(width: 12),
//                   Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text(title, style: TextStyle(color: isActive ? AppColors.primaryTeal(context) : Colors.white, fontSize: 16, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)))),
//                 ]
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // رسام الانحناء
// class SidebarCurvePainter extends CustomPainter {
//   final Color bgColor;
//   SidebarCurvePainter(this.bgColor);
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()..color = bgColor..style = PaintingStyle.fill;
//     double r = 25; double h = 55;
//     Path pathTop = Path()..moveTo(0, -r)..quadraticBezierTo(0, 0, r, 0)..lineTo(0, 0)..close();
//     canvas.drawPath(pathTop, paint);
//     Path pathBottom = Path()..moveTo(0, h + r)..quadraticBezierTo(0, h, r, h)..lineTo(0, h)..close();
//     canvas.drawPath(pathBottom, paint);
//   }
//   @override bool shouldRepaint(CustomPainter oldDelegate) => false;
// }

// // =========================================================
// // الوجات الأصلية (Widgets) - محتواك الأصلي تماماً
// // =========================================================

// class HeaderWidget extends StatelessWidget {
//   const HeaderWidget({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text("مرحباً م.خديجة!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
//             const SizedBox(height: 4),
//             Text("تحقق من إحصائياتك", style: TextStyle(color: AppColors.textSecondary(context))),
//           ]),
//           Row(children: [
//             _iconButton(context, Icons.notifications_none),
//             const SizedBox(width: 10),
//             _iconButton(context, Icons.person_outline)
//           ])
//         ],
//       ),
//     );
//   }
//   Widget _iconButton(BuildContext context, IconData icon) => Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle), child: Icon(icon, color: AppColors.primaryTeal(context)));
// }

// class TopStatsGrid extends StatelessWidget {
//   const TopStatsGrid({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         _statCard(context, "الطلاب", "340", AppColors.accentYellow(context), Icons.people),
//         _statCard(context, "الأوراق المصححة", "780", AppColors.primaryTeal(context), Icons.description),
//         _statCard(context, "الاختبارات المنشئة", "13", AppColors.primaryTeal(context), Icons.create),
//         _statCard(context, "المسودات", "5", AppColors.primaryTeal(context), Icons.edit_note),
//       ],
//     );
//   }
//   Widget _statCard(BuildContext context, String title, String value, Color color, IconData icon) => Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 8), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)), Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14))]), Icon(icon, color: Colors.white54, size: 40)])));
// }

// class MonthlyAverageChart extends StatelessWidget {
//   const MonthlyAverageChart({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> chartData = [
//       {"label": "ديسمبر", "value": 0.45, "special": false}, {"label": "نوفمبر", "value": 0.53, "special": false},
//       {"label": "أكتوبر", "value": 0.45, "special": false}, {"label": "سبتمبر", "value": 0.72, "special": true}, 
//       {"label": "أغسطس", "value": 0.82, "special": true}, {"label": "يوليو", "value": 0.95, "special": true}, 
//     ];
//     return Container(
//       height: 300, padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: AppColors.textPrimary(context).withValues(alpha: 0.05), blurRadius: 15)]),
//       child: Column(children: [
//         const Text("متوسط الدرجات شهرياً", style: TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 30),
//         Expanded(child: LayoutBuilder(builder: (context, constraints) => Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.end, children: chartData.map((data) => _bar(context, constraints.maxHeight, data['value'], data['label'], isSpecial: data['special'])).toList()))),
//       ]),
//     );
//   }
//   Widget _bar(BuildContext context, double h, double v, String l, {bool isSpecial = false}) => Column(mainAxisAlignment: MainAxisAlignment.end, children: [Container(width: 18, height: (h - 30) * v, decoration: BoxDecoration(color: isSpecial ? AppColors.accentYellow(context) : AppColors.primaryTeal(context), borderRadius: BorderRadius.circular(4))), const SizedBox(height: 8), Text(l, style: const TextStyle(fontSize: 8))]);
// }

// class CalendarWidget extends StatelessWidget {
//   const CalendarWidget({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
//       child: Column(children: [
//         const Text("التقويم", style: TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 10),
//         GridView.builder(
//           shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: 28,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
//           itemBuilder: (context, index) => Center(child: Text("${index + 1}", style: const TextStyle(fontSize: 11))),
//         )
//       ]),
//     );
//   }
// }

// class BottomStatsRow extends StatelessWidget {
//   const BottomStatsRow({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Row(children: [
//       const Expanded(child: StatusCircleCard()),
//       Expanded(child: GaugeCard(title: "نسبة مراجعة الأوراق", percent: 0.8, text: "80%", color: AppColors.primaryTeal(context))),
//       Expanded(child: GaugeCard(title: "نسبة نشر النتائج", percent: 0.6, text: "60%", color: AppColors.accentYellow(context))),
//     ]);
//   }
// }

// class StatusCircleCard extends StatelessWidget {
//   const StatusCircleCard({super.key});
//   @override
//   Widget build(BuildContext context) => Container(height: 190, margin: const EdgeInsets.symmetric(horizontal: 8), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(children: [const Text("حالة نتائج الطلاب", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), const Spacer(), SizedBox(width: 70, height: 70, child: CircularProgressIndicator(value: 0.7, color: AppColors.primaryTeal(context), backgroundColor: AppColors.accentYellow(context))), const Spacer(), const Text("مكتملة بنسبة 70%")]));
// }

// class GaugeCard extends StatelessWidget {
//   final String title; final double percent; final String text; final Color? color;
//   const GaugeCard({required this.title, required this.percent, required this.text, this.color, super.key});
//   @override
//   Widget build(BuildContext context) => Container(height: 190, margin: const EdgeInsets.symmetric(horizontal: 8), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(children: [Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), const Spacer(), CustomPaint(size: const Size(100, 50), painter: OpenArcPainter(percent: percent, color: color ?? AppColors.primaryTeal(context), background: AppColors.scaffoldBg(context)), child: Center(child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))), const Spacer()]));
// }

// class OpenArcPainter extends CustomPainter {
//   final double percent; final Color color; final Color background;
//   OpenArcPainter({required this.percent, required this.color, required this.background});
//   @override
//   void paint(Canvas canvas, Size size) {
//     final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
//     canvas.drawArc(rect, math.pi * 1.15, math.pi * 0.7, false, Paint()..color = background..style = PaintingStyle.stroke..strokeWidth = 12..strokeCap = StrokeCap.round);
//     canvas.drawArc(rect, math.pi * 1.15, (math.pi * 0.7) * percent, false, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 12..strokeCap = StrokeCap.round);
//   }
//   @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }



// import 'package:flutter/material.dart';
// import 'dart:math' as math;
// import '../core/colors.dart'; 
// import 'teacher_matearial.dart';
// import 'grading.dart';
// import 'exam_page.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});
  
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   int _selectedIndex = 0;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: LayoutBuilder(builder: (context, constraints) {
//         bool isMobile = constraints.maxWidth < 800;
//         bool isTablet = constraints.maxWidth >= 800 && constraints.maxWidth < 1150;

//         return Scaffold(
//           key: _scaffoldKey,
//           backgroundColor: AppColors.secondaryTeal(context),
//           drawer: isMobile
//               ? Drawer(
//                   width: 260,
//                   backgroundColor: AppColors.primaryTeal(context),
//                   child: SafeArea(
//                     child: CustSidebar(
//                       selectedIndex: _selectedIndex,
//                       isCompact: false, // في الجوال القائمة تظهر كاملة
//                       onItemSelected: _handleNavigation,
//                     ),
//                   ),
//                 )
//               : null,
//           body: Row(
//             children: [
//               if (!isMobile)
//                 CustSidebar(
//                   selectedIndex: _selectedIndex,
//                   isCompact: isTablet, // تقلص القائمة في التابلت
//                   onItemSelected: _handleNavigation,
//                 ),
//               Expanded(
//                 child: Column(
//                   children: [
//                     if (isMobile) _buildMobileHeader(),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         padding: const EdgeInsets.all(24.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const HeaderWidget(),
//                             const SizedBox(height: 24),
//                             _buildResponsiveTopStats(isMobile),
//                             const SizedBox(height: 24),
//                             _buildResponsiveCharts(isMobile, isTablet),
//                             const SizedBox(height: 24),
//                             _buildResponsiveBottomStats(isMobile),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildMobileHeader() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Row(
//           children: [
//             IconButton(
//               icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)),
//               onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//             ),
//             const Spacer(),
//             Text("لوحة التحكم", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal(context))),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleNavigation(int index) {
//     if (index == _selectedIndex) return;
//     setState(() => _selectedIndex = index);
//     if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);

//     if (index == 2) {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Material1()));
//     } else if (index == 1) {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FinalExamPage()));
//     } else if (index == 3) {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GradingPage()));
//     }
//   }

//   // --- دوال التجاوب لترتيب التصميم حسب الشاشة ---

//   Widget _buildResponsiveTopStats(bool isMobile) {
//     if (isMobile) {
//       return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         physics: const BouncingScrollPhysics(),
//         child: Row(
//           children: [
//             _statCardFixed("الطلاب", "340", AppColors.accentYellow(context), Icons.people),
//             _statCardFixed("الأوراق المصححة", "780", AppColors.primaryTeal(context), Icons.description),
//             _statCardFixed("الاختبارات المنشئة", "13", AppColors.primaryTeal(context), Icons.create),
//             _statCardFixed("المسودات", "5", AppColors.primaryTeal(context), Icons.edit_note),
//           ],
//         ),
//       );
//     }
//     return const TopStatsGrid();
//   }

//   Widget _buildResponsiveCharts(bool isMobile, bool isTablet) {
//     if (isMobile || isTablet) {
//       return const Column(
//         children: [
//           MonthlyAverageChart(), 
//           SizedBox(height: 24), 
//           CalendarWidget()
//         ]
//       );
//     }
//     return const Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(flex: 3, child: MonthlyAverageChart()),
//         SizedBox(width: 20),
//         Expanded(flex: 1, child: CalendarWidget()), 
//       ],
//     );
//   }

//   Widget _buildResponsiveBottomStats(bool isMobile) {
//     if (isMobile) {
//       return const Column(
//         children: [
//           StatusCircleCard(),
//           SizedBox(height: 16),
//           GaugeCardWidget(title: "نسبة اكتمال مراجعة الأوراق المصححة", percent: 0.8, text: "80%", colorKey: 1),
//           SizedBox(height: 16),
//           GaugeCardWidget(title: "نسبة اكتمال نشر النتائج", percent: 0.6, text: "60%", colorKey: 2),
//         ],
//       );
//     }
//     return const BottomStatsRow();
//   }

//   Widget _statCardFixed(String title, String value, Color color, IconData icon) {
//     return Container(
//       width: 200, 
//       margin: const EdgeInsets.only(left: 12), 
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start, 
//             children: [
//               Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)), 
//               Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14))
//             ]
//           ), 
//           Icon(icon, color: Colors.white54, size: 40)
//         ]
//       )
//     );
//   }
// }

// /* =========================================================
//    السايد بار مع الرسام المنحني (Curved Painter)
// ========================================================= */
// class CustSidebar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemSelected;
//   final bool isCompact;

//   const CustSidebar({super.key, required this.selectedIndex, required this.onItemSelected, this.isCompact = false});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       width: isCompact ? 90 : 260,
//       decoration: BoxDecoration(
//         color: AppColors.primaryTeal(context),
//         borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
//       ),
//       child: Column(
//         children: [
//           const SizedBox(height: 40),
//           Icon(Icons.check_circle_outline, size: isCompact ? 40 : 60, color: Colors.white),
//           if (!isCompact) ...[
//             const SizedBox(height: 10),
//             const Text("Intelligent\nGrading System", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
//           ],
//           const SizedBox(height: 40),
//           _menuItem(context, "لوحة التحكم", Icons.dashboard_rounded, 0),
//           _menuItem(context, "إدارة الامتحانات", Icons.assignment_rounded, 1),
//           _menuItem(context, "المواد", Icons.library_books_rounded, 2),
//           _menuItem(context, "تصحيح", Icons.spellcheck_rounded, 3),
//           _menuItem(context, "مراجعة", Icons.rate_review_rounded, 4),
//           _menuItem(context, "إعدادات", Icons.settings_rounded, 5),
//           const Spacer(),
//         ],
//       ),
//     );
//   }

//   Widget _menuItem(BuildContext context, String title, IconData icon, int index) {
//     bool isActive = selectedIndex == index;
//     return InkWell(
//       onTap: () => onItemSelected(index),
//       child: Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.centerLeft,
//         children: [
//           if (isActive && !isCompact) 
//             Positioned(left: 0, top: 0, width: 45, child: CustomPaint(painter: SidebarCurvePainter(AppColors.secondaryTeal(context)))),
//           Container(
//             height: 55,
//             margin: EdgeInsets.only(left: isCompact ? 10 : (isActive ? 0 : 20), right: isCompact ? 10 : 15, bottom: 8),
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             decoration: BoxDecoration(
//               color: isActive ? AppColors.secondaryTeal(context) : Colors.transparent,
//               borderRadius: BorderRadius.only(
//                 topRight: const Radius.circular(25), bottomRight: const Radius.circular(25), 
//                 topLeft: Radius.circular(isActive && !isCompact ? 0 : 25), bottomLeft: Radius.circular(isActive && !isCompact ? 0 : 25)
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: isCompact ? MainAxisAlignment.center : MainAxisAlignment.start,
//               children: [
//                 Icon(icon, color: isActive ? AppColors.primaryTeal(context) : AppColors.accentYellow(context), size: 22),
//                 if (!isCompact) ...[
//                   const SizedBox(width: 12),
//                   Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text(title, style: TextStyle(color: isActive ? AppColors.primaryTeal(context) : Colors.white, fontSize: 16, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)))),
//                 ]
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SidebarCurvePainter extends CustomPainter {
//   final Color bgColor;
//   SidebarCurvePainter(this.bgColor);
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()..color = bgColor..style = PaintingStyle.fill;
//     double r = 25; double h = 55;
//     Path pathTop = Path()..moveTo(0, -r)..quadraticBezierTo(0, 0, r, 0)..lineTo(0, 0)..close();
//     canvas.drawPath(pathTop, paint);
//     Path pathBottom = Path()..moveTo(0, h + r)..quadraticBezierTo(0, h, r, h)..lineTo(0, h)..close();
//     canvas.drawPath(pathBottom, paint);
//   }
//   @override bool shouldRepaint(CustomPainter oldDelegate) => false;
// }

// /* =========================================================
//    مكونات التصميم الخاصة بك (Widgets)
// ========================================================= */

// class HeaderWidget extends StatelessWidget {
//   const HeaderWidget({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("مرحباً م.خديجة!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
//               const SizedBox(height: 4),
//               Text("تحقق من إحصائياتك", style: TextStyle(color: AppColors.textSecondary(context))),
//             ],
//           ),
//           Row(children: [_iconButton(context, Icons.notifications_none), const SizedBox(width: 10), _iconButton(context, Icons.person_outline)])
//         ],
//       ),
//     );
//   }
//   Widget _iconButton(BuildContext context, IconData icon) => Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle), child: Icon(icon, color: AppColors.primaryTeal(context)));
// }

// class TopStatsGrid extends StatelessWidget {
//   const TopStatsGrid({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         _statCard(context, "الطلاب", "340", AppColors.accentYellow(context), Icons.people),
//         _statCard(context, "الأوراق المصححة", "780", AppColors.primaryTeal(context), Icons.description),
//         _statCard(context, "الاختبارات المنشئة", "13", AppColors.primaryTeal(context), Icons.create),
//         _statCard(context, "المسودات", "5", AppColors.primaryTeal(context), Icons.edit_note),
//       ],
//     );
//   }
//   Widget _statCard(BuildContext context, String title, String value, Color color, IconData icon) => Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 8), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)), Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14))]), Icon(icon, color: Colors.white54, size: 40)])));
// }

// class MonthlyAverageChart extends StatelessWidget {
//   const MonthlyAverageChart({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> chartData = [
//       {"label": "ديسمبر", "value": 0.45, "special": false}, {"label": "نوفمبر", "value": 0.53, "special": false},
//       {"label": "أكتوبر", "value": 0.45, "special": false}, {"label": "سبتمبر", "value": 0.72, "special": true}, 
//       {"label": "أغسطس", "value": 0.82, "special": true}, {"label": "يوليو", "value": 0.95, "special": true}, 
//       {"label": "يونيو", "value": 0.55, "special": false}, {"label": "مايو", "value": 0.28, "special": false},
//       {"label": "أبريل", "value": 0.20, "special": false}, {"label": "مارس", "value": 0.35, "special": false},
//       {"label": "فبراير", "value": 0.45, "special": false}, {"label": "يناير", "value": 0.65, "special": false},
//     ];
//     return Container(
//       height: 300, padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: AppColors.textPrimary(context).withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))]),
//       child: Column(children: [
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Text("متوسط درجات الطلاب شهرياً", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary(context))),
//           Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.accentYellow(context), shape: BoxShape.circle)), const SizedBox(width: 5), Text("أفضل 3 أشهر", style: TextStyle(fontSize: 11, color: AppColors.accentYellow(context)))]),
//         ]),
//         const SizedBox(height: 30),
//         Expanded(child: Row(children: [
//           Expanded(child: LayoutBuilder(builder: (context, constraints) => Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.end, children: chartData.map((data) => _bar(context, constraints.maxHeight, data['value'], data['label'], isSpecial: data['special'])).toList()))),
//           const SizedBox(width: 10),
//           Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: ["100%", "80%", "60%", "40%", "20%", "0%"].map((l) => Text(l, style: TextStyle(fontSize: 9, color: AppColors.textSecondary(context)))).toList()),
//         ])),
//       ]),
//     );
//   }
//   Widget _bar(BuildContext context, double h, double v, String l, {bool isSpecial = false}) => Column(mainAxisAlignment: MainAxisAlignment.end, children: [Container(width: 18, height: (h - 30) * v, decoration: BoxDecoration(color: isSpecial ? AppColors.accentYellow(context) : AppColors.primaryTeal(context), borderRadius: BorderRadius.circular(4))), const SizedBox(height: 8), Text(l, style: TextStyle(fontSize: 8, color: AppColors.textSecondary(context)))]);
// }

// class CalendarWidget extends StatelessWidget {
//   const CalendarWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<String> days = ["27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"];
//     final List<String> weekDays = ["ح", "ن", "ث", "ر", "خ", "ج", "س"];

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.textPrimary(context).withValues(alpha: 0.05),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//           Align(
//             alignment: Alignment.centerRight,
//             child: Text("التقويم", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary(context))),
//           ),
//           const SizedBox(height: 15),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(color: AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(10)),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textSecondary(context)),
//                 const SizedBox(width: 5),
//                 Text("فبراير 2026", style: TextStyle(fontSize: 13, color: AppColors.textSecondary(context))),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: weekDays.map((d) => Expanded(child: Center(child: Text(d, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 12))))).toList(),
//           ),
//           const SizedBox(height: 10),
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: days.length,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 5, crossAxisSpacing: 5),
//             itemBuilder: (context, index) {
//               final day = days[index];
//               bool isToday = day == "3" && index == 7; 
//               bool isGrey = index < 5 || index > 32;
              
//               return Container(
//                 decoration: BoxDecoration(
//                   color: isToday ? AppColors.primaryTeal(context) : Colors.transparent, 
//                   shape: BoxShape.circle
//                 ),
//                 child: Center(
//                   child: Text(
//                     day,
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
//                       color: isToday ? Colors.white : (isGrey ? AppColors.textSecondary(context).withValues(alpha: 0.3) : AppColors.textPrimary(context)),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }
// }

// class BottomStatsRow extends StatelessWidget {
//   const BottomStatsRow({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const Expanded(child: StatusCircleCard()),
//         Expanded(child: GaugeCardWidget(title: "نسبة اكتمال مراجعة الأوراق المصححة", percent: 0.8, text: "80%", colorKey: 1)), 
//         Expanded(child: GaugeCardWidget(title: "نسبة اكتمال نشر النتائج", percent: 0.6, text: "60%", colorKey: 2))
//       ]
//     );
//   }
// }

// class StatusCircleCard extends StatelessWidget {
//   const StatusCircleCard({super.key});
//   @override
//   Widget build(BuildContext context) => Container(
//     height: 190, margin: const EdgeInsets.symmetric(horizontal: 8), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), 
//     child: Column(
//       children: [
//         const Text("حالة نتائج الطلاب", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), 
//         const Spacer(), 
//         SizedBox(width: 85, height: 85, child: CircularProgressIndicator(value: 0.7, strokeWidth: 10, color: AppColors.primaryTeal(context), backgroundColor: AppColors.accentYellow(context))), 
//         const Spacer(), 
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center, 
//           children: [
//             _dot(AppColors.primaryTeal(context), "نجاح"), 
//             const SizedBox(width: 18), 
//             _dot(AppColors.accentYellow(context), "فشل")
//           ]
//         )
//       ]
//     )
//   );

//   Widget _dot(Color c, String t) => Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle)), const SizedBox(width: 6), Text(t, style: const TextStyle(fontSize: 11))]);
// }

// class GaugeCardWidget extends StatelessWidget {
//   final String title; final double percent; final String text; final int colorKey;
//   const GaugeCardWidget({required this.title, required this.percent, required this.text, required this.colorKey, super.key});
  
//   @override
//   Widget build(BuildContext context) {
//     Color c = colorKey == 1 ? AppColors.primaryTeal(context) : AppColors.accentYellow(context);
//     return Container(
//       height: 190, margin: const EdgeInsets.symmetric(horizontal: 8), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), 
//       child: Column(
//         children: [
//           Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), 
//           const Spacer(), 
//           CustomPaint(
//             size: const Size(130, 65), 
//             painter: OpenArcPainter(percent: percent, color: c, background: AppColors.scaffoldBg(context)), 
//             child: SizedBox(width: 130, height: 65, child: Center(child: Text(text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))))
//           ), 
//           const Spacer()
//         ]
//       )
//     );
//   }
// }

// class OpenArcPainter extends CustomPainter {
//   final double percent; final Color color; final Color background;
//   OpenArcPainter({required this.percent, required this.color, required this.background});
//   @override
//   void paint(Canvas canvas, Size size) {
//     final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
//     canvas.drawArc(rect, math.pi * 1.15, math.pi * 0.7, false, Paint()..color = background..style = PaintingStyle.stroke..strokeWidth = 16..strokeCap = StrokeCap.round);
//     canvas.drawArc(rect, math.pi * 1.15, (math.pi * 0.7) * percent, false, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 16..strokeCap = StrokeCap.round);
//   }
//   @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }



// import 'package:flutter/material.dart';
// import 'dart:math' as math;
// import '../core/colors.dart'; 
// import 'teacher_matearial.dart';
// import 'grading.dart';
// import 'exam_page.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});
  
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   int _selectedIndex = 0;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: LayoutBuilder(builder: (context, constraints) {
//         bool isMobile = constraints.maxWidth < 800;
//         bool isTablet = constraints.maxWidth >= 800 && constraints.maxWidth < 1150;

//         return Scaffold(
//           key: _scaffoldKey,
//           backgroundColor: AppColors.secondaryTeal(context),
//           drawer: isMobile
//               ? Drawer(
//                   width: 260,
//                   backgroundColor: AppColors.primaryTeal(context),
//                   child: SafeArea(
//                     child: CustSidebar(
//                       selectedIndex: _selectedIndex,
//                       isCompact: false, 
//                       onItemSelected: _handleNavigation,
//                     ),
//                   ),
//                 )
//               : null,
//           body: Row(
//             children: [
//               // السايد بار يتقلص في التابلت
//               if (!isMobile)
//                 CustSidebar(
//                   selectedIndex: _selectedIndex,
//                   isCompact: isTablet, 
//                   onItemSelected: _handleNavigation,
//                 ),
//               Expanded(
//                 child: Column(
//                   children: [
//                     if (isMobile) _buildMobileHeader(),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         padding: const EdgeInsets.all(24.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const HeaderWidget(),
//                             const SizedBox(height: 24),
                            
//                             // كروت الإحصائيات العلوية
//                             TopStatsGrid(isMobile: isMobile, isTablet: isTablet),
                            
//                             const SizedBox(height: 24),
                            
//                             // المخطط والتقويم
//                             _buildResponsiveCharts(isMobile, isTablet),
                            
//                             const SizedBox(height: 24),
                            
//                             // الإحصائيات السفلية الدائرية
//                             _buildResponsiveBottomStats(isMobile),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildMobileHeader() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Row(
//           children: [
//             IconButton(
//               icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)),
//               onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//             ),
//             const Spacer(),
//             Text("لوحة التحكم", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal(context))),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleNavigation(int index) {
//     if (index == _selectedIndex) return;
//     setState(() => _selectedIndex = index);
//     if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);

//     if (index == 2) {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Material1()));
//     } else if (index == 1) {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FinalExamPage()));
//     } else if (index == 3) {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GradingPage()));
//     }
//   }

//   // --- التجاوب الخاص بالمخطط البياني والتقويم ---
//   Widget _buildResponsiveCharts(bool isMobile, bool isTablet) {
//     if (isMobile) {
//       return Column(
//         children: [
//           const MonthlyAverageChart(), 
//           const SizedBox(height: 24), 
//           CalendarWidget(isMobile: isMobile) 
//         ]
//       );
//     }
//     // التابلت والويب يبقون بنفس التصميم الأصلي (بجانب بعض)
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Expanded(flex: 3, child: MonthlyAverageChart()),
//         const SizedBox(width: 20),
//         Expanded(flex: 1, child: CalendarWidget(isMobile: isMobile)), 
//       ],
//     );
//   }

//   // --- التجاوب الخاص بالكروت الدائرية السفلية ---
//   Widget _buildResponsiveBottomStats(bool isMobile) {
//     if (isMobile) {
//       // في الجوال نعرضهم بالطول وبنفس العرض 100%
//       return Column(
//         children: [
//           StatusCircleCard(isMobile: isMobile),
//           const SizedBox(height: 16),
//           GaugeCardWidget(title: "نسبة اكتمال مراجعة الأوراق المصححة", percent: 0.8, text: "80%", colorKey: 1, isMobile: isMobile),
//           const SizedBox(height: 16),
//           GaugeCardWidget(title: "نسبة اكتمال نشر النتائج", percent: 0.6, text: "60%", colorKey: 2, isMobile: isMobile),
//         ],
//       );
//     }
//     // التابلت والويب يبقون بنفس التصميم الأصلي (صف واحد Expanded)
//     return const BottomStatsRow();
//   }
// }

// /* =========================================================
//    الكروت العلوية للإحصائيات (الحل الدقيق لمشكلة التابلت والفون)
// ========================================================= */
// class TopStatsGrid extends StatelessWidget {
//   final bool isMobile;
//   final bool isTablet;
  
//   const TopStatsGrid({super.key, required this.isMobile, required this.isTablet});

//   @override
//   Widget build(BuildContext context) {
//     // إذا كان جوال أو تابلت -> نجعلها قابلة للتمرير (سحب أفقي)
//     if (isMobile || isTablet) {
//       // حجم الكرت ثابت وكبير في التابلت، ومناسب في الفون
//       double cardWidth = isMobile ? 220 : 280; 
      
//       return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         physics: const BouncingScrollPhysics(),
//         child: Row(
//           children: [
//             _statCardFixed(context, "الطلاب", "340", AppColors.accentYellow(context), Icons.people, cardWidth),
//             _statCardFixed(context, "الأوراق المصححة", "780", AppColors.primaryTeal(context), Icons.description, cardWidth),
//             _statCardFixed(context, "الاختبارات المنشئة", "13", AppColors.primaryTeal(context), Icons.create, cardWidth),
//             _statCardFixed(context, "المسودات", "5", AppColors.primaryTeal(context), Icons.edit_note, cardWidth),
//           ],
//         ),
//       );
//     }

//     // إذا كان ويب -> نفس تصميمك القديم Expanded لملء الشاشة بدون سكرول
//     return Row(
//       children: [
//         _statCardExpanded(context, "الطلاب", "340", AppColors.accentYellow(context), Icons.people),
//         _statCardExpanded(context, "الأوراق المصححة", "780", AppColors.primaryTeal(context), Icons.description),
//         _statCardExpanded(context, "الاختبارات المنشئة", "13", AppColors.primaryTeal(context), Icons.create),
//         _statCardExpanded(context, "المسودات", "5", AppColors.primaryTeal(context), Icons.edit_note),
//       ],
//     );
//   }

//   // كرت بحجم ثابت وقابل للتمرير (للتابلت والفون)
//   Widget _statCardFixed(BuildContext context, String title, String value, Color color, IconData icon, double width) {
//     return Container(
//       width: width, 
//       margin: const EdgeInsets.only(left: 16), 
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start, 
//             children: [
//               Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)), 
//               Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14))
//             ]
//           ), 
//           Icon(icon, color: Colors.white54, size: 40)
//         ]
//       )
//     );
//   }

//   // كرت يتمدد (للويب) كما في تصميمك الأصلي
//   Widget _statCardExpanded(BuildContext context, String title, String value, Color color, IconData icon) {
//     return Expanded(
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 8), 
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start, 
//               children: [
//                 Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)), 
//                 Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14))
//               ]
//             ), 
//             Icon(icon, color: Colors.white54, size: 40)
//           ]
//         )
//       )
//     );
//   }
// }

// /* =========================================================
//    السايد بار مع الرسام المنحني
// ========================================================= */
// class CustSidebar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemSelected;
//   final bool isCompact;

//   const CustSidebar({super.key, required this.selectedIndex, required this.onItemSelected, this.isCompact = false});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       width: isCompact ? 90 : 260,
//       decoration: BoxDecoration(
//         color: AppColors.primaryTeal(context),
//         borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
//       ),
//       child: Column(
//         children: [
//           const SizedBox(height: 40),
//           Icon(Icons.check_circle_outline, size: isCompact ? 40 : 60, color: Colors.white),
//           if (!isCompact) ...[
//             const SizedBox(height: 10),
//             const Text("Intelligent\nGrading System", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
//           ],
//           const SizedBox(height: 40),
//           _menuItem(context, "لوحة التحكم", Icons.dashboard_rounded, 0),
//           _menuItem(context, "إدارة الامتحانات", Icons.assignment_rounded, 1),
//           _menuItem(context, "المواد", Icons.library_books_rounded, 2),
//           _menuItem(context, "تصحيح", Icons.spellcheck_rounded, 3),
//           _menuItem(context, "مراجعة", Icons.rate_review_rounded, 4),
//           _menuItem(context, "إعدادات", Icons.settings_rounded, 5),
//           const Spacer(),
//         ],
//       ),
//     );
//   }

//   Widget _menuItem(BuildContext context, String title, IconData icon, int index) {
//     bool isActive = selectedIndex == index;
//     return InkWell(
//       onTap: () => onItemSelected(index),
//       child: Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.centerLeft,
//         children: [
//           if (isActive && !isCompact) 
//             Positioned(left: 0, top: 0, width: 45, child: CustomPaint(painter: SidebarCurvePainter(AppColors.secondaryTeal(context)))),
//           Container(
//             height: 55,
//             margin: EdgeInsets.only(left: isCompact ? 10 : (isActive ? 0 : 20), right: isCompact ? 10 : 15, bottom: 8),
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             decoration: BoxDecoration(
//               color: isActive ? AppColors.secondaryTeal(context) : Colors.transparent,
//               borderRadius: BorderRadius.only(
//                 topRight: const Radius.circular(25), bottomRight: const Radius.circular(25), 
//                 topLeft: Radius.circular(isActive && !isCompact ? 0 : 25), bottomLeft: Radius.circular(isActive && !isCompact ? 0 : 25)
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: isCompact ? MainAxisAlignment.center : MainAxisAlignment.start,
//               children: [
//                 Icon(icon, color: isActive ? AppColors.primaryTeal(context) : AppColors.accentYellow(context), size: 22),
//                 if (!isCompact) ...[
//                   const SizedBox(width: 12),
//                   Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text(title, style: TextStyle(color: isActive ? AppColors.primaryTeal(context) : Colors.white, fontSize: 16, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)))),
//                 ]
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SidebarCurvePainter extends CustomPainter {
//   final Color bgColor;
//   SidebarCurvePainter(this.bgColor);
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()..color = bgColor..style = PaintingStyle.fill;
//     double r = 25; double h = 55;
//     Path pathTop = Path()..moveTo(0, -r)..quadraticBezierTo(0, 0, r, 0)..lineTo(0, 0)..close();
//     canvas.drawPath(pathTop, paint);
//     Path pathBottom = Path()..moveTo(0, h + r)..quadraticBezierTo(0, h, r, h)..lineTo(0, h)..close();
//     canvas.drawPath(pathBottom, paint);
//   }
//   @override bool shouldRepaint(CustomPainter oldDelegate) => false;
// }

// /* =========================================================
//    مكونات التصميم الأصلية
// ========================================================= */

// class HeaderWidget extends StatelessWidget {
//   const HeaderWidget({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("مرحباً م.خديجة!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
//               const SizedBox(height: 4),
//               Text("تحقق من إحصائياتك", style: TextStyle(color: AppColors.textSecondary(context))),
//             ],
//           ),
//           Row(children: [_iconButton(context, Icons.notifications_none), const SizedBox(width: 10), _iconButton(context, Icons.person_outline)])
//         ],
//       ),
//     );
//   }
//   Widget _iconButton(BuildContext context, IconData icon) => Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle), child: Icon(icon, color: AppColors.primaryTeal(context)));
// }

// class MonthlyAverageChart extends StatelessWidget {
//   const MonthlyAverageChart({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> chartData = [
//       {"label": "ديسمبر", "value": 0.45, "special": false}, {"label": "نوفمبر", "value": 0.53, "special": false},
//       {"label": "أكتوبر", "value": 0.45, "special": false}, {"label": "سبتمبر", "value": 0.72, "special": true}, 
//       {"label": "أغسطس", "value": 0.82, "special": true}, {"label": "يوليو", "value": 0.95, "special": true}, 
//       {"label": "يونيو", "value": 0.55, "special": false}, {"label": "مايو", "value": 0.28, "special": false},
//       {"label": "أبريل", "value": 0.20, "special": false}, {"label": "مارس", "value": 0.35, "special": false},
//       {"label": "فبراير", "value": 0.45, "special": false}, {"label": "يناير", "value": 0.65, "special": false},
//     ];
//     return Container(
//       height: 300, padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: AppColors.textPrimary(context).withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))]),
//       child: Column(children: [
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Text("متوسط درجات الطلاب شهرياً", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary(context))),
//           Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.accentYellow(context), shape: BoxShape.circle)), const SizedBox(width: 5), Text("أفضل 3 أشهر", style: TextStyle(fontSize: 11, color: AppColors.accentYellow(context)))]),
//         ]),
//         const SizedBox(height: 30),
//         Expanded(child: Row(children: [
//           Expanded(child: LayoutBuilder(builder: (context, constraints) => Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.end, children: chartData.map((data) => _bar(context, constraints.maxHeight, data['value'], data['label'], isSpecial: data['special'])).toList()))),
//           const SizedBox(width: 10),
//           Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: ["100%", "80%", "60%", "40%", "20%", "0%"].map((l) => Text(l, style: TextStyle(fontSize: 9, color: AppColors.textSecondary(context)))).toList()),
//         ])),
//       ]),
//     );
//   }
//   Widget _bar(BuildContext context, double h, double v, String l, {bool isSpecial = false}) => Column(mainAxisAlignment: MainAxisAlignment.end, children: [Container(width: 15, height: (h - 30) * v, decoration: BoxDecoration(color: isSpecial ? AppColors.accentYellow(context) : AppColors.primaryTeal(context), borderRadius: BorderRadius.circular(4))), const SizedBox(height: 8), Text(l, style: TextStyle(fontSize: 8, color: AppColors.textSecondary(context)))]);
// }

// class CalendarWidget extends StatelessWidget {
//   final bool isMobile;
//   const CalendarWidget({super.key, this.isMobile = false});

//   @override
//   Widget build(BuildContext context) {
//     final List<String> days = ["27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"];
//     final List<String> weekDays = ["ح", "ن", "ث", "ر", "خ", "ج", "س"];

//     return Container(
//       // تصغير الهوامش إذا كان جوال
//       padding: EdgeInsets.all(isMobile ? 12 : 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.textPrimary(context).withValues(alpha: 0.05),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//           Align(
//             alignment: Alignment.centerRight,
//             child: Text("التقويم", style: TextStyle(fontWeight: FontWeight.bold, fontSize: isMobile ? 15 : 18, color: AppColors.textPrimary(context))),
//           ),
//           SizedBox(height: isMobile ? 10 : 15),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(color: AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(10)),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textSecondary(context)),
//                 const SizedBox(width: 5),
//                 Text("فبراير 2026", style: TextStyle(fontSize: 13, color: AppColors.textSecondary(context))),
//               ],
//             ),
//           ),
//           SizedBox(height: isMobile ? 10 : 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: weekDays.map((d) => Expanded(child: Center(child: Text(d, style: TextStyle(color: AppColors.textSecondary(context), fontSize: isMobile ? 10 : 12))))).toList(),
//           ),
//           SizedBox(height: isMobile ? 5 : 10),
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: days.length,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 5, crossAxisSpacing: 5),
//             itemBuilder: (context, index) {
//               final day = days[index];
//               bool isToday = day == "3" && index == 7; 
//               bool isGrey = index < 5 || index > 32;
              
//               return Container(
//                 decoration: BoxDecoration(
//                   color: isToday ? AppColors.primaryTeal(context) : Colors.transparent, 
//                   shape: BoxShape.circle
//                 ),
//                 child: Center(
//                   child: Text(
//                     day,
//                     style: TextStyle(
//                       fontSize: isMobile ? 10 : 12, 
//                       fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
//                       color: isToday ? Colors.white : (isGrey ? AppColors.textSecondary(context).withValues(alpha: 0.3) : AppColors.textPrimary(context)),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }
// }

// // تصميم الويب والتابلت للكروت السفلية
// class BottomStatsRow extends StatelessWidget {
//   const BottomStatsRow({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const Expanded(child: StatusCircleCard(isMobile: false)),
//         const SizedBox(width: 16),
//         Expanded(child: GaugeCardWidget(title: "نسبة مراجعة الأوراق", percent: 0.8, text: "80%", colorKey: 1, isMobile: false)), 
//         const SizedBox(width: 16),
//         Expanded(child: GaugeCardWidget(title: "نسبة نشر النتائج", percent: 0.6, text: "60%", colorKey: 2, isMobile: false))
//       ]
//     );
//   }
// }

// class StatusCircleCard extends StatelessWidget {
//   final bool isMobile;
//   const StatusCircleCard({super.key, required this.isMobile});
  
//   @override
//   Widget build(BuildContext context) => Container(
//     width: isMobile ? double.infinity : null, // العرض الكامل في الجوال
//     height: 190, 
//     padding: const EdgeInsets.all(20), 
//     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), 
//     child: Column(
//       children: [
//         const Text("حالة نتائج الطلاب", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), 
//         const Spacer(), 
//         SizedBox(width: 85, height: 85, child: CircularProgressIndicator(value: 0.7, strokeWidth: 10, color: AppColors.primaryTeal(context), backgroundColor: AppColors.accentYellow(context))), 
//         const Spacer(), 
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center, 
//           children: [
//             _dot(AppColors.primaryTeal(context), "نجاح"), 
//             const SizedBox(width: 18), 
//             _dot(AppColors.accentYellow(context), "فشل")
//           ]
//         )
//       ]
//     )
//   );

//   Widget _dot(Color c, String t) => Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle)), const SizedBox(width: 6), Text(t, style: const TextStyle(fontSize: 11))]);
// }

// class GaugeCardWidget extends StatelessWidget {
//   final String title; final double percent; final String text; final int colorKey; final bool isMobile;
//   const GaugeCardWidget({required this.title, required this.percent, required this.text, required this.colorKey, required this.isMobile, super.key});
  
//   @override
//   Widget build(BuildContext context) {
//     Color c = colorKey == 1 ? AppColors.primaryTeal(context) : AppColors.accentYellow(context);
//     return Container(
//       width: isMobile ? double.infinity : null, // العرض الكامل في الجوال
//       height: 190, 
//       padding: const EdgeInsets.all(20), 
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), 
//       child: Column(
//         children: [
//           Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), 
//           const Spacer(), 
//           CustomPaint(
//             size: const Size(130, 65), 
//             painter: OpenArcPainter(percent: percent, color: c, background: AppColors.scaffoldBg(context)), 
//             child: SizedBox(width: 130, height: 65, child: Center(child: Text(text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))))
//           ), 
//           const Spacer()
//         ]
//       )
//     );
//   }
// }

// class OpenArcPainter extends CustomPainter {
//   final double percent; final Color color; final Color background;
//   OpenArcPainter({required this.percent, required this.color, required this.background});
//   @override
//   void paint(Canvas canvas, Size size) {
//     final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
//     canvas.drawArc(rect, math.pi * 1.15, math.pi * 0.7, false, Paint()..color = background..style = PaintingStyle.stroke..strokeWidth = 16..strokeCap = StrokeCap.round);
//     canvas.drawArc(rect, math.pi * 1.15, (math.pi * 0.7) * percent, false, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 16..strokeCap = StrokeCap.round);
//   }
//   @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: LayoutBuilder(builder: (context, constraints) {
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
              if (!isMobile)
                CustSidebar(
                  selectedIndex: _selectedIndex,
                  isCompact: isTablet, 
                  onItemSelected: _handleNavigation,
                ),
              Expanded(
                child: Column(
                  children: [
                    if (isMobile) _buildMobileHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const HeaderWidget(),
                            const SizedBox(height: 24),
                            
                            // كروت الإحصائيات العلوية
                            TopStatsGrid(isMobile: isMobile, isTablet: isTablet),
                            
                            const SizedBox(height: 24),
                            
                            // المخطط والتقويم
                            _buildResponsiveCharts(isMobile, isTablet),
                            
                            const SizedBox(height: 24),
                            
                            // الإحصائيات السفلية الدائرية
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
      }),
    );
  }

  Widget _buildMobileHeader() {
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
            Text("لوحة التحكم", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal(context))),
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FinalExamPage()));
    } else if (index == 3) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GradingPage()));
    }
  }

  // --- التجاوب الخاص بالمخطط البياني والتقويم ---
  Widget _buildResponsiveCharts(bool isMobile, bool isTablet) {
    if (isMobile) {
      return Column(
        children: [
          const MonthlyAverageChart(), 
          const SizedBox(height: 24), 
          CalendarWidget(isMobile: isMobile) 
        ]
      );
    }
    // التابلت والويب يبقون بنفس التصميم الأصلي (بجانب بعض)
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(flex: 3, child: MonthlyAverageChart()),
        const SizedBox(width: 20),
        Expanded(flex: 1, child: CalendarWidget(isMobile: isMobile)), 
      ],
    );
  }

  // --- التجاوب الخاص بالكروت الدائرية السفلية ---
  Widget _buildResponsiveBottomStats(bool isMobile) {
    if (isMobile) {
      // في الجوال نعرضهم بالطول وبنفس العرض 100%
      return Column(
        children: [
          StatusCircleCard(isMobile: isMobile),
          const SizedBox(height: 16),
          GaugeCardWidget(title: "نسبة اكتمال مراجعة الأوراق المصححة", percent: 0.8, text: "80%", colorKey: 1, isMobile: isMobile),
          const SizedBox(height: 16),
          GaugeCardWidget(title: "نسبة اكتمال نشر النتائج", percent: 0.6, text: "60%", colorKey: 2, isMobile: isMobile),
        ],
      );
    }
    // التابلت والويب يبقون بنفس التصميم الأصلي (صف واحد Expanded)
    return const BottomStatsRow();
  }
}

/* =========================================================
   الكروت العلوية للإحصائيات 
========================================================= */
class TopStatsGrid extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  
  const TopStatsGrid({super.key, required this.isMobile, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    // إذا كان جوال أو تابلت -> نجعلها قابلة للتمرير (سحب أفقي) وبنفس الحجم
    if (isMobile || isTablet) {
      // تم توحيد العرض ليكون التابلت نفس الفون تماماً
      double cardWidth = 220; 
      
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            _statCardFixed(context, "الطلاب", "340", AppColors.accentYellow(context), Icons.people, cardWidth),
            _statCardFixed(context, "الأوراق المصححة", "780", AppColors.primaryTeal(context), Icons.description, cardWidth),
            _statCardFixed(context, "الاختبارات المنشئة", "13", AppColors.primaryTeal(context), Icons.create, cardWidth),
            _statCardFixed(context, "المسودات", "5", AppColors.primaryTeal(context), Icons.edit_note, cardWidth),
          ],
        ),
      );
    }

    // إذا كان ويب -> نفس تصميمك القديم Expanded لملء الشاشة بدون سكرول
    return Row(
      children: [
        _statCardExpanded(context, "الطلاب", "340", AppColors.accentYellow(context), Icons.people),
        _statCardExpanded(context, "الأوراق المصححة", "780", AppColors.primaryTeal(context), Icons.description),
        _statCardExpanded(context, "الاختبارات المنشئة", "13", AppColors.primaryTeal(context), Icons.create),
        _statCardExpanded(context, "المسودات", "5", AppColors.primaryTeal(context), Icons.edit_note),
      ],
    );
  }

  // كرت بحجم ثابت وقابل للتمرير (للتابلت والفون)
  Widget _statCardFixed(BuildContext context, String title, String value, Color color, IconData icon, double width) {
    return Container(
      width: width, 
      margin: const EdgeInsets.only(left: 16), 
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)), 
              Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14))
            ]
          ), 
          Icon(icon, color: Colors.white54, size: 40)
        ]
      )
    );
  }

  // كرت يتمدد (للويب) كما في تصميمك الأصلي
  Widget _statCardExpanded(BuildContext context, String title, String value, Color color, IconData icon) {
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
                Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14))
              ]
            ), 
            Icon(icon, color: Colors.white54, size: 40)
          ]
        )
      )
    );
  }
}

/* =========================================================
   السايد بار مع الرسام المنحني
========================================================= */
class CustSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool isCompact;

  const CustSidebar({super.key, required this.selectedIndex, required this.onItemSelected, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isCompact ? 90 : 260,
      decoration: BoxDecoration(
        color: AppColors.primaryTeal(context),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.check_circle_outline, size: isCompact ? 40 : 60, color: Colors.white),
          if (!isCompact) ...[
            const SizedBox(height: 10),
            const Text("Intelligent\nGrading System", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
          const SizedBox(height: 40),
          _menuItem(context, "لوحة التحكم", Icons.dashboard_rounded, 0),
          _menuItem(context, "إدارة الامتحانات", Icons.assignment_rounded, 1),
          _menuItem(context, "المواد", Icons.library_books_rounded, 2),
          _menuItem(context, "تصحيح", Icons.spellcheck_rounded, 3),
          _menuItem(context, "مراجعة", Icons.rate_review_rounded, 4),
          _menuItem(context, "إعدادات", Icons.settings_rounded, 5),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _menuItem(BuildContext context, String title, IconData icon, int index) {
    bool isActive = selectedIndex == index;
    return InkWell(
      onTap: () => onItemSelected(index),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          if (isActive && !isCompact) 
            Positioned(left: 0, top: 0, width: 45, child: CustomPaint(painter: SidebarCurvePainter(AppColors.secondaryTeal(context)))),
          Container(
            height: 55,
            margin: EdgeInsets.only(left: isCompact ? 10 : (isActive ? 0 : 20), right: isCompact ? 10 : 15, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: isActive ? AppColors.secondaryTeal(context) : Colors.transparent,
              borderRadius: BorderRadius.only(
                topRight: const Radius.circular(25), bottomRight: const Radius.circular(25), 
                topLeft: Radius.circular(isActive && !isCompact ? 0 : 25), bottomLeft: Radius.circular(isActive && !isCompact ? 0 : 25)
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

/* =========================================================
   مكونات التصميم الأصلية
========================================================= */

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("مرحباً م.خديجة!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
              const SizedBox(height: 4),
              Text("تحقق من إحصائياتك", style: TextStyle(color: AppColors.textSecondary(context))),
            ],
          ),
          Row(children: [_iconButton(context, Icons.notifications_none), const SizedBox(width: 10), _iconButton(context, Icons.person_outline)])
        ],
      ),
    );
  }
  Widget _iconButton(BuildContext context, IconData icon) => Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle), child: Icon(icon, color: AppColors.primaryTeal(context)));
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: AppColors.textPrimary(context).withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))]),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("متوسط درجات الطلاب شهرياً", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary(context))),
          Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.accentYellow(context), shape: BoxShape.circle)), const SizedBox(width: 5), Text("أفضل 3 أشهر", style: TextStyle(fontSize: 11, color: AppColors.accentYellow(context)))]),
        ]),
        const SizedBox(height: 30),
        Expanded(child: Row(children: [
          Expanded(child: LayoutBuilder(builder: (context, constraints) => Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.end, children: chartData.map((data) => _bar(context, constraints.maxHeight, data['value'], data['label'], isSpecial: data['special'])).toList()))),
          const SizedBox(width: 10),
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: ["100%", "80%", "60%", "40%", "20%", "0%"].map((l) => Text(l, style: TextStyle(fontSize: 9, color: AppColors.textSecondary(context)))).toList()),
        ])),
      ]),
    );
  }
  Widget _bar(BuildContext context, double h, double v, String l, {bool isSpecial = false}) => Column(mainAxisAlignment: MainAxisAlignment.end, children: [Container(width: 15, height: (h - 30) * v, decoration: BoxDecoration(color: isSpecial ? AppColors.accentYellow(context) : AppColors.primaryTeal(context), borderRadius: BorderRadius.circular(4))), const SizedBox(height: 8), Text(l, style: TextStyle(fontSize: 8, color: AppColors.textSecondary(context)))]);
}

class CalendarWidget extends StatelessWidget {
  final bool isMobile;
  const CalendarWidget({super.key, this.isMobile = false}); 

  @override
  Widget build(BuildContext context) {
    final List<String> days = ["27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"];
    final List<String> weekDays = ["ح", "ن", "ث", "ر", "خ", "ج", "س"];

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary(context).withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text("التقويم", style: TextStyle(fontWeight: FontWeight.bold, fontSize: isMobile ? 15 : 18, color: AppColors.textPrimary(context))),
          ),
          SizedBox(height: isMobile ? 10 : 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textSecondary(context)),
                const SizedBox(width: 5),
                Text("فبراير 2026", style: TextStyle(fontSize: 13, color: AppColors.textSecondary(context))),
              ],
            ),
          ),
          SizedBox(height: isMobile ? 10 : 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDays.map((d) => Expanded(child: Center(child: Text(d, style: TextStyle(color: AppColors.textSecondary(context), fontSize: isMobile ? 10 : 12))))).toList(),
          ),
          SizedBox(height: isMobile ? 5 : 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 5, crossAxisSpacing: 5),
            itemBuilder: (context, index) {
              final day = days[index];
              bool isToday = day == "3" && index == 7; 
              bool isGrey = index < 5 || index > 32;
              
              return Container(
                decoration: BoxDecoration(
                  color: isToday ? AppColors.primaryTeal(context) : Colors.transparent, 
                  shape: BoxShape.circle
                ),
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: isMobile ? 10 : 12, 
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday ? Colors.white : (isGrey ? AppColors.textSecondary(context).withValues(alpha: 0.3) : AppColors.textPrimary(context)),
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

// تصميم الويب والتابلت للكروت السفلية
class BottomStatsRow extends StatelessWidget {
  const BottomStatsRow({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: StatusCircleCard(isMobile: false)),
        const SizedBox(width: 16),
        Expanded(child: GaugeCardWidget(title: "نسبة مراجعة الأوراق", percent: 0.8, text: "80%", colorKey: 1, isMobile: false)), 
        const SizedBox(width: 16),
        Expanded(child: GaugeCardWidget(title: "نسبة نشر النتائج", percent: 0.6, text: "60%", colorKey: 2, isMobile: false))
      ]
    );
  }
}

class StatusCircleCard extends StatelessWidget {
  final bool isMobile;
  const StatusCircleCard({super.key, required this.isMobile});
  
  @override
  Widget build(BuildContext context) => Container(
    width: isMobile ? double.infinity : null, 
    height: 190, 
    padding: const EdgeInsets.all(20), 
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), 
    child: Column(
      children: [
        const Text("حالة نتائج الطلاب", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), 
        const Spacer(), 
        SizedBox(width: 85, height: 85, child: CircularProgressIndicator(value: 0.7, strokeWidth: 10, color: AppColors.primaryTeal(context), backgroundColor: AppColors.accentYellow(context))), 
        const Spacer(), 
        Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            _dot(AppColors.primaryTeal(context), "نجاح"), 
            const SizedBox(width: 18), 
            _dot(AppColors.accentYellow(context), "فشل")
          ]
        )
      ]
    )
  );

  Widget _dot(Color c, String t) => Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle)), const SizedBox(width: 6), Text(t, style: const TextStyle(fontSize: 11))]);
}

class GaugeCardWidget extends StatelessWidget {
  final String title; final double percent; final String text; final int colorKey; final bool isMobile;
  const GaugeCardWidget({required this.title, required this.percent, required this.text, required this.colorKey, required this.isMobile, super.key});
  
  @override
  Widget build(BuildContext context) {
    Color c = colorKey == 1 ? AppColors.primaryTeal(context) : AppColors.accentYellow(context);
    return Container(
      width: isMobile ? double.infinity : null, 
      height: 190, 
      padding: const EdgeInsets.all(20), 
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), 
      child: Column(
        children: [
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), 
          const Spacer(), 
          CustomPaint(
            size: const Size(130, 65), 
            painter: OpenArcPainter(percent: percent, color: c, background: AppColors.scaffoldBg(context)), 
            child: SizedBox(width: 130, height: 65, child: Center(child: Text(text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))))
          ), 
          const Spacer()
        ]
      )
    );
  }
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