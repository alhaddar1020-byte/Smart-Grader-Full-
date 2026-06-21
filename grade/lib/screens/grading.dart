// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../core/colors.dart';
// import 'teacher_dashboard.dart' hide HeaderWidget;
// import 'teacher_matearial.dart'  hide HeaderWidget;
// import '../generated/l10n.dart'; 
// import 'review_exam_screen.dart';
// import 'teacer_setting.dart';
// import 'ExamManagementPage.dart';
// import 'teacher_profile_settings_page.dart';

// class GradingPage extends StatefulWidget {
//   const GradingPage({super.key});

//   @override
//   State<GradingPage> createState() => _GradingPageState();
// }

// class _GradingPageState extends State<GradingPage> {
//   // المتحكمات للحقول التي ستملأ تلقائياً (للقراءة فقط)
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController questionsCountController = TextEditingController();
//   final TextEditingController totalGradeController = TextEditingController();

//   // متغيرات الربط الديناميكي
//   int? selectedCourseId;
//   int? selectedExamId;
//   List<dynamic> teacherCourses = []; // قائمة المواد من الداتابيس
//   List<dynamic> courseExams = [];    // قائمة الاختبارات التابعة للمادة

//   List<PlatformFile> selectedFiles = [];
//   bool isGrading = false;
//   bool isGradingComplete = false;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     // جلب البيانات فور تشغيل الصفحة
//     _fetchInitialData();
//   }

  

// Future<void> _fetchInitialData() async {
//   try {
//     final response = await http.get(Uri.parse('http://127.0.0.1:8000/teacher-materials/1'));
    
//     if (response.statusCode == 200) {
//       var decodedData = json.decode(response.body);
      
//       setState(() {
//         // التعديل هنا: الدخول إلى داخل مفتاح 'courses'
//         if (decodedData is Map && decodedData.containsKey('courses')) {
//           teacherCourses = decodedData['courses'];
//         } else if (decodedData is List) {
//           teacherCourses = decodedData;
//         }
//       });
      
//       debugPrint("✅ تم جلب ${teacherCourses.length} مواد بنجاح");
//     }
//   } catch (e) {
//     debugPrint("❌ خطأ في معالجة البيانات: $e");
//   }
// }
//   // 2. جلب الاختبارات (Exams) عند اختيار مادة معينة
//   Future<void> _fetchExamsForCourse(int courseId) async {
//     try {
//       final response = await http.get(Uri.parse('http://127.0.0.1:8000/exams/by-course/$courseId'));
//       if (response.statusCode == 200) {
//         var decodedExams = json.decode(response.body);
//         setState(() {
//           if (decodedExams is List) {
//             courseExams = decodedExams;
//           } else if (decodedExams is Map) {
//             courseExams = [decodedExams];
//           }
//           selectedExamId = null; // إعادة تعيين الاختبار المختار
//           _clearExamFields(); // مسح الحقول التلقائية
//         });
//         debugPrint("✅ Exams loaded for course $courseId: ${courseExams.length}");
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching exams: $e");
//     }
//   }

//   void _clearExamFields() {
//     dateController.clear();
//     questionsCountController.clear();
//     totalGradeController.clear();
//   }

//   Future<void> pickFiles() async {
//     if (isGrading) return;
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       allowMultiple: true,
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       setState(() {
//         selectedFiles.addAll(result.files);
//       });
//     }
//   }

//   // 3. عملية التصحيح والرفع الفعلي باستخدام 127.0.0.1 لضمان الاتصال في المتصفح
//   Future<void> _processGrading() async {
//     if (selectedFiles.isEmpty || selectedExamId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(S.of(context).ready_to_start_grading), backgroundColor: Colors.orange),
//       );
//       return;
//     }

//     setState(() {
//       isGrading = true;
//       isGradingComplete = false;
//     });

//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('http://127.0.0.1:8000/grading/upload-sheets/$selectedExamId'),
//       );

//       for (var file in selectedFiles) {
//         if (file.bytes != null) {
//           request.files.add(http.MultipartFile.fromBytes('files', file.bytes!, filename: file.name));
//         } else if (file.path != null) {
//           request.files.add(await http.MultipartFile.fromPath('files', file.path!));
//         }
//       }

//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         await Future.delayed(const Duration(seconds: 2)); 
//         setState(() {
//           isGrading = false;
//           isGradingComplete = true;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("✅ تم رفع الأوراق وبدأ التصحيح بنجاح"), backgroundColor: Colors.green),
//         );
//       } else {
//         throw Exception("فشل رفع الملفات");
//       }
//     } catch (e) {
//       setState(() => isGrading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ حدث خطأ: $e"), backgroundColor: Colors.red),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     dateController.dispose();
//     questionsCountController.dispose();
//     totalGradeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool hasFiles = selectedFiles.isNotEmpty;

//     return LayoutBuilder(builder: (context, constraints) {
//       bool isMobile = constraints.maxWidth < 850;
//       bool isTablet = constraints.maxWidth >= 850 && constraints.maxWidth < 1150;

//       return Scaffold(
//         key: _scaffoldKey,
//         backgroundColor: AppColors.secondaryTeal(context),
//         drawer: isMobile
//             ? Drawer(
//                 width: 260,
//                 backgroundColor: AppColors.primaryTeal(context),
//                 child: SafeArea(
//                   child: CustSidebar(
//                     selectedIndex: 3,
//                     isCompact: false,
//                     onItemSelected: _handleNavigation,
//                   ),
//                 ),
//               )
//             : null,
//         body: Row(
//           children: [
//             if (!isMobile)
//               CustSidebar(
//                 selectedIndex: 3,
//                 isCompact: isTablet,
//                 onItemSelected: _handleNavigation,
//               ),
//             Expanded(
//               child: Column(
//                 children: [
//                   if (isMobile) _buildMobileAppBar(),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: isMobile ? 12 : 24,
//                         vertical: 20,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const HeaderWidget(),
//                           const SizedBox(height: 15),
//                           _buildExamInfoSection(isMobile, isTablet),
//                           const SizedBox(height: 15),
//                           _buildResponsiveUploadRow(isMobile, hasFiles),
//                           const SizedBox(height: 25),
//                           if (isGradingComplete)
//                             _buildCompleteCard()
//                           else if (isGrading)
//                             _buildProcessingCard()
//                           else if (hasFiles)
//                             _buildFileListSection(),
//                           const SizedBox(height: 40),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }

//   Widget _buildExamInfoSection(bool isMobile, bool isTablet) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       width: double.infinity,
//       decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(S.of(context).exam_information, style: const TextStyle(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 12),
//           Wrap(
//             spacing: 10,
//             runSpacing: 10,
//             children: [
//               _buildDropdownField(
//                 label: S.of(context).course_subject,
//                 value: selectedCourseId,
//                 items: teacherCourses.map((c) => DropdownMenuItem<int>(
//                   value: c['course_id'],
//                   child: Text(c['course_name'] ?? ""),
//                 )).toList(),
//                 onChanged: (val) {
//                   setState(() => selectedCourseId = val);
//                   _fetchExamsForCourse(val!);
//                 },
//                 isMobile: isMobile,
//               ),
//               _buildDropdownField(
//                 label: S.of(context).exam_name,
//                 value: selectedExamId,
//                 items: courseExams.map((e) => DropdownMenuItem<int>(
//                   value: e['exam_id'],
//                   child: Text(e['exam_title'] ?? ""),
//                 )).toList(),
//                 onChanged: (val) {
//                   setState(() {
//                     selectedExamId = val;
//                     var exam = courseExams.firstWhere((e) => e['exam_id'] == val);
//                     dateController.text = exam['exam_date'] ?? "";
//                     questionsCountController.text = exam['number_of_questions'].toString();
//                     totalGradeController.text = exam['total_marks'].toString();
//                   });
//                 },
//                 isMobile: isMobile,
//               ),
//               _infoTextField(S.of(context).exam_date, dateController, isMobile, readOnly: true),
//               _infoTextField(S.of(context).number_of_questions, questionsCountController, isMobile, readOnly: true),
//               _infoTextField(S.of(context).total_grade, totalGradeController, isMobile, readOnly: true),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDropdownField({
//     required String label,
//     required dynamic value,
//     required List<DropdownMenuItem<int>> items,
//     required Function(int?) onChanged,
//     required bool isMobile,
//   }) {
//     double fieldWidth = isMobile ? (MediaQuery.of(context).size.width - 60) : 180;
//     return SizedBox(
//       width: fieldWidth,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
//           const SizedBox(height: 4),
//           DropdownButtonFormField<int>(
//             value: value,
//             items: items,
//             onChanged: isGrading ? null : onChanged,
//             decoration: InputDecoration(
//               isDense: true,
//               filled: true,
//               fillColor: AppColors.secondaryTeal(context).withOpacity(0.3),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
//             ),
//             style: const TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _infoTextField(String label, TextEditingController controller, bool isMobile, {bool readOnly = false}) {
//     double fieldWidth = isMobile ? (MediaQuery.of(context).size.width - 60) : 180;
//     return SizedBox(
//       width: fieldWidth,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
//           const SizedBox(height: 4),
//           TextField(
//             controller: controller,
//             readOnly: readOnly,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
//             decoration: InputDecoration(
//               isDense: true,
//               filled: true,
//               fillColor: AppColors.secondaryTeal(context).withOpacity(0.1),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- بقية الودجت من كودك الأصلي ---
//   Widget _buildMobileAppBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
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
//             Text(S.of(context).auto_grading, style: const TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildResponsiveUploadRow(bool isMobile, bool hasFiles) {
//     if (isMobile) {
//       return Column(
//         children: [
//           _buildUploadCard(isFullWidth: true),
//           const SizedBox(height: 16),
//           _buildStatusCard(hasFiles, isFullWidth: true),
//         ],
//       );
//     }
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildUploadCard(isFullWidth: false),
//         const SizedBox(width: 20),
//         _buildStatusCard(hasFiles, isFullWidth: false),
//       ],
//     );
//   }

//   Widget _buildUploadCard({required bool isFullWidth}) {
//     Widget card = Container(
//       height: 200,
//       decoration: BoxDecoration(
//         color: AppColors.textWhite(context),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.black12),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.cloud_upload_outlined,
//               size: 50, color: isGrading ? Colors.grey : AppColors.primaryTeal(context)),
//           const SizedBox(height: 10),
//           Text(S.of(context).click_to_select_files),
//           const SizedBox(height: 15),
//           ElevatedButton.icon(
//             onPressed: isGrading ? null : pickFiles,
//             icon: const Icon(Icons.file_upload, color: Colors.white),
//             label: Text(S.of(context).choose_files, style: const TextStyle(color: Colors.white)),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: isGrading ? Colors.grey[400] : AppColors.primaryTeal(context),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//     return isFullWidth ? card : Expanded(flex: 2, child: card);
//   }

//   Widget _buildStatusCard(bool hasFiles, {required bool isFullWidth}) {
//     Widget card = Container(
//       height: 200,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.textWhite(context),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             hasFiles ? Icons.check_circle_outline_rounded : Icons.priority_high_rounded,
//             size: 40,
//             color: isGrading ? Colors.grey : (hasFiles ? AppColors.primaryTeal(context) : Colors.orange),
//           ),
//           const SizedBox(height: 10),
//           Text(isGrading
//               ? S.of(context).processing_data
//               : (hasFiles ? S.of(context).ready_to_start_grading : S.of(context).no_papers_attached)),
//           Text("${selectedFiles.length} ${S.of(context).valid_answer_sheets}"),
//           const Spacer(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: (hasFiles && !isGrading) ? _processGrading : null,
//                 icon: const Icon(Icons.update_rounded, size: 18),
//                 label: Text(S.of(context).start_auto_grading, style: const TextStyle(fontSize: 13)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: (hasFiles && !isGrading) ? AppColors.primaryTeal(context) : Colors.grey[400],
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               OutlinedButton(
//                 onPressed: () => setState(() { if (isGrading) isGrading = false; else selectedFiles = []; }),
//                 style: OutlinedButton.styleFrom(side: BorderSide(color: isGrading ? Colors.grey : Colors.redAccent)),
//                 child: Text(S.of(context).cancel, style: TextStyle(color: isGrading ? Colors.grey : Colors.redAccent)),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//     return isFullWidth ? card : Expanded(flex: 3, child: card);
//   }

//   Widget _buildProcessingCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
//               const SizedBox(width: 8),
//               Text(S.of(context).auto_grading_in_progress, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
//             ],
//           ),
//           const SizedBox(height: 15),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(S.of(context).overall_progress, style: const TextStyle(fontSize: 12, color: Colors.black)),
//               Text("${(selectedFiles.length * 0.24).toInt()} / ${selectedFiles.length}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.orange)),
//             ],
//           ),
//           const SizedBox(height: 10),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: const LinearProgressIndicator(value: 0.24, minHeight: 10, backgroundColor: Color(0xFFE5E5E5), valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent)),
//           ),
//           const SizedBox(height: 15),
//           Row(
//             children: [
//               _statBox("29", S.of(context).completed, Icons.check_circle),
//               const SizedBox(width: 10),
//               _statBox("3", S.of(context).in_progress, Icons.sync),
//               const SizedBox(width: 10),
//               _statBox("88", S.of(context).waiting, Icons.access_time),
//               const SizedBox(width: 10),
//               _statBox("2", S.of(context).remaining, Icons.trending_up),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   // Widget _buildCompleteCard() {
//   //   return Container(
//   //     width: double.infinity,
//   //     padding: const EdgeInsets.all(24),
//   //     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.center,
//   //       children: [
//   //         Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.check_circle_outline, color: Colors.green, size: 28), const SizedBox(width: 8), Text(S.of(context).auto_grading_completed, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)))]),
//   //         const SizedBox(height: 15),
//   //         ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal(context), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)), child: Text(S.of(context).view_graded_papers, style: const TextStyle(color: Colors.white))),
//   //         const SizedBox(height: 20),
//   //         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(S.of(context).overall_progress), Text("${selectedFiles.length} / ${selectedFiles.length}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))]),
//   //         const SizedBox(height: 10),
//   //         ClipRRect(borderRadius: BorderRadius.circular(20), child: const LinearProgressIndicator(value: 1, minHeight: 10, backgroundColor: Color(0xFFE5E5E5), valueColor: AlwaysStoppedAnimation<Color>(Colors.green))),
//   //         const SizedBox(height: 20),
//   //         Row(
//   //           children: [
//   //             _statBox("${selectedFiles.length}", S.of(context).completed, Icons.check_circle),
//   //             const SizedBox(width: 10),
//   //             _statBox("0", S.of(context).in_progress, Icons.sync),
//   //             const SizedBox(width: 10),
//   //             _statBox("0", S.of(context).waiting, Icons.access_time),
//   //             const SizedBox(width: 10),
//   //             _statBox("0", S.of(context).remaining, Icons.trending_up),
//   //           ],
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//   Widget _buildCompleteCard() {
//   return Container(
//     width: double.infinity,
//     padding: const EdgeInsets.all(24),
//     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.check_circle_outline, color: Colors.green, size: 28), const SizedBox(width: 8), Text(S.of(context).auto_grading_completed, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)))]),
//         const SizedBox(height: 15),
//         ElevatedButton(
//           onPressed: () {
//             // الانتقال الحقيقي لشاشة مراجعة رصد النتائج مع تمرير معرف الاختبار المختار
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ReviewExamPage(examId: selectedExamId!),
//               ),
//             );
//           }, 
//           style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal(context), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)), 
//           child: Text(S.of(context).view_graded_papers, style: const TextStyle(color: Colors.white))
//         ),
//         const SizedBox(height: 20),
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(S.of(context).overall_progress), Text("${selectedFiles.length} / ${selectedFiles.length}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))]),
//         const SizedBox(height: 10),
//         ClipRRect(borderRadius: BorderRadius.circular(20), child: const LinearProgressIndicator(value: 1, minHeight: 10, backgroundColor: Color(0xFFE5E5E5), valueColor: AlwaysStoppedAnimation<Color>(Colors.green))),
//         const SizedBox(height: 20),
//         Row(
//           children: [
//             _statBox("${selectedFiles.length}", S.of(context).completed, Icons.check_circle),
//             const SizedBox(width: 10),
//             _statBox("0", S.of(context).in_progress, Icons.sync),
//             const SizedBox(width: 10),
//             _statBox("0", S.of(context).waiting, Icons.access_time),
//             const SizedBox(width: 10),
//             _statBox("0", S.of(context).remaining, Icons.trending_up),
//           ],
//         ),
//       ],
//     ),
//   );
// }

//   Widget _statBox(String number, String label, IconData icon) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//         decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           children: [
//             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(icon, size: 20, color: AppColors.primaryTeal(context)), Text(number, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)))]),
//             const SizedBox(height: 8),
//             Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFileListSection() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(15)),
//       child: Column(
//         children: [
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(S.of(context).uploaded_files, style: const TextStyle(fontWeight: FontWeight.bold)), TextButton(onPressed: () => setState(() => selectedFiles = []), child: Text(S.of(context).delete_all, style: const TextStyle(color: Colors.redAccent)))]),
//           const Divider(height: 30),
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: selectedFiles.length,
//             separatorBuilder: (context, index) => const Divider(height: 20),
//             itemBuilder: (context, index) => Row(children: [const Icon(Icons.check_circle, color: Colors.green, size: 20), const SizedBox(width: 10), Expanded(child: Text(selectedFiles[index].name, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)), IconButton(icon: const Icon(Icons.close, color: Colors.redAccent, size: 18), onPressed: () => setState(() => selectedFiles.removeAt(index)))]),
//           ),
//         ],
//       ),
//     );
//   }

//   void _handleNavigation(int index) {
//     if (index == 3) return;
//     if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);

//     Widget? page;
//     if (index == 0) page = const DashboardScreen();
//     if (index == 1) page = const ExamManagementPage();
//     if (index == 2) page = const Material1();
//     if (index == 4) page = const ReviewExamPage(); 
//     if (index == 5) page = const SettingsScreen(); 

//     if (page != null) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => page!),
//         (route) => false,
//       );
//     }
//   }
// }

// // ---------------------------------------------------------
// // HeaderWidget
// // ---------------------------------------------------------
// class HeaderWidget extends StatelessWidget {
//   const HeaderWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(
//         color: AppColors.textWhite(context), 
//         borderRadius: BorderRadius.circular(15)
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start, 
//             children: [
//               Text(
//                 S.of(context).upload_answer_sheets, 
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))
//               ), 
//               const SizedBox(height: 4), 
//               Text(
//                 S.of(context).upload_answer_sheets_desc, 
//                 style: const TextStyle(fontSize: 12, color: Colors.grey)
//               )
//             ]
//           ),
//           Row(
//             children: [
//               _iconButton(context, Icons.notifications_none, () {}),
//               const SizedBox(width: 10),
//               _iconButton(context, Icons.person_outline, () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const ProfileSettingsPage()),
//                 );
//               }),
//             ]
//           )
//         ],
//       ),
//     );
//   }

//   Widget _iconButton(BuildContext context, IconData icon, VoidCallback onTap) {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: AppColors.secondaryTeal(context), 
//             shape: BoxShape.circle
//           ),
//           child: Icon(icon, color: AppColors.primaryTeal(context)),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../core/colors.dart';
// import 'teacher_dashboard.dart' hide HeaderWidget;
// import 'teacher_matearial.dart'  hide HeaderWidget;
// import '../generated/l10n.dart'; 
// import 'review_exam_screen.dart';
// import 'teacer_setting.dart';
// import 'ExamManagementPage.dart';
// import 'teacher_profile_settings_page.dart';

// class GradingPage extends StatefulWidget {
//   const GradingPage({super.key});

//   @override
//   State<GradingPage> createState() => _GradingPageState();
// }

// class _GradingPageState extends State<GradingPage> {
//   // المتحكمات للحقول التي ستملأ تلقائياً (للقراءة فقط)
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController questionsCountController = TextEditingController();
//   final TextEditingController totalGradeController = TextEditingController();

//   // متغيرات الربط الديناميكي
//   int? selectedCourseId;
//   int? selectedExamId;
//   List<dynamic> teacherCourses = []; // قائمة المواد من الداتابيس
//   List<dynamic> courseExams = [];    // قائمة الاختبارات التابعة للمادة

//   List<PlatformFile> selectedFiles = [];
//   bool isGrading = false;
//   bool isGradingComplete = false;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     // جلب البيانات فور تشغيل الصفحة
//     _fetchInitialData();
//   }

//   // 1. جلب المواد (Courses) من السيرفر بتعامل مرن مع البيانات
//   Future<void> _fetchInitialData() async {
//     try {
//       final response = await http.get(Uri.parse('http://127.0.0.1:8000/teacher-materials/1'));
      
//       if (response.statusCode == 200) {
//         var decodedData = json.decode(response.body);
//         if (!mounted) return;
//         setState(() {
//           // الدخول إلى داخل مفتاح 'courses'
//           if (decodedData is Map && decodedData.containsKey('courses')) {
//             teacherCourses = decodedData['courses'];
//           } else if (decodedData is List) {
//             teacherCourses = decodedData;
//           }
//         });
        
//         debugPrint("✅ تم جلب ${teacherCourses.length} مواد بنجاح");
//       }
//     } catch (e) {
//       debugPrint("❌ خطأ في معالجة البيانات: $e");
//     }
//   }

//   // 2. جلب الاختبارات (Exams) عند اختيار مادة معينة
//   Future<void> _fetchExamsForCourse(int courseId) async {
//     try {
//       final response = await http.get(Uri.parse('http://127.0.0.1:8000/exams/by-course/$courseId'));
//       if (response.statusCode == 200) {
//         var decodedExams = json.decode(response.body);
//         if (!mounted) return;
//         setState(() {
//           if (decodedExams is List) {
//             courseExams = decodedExams;
//           } else if (decodedExams is Map) {
//             courseExams = [decodedExams];
//           }
//           selectedExamId = null; // إعادة تعيين الاختبار المختار
//           _clearExamFields(); // مسح الحقول التلقائية
//         });
//         debugPrint("✅ Exams loaded for course $courseId: ${courseExams.length}");
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching exams: $e");
//     }
//   }

//   void _clearExamFields() {
//     dateController.clear();
//     questionsCountController.clear();
//     totalGradeController.clear();
//   }

//   Future<void> pickFiles() async {
//     if (isGrading) return;
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       allowMultiple: true,
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       setState(() {
//         selectedFiles.addAll(result.files);
//       });
//     }
//   }

//   // 3. عملية التصحيح والرفع الفعلي باستخدام 127.0.0.1 لضمان الاتصال في المتصفح
//   Future<void> _processGrading() async {
//     if (selectedFiles.isEmpty || selectedExamId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(S.of(context).ready_to_start_grading), backgroundColor: Colors.orange),
//       );
//       return;
//     }

//     setState(() {
//       isGrading = true;
//       isGradingComplete = false;
//     });

//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('http://127.0.0.1:8000/grading/upload-sheets/$selectedExamId'),
//       );

//       for (var file in selectedFiles) {
//         if (file.bytes != null) {
//           request.files.add(http.MultipartFile.fromBytes('files', file.bytes!, filename: file.name));
//         } else if (file.path != null) {
//           request.files.add(await http.MultipartFile.fromPath('files', file.path!));
//         }
//       }

//       var streamedResponse = await request.send();
//       if (!mounted) return;

//       if (streamedResponse.statusCode == 200) {
//         await Future.delayed(const Duration(seconds: 2)); 
//         setState(() {
//           isGrading = false;
//           isGradingComplete = true;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("✅ تم رفع الأوراق وبدأ التصحيح بنجاح"), backgroundColor: Colors.green),
//         );
//       } else {
//         throw Exception("فشل رفع الملفات");
//       }
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => isGrading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ حدث خطأ: $e"), backgroundColor: Colors.red),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     dateController.dispose();
//     questionsCountController.dispose();
//     totalGradeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool hasFiles = selectedFiles.isNotEmpty;

//     return LayoutBuilder(builder: (context, constraints) {
//       bool isMobile = constraints.maxWidth < 850;
//       bool isTablet = constraints.maxWidth >= 850 && constraints.maxWidth < 1150;

//       return Scaffold(
//         key: _scaffoldKey,
//         backgroundColor: AppColors.secondaryTeal(context),
//         drawer: isMobile
//             ? Drawer(
//                 width: 260,
//                 backgroundColor: AppColors.primaryTeal(context),
//                 child: SafeArea(
//                   child: CustSidebar(
//                     selectedIndex: 3,
//                     isCompact: false,
//                     onItemSelected: _handleNavigation,
//                   ),
//                 ),
//               )
//             : null,
//         body: Row(
//           children: [
//             if (!isMobile)
//               CustSidebar(
//                 selectedIndex: 3,
//                 isCompact: isTablet,
//                 onItemSelected: _handleNavigation,
//               ),
//             Expanded(
//               child: Column(
//                 children: [
//                   if (isMobile) _buildMobileAppBar(),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: isMobile ? 12 : 24,
//                         vertical: 20,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const HeaderWidget(),
//                           const SizedBox(height: 15),
//                           _buildExamInfoSection(isMobile),
//                           const SizedBox(height: 15),
//                           _buildResponsiveUploadRow(isMobile, hasFiles),
//                           const SizedBox(height: 25),
//                           if (isGradingComplete)
//                             _buildCompleteCard()
//                           else if (isGrading)
//                             _buildProcessingCard()
//                           else if (hasFiles)
//                             _buildFileListSection(),
//                           const SizedBox(height: 40),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }

//   Widget _buildExamInfoSection(bool isMobile) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       width: double.infinity,
//       decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(S.of(context).exam_information, style: const TextStyle(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 12),
//           Wrap(
//             spacing: 10,
//             runSpacing: 10,
//             children: [
//               _buildDropdownField(
//                 label: S.of(context).course_subject,
//                 value: selectedCourseId,
//                 items: teacherCourses.map((c) => DropdownMenuItem<int>(
//                   value: c['course_id'],
//                   child: Text(c['course_name'] ?? ""),
//                 )).toList(),
//                 onChanged: (val) {
//                   setState(() => selectedCourseId = val);
//                   _fetchExamsForCourse(val!);
//                 },
//                 isMobile: isMobile,
//               ),
//               _buildDropdownField(
//                 label: S.of(context).exam_name,
//                 value: selectedExamId,
//                 items: courseExams.map((e) => DropdownMenuItem<int>(
//                   value: e['exam_id'],
//                   child: Text(e['exam_title'] ?? ""),
//                 )).toList(),
//                 onChanged: (val) {
//                   setState(() {
//                     selectedExamId = val;
//                     var exam = courseExams.firstWhere((e) => e['exam_id'] == val);
//                     dateController.text = exam['exam_date'] ?? "";
//                     questionsCountController.text = exam['number_of_questions'].toString();
//                     totalGradeController.text = exam['total_marks'].toString();
//                   });
//                 },
//                 isMobile: isMobile,
//               ),
//               _infoTextField(S.of(context).exam_date, dateController, isMobile, readOnly: true),
//               _infoTextField(S.of(context).number_of_questions, questionsCountController, isMobile, readOnly: true),
//               _infoTextField(S.of(context).total_grade, totalGradeController, isMobile, readOnly: true),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDropdownField({
//     required String label,
//     required dynamic value,
//     required List<DropdownMenuItem<int>> items,
//     required Function(int?) onChanged,
//     required bool isMobile,
//   }) {
//     double fieldWidth = isMobile ? (MediaQuery.of(context).size.width - 60) : 180;
//     return SizedBox(
//       width: fieldWidth,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
//           const SizedBox(height: 4),
//           DropdownButtonFormField<int>(
//             value: value,
//             items: items,
//             onChanged: isGrading ? null : onChanged,
//             decoration: InputDecoration(
//               isDense: true,
//               filled: true,
//               fillColor: AppColors.secondaryTeal(context).withValues(alpha: 0.3),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
//             ),
//             style: const TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _infoTextField(String label, TextEditingController controller, bool isMobile, {bool readOnly = false}) {
//     double fieldWidth = isMobile ? (MediaQuery.of(context).size.width - 60) : 180;
//     return SizedBox(
//       width: fieldWidth,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
//           const SizedBox(height: 4),
//           TextField(
//             controller: controller,
//             readOnly: readOnly,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
//             decoration: InputDecoration(
//               isDense: true,
//               filled: true,
//               fillColor: AppColors.secondaryTeal(context).withValues(alpha: 0.1),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMobileAppBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
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
//             Text(S.of(context).auto_grading, style: const TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildResponsiveUploadRow(bool isMobile, bool hasFiles) {
//     if (isMobile) {
//       return Column(
//         children: [
//           _buildUploadCard(isFullWidth: true),
//           const SizedBox(height: 16),
//           _buildStatusCard(hasFiles, isFullWidth: true),
//         ],
//       );
//     }
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildUploadCard(isFullWidth: false),
//         const SizedBox(width: 20),
//         _buildStatusCard(hasFiles, isFullWidth: false),
//       ],
//     );
//   }

//   Widget _buildUploadCard({required bool isFullWidth}) {
//     Widget card = Container(
//       height: 200,
//       decoration: BoxDecoration(
//         color: AppColors.textWhite(context),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.black12),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.cloud_upload_outlined,
//               size: 50, color: isGrading ? Colors.grey : AppColors.primaryTeal(context)),
//           const SizedBox(height: 10),
//           Text(S.of(context).click_to_select_files),
//           const SizedBox(height: 15),
//           ElevatedButton.icon(
//             onPressed: isGrading ? null : pickFiles,
//             icon: const Icon(Icons.file_upload, color: Colors.white),
//             label: Text(S.of(context).choose_files, style: const TextStyle(color: Colors.white)),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: isGrading ? Colors.grey[400] : AppColors.primaryTeal(context),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//     return isFullWidth ? card : Expanded(flex: 2, child: card);
//   }

//   Widget _buildStatusCard(bool hasFiles, {required bool isFullWidth}) {
//     Widget card = Container(
//       height: 200,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.textWhite(context),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             hasFiles ? Icons.check_circle_outline_rounded : Icons.priority_high_rounded,
//             size: 40,
//             color: isGrading ? Colors.grey : (hasFiles ? AppColors.primaryTeal(context) : Colors.orange),
//           ),
//           const SizedBox(height: 10),
//           Text(isGrading
//               ? S.of(context).processing_data
//               : (hasFiles ? S.of(context).ready_to_start_grading : S.of(context).no_papers_attached)),
//           Text("${selectedFiles.length} ${S.of(context).valid_answer_sheets}"),
//           const Spacer(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: (hasFiles && !isGrading) ? _processGrading : null,
//                 icon: const Icon(Icons.update_rounded, size: 18),
//                 label: Text(S.of(context).start_auto_grading, style: const TextStyle(fontSize: 13)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: (hasFiles && !isGrading) ? AppColors.primaryTeal(context) : Colors.grey[400],
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               OutlinedButton(
//                 onPressed: () => setState(() { if (isGrading) isGrading = false; else selectedFiles = []; }),
//                 style: OutlinedButton.styleFrom(side: BorderSide(color: isGrading ? Colors.grey : Colors.redAccent)),
//                 child: Text(S.of(context).cancel, style: TextStyle(color: isGrading ? Colors.grey : Colors.redAccent)),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//     return isFullWidth ? card : Expanded(flex: 3, child: card);
//   }

//   Widget _buildProcessingCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
//               const SizedBox(width: 8),
//               Text(S.of(context).auto_grading_in_progress, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
//             ],
//           ),
//           const SizedBox(height: 15),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(S.of(context).overall_progress, style: const TextStyle(fontSize: 12, color: Colors.black)),
//               Text("${(selectedFiles.length * 0.24).toInt()} / ${selectedFiles.length}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.orange)),
//             ],
//           ),
//           const SizedBox(height: 10),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: const LinearProgressIndicator(value: 0.24, minHeight: 10, backgroundColor: Color(0xFFE5E5E5), valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent)),
//           ),
//           const SizedBox(height: 15),
//           Row(
//             children: [
//               _statBox("29", S.of(context).completed, Icons.check_circle),
//               const SizedBox(width: 10),
//               _statBox("3", S.of(context).in_progress, Icons.sync),
//               const SizedBox(width: 10),
//               _statBox("88", S.of(context).waiting, Icons.access_time),
//               const SizedBox(width: 10),
//               _statBox("2", S.of(context).remaining, Icons.trending_up),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildCompleteCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.check_circle_outline, color: Colors.green, size: 28), const SizedBox(width: 8), Text(S.of(context).auto_grading_completed, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)))]),
//           const SizedBox(height: 15),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ReviewExamPage(examId: selectedExamId!),
//                 ),
//               );
//             }, 
//             style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal(context), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)), 
//             child: const Text("عرض الأوراق المصححة", style: TextStyle(color: Colors.white))
//           ),
//           const SizedBox(height: 20),
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(S.of(context).overall_progress), Text("${selectedFiles.length} / ${selectedFiles.length}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))]),
//           const SizedBox(height: 10),
//           ClipRRect(borderRadius: BorderRadius.circular(20), child: const LinearProgressIndicator(value: 1, minHeight: 10, backgroundColor: Color(0xFFE5E5E5), valueColor: AlwaysStoppedAnimation<Color>(Colors.green))),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               _statBox("${selectedFiles.length}", S.of(context).completed, Icons.check_circle),
//               const SizedBox(width: 10),
//               _statBox("0", S.of(context).in_progress, Icons.sync),
//               const SizedBox(width: 10),
//               _statBox("0", S.of(context).waiting, Icons.access_time),
//               const SizedBox(width: 10),
//               _statBox("0", S.of(context).remaining, Icons.trending_up),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _statBox(String number, String label, IconData icon) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//         decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           children: [
//             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(icon, size: 20, color: AppColors.primaryTeal(context)), Text(number, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)))]),
//             const SizedBox(height: 8),
//             Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFileListSection() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(15)),
//       child: Column(
//         children: [
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(S.of(context).uploaded_files, style: const TextStyle(fontWeight: FontWeight.bold)), TextButton(onPressed: () => setState(() => selectedFiles = []), child: Text(S.of(context).delete_all, style: const TextStyle(color: Colors.redAccent)))]),
//           const Divider(height: 30),
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: selectedFiles.length,
//             separatorBuilder: (context, index) => const Divider(height: 20),
//             itemBuilder: (context, index) => Row(children: [const Icon(Icons.check_circle, color: Colors.green, size: 20), const SizedBox(width: 10), Expanded(child: Text(selectedFiles[index].name, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)), IconButton(icon: const Icon(Icons.close, color: Colors.redAccent, size: 18), onPressed: () => setState(() => selectedFiles.removeAt(index)))]),
//           ),
//         ],
//       ),
//     );
//   }

//   void _handleNavigation(int index) {
//     if (index == 3) return;
//     if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);

//     Widget? page;
//     if (index == 0) page = const DashboardScreen();
//     if (index == 1) page = const ExamManagementPage();
//     if (index == 2) page = const Material1();
//     if (index == 4) page = ReviewExamPage(examId: selectedExamId ?? 0); // تمرير ديناميكي آمن لمنع الأخطاء هنا
//     if (index == 5) page = const SettingsScreen(); 

//     if (page != null) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => page!),
//         (route) => false,
//       );
//     }
//   }
// }

// class HeaderWidget extends StatelessWidget {
//   const HeaderWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(
//         color: AppColors.textWhite(context), 
//         borderRadius: BorderRadius.circular(15)
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start, 
//             children: [
//               Text(
//                 S.of(context).upload_answer_sheets, 
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))
//               ), 
//               const SizedBox(height: 4), 
//               Text(
//                 S.of(context).upload_answer_sheets_desc, 
//                 style: const TextStyle(fontSize: 12, color: Colors.grey)
//               )
//             ]
//           ),
//           Row(
//             children: [
//               _iconButton(context, Icons.notifications_none, () {}),
//               const SizedBox(width: 10),
//               _iconButton(context, Icons.person_outline, () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const ProfileSettingsPage()),
//                 );
//               }),
//             ]
//           )
//         ],
//       ),
//     );
//   }

//   Widget _iconButton(BuildContext context, IconData icon, VoidCallback onTap) {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: AppColors.secondaryTeal(context), 
//             shape: BoxShape.circle
//           ),
//           child: Icon(icon, color: AppColors.primaryTeal(context)),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/colors.dart';
import 'teacher_dashboard.dart' hide HeaderWidget;
import 'teacher_matearial.dart' hide HeaderWidget;
import '../generated/l10n.dart'; 
import 'review_exam_screen.dart';
import 'teacer_setting.dart';
import 'ExamManagementPage.dart';

class GradingPage extends StatefulWidget {
  const GradingPage({super.key});

  @override
  State<GradingPage> createState() => _GradingPageState();
}

class _GradingPageState extends State<GradingPage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController questionsCountController = TextEditingController();
  final TextEditingController totalGradeController = TextEditingController();

  int? selectedCourseId;
  int? selectedExamId;
  List<dynamic> teacherCourses = []; 
  List<dynamic> courseExams = [];    

  List<PlatformFile> selectedFiles = [];
  bool isGrading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final response = await http.get(
        Uri.parse('http://localhost:8000/teacher-materials/1'),
        headers: {'Authorization': 'Bearer $token'}
      );
      if (response.statusCode == 200) {
        var decodedData = json.decode(response.body);
        if (!mounted) return;
        setState(() {
          if (decodedData is Map && decodedData.containsKey('courses')) {
            teacherCourses = decodedData['courses'];
          } else if (decodedData is List) {
            teacherCourses = decodedData;
          }
        });
      }
    } catch (e) {
      debugPrint("❌ Error fetching courses: $e");
    }
  }

  Future<void> _fetchExamsForCourse(int courseId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final response = await http.get(
        Uri.parse('http://localhost:8000/exams/by-course/$courseId'),
        headers: {'Authorization': 'Bearer $token'}
      );
      if (response.statusCode == 200) {
        var decodedExams = json.decode(response.body);
        if (!mounted) return;
        setState(() {
          if (decodedExams is List) {
            courseExams = decodedExams;
          } else if (decodedExams is Map) {
            courseExams = [decodedExams];
          }
          selectedExamId = null; 
          _clearExamFields(); 
        });
      }
    } catch (e) {
      debugPrint("❌ Error fetching exams: $e");
    }
  }

  void _clearExamFields() {
    dateController.clear();
    questionsCountController.clear();
    totalGradeController.clear();
  }

  Future<void> pickFiles() async {
    if (isGrading) return;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFiles.addAll(result.files);
      });
    }
  }

  Future<void> _processGrading() async {
    if (selectedFiles.isEmpty || selectedExamId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).ready_to_start_grading), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() {
      isGrading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:8000/grading/upload-sheets/$selectedExamId'),
      );
      request.headers['Authorization'] = 'Bearer $token';

      for (var file in selectedFiles) {
        if (file.bytes != null) {
          request.files.add(http.MultipartFile.fromBytes('files', file.bytes!, filename: file.name));
        } else if (file.path != null) {
          request.files.add(await http.MultipartFile.fromPath('files', file.path!));
        }
      }

      var streamedResponse = await request.send();
      if (!mounted) return;

      if (streamedResponse.statusCode == 200) {
        setState(() {
          isGrading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("🚀 تم رفع الملفات بنجاح، جاري نقلك لكشف متابعة الطلاب"), backgroundColor: Colors.green),
        );

        // تعديل مؤقت لحين بناء شاشة المراجعة بالهيكل الجديد لكي يقبل المشروع التنزيل والترجمة
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ReviewExamPage(),
          ),
        );
      } else {
        throw Exception("فشل رفع الملفات");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isGrading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ حدث خطأ: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasFiles = selectedFiles.isNotEmpty;

    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 850;
      bool isTablet = constraints.maxWidth >= 850 && constraints.maxWidth < 1150;

      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.secondaryTeal(context),
        drawer: isMobile
            ? Drawer(
                width: 260,
                backgroundColor: AppColors.primaryTeal(context),
                child: SafeArea(
                  child: CustSidebar(
                    selectedIndex: 3,
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
                selectedIndex: 3,
                isCompact: isTablet,
                onItemSelected: _handleNavigation,
              ),
            Expanded(
              child: Column(
                children: [
                  if (isMobile) _buildMobileAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 12 : 24,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeaderWidget(),
                          const SizedBox(height: 15),
                          _buildExamInfoSection(isMobile),
                          const SizedBox(height: 15),
                          _buildResponsiveUploadRow(isMobile, hasFiles),
                          const SizedBox(height: 25),
                          if (isGrading)
                            _buildProcessingCard()
                          else if (hasFiles)
                            _buildFileListSection(),
                          const SizedBox(height: 40),
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

  Widget _buildExamInfoSection(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).exam_information, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildDropdownField(
                label: S.of(context).course_subject,
                value: selectedCourseId,
                items: teacherCourses.map((c) => DropdownMenuItem<int>(
                  value: c['course_id'],
                  child: Text(c['course_name'] ?? ""),
                )).toList(),
                onChanged: (val) {
                  setState(() => selectedCourseId = val);
                  _fetchExamsForCourse(val!);
                },
                isMobile: isMobile,
              ),
              _buildDropdownField(
                label: S.of(context).exam_name,
                value: selectedExamId,
                items: courseExams.map((e) => DropdownMenuItem<int>(
                  value: e['exam_id'],
                  child: Text(e['exam_title'] ?? ""),
                )).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedExamId = val;
                    var exam = courseExams.firstWhere((e) => e['exam_id'] == val);
                    dateController.text = exam['exam_date'] ?? "";
                    questionsCountController.text = exam['number_of_questions'].toString();
                    totalGradeController.text = exam['total_marks'].toString();
                  });
                },
                isMobile: isMobile,
              ),
              _infoTextField(S.of(context).exam_date, dateController, isMobile, readOnly: true),
              _infoTextField(S.of(context).number_of_questions, questionsCountController, isMobile, readOnly: true),
              _infoTextField(S.of(context).total_grade, totalGradeController, isMobile, readOnly: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required dynamic value,
    required List<DropdownMenuItem<int>> items,
    required Function(int?) onChanged,
    required bool isMobile,
  }) {
    double fieldWidth = isMobile ? (MediaQuery.of(context).size.width - 60) : 180;
    return SizedBox(
      width: fieldWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 4),
          DropdownButtonFormField<int>(
            value: value,
            items: items,
            onChanged: isGrading ? null : onChanged,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: AppColors.secondaryTeal(context).withValues(alpha: 0.3),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
            ),
            style: const TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _infoTextField(String label, TextEditingController controller, bool isMobile, {bool readOnly = false}) {
    double fieldWidth = isMobile ? (MediaQuery.of(context).size.width - 60) : 180;
    return SizedBox(
      width: fieldWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            readOnly: readOnly,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: AppColors.secondaryTeal(context).withValues(alpha: 0.1),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            const Spacer(),
            Text(S.of(context).auto_grading, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveUploadRow(bool isMobile, bool hasFiles) {
    if (isMobile) {
      return Column(
        children: [
          _buildUploadCard(isFullWidth: true),
          const SizedBox(height: 16),
          _buildStatusCard(hasFiles, isFullWidth: true),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUploadCard(isFullWidth: false),
        const SizedBox(width: 20),
        _buildStatusCard(hasFiles, isFullWidth: false),
      ],
    );
  }

  Widget _buildUploadCard({required bool isFullWidth}) {
    Widget card = Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload_outlined,
              size: 50, color: isGrading ? Colors.grey : AppColors.primaryTeal(context)),
          const SizedBox(height: 10),
          Text(S.of(context).click_to_select_files),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: isGrading ? null : pickFiles,
            icon: const Icon(Icons.file_upload, color: Colors.white),
            label: Text(S.of(context).choose_files, style: const TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: isGrading ? Colors.grey[400] : AppColors.primaryTeal(context),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
    return isFullWidth ? card : Expanded(flex: 2, child: card);
  }

  Widget _buildStatusCard(bool hasFiles, {required bool isFullWidth}) {
    Widget card = Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFiles ? Icons.check_circle_outline_rounded : Icons.priority_high_rounded,
            size: 40,
            color: isGrading ? Colors.grey : (hasFiles ? AppColors.primaryTeal(context) : Colors.orange),
          ),
          const SizedBox(height: 10),
          Text(isGrading
              ? S.of(context).processing_data
              : (hasFiles ? S.of(context).ready_to_start_grading : S.of(context).no_papers_attached)),
          Text("${selectedFiles.length} ${S.of(context).valid_answer_sheets}"),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: (hasFiles && !isGrading) ? _processGrading : null,
                icon: const Icon(Icons.update_rounded, size: 18),
                label: Text(S.of(context).start_auto_grading, style: const TextStyle(fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: (hasFiles && !isGrading) ? AppColors.primaryTeal(context) : Colors.grey[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () => setState(() { if (isGrading) isGrading = false; else selectedFiles = []; }),
                style: OutlinedButton.styleFrom(side: BorderSide(color: isGrading ? Colors.grey : Colors.redAccent)),
                child: Text(S.of(context).cancel, style: TextStyle(color: isGrading ? Colors.grey : Colors.redAccent)),
              ),
            ],
          ),
        ],
      ),
    );
    return isFullWidth ? card : Expanded(flex: 3, child: card);
  }

  Widget _buildProcessingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(S.of(context).processing_data, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("جاري رفع الأوراق وتهيئة محركات المعالجة... يرجى الانتظار", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFileListSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(S.of(context).uploaded_files, style: const TextStyle(fontWeight: FontWeight.bold)), TextButton(onPressed: () => setState(() => selectedFiles = []), child: Text(S.of(context).delete_all, style: const TextStyle(color: Colors.redAccent)))]),
          const Divider(height: 30),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedFiles.length,
            separatorBuilder: (context, index) => const Divider(height: 20),
            itemBuilder: (context, index) => Row(children: [const Icon(Icons.check_circle, color: Colors.green, size: 20), const SizedBox(width: 10), Expanded(child: Text(selectedFiles[index].name, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)), IconButton(icon: const Icon(Icons.close, color: Colors.redAccent, size: 18), onPressed: () => setState(() => selectedFiles.removeAt(index)))]),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(int index) {
    if (index == 3) return;
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);

    Widget? page;
    if (index == 0) page = const DashboardScreen();
    if (index == 1) page = const ExamManagementPage();
    if (index == 2) page = const Material1();
    if (index == 4) page = const ReviewExamPage(); // تم ضبطها مؤقتاً لتطابق الـ Constructor الحالي عندك
    if (index == 5) page = const SettingsScreen(); 

    if (page != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => page!),
        (route) => false,
      );
    }
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context), 
        borderRadius: BorderRadius.circular(15)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Text(
                S.of(context).upload_answer_sheets, 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))
              ), 
              const SizedBox(height: 4), 
              Text(
                S.of(context).upload_answer_sheets_desc, 
                style: const TextStyle(fontSize: 12, color: Colors.grey)
              )
            ]
          ),
          Row(
            children: [
              _iconButton(context, Icons.person_outline, () {}),
            ]
          )
        ],
      ),
    );
  }

  Widget _iconButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.secondaryTeal(context).withValues(alpha: 0.3), 
            shape: BoxShape.circle
          ),
          child: Icon(icon, color: AppColors.primaryTeal(context)),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../core/colors.dart';
// import 'teacher_dashboard.dart' hide HeaderWidget;
// import 'teacher_matearial.dart' hide HeaderWidget;
// import '../generated/l10n.dart'; 
// import 'review_exam_screen.dart';
// import 'teacer_setting.dart';
// import 'ExamManagementPage.dart';

// class GradingPage extends StatefulWidget {
//   const GradingPage({super.key});

//   @override
//   State<GradingPage> createState() => _GradingPageState();
// }

// class _GradingPageState extends State<GradingPage> {
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController questionsCountController = TextEditingController();
//   final TextEditingController totalGradeController = TextEditingController();
  
//   int? selectedCourseId;
//   int? selectedExamId;
//   List<dynamic> teacherCourses = []; 
//   List<dynamic> courseExams = [];    

//   List<PlatformFile> selectedFiles = [];
//   bool isGrading = false;
//   int completedCount = 0;
//   int totalCount = 0;
  
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _fetchInitialData();
//   }

//   Future<void> _fetchInitialData() async {
//     try {
//       final response = await http.get(Uri.parse('http://localhost:8000/teacher-materials/1'));
//       if (response.statusCode == 200) {
//         var decodedData = json.decode(response.body);
//         if (!mounted) return;
//         setState(() {
//           if (decodedData is Map && decodedData.containsKey('courses')) {
//             teacherCourses = decodedData['courses'];
//           } else if (decodedData is List) {
//             teacherCourses = decodedData;
//           }
//         });
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching courses: $e");
//     }
//   }

//   Future<void> _fetchExamsForCourse(int courseId) async {
//     try {
//       final response = await http.get(Uri.parse('http://localhost:8000/exams/by-course/$courseId'));
//       if (response.statusCode == 200) {
//         var decodedExams = json.decode(response.body);
//         if (!mounted) return;
//         setState(() {
//           if (decodedExams is List) {
//             courseExams = decodedExams;
//           } else if (decodedExams is Map) {
//             courseExams = [decodedExams];
//           }
//           selectedExamId = null; 
//           _clearExamFields(); 
//         });
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching exams: $e");
//     }
//   }

//   void _clearExamFields() {
//     dateController.clear();
//     questionsCountController.clear();
//     totalGradeController.clear();
//   }

//   Future<void> pickFiles() async {
//     if (isGrading) return;
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       allowMultiple: true,
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       setState(() {
//         selectedFiles.addAll(result.files);
//       });
//     }
//   }

//   Future<void> _processGrading() async {
//     if (selectedFiles.isEmpty || selectedExamId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(S.of(context).ready_to_start_grading), backgroundColor: Colors.orange),
//       );
//       return;
//     }

//     setState(() {
//       isGrading = true;
//       totalCount = selectedFiles.length;
//       completedCount = 0;
//     });

//     try {
//       for (var file in selectedFiles) {
//         var request = http.MultipartRequest(
//           'POST',
//           Uri.parse('http://localhost:8000/grading/upload-sheets/$selectedExamId'),
//         );

//         if (file.bytes != null) {
//           request.files.add(http.MultipartFile.fromBytes('files', file.bytes!, filename: file.name));
//         } else if (file.path != null) {
//           request.files.add(await http.MultipartFile.fromPath('files', file.path!));
//         }

//         var streamedResponse = await request.send();
        
//         if (streamedResponse.statusCode == 200) {
//           if (mounted) {
//             setState(() {
//               completedCount++;
//             });
//           }
//         } else {
//           throw Exception("فشل رفع الملف: ${file.name}");
//         }
//       }

//       // بعد انتهاء جميع الملفات بنجاح، يتم الانتقال
//       if (!mounted) return;
      
//       setState(() => isGrading = false);
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("🚀 تم تصحيح جميع الملفات بنجاح!"), backgroundColor: Colors.green),
//       );

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const ReviewExamPage()),
//       );
      
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => isGrading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ حدث خطأ: $e"), backgroundColor: Colors.red),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool hasFiles = selectedFiles.isNotEmpty;

//     return LayoutBuilder(builder: (context, constraints) {
//       bool isMobile = constraints.maxWidth < 850;
//       bool isTablet = constraints.maxWidth >= 850 && constraints.maxWidth < 1150;

//       return Scaffold(
//         key: _scaffoldKey,
//         backgroundColor: AppColors.secondaryTeal(context),
//         drawer: isMobile
//             ? Drawer(
//                 width: 260,
//                 backgroundColor: AppColors.primaryTeal(context),
//                 child: SafeArea(
//                   child: CustSidebar(
//                     selectedIndex: 3,
//                     isCompact: false,
//                     onItemSelected: _handleNavigation,
//                   ),
//                 ),
//               )
//             : null,
//         body: Row(
//           children: [
//             if (!isMobile)
//               CustSidebar(
//                 selectedIndex: 3,
//                 isCompact: isTablet,
//                 onItemSelected: _handleNavigation,
//               ),
//             Expanded(
//               child: Column(
//                 children: [
//                   if (isMobile) _buildMobileAppBar(),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: isMobile ? 12 : 24,
//                         vertical: 20,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const HeaderWidget(),
//                           const SizedBox(height: 15),
//                           _buildExamInfoSection(isMobile),
//                           const SizedBox(height: 15),
//                           _buildResponsiveUploadRow(isMobile, hasFiles),
//                           const SizedBox(height: 25),
//                           if (isGrading)
//                             _buildProcessingCard()
//                           else if (hasFiles)
//                             _buildFileListSection(),
//                           const SizedBox(height: 40),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }

//   Widget _buildExamInfoSection(bool isMobile) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       width: double.infinity,
//       decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(S.of(context).exam_information, style: const TextStyle(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 12),
//           Wrap(
//             spacing: 10,
//             runSpacing: 10,
//             children: [
//               _buildDropdownField(
//                 label: S.of(context).course_subject,
//                 value: selectedCourseId,
//                 items: teacherCourses.map((c) => DropdownMenuItem<int>(
//                   value: c['course_id'],
//                   child: Text(c['course_name'] ?? ""),
//                 )).toList(),
//                 onChanged: (val) {
//                   setState(() => selectedCourseId = val);
//                   _fetchExamsForCourse(val!);
//                 },
//                 isMobile: isMobile,
//               ),
//               _buildDropdownField(
//                 label: S.of(context).exam_name,
//                 value: selectedExamId,
//                 items: courseExams.map((e) => DropdownMenuItem<int>(
//                   value: e['exam_id'],
//                   child: Text(e['exam_title'] ?? ""),
//                 )).toList(),
//                 onChanged: (val) {
//                   setState(() {
//                     selectedExamId = val;
//                     var exam = courseExams.firstWhere((e) => e['exam_id'] == val);
//                     dateController.text = exam['exam_date'] ?? "";
//                     questionsCountController.text = exam['number_of_questions'].toString();
//                     totalGradeController.text = exam['total_marks'].toString();
//                   });
//                 },
//                 isMobile: isMobile,
//               ),
//               _infoTextField(S.of(context).exam_date, dateController, isMobile, readOnly: true),
//               _infoTextField(S.of(context).number_of_questions, questionsCountController, isMobile, readOnly: true),
//               _infoTextField(S.of(context).total_grade, totalGradeController, isMobile, readOnly: true),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDropdownField({required String label, required dynamic value, required List<DropdownMenuItem<int>> items, required Function(int?) onChanged, required bool isMobile}) {
//     double fieldWidth = isMobile ? (MediaQuery.of(context).size.width - 60) : 180;
//     return SizedBox(
//       width: fieldWidth,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
//           const SizedBox(height: 4),
//           DropdownButtonFormField<int>(
//             value: value,
//             items: items,
//             onChanged: isGrading ? null : onChanged,
//             decoration: InputDecoration(
//               isDense: true,
//               filled: true,
//               fillColor: AppColors.secondaryTeal(context).withValues(alpha: 0.3),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
//             ),
//             style: const TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _infoTextField(String label, TextEditingController controller, bool isMobile, {bool readOnly = false}) {
//     double fieldWidth = isMobile ? (MediaQuery.of(context).size.width - 60) : 180;
//     return SizedBox(
//       width: fieldWidth,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
//           const SizedBox(height: 4),
//           TextField(
//             controller: controller,
//             readOnly: readOnly,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
//             decoration: InputDecoration(
//               isDense: true,
//               filled: true,
//               fillColor: AppColors.secondaryTeal(context).withValues(alpha: 0.1),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMobileAppBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//       ),
//       child: SafeArea(
//         child: Row(
//           children: [
//             IconButton(
//               icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)),
//               onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//             ),
//             const Spacer(),
//             Text(S.of(context).auto_grading, style: const TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildResponsiveUploadRow(bool isMobile, bool hasFiles) {
//     if (isMobile) {
//       return Column(children: [_buildUploadCard(isFullWidth: true), const SizedBox(height: 16), _buildStatusCard(hasFiles, isFullWidth: true)]);
//     }
//     return Row(children: [_buildUploadCard(isFullWidth: false), const SizedBox(width: 20), _buildStatusCard(hasFiles, isFullWidth: false)]);
//   }

//   Widget _buildUploadCard({required bool isFullWidth}) {
//     Widget card = Container(
//       height: 200,
//       decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black12)),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.cloud_upload_outlined, size: 50, color: isGrading ? Colors.grey : AppColors.primaryTeal(context)),
//           const SizedBox(height: 10),
//           Text(S.of(context).click_to_select_files),
//           const SizedBox(height: 15),
//           ElevatedButton.icon(
//             onPressed: isGrading ? null : pickFiles,
//             icon: const Icon(Icons.file_upload, color: Colors.white),
//             label: Text(S.of(context).choose_files, style: const TextStyle(color: Colors.white)),
//             style: ElevatedButton.styleFrom(backgroundColor: isGrading ? Colors.grey[400] : AppColors.primaryTeal(context), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
//           ),
//         ],
//       ),
//     );
//     return isFullWidth ? card : Expanded(flex: 2, child: card);
//   }

//   Widget _buildStatusCard(bool hasFiles, {required bool isFullWidth}) {
//     Widget card = Container(
//       height: 200,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(16)),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(hasFiles ? Icons.check_circle_outline_rounded : Icons.priority_high_rounded, size: 40, color: isGrading ? Colors.grey : (hasFiles ? AppColors.primaryTeal(context) : Colors.orange)),
//           const SizedBox(height: 10),
//           Text(isGrading ? S.of(context).processing_data : (hasFiles ? S.of(context).ready_to_start_grading : S.of(context).no_papers_attached)),
//           Text("${selectedFiles.length} ${S.of(context).valid_answer_sheets}"),
//           const Spacer(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: (hasFiles && !isGrading) ? _processGrading : null,
//                 icon: const Icon(Icons.update_rounded, size: 18),
//                 label: Text(S.of(context).start_auto_grading, style: const TextStyle(fontSize: 13)),
//                 style: ElevatedButton.styleFrom(backgroundColor: (hasFiles && !isGrading) ? AppColors.primaryTeal(context) : Colors.grey[400], foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
//               ),
//               const SizedBox(width: 12),
//               OutlinedButton(
//                 onPressed: () => setState(() { if (isGrading) isGrading = false; else selectedFiles = []; }),
//                 style: OutlinedButton.styleFrom(side: BorderSide(color: isGrading ? Colors.grey : Colors.redAccent)),
//                 child: Text(S.of(context).cancel, style: TextStyle(color: isGrading ? Colors.grey : Colors.redAccent)),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//     return isFullWidth ? card : Expanded(flex: 3, child: card);
//   }

//   Widget _buildProcessingCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const CircularProgressIndicator(color: Colors.orange),
//           const SizedBox(height: 16),
//           Text(S.of(context).processing_data, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           Text("جاري تصحيح الورقة $completedCount من $totalCount ... يرجى الانتظار", style: const TextStyle(color: Colors.grey, fontSize: 12)),
//           const SizedBox(height: 20),
//           LinearProgressIndicator(
//             value: totalCount > 0 ? (completedCount / totalCount) : 0,
//             minHeight: 10,
//             backgroundColor: Colors.grey[200],
//             valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               _statBox("$completedCount", "مكتمل", Icons.check_circle),
//               const SizedBox(width: 10),
//               _statBox("${totalCount - completedCount}", "متبقي", Icons.trending_up),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _statBox(String number, String label, IconData icon) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//         decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           children: [
//             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(icon, size: 20, color: AppColors.primaryTeal(context)), Text(number, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)))]),
//             const SizedBox(height: 8),
//             Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFileListSection() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(15)),
//       child: Column(
//         children: [
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(S.of(context).uploaded_files, style: const TextStyle(fontWeight: FontWeight.bold)), TextButton(onPressed: () => setState(() => selectedFiles = []), child: Text(S.of(context).delete_all, style: const TextStyle(color: Colors.redAccent)))]),
//           const Divider(height: 30),
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: selectedFiles.length,
//             separatorBuilder: (context, index) => const Divider(height: 20),
//             itemBuilder: (context, index) => Row(children: [const Icon(Icons.check_circle, color: Colors.green, size: 20), const SizedBox(width: 10), Expanded(child: Text(selectedFiles[index].name, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)), IconButton(icon: const Icon(Icons.close, color: Colors.redAccent, size: 18), onPressed: () => setState(() => selectedFiles.removeAt(index)))]),
//           ),
//         ],
//       ),
//     );
//   }

//   void _handleNavigation(int index) {
//     if (index == 3) return;
//     if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);
//     Widget? page;
//     if (index == 0) page = const DashboardScreen();
//     if (index == 1) page = const ExamManagementPage();
//     if (index == 2) page = const Material1();
//     if (index == 4) page = const ReviewExamPage();
//     if (index == 5) page = const SettingsScreen(); 
//     if (page != null) {
//       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => page!), (route) => false);
//     }
//   }
// }

// class HeaderWidget extends StatelessWidget {
//   const HeaderWidget({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(15)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(S.of(context).upload_answer_sheets, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))), const SizedBox(height: 4), Text(S.of(context).upload_answer_sheets_desc, style: const TextStyle(fontSize: 12, color: Colors.grey))]),
//           Row(children: [_iconButton(context, Icons.person_outline, () {})])
//         ],
//       ),
//     );
//   }
//   Widget _iconButton(BuildContext context, IconData icon, VoidCallback onTap) {
//     return MouseRegion(cursor: SystemMouseCursors.click, child: GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.secondaryTeal(context).withValues(alpha: 0.3), shape: BoxShape.circle), child: Icon(icon, color: AppColors.primaryTeal(context)))));
//   }
// }