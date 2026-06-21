// // import 'package:flutter/material.dart';
// // import '../core/colors.dart';
// // import '../generated/l10n.dart';
// // import 'create_electronic_exam.dart';
// // import 'teacher_dashboard.dart';
// // import 'create_ai_exam_screen.dart';
// // import 'teacher_matearial.dart' hide HeaderWidget;
// // import 'grading.dart' hide HeaderWidget;
// // import 'review_exam_screen.dart';
// // import 'teacer_setting.dart';
// // import 'teacher_profile_settings_page.dart';
// // import 'exam_page.dart';
// // import '../service/api_service.dart';

// // class ExamManagementPage extends StatefulWidget {
// //   const ExamManagementPage({super.key});

// //   @override
// //   State<ExamManagementPage> createState() => _ExamManagementPageState();
// // }

// // class _ExamManagementPageState extends State<ExamManagementPage>
// //     with SingleTickerProviderStateMixin {
// //   late TabController _tabController;
// //   final int _selectedIndex = 1;
// //   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
// //   String searchQuery = "";
// //   final ApiService _apiService = ApiService();

// //   // المتغيرات الحقيقية للإحصائيات العلوية
// //   int manualExamsCount = 0;
// //   int aiExamsCount = 0;
// //   int draftsCount = 0;

// //   // متغيرات لحفظ حالة الجداول وإجبارها على التحديث
// //   late Future<List<dynamic>> _manualExamsFuture;
// //   late Future<List<dynamic>> _aiExamsFuture;
// //   late Future<List<dynamic>> _draftsFuture;

// //   // دالة التحديث الشامل (تحدث الجداول + الأرقام معاً)
// //   void _refreshData() {
// //     setState(() {
// //       _manualExamsFuture = _apiService.fetchExams("Manual", 1);
// //       _aiExamsFuture = _apiService.fetchExams("AI", 1);
// //       _draftsFuture = _apiService.fetchExams("Draft", 1);
// //     });
// //     _loadStats();
// //   }

// //   Future<void> _loadStats() async {
// //     try {
// //       var manual = await _apiService.fetchExams("Manual", 1);
// //       var ai = await _apiService.fetchExams("AI", 1);
// //       var drafts = await _apiService.fetchExams("Draft", 1);

// //       if (mounted) {
// //         setState(() {
// //           manualExamsCount = manual.length;
// //           aiExamsCount = ai.length;
// //           draftsCount = drafts.length;
// //         });
// //       }
// //     } catch (e) {
// //       debugPrint("Error loading stats: $e");
// //     }
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: 3, vsync: this);
// //     _tabController.addListener(() => setState(() {}));
// //     _refreshData(); // تشغيل التحديث الشامل عند فتح الصفحة
// //   }

// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     super.dispose();
// //   }

// //   void _handleNavigation(int index) {
// //     if (index == _selectedIndex) return;
// //     if (_scaffoldKey.currentState?.isDrawerOpen ?? false)
// //       Navigator.pop(context);

// //     Widget? targetPage;
// //     switch (index) {
// //       case 0:
// //         targetPage = const DashboardScreen();
// //         break;
// //       case 1:
// //         targetPage = const ExamManagementPage();
// //         break;
// //       case 2:
// //         targetPage = const Material1();
// //         break;
// //       case 3:
// //         targetPage = const GradingPage();
// //         break;
// //       case 4:
// //         targetPage = const ReviewExamPage();
// //         break;
// //       case 5:
// //         targetPage = const SettingsScreen();
// //         break;
// //     }
// //     if (targetPage != null) {
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (context) => targetPage!),
// //       );
// //     }
// //   }

// //   // دالة الحذف القوية مع تأكيد وتحديث مباشر
// //   Future<void> _confirmAndDeleteExam(dynamic examId) async {
// //     bool? confirm = await showDialog(
// //       context: context,
// //       builder: (ctx) => AlertDialog(
// //         title: const Text(
// //           "تأكيد الحذف",
// //           style: TextStyle(fontWeight: FontWeight.bold),
// //         ),
// //         content: const Text("هل أنت متأكد من حذف هذا الاختبار نهائياً؟"),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(ctx, false),
// //             child: const Text("إلغاء"),
// //           ),
// //           ElevatedButton(
// //             onPressed: () => Navigator.pop(ctx, true),
// //             style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
// //             child: const Text("حذف", style: TextStyle(color: Colors.white)),
// //           ),
// //         ],
// //       ),
// //     );

// //     if (confirm == true) {
// //       try {
// //         await _apiService.deleteExam(examId); // الحذف الفعلي من الداتا بيس
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(
// //               content: Text("تم الحذف بنجاح!"),
// //               backgroundColor: Colors.green,
// //             ),
// //           );
// //           _refreshData(); // تحديث الشاشة بالكامل بعد الحذف
// //         }
// //       } catch (e) {
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(
// //               content: Text("حدث خطأ أثناء الحذف"),
// //               backgroundColor: Colors.red,
// //             ),
// //           );
// //         }
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       key: _scaffoldKey,
// //       backgroundColor: const Color(0xFFE0F2F1),
// //       drawer: CustSidebar(
// //         selectedIndex: _selectedIndex,
// //         onItemSelected: _handleNavigation,
// //       ),
// //       body: Directionality(
// //         textDirection: Directionality.of(context),
// //         child: Row(
// //           children: [
// //             CustSidebar(
// //               selectedIndex: _selectedIndex,
// //               onItemSelected: _handleNavigation,
// //             ),
// //             Expanded(
// //               child: Padding(
// //                 padding: const EdgeInsets.all(24.0),
// //                 child: Column(
// //                   children: [
// //                     _buildHeader(),
// //                     const SizedBox(height: 20),
// //                     _buildStatsRow(),
// //                     const SizedBox(height: 25),
// //                     _buildTabBar(),
// //                     const SizedBox(height: 15),
// //                     _buildSearchAndActionRow(),
// //                     const SizedBox(height: 20),
// //                     Expanded(
// //                       child: TabBarView(
// //                         controller: _tabController,
// //                         children: [
// //                           _buildManualExamsTab(),
// //                           _buildAIExamsTab(),
// //                           _buildDraftsTab(),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // --- جداول التبويبات الموحدة (تمدد كامل + تمرير للأسفل + حذف فعال) ---

// //   Widget _buildManualExamsTab() {
// //     return FutureBuilder<List<dynamic>>(
// //       future: _manualExamsFuture,
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting)
// //           return const Center(child: CircularProgressIndicator());
// //         if (!snapshot.hasData || snapshot.data!.isEmpty)
// //           return const Center(child: Text("لا توجد بيانات"));
// //         var data = snapshot.data!
// //             .where(
// //               (e) => (e['exam_title'] ?? '').toString().contains(searchQuery),
// //             )
// //             .toList();

// //         return Container(
// //           width: double.infinity,
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(15),
// //           ),
// //           child: ClipRRect(
// //             borderRadius: BorderRadius.circular(15),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               children: [
// //                 Expanded(
// //                   child: Scrollbar(
// //                     thumbVisibility: true,
// //                     child: SingleChildScrollView(
// //                       scrollDirection: Axis.vertical, // التمرير للأسفل متاح
// //                       child: SizedBox(
// //                         width: double
// //                             .infinity, // ✅ هذا السطر يجبر الجدول يفرش للآخر
// //                         child: DataTable(
// //                           headingRowColor: WidgetStateProperty.all(
// //                             const Color(0xFFF5F5F5),
// //                           ),
// //                           columns: [
// //                             DataColumn(
// //                               label: Text(S.of(context).exam_title_label),
// //                             ),
// //                             DataColumn(
// //                               label: Text(S.of(context).exam_date_label),
// //                             ),
// //                             // DataColumn(
// //                             //   label: Text(S.of(context).students_count_label),
// //                             // ),
// //                             DataColumn(label: Text(S.of(context).status_label)),
// //                             DataColumn(label: Text(S.of(context).actions)),
// //                           ],
// //                           rows: data
// //                               .map(
// //                                 (item) => DataRow(
// //                                   cells: [
// //                                     DataCell(
// //                                       Text(
// //                                         item['exam_title'] ?? '',
// //                                         style: const TextStyle(
// //                                           fontWeight: FontWeight.bold,
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     DataCell(Text(item['exam_date'] ?? 'N/A')),
// //                                     // DataCell(
// //                                     //   Text(
// //                                     //     item['number_of_questions']
// //                                     //             ?.toString() ??
// //                                     //         '0',
// //                                     //   ),
// //                                     // ),
// //                                     DataCell(
// //                                       _statusChip(item['status'] ?? 'مكتمل'),
// //                                     ),
// //                                     DataCell(
// //                                       Row(
// //                                         children: [
// //                                           _iconBtn(
// //                                             Icons.visibility_outlined,
// //                                             Colors.grey.shade700,
// //                                             onTap: () {
// //                                               Navigator.push(
// //                                                 context,
// //                                                 MaterialPageRoute(
// //                                                   builder: (context) =>
// //                                                       const FinalExamPage(),
// //                                                 ),
// //                                               );
// //                                             },
// //                                           ),
// //                                           const SizedBox(width: 5),
// //                                           _iconBtn(
// //                                             Icons.edit_outlined,
// //                                             Colors.blue,
// //                                             onTap: () {
// //                                               Navigator.push(
// //                                                 context,
// //                                                 MaterialPageRoute(
// //                                                   builder: (context) =>
// //                                                       CreateElectronicExamPage(
// //                                                         examIdToEdit:
// //                                                             item['exam_id'], // 👈 هنا نرسل الـ ID لصفحتك اللي برمجناها
// //                                                       ),
// //                                                 ),
// //                                               ).then(
// //                                                 (_) => _refreshData(),
// //                                               ); // 👈 هذا السطر يحدث الصفحة تلقائياً بعد ما يرجع من التعديل
// //                                             },
// //                                           ),
// //                                           const SizedBox(width: 5),
// //                                           // ✅ زر الحذف مفعل لليدوي
// //                                           _iconBtn(
// //                                             Icons.delete_outline,
// //                                             Colors.redAccent,
// //                                             onTap: () => _confirmAndDeleteExam(
// //                                               item['exam_id'],
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               )
// //                               .toList(),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildAIExamsTab() {
// //     return FutureBuilder<List<dynamic>>(
// //       future: _aiExamsFuture,
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting)
// //           return const Center(child: CircularProgressIndicator());
// //         if (!snapshot.hasData || snapshot.data!.isEmpty)
// //           return const Center(child: Text("لا توجد بيانات"));
// //         var data = snapshot.data!
// //             .where(
// //               (e) => (e['exam_title'] ?? '').toString().contains(searchQuery),
// //             )
// //             .toList();

// //         return Container(
// //           width: double.infinity,
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(15),
// //           ),
// //           child: ClipRRect(
// //             borderRadius: BorderRadius.circular(15),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               children: [
// //                 Expanded(
// //                   child: Scrollbar(
// //                     thumbVisibility: true,
// //                     child: SingleChildScrollView(
// //                       scrollDirection: Axis.vertical,
// //                       child: SizedBox(
// //                         width: double
// //                             .infinity, // ✅ هذا السطر يجبر الجدول يفرش للآخر
// //                         child: DataTable(
// //                           headingRowColor: WidgetStateProperty.all(
// //                             const Color(0xFFF5F5F5),
// //                           ),
// //                           columns: [
// //                             DataColumn(
// //                               label: Text(S.of(context).exam_title_label),
// //                             ),
// //                             DataColumn(
// //                               label: Text(S.of(context).exam_date_label),
// //                             ),
// //                             // DataColumn(
// //                             //   label: Text(S.of(context).students_count_label),
// //                             // ),
// //                             DataColumn(label: Text(S.of(context).status_label)),
// //                             DataColumn(label: Text(S.of(context).actions)),
// //                           ],
// //                           rows: data
// //                               .map(
// //                                 (item) => DataRow(
// //                                   cells: [
// //                                     DataCell(
// //                                       Text(
// //                                         item['exam_title'] ?? '',
// //                                         style: const TextStyle(
// //                                           fontWeight: FontWeight.bold,
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     DataCell(Text(item['exam_date'] ?? '')),
// //                                     // DataCell(
// //                                     //   Text(
// //                                     //     item['number_of_questions']
// //                                     //             ?.toString() ??
// //                                     //         '0',
// //                                     //   ),
// //                                     // ),
// //                                     DataCell(
// //                                       _statusChip(item['status'] ?? 'مكتمل'),
// //                                     ),
// //                                     DataCell(
// //                                       Row(
// //                                         children: [
// //                                           _iconBtn(
// //                                             Icons.visibility_outlined,
// //                                             Colors.grey.shade700,
// //                                             onTap: () {
// //                                               Navigator.push(
// //                                                 context,
// //                                                 MaterialPageRoute(
// //                                                   builder: (context) =>
// //                                                       const FinalExamPage(),
// //                                                 ),
// //                                               );
// //                                             },
// //                                           ),
// //                                           const SizedBox(width: 5),
// //                                           _iconBtn(
// //                                             Icons.edit_outlined,
// //                                             Colors.blue,
// //                                             onTap: () {
// //                                               Navigator.push(
// //                                                 context,
// //                                                 MaterialPageRoute(
// //                                                   builder: (context) =>
// //                                                       CreateElectronicExamPage(
// //                                                         examIdToEdit:
// //                                                             item['exam_id'], // 👈 نرسل رقم الاختبار للصفحة
// //                                                       ),
// //                                                 ),
// //                                               ).then(
// //                                                 (_) => _refreshData(),
// //                                               ); // 👈 هذا السطر السحري عشان تتحدث القائمة أول ما يرجع!
// //                                             },
// //                                           ),
// //                                           const SizedBox(width: 5),
// //                                           // ✅ زر الحذف مفعل للذكاء الاصطناعي
// //                                           _iconBtn(
// //                                             Icons.delete_outline,
// //                                             Colors.redAccent,
// //                                             onTap: () => _confirmAndDeleteExam(
// //                                               item['exam_id'],
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               )
// //                               .toList(),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildDraftsTab() {
// //     return FutureBuilder<List<dynamic>>(
// //       future: _draftsFuture,
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting)
// //           return const Center(child: CircularProgressIndicator());
// //         if (!snapshot.hasData || snapshot.data!.isEmpty)
// //           return const Center(child: Text("لا توجد بيانات"));
// //         var data = snapshot.data!
// //             .where(
// //               (e) => (e['exam_title'] ?? '').toString().contains(searchQuery),
// //             )
// //             .toList();

// //         return Container(
// //           width: double.infinity,
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(15),
// //           ),
// //           child: ClipRRect(
// //             borderRadius: BorderRadius.circular(15),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               children: [
// //                 Expanded(
// //                   child: Scrollbar(
// //                     thumbVisibility: true,
// //                     child: SingleChildScrollView(
// //                       scrollDirection: Axis.vertical,
// //                       child: SizedBox(
// //                         width: double
// //                             .infinity, // ✅ هذا السطر يجبر الجدول يفرش للآخر
// //                         child: DataTable(
// //                           headingRowColor: WidgetStateProperty.all(
// //                             const Color(0xFFF5F5F5),
// //                           ),
// //                           columns: [
// //                             DataColumn(
// //                               label: Text(S.of(context).exam_title_label),
// //                             ),
// //                             DataColumn(
// //                               label: Text(S.of(context).exam_date_label),
// //                             ),
// //                             // DataColumn(
// //                             //   label: Text(S.of(context).students_count_label),
// //                             // ),
// //                             DataColumn(label: Text(S.of(context).status_label)),
// //                             DataColumn(label: Text(S.of(context).actions)),
// //                           ],
// //                           rows: data
// //                               .map(
// //                                 (item) => DataRow(
// //                                   cells: [
// //                                     DataCell(
// //                                       Text(
// //                                         item['exam_title'] ?? '',
// //                                         style: const TextStyle(
// //                                           fontWeight: FontWeight.bold,
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     DataCell(Text(item['exam_date'] ?? 'N/A')),
// //                                     // DataCell(
// //                                     //   Text(
// //                                     //     item['number_of_questions']
// //                                     //             ?.toString() ??
// //                                     //         '0',
// //                                     //   ),
// //                                     // ),
// //                                     DataCell(_statusChip('draft')),
// //                                     DataCell(
// //                                       Row(
// //                                         children: [
// //                                           _iconBtn(
// //                                             Icons.edit_outlined,
// //                                             Colors.blue,
// //                                             onTap: () {
// //                                               Navigator.push(
// //                                                 context,
// //                                                 MaterialPageRoute(
// //                                                   builder: (context) =>
// //                                                       CreateElectronicExamPage(
// //                                                         examIdToEdit:
// //                                                             item['exam_id'], // 👈 نرسل رقم الاختبار للصفحة
// //                                                       ),
// //                                                 ),
// //                                               ).then(
// //                                                 (_) => _refreshData(),
// //                                               ); // 👈 هذا السطر السحري عشان تتحدث القائمة أول ما يرجع!
// //                                             },
// //                                           ),
// //                                           const SizedBox(width: 5),
// //                                           // ✅ زر الحذف مفعل للمسودات
// //                                           _iconBtn(
// //                                             Icons.delete_outline,
// //                                             Colors.redAccent,
// //                                             onTap: () => _confirmAndDeleteExam(
// //                                               item['exam_id'],
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               )
// //                               .toList(),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   // --- دوال التصميم ---

// //   Widget _buildHeader() {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(15),
// //       ),
// //       child: Row(
// //         children: [
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 S.of(context).exam_management,
// //                 style: const TextStyle(
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               Text(
// //                 S.of(context).manage_your_materials_and_exams,
// //                 style: TextStyle(fontSize: 12, color: Colors.grey[600]),
// //               ),
// //             ],
// //           ),
// //           const Spacer(),
// //
// //           const SizedBox(width: 12),
// //           _headerIcon(
// //             Icons.person_outline,
// //             onTap: () {
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (context) => const ProfileSettingsPage(),
// //                 ),
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _headerIcon(IconData icon, {VoidCallback? onTap}) => InkWell(
// //     onTap: onTap,
// //     borderRadius: BorderRadius.circular(50),
// //     child: Container(
// //       padding: const EdgeInsets.all(8),
// //       decoration: const BoxDecoration(
// //         color: Color(0xFFE0F2F1),
// //         shape: BoxShape.circle,
// //       ),
// //       child: Icon(icon, color: const Color(0xFF4DB6AC)),
// //     ),
// //   );

// //   Widget _buildStatsRow() {
// //     return Row(
// //       children: [
// //         _statCard(
// //           draftsCount.toString(),
// //           S.of(context).save_as_draft,
// //           Icons.description,
// //           Colors.blueGrey,
// //         ),
// //         const SizedBox(width: 15),
// //         _statCard(
// //           manualExamsCount.toString(),
// //           S.of(context).create_manual_exam,
// //           Icons.edit_document,
// //           Colors.orangeAccent,
// //         ),
// //         const SizedBox(width: 15),
// //         _statCard(
// //           aiExamsCount.toString(),
// //           S.of(context).generate_ai_exam,
// //           Icons.psychology,
// //           Colors.teal,
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _statCard(String count, String label, IconData icon, Color color) {
// //     return Expanded(
// //       child: Container(
// //         padding: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(15),
// //         ),
// //         child: Row(
// //           children: [
// //             Text(
// //               label,
// //               style: const TextStyle(fontSize: 12, color: Colors.grey),
// //             ),
// //             const Spacer(),
// //             Row(
// //               children: [
// //                 Text(
// //                   count,
// //                   style: TextStyle(
// //                     fontSize: 28,
// //                     fontWeight: FontWeight.bold,
// //                     color: color,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 8),
// //                 Container(
// //                   padding: const EdgeInsets.all(6),
// //                   decoration: BoxDecoration(
// //                     color: color.withValues(alpha: 0.1),
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                   child: Icon(icon, color: color, size: 24),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSearchAndActionRow() {
// //     bool isDrafts = _tabController.index == 2;
// //     bool isAI = _tabController.index == 1;
// //     return Row(
// //       children: [
// //         SizedBox(
// //           width: 350,
// //           child: TextField(
// //             onChanged: (val) => setState(() => searchQuery = val),
// //             decoration: InputDecoration(
// //               hintText: S.of(context).exam_title_hint,
// //               prefixIcon: const Icon(Icons.search, color: Colors.grey),
// //               filled: true,
// //               fillColor: Colors.white,
// //               border: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(10),
// //                 borderSide: BorderSide.none,
// //               ),
// //             ),
// //           ),
// //         ),
// //         const Spacer(),
// //         if (!isDrafts)
// //           ElevatedButton.icon(
// //             onPressed: () {
// //               if (isAI) {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (context) => const CreateAIExamScreen(),
// //                   ),
// //                 ).then((value) => _refreshData());
// //               } else {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (context) => const CreateElectronicExamPage(),
// //                   ),
// //                 ).then((value) => _refreshData());
// //               }
// //             },
// //             icon: const Icon(Icons.add, color: Colors.white),
// //             label: Text(
// //               isAI
// //                   ? S.of(context).generate_ai_exam
// //                   : S.of(context).create_manual_exam,
// //               style: const TextStyle(
// //                 color: Colors.white,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: const Color(0xFF4DB6AC),
// //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //             ),
// //           ),
// //       ],
// //     );
// //   }

// //   Widget _buildTabBar() => Align(
// //     alignment: Alignment.centerRight,
// //     child: TabBar(
// //       controller: _tabController,
// //       isScrollable: true,
// //       indicatorColor: const Color(0xFF4DB6AC),
// //       labelColor: const Color(0xFF4DB6AC),
// //       tabs: [
// //         Tab(text: S.of(context).manual_tab),
// //         Tab(text: S.of(context).ai_tab),
// //         Tab(text: S.of(context).drafts_tab),
// //       ],
// //     ),
// //   );

// //   Widget _statusChip(String statusKey) {
// //     String displayStatus;
// //     Color textColor;
// //     Color bgColor;

// //     String cleanStatus = statusKey.trim().toLowerCase();

// //     if (cleanStatus.contains("completed") ||
// //         cleanStatus.contains("مكتمل") ||
// //         cleanStatus.contains("published")) {
// //       displayStatus = S.of(context).completed_status;
// //       textColor = Colors.green;
// //       bgColor = Colors.green[50]!;
// //     } else {
// //       displayStatus = S.of(context).draft_status;
// //       textColor = Colors.grey;
// //       bgColor = Colors.grey[100]!;
// //     }

// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //       decoration: BoxDecoration(
// //         color: bgColor,
// //         borderRadius: BorderRadius.circular(5),
// //       ),
// //       child: Text(
// //         displayStatus,
// //         style: TextStyle(
// //           color: textColor,
// //           fontSize: 10,
// //           fontWeight: FontWeight.bold,
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _infoRow(IconData icon, String text) => Row(
// //     children: [
// //       Icon(icon, size: 14, color: Colors.grey),
// //       const SizedBox(width: 8),
// //       Text(text, style: const TextStyle(fontSize: 11, color: Colors.grey)),
// //     ],
// //   );

// //   Widget _iconBtn(IconData icon, Color color, {VoidCallback? onTap}) => InkWell(
// //     onTap: onTap,
// //     child: Container(
// //       padding: const EdgeInsets.all(8),
// //       decoration: BoxDecoration(
// //         color: color.withValues(alpha: 0.1),
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //       child: Icon(icon, color: color, size: 18),
// //     ),
// //   );
// // }

// import 'package:flutter/material.dart';
// import '../core/colors.dart';
// import '../generated/l10n.dart';
// import 'create_electronic_exam.dart';
// import 'teacher_dashboard.dart';
// import 'create_ai_exam_screen.dart';
// import 'teacher_matearial.dart' hide HeaderWidget;
// import 'grading.dart' hide HeaderWidget;
// import 'review_exam_screen.dart';
// import 'teacer_setting.dart';
// import 'teacher_profile_settings_page.dart';
// import 'exam_page.dart';
// import '../service/api_service.dart';

// class ExamManagementPage extends StatefulWidget {
//   const ExamManagementPage({super.key});

//   @override
//   State<ExamManagementPage> createState() => _ExamManagementPageState();
// }

// class _ExamManagementPageState extends State<ExamManagementPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final int _selectedIndex = 1;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   String searchQuery = "";
//   final ApiService _apiService = ApiService();

//   // المتغيرات الحقيقية للإحصائيات العلوية
//   int manualExamsCount = 0;
//   int aiExamsCount = 0;
//   int draftsCount = 0;

//   // متغيرات لحفظ حالة الجداول وإجبارها على التحديث
//   late Future<List<dynamic>> _manualExamsFuture;
//   late Future<List<dynamic>> _aiExamsFuture;
//   late Future<List<dynamic>> _draftsFuture;

//   // دالة التحديث الشامل (تحدث الجداول + الأرقام معاً)
//   void _refreshData() {
//     setState(() {
//       _manualExamsFuture = _apiService.fetchExams("Manual", 1);
//       _aiExamsFuture = _apiService.fetchExams("AI", 1);
//       _draftsFuture = _apiService.fetchExams("Draft", 1);
//     });
//     _loadStats();
//   }

//   Future<void> _loadStats() async {
//     try {
//       var manual = await _apiService.fetchExams("Manual", 1);
//       var ai = await _apiService.fetchExams("AI", 1);
//       var drafts = await _apiService.fetchExams("Draft", 1);

//       if (mounted) {
//         setState(() {
//           manualExamsCount = manual.length;
//           aiExamsCount = ai.length;
//           draftsCount = drafts.length;
//         });
//       }
//     } catch (e) {
//       debugPrint("Error loading stats: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _tabController.addListener(() => setState(() {}));
//     _refreshData(); // تشغيل التحديث الشامل عند فتح الصفحة
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _handleNavigation(int index) {
//     if (index == _selectedIndex) return;
//     if (_scaffoldKey.currentState?.isDrawerOpen ?? false)
//       Navigator.pop(context);

//     Widget? targetPage;
//     switch (index) {
//       case 0:
//         targetPage = const DashboardScreen();
//         break;
//       case 1:
//         targetPage = const ExamManagementPage();
//         break;
//       case 2:
//         targetPage = const Material1();
//         break;
//       case 3:
//         targetPage = const GradingPage();
//         break;
//       case 4:
//         targetPage = const ReviewExamPage();
//         break;
//       case 5:
//         targetPage = const SettingsScreen();
//         break;
//     }
//     if (targetPage != null) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => targetPage!),
//       );
//     }
//   }

//   // دالة الحذف القوية مع تأكيد وتحديث مباشر
//   Future<void> _confirmAndDeleteExam(dynamic examId) async {
//     bool? confirm = await showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text(
//           "تأكيد الحذف",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: const Text("هل أنت متأكد من حذف هذا الاختبار نهائياً؟"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, false),
//             child: const Text("إلغاء"),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(ctx, true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
//             child: const Text("حذف", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       try {
//         await _apiService.deleteExam(examId); // الحذف الفعلي من الداتا بيس
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("تم الحذف بنجاح!"),
//               backgroundColor: Colors.green,
//             ),
//           );
//           _refreshData(); // تحديث الشاشة بالكامل بعد الحذف
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("حدث خطأ أثناء الحذف"),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }
//     }
//   }

//   // نافذة تحذير التعديل للاختبارات المكتملة
//   void _showEditWarningDialog(dynamic examId) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: [
//             const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 S.of(context).edit_warning_title,
//                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//         content: Text(
//           S.of(context).edit_warning_content,
//           style: const TextStyle(height: 1.6, fontSize: 14),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: Text(
//               S.of(context).edit_warning_cancel,
//               style: const TextStyle(color: Colors.grey),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(ctx);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => CreateElectronicExamPage(
//                     examIdToEdit: examId,
//                   ),
//                 ),
//               ).then((_) => _refreshData());
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.orange,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: Text(
//               S.of(context).edit_warning_continue,
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ✅ جلب مقاس الشاشة للتحكم بالتصميم (Responsive)
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isMobile = screenWidth < 600;
//     final isDesktop = screenWidth >= 900;

//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: const Color(0xFFE0F2F1),
//       drawer: CustSidebar(
//         selectedIndex: _selectedIndex,
//         onItemSelected: _handleNavigation,
//       ),
//       body: Directionality(
//         textDirection: Directionality.of(context),
//         child: Row(
//           children: [
//             // ✅ عرض القائمة الجانبية فقط في الشاشات الكبيرة
//             if (isDesktop)
//               CustSidebar(
//                 selectedIndex: _selectedIndex,
//                 onItemSelected: _handleNavigation,
//               ),
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.all(
//                   isMobile ? 12.0 : 24.0,
//                 ), // ✅ تقليل الحواف في الجوال
//                 child: Column(
//                   children: [
//                     _buildHeader(isMobile, isDesktop),
//                     SizedBox(height: isMobile ? 10 : 20),
//                     _buildStatsRow(isMobile),
//                     SizedBox(height: isMobile ? 15 : 25),
//                     _buildTabBar(),
//                     SizedBox(height: isMobile ? 10 : 15),
//                     _buildSearchAndActionRow(isMobile),
//                     const SizedBox(height: 20),
//                     Expanded(
//                       child: TabBarView(
//                         controller: _tabController,
//                         children: [
//                           _buildManualExamsTab(),
//                           _buildAIExamsTab(),
//                           _buildDraftsTab(),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- جداول التبويبات الموحدة (تمدد كامل + تمرير للأسفل + تمرير أفقي للجوال + حذف فعال) ---

//   Widget _buildManualExamsTab() {
//     return FutureBuilder<List<dynamic>>(
//       future: _manualExamsFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting)
//           return const Center(child: CircularProgressIndicator());
//         if (!snapshot.hasData || snapshot.data!.isEmpty)
//           return const Center(child: Text("لا توجد بيانات"));
//         var data = snapshot.data!
//             .where(
//               (e) => (e['exam_title'] ?? '').toString().contains(searchQuery),
//             )
//             .toList();

//         return Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Expanded(
//                   child: Scrollbar(
//                     thumbVisibility: true,
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical, // التمرير للأسفل متاح
//                       child: LayoutBuilder(
//                         builder: (context, constraints) {
//                           return SingleChildScrollView(
//                             scrollDirection: Axis
//                                 .horizontal, // ✅ التمرير الأفقي للشاشات الصغيرة متاح
//                             child: ConstrainedBox(
//                               constraints: BoxConstraints(
//                                 minWidth: constraints.maxWidth,
//                               ), // ✅ بديل double.infinity للحفاظ على التمدد بدون أخطاء
//                               child: DataTable(
//                                 headingRowColor: WidgetStateProperty.all(
//                                   const Color(0xFFF5F5F5),
//                                 ),
//                                 columns: [
//                                   DataColumn(
//                                     label: Text(S.of(context).exam_title_label),
//                                   ),
//                                   DataColumn(
//                                     label: Text(S.of(context).exam_date_label),
//                                   ),
//                                   DataColumn(
//                                     label: Text(
//                                       S.of(context).course_name_label,
//                                     ),
//                                   ),
//                                   DataColumn(
//                                     label: Text(S.of(context).status_label),
//                                   ),
//                                   DataColumn(
//                                     label: Text(S.of(context).actions),
//                                   ),
//                                 ],
//                                 rows: data
//                                     .map(
//                                       (item) => DataRow(
//                                         cells: [
//                                           DataCell(
//                                             Text(
//                                               item['exam_title'] ?? '',
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                           DataCell(
//                                             Text(item['exam_date'] ?? 'N/A'),
//                                           ),
//                                           DataCell(
//                                             Text(
//                                               item['course_name'] ?? 'بدون مادة',
//                                             ),
//                                           ),
//                                           DataCell(
//                                             _statusChip(
//                                               item['status'] ?? 'مكتمل',
//                                             ),
//                                           ),
//                                           DataCell(
//                                             Row(
//                                               children: [
//                                                 if (item['status']?.toString().toLowerCase() == 'published')
//                                                   _iconBtn(
//                                                     Icons.visibility_outlined,
//                                                     Colors.grey.shade700,
//                                                     onTap: () {
//                                                       Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               const FinalExamPage(),
//                                                         ),
//                                                       );
//                                                     },
//                                                   ),
//                                                 if (item['status']?.toString().toLowerCase() == 'published')
//                                                   const SizedBox(width: 5),
//                                                 _iconBtn(
//                                                   Icons.edit_outlined,
//                                                   Colors.blue,
//                                                   onTap: () {
//                                                     if (item['status']?.toString().toLowerCase() == 'published') {
//                                                       _showEditWarningDialog(item['exam_id']);
//                                                     } else {
//                                                       Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder: (context) => CreateElectronicExamPage(
//                                                             examIdToEdit: item['exam_id'],
//                                                           ),
//                                                         ),
//                                                       ).then((_) => _refreshData());
//                                                     }
//                                                   },
//                                                 ),
//                                                 const SizedBox(width: 5),
//                                                 // ✅ زر الحذف مفعل لليدوي
//                                                 _iconBtn(
//                                                   Icons.delete_outline,
//                                                   Colors.redAccent,
//                                                   onTap: () =>
//                                                       _confirmAndDeleteExam(
//                                                         item['exam_id'],
//                                                       ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                     .toList(),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildAIExamsTab() {
//     return FutureBuilder<List<dynamic>>(
//       future: _aiExamsFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting)
//           return const Center(child: CircularProgressIndicator());
//         if (!snapshot.hasData || snapshot.data!.isEmpty)
//           return const Center(child: Text("لا توجد بيانات"));
//         var data = snapshot.data!
//             .where(
//               (e) => (e['exam_title'] ?? '').toString().contains(searchQuery),
//             )
//             .toList();

//         return Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Expanded(
//                   child: Scrollbar(
//                     thumbVisibility: true,
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: LayoutBuilder(
//                         builder: (context, constraints) {
//                           return SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: ConstrainedBox(
//                               constraints: BoxConstraints(
//                                 minWidth: constraints.maxWidth,
//                               ), // ✅ بديل double.infinity
//                               child: DataTable(
//                                 headingRowColor: WidgetStateProperty.all(
//                                   const Color(0xFFF5F5F5),
//                                 ),
//                                 columns: [
//                                   DataColumn(
//                                     label: Text(S.of(context).exam_title_label),
//                                   ),
//                                   DataColumn(
//                                     label: Text(S.of(context).exam_date_label),
//                                   ),
//                                   DataColumn(
//                                     label: Text(
//                                       S.of(context).course_name_label,
//                                     ),
//                                   ),
//                                   DataColumn(
//                                     label: Text(S.of(context).status_label),
//                                   ),
//                                   DataColumn(
//                                     label: Text(S.of(context).actions),
//                                   ),
//                                 ],
//                                 rows: data
//                                     .map(
//                                       (item) => DataRow(
//                                         cells: [
//                                           DataCell(
//                                             Text(
//                                               item['exam_title'] ?? '',
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                           DataCell(
//                                             Text(item['exam_date'] ?? ''),
//                                           ),
//                                           DataCell(
//                                             Text(
//                                               item['course_name'] ?? 'بدون مادة',
//                                             ),
//                                           ),
//                                           DataCell(
//                                             _statusChip(
//                                               item['status'] ?? 'مكتمل',
//                                             ),
//                                           ),
//                                           DataCell(
//                                             Row(
//                                               children: [
//                                                 if (item['status']?.toString().toLowerCase() == 'published')
//                                                   _iconBtn(
//                                                     Icons.visibility_outlined,
//                                                     Colors.grey.shade700,
//                                                     onTap: () {
//                                                       Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               const FinalExamPage(),
//                                                         ),
//                                                       );
//                                                     },
//                                                   ),
//                                                 if (item['status']?.toString().toLowerCase() == 'published')
//                                                   const SizedBox(width: 5),
//                                                 _iconBtn(
//                                                   Icons.edit_outlined,
//                                                   Colors.blue,
//                                                   onTap: () {
//                                                     if (item['status']?.toString().toLowerCase() == 'published') {
//                                                       _showEditWarningDialog(item['exam_id']);
//                                                     } else {
//                                                       Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder: (context) => CreateElectronicExamPage(
//                                                             examIdToEdit: item['exam_id'],
//                                                           ),
//                                                         ),
//                                                       ).then((_) => _refreshData());
//                                                     }
//                                                   },
//                                                 ),
//                                                 const SizedBox(width: 5),
//                                                 // ✅ زر الحذف مفعل للذكاء الاصطناعي
//                                                 _iconBtn(
//                                                   Icons.delete_outline,
//                                                   Colors.redAccent,
//                                                   onTap: () =>
//                                                       _confirmAndDeleteExam(
//                                                         item['exam_id'],
//                                                       ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                     .toList(),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDraftsTab() {
//     return FutureBuilder<List<dynamic>>(
//       future: _draftsFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting)
//           return const Center(child: CircularProgressIndicator());
//         if (!snapshot.hasData || snapshot.data!.isEmpty)
//           return const Center(child: Text("لا توجد بيانات"));
//         var data = snapshot.data!
//             .where(
//               (e) => (e['exam_title'] ?? '').toString().contains(searchQuery),
//             )
//             .toList();

//         return Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Expanded(
//                   child: Scrollbar(
//                     thumbVisibility: true,
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: LayoutBuilder(
//                         builder: (context, constraints) {
//                           return SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: ConstrainedBox(
//                               constraints: BoxConstraints(
//                                 minWidth: constraints.maxWidth,
//                               ), // ✅ بديل double.infinity
//                               child: DataTable(
//                                 headingRowColor: WidgetStateProperty.all(
//                                   const Color(0xFFF5F5F5),
//                                 ),
//                                 columns: [
//                                   DataColumn(
//                                     label: Text(S.of(context).exam_title_label),
//                                   ),
//                                   DataColumn(
//                                     label: Text(S.of(context).exam_date_label),
//                                   ),
//                                   DataColumn(
//                                     label: Text(
//                                       S.of(context).course_name_label,
//                                     ),
//                                   ),
//                                   DataColumn(
//                                     label: Text(S.of(context).status_label),
//                                   ),
//                                   DataColumn(
//                                     label: Text(S.of(context).actions),
//                                   ),
//                                 ],
//                                 rows: data
//                                     .map(
//                                       (item) => DataRow(
//                                         cells: [
//                                           DataCell(
//                                             Text(
//                                               item['exam_title'] ?? '',
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                           DataCell(
//                                             Text(item['exam_date'] ?? 'N/A'),
//                                           ),
//                                           DataCell(
//                                             Text(
//                                               item['course_name'] ?? 'بدون مادة',
//                                             ),
//                                           ),
//                                           DataCell(_statusChip('draft')),
//                                           DataCell(
//                                             Row(
//                                               children: [
//                                                 _iconBtn(
//                                                   Icons.edit_outlined,
//                                                   Colors.blue,
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) => CreateElectronicExamPage(
//                                                           examIdToEdit: item['exam_id'],
//                                                         ),
//                                                       ),
//                                                     ).then((_) => _refreshData());
//                                                   },
//                                                 ),
//                                                 const SizedBox(width: 5),
//                                                 // ✅ زر الحذف مفعل للمسودات
//                                                 _iconBtn(
//                                                   Icons.delete_outline,
//                                                   Colors.redAccent,
//                                                   onTap: () =>
//                                                       _confirmAndDeleteExam(
//                                                         item['exam_id'],
//                                                       ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                     .toList(),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // --- دوال التصميم (تم تحديثها لدعم الأحجام) ---

//   Widget _buildHeader(bool isMobile, bool isDesktop) {
//     return Container(
//       padding: EdgeInsets.all(isMobile ? 12 : 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         children: [
//           if (!isDesktop) ...[
//             IconButton(
//               icon: const Icon(Icons.menu, color: Color(0xFF4DB6AC)),
//               onPressed: () => _scaffoldKey.currentState
//                   ?.openDrawer(), // ✅ زر فتح القائمة للشاشات الصغيرة
//             ),
//             const SizedBox(width: 8),
//           ],
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   S.of(context).exam_management,
//                   style: TextStyle(
//                     fontSize: isMobile ? 16 : 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   S.of(context).manage_your_materials_and_exams,
//                   style: TextStyle(
//                     fontSize: isMobile ? 10 : 12,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 12),
//           _headerIcon(
//             Icons.person_outline,
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const ProfileSettingsPage(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _headerIcon(IconData icon, {VoidCallback? onTap}) => InkWell(
//     onTap: onTap,
//     borderRadius: BorderRadius.circular(50),
//     child: Container(
//       padding: const EdgeInsets.all(8),
//       decoration: const BoxDecoration(
//         color: Color(0xFFE0F2F1),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(icon, color: const Color(0xFF4DB6AC)),
//     ),
//   );

//   Widget _buildStatsRow(bool isMobile) {
//     // ✅ في حال الجوال نعرض الإحصائيات كـ Column عشان ما تضرب المساحة
//     if (isMobile) {
//       return Column(
//         children: [
//           _statCard(
//             draftsCount.toString(),
//             S.of(context).save_as_draft,
//             Icons.description,
//             Colors.blueGrey,
//             isMobile: true,
//           ),
//           const SizedBox(height: 10),
//           _statCard(
//             manualExamsCount.toString(),
//             S.of(context).create_manual_exam,
//             Icons.edit_document,
//             Colors.orangeAccent,
//             isMobile: true,
//           ),
//           const SizedBox(height: 10),
//           _statCard(
//             aiExamsCount.toString(),
//             S.of(context).generate_ai_exam,
//             Icons.psychology,
//             Colors.teal,
//             isMobile: true,
//           ),
//         ],
//       );
//     }
//     // ✅ في حال الديسكتوب والآيباد نعرضها كـ Row
//     return Row(
//       children: [
//         _statCard(
//           draftsCount.toString(),
//           S.of(context).save_as_draft,
//           Icons.description,
//           Colors.blueGrey,
//         ),
//         const SizedBox(width: 15),
//         _statCard(
//           manualExamsCount.toString(),
//           S.of(context).create_manual_exam,
//           Icons.edit_document,
//           Colors.orangeAccent,
//         ),
//         const SizedBox(width: 15),
//         _statCard(
//           aiExamsCount.toString(),
//           S.of(context).generate_ai_exam,
//           Icons.psychology,
//           Colors.teal,
//         ),
//       ],
//     );
//   }

//   Widget _statCard(
//     String count,
//     String label,
//     IconData icon,
//     Color color, {
//     bool isMobile = false,
//   }) {
//     Widget card = Container(
//       padding: EdgeInsets.all(isMobile ? 12 : 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               label,
//               style: const TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ),
//           Row(
//             children: [
//               Text(
//                 count,
//                 style: TextStyle(
//                   fontSize: isMobile ? 22 : 28,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: color.withValues(alpha: 0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(icon, color: color, size: isMobile ? 20 : 24),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//     // ✅ منع Expanded داخل الـ Column في وضع الجوال
//     return isMobile ? card : Expanded(child: card);
//   }

//   Widget _buildSearchAndActionRow(bool isMobile) {
//     bool isDrafts = _tabController.index == 2;
//     bool isAI = _tabController.index == 1;

//     Widget searchField = TextField(
//       onChanged: (val) => setState(() => searchQuery = val),
//       decoration: InputDecoration(
//         hintText: S.of(context).exam_title_hint,
//         prefixIcon: const Icon(Icons.search, color: Colors.grey),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );

//     Widget actionButton = ElevatedButton.icon(
//       onPressed: () {
//         if (isAI) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const CreateAIExamScreen()),
//           ).then((value) => _refreshData());
//         } else {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const CreateElectronicExamPage(),
//             ),
//           ).then((value) => _refreshData());
//         }
//       },
//       icon: const Icon(Icons.add, color: Colors.white),
//       label: Text(
//         isAI
//             ? S.of(context).generate_ai_exam
//             : S.of(context).create_manual_exam,
//         style: const TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFF4DB6AC),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );

//     // ✅ ترتيب عمودي للجوال عشان البحث والزر ياخذون راحتهم بدون Overflow
//     if (isMobile) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           searchField,
//           if (!isDrafts) ...[const SizedBox(height: 10), actionButton],
//         ],
//       );
//     }

//     // ✅ الترتيب الأفقي الأساسي للديسكتوب
//     return Row(
//       children: [
//         SizedBox(width: 350, child: searchField),
//         const Spacer(),
//         if (!isDrafts) actionButton,
//       ],
//     );
//   }

//   Widget _buildTabBar() => Align(
//     alignment: Alignment.centerRight,
//     child: TabBar(
//       controller: _tabController,
//       isScrollable: true,
//       indicatorColor: const Color(0xFF4DB6AC),
//       labelColor: const Color(0xFF4DB6AC),
//       tabs: [
//         Tab(text: S.of(context).manual_tab),
//         Tab(text: S.of(context).ai_tab),
//         Tab(text: S.of(context).drafts_tab),
//       ],
//     ),
//   );

//   Widget _statusChip(String statusKey) {
//     String displayStatus;
//     Color textColor;
//     Color bgColor;

//     String cleanStatus = statusKey.trim().toLowerCase();

//     if (cleanStatus.contains("completed") ||
//         cleanStatus.contains("مكتمل") ||
//         cleanStatus.contains("published")) {
//       displayStatus = S.of(context).completed_status;
//       textColor = Colors.green;
//       bgColor = Colors.green[50]!;
//     } else {
//       displayStatus = S.of(context).draft_status;
//       textColor = Colors.grey;
//       bgColor = Colors.grey[100]!;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Text(
//         displayStatus,
//         style: TextStyle(
//           color: textColor,
//           fontSize: 10,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Widget _infoRow(IconData icon, String text) => Row(
//     children: [
//       Icon(icon, size: 14, color: Colors.grey),
//       const SizedBox(width: 8),
//       Text(text, style: const TextStyle(fontSize: 11, color: Colors.grey)),
//     ],
//   );

//   Widget _iconBtn(IconData icon, Color color, {VoidCallback? onTap}) => InkWell(
//     onTap: onTap,
//     child: Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Icon(icon, color: color, size: 18),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../generated/l10n.dart';
import 'create_electronic_exam.dart';
import 'teacher_dashboard.dart';
import 'create_ai_exam_screen.dart';
import 'teacher_matearial.dart' hide HeaderWidget;
import 'grading.dart' hide HeaderWidget;
import 'review_exam_screen.dart';
import 'teacer_setting.dart';
import 'teacher_profile_settings_page.dart';
import 'exam_page.dart';
import '../service/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ExamManagementPage extends StatefulWidget {
  const ExamManagementPage({super.key});

  @override
  State<ExamManagementPage> createState() => _ExamManagementPageState();
}

class _ExamManagementPageState extends State<ExamManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int _selectedIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String searchQuery = "";
  final ApiService _apiService = ApiService();

  // المتغيرات الحقيقية للإحصائيات العلوية
  int manualExamsCount = 0;
  int aiExamsCount = 0;
  int draftsCount = 0;

  // متغيرات لحفظ حالة الجداول وإجبارها على التحديث
  late Future<List<dynamic>> _manualExamsFuture;
  late Future<List<dynamic>> _aiExamsFuture;
  late Future<List<dynamic>> _draftsFuture;

  // دالة التحديث الشامل (تحدث الجداول + الأرقام معاً)
  void _refreshData() {
    setState(() {
      _manualExamsFuture = _apiService.fetchExams("Manual", 1);
      _aiExamsFuture = _apiService.fetchExams("AI", 1);
      _draftsFuture = _apiService.fetchExams("Draft", 1);
    });
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      var manual = await _apiService.fetchExams("Manual", 1);
      var ai = await _apiService.fetchExams("AI", 1);
      var drafts = await _apiService.fetchExams("Draft", 1);

      if (mounted) {
        setState(() {
          manualExamsCount = manual.length;
          aiExamsCount = ai.length;
          draftsCount = drafts.length;
        });
      }
    } catch (e) {
      debugPrint("Error loading stats: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _refreshData(); // تشغيل التحديث الشامل عند فتح الصفحة
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleNavigation(int index) {
    if (index == _selectedIndex) return;
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.pop(context);
    }

    Widget? targetPage;
    switch (index) {
      case 0:
        targetPage = const DashboardScreen();
        break;
      case 1:
        targetPage = const ExamManagementPage();
        break;
      case 2:
        targetPage = const Material1();
        break;
      case 3:
        targetPage = const GradingPage();
        break;
      case 4:
        targetPage = const ReviewExamPage();
        break;
      case 5:
        targetPage = const SettingsScreen();
        break;
    }
    if (targetPage != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => targetPage!),
      );
    }
  }

  // دالة الحذف القوية مع تأكيد وتحديث مباشر
  Future<void> _confirmAndDeleteExam(dynamic examId) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          "تأكيد الحذف",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("هل أنت متأكد من حذف هذا الاختبار نهائياً؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text("حذف", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _apiService.deleteExam(examId); // الحذف الفعلي من الداتا بيس
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم الحذف بنجاح!"),
              backgroundColor: Colors.green,
            ),
          );
          _refreshData(); // تحديث الشاشة بالكامل بعد الحذف
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("حدث خطأ أثناء الحذف"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  // نافذة تحذير التعديل للاختبارات المكتملة
  // دالة الضغط على زر القلم (الذكية)
  Future<void> _onEditTapped(
    BuildContext context,
    dynamic examId,
    String status,
  ) async {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    String cleanStatus = status.trim().toLowerCase();

    // 1. إذا كان الاختبار "مسودة" (يدخل مباشرة)
    if (cleanStatus == 'draft' || cleanStatus == 'مسودة') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateElectronicExamPage(examIdToEdit: examId),
        ),
      ).then((_) => _refreshData());
      return;
    }

    // 2. إذا كان الاختبار "مكتمل/معتمد"
    if (cleanStatus == 'published' || cleanStatus == 'مكتمل') {
      // إظهار الديلوج التحميلي
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // 🚨 تنبيه: غيري الرابط للرابط حق السيرفر حقك!
        var url = Uri.parse(
          'http://127.0.0.1:8000/api/exams/check-answers/$examId',
        );
        var response = await http.get(url);
        var data = jsonDecode(response.body);

        // إخفاء التحميل
        if (context.mounted) Navigator.pop(context);

        // هل في إجابات؟
        if (data['has_answers'] == true) {
          String errorMessage = isArabic
              ? "لا يمكن تعديل هذا الاختبار لوجود إجابات مسجلة للطلاب. يرجى إنشاء مسودة جديدة."
              : "Cannot edit this exam because there are recorded student answers. Please create a new draft.";

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(errorMessage)),
                  ],
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } else {
          // مافي إجابات -> يدخل لشاشة التعديل
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CreateElectronicExamPage(examIdToEdit: examId),
              ),
            ).then((_) => _refreshData());
          }
        }
      } catch (e) {
        // إخفاء التحميل لو صار خطأ بالنت
        if (context.mounted) Navigator.pop(context);

        String failMessage = isArabic
            ? "يرجى التحقق من اتصالك بالإنترنت والمحاولة مجدداً."
            : "Please check your internet connection and try again.";

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failMessage),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ جلب مقاس الشاشة للتحكم بالتصميم (Responsive)
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isDesktop = screenWidth >= 900;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFE0F2F1),
      drawer: CustSidebar(
        selectedIndex: _selectedIndex,
        onItemSelected: _handleNavigation,
      ),
      body: Directionality(
        textDirection: Directionality.of(context),
        child: Row(
          children: [
            // ✅ عرض القائمة الجانبية فقط في الشاشات الكبيرة
            if (isDesktop)
              CustSidebar(
                selectedIndex: _selectedIndex,
                onItemSelected: _handleNavigation,
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(
                  isMobile ? 12.0 : 24.0,
                ), // ✅ تقليل الحواف في الجوال
                child: Column(
                  children: [
                    _buildHeader(isMobile, isDesktop),
                    SizedBox(height: isMobile ? 10 : 20),
                    _buildStatsRow(isMobile),
                    SizedBox(height: isMobile ? 15 : 25),
                    _buildTabBar(),
                    SizedBox(height: isMobile ? 10 : 15),
                    _buildSearchAndActionRow(isMobile),
                    const SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildManualExamsTab(),
                          _buildAIExamsTab(),
                          _buildDraftsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- جداول التبويبات الموحدة (تمدد كامل + تمرير للأسفل + تمرير أفقي للجوال + حذف فعال) ---

  Widget _buildManualExamsTab() {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    String unassignedText = isArabic ? 'غير محدد' : 'Unassigned';
    return FutureBuilder<List<dynamic>>(
      future: _manualExamsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("لا توجد بيانات"));
        }
        var data = snapshot.data!
            .where(
              (e) => (e['exam_title'] ?? '').toString().contains(searchQuery),
            )
            .toList();

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical, // التمرير للأسفل متاح
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis
                              .horizontal, // ✅ التمرير الأفقي للشاشات الصغيرة متاح
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ), // ✅ بديل double.infinity للحفاظ على التمدد بدون أخطاء
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(
                                const Color(0xFFF5F5F5),
                              ),
                              columns: [
                                DataColumn(
                                  label: Text(S.of(context).exam_title_label),
                                ),
                                DataColumn(
                                  label: Text(S.of(context).exam_date_label),
                                ),
                                DataColumn(
                                  label: Text(S.of(context).course_name_label),
                                ),
                                DataColumn(
                                  label: Text(S.of(context).status_label),
                                ),
                                DataColumn(label: Text(S.of(context).actions)),
                              ],
                              rows: data
                                  .map(
                                    (item) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            item['exam_title'] ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(item['exam_date'] ?? 'N/A'),
                                        ),
                                        DataCell(
                                          Text(
                                            item['course_name'] ?? 'بدون مادة',
                                          ),
                                        ),
                                        DataCell(
                                          _statusChip(
                                            item['status'] ?? 'مكتمل',
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              if (item['status']
                                                      ?.toString()
                                                      .toLowerCase() ==
                                                  'published')
                                                _iconBtn(
                                                  Icons.visibility_outlined,
                                                  Colors.grey.shade700,
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const FinalExamPage(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              if (item['status']
                                                      ?.toString()
                                                      .toLowerCase() ==
                                                  'published')
                                                const SizedBox(width: 5),
                                              _iconBtn(
                                                Icons.edit_outlined,
                                                Colors.blue,
                                                onTap: () => _onEditTapped(
                                                  context,
                                                  item['exam_id'],
                                                  item['status'] ?? '',
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              // ✅ زر الحذف مفعل لليدوي
                                              _iconBtn(
                                                Icons.delete_outline,
                                                Colors.redAccent,
                                                onTap: () =>
                                                    _confirmAndDeleteExam(
                                                      item['exam_id'],
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAIExamsTab() {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    String unassignedText = isArabic ? 'غير محدد' : 'Unassigned';
    return FutureBuilder<List<dynamic>>(
      future: _aiExamsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("لا توجد بيانات"));
        }
        var data = snapshot.data!
            .where(
              (e) => (e['exam_title'] ?? '').toString().contains(searchQuery),
            )
            .toList();

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ), // ✅ بديل double.infinity
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(
                                const Color(0xFFF5F5F5),
                              ),
                              columns: [
                                DataColumn(
                                  label: Text(S.of(context).exam_title_label),
                                ),
                                DataColumn(
                                  label: Text(S.of(context).exam_date_label),
                                ),
                                DataColumn(
                                  label: Text(S.of(context).course_name_label),
                                ),
                                DataColumn(
                                  label: Text(S.of(context).status_label),
                                ),
                                DataColumn(label: Text(S.of(context).actions)),
                              ],
                              rows: data
                                  .map(
                                    (item) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            item['exam_title'] ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataCell(Text(item['exam_date'] ?? '')),
                                        DataCell(
                                          Text(
                                            item['course_name'] ??
                                                unassignedText,
                                            style: TextStyle(
                                              // نعطيها لون أحمر خفيف أو رمادي عشان ينتبه لها المدرس
                                              color: item['course_name'] == null
                                                  ? Colors.redAccent
                                                  : Colors.black,
                                              fontWeight:
                                                  item['course_name'] == null
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          _statusChip(
                                            item['status'] ?? 'مكتمل',
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              if (item['status']
                                                      ?.toString()
                                                      .toLowerCase() ==
                                                  'published')
                                                _iconBtn(
                                                  Icons.visibility_outlined,
                                                  Colors.grey.shade700,
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const FinalExamPage(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              if (item['status']
                                                      ?.toString()
                                                      .toLowerCase() ==
                                                  'published')
                                                const SizedBox(width: 5),
                                              _iconBtn(
                                                Icons.edit_outlined,
                                                Colors.blue,
                                                onTap: () => _onEditTapped(
                                                  context,
                                                  item['exam_id'],
                                                  item['status'] ?? '',
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              // ✅ زر الحذف مفعل للذكاء الاصطناعي
                                              _iconBtn(
                                                Icons.delete_outline,
                                                Colors.redAccent,
                                                onTap: () =>
                                                    _confirmAndDeleteExam(
                                                      item['exam_id'],
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDraftsTab() {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    String unassignedText = isArabic ? 'غير محدد' : 'Unassigned';
    return FutureBuilder<List<dynamic>>(
      future: _draftsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("لا توجد بيانات"));
        }
        var data = snapshot.data!
            .where(
              (e) => (e['exam_title'] ?? '').toString().contains(searchQuery),
            )
            .toList();

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ), // ✅ بديل double.infinity
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(
                                const Color(0xFFF5F5F5),
                              ),
                              columns: [
                                DataColumn(
                                  label: Text(S.of(context).exam_title_label),
                                ),
                                DataColumn(
                                  label: Text(S.of(context).exam_date_label),
                                ),
                                DataColumn(
                                  label: Text(S.of(context).course_name_label),
                                ),
                                DataColumn(
                                  label: Text(S.of(context).status_label),
                                ),
                                DataColumn(label: Text(S.of(context).actions)),
                              ],
                              rows: data
                                  .map(
                                    (item) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            item['exam_title'] ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(item['exam_date'] ?? 'N/A'),
                                        ),
                                        DataCell(
                                          Text(
                                            item['course_name'] ??
                                                unassignedText,
                                            style: TextStyle(
                                              // نعطيها لون أحمر خفيف أو رمادي عشان ينتبه لها المدرس
                                              color: item['course_name'] == null
                                                  ? Colors.redAccent
                                                  : Colors.black,
                                              fontWeight:
                                                  item['course_name'] == null
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        DataCell(_statusChip('draft')),
                                        DataCell(
                                          Row(
                                            children: [
                                              _iconBtn(
                                                Icons.edit_outlined,
                                                Colors.blue,
                                                onTap: () => _onEditTapped(
                                                  context,
                                                  item['exam_id'],
                                                  item['status'] ?? '',
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              // ✅ زر الحذف مفعل للمسودات
                                              _iconBtn(
                                                Icons.delete_outline,
                                                Colors.redAccent,
                                                onTap: () =>
                                                    _confirmAndDeleteExam(
                                                      item['exam_id'],
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- دوال التصميم (تم تحديثها لدعم الأحجام) ---

  Widget _buildHeader(bool isMobile, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          if (!isDesktop) ...[
            IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF4DB6AC)),
              onPressed: () => _scaffoldKey.currentState
                  ?.openDrawer(), // ✅ زر فتح القائمة للشاشات الصغيرة
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).exam_management,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  S.of(context).manage_your_materials_and_exams,
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _headerIcon(
            Icons.person_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileSettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _headerIcon(IconData icon, {VoidCallback? onTap}) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(50),
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xFFE0F2F1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: const Color(0xFF4DB6AC)),
    ),
  );

  Widget _buildStatsRow(bool isMobile) {
    // ✅ في حال الجوال نعرض الإحصائيات كـ Column عشان ما تضرب المساحة
    if (isMobile) {
      return Column(
        children: [
          _statCard(
            draftsCount.toString(),
            S.of(context).save_as_draft,
            Icons.description,
            Colors.blueGrey,
            isMobile: true,
          ),
          const SizedBox(height: 10),
          _statCard(
            manualExamsCount.toString(),
            S.of(context).create_manual_exam,
            Icons.edit_document,
            Colors.orangeAccent,
            isMobile: true,
          ),
          const SizedBox(height: 10),
          _statCard(
            aiExamsCount.toString(),
            S.of(context).generate_ai_exam,
            Icons.psychology,
            Colors.teal,
            isMobile: true,
          ),
        ],
      );
    }
    // ✅ في حال الديسكتوب والآيباد نعرضها كـ Row
    return Row(
      children: [
        _statCard(
          draftsCount.toString(),
          S.of(context).save_as_draft,
          Icons.description,
          Colors.blueGrey,
        ),
        const SizedBox(width: 15),
        _statCard(
          manualExamsCount.toString(),
          S.of(context).create_manual_exam,
          Icons.edit_document,
          Colors.orangeAccent,
        ),
        const SizedBox(width: 15),
        _statCard(
          aiExamsCount.toString(),
          S.of(context).generate_ai_exam,
          Icons.psychology,
          Colors.teal,
        ),
      ],
    );
  }

  Widget _statCard(
    String count,
    String label,
    IconData icon,
    Color color, {
    bool isMobile = false,
  }) {
    Widget card = Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Row(
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: isMobile ? 22 : 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: isMobile ? 20 : 24),
              ),
            ],
          ),
        ],
      ),
    );
    // ✅ منع Expanded داخل الـ Column في وضع الجوال
    return isMobile ? card : Expanded(child: card);
  }

  Widget _buildSearchAndActionRow(bool isMobile) {
    bool isDrafts = _tabController.index == 2;
    bool isAI = _tabController.index == 1;

    Widget searchField = TextField(
      onChanged: (val) => setState(() => searchQuery = val),
      decoration: InputDecoration(
        hintText: S.of(context).exam_title_hint,
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );

    Widget actionButton = ElevatedButton.icon(
      onPressed: () {
        if (isAI) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateAIExamScreen()),
          ).then((value) => _refreshData());
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateElectronicExamPage(),
            ),
          ).then((value) => _refreshData());
        }
      },
      icon: const Icon(Icons.add, color: Colors.white),
      label: Text(
        isAI
            ? S.of(context).generate_ai_exam
            : S.of(context).create_manual_exam,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4DB6AC),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // ✅ ترتيب عمودي للجوال عشان البحث والزر ياخذون راحتهم بدون Overflow
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          searchField,
          if (!isDrafts) ...[const SizedBox(height: 10), actionButton],
        ],
      );
    }

    // ✅ الترتيب الأفقي الأساسي للديسكتوب
    return Row(
      children: [
        SizedBox(width: 350, child: searchField),
        const Spacer(),
        if (!isDrafts) actionButton,
      ],
    );
  }

  Widget _buildTabBar() => Align(
    alignment: Alignment.centerRight,
    child: TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorColor: const Color(0xFF4DB6AC),
      labelColor: const Color(0xFF4DB6AC),
      tabs: [
        Tab(text: S.of(context).manual_tab),
        Tab(text: S.of(context).ai_tab),
        Tab(text: S.of(context).drafts_tab),
      ],
    ),
  );

  Widget _statusChip(String statusKey) {
    String displayStatus;
    Color textColor;
    Color bgColor;

    String cleanStatus = statusKey.trim().toLowerCase();

    if (cleanStatus.contains("completed") ||
        cleanStatus.contains("مكتمل") ||
        cleanStatus.contains("published")) {
      displayStatus = S.of(context).completed_status;
      textColor = Colors.green;
      bgColor = Colors.green[50]!;
    } else {
      displayStatus = S.of(context).draft_status;
      textColor = Colors.grey;
      bgColor = Colors.grey[100]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        displayStatus,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 14, color: Colors.grey),
      const SizedBox(width: 8),
      Text(text, style: const TextStyle(fontSize: 11, color: Colors.grey)),
    ],
  );

  Widget _iconBtn(IconData icon, Color color, {VoidCallback? onTap}) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 18),
    ),
  );
}
