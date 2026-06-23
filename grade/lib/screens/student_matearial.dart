// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import '../core/colors.dart';
// // import '../generated/l10n.dart';
// // import '../provider/subject_screen_controller.dart';

// // class SubjectsScreen extends StatefulWidget {
// //   final String subjectName;
// //   final VoidCallback onBack;
// //   final Function(String) onSubjectTap;

// //   const SubjectsScreen({
// //     super.key,
// //     required this.subjectName,
// //     required this.onBack,
// //     required this.onSubjectTap,
// //   });

// //   @override
// //   State<SubjectsScreen> createState() => _SubjectsScreenState();
// // }

// // class _SubjectsScreenState extends State<SubjectsScreen> {
// //   String? selectedSubjectName;

// //   final SubjectScreenController controller = Get.put(SubjectScreenController());

// //   @override
// //   void initState() {
// //     super.initState();
// //     if (widget.subjectName.isNotEmpty) {
// //       selectedSubjectName = widget.subjectName;
// //     }
// //   }

// //   void onSubjectTap(String name) {
// //     if (selectedSubjectName == name) {
// //       widget.onSubjectTap(name);
// //     } else {
// //       setState(() {
// //         selectedSubjectName = name;
// //       });
// //       // استدعاء دالة الضغط لتمرير اسم المادة للداش بورد
// //       widget.onSubjectTap(name);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return LayoutBuilder(
// //       builder: (context, constraints) {
// //         bool isMobile = constraints.maxWidth < 600;
// //         double horizontalPadding = isMobile ? 14.0 : 30.0;

// //         return Obx(() {
// //           if (controller.isLoading.value) {
// //             return const Scaffold(
// //               backgroundColor: Colors.transparent,
// //               body: Center(
// //                 child: CircularProgressIndicator(color: Colors.white),
// //               ),
// //             );
// //           }

// //           return Scaffold(
// //             backgroundColor: Colors.transparent,
// //             body: SingleChildScrollView(
// //               padding: EdgeInsets.symmetric(
// //                 horizontal: horizontalPadding,
// //                 vertical: 32,
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   _buildTopStatsGrid(context, isMobile),
// //                   const SizedBox(height: 40),
// //                   _buildTermSwitcher(context),
// //                   const SizedBox(height: 32),
// //                   _buildFluidSubjectsLayout(context),
// //                 ],
// //               ),
// //             ),
// //           );
// //         });
// //       },
// //     );
// //   }

// //   Widget _buildTopStatsGrid(BuildContext context, bool isMobile) {
// //     double width = MediaQuery.of(context).size.width;
// //     bool isTablet = width >= 600 && width < 1100;

// //     var statsData = controller.topStats;

// //     var stats = [
// //       _statTopCard(
// //         context,
// //         S.of(context).statHighScore,
// //         statsData['highest_score']?.toString() ?? "0%",
// //         Icons.trending_up,
// //         isTablet,
// //       ),
// //       _statTopCard(
// //         context,
// //         S.of(context).statAverage,
// //         statsData['average_score']?.toString() ?? "0%",
// //         Icons.analytics,
// //         isTablet,
// //       ),
// //       _statTopCard(
// //         context,
// //         S.of(context).statExams,
// //         statsData['total_exams']?.toString() ?? "0",
// //         Icons.description,
// //         isTablet,
// //       ),
// //       _statTopCard(
// //         context,
// //         S.of(context).statMaterials,
// //         statsData['total_subjects']?.toString() ?? "0",
// //         Icons.book,
// //         isTablet,
// //       ),
// //     ];

// //     if (isMobile) {
// //       return SingleChildScrollView(
// //         scrollDirection: Axis.horizontal,
// //         physics: const BouncingScrollPhysics(),
// //         child: Row(
// //           children: stats
// //               .map(
// //                 (card) => Container(
// //                   width: width * 0.35,
// //                   margin: const EdgeInsetsDirectional.only(end: 12),
// //                   child: card,
// //                 ),
// //               )
// //               .toList(),
// //         ),
// //       );
// //     }

// //     return Row(
// //       children: stats
// //           .map(
// //             (card) => Expanded(
// //               child: Padding(
// //                 padding: const EdgeInsetsDirectional.only(end: 16),
// //                 child: card,
// //               ),
// //             ),
// //           )
// //           .toList(),
// //     );
// //   }

// //   Widget _statTopCard(
// //     BuildContext context,
// //     String title,
// //     String value,
// //     IconData icon,
// //     bool isTablet,
// //   ) {
// //     return Container(
// //       padding: EdgeInsets.all(isTablet ? 12 : 17),
// //       decoration: BoxDecoration(
// //         color: AppColors.cardBg(context),
// //         borderRadius: BorderRadius.circular(24),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.02),
// //             blurRadius: 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Icon(
// //                 icon,
// //                 color: const Color(0xFFF6AD55),
// //                 size: isTablet ? 20 : 25,
// //               ),
// //               const SizedBox(width: 4),
// //               Expanded(
// //                 child: FittedBox(
// //                   fit: BoxFit.scaleDown,
// //                   alignment: AlignmentDirectional.centerStart,
// //                   child: Text(
// //                     title,
// //                     style: TextStyle(
// //                       color: AppColors.textSecondary(context),
// //                       fontSize: 13,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 8),
// //           FittedBox(
// //             fit: BoxFit.scaleDown,
// //             child: Text(
// //               value,
// //               style: TextStyle(
// //                 color: AppColors.textPrimary(context),
// //                 fontSize: isTablet ? 22 : 20,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTermSwitcher(BuildContext context) {
// //     if (controller.availableSemesters.isEmpty) return const SizedBox.shrink();

// //     return Center(
// //       child: Container(
// //         padding: const EdgeInsets.all(6),
// //         decoration: BoxDecoration(
// //           color: Colors.black.withOpacity(0.05),
// //           borderRadius: BorderRadius.circular(15),
// //         ),
// //         child: SingleChildScrollView(
// //           scrollDirection: Axis.horizontal,
// //           child: Row(
// //             mainAxisSize: MainAxisSize.min,
// //             children: controller.availableSemesters.map((semester) {
// //               return _termButton(semester['name'] ?? "", semester['id'] ?? 1);
// //             }).toList(),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _termButton(String title, int id) {
// //     bool isSelected = controller.selectedTermId.value == id;
// //     return GestureDetector(
// //       onTap: () {
// //         controller.changeTerm(id);
// //         setState(() {
// //           selectedSubjectName = null;
// //         });
// //       },
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
// //         decoration: BoxDecoration(
// //           color: isSelected
// //               ? AppColors.primaryTeal(context)
// //               : Colors.transparent,
// //           borderRadius: BorderRadius.circular(10),
// //         ),
// //         child: Text(
// //           title,
// //           style: TextStyle(
// //             color: isSelected ? Colors.white : Colors.grey,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildFluidSubjectsLayout(BuildContext context) {
// //     final List subjects = controller.activeTermSubjects;

// //     if (subjects.isEmpty) {
// //       return const Center(
// //         child: Padding(
// //           padding: EdgeInsets.all(20.0),
// //           child: Text(
// //             "لا توجد مواد مسجلة في هذا الفصل الدراسي",
// //             style: TextStyle(
// //               color: Colors.white70,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //         ),
// //       );
// //     }

// //     return LayoutBuilder(
// //       builder: (context, box) {
// //         int crossAxisCount = box.maxWidth > 900
// //             ? 4
// //             : (box.maxWidth > 650 ? 2 : 1);
// //         return GridView.builder(
// //           shrinkWrap: true,
// //           physics: const NeverScrollableScrollPhysics(),
// //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //             crossAxisCount: crossAxisCount,
// //             crossAxisSpacing: 16,
// //             mainAxisSpacing: 20,
// //             mainAxisExtent: 210,
// //           ),
// //           itemCount: subjects.length,
// //           itemBuilder: (context, index) =>
// //               _buildOldStyleSubjectCard(subjects[index]),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildOldStyleSubjectCard(Map<String, dynamic> subject) {
// //     bool isSelected = selectedSubjectName == subject["name"];
// //     return GestureDetector(
// //       onTap: () => onSubjectTap(subject["name"]),
// //       child: AnimatedContainer(
// //         duration: const Duration(milliseconds: 200),
// //         padding: const EdgeInsets.all(12),
// //         decoration: BoxDecoration(
// //           color: AppColors.cardBg(context),
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(
// //             color: isSelected
// //                 ? AppColors.primaryTeal(context)
// //                 : Colors.transparent,
// //             width: 1.6,
// //           ),
// //           boxShadow: isSelected
// //               ? [
// //                   BoxShadow(
// //                     color: AppColors.primaryTeal(context).withOpacity(0.2),
// //                     blurRadius: 10,
// //                     offset: const Offset(0, 4),
// //                   ),
// //                 ]
// //               : [],
// //         ),
// //         child: Column(
// //           children: [
// //             Row(
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.all(8),
// //                   decoration: BoxDecoration(
// //                     color: AppColors.primaryTeal(context),
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                   child: const Icon(
// //                     Icons.menu_book,
// //                     color: Colors.white,
// //                     size: 18,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 8),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         subject["name"] ?? "",
// //                         style: const TextStyle(
// //                           fontSize: 15,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                       Text(
// //                         subject["teacher"] ?? "",
// //                         style: TextStyle(
// //                           fontSize: 12,
// //                           color: AppColors.textSecondary(context),
// //                         ),
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const Divider(height: 20, thickness: 0.8),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: _buildOldStatBox(
// //                     S.of(context).gradeLabel,
// //                     subject["total_earned_mark"]?.toString() ??
// //                         "0", // 🟢 التعديل هنا: استخدام اسم العمود الصحيح
// //                   ),
// //                 ),
// //                 const SizedBox(width: 8),
// //                 Expanded(
// //                   child: _buildOldStatBox(
// //                     S.of(context).examsLabel,
// //                     subject["exams"]?.toString() ?? "0",
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 12),
// //             Container(
// //               width: double.infinity,
// //               padding: const EdgeInsets.all(8),
// //               decoration: BoxDecoration(
// //                 color: Colors.grey.withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     S.of(context).lastExam,
// //                     style: const TextStyle(fontSize: 11, color: Colors.grey),
// //                   ),
// //                   Text(
// //                     subject["lastExam"] ?? "",
// //                     style: const TextStyle(
// //                       fontSize: 13,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildOldStatBox(String label, String value) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(vertical: 6),
// //       decoration: BoxDecoration(
// //         color: Colors.grey.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //       child: Column(
// //         children: [
// //           FittedBox(
// //             child: Text(
// //               label,
// //               style: const TextStyle(fontSize: 10, color: Colors.grey),
// //             ),
// //           ),
// //           Text(
// //             value,
// //             style: TextStyle(
// //               fontSize: 14,
// //               fontWeight: FontWeight.bold,
// //               color: AppColors.primaryTeal(context),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // 🌟 استيراد مكتبة بروفايدر
// import '../core/colors.dart';
// import '../generated/l10n.dart';
// // 🌟 استيراد البروفايدرات
// import '/provider/subject_screen_controller.dart'; // مسار ملف البروفايدر الذي أنشأناه بالأعلى
// import '../../provider/student_dashboard_controller.dart'; // نفترض أنه أصبح بروفايدر أيضاً

// class SubjectsScreen extends StatefulWidget {
//   final String subjectName;
//   final VoidCallback onBack;
//   final Function(String) onSubjectTap;

//   const SubjectsScreen({
//     super.key,
//     required this.subjectName,
//     required this.onBack,
//     required this.onSubjectTap,
//   });

//   @override
//   State<SubjectsScreen> createState() => _SubjectsScreenState();
// }

// class _SubjectsScreenState extends State<SubjectsScreen> {
//   String? selectedSubjectName;
//   late SubjectScreenController providerController; // 🌟 تعريف البروفايدر محلياً

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   if (widget.subjectName.isNotEmpty) {
//   //     selectedSubjectName = widget.subjectName;
//   //   }

//   //   // 🌟 تهيئة البروفايدر وجلب البيانات مباشرة من هنا بدلاً من Get.put
//   //   providerController = SubjectScreenController();
//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     // 🌟 جلب رقم الطالب من الداش بورد (تأكدي أن اسمه مطابق لما لديك)
//   //     final studentId = Provider.of<StudentDashboardController>(
//   //       context,
//   //       listen: false,
//   //     ).currentStudentId;
//   //     providerController.init(studentId, context);
//   //   });
//   // }

//   @override
//   void initState() {
//     super.initState();
//     if (widget.subjectName.isNotEmpty) {
//       selectedSubjectName = widget.subjectName;
//     }

//     providerController = SubjectScreenController();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // 🛡️ درع الحماية: تأكدي أن الشاشة لا تزال موجودة قبل البدء
//       if (!mounted) return;

//       final studentId = Provider.of<StudentDashboardController>(
//         context,
//         listen: false,
//       ).currentStudentId;

//       // 🛡️ جلب البيانات
//       providerController.init(studentId, context);
//     });
//   }

//   @override
//   void dispose() {
//     providerController
//         .dispose(); // 🌟 تنظيف البروفايدر من الذاكرة عند إغلاق الشاشة
//     super.dispose();
//   }

//   void onSubjectTap(String name) {
//     if (selectedSubjectName == name) {
//       widget.onSubjectTap(name);
//     } else {
//       setState(() {
//         selectedSubjectName = name;
//       });
//       // استدعاء دالة الضغط لتمرير اسم المادة للداش بورد
//       widget.onSubjectTap(name);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // 🌟 نغلف الواجهة بـ ChangeNotifierProvider لنتمكن من استخدام البروفايدر بداخلها
//     return ChangeNotifierProvider.value(
//       value: providerController,
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           bool isMobile = constraints.maxWidth < 600;
//           double horizontalPadding = isMobile ? 14.0 : 30.0;

//           // 🌟 استبدال Obx بـ Consumer
//           return Consumer<SubjectScreenController>(
//             builder: (context, provider, child) {
//               if (provider.isLoading) {
//                 return const Scaffold(
//                   backgroundColor: Colors.transparent,
//                   body: Center(
//                     child: CircularProgressIndicator(color: Colors.white),
//                   ),
//                 );
//               }

//               return Scaffold(
//                 backgroundColor: Colors.transparent,
//                 body: SingleChildScrollView(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: horizontalPadding,
//                     vertical: 32,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildTopStatsGrid(context, isMobile, provider),
//                       const SizedBox(height: 40),
//                       _buildTermSwitcher(context, provider),
//                       const SizedBox(height: 32),
//                       _buildFluidSubjectsLayout(context, provider),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTopStatsGrid(
//     BuildContext context,
//     bool isMobile,
//     SubjectScreenController provider,
//   ) {
//     double width = MediaQuery.of(context).size.width;
//     bool isTablet = width >= 600 && width < 1100;

//     var statsData = provider.topStats;

//     var stats = [
//       _statTopCard(
//         context,
//         S.of(context).statHighScore,
//         statsData['highest_score']?.toString() ?? "0%",
//         Icons.trending_up,
//         isTablet,
//       ),
//       _statTopCard(
//         context,
//         S.of(context).statAverage,
//         statsData['average_score']?.toString() ?? "0%",
//         Icons.analytics,
//         isTablet,
//       ),
//       _statTopCard(
//         context,
//         S.of(context).statExams,
//         statsData['total_exams']?.toString() ?? "0",
//         Icons.description,
//         isTablet,
//       ),
//       _statTopCard(
//         context,
//         S.of(context).statMaterials,
//         statsData['total_subjects']?.toString() ?? "0",
//         Icons.book,
//         isTablet,
//       ),
//     ];

//     if (isMobile) {
//       return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         physics: const BouncingScrollPhysics(),
//         child: Row(
//           children: stats
//               .map(
//                 (card) => Container(
//                   width: width * 0.35,
//                   margin: const EdgeInsetsDirectional.only(end: 12),
//                   child: card,
//                 ),
//               )
//               .toList(),
//         ),
//       );
//     }

//     return Row(
//       children: stats
//           .map(
//             (card) => Expanded(
//               child: Padding(
//                 padding: const EdgeInsetsDirectional.only(end: 16),
//                 child: card,
//               ),
//             ),
//           )
//           .toList(),
//     );
//   }

//   Widget _statTopCard(
//     BuildContext context,
//     String title,
//     String value,
//     IconData icon,
//     bool isTablet,
//   ) {
//     return Container(
//       padding: EdgeInsets.all(isTablet ? 12 : 17),
//       decoration: BoxDecoration(
//         color: AppColors.cardBg(context),
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.02),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Icon(
//                 icon,
//                 color: const Color(0xFFF6AD55),
//                 size: isTablet ? 20 : 25,
//               ),
//               const SizedBox(width: 4),
//               Expanded(
//                 child: FittedBox(
//                   fit: BoxFit.scaleDown,
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       color: AppColors.textSecondary(context),
//                       fontSize: 13,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Text(
//               value,
//               style: TextStyle(
//                 color: AppColors.textPrimary(context),
//                 fontSize: isTablet ? 22 : 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTermSwitcher(
//     BuildContext context,
//     SubjectScreenController provider,
//   ) {
//     if (provider.availableSemesters.isEmpty) return const SizedBox.shrink();

//     return Center(
//       child: Container(
//         padding: const EdgeInsets.all(6),
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.05),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: provider.availableSemesters.map((semester) {
//               return _termButton(
//                 semester['name'] ?? "",
//                 semester['id'] ?? 1,
//                 provider,
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _termButton(String title, int id, SubjectScreenController provider) {
//     bool isSelected = provider.selectedTermId == id;
//     return GestureDetector(
//       onTap: () {
//         provider.changeTerm(id);
//         setState(() {
//           selectedSubjectName = null;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? AppColors.primaryTeal(context)
//               : Colors.transparent,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Text(
//           title,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.grey,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFluidSubjectsLayout(
//     BuildContext context,
//     SubjectScreenController provider,
//   ) {
//     final List subjects = provider.activeTermSubjects;

//     if (subjects.isEmpty) {
//       return const Center(
//         child: Padding(
//           padding: EdgeInsets.all(20.0),
//           child: Text(
//             "لا توجد مواد مسجلة في هذا الفصل الدراسي",
//             style: TextStyle(
//               color: Colors.white70,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       );
//     }

//     return LayoutBuilder(
//       builder: (context, box) {
//         int crossAxisCount = box.maxWidth > 900
//             ? 4
//             : (box.maxWidth > 650 ? 2 : 1);
//         return GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: crossAxisCount,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 20,
//             mainAxisExtent: 210,
//           ),
//           itemCount: subjects.length,
//           itemBuilder: (context, index) =>
//               _buildOldStyleSubjectCard(subjects[index]),
//         );
//       },
//     );
//   }

//   Widget _buildOldStyleSubjectCard(Map<String, dynamic> subject) {
//     bool isSelected = selectedSubjectName == subject["name"];
//     return GestureDetector(
//       onTap: () => onSubjectTap(subject["name"]),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: AppColors.cardBg(context),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected
//                 ? AppColors.primaryTeal(context)
//                 : Colors.transparent,
//             width: 1.6,
//           ),
//           boxShadow: isSelected
//               ? [
//                   BoxShadow(
//                     color: AppColors.primaryTeal(context).withOpacity(0.2),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ]
//               : [],
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryTeal(context),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(
//                     Icons.menu_book,
//                     color: Colors.white,
//                     size: 18,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         subject["name"] ?? "",
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       Text(
//                         subject["teacher"] ?? "",
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: AppColors.textSecondary(context),
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(height: 20, thickness: 0.8),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildOldStatBox(
//                     S.of(context).gradeLabel,
//                     subject["total_earned_mark"]?.toString() ?? "0",
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: _buildOldStatBox(
//                     S.of(context).examsLabel,
//                     subject["exams"]?.toString() ?? "0",
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.grey.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     S.of(context).lastExam,
//                     style: const TextStyle(fontSize: 11, color: Colors.grey),
//                   ),
//                   Text(
//                     subject["lastExam"] ?? "",
//                     style: const TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
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

//   Widget _buildOldStatBox(String label, String value) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.grey.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         children: [
//           FittedBox(
//             child: Text(
//               label,
//               style: const TextStyle(fontSize: 10, color: Colors.grey),
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: AppColors.primaryTeal(context),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/colors.dart';
import '../generated/l10n.dart';
import '/provider/subject_screen_controller.dart';
import '../../provider/student_dashboard_controller.dart';

class SubjectsScreen extends StatefulWidget {
  final String subjectName;
  final VoidCallback onBack;
  final Function(String) onSubjectTap;

  const SubjectsScreen({
    super.key,
    required this.subjectName,
    required this.onBack,
    required this.onSubjectTap,
  });

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  String? selectedSubjectName;
  late SubjectScreenController providerController;

  @override
  void initState() {
    super.initState();
    if (widget.subjectName.isNotEmpty) {
      selectedSubjectName = widget.subjectName;
    }

    providerController = SubjectScreenController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final studentId = Provider.of<StudentDashboardController>(
        context,
        listen: false,
      ).currentStudentId;

      providerController.init(studentId, context);
    });
  }

  @override
  void dispose() {
    providerController.dispose();
    super.dispose();
  }

  void onSubjectTap(String name) {
    if (selectedSubjectName == name) {
      widget.onSubjectTap(name);
    } else {
      setState(() {
        selectedSubjectName = name;
      });
      widget.onSubjectTap(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: providerController,
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;
          double horizontalPadding = isMobile ? 14.0 : 30.0;

          return Consumer<SubjectScreenController>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }

              return Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopStatsGrid(context, isMobile, provider),
                      const SizedBox(height: 40),
                      _buildTermSwitcher(context, provider),
                      const SizedBox(height: 32),
                      _buildFluidSubjectsLayout(context, provider),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTopStatsGrid(
    BuildContext context,
    bool isMobile,
    SubjectScreenController provider,
  ) {
    double width = MediaQuery.of(context).size.width;
    bool isTablet = width >= 600 && width < 1100;

    var statsData = provider.topStats;

    var stats = [
      _statTopCard(
        context,
        S.of(context).statHighScore,
        statsData['highest_score']?.toString() ?? "0%",
        Icons.trending_up,
        isTablet,
      ),
      _statTopCard(
        context,
        S.of(context).statAverage,
        statsData['average_score']?.toString() ?? "0%",
        Icons.analytics,
        isTablet,
      ),
      _statTopCard(
        context,
        S.of(context).statExams,
        statsData['total_exams']?.toString() ?? "0",
        Icons.description,
        isTablet,
      ),
      _statTopCard(
        context,
        S.of(context).statMaterials,
        statsData['total_subjects']?.toString() ?? "0",
        Icons.book,
        isTablet,
      ),
    ];

    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: stats
              .map(
                (card) => Container(
                  width: width * 0.35,
                  margin: const EdgeInsetsDirectional.only(end: 12),
                  child: card,
                ),
              )
              .toList(),
        ),
      );
    }

    return Row(
      children: stats
          .map(
            (card) => Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: card,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _statTopCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 12 : 17),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: const Color(0xFFF6AD55),
                size: isTablet ? 20 : 25,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary(context),
                fontSize: isTablet ? 22 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermSwitcher(
    BuildContext context,
    SubjectScreenController provider,
  ) {
    if (provider.availableSemesters.isEmpty) return const SizedBox.shrink();

    return Center(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: provider.availableSemesters.map((semester) {
              return _termButton(
                semester['name'] ?? "",
                semester['id'] ?? 1,
                provider,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _termButton(String title, int id, SubjectScreenController provider) {
    bool isSelected = provider.selectedTermId == id;
    return GestureDetector(
      onTap: () {
        provider.changeTerm(id);
        setState(() {
          selectedSubjectName = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryTeal(context)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFluidSubjectsLayout(
    BuildContext context,
    SubjectScreenController provider,
  ) {
    final List subjects = provider.activeTermSubjects;

    if (subjects.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            S.of(context).no_materials_in_term,
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, box) {
        int crossAxisCount = box.maxWidth > 900
            ? 4
            : (box.maxWidth > 650 ? 2 : 1);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
            mainAxisExtent: 210,
          ),
          itemCount: subjects.length,
          itemBuilder: (context, index) =>
              _buildOldStyleSubjectCard(subjects[index]),
        );
      },
    );
  }

  Widget _buildOldStyleSubjectCard(Map<String, dynamic> subject) {
    bool isSelected = selectedSubjectName == subject["name"];
    return GestureDetector(
      onTap: () => onSubjectTap(subject["name"]),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryTeal(context)
                : Colors.transparent,
            width: 1.6,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryTeal(context).withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.menu_book,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject["name"] ?? "",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subject["teacher"] ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 0.8),
            Row(
              children: [
                Expanded(
                  child: _buildOldStatBox(
                    S.of(context).gradeLabel,
                    subject["total_earned_mark"]?.toString() ?? "0",
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildOldStatBox(
                    S.of(context).examsLabel,
                    subject["exams"]?.toString() ?? "0",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).lastExam,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  Text(
                    subject["lastExam"] ?? "",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOldStatBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          FittedBox(
            child: Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryTeal(context),
            ),
          ),
        ],
      ),
    );
  }
}
