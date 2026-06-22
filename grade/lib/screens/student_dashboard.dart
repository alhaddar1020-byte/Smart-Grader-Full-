// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:get/get.dart'; // تمت إضافة مكتبة GetX
// import '../core/controllers/student_dashboard_controller.dart'; // تأكدي من صحة مسار ملف المتحكم
// import '../core/locale_provider.dart';
// import '../core/colors.dart';
// import 'student_matearial.dart';
// import 'student_setting.dart';
// import 'student_exim.dart';
// import 'student_detiles.dart';
// import '../generated/l10n.dart';

// class StudentDashboardScreen extends StatefulWidget {
//   const StudentDashboardScreen({super.key});

//   @override
//   State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
// }

// class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
//   int selectedIndex = 0;
//   List<String> viewedExams = [];
//   String? selectedSubjectName;
//   String selectedSubject = "";
//   String? selectedExamTitle; // تم التعديل ليكون في سطر منفصل
//   final GlobalKey<ScaffoldState> _scaffoldKey =
//       GlobalKey<ScaffoldState>(); // تم إخراجه من التعليق ليعمل

//   // استدعاء المتحكم
//   final controller = Get.put(StudentDashboardController(), permanent: true);

//   @override
//   Widget build(BuildContext context) {
//     final localeProvider = Provider.of<LocaleProvider>(context);
//     final bool isArabic = localeProvider.locale.languageCode == 'ar';

//     // تغليف الشاشة بـ Obx لمراقبة التحميل والبيانات
//     return Obx(() {
//       // حالة التحميل
//       if (controller.isLoading.value) {
//         return Scaffold(
//           backgroundColor: AppColors.secondaryTeal(context),
//           body: const Center(child: CircularProgressIndicator()),
//         );
//       }

//       // حالة عدم وجود بيانات
//       if (controller.studentData.isEmpty) {
//         return Scaffold(
//           backgroundColor: AppColors.secondaryTeal(context),
//           body: const Center(child: Text("لا توجد بيانات لعرضها")),
//         );
//       }

//       // عرض الواجهة الأصلية الخاصة بك
//       return LayoutBuilder(
//         builder: (context, constraints) {
//           double width = constraints.maxWidth;
//           bool isMobile = width < 600;
//           bool isTablet = width >= 600 && width < 1100;
//           bool isWeb = width >= 1100;

//           // الهامش العام (13 للجوال و 30 للويب/تابلت)
//           double currentPadding = isMobile ? 13.0 : 30.0;
//           // قرار التمرير للإحصائيات (أقل من 900 بكسل تلتصق بالحافة)
//           bool shouldStatsScroll = width < 900;

//           return Scaffold(
//             key: _scaffoldKey,
//             backgroundColor: AppColors.secondaryTeal(context),
//             drawer: isMobile
//                 ? Drawer(
//                     width: 280,
//                     backgroundColor: Colors.transparent,
//                     child: CustSidebar(
//                       isCompact: false,
//                       selectedIndex: selectedIndex,
//                       isArabic: isArabic,
//                       onItemSelected: _handleNavigation,
//                     ),
//                   )
//                 : null,
//             body: Row(
//               children: [
//                 if (!isMobile)
//                   CustSidebar(
//                     isCompact: isTablet,
//                     selectedIndex: selectedIndex,
//                     isArabic: isArabic,
//                     onItemSelected: _handleNavigation,
//                   ),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       if (isMobile) _buildMobileTopBar(),
//                       if (!isMobile)
//                         Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(
//                             currentPadding,
//                             32,
//                             currentPadding,
//                             0,
//                           ),
//                           child: _buildHeader(context, isWeb, currentPadding),
//                         ),
//                       Expanded(
//                         child: _buildBody(
//                           isMobile,
//                           isTablet,
//                           isWeb,
//                           isArabic,
//                           shouldStatsScroll,
//                           currentPadding,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     });
//   }

//   void _handleNavigation(int index) {
//     setState(() {
//       if (index == 1) selectedSubjectName = null;
//       selectedIndex = index;
//     });
//     if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
//       _scaffoldKey.currentState?.closeDrawer();
//     }
//   }

//   Widget _buildMobileTopBar() {
//     print(
//       "====== DEBUG: selectedIndex is $selectedIndex ======",
//     ); // 👈 ضيفي هذا السطر
//     // في الهيدر، اجعلي الحالات 1 و 4 تظهر نفس العنوان
//     String subTitle;
//     if (selectedIndex == 0) {
//       subTitle = S.of(context).goodDay;
//     } else if (selectedIndex == 1 || selectedIndex == 4) {
//       subTitle = S
//           .of(context)
//           .subExplore; // سيبقى "المواد الدراسية" في الحالتين
//     } else if (selectedIndex == 5) {
//       subTitle = S.of(context).subExam;
//     } else if (selectedIndex == 2) {
//       subTitle = S.of(context).subSettings;
//     } else {
//       subTitle = S.of(context).appName;
//     }
//     return Container(
//       height: 80,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: AppColors.cardBg(context),
//         borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.menu, color: Color(0xFF636262), size: 30),
//             onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 S
//                     .of(context)
//                     .welcome(
//                       (controller.studentData["name"] ?? "").split(' ')[0],
//                     ),
//                 style: TextStyle(
//                   color: AppColors.textPrimary(context),
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 300),
//                 child: Text(
//                   subTitle,
//                   key: ValueKey(subTitle),
//                   style: TextStyle(
//                     color: AppColors.textSecondary(context),
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBody(
//     bool isMobile,
//     bool isTablet,
//     bool isWeb,
//     bool isArabic,
//     bool shouldStatsScroll,
//     double contentPadding,
//   ) {
//     switch (selectedIndex) {
//       case 0:
//         return SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           child: _buildDashboardHome(
//             isMobile,
//             isTablet,
//             isArabic,
//             shouldStatsScroll,
//             contentPadding,
//           ),
//         );

//       case 1: // شاشة قائمة المواد (المربعات)
//         return SubjectsScreen(
//           subjectName: "",
//           onBack: () => setState(() => selectedIndex = 0),
//           onSubjectTap: (name) => setState(() {
//             selectedSubjectName = name;
//             selectedExamTitle = null; // تصفير أي اختبار قديم
//             selectedIndex = 4; // <--- تأكدي أنها 4 (تفاصيل المادة) وليست 5
//           }),
//         );

//       case 4: // شاشة تفاصيل المادة (التي فيها قائمة الاختبارات)
//         return SubjectDetailsScreen(
//           subjectName: selectedSubjectName ?? "",
//           onBack: () => setState(() => selectedIndex = 1),
//           onExamTap: (subject, exam) => setState(() {
//             selectedSubjectName = subject;
//             selectedExamTitle = exam; // حفظ اسم الاختبار
//             selectedIndex = 5; // <--- هنا فقط نذهب لـ 5 (شاشة الاختبار)
//           }),
//         );

//       case 5: // شاشة تصحيح الاختبار التفصيلية
//         // كود الحماية (تأكدي أنه مكتوب بهذا الشكل البسيط)
//         if (selectedExamTitle == null || selectedExamTitle!.isEmpty) {
//           return const Center(child: Text("خطأ: لم يتم اختيار اختبار"));
//         }

//         return StudentExamScreen(
//           subjectName: selectedSubjectName ?? "",
//           examTitle: selectedExamTitle!,
//           onBack: () => setState(() => selectedIndex = 4), // يرجع للتفاصيل
//           onItemSelected: _handleNavigation,
//         );

//         return StudentExamScreen(
//           subjectName: selectedSubjectName ?? "",
//           examTitle: selectedExamTitle!, // هنا نحن متأكدين 100% أن الاسم موجود
//           onBack: () => setState(() => selectedIndex = 4),
//           onItemSelected: _handleNavigation,
//         );

//       case 2:
//         return const SettingsScreen();

//       default:
//         return Center(child: Text(S.of(context).pageNotFound));
//     }
//   }

//   Widget _buildDashboardHome(
//     bool isMobile,
//     bool isTablet,
//     bool isArabic,
//     bool shouldStatsScroll,
//     double contentPadding,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // الإحصائيات: تلتصق بالحافة (0) في وضع التمرير
//         _buildTopStatsGrid(
//           context,
//           isMobile,
//           isTablet,
//           shouldStatsScroll,
//           contentPadding,
//         ),

//         const SizedBox(height: 15),

//         // المحتوى الباقي: يلتزم بالهامش (13 للجوال و 30 للويب)
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: contentPadding),
//           child: isMobile
//               ? Column(
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildPerformanceCard(
//                             context,
//                             controller.studentData["performance"],
//                             isSmall: true,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: _questionsMasteredCard(
//                             controller.studentData["performance"] ?? {},
//                             true, // هنا isSmall = true للجوال
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 15),
//                     _buildMainResultsList(isMobile: true),
//                   ],
//                 )
//               : Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildMainResultsList(isMobile: false),
//                     const SizedBox(width: 32),
//                     Expanded(
//                       flex: 1,
//                       child: Column(
//                         children: [
//                           _questionsMasteredCard(
//                             controller.studentData["performance"] ?? {},
//                             isTablet, // هنا المتغير يعتمد على حجم الشاشة
//                           ),
//                           const SizedBox(height: 20),
//                           _buildPerformanceCard(
//                             context,
//                             controller.studentData["performance"],
//                             isSmall: isTablet,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTopStatsGrid(
//     BuildContext context,
//     bool isMobile,
//     bool isTablet,
//     bool shouldScroll,
//     double contentPadding,
//   ) {
//     var stats = controller.studentData["stats"];
//     var children = [
//       _statCard(
//         S.of(context).statMaterials,
//         stats["subjects_count"].toString(),
//         Icons.book,
//         AppColors.accentYellow(context),
//         isTablet,
//       ),
//       _statCard(
//         S.of(context).statExams,
//         stats["exams_count"].toString(),
//         Icons.assignment,
//         AppColors.primaryTeal(context),
//         isTablet,
//       ),
//       _statCard(
//         S.of(context).statAverage,
//         stats["gpa"].toString(),
//         Icons.trending_up,
//         AppColors.primaryTeal(context),
//         isTablet,
//       ),
//       _statCard(
//         S.of(context).statHighScore,
//         stats["highest_score"].toString(),
//         Icons.military_tech,
//         AppColors.primaryTeal(context),
//         isTablet,
//       ),
//     ];

//     if (shouldScroll) {
//       return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         physics: const BouncingScrollPhysics(),
//         padding: EdgeInsetsDirectional.only(
//           start: contentPadding,
//           end: 0,
//         ), // تلتصق بالنهاية
//         child: Row(
//           children: children
//               .map(
//                 (card) => Container(
//                   width: MediaQuery.of(context).size.width < 400 ? 140 : 180,
//                   margin: const EdgeInsetsDirectional.only(end: 12),
//                   child: card,
//                 ),
//               )
//               .toList(),
//         ),
//       );
//     }

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: contentPadding),
//       child: Row(
//         children: children
//             .map(
//               (card) => Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 6),
//                   child: card,
//                 ),
//               ),
//             )
//             .toList(),
//       ),
//     );
//   }

//   Widget _statCard(
//     String title,
//     String value,
//     IconData icon,
//     Color color,
//     bool isTablet,
//   ) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 8 : 10),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: Colors.white, size: isTablet ? 18 : 25),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           FittedBox(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 22,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context, bool isWeb, double contentPadding) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     bool isSmallScreen = screenWidth < 1100;
//     String subTitle;
//     if (selectedIndex == 0) {
//       subTitle = S.of(context).goodDay;
//     } else if (selectedIndex == 1 || selectedIndex == 4) {
//       subTitle = S.of(context).subExplore;
//     } else if (selectedIndex == 5) {
//       subTitle = S.of(context).subExam;
//     } else if (selectedIndex == 2) {
//       subTitle = S.of(context).subSettings;
//     } else {
//       subTitle = S.of(context).appName;
//     }

//     return Container(
//       height: 101,
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       decoration: BoxDecoration(
//         color: AppColors.cardBg(context),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 S
//                     .of(context)
//                     .welcome(
//                       (controller.studentData["name"] ?? "").split(' ')[0],
//                     ),
//                 style: TextStyle(
//                   fontSize: isSmallScreen ? 18 : 22,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textPrimary(context),
//                 ),
//               ),
//               Text(
//                 subTitle,
//                 style: TextStyle(
//                   color: AppColors.textSecondary(context),
//                   fontSize: isSmallScreen ? 12 : 14,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     controller.studentData["name"] ?? "",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: isSmallScreen ? 10 : 16,
//                       color: AppColors.textPrimary(context),
//                     ),
//                   ),
//                   Text(
//                     controller.studentData["level"] ?? "",
//                     style: TextStyle(
//                       color: AppColors.textSecondary(context),
//                       fontSize: isSmallScreen ? 8 : 12,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(width: 12),
//               CircleAvatar(
//                 radius: isSmallScreen ? 18 : 20,
//                 backgroundColor: AppColors.primaryTeal(context),
//                 child: const Icon(Icons.person, color: Colors.white, size: 22),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMainResultsList({required bool isMobile}) {
//     List results = controller.studentData["recent_results"] ?? [];
//     return Expanded(
//       flex: isMobile ? 0 : 3,
//       child: Container(
//         padding: const EdgeInsets.all(22),
//         decoration: BoxDecoration(
//           color: AppColors.cardBg(context),
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   S.of(context).recentResults,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () => setState(() => selectedIndex = 1),
//                   child: Text(S.of(context).viewAll),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 15),
//             ...results.map((r) => _resultItem(r)).toList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _resultItem(Map data) {
//     // 1. نسحب رقم الاختبار من البيانات
//     String examId = data["id"]?.toString() ?? "";

//     return InkWell(
//       onTap: () {
//         // 🔴 استدعاء دالة الحفظ الدائم عشان المتصفح يتذكر
//         controller.markExamAsViewed(examId);

//         // كودك الأصلي للانتقال بدون أي تغيير
//         setState(() {
//           selectedSubjectName = data["subject"];
//           selectedIndex = 4;
//         });
//       },
//       borderRadius: BorderRadius.circular(18),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 15),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: AppColors.scaffoldBg(context).withOpacity(0.5),
//           borderRadius: BorderRadius.circular(18),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // 🔴 التعديل الوحيد هنا: غلفنا النقطة والنصوص بـ Obx عشان تتحدث فوراً
//             Obx(() {
//               // ننقل الشرط هنا داخل الـ Obx عشان يراقب التغيير لحظة بلحظة
//               bool isNew =
//                   examId.isNotEmpty && !controller.viewedExams.contains(examId);

//               return Row(
//                 children: [
//                   // النقطة تظهر فقط إذا كان الاختبار جديد
//                   if (isNew) ...[
//                     Container(
//                       width: 10,
//                       height: 10,
//                       decoration: const BoxDecoration(
//                         color: Colors.blue, // لون نقطتك
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 12), // مسافة بين النقطة والنص
//                   ],

//                   // عمود النصوص حقك زي ما هو بالضبط ما لمسته
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         data["title"] ?? "",
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         data["subject"] ?? "",
//                         style: const TextStyle(
//                           color: Colors.grey,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               );
//             }),

//             // عمود الدرجات حقك زي ما هو بالضبط ما لمسته
//             Column(
//               children: [
//                 Text(
//                   data["total_earned_mark"] ?? "",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//                 Text(
//                   data["label"] ?? "",
//                   style: const TextStyle(color: Colors.blue, fontSize: 11),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _questionsMasteredCard(Map performanceData, bool isSmall) {
//     // استخراج الرقم
//     final String mastered = performanceData["questions_mastered"] ?? "0";

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(isSmall ? 10 : 20),
//       decoration: BoxDecoration(
//         color: AppColors.cardBg(context), // نفس خلفية الكارد القديم بالضبط
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // 1. الأيقونة الفخمة
//           Container(
//             padding: EdgeInsets.all(isSmall ? 10 : 16),
//             decoration: BoxDecoration(
//               color: AppColors.accentYellow(
//                 context,
//               ).withOpacity(0.1), // خلفية شفافة هادية
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.verified_rounded, // أيقونة إنجاز رسمية وجميلة
//               color: AppColors.accentYellow(context),
//               size: isSmall ? 20 : 36,
//             ),
//           ),
//           const SizedBox(height: 12),

//           // 2. العنوان
//           Text(
//             S.of(context).questionsMasteredTitle, // 👈 التعديل الأول
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: isSmall ? 12 : 16,
//               color: AppColors.textPrimary(context),
//             ),
//           ),
//           const SizedBox(height: 6),

//           // 3. الرقم البارز (إعطاء الطالب شعور بالإنجاز)
//           Text(
//             S.of(context).correctAnswersCount(mastered),
//             textAlign:
//                 TextAlign.center, // 👈 هذا هو السطر السحري اللي يوسط النص
//             style: TextStyle(
//               color: AppColors.accentYellow(context),
//               fontSize: isSmall ? 14 : 17,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 4),

//           // 4. نص تشجيعي صغير
//           Text(
//             S.of(context).throughoutYourJourney, // 👈 التعديل الثالث
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: AppColors.textSecondary(context),
//               fontSize: isSmall ? 10 : 13,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPerformanceCard(
//     BuildContext context,
//     Map<String, dynamic>? perf, {
//     bool isSmall = false,
//   }) {
//     // 1. جلب القيم بالأسماء الصحيحة والدقيقة القادمة من البايثون
//     final String gradedExams =
//         perf?["graded_exams"] ?? "0"; // الاختبارات الناجح فيها
//     final String totalExams =
//         perf?["total_exams"] ?? "0"; // إجمالي الاختبارات المصححة طوال السنة
//     final String successRate = perf?["success_rate"] ?? "0%";

//     // 2. دمجهم بالطريقة التي تحبينها لتظهر بالواجهة (مثلاً: 4 / 5)
//     final String examsRatio = "$gradedExams / $totalExams";

//     // 3. حساب النسبة لشريط التحميل مباشرة بالأرقام دون الحاجة لتقطيع النصوص
//     double progress = 0.0;
//     try {
//       double passed = double.parse(gradedExams);
//       double total = double.parse(totalExams);
//       if (total > 0) {
//         progress = passed / total;
//       }
//     } catch (_) {}

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(isSmall ? 12 : 20),
//       decoration: BoxDecoration(
//         color: AppColors.primaryTeal(context),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           Align(
//             alignment: AlignmentDirectional.centerStart,
//             child: Text(
//               S.of(context).performanceSummary,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: isSmall ? 12 : 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),

//           // 4. استبدال نص المواد المصححة بنص ثابت وواضح وهو "الاختبارات المجتازة"
//           _rowInfoDesign(S.of(context).passing, examsRatio, isSmall),
//           const SizedBox(height: 16),
//           _buildResponsiveProgressBar(progress, isSmall),
//           const SizedBox(height: 16),
//           _rowInfoDesign(S.of(context).successRate, successRate, isSmall),
//         ],
//       ),
//     );
//   }

//   Widget _rowInfoDesign(String label, String value, bool isSmall) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(color: Colors.white, fontSize: isSmall ? 9 : 14),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: isSmall ? 12 : 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildResponsiveProgressBar(double progress, bool isSmall) {
//     return Stack(
//       children: [
//         Container(
//           height: isSmall ? 6 : 8,
//           decoration: BoxDecoration(
//             color: Colors.white24,
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         FractionallySizedBox(
//           widthFactor: progress.clamp(0.0, 1.0),
//           child: Container(
//             height: isSmall ? 6 : 8,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // # 1. إضافة إعدادات المشروع وملفات الترجمة فقط
// // git add pubspec.yaml pubspec.lock
// // git add lib/l10n/
// // git add lib/generated/

// // # 2. كتابة رسالة توضح الهدف
// // git commit -m "setup: implement Flutter Intl localization system and ARB files"

// // # 3. الرفع للمستودع
// // git push origin [اسم_الفرع_حقك]

// class CustSidebar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemSelected;
//   final bool isCompact;
//   final bool isArabic;

//   const CustSidebar({
//     super.key,
//     required this.selectedIndex,
//     required this.onItemSelected,
//     required this.isCompact,
//     required this.isArabic,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bool isMobile = MediaQuery.of(context).size.width < 600;
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       width: isCompact ? 110 : 280,
//       decoration: BoxDecoration(
//         color: AppColors.primaryTeal(context),
//         borderRadius: BorderRadiusDirectional.only(
//           topEnd: Radius.circular(isMobile ? 0 : 55),
//           bottomEnd: Radius.circular(isMobile ? 0 : 55),
//         ),
//       ),
//       child: Column(
//         children: [
//           _buildLogoSection(context, isCompact),
//           const SizedBox(height: 20),
//           _menuItem(
//             context,
//             S.of(context).sidebarHome,
//             Icons.home_rounded,
//             0,
//             isMobile,
//           ),
//           _menuItem(
//             context,
//             S.of(context).sidebarMaterials,
//             Icons.library_books,
//             1,
//             isMobile,
//           ),
//           _menuItem(
//             context,
//             S.of(context).sidebarSettings,
//             Icons.settings_rounded,
//             2,
//             isMobile,
//           ),
//           const Spacer(),
//         ],
//       ),
//     );
//   }

//   Widget _menuItem(
//     BuildContext context,
//     String title,
//     IconData icon,
//     int index,
//     bool isMobile,
//   ) {
//     // التعديل هنا: أضفنا رقم 5 ليكون زر المواد (index 1) نشطاً في حالات العرض المختلفة للمواد
//     // السطر المطلوب تعديله:
//     bool isActive =
//         (selectedIndex == index) ||
//         (index == 1 && (selectedIndex == 4 || selectedIndex == 5));

//     Color activeBg = AppColors.secondaryTeal(context);

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: InkWell(
//         onTap: () => onItemSelected(index),
//         child: Stack(
//           alignment: AlignmentDirectional.centerStart,
//           clipBehavior: Clip.none,
//           children: [
//             if (isActive && !isMobile)
//               PositionedDirectional(
//                 end: -1,
//                 top: -38,
//                 bottom: -38,
//                 width: 50,
//                 child: CustomPaint(
//                   painter: SidebarCurvePainter(activeBg, isArabic),
//                 ),
//               ),
//             Container(
//               height: 60,
//               margin: EdgeInsetsDirectional.only(
//                 end: isMobile ? 12 : (isActive ? 0 : 25),
//                 start: isCompact ? 10 : 20,
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               decoration: BoxDecoration(
//                 color: isActive ? activeBg : Colors.transparent,
//                 borderRadius: BorderRadiusDirectional.horizontal(
//                   start: const Radius.circular(30),
//                   end: Radius.circular(isActive && !isMobile ? 0 : 30),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: isCompact
//                     ? MainAxisAlignment.center
//                     : MainAxisAlignment.start,
//                 children: [
//                   Icon(icon, color: const Color(0xFFF6AD55), size: 30),
//                   if (!isCompact) ...[
//                     const SizedBox(width: 15),
//                     Expanded(
//                       child: Text(
//                         title,
//                         style: TextStyle(
//                           color: isActive
//                               ? AppColors.primaryTeal(context)
//                               : Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLogoSection(BuildContext context, bool isCompact) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 40, bottom: 30),
//       child: Column(
//         children: [
//           Image.asset(
//             'assets/emaige/logo.png',
//             height: isCompact ? 70 : 110,
//             width: isCompact ? 70 : 110,
//             fit: BoxFit.contain,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SidebarCurvePainter extends CustomPainter {
//   final Color bgColor;
//   final bool isArabic;
//   SidebarCurvePainter(this.bgColor, this.isArabic);

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = bgColor
//       ..style = PaintingStyle.fill;
//     double radius = 35;
//     double topY = 38;
//     double bottomY = topY + 60;
//     double startX = isArabic ? 0 : size.width;
//     double curveControlX = isArabic ? size.width : 0;

//     Path pathTop = Path();
//     pathTop.moveTo(startX, topY - radius);
//     pathTop.quadraticBezierTo(startX, topY, curveControlX, topY);
//     pathTop.lineTo(startX, topY);
//     pathTop.close();
//     canvas.drawPath(pathTop, paint);

//     Path pathBottom = Path();
//     pathBottom.moveTo(startX, bottomY + radius);
//     pathBottom.quadraticBezierTo(startX, bottomY, curveControlX, bottomY);
//     pathBottom.lineTo(startX, bottomY);
//     pathBottom.close();
//     canvas.drawPath(pathBottom, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }

// // # 1. إضافة إعدادات المشروع وملفات الترجمة فقط
// // git add pubspec.yaml pubspec.lock
// // git add lib/l10n/
// // git add lib/generated/

// // # 2. كتابة رسالة توضح الهدف
// // git commit -m "setup: implement Flutter Intl localization system and ARB files"

// // # 3. الرفع للمستودع
// // git push origin [اسم_الفرع_حقك]

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/student_dashboard_controller.dart';
import '../core/locale_provider.dart';
import '../core/colors.dart';
import 'student_matearial.dart';
import 'student_setting.dart';
import 'student_exim.dart';
import 'student_detiles.dart';
import '../generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int selectedIndex = 0;
  String? selectedSubjectName;
  String selectedSubject = "";
  String? selectedExamTitle;
  int? selectedExamId; // 👈 🚨 تأكدي مليون بالمية إن هذا السطر موجود هنا!
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // @override
  // void initState() {
  //   super.initState();

  //   // استخدام addPostFrameCallback لضمان أن الواجهة جاهزة
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     final prefs = await SharedPreferences.getInstance();

  //     // 1. نقرأ الرقم المحفوظ
  //     final int? savedId = prefs.getInt('user_id');

  //     print(
  //       "🔎 قراءة رقم الطالب من الذاكرة: $savedId",
  //     ); // 👈 شوفي التيرمنال إيش يقول هنا

  //     if (savedId != null) {
  //       // 2. إذا وجدنا الرقم المحفوظ، نستخدمه
  //       final dashController = context.read<StudentDashboardController>();
  //       dashController.initController(savedId, context: context);
  //     } else {
  //       // 3. إذا لم يوجد رقم (أول مرة أو خطأ)، لا تجلبي بيانات الطالب 1، بل انتظر أو اطلبي تسجيل الدخول
  //       print("⚠️ تحذير: لا يوجد رقم طالب محفوظ في الذاكرة!");
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return; // 🌟 حماية 1
      final prefs = await SharedPreferences.getInstance();

      if (!mounted) return; // 🌟 حماية 2 (مهمة جداً بعد الـ await)
      final int? savedId = prefs.getInt('user_id');
      if (savedId != null) {
        final dashController = context.read<StudentDashboardController>();
        dashController.initController(savedId, context: context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final controller = context
        .watch<
          StudentDashboardController
        >(); // 🌟 استدعاء Provider بدلاً من GetX
    final bool isArabic = localeProvider.locale.languageCode == 'ar';

    // 1. حالة التحميل
    if (controller.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.secondaryTeal(context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // 2. حالة عدم وجود بيانات
    if (controller.studentData.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.secondaryTeal(context),
        body: const Center(child: Text("لا توجد بيانات لعرضها")),
      );
    }

    // 3. عرض الواجهة الأصلية الخاصة بكِ
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        bool isMobile = width < 600;
        bool isTablet = width >= 600 && width < 1100;
        bool isWeb = width >= 1100;

        double currentPadding = isMobile ? 13.0 : 30.0;
        bool shouldStatsScroll = width < 900;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.secondaryTeal(context),
          drawer: isMobile
              ? Drawer(
                  width: 280,
                  backgroundColor: Colors.transparent,
                  child: CustSidebar(
                    isCompact: false,
                    selectedIndex: selectedIndex,
                    isArabic: isArabic,
                    onItemSelected: _handleNavigation,
                  ),
                )
              : null,
          body: Row(
            children: [
              if (!isMobile)
                CustSidebar(
                  isCompact: isTablet,
                  selectedIndex: selectedIndex,
                  isArabic: isArabic,
                  onItemSelected: _handleNavigation,
                ),
              Expanded(
                child: Column(
                  children: [
                    if (isMobile) _buildMobileTopBar(controller),
                    if (!isMobile)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          currentPadding,
                          32,
                          currentPadding,
                          0,
                        ),
                        child: _buildHeader(
                          context,
                          isWeb,
                          currentPadding,
                          controller,
                        ),
                      ),
                    Expanded(
                      child: _buildBody(
                        isMobile,
                        isTablet,
                        isWeb,
                        isArabic,
                        shouldStatsScroll,
                        currentPadding,
                        controller,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleNavigation(int index) {
    setState(() {
      if (index == 1) selectedSubjectName = null;
      selectedIndex = index;
    });
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      _scaffoldKey.currentState?.closeDrawer();
    }
  }

  Widget _buildMobileTopBar(StudentDashboardController controller) {
    String subTitle;
    if (selectedIndex == 0) {
      subTitle = S.of(context).goodDay;
    } else if (selectedIndex == 1 || selectedIndex == 4) {
      subTitle = S.of(context).subExplore;
    } else if (selectedIndex == 5) {
      subTitle = S.of(context).subExam;
    } else if (selectedIndex == 2) {
      subTitle = S.of(context).subSettings;
    } else {
      subTitle = S.of(context).appName;
    }
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF636262), size: 30),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S
                    .of(context)
                    .welcome(
                      (controller.studentData["name"] ?? "").split(' ')[0],
                    ),
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  subTitle,
                  key: ValueKey(subTitle),
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildBody(
  //   bool isMobile,
  //   bool isTablet,
  //   bool isWeb,
  //   bool isArabic,
  //   bool shouldStatsScroll,
  //   double contentPadding,
  //   StudentDashboardController controller,
  // ) {
  //   switch (selectedIndex) {
  //     case 0:
  //       return SingleChildScrollView(
  //         padding: const EdgeInsets.symmetric(vertical: 16),
  //         child: _buildDashboardHome(
  //           isMobile,
  //           isTablet,
  //           isArabic,
  //           shouldStatsScroll,
  //           contentPadding,
  //           controller,
  //         ),
  //       );

  //     case 1:
  //       return SubjectsScreen(
  //         subjectName: "",
  //         onBack: () => setState(() => selectedIndex = 0),
  //         onSubjectTap: (name) => setState(() {
  //           selectedSubjectName = name;
  //           selectedExamTitle = null;
  //           selectedIndex = 4;
  //         }),
  //       );

  //     case 4:
  //       return SubjectDetailsScreen(
  //         subjectName: selectedSubjectName ?? "",
  //         onBack: () => setState(() => selectedIndex = 1),
  //         onExamTap: (subject, exam) => setState(() {
  //           selectedSubjectName = subject;
  //           selectedExamTitle = exam;
  //           selectedIndex = 5;
  //         }),
  //       );

  //     case 5:
  //       if (selectedExamTitle == null || selectedExamTitle!.isEmpty) {
  //         return const Center(child: Text("خطأ: لم يتم اختيار اختبار"));
  //       }
  //       return StudentExamScreen(
  //         subjectName: selectedSubjectName ?? "",
  //         examTitle: selectedExamTitle!,
  //         onBack: () => setState(() => selectedIndex = 4),
  //         onItemSelected: _handleNavigation,
  //       );

  //     case 2:
  //       return const SettingsScreen();

  //     default:
  //       return Center(child: Text(S.of(context).pageNotFound));
  //   }
  // }

  Widget _buildBody(
    bool isMobile,
    bool isTablet,
    bool isWeb,
    bool isArabic,
    bool shouldStatsScroll,
    double contentPadding,
    StudentDashboardController controller,
  ) {
    switch (selectedIndex) {
      case 0:
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: _buildDashboardHome(
            isMobile,
            isTablet,
            isArabic,
            shouldStatsScroll,
            contentPadding,
            controller,
          ),
        );

      case 1:
        return SubjectsScreen(
          subjectName: "",
          onBack: () => setState(() => selectedIndex = 0),
          onSubjectTap: (name) => setState(() {
            selectedSubjectName = name;
            selectedExamTitle = null;
            selectedExamId = null;
            selectedIndex = 4;
          }),
        );

      case 4:
        return SubjectDetailsScreen(
          subjectName: selectedSubjectName ?? "",
          onBack: () => setState(() => selectedIndex = 1),
          // ✅ حل الخطأ الأول: أضفنا examId هنا ليستقبل الـ 3 قيم
          onExamTap: (subject, examTitle, examId) => setState(() {
            selectedSubjectName = subject;
            selectedExamTitle = examTitle;
            selectedExamId = examId;
            selectedIndex = 5;
          }),
        );

      case 5:
        if (selectedExamTitle == null ||
            selectedExamTitle!.isEmpty ||
            selectedExamId == null) {
          return const Center(child: Text("خطأ: لم يتم اختيار اختبار"));
        }
        return StudentExamScreen(
          subjectName: selectedSubjectName ?? "",
          examTitle: selectedExamTitle!,
          // ✅ حل الخطأ الثاني: أرسلنا الـ examId للشاشة لكي تختفي رسالة النقص
          examId: selectedExamId!,
          onBack: () => setState(() => selectedIndex = 4),
          onItemSelected: _handleNavigation,
        );

      case 2:
        return const SettingsScreen();

      default:
        return Center(child: Text(S.of(context).pageNotFound));
    }
  }

  Widget _buildDashboardHome(
    bool isMobile,
    bool isTablet,
    bool isArabic,
    bool shouldStatsScroll,
    double contentPadding,
    StudentDashboardController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopStatsGrid(
          context,
          isMobile,
          isTablet,
          shouldStatsScroll,
          contentPadding,
          controller,
        ),
        const SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: contentPadding),
          child: isMobile
              ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildPerformanceCard(
                            context,
                            controller.studentData["performance"],
                            isSmall: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _questionsMasteredCard(
                            controller.studentData["performance"] ?? {},
                            true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildMainResultsList(
                      isMobile: true,
                      controller: controller,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainResultsList(
                      isMobile: false,
                      controller: controller,
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _questionsMasteredCard(
                            controller.studentData["performance"] ?? {},
                            isTablet,
                          ),
                          const SizedBox(height: 20),
                          _buildPerformanceCard(
                            context,
                            controller.studentData["performance"],
                            isSmall: isTablet,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildTopStatsGrid(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    bool shouldScroll,
    double contentPadding,
    StudentDashboardController controller,
  ) {
    var stats = controller.studentData["stats"] ?? {};
    var children = [
      _statCard(
        S.of(context).statMaterials,
        stats["subjects_count"]?.toString() ?? "0",
        Icons.book,
        AppColors.accentYellow(context),
        isTablet,
      ),
      _statCard(
        S.of(context).statExams,
        stats["exams_count"]?.toString() ?? "0",
        Icons.assignment,
        AppColors.primaryTeal(context),
        isTablet,
      ),
      _statCard(
        S.of(context).statAverage,
        stats["gpa"]?.toString() ?? "0",
        Icons.trending_up,
        AppColors.primaryTeal(context),
        isTablet,
      ),
      _statCard(
        S.of(context).statHighScore,
        stats["highest_score"]?.toString() ?? "0",
        Icons.military_tech,
        AppColors.primaryTeal(context),
        isTablet,
      ),
    ];

    if (shouldScroll) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsetsDirectional.only(start: contentPadding, end: 0),
        child: Row(
          children: children
              .map(
                (card) => Container(
                  width: MediaQuery.of(context).size.width < 400 ? 140 : 180,
                  margin: const EdgeInsetsDirectional.only(end: 12),
                  child: card,
                ),
              )
              .toList(),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: contentPadding),
      child: Row(
        children: children
            .map(
              (card) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: card,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 8 : 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: isTablet ? 18 : 25),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isWeb,
    double contentPadding,
    StudentDashboardController controller,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth < 1100;
    String subTitle;
    if (selectedIndex == 0) {
      subTitle = S.of(context).goodDay;
    } else if (selectedIndex == 1 || selectedIndex == 4) {
      subTitle = S.of(context).subExplore;
    } else if (selectedIndex == 5) {
      subTitle = S.of(context).subExam;
    } else if (selectedIndex == 2) {
      subTitle = S.of(context).subSettings;
    } else {
      subTitle = S.of(context).appName;
    }

    return Container(
      height: 101,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S
                    .of(context)
                    .welcome(
                      (controller.studentData["name"] ?? "").split(' ')[0],
                    ),
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              Text(
                subTitle,
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: isSmallScreen ? 12 : 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    controller.studentData["name"] ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 10 : 16,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  Text(
                    controller.studentData["level"] ?? "",
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: isSmallScreen ? 8 : 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: isSmallScreen ? 18 : 20,
                backgroundColor: AppColors.primaryTeal(context),
                child: const Icon(Icons.person, color: Colors.white, size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainResultsList({
    required bool isMobile,
    required StudentDashboardController controller,
  }) {
    List results = controller.studentData["recent_results"] ?? [];

    // 1. نفصل المحتوى في متغير لحاله
    Widget content = Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).recentResults,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => setState(() => selectedIndex = 1),
                child: Text(S.of(context).viewAll),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...results.map((r) => _resultItem(r, controller)).toList(),
        ],
      ),
    );

    // 🌟 2. الحل السحري: إذا كانت الشاشة جوال (بسبب وجود Scroll) نمنع استخدام Expanded تماماً!
    // نستخدمه فقط في شاشات الويب لأنها تستخدم Row.
    return isMobile ? content : Expanded(flex: 3, child: content);
  }

  Widget _resultItem(Map data, StudentDashboardController controller) {
    String examIdStr = data["id"]?.toString() ?? "0";
    int safeExamId = int.tryParse(examIdStr) ?? 0;

    // 🌟 التعديل السحري الأول: النقطة صارت تقرأ من الداتا بيس مباشرة
    // إذا الداتا بيس أرسلت false (يعني النتيجة جديدة)، تظهر النقطة
    // إذا كانت القيمة false أو null (غير موجودة)، نعتبرها نتيجة جديدة ونعرض النقطة
    bool isNew = data["is_read"] == false || data["is_read"] == null;
    return InkWell(
      onTap: () {
        if (safeExamId <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('خطأ: رقم الاختبار مفقود من السيرفر!'),
            ),
          );
          return;
        }

        // 🌟 التعديل السحري الثاني: إرسال الطلب للباك إند لتوثيق القراءة
        controller.markAsRead(safeExamId);

        setState(() {
          // إخفاء النقطة محلياً فوراً عشان تجربة المستخدم تكون سريعة
          data["is_read"] = true;

          selectedSubjectName = data['subject'];
          selectedExamTitle = data['title'];
          selectedExamId = safeExamId;
          selectedIndex = 5;
        });
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg(context).withOpacity(0.5),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (isNew) ...[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data["title"] ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          data["subject"] ?? "",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                Text(
                  data["total_earned_mark"]?.toString() ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  data["label"] ?? "",
                  style: const TextStyle(color: Colors.blue, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _questionsMasteredCard(Map performanceData, bool isSmall) {
    final String mastered = performanceData["questions_mastered"] ?? "0";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmall ? 10 : 20),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(isSmall ? 10 : 16),
            decoration: BoxDecoration(
              color: AppColors.accentYellow(context).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_rounded,
              color: AppColors.accentYellow(context),
              size: isSmall ? 20 : 36,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            S.of(context).questionsMasteredTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isSmall ? 12 : 16,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            S.of(context).correctAnswersCount(mastered),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.accentYellow(context),
              fontSize: isSmall ? 14 : 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            S.of(context).throughoutYourJourney,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: isSmall ? 10 : 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(
    BuildContext context,
    Map<String, dynamic>? perf, {
    bool isSmall = false,
  }) {
    final String gradedExams = perf?["graded_exams"]?.toString() ?? "0";
    final String totalExams = perf?["total_exams"]?.toString() ?? "0";
    final String successRate = perf?["success_rate"]?.toString() ?? "0%";

    final String examsRatio = "$gradedExams / $totalExams";

    double progress = 0.0;
    try {
      double passed = double.parse(gradedExams);
      double total = double.parse(totalExams);
      if (total > 0) {
        progress = passed / total;
      }
    } catch (_) {}

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmall ? 12 : 20),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              S.of(context).performanceSummary,
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmall ? 12 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _rowInfoDesign(S.of(context).passing, examsRatio, isSmall),
          const SizedBox(height: 16),
          _buildResponsiveProgressBar(progress, isSmall),
          const SizedBox(height: 16),
          _rowInfoDesign(S.of(context).successRate, successRate, isSmall),
        ],
      ),
    );
  }

  Widget _rowInfoDesign(String label, String value, bool isSmall) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: isSmall ? 9 : 14),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmall ? 12 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildResponsiveProgressBar(double progress, bool isSmall) {
    return Stack(
      children: [
        Container(
          height: isSmall ? 6 : 8,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0),
          child: Container(
            height: isSmall ? 6 : 8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

class CustSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool isCompact;
  final bool isArabic;

  const CustSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.isCompact,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isCompact ? 110 : 280,
      decoration: BoxDecoration(
        color: AppColors.primaryTeal(context),
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(isMobile ? 0 : 55),
          bottomEnd: Radius.circular(isMobile ? 0 : 55),
        ),
      ),
      child: Column(
        children: [
          _buildLogoSection(context, isCompact),
          const SizedBox(height: 20),
          _menuItem(
            context,
            S.of(context).sidebarHome,
            Icons.home_rounded,
            0,
            isMobile,
          ),
          _menuItem(
            context,
            S.of(context).sidebarMaterials,
            Icons.library_books,
            1,
            isMobile,
          ),
          _menuItem(
            context,
            S.of(context).sidebarSettings,
            Icons.settings_rounded,
            2,
            isMobile,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    String title,
    IconData icon,
    int index,
    bool isMobile,
  ) {
    bool isActive =
        (selectedIndex == index) ||
        (index == 1 && (selectedIndex == 4 || selectedIndex == 5));
    Color activeBg = AppColors.secondaryTeal(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () => onItemSelected(index),
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          clipBehavior: Clip.none,
          children: [
            if (isActive && !isMobile)
              PositionedDirectional(
                end: -1,
                top: -38,
                bottom: -38,
                width: 50,
                child: CustomPaint(
                  painter: SidebarCurvePainter(activeBg, isArabic),
                ),
              ),
            Container(
              height: 60,
              margin: EdgeInsetsDirectional.only(
                end: isMobile ? 12 : (isActive ? 0 : 25),
                start: isCompact ? 10 : 20,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isActive ? activeBg : Colors.transparent,
                borderRadius: BorderRadiusDirectional.horizontal(
                  start: const Radius.circular(30),
                  end: Radius.circular(isActive && !isMobile ? 0 : 30),
                ),
              ),
              child: Row(
                mainAxisAlignment: isCompact
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Icon(icon, color: const Color(0xFFF6AD55), size: 30),
                  if (!isCompact) ...[
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: isActive
                              ? AppColors.primaryTeal(context)
                              : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection(BuildContext context, bool isCompact) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 30),
      child: Column(
        children: [
          Image.asset(
            'assets/emaige/logo.png',
            height: isCompact ? 70 : 110,
            width: isCompact ? 70 : 110,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class SidebarCurvePainter extends CustomPainter {
  final Color bgColor;
  final bool isArabic;
  SidebarCurvePainter(this.bgColor, this.isArabic);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;
    double radius = 35;
    double topY = 38;
    double bottomY = topY + 60;
    double startX = isArabic ? 0 : size.width;
    double curveControlX = isArabic ? size.width : 0;

    Path pathTop = Path();
    pathTop.moveTo(startX, topY - radius);
    pathTop.quadraticBezierTo(startX, topY, curveControlX, topY);
    pathTop.lineTo(startX, topY);
    pathTop.close();
    canvas.drawPath(pathTop, paint);

    Path pathBottom = Path();
    pathBottom.moveTo(startX, bottomY + radius);
    pathBottom.quadraticBezierTo(startX, bottomY, curveControlX, bottomY);
    pathBottom.lineTo(startX, bottomY);
    pathBottom.close();
    canvas.drawPath(pathBottom, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
