// import 'package:flutter/material.dart';
// import 'package:get/get.dart'; // إضافة GetX
// import '../core/colors.dart';
// import '../generated/l10n.dart';
// import '../provider/subject_details_controller.dart'; // مسار الكنترولر
// import '../provider/student_dashboard_controller.dart';

// class SubjectDetailsScreen extends StatefulWidget {
//   final String subjectName;
//   final VoidCallback onBack;
//   final Function(String subjectName, String examTitle) onExamTap;

//   const SubjectDetailsScreen({
//     super.key,
//     required this.subjectName,
//     required this.onBack,
//     required this.onExamTap,
//   }); // غيرنا اسمها هنا أيضاً  });

//   @override
//   State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
// }

// class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
//   // حقن الكنترولر
//   final SubjectDetailsController controller = Get.put(
//     SubjectDetailsController(),
//   );

//   @override
//   void initState() {
//     super.initState();
//     final dashController = Get.find<StudentDashboardController>();
//     // جلب البيانات فور فتح الشاشة باستخدام رقم الطالب الحقيقي
//     controller.fetchSubjectDetails(
//       dashController.currentStudentId,
//       widget.subjectName,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         double width = constraints.maxWidth;
//         bool showSideLayout = width > 750;
//         bool isMobile = constraints.maxWidth < 600;
//         double horizontalPadding = isMobile ? 14.0 : 30.0;

//         return Scaffold(
//           backgroundColor: AppColors.secondaryTeal(context),
//           body: SafeArea(
//             child: Column(
//               children: [
//                 _buildFixedHeader(context, horizontalPadding),
//                 Expanded(
//                   // تغليف المحتوى بـ Obx لمراقبة التحميل
//                   child: Obx(() {
//                     if (controller.isLoading.value) {
//                       return const Center(
//                         child: CircularProgressIndicator(color: Colors.white),
//                       );
//                     }

//                     // في حال لم يكن هناك اختبارات
//                     if (controller.exams.isEmpty) {
//                       return const Center(
//                         child: Text(
//                           "لا توجد تفاصيل أو اختبارات مسجلة لهذه المادة بعد.",
//                           style: TextStyle(color: Colors.white70, fontSize: 16),
//                         ),
//                       );
//                     }

//                     return SingleChildScrollView(
//                       padding: EdgeInsetsDirectional.symmetric(
//                         horizontal: horizontalPadding,
//                         vertical: 5,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildFullWidthStatsRow(context, width),
//                           const SizedBox(height: 20),
//                           if (showSideLayout)
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Expanded(
//                                   flex: 3,
//                                   child: Column(
//                                     children: controller.exams
//                                         .map((e) => _buildExamCard(context, e))
//                                         .toList(),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 24),
//                                 SizedBox(
//                                   width: width > 900 ? 300 : 220,
//                                   child: _buildSideSection(context, false),
//                                 ),
//                               ],
//                             )
//                           else
//                             Column(
//                               children: [
//                                 _buildSideSection(context, true),
//                                 const SizedBox(height: 20),
//                                 ...controller.exams
//                                     .map((e) => _buildExamCard(context, e))
//                                     .toList(),
//                               ],
//                             ),
//                         ],
//                       ),
//                     );
//                   }),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildFullWidthStatsRow(BuildContext context, double width) {
//     bool isTablet = width >= 600 && width < 1100;
//     var stats = controller.stats;

//     var items = [
//       _statItem(
//         context,
//         S.of(context).statMinGrade,
//         stats["min"]?.toString() ?? "0%",
//         Icons.arrow_downward,
//         AppColors.accentYellow(context),
//         isTablet,
//       ),
//       _statItem(
//         context,
//         S.of(context).statMaxGrade,
//         stats["max"]?.toString() ?? "0%",
//         Icons.arrow_upward,
//         AppColors.primaryTeal(context),
//         isTablet,
//       ),
//       _statItem(
//         context,
//         S.of(context).statAverage,
//         stats["avg"]?.toString() ?? "0%",
//         Icons.analytics,
//         const Color(0xFF4F85E2),
//         isTablet,
//       ),
//       _statItem(
//         context,
//         S.of(context).statExams,
//         stats["count"]?.toString() ?? "0",
//         Icons.assignment,
//         AppColors.accentYellow(context),
//         isTablet,
//       ),
//     ];

//     if (width < 600) {
//       return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: items
//               .map(
//                 (i) => Container(
//                   width: 145,
//                   margin: const EdgeInsetsDirectional.only(end: 12),
//                   child: i,
//                 ),
//               )
//               .toList(),
//         ),
//       );
//     }
//     return Row(
//       children: items
//           .map(
//             (i) => Expanded(
//               child: Padding(
//                 padding: const EdgeInsetsDirectional.only(end: 16),
//                 child: i,
//               ),
//             ),
//           )
//           .toList(),
//     );
//   }

//   Widget _statItem(
//     BuildContext context,
//     String label,
//     String value,
//     IconData icon,
//     Color bgColor,
//     bool isTablet,
//   ) {
//     return Container(
//       height: 97,
//       padding: EdgeInsets.all(isTablet ? 12 : 17),
//       decoration: BoxDecoration(
//         color: AppColors.cardBg(context),
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
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
//                     label,
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

//   Widget _buildExamCard(BuildContext context, dynamic exam) {
//     final String title = exam["title"]?.toString() ?? "بدون عنوان";
//     final String date = exam["date"]?.toString() ?? "-";
//     final String totalQ = exam["total"]?.toString() ?? "0";
//     final String answeredQ = exam["answers"]?.toString() ?? "0";
//     final String rating = exam["rating"]?.toString() ?? "-";
//     final String earnedMark = exam["total_earned_mark"]?.toString() ?? "0";
//     final String totalMark = exam["total_marks"]?.toString() ?? "100";

//     // 2. دمج الإجابات مع مجموع الأسئلة (مثال: 8 / 10)
//     final String questionsRatio = "$answeredQ / $totalQ";
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.cardBg(context),
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   exam["title"]?.toString() ?? "بدون عنوان",
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _badgeInfo(context, S.of(context).examDate, date),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: _badgeInfo(
//                         context,
//                         S.of(context).examQuestions,
//                         exam["total"]?.toString() ?? "-",
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: _badgeInfo(
//                         context,
//                         S.of(context).examAnswers,
//                         questionsRatio,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: _badgeInfo(
//                         context,
//                         S.of(context).examRating,
//                         rating,
//                         isBlue: true,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Center(
//                   child: InkWell(
//                     onTap: () {
//                       // هنا نرسل اسم المادة واسم الاختبار معاً للداش بورد!
//                       widget.onExamTap(
//                         widget.subjectName,
//                         exam["title"]?.toString() ?? "",
//                       );
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.primaryTeal(context),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Text(
//                         S.of(context).viewDetails,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 20),
//           Container(
//             width: 100,
//             height: 130,
//             decoration: BoxDecoration(
//               color: AppColors.primaryTeal(context),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   S.of(context).gradeLabel,
//                   style: const TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//                 Text(
//                   exam["total_earned_mark"]?.toString() ?? "0",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   S.of(context).gradeOf,
//                   style: const TextStyle(color: Colors.white70, fontSize: 10),
//                 ),
//                 Text(
//                   exam["total_marks"]?.toString() ?? "100",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSideSection(BuildContext context, bool isHorizontal) {
//     if (isHorizontal) {
//       return Row(
//         children: [
//           Expanded(
//             child: _sideCard(
//               context,
//               S.of(context).strengths,
//               controller.strengths,
//               AppColors.primaryTeal(context),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: _sideCard(
//               context,
//               S.of(context).improvements,
//               controller.improvements,
//               AppColors.accentYellow(context),
//             ),
//           ),
//         ],
//       );
//     }
//     return Column(
//       children: [
//         _sideCard(
//           context,
//           S.of(context).strengths,
//           controller.strengths,
//           AppColors.primaryTeal(context),
//         ),
//         const SizedBox(height: 20),
//         _sideCard(
//           context,
//           S.of(context).improvements,
//           controller.improvements,
//           AppColors.accentYellow(context),
//         ),
//       ],
//     );
//   }

//   Widget _sideCard(
//     BuildContext context,
//     String title,
//     List<String> items,
//     Color bgColor,
//   ) {
//     return Container(
//       height: 150,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
//               const SizedBox(width: 8),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: items
//                     .map(
//                       (item) => Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 4),
//                         child: Row(
//                           children: [
//                             const Text(
//                               "• ",
//                               style: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 item,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                     .toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _badgeInfo(
//     BuildContext context,
//     String label,
//     String value, {
//     bool isBlue = false,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//       decoration: BoxDecoration(
//         color: AppColors.scaffoldBg(context).withOpacity(0.5),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           FittedBox(
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: AppColors.textSecondary(context),
//               ),
//             ),
//           ),
//           const SizedBox(height: 4),
//           FittedBox(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: isBlue
//                     ? Colors.blueAccent
//                     : AppColors.textPrimary(context),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFixedHeader(BuildContext context, double horizontalPadding) {
//     return Container(
//       width: double.infinity,
//       height: 43,
//       margin: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
//       decoration: BoxDecoration(
//         color: AppColors.cardBg(context),
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 7,
//             offset: const Offset(0, 7),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Row(
//           children: [
//             InkWell(
//               onTap: widget.onBack,
//               child: Text(
//                 S.of(context).backToMaterials,
//                 style: TextStyle(
//                   color: AppColors.textSecondary(context),
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 4),
//               child: Icon(Icons.chevron_left, color: Colors.grey, size: 16),
//             ),
//             Text(
//               widget.subjectName,
//               style: TextStyle(
//                 color: AppColors.primaryTeal(context),
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/colors.dart';
import '../generated/l10n.dart';
import '../provider/subject_details_controller.dart';
import '../provider/student_dashboard_controller.dart';

class SubjectDetailsScreen extends StatefulWidget {
  final String subjectName;
  final VoidCallback onBack;
  final Function(String subjectName, String examTitle, int examId) onExamTap;

  const SubjectDetailsScreen({
    super.key,
    required this.subjectName,
    required this.onBack,
    required this.onExamTap,
  });

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // 🌟 الحماية السحرية هنا
      final dashController = context.read<StudentDashboardController>();
      final subjectDetailsController = context.read<SubjectDetailsController>();

      subjectDetailsController.fetchSubjectDetails(
        dashController.currentStudentId,
        widget.subjectName,
        context: context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        bool showSideLayout = width > 750;
        bool isMobile = constraints.maxWidth < 600;
        double horizontalPadding = isMobile ? 14.0 : 30.0;

        return Scaffold(
          backgroundColor: AppColors.secondaryTeal(context),
          body: SafeArea(
            child: Column(
              children: [
                _buildFixedHeader(context, horizontalPadding),
                Expanded(
                  // 🌟 تغليف المحتوى بـ Consumer لمراقبة التحميل (بديل Obx)
                  child: Consumer<SubjectDetailsController>(
                    builder: (context, controller, child) {
                      if (controller.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }

                      // في حال لم يكن هناك اختبارات
                      if (controller.exams.isEmpty) {
                        return Center(
                          child: Text(
                            S.of(context).no_subject_details,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: horizontalPadding,
                          vertical: 5,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFullWidthStatsRow(context, width, controller),
                            const SizedBox(height: 20),
                            if (showSideLayout)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: controller.exams
                                          .map(
                                            (e) => _buildExamCard(context, e),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  SizedBox(
                                    width: width > 900 ? 300 : 220,
                                    child: _buildSideSection(
                                      context,
                                      false,
                                      controller,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Column(
                                children: [
                                  _buildSideSection(context, true, controller),
                                  const SizedBox(height: 20),
                                  ...controller.exams
                                      .map((e) => _buildExamCard(context, e))
                                      .toList(),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFullWidthStatsRow(
    BuildContext context,
    double width,
    SubjectDetailsController controller,
  ) {
    bool isTablet = width >= 600 && width < 1100;
    var stats = controller.stats;

    var items = [
      _statItem(
        context,
        S.of(context).statMinGrade,
        stats["min"]?.toString() ?? "0%",
        Icons.arrow_downward,
        AppColors.accentYellow(context),
        isTablet,
      ),
      _statItem(
        context,
        S.of(context).statMaxGrade,
        stats["max"]?.toString() ?? "0%",
        Icons.arrow_upward,
        AppColors.primaryTeal(context),
        isTablet,
      ),
      _statItem(
        context,
        S.of(context).statAverage,
        stats["avg"]?.toString() ?? "0%",
        Icons.analytics,
        const Color(0xFF4F85E2),
        isTablet,
      ),
      _statItem(
        context,
        S.of(context).statExams,
        stats["count"]?.toString() ?? "0",
        Icons.assignment,
        AppColors.accentYellow(context),
        isTablet,
      ),
    ];

    if (width < 600) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: items
              .map(
                (i) => Container(
                  width: 145,
                  margin: const EdgeInsetsDirectional.only(end: 12),
                  child: i,
                ),
              )
              .toList(),
        ),
      );
    }
    return Row(
      children: items
          .map(
            (i) => Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: i,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _statItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color bgColor,
    bool isTablet,
  ) {
    return Container(
      height: 97,
      padding: EdgeInsets.all(isTablet ? 12 : 17),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                    label,
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

  //   Widget _buildExamCard(BuildContext context, dynamic exam) {
  // String rawDate = exam["date"]?.toString().trim() ?? "";

  //     // إذا كان التاريخ فارغ، أو يحتوي على كلمة null أو خط، نعطيه قيمة "غير مسجل/محدد" باللغتين
  //     if (rawDate.isEmpty || rawDate == "null" || rawDate == "-") {
  //       // استخدمنا مفتاح الترجمة الموجود عندك مسبقاً ليدعم اللغتين تلقائياً
  //       rawDate = S.of(context).not_specified;
  //     }

  //     final String date = exam["date"]?.toString() ?? "-";
  //     final String totalQ = exam["total"]?.toString() ?? "0";
  //     final String answeredQ = exam["answers"]?.toString() ?? "0";
  //     final String rating = exam["rating"]?.toString() ?? "-";

  //     final String questionsRatio = "$answeredQ / $totalQ";
  //     return Container(
  //       margin: const EdgeInsets.only(bottom: 20),
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: AppColors.cardBg(context),
  //         borderRadius: BorderRadius.circular(14),
  //         boxShadow: [
  //           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
  //         ],
  //       ),
  //       child: Row(
  //         children: [
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   exam["title"]?.toString() ?? "بدون عنوان",
  //                   style: const TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 12),
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: _badgeInfo(context, S.of(context).examDate, date),
  //                     ),
  //                     const SizedBox(width: 8),
  //                     Expanded(
  //                       child: _badgeInfo(
  //                         context,
  //                         S.of(context).examQuestions,
  //                         exam["total"]?.toString() ?? "-",
  //                       ),
  //                     ),
  //                     const SizedBox(width: 8),
  //                     Expanded(
  //                       child: _badgeInfo(
  //                         context,
  //                         S.of(context).examAnswers,
  //                         questionsRatio,
  //                       ),
  //                     ),
  //                     const SizedBox(width: 8),
  //                     Expanded(
  //                       child: _badgeInfo(
  //                         context,
  //                         S.of(context).examRating,
  //                         rating,
  //                         isBlue: true,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 16),
  //                 Center(
  //                   child: InkWell(
  //                     // 🌟 هنا التعديل الجوهري السحري!
  //                     onTap: () {
  //                       // سحب الرقم سواء كان اسمه exam_id أو id، وبدون ما يضرب الكود لو كان null
  //                       String idStr =
  //                           exam["exam_id"]?.toString() ??
  //                           exam["id"]?.toString() ??
  //                           '0';
  //                       int safeExamId = int.tryParse(idStr) ?? 0;

  //                       if (safeExamId <= 0) {
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                           const SnackBar(
  //                             content: Text('خطأ: رقم الاختبار غير متوفر!'),
  //                             backgroundColor: Colors.red,
  //                           ),
  //                         );
  //                         return; // توقيف الانتقال إذا مافي رقم
  //                       }

  //                       widget.onExamTap(
  //                         widget.subjectName,
  //                         exam["title"]?.toString() ?? "",
  //                         safeExamId, // 👈 إرسال الرقم السليم والصحيح 100%
  //                       );
  //                     },
  //                     child: Container(
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 24,
  //                         vertical: 8,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: AppColors.primaryTeal(context),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       child: Text(
  //                         S.of(context).viewDetails,
  //                         style: const TextStyle(
  //                           color: Colors.white,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const SizedBox(width: 20),
  //           Container(
  //             width: 100,
  //             height: 130,
  //             decoration: BoxDecoration(
  //               color: AppColors.primaryTeal(context),
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   S.of(context).Grade1,
  //                   style: const TextStyle(color: Colors.white, fontSize: 12),
  //                 ),
  //                 Text(
  //                   exam["total_earned_mark"]?.toString() ?? "0",
  //                   style: const TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 28,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 Text(
  //                   S.of(context).gradeOf,
  //                   style: const TextStyle(color: Colors.white70, fontSize: 10),
  //                 ),
  //                 Text(
  //                   exam["total_marks"]?.toString() ?? "100",
  //                   style: const TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }

  Widget _buildExamCard(BuildContext context, dynamic exam) {
    // 🌟 التعديل السحري هنا: تنظيف وفحص التاريخ
    String rawDate = exam["date"]?.toString().trim() ?? "";

    // إذا كان التاريخ فارغ، أو يحتوي على كلمة null أو خط، نعطيه قيمة "غير مسجل/محدد" باللغتين
    if (rawDate.isEmpty || rawDate == "null" || rawDate == "-") {
      // استخدمنا مفتاح الترجمة الموجود عندك مسبقاً ليدعم اللغتين تلقائياً
      rawDate = S.of(context).not_specified;
    }

    final String date = rawDate;
    final String totalQ = exam["total"]?.toString() ?? "0";
    final String answeredQ = exam["answers"]?.toString() ?? "0";
    final String rating = exam["rating"]?.toString() ?? "-";

    final String questionsRatio = "$answeredQ / $totalQ";
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam["title"]?.toString() ?? S.of(context).untitled_exam,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _badgeInfo(context, S.of(context).examDate, date),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _badgeInfo(
                        context,
                        S.of(context).examQuestions,
                        exam["total"]?.toString() ?? "-",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _badgeInfo(
                        context,
                        S.of(context).examAnswers,
                        questionsRatio,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _badgeInfo(
                        context,
                        S.of(context).examRating,
                        rating,
                        isBlue: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: InkWell(
                    onTap: () {
                      String idStr =
                          exam["exam_id"]?.toString() ??
                          exam["id"]?.toString() ??
                          '0';
                      int safeExamId = int.tryParse(idStr) ?? 0;

                      if (safeExamId <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              S.of(context).err_exam_id_unavailable,
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      widget.onExamTap(
                        widget.subjectName,
                        exam["title"]?.toString() ?? "",
                        safeExamId,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal(context),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        S.of(context).viewDetails,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 100,
            height: 130,
            decoration: BoxDecoration(
              color: AppColors.primaryTeal(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).Grade1,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  exam["total_earned_mark"]?.toString() ?? "0",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  S.of(context).gradeOf,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
                Text(
                  exam["total_marks"]?.toString() ?? "100",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideSection(
    BuildContext context,
    bool isHorizontal,
    SubjectDetailsController controller,
  ) {
    if (isHorizontal) {
      return Row(
        children: [
          Expanded(
            child: _sideCard(
              context,
              S.of(context).strengths,
              controller.strengths,
              AppColors.primaryTeal(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _sideCard(
              context,
              S.of(context).improvements,
              controller.improvements,
              AppColors.accentYellow(context),
            ),
          ),
        ],
      );
    }
    return Column(
      children: [
        _sideCard(
          context,
          S.of(context).strengths,
          controller.strengths,
          AppColors.primaryTeal(context),
        ),
        const SizedBox(height: 20),
        _sideCard(
          context,
          S.of(context).improvements,
          controller.improvements,
          AppColors.accentYellow(context),
        ),
      ],
    );
  }

  Widget _sideCard(
    BuildContext context,
    String title,
    List<String> items,
    Color bgColor,
  ) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: items
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "• ",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badgeInfo(
    BuildContext context,
    String label,
    String value, {
    bool isBlue = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg(context).withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary(context),
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isBlue
                    ? Colors.blueAccent
                    : AppColors.textPrimary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedHeader(BuildContext context, double horizontalPadding) {
    return Container(
      width: double.infinity,
      height: 43,
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 7,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            InkWell(
              onTap: widget.onBack,
              child: Text(
                S.of(context).backToMaterials,
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 14,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.chevron_left, color: Colors.grey, size: 16),
            ),
            Text(
              widget.subjectName,
              style: TextStyle(
                color: AppColors.primaryTeal(context),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
