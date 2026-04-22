// import 'package:flutter/material.dart';
// import '../core/colors.dart'; 
// import '../screens/review_exam_screen.dart'; 
// import '../screens/create_ai_exam_screen.dart'; 
// import 'package:grade/generated/l10n.dart'; // استدعاء القاموس الذكي

// class TeacherMainLayout extends StatefulWidget {
//   const TeacherMainLayout({super.key});

//   @override
//   State<TeacherMainLayout> createState() => _TeacherMainLayoutState();
// }

// class _TeacherMainLayoutState extends State<TeacherMainLayout> {
//   int selectedIndex = 1; // صفحة إنشاء الاختبار الافتراضية
//   bool isEditingGlobal = false; 

//   // قائمة أسئلة المراجعة
//   List<QuestionData> questionsList = [
//     QuestionData(
//       questionNumber: 'السؤال الأول', 
//       questionText: 'عرف قانون الجاذبية العام لنيوتن؟', 
//       type: QuestionType.essay,
//       studentTextAnswer: 'ينص قانون الجاذبية العام لنيوتن على أن أي جسمين في الكون توجد بينهما قوة تجاذب تتناسب طردياً مع حاصل ضرب كتلتيهما وعكسياً مع مربع المسافة بين مركزيهما.',
//       modelAnswer: 'ينص على أن القوة التجاذبية بين جسمين تساوي ثابت الجاذبية الأرضية في حاصل ضرب كتلتيهما على مربع المسافة بين مركزيهما.',
//       achievedGrade: '10', 
//       maxGrade: '10'
//     ),
//     QuestionData(
//       questionNumber: 'السؤال الثاني', 
//       questionText: 'هل تأثير دوبلر يحدث فقط في الموجات الصوتية؟', 
//       type: QuestionType.trueFalse,
//       studentTFAnswer: true, 
//       modelAnswer: 'خطأ (تأثير دوبلر يحدث في جميع أنواع الموجات)',
//       achievedGrade: '0', 
//       maxGrade: '10'
//     ),
//     QuestionData(
//       questionNumber: 'السؤال الثالث', 
//       questionText: 'ما هي وحدة قياس القوة في النظام الدولي؟', 
//       type: QuestionType.multipleChoice,
//       studentMCAnswer: 'Newton', 
//       modelAnswer: 'Newton',
//       achievedGrade: '10', 
//       maxGrade: '10'
//     ),
//   ];

//   int get totalAchieved {
//     double total = 0;
//     for (var q in questionsList) { total += double.tryParse(q.achievedGrade) ?? 0; }
//     return total.toInt();
//   }

//   int get totalMax {
//     double total = 0;
//     for (var q in questionsList) { total += double.tryParse(q.maxGrade) ?? 0; }
//     return total.toInt();
//   }

//   Widget _buildBody(bool isMobile, bool isTablet, bool isWeb) {
//     switch (selectedIndex) {
//       case 0: return Center(child: Text("${S.of(context).teacher_dashboard} ${S.of(context).under_development}"));
//       case 1: return const CreateExamScreen(); 
//       case 2: return Center(child: Text("${S.of(context).subjects} ${S.of(context).under_development}"));
//       case 3: return Center(child: Text("${S.of(context).grading} ${S.of(context).under_development}"));
//       case 4: 
//         return ReviewExamScreen(
//           questionsList: questionsList,
//           isEditing: isEditingGlobal,
//           onGradeChanged: (index, newGrade) => setState(() => questionsList[index].achievedGrade = newGrade),
//           onEditToggle: () => setState(() => isEditingGlobal = !isEditingGlobal),
//         );
//       case 5: return Center(child: Text("${S.of(context).settings} ${S.of(context).under_development}"));
//       default: return Center(child: Text(S.of(context).page_not_found));
//     }
//   }

//   Widget _buildHeader(BuildContext context) {
//     if (selectedIndex == 1) {
//       return Container(
//         height: 101, 
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         decoration: BoxDecoration(
//           color: AppColors.textWhite(context), 
//           borderRadius: BorderRadius.circular(16), 
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center, 
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(S.of(context).create_new_exam, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
//                 const SizedBox(height: 4),
//                 Text(S.of(context).create_exam_subtitle, style: TextStyle(fontSize: 14, color: AppColors.textSecondary(context))),
//               ],
//             ),
//           ],
//         ),
//       );
//     }

//     String subTitle;
//     switch (selectedIndex) {
//       case 0: subTitle = S.of(context).dashboard_subtitle; break;
//       case 2: subTitle = S.of(context).subjects_subtitle; break;
//       case 3: subTitle = S.of(context).grading_subtitle; break;
//       case 4: subTitle = S.of(context).review_subtitle; break;
//       case 5: subTitle = S.of(context).settings_subtitle; break;
//       default: subTitle = S.of(context).default_subtitle;
//     }

//     return Container(
//       height: 101, 
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       decoration: BoxDecoration(
//         color: AppColors.textWhite(context), 
//         borderRadius: BorderRadius.circular(16), 
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center, 
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 FittedBox(fit: BoxFit.scaleDown, child: Text(S.of(context).welcome_teacher, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)))),
//                 const SizedBox(height: 4),
//                 FittedBox(fit: BoxFit.scaleDown, child: Text(subTitle, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 14))),
//               ],
//             ),
//           ),
//           if (selectedIndex == 4)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               decoration: BoxDecoration(
//                 color: isEditingGlobal ? AppColors.accentYellow(context).withOpacity(0.1) : AppColors.scaffoldBg(context), 
//                 borderRadius: BorderRadius.circular(12), 
//                 border: Border.all(color: isEditingGlobal ? AppColors.accentYellow(context) : AppColors.primaryTeal(context).withOpacity(0.3))
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min, 
//                 children: [
//                   Text('$totalAchieved', style: TextStyle(fontSize: 28, color: AppColors.primaryTeal(context), fontWeight: FontWeight.w900)), 
//                   Text(' ${S.of(context).of_total} $totalMax', style: TextStyle(fontSize: 14, color: AppColors.textSecondary(context), fontWeight: FontWeight.bold))
//                 ]
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     bool isMobile = width < 800; 
//     bool isTablet = width >= 800 && width < 1100; 
//     bool isWeb = width >= 1100;

//     // تمت إزالة Directionality ليتكيف النظام تلقائياً مع اللغتين
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg(context),
//       appBar: isMobile ? AppBar(backgroundColor: AppColors.scaffoldBg(context), iconTheme: IconThemeData(color: AppColors.primaryTeal(context)), elevation: 0) : null,
//       drawer: isMobile ? Drawer(child: CustSidebar(selectedIndex: selectedIndex, isMobile: true, onItemSelected: (index) { setState(() => selectedIndex = index); Navigator.pop(context); })) : null,
//       body: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (!isMobile) CustSidebar(selectedIndex: selectedIndex, isTablet: isTablet, onItemSelected: (index) => setState(() => selectedIndex = index)),
//           Expanded(
//             child: Column(
//               children: [
//                 Padding(padding: EdgeInsets.all(isMobile ? 16.0 : 32.0), child: _buildHeader(context)),
//                 Expanded(child: _buildBody(isMobile, isTablet, isWeb)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ===========================================================================
// // القائمة الجانبية (CustSidebar) المتجاوبة مع LTR و RTL
// // ===========================================================================
// class CustSidebar extends StatelessWidget {
//   final int selectedIndex; 
//   final Function(int) onItemSelected;
//   final bool isTablet;
//   final bool isMobile;

//   const CustSidebar({
//     super.key, 
//     required this.selectedIndex, 
//     required this.onItemSelected,
//     this.isTablet = false,
//     this.isMobile = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bool isRtl = Directionality.of(context) == TextDirection.rtl;
//     double sidebarWidth = isTablet ? 220 : 280;

//     return Container(
//       width: sidebarWidth, 
//       height: double.infinity,
//       decoration: BoxDecoration(
//         color: AppColors.primaryTeal(context), 
//         // الحواف تنقلب بذكاء بناءً على لغة الجهاز
//         borderRadius: isMobile 
//           ? BorderRadius.zero 
//           : const BorderRadiusDirectional.only(
//               topEnd: Radius.circular(55), 
//               bottomEnd: Radius.circular(55)
//             ),
//       ),
//       child: Column(
//         children: [
//           const SizedBox(height: 30), 
//           Icon(Icons.check_circle_outline, size: 70, color: AppColors.textWhite(context)),
//           Text(S.of(context).app_name, textAlign: TextAlign.center, style: TextStyle(color: AppColors.textWhite(context), fontSize: 16)),
//           const SizedBox(height: 50),
//           Expanded(
//             child: ListView(
//               physics: const BouncingScrollPhysics(),
//               children: [
//                 _menuItem(context, S.of(context).teacher_dashboard, Icons.home_rounded, 0, isRtl), 
//                 _menuItem(context, S.of(context).exams_management, Icons.assignment_rounded, 1, isRtl),
//                 _menuItem(context, S.of(context).subjects, Icons.library_books, 2, isRtl), 
//                 _menuItem(context, S.of(context).grading, Icons.checklist_rtl_rounded, 3, isRtl),
//                 _menuItem(context, S.of(context).review, Icons.rule_rounded, 4, isRtl), 
//                 _menuItem(context, S.of(context).settings, Icons.settings_rounded, 5, isRtl),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _menuItem(BuildContext context, String title, IconData icon, int index, bool isRtl) {
//     bool isActive = selectedIndex == index; 
//     Color bgColor = AppColors.scaffoldBg(context);
//     double radius = 30.0; 

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: InkWell(
//         onTap: () => onItemSelected(index), 
//         hoverColor: Colors.transparent,
//         child: Stack(
//           clipBehavior: Clip.none, 
//           children: [
//             if (isActive) 
//               // تحديد موقع المنحنى بذكاء ليتوافق مع اللغة
//               PositionedDirectional(
//                 top: -radius, 
//                 bottom: -radius, 
//                 end: 0, 
//                 width: radius, 
//                 child: CustomPaint(painter: SidebarCurvePainter(bgColor, isRtl, radius))
//               ),
//             Container(
//               height: 60, 
//               // الهوامش تتكيف مع الاتجاه
//               margin: EdgeInsetsDirectional.only(
//                 start: isActive ? 20 : 25, 
//                 end: isActive ? 0 : 20
//               ), 
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               decoration: BoxDecoration(
//                 color: isActive ? bgColor : Colors.transparent, 
//                 borderRadius: BorderRadiusDirectional.only(
//                   topStart: const Radius.circular(30), 
//                   bottomStart: const Radius.circular(30), 
//                   topEnd: Radius.circular(isActive ? 0 : 30), 
//                   bottomEnd: Radius.circular(isActive ? 0 : 30)
//                 )
//               ),
//               child: Row(
//                 children: [
//                   Icon(icon, color: isActive ? AppColors.primaryTeal(context) : AppColors.accentYellow(context), size: isTablet ? 22 : 26), 
//                   const SizedBox(width: 15), 
//                   Expanded(
//                     child: Text(
//                       title, 
//                       style: TextStyle(
//                         fontFamily: "Arimo", 
//                         color: isActive ? AppColors.primaryTeal(context) : Colors.white, 
//                         fontSize: isTablet ? 15 : 18, 
//                         fontWeight: FontWeight.w900
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     )
//                   )
//                 ]
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ===========================================================================
// // رسّام المنحنى (Curve Painter) الذكي
// // ===========================================================================
// class SidebarCurvePainter extends CustomPainter {
//   final Color bgColor;
//   final bool isRtl;
//   final double radius;
  
//   SidebarCurvePainter(this.bgColor, this.isRtl, this.radius);
  
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()..color = bgColor..style = PaintingStyle.fill;
//     Path path = Path();
    
//     if (isRtl) {
//       // القصة تكون على اليسار
//       path.moveTo(0, 0);
//       path.quadraticBezierTo(0, radius, radius, radius);
//       path.lineTo(0, radius);
//       path.close();
      
//       path.moveTo(0, size.height);
//       path.quadraticBezierTo(0, size.height - radius, radius, size.height - radius);
//       path.lineTo(0, size.height - radius);
//       path.close();
//     } else {
//       // القصة تكون على اليمين
//       path.moveTo(size.width, 0);
//       path.quadraticBezierTo(size.width, radius, size.width - radius, radius);
//       path.lineTo(size.width, radius);
//       path.close();
      
//       path.moveTo(size.width, size.height);
//       path.quadraticBezierTo(size.width, size.height - radius, size.width - radius, size.height - radius);
//       path.lineTo(size.width, size.height - radius);
//       path.close();
//     }
    
//     canvas.drawPath(path, paint);
//   }
  
//   @override 
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }