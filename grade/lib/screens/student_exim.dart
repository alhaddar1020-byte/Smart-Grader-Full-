// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:grade/core/locale_provider.dart';
// import '../core/colors.dart';
// import '../generated/l10n.dart';
// import '../provider/exam_details_controller.dart'; // مسار الكنترولر
// import '../core/controllers/student_dashboard_controller.dart';
// // import 'package:printing/printing.dart';
// // import '../core/helpers/pdf_helper.dart';
// // import 'package:pdf/pdf.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart'; // إذا كنتِ بتستخدمينها للتحميل
// // أو ضعي كود الكلاس ExamReportActions الذي سنقوم بإضافته في أسفل هذا الملف

// import 'dart:typed_data';
// import 'package:printing/printing.dart';
// import 'student_setting.dart';

// class StudentExamScreen extends StatefulWidget {
//   final String subjectName;
//   final String examTitle; // أضفنا هذا لنعرف أي اختبار نجلب
//   final VoidCallback onBack;
//   final Function(int) onItemSelected;

//   const StudentExamScreen({
//     super.key,
//     required this.subjectName,
//     required this.examTitle, // مطلوب الآن
//     required this.onBack,
//     required this.onItemSelected,
//   });

//   @override
//   State<StudentExamScreen> createState() => _StudentExamScreenState();
// }

// class _StudentExamScreenState extends State<StudentExamScreen> {
//   bool isDetailedCorrection = true;
//   final ExamDetailsController controller = Get.put(ExamDetailsController());

//   @override
//   void initState() {
//     super.initState();
//     // جلب بيانات الاختبار (نفترض الطالب رقم 1)
//     final dashController = Get.find<StudentDashboardController>();

//     // 2. نستخرج رقم الطالب الحقيقي من الكنترولر (ونضع 1 كاحتياط لو فشل)
//     int realStudentId = dashController.currentStudentId;

//     // 3. نرسل رقم الطالب الحقيقي مع اسم الاختبار للسيرفر
//     controller.fetchExamDetails(realStudentId, widget.examTitle);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.secondaryTeal(context),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           double width = constraints.maxWidth;
//           bool isMobile = width < 650;
//           double horizontalPadding = isMobile ? 16.0 : 33.0;

//           return Column(
//             children: [
//               _buildResponsiveHeader(context, horizontalPadding),
//               Expanded(
//                 child: Obx(() {
//                   if (controller.isLoading.value) {
//                     return const Center(
//                       child: CircularProgressIndicator(color: Colors.white),
//                     );
//                   }

//                   return SingleChildScrollView(
//                     padding: EdgeInsetsDirectional.symmetric(
//                       horizontal: horizontalPadding,
//                       vertical: 10,
//                     ),
//                     child: Column(
//                       children: [
//                         _buildStatsAndScoreSection(isMobile),
//                         const SizedBox(height: 25),
//                         _buildMainContentSection(isMobile),
//                       ],
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildStatsAndScoreSection(bool isMobile) {
//     return IntrinsicHeight(
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(
//             flex: 5,
//             child: _ExamStatsGrid(isMobile: isMobile, stats: controller.stats),
//           ),
//           const SizedBox(width: 15),
//           Expanded(
//             flex: isMobile ? 3 : 2,
//             child: _FinalScoreCard(isMobile: isMobile, stats: controller.stats),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMainContentSection(bool isMobile) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: AppColors.cardBg(context),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           _buildTabs(isMobile),
//           Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 300),
//             child: Padding(
//               key: ValueKey<bool>(isDetailedCorrection),
//               padding: EdgeInsets.all(isMobile ? 15 : 25),
//               child: isDetailedCorrection
//                   ? _buildDetailedQuestionsList(isMobile)
//                   : _buildOriginalPaperView(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabs(bool isMobile) {
//     return Padding(
//       padding: const EdgeInsets.all(15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _TabButton(
//             label: S.of(context).examDetailedCorrection,
//             isActive: isDetailedCorrection,
//             onTap: () => setState(() => isDetailedCorrection = true),
//           ),
//           const SizedBox(width: 10),
//           _TabButton(
//             label: S.of(context).examAnswerPaper,
//             isActive: !isDetailedCorrection,
//             onTap: () => setState(() => isDetailedCorrection = false),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailedQuestionsList(bool isMobile) {
//     if (controller.questions.isEmpty) {
//       return const Center(child: Text("لا توجد أسئلة مسجلة حتى الآن."));
//     }
//     return Column(
//       children: controller.questions
//           .map((data) => _QuestionCard(data: data, isMobile: isMobile))
//           .toList(),
//     );
//   }

//   Widget _buildOriginalPaperView() {
//     // 🔴 استدعي الكنترولر حقك هنا (عدلي اسم الكنترولر حسب اللي تستخدمينه)
//     final controller = Get.find<ExamDetailsController>();

//     return Obx(() {
//       final images = controller.originalPaperImages;

//       // حالة: لا توجد صور
//       if (images.isEmpty) {
//         return SizedBox(
//           height: 300,
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.insert_drive_file_outlined,
//                   size: 50,
//                   color: Colors.grey.shade400,
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   S.of(context).noPaperImagesUploaded,
//                   style: TextStyle(color: Colors.grey.shade600),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }

//       // حالة: توجد صور (نعرضها في PageView مع إمكانية التكبير)
//       return SizedBox(
//         height: 400, // كبرنا الارتفاع شوي عشان الورقة تكون واضحة
//         child: Column(
//           children: [
//             Expanded(
//               child: PageView.builder(
//                 itemCount: images.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       // 🔴 InteractiveViewer هو السحر اللي يسمح للطالب يسوي زوم بإصبعه!
//                       child: InteractiveViewer(
//                         panEnabled: true,
//                         minScale: 1.0,
//                         maxScale: 4.0, // يقدر يكبر لحد 4 أضعاف
//                         child: Image.network(
//                           images[index], // رابط الصورة
//                           fit: BoxFit
//                               .contain, // يضمن إن الورقة كاملة تظهر بدون قص
//                           loadingBuilder: (context, child, loadingProgress) {
//                             if (loadingProgress == null) return child;
//                             return Center(
//                               child: CircularProgressIndicator(
//                                 value:
//                                     loadingProgress.expectedTotalBytes != null
//                                     ? loadingProgress.cumulativeBytesLoaded /
//                                           loadingProgress.expectedTotalBytes!
//                                     : null,
//                                 color: AppColors.primaryTeal(context),
//                               ),
//                             );
//                           },
//                           errorBuilder: (context, error, stackTrace) =>
//                               const Center(
//                                 child: Icon(
//                                   Icons.broken_image,
//                                   size: 50,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             // 🔴 مؤشر عدد الصفحات (مثلاً: صفحة 1 من 3)
//             if (images.length > 1)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Text(
//                   S.of(context).swipeToSeeMorePages(images.length),
//                   style: const TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ),
//           ],
//         ),
//       );
//     });
//   }

//   Widget _buildResponsiveHeader(BuildContext context, double padding) {
//     return Container(
//       width: double.infinity,
//       height: 43,
//       margin: EdgeInsetsDirectional.fromSTEB(padding, 20, padding, 10),
//       decoration: BoxDecoration(
//         color: AppColors.cardBg(context),
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Row(
//           children: [
//             _headerLink(
//               S.of(context).examMaterials,
//               () => widget.onItemSelected(1),
//             ),
//             _headerSeparator(),
//             _headerLink(widget.subjectName, widget.onBack),
//             _headerSeparator(),
//             Text(
//               widget.examTitle, // نعرض اسم الاختبار هنا
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

//   Widget _headerLink(String text, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: Text(
//         text,
//         style: const TextStyle(color: Colors.grey, fontSize: 13),
//       ),
//     );
//   }

//   Widget _headerSeparator() {
//     return const Padding(
//       padding: EdgeInsets.symmetric(horizontal: 5),
//       child: Icon(Icons.chevron_left, color: Colors.grey, size: 16),
//     );
//   }
// }

// // ==========================================
// // مكونات مصغرة (تم تعديلها لتقبل البيانات)
// // ==========================================

// class _ExamStatsGrid extends StatelessWidget {
//   final bool isMobile;
//   final Map stats;
//   const _ExamStatsGrid({required this.isMobile, required this.stats});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(isMobile ? 10 : 15),
//       decoration: BoxDecoration(
//         color: AppColors.cardBg(context),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _statItem(
//             context,
//             S.of(context).examTotalQuestions,
//             stats["total_questions"] ?? "0",
//             const Color(0xFFDBEAFE),
//             Icons.list_alt,
//           ),
//           _statItem(
//             context,
//             S.of(context).examWrongAnswers,
//             stats["wrong"] ?? "0",
//             const Color(0xFFFFE2E2),
//             Icons.close,
//           ),
//           _statItem(
//             context,
//             S.of(context).examPartialAnswers,
//             stats["partial"] ?? "0",
//             const Color(0xFFFEF9C2),
//             Icons.priority_high,
//           ),
//           _statItem(
//             context,
//             S.of(context).examCorrectAnswers,
//             stats["correct"] ?? "0",
//             const Color(0xFFDCFCE7),
//             Icons.check,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _statItem(
//     BuildContext context,
//     String label,
//     String value,
//     Color color,
//     IconData icon,
//   ) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, color: Colors.black45, size: isMobile ? 16 : 22),
//         ),
//         const SizedBox(height: 6),
//         Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: isMobile ? 14 : 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ExamReportActions extends StatefulWidget {
//   final int studentId;
//   final int examId;

//   const ExamReportActions({
//     super.key,
//     required this.studentId,
//     required this.examId,
//   });

//   @override
//   State<ExamReportActions> createState() => _ExamReportActionsState();
// }

// class ExamReportPreviewScreen extends StatelessWidget {
//   final int studentId;
//   final int examId;

//   const ExamReportPreviewScreen({
//     super.key,
//     required this.studentId,
//     required this.examId,
//   });

//   Future<Uint8List> _fetchPdfFromPython(BuildContext context) async {
//     String langCode = Localizations.localeOf(context).languageCode;
//     // 🔴 نرسل الثيم للباك إند عشان يغير ألوان الـ PDF
//     String themeMode = Theme.of(context).brightness == Brightness.dark
//         ? 'dark'
//         : 'light';

//     final url = Uri.parse(
//       'http://127.0.0.1:8000/api/download-exam-report/$studentId/$examId?lang=$langCode&theme=$themeMode',
//     );

//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       return response.bodyBytes;
//     } else {
//       throw Exception('فشل جلب الملف من الخادم');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.secondaryTeal(context),
//       appBar: AppBar(
//         // 🔴 غيرنا لون الشريط ليكون التركواز الأساسي
//         backgroundColor: AppColors.primaryTeal(context),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           S.of(context).previewReportTitle ?? 'معاينة تقرير النتيجة',
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Theme(
//         // 🔴 هنا السحر! نجبر المكتبة تستخدم التركواز بدل البنفسجي الافتراضي
//         data: Theme.of(context).copyWith(
//           primaryColor: AppColors.primaryTeal(context),
//           colorScheme: Theme.of(context).colorScheme.copyWith(
//             primary: AppColors.primaryTeal(context),
//             secondary: AppColors.primaryTeal(context),
//           ),
//         ),
//         child: PdfPreview(
//           scrollViewDecoration: BoxDecoration(
//             color: AppColors.secondaryTeal(context),
//           ),
//           build: (format) => _fetchPdfFromPython(context),
//           allowSharing: false,
//           allowPrinting: true,
//           canChangeOrientation: false,
//           canChangePageFormat: false,
//           canDebug: false,
//           pdfFileName: 'Exam_Report_$examId.pdf',
//           actions: [
//             PdfPreviewAction(
//               icon: const Icon(Icons.file_download),
//               onPressed: (context, build, pageFormat) async {
//                 final bytes = await build(pageFormat);
//                 await Printing.sharePdf(
//                   bytes: bytes,
//                   filename: 'Exam_Report_$examId.pdf',
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ExamReportActionsState extends State<ExamReportActions> {
//   bool _isLoading = false;

//   Future<void> _downloadOrPrintPdf({required bool isPrint}) async {
//     setState(() => _isLoading = true);
//     try {
//       String langCode = Localizations.localeOf(context).languageCode;
//       // ⚠️ ملاحظة: ضعي عنوان الـ IP الخاص بالسيرفر حقكم هنا
//       final String apiUrl =
//           'http://localhost:8000/api/download-exam-report/${widget.studentId}/${widget.examId}?lang=$langCode';
//       final Uri url = Uri.parse(apiUrl);

//       if (isPrint) {
//         // للطباعة، نفتح الرابط مباشرة أو نستخدم نافذة النظام
//         if (await canLaunchUrl(url)) {
//           await launchUrl(url);
//         } else {
//           _showError('لا يمكن فتح ملف الطباعة');
//         }
//       } else {
//         // للتحميل، نفتح الرابط في المتصفح ليحمل الـ PDF
//         if (await canLaunchUrl(url)) {
//           await launchUrl(url, mode: LaunchMode.externalApplication);
//         } else {
//           _showError('لا يمكن تحميل الملف');
//         }
//       }
//     } catch (e) {
//       _showError('تأكد من اتصالك بالإنترنت');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _showError(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const SizedBox(
//         height: 30,
//         width: 30,
//         child: CircularProgressIndicator(strokeWidth: 2),
//       );
//     }

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // زر الطباعة
//         ElevatedButton.icon(
//           onPressed: () => _downloadOrPrintPdf(isPrint: true),
//           icon: const Icon(Icons.print, size: 16),
//           label: const Text('طباعة'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF4FB7B5),
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             minimumSize: const Size(0, 30),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         // زر التحميل
//         OutlinedButton.icon(
//           onPressed: () => _downloadOrPrintPdf(isPrint: false),
//           icon: const Icon(Icons.download, size: 16),
//           label: const Text('تحميل'),
//           style: OutlinedButton.styleFrom(
//             foregroundColor: const Color(0xFF4FB7B5),
//             side: const BorderSide(color: Color(0xFF4FB7B5)),
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             minimumSize: const Size(0, 30),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _FinalScoreCard extends StatelessWidget {
//   final bool isMobile;
//   final Map stats;
//   const _FinalScoreCard({required this.isMobile, required this.stats});

//   @override
//   Widget build(BuildContext context) {
//     final examController = Get.find<ExamDetailsController>();
//     final dashController = Get.find<StudentDashboardController>();

//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [AppColors.primaryTeal(context), const Color(0xFF006D6D)],
//         ),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           FittedBox(
//             child: Text(
//               S.of(context).examResultTitle,
//               style: const TextStyle(color: Colors.white, fontSize: 12),
//             ),
//           ),
//           Obx(
//             () => Text(
//               "${examController.stats['total_earned_mark'] ?? 0}",
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Text(
//             S.of(context).examOutOf(stats["total"] ?? "100"),
//             style: const TextStyle(color: Colors.white, fontSize: 10),
//           ),

//           const SizedBox(height: 15),

//           // الزر اللي يفتح صفحة المعاينة الجديدة
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 // 1. استخراج رقم الطالب الحقيقي (أضفنا .value)
//                 int sId = dashController.currentStudentId;

//                 // 2. استخراج رقم الاختبار بأمان (إذا لم يجده سيعطي 0 بدلاً من 1)
//                 int eId =
//                     int.tryParse(
//                       examController.stats['exam_id']?.toString() ?? '0',
//                     ) ??
//                     0;

//                 // حماية: إذا كان الرقم 0، نمنع الانتقال وننبه المستخدم
//                 if (eId == 0) {
//                   Get.snackbar(
//                     'تنبيه',
//                     'بيانات الاختبار غير مكتملة، يرجى الانتظار أو تحديث الصفحة',
//                   );
//                   return;
//                 }

//                 // 3. الانتقال للشاشة مع الأرقام الصحيحة 100%
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         ExamReportPreviewScreen(studentId: sId, examId: eId),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: AppColors.primaryTeal(context),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(
//                 S.of(context).previewReportTitle,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // class _FinalScoreCard extends StatelessWidget {
// //   final bool isMobile;
// //   final Map stats;
// //   const _FinalScoreCard({required this.isMobile, required this.stats});

// //   @override
// //   Widget build(BuildContext context) {
// //     final examController = Get.find<ExamDetailsController>();
// //     final dashController = Get.find<StudentDashboardController>();
// //     return Container(
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           colors: [AppColors.primaryTeal(context), const Color(0xFF006D6D)],
// //         ),
// //         borderRadius: BorderRadius.circular(16),
// //       ),
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           FittedBox(
// //             child: Text(
// //               S.of(context).examResultTitle,
// //               style: const TextStyle(color: Colors.white, fontSize: 12),
// //             ),
// //           ),
// //           // في مكان عرض الدرجة في الشاشة
// //           Obx(
// //             () => Text(
// //               "${examController.stats['total_earned_mark'] ?? 0}",
// //               style: const TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),

// //           Text(
// //             S.of(context).examOutOf(stats["total"] ?? "100"),
// //             style: const TextStyle(color: Colors.white, fontSize: 10),
// //           ),
// //           const SizedBox(height: 8),
// //           SizedBox(
// //             width: double.infinity,
// //             child: ElevatedButton(
// //               onPressed: () {
// //                 // 1. جلب الكنترولر (تأكدي أنه معرف في الـ build)
// //                 final examController = Get.find<ExamDetailsController>();
// //                 final dashController = Get.find<StudentDashboardController>();

// //                 // 2. سحب الدرجة الحقيقية باستخدام المسميات الموجودة في البايثون (total_earned و total_marks)
// //                 final String studentGrade =
// //                     examController.stats['total_earned_mark']?.toString() ??
// //                     "0";
// //                 final String maxGrade =
// //                     examController.stats['total_marks']?.toString() ?? "0";
// //                 final String totalScore = "$studentGrade / $maxGrade";

// //                 // 3. جلب قائمة الأسئلة الحقيقية
// //                 final List<dynamic> realQuestions = examController.questions;

// //                 // 4. إعدادات اللغة والثيم
// //                 final localeProvider = Provider.of<LocaleProvider>(
// //                   context,
// //                   listen: false,
// //                 );
// //                 final bool isArabic =
// //                     localeProvider.locale.languageCode == 'ar';
// //                 final bool isDark =
// //                     Theme.of(context).brightness == Brightness.dark;

// //                 // 5. تجهيز نصوص الترجمة
// //                 final Map<String, String> translatedLabels = {
// //                   'titleSystem':
// //                       S.of(context).systemName ?? 'نظام التصحيح الذكي',
// //                   'titleReport':
// //                       S.of(context).reportTitle ?? 'تقرير نتيجة اختبار تفصيلي',
// //                   'lblStudent': S.of(context).studentName ?? 'اسم الطالب:',
// //                   'lblLevel': S.of(context).level ?? 'المستوى:',
// //                   'lblExam': S.of(context).exam ?? 'الاختبار:',
// //                   'lblDate': S.of(context).date ?? 'التاريخ:',
// //                   'lblDetails':
// //                       S.of(context).details ?? 'تفاصيل الإجابات والتقييم:',
// //                   'lblTotalScore':
// //                       S.of(context).totalScore ?? 'الدرجة النهائية:',
// //                   'colNo': S.of(context).colNo ?? 'الرقم',
// //                   'colQuestion': S.of(context).colQuestion ?? 'نص السؤال',
// //                   'colStudentAns':
// //                       S.of(context).colStudentAns ?? 'إجابة الطالب',
// //                   'colModelAns':
// //                       S.of(context).colModelAns ?? 'الإجابة النموذجية',
// //                   'colScore': S.of(context).colScore ?? 'الدرجة',
// //                 };

// //                 // الآن استدعي Navigator.push و PdfPreview مررّي لها البيانات أعلاه

// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (context) => Theme(
// //                       // 🔴 فرض ثيم شريط الأدوات ليأخذ لون التركواز الخاص بك
// //                       data: Theme.of(context).copyWith(
// //                         primaryColor: AppColors.primaryTeal(context),
// //                         appBarTheme: AppBarTheme(
// //                           backgroundColor: AppColors.secondaryTeal(context),
// //                           iconTheme: IconThemeData(
// //                             color: AppColors.primaryTeal(context),
// //                             size: 18, // تقدرين تخلينه Colors.white حسب ذوقك
// //                           ),
// //                           foregroundColor: Colors.white,
// //                         ),
// //                       ),
// //                       child: Scaffold(
// //                         appBar: AppBar(
// //                           backgroundColor: AppColors.secondaryTeal(context),
// //                           titleSpacing: 0,
// //                           title: Text(
// //                             // قراءة النص من ملف الترجمة مباشرة
// //                             S.of(context).previewReportTitle ??
// //                                 "معاينة تقرير النتيجة",
// //                             style: TextStyle(
// //                               fontSize: 18,
// //                               fontWeight: FontWeight.bold,
// //                               color: AppColors.primaryTeal(context),
// //                               // سحب نوع الخط الأساسي الخاص بتطبيقك تلقائياً
// //                               fontFamily: Theme.of(
// //                                 context,
// //                               ).textTheme.bodyLarge?.fontFamily,
// //                             ),
// //                           ),
// //                         ),
// //                         body: PdfPreview(
// //                           initialPageFormat: PdfPageFormat.a4,
// //                           // 🔴 الأزرار الـ 3 المطلوبة فقط
// //                           allowPrinting: true, // 1. زر الطباعة
// //                           allowSharing: true, // 2. زر المشاركة
// //                           canDebug: false,
// //                           scrollViewDecoration: BoxDecoration(
// //                             color: AppColors.secondaryTeal(
// //                               context,
// //                             ), // غيريه للون اللي تبغينه
// //                           ), // إلغاء زر التفعيل المزعج
// //                           canChangeOrientation: false, // إلغاء زر تغيير الاتجاه
// //                           canChangePageFormat:
// //                               false, // إلغاء زر تغيير حجم الصفحة
// //                           actions: [
// //                             // 3. زر التحميل
// //                             PdfPreviewAction(
// //                               icon: const Icon(Icons.file_download),
// //                               onPressed: (context, build, pageFormat) async {
// //                                 final bytes = await build(pageFormat);
// //                                 await Printing.sharePdf(
// //                                   bytes: bytes,
// //                                   filename: 'Exam_Report.pdf',
// //                                 );
// //                               },
// //                             ),
// //                           ],
// //                           build: (format) => PdfHelper.generateExamReport(
// //                             studentData: Map<String, dynamic>.from(
// //                               dashController.studentData,
// //                             ),
// //                             examTitle: "examTitle",
// //                             isArabic: isArabic,
// //                             isDarkMode: isDark, // تمرير الدارك مود
// //                             logoPath: 'assets/logo.png',
// //                             labels: translatedLabels, // تمرير الترجمة
// //                             questions: realQuestions, // بيانات الداتا بيس
// //                             finalScore: totalScore, // الدرجة النهائية
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               },
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Colors.white,
// //                 foregroundColor: AppColors.primaryTeal(context),
// //                 padding: EdgeInsets.zero,
// //                 minimumSize: const Size(0, 30),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //               ),
// //               child: Text(
// //                 S.of(context).examDownload,
// //                 style: const TextStyle(fontSize: 11),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// class _QuestionCard extends StatelessWidget {
//   final Map<String, dynamic> data;
//   final bool isMobile;
//   const _QuestionCard({required this.data, required this.isMobile});

//   Color _getStatusColor() {
//     if (data['score'] == data['total']) return const Color(0xFF00A63E); // كامل
//     if (data['score'] > 0) return const Color(0xFFD08700); // جزئي
//     return const Color(0xFFE7000B); // خاطئ
//   }

//   @override
//   Widget build(BuildContext context) {
//     final color = _getStatusColor();
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 S.of(context).examQuestionNumber(data['id']),
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 "${data['score'].toInt()}/${data['total'].toInt()}",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                   fontSize: 18,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Text(data['text'], style: const TextStyle(height: 1.5)),
//           const SizedBox(height: 15),
//           Row(
//             children: [
//               _answerBox(
//                 S.of(context).examModelAnswer,
//                 data['modelAnswer'],
//                 context,
//               ),
//               const SizedBox(width: 10),
//               _answerBox(
//                 S.of(context).examYourAnswer,
//                 data['studentAnswer'],
//                 context,
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: AppColors.cardBg(context),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.auto_awesome,
//                   size: 16,
//                   color: AppColors.primaryTeal(context),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: RichText(
//                     text: TextSpan(
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: AppColors.textPrimary(context),
//                         fontFamily: 'Arimo',
//                       ),
//                       children: [
//                         TextSpan(
//                           text: "${S.of(context).examAiEvaluation}: ",
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         TextSpan(text: data['evaluation']),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _answerBox(String title, String content, BuildContext context) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
//           const SizedBox(height: 4),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: AppColors.cardBg(context),
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: Text(
//               content,
//               style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _TabButton extends StatelessWidget {
//   final String label;
//   final bool isActive;
//   final VoidCallback onTap;

//   const _TabButton({
//     required this.label,
//     required this.isActive,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(10),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         decoration: BoxDecoration(
//           color: isActive ? AppColors.primaryTeal(context) : Colors.transparent,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: isActive ? Colors.white : Colors.grey,
//             fontWeight: FontWeight.bold,
//             fontSize: 13,
//           ),
//         ),
//       ),
//     );
//   }
// }
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: isActive ? Colors.white : Colors.grey,
//             fontWeight: FontWeight.bold,
//             fontSize: 13,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grade/core/locale_provider.dart';
import '../core/colors.dart';
import '../generated/l10n.dart';
import '../provider/exam_details_controller.dart';
import '../provider/student_dashboard_controller.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';
import 'package:printing/printing.dart';

class StudentExamScreen extends StatefulWidget {
  final String subjectName;
  final String examTitle;
  final int examId; // 👈 التعديل: إضافة المتغير الجديد هنا
  final VoidCallback onBack;
  final Function(int) onItemSelected;

  const StudentExamScreen({
    super.key,
    required this.subjectName,
    required this.examTitle,
    required this.examId, // 👈 وهنا
    required this.onBack,
    required this.onItemSelected,
  });

  @override
  State<StudentExamScreen> createState() => _StudentExamScreenState();
}

class _StudentExamScreenState extends State<StudentExamScreen> {
  bool isDetailedCorrection = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 🛡️ درع الحماية هنا
      if (!mounted) return;

      final dashController = context.read<StudentDashboardController>();
      final examController = context.read<ExamDetailsController>();

      int realStudentId = dashController.currentStudentId;
      examController.fetchExamDetails(
        realStudentId,
        widget.examId,
        context: context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryTeal(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          bool isMobile = width < 650;
          double horizontalPadding = isMobile ? 16.0 : 33.0;

          return Column(
            children: [
              _buildResponsiveHeader(context, horizontalPadding),
              Expanded(
                child: Consumer<ExamDetailsController>(
                  builder: (context, controller, child) {
                    if (controller.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    return SingleChildScrollView(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          _buildStatsAndScoreSection(isMobile, controller),
                          const SizedBox(height: 25),
                          _buildMainContentSection(isMobile, controller),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatsAndScoreSection(
    bool isMobile,
    ExamDetailsController controller,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: _ExamStatsGrid(isMobile: isMobile, stats: controller.stats),
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: isMobile ? 3 : 2,
            child: _FinalScoreCard(isMobile: isMobile, stats: controller.stats),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContentSection(
    bool isMobile,
    ExamDetailsController controller,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildTabs(isMobile),
          Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Padding(
              key: ValueKey<bool>(isDetailedCorrection),
              padding: EdgeInsets.all(isMobile ? 15 : 25),
              child: isDetailedCorrection
                  ? _buildDetailedQuestionsList(isMobile, controller)
                  : _buildOriginalPaperView(controller),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _TabButton(
            label: S.of(context).examDetailedCorrection,
            isActive: isDetailedCorrection,
            onTap: () => setState(() => isDetailedCorrection = true),
          ),
          const SizedBox(width: 10),
          _TabButton(
            label: S.of(context).examAnswerPaper,
            isActive: !isDetailedCorrection,
            onTap: () => setState(() => isDetailedCorrection = false),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedQuestionsList(
    bool isMobile,
    ExamDetailsController controller,
  ) {
    if (controller.questions.isEmpty) {
      return Center(child: Text(S.of(context).no_questions_yet));
    }
    return Column(
      children: controller.questions
          .map((data) => _QuestionCard(data: data, isMobile: isMobile))
          .toList(),
    );
  }

  Widget _buildOriginalPaperView(ExamDetailsController controller) {
    final images = controller.originalPaperImages;

    if (images.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_drive_file_outlined,
                size: 50,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 10),
              Text(
                S.of(context).noPaperImagesUploaded,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 400,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: InteractiveViewer(
                      panEnabled: true,
                      minScale: 1.0,
                      maxScale: 4.0,
                      child: Image.network(
                        images[index],
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              color: AppColors.primaryTeal(context),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (images.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                S.of(context).swipeToSeeMorePages(images.length),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResponsiveHeader(BuildContext context, double padding) {
    return Container(
      width: double.infinity,
      height: 43,
      margin: EdgeInsetsDirectional.fromSTEB(padding, 20, padding, 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            _headerLink(
              S.of(context).examMaterials,
              () => widget.onItemSelected(1),
            ),
            _headerSeparator(),
            _headerLink(widget.subjectName, widget.onBack),
            _headerSeparator(),
            Text(
              widget.examTitle,
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

  Widget _headerLink(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(color: Colors.grey, fontSize: 13),
      ),
    );
  }

  Widget _headerSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Icon(Icons.chevron_left, color: Colors.grey, size: 16),
    );
  }
}

// ==========================================
// مكونات مصغرة
// ==========================================

class _ExamStatsGrid extends StatelessWidget {
  final bool isMobile;
  final Map stats;
  const _ExamStatsGrid({required this.isMobile, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 10 : 15),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(
            context,
            S.of(context).examTotalQuestions,
            stats["total_questions"] ?? "0",
            const Color(0xFFDBEAFE),
            Icons.list_alt,
          ),
          _statItem(
            context,
            S.of(context).examWrongAnswers,
            stats["wrong"] ?? "0",
            const Color(0xFFFFE2E2),
            Icons.close,
          ),
          _statItem(
            context,
            S.of(context).examPartialAnswers,
            stats["partial"] ?? "0",
            const Color(0xFFFEF9C2),
            Icons.priority_high,
          ),
          _statItem(
            context,
            S.of(context).examCorrectAnswers,
            stats["correct"] ?? "0",
            const Color(0xFFDCFCE7),
            Icons.check,
          ),
        ],
      ),
    );
  }

  Widget _statItem(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.black45, size: isMobile ? 16 : 22),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: isMobile ? 14 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _FinalScoreCard extends StatelessWidget {
  final bool isMobile;
  final Map stats;
  const _FinalScoreCard({required this.isMobile, required this.stats});

  @override
  Widget build(BuildContext context) {
    final examController = context.watch<ExamDetailsController>();
    final dashController = context.read<StudentDashboardController>();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryTeal(context), const Color(0xFF006D6D)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: Text(
              S.of(context).examResultTitle,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          Text(
            "${examController.stats['total_earned_mark'] ?? 0}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          // داخل كلاس _FinalScoreCard، ابحثي عن هذا السطر واستبدليه:
          Text(
            S
                .of(context)
                .examOutOf(
                  stats["total_marks"]?.toString() ?? "100",
                ), // 👈 التعديل هنا: total_marks بدلاً من total
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                int sId = dashController.currentStudentId;
                int eId =
                    int.tryParse(
                      examController.stats['exam_id']?.toString() ?? '0',
                    ) ??
                    0;

                if (eId == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        S.of(context).err_incomplete_exam_data,
                      ),
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ExamReportPreviewScreen(studentId: sId, examId: eId),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryTeal(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                S.of(context).previewReportTitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExamReportActions extends StatefulWidget {
  final int studentId;
  final int examId;

  const ExamReportActions({
    super.key,
    required this.studentId,
    required this.examId,
  });

  @override
  State<ExamReportActions> createState() => _ExamReportActionsState();
}

class _ExamReportActionsState extends State<ExamReportActions> {
  bool _isLoading = false;

  Future<void> _downloadOrPrintPdf({required bool isPrint}) async {
    setState(() => _isLoading = true);
    try {
      String langCode = Localizations.localeOf(context).languageCode;
      final String apiUrl =
          'https://smart-grader-full.onrender.com/api/download-exam-report/${widget.studentId}/${widget.examId}?lang=$langCode';
      final Uri url = Uri.parse(apiUrl);

      if (isPrint) {
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          if (!mounted) return; // 🌟 حماية
          _showError(S.of(context).err_cannot_open_print_file);
        }
      } else {
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          if (!mounted) return; // 🌟 حماية
          _showError(S.of(context).err_cannot_download_file);
        }
      }
    } catch (e) {
      if (!mounted) return; // 🌟 حماية
      _showError(S.of(context).err_check_internet);
    } finally {
      // 🌟 أهم حماية: ممنوع عمل setState إذا الشاشة مقفلة!
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 30,
        width: 30,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: () => _downloadOrPrintPdf(isPrint: true),
          icon: const Icon(Icons.print, size: 16),
          label: Text(S.of(context).print),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4FB7B5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: const Size(0, 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: () => _downloadOrPrintPdf(isPrint: false),
          icon: const Icon(Icons.download, size: 16),
          label: Text(S.of(context).download),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF4FB7B5),
            side: const BorderSide(color: Color(0xFF4FB7B5)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: const Size(0, 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

class ExamReportPreviewScreen extends StatelessWidget {
  final int studentId;
  final int examId;

  const ExamReportPreviewScreen({
    super.key,
    required this.studentId,
    required this.examId,
  });

  Future<Uint8List> _fetchPdfFromPython(BuildContext context) async {
    String langCode = Localizations.localeOf(context).languageCode;
    String themeMode = Theme.of(context).brightness == Brightness.dark
        ? 'dark'
        : 'light';
    final url = Uri.parse(
      'https://smart-grader-full.onrender.com/api/download-exam-report/$studentId/$examId?lang=$langCode&theme=$themeMode',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception(S.current.err_fetch_file_failed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryTeal(context),
      appBar: AppBar(
        backgroundColor: AppColors.primaryTeal(context),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context).previewReportTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: AppColors.primaryTeal(context),
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: AppColors.primaryTeal(context),
            secondary: AppColors.primaryTeal(context),
          ),
        ),
        child: PdfPreview(
          scrollViewDecoration: BoxDecoration(
            color: AppColors.secondaryTeal(context),
          ),
          build: (format) => _fetchPdfFromPython(context),
          allowSharing: false,
          allowPrinting: true,
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          pdfFileName: 'Exam_Report_$examId.pdf',
          actions: [
            PdfPreviewAction(
              icon: const Icon(Icons.file_download),
              onPressed: (context, build, pageFormat) async {
                final bytes = await build(pageFormat);
                await Printing.sharePdf(
                  bytes: bytes,
                  filename: 'Exam_Report_$examId.pdf',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isMobile;
  const _QuestionCard({required this.data, required this.isMobile});

  Color _getStatusColor() {
    if (data['score'] == data['total']) return const Color(0xFF00A63E);
    if (data['score'] > 0) return const Color(0xFFD08700);
    return const Color(0xFFE7000B);
  }

  bool _isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    bool isQuestionArabic = _isArabic(data['text'] ?? '');
    bool isEvalArabic = _isArabic(data['evaluation'] ?? '');
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).examQuestionNumber(data['id']),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "${data['score'].toInt()}/${data['total'].toInt()}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 🌟 تطبيق التعرف الذكي على السؤال
          SizedBox(
            width: double.infinity,
            child: Text(
              data['text'],
              style: const TextStyle(height: 1.5),
              textAlign: isQuestionArabic ? TextAlign.right : TextAlign.left,
              textDirection: isQuestionArabic
                  ? TextDirection.rtl
                  : TextDirection.ltr,
            ),
          ),

          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _answerBox(
                S.of(context).examModelAnswer,
                data['modelAnswer'] ?? '',
                context,
              ),
              const SizedBox(width: 10),
              _answerBox(
                S.of(context).examYourAnswer,
                data['studentAnswer'] ?? '',
                context,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cardBg(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 16,
                  color: AppColors.primaryTeal(context),
                ),
                const SizedBox(width: 8),
                Expanded(
                  // 🌟 تطبيق التعرف الذكي على التقييم
                  child: RichText(
                    textDirection: isEvalArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary(context),
                        fontFamily: 'Arimo',
                      ),
                      children: [
                        TextSpan(
                          text: "${S.of(context).examAiEvaluation}: ",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: data['evaluation']),
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
  }

  Widget _answerBox(String title, String content, BuildContext context) {
    // 🌟 تطبيق التعرف الذكي على مربعات الإجابة
    bool isContentArabic = _isArabic(content);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.cardBg(context),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              content,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              // تعديل المحاذاة والاتجاه ليكون يمين إذا النص عربي، ويسار إذا إنجليزي
              textAlign: isContentArabic ? TextAlign.right : TextAlign.left,
              textDirection: isContentArabic
                  ? TextDirection.rtl
                  : TextDirection.ltr,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryTeal(context) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
