import 'package:flutter/material.dart';
import 'package:grade/provider/ExamProvider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/colors.dart';
import 'teacher_dashboard.dart';
import 'grading.dart' hide HeaderWidget;
import 'teacher_matearial.dart' hide HeaderWidget;
import 'exam_page.dart' hide HeaderWidget;
import '../generated/l10n.dart';
import 'review_exam_screen.dart' hide HeaderWidget;
import 'teacer_setting.dart';
import 'ExamManagementPage.dart';
import 'create_ai_exam_screen.dart';
import 'create_electronic_exam.dart';
import 'package:grade/models/material_detail.dart';

class SubjectDetailsPage extends StatefulWidget {
  final int courseId;
  const SubjectDetailsPage({super.key, required this.courseId});

  @override
  State<SubjectDetailsPage> createState() => _SubjectDetailsPageState();
}

class _SubjectDetailsPageState extends State<SubjectDetailsPage> {
  String courseName = "";
  String specialization = ""; // 👈 جديد
  String levelName = ""; // 👈 جديد
  String selectedFolderName = "";
  int? selectedFolderId;
  int currentPage = 1;
  final int _selectedIndex = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _folderController = TextEditingController();

  List<FolderDetail> folders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourseDetails();
  }

  Future<void> fetchCourseDetails() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://localhost:8000/teacher-materials/detail/${widget.courseId}/1',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          courseName = data['course_name'] ?? "";
          specialization = data['department_name'] ?? "تلقائي"; // 👈 جديد
          levelName = data['level_name'] ?? "تلقائي"; // 👈 جديد

          folders = (data['folders'] as List)
              .map((f) => FolderDetail.fromJson(f))
              .toList();

          if (folders.isNotEmpty) {
            var current = folders.any((f) => f.name == selectedFolderName)
                ? folders.firstWhere((f) => f.name == selectedFolderName)
                : folders.first;

            selectedFolderName = current.name;
            selectedFolderId = current.id;
          } else {
            selectedFolderName = "";
            selectedFolderId = null;
          }
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  // --- نافذة تأكيد الحذف ---
  void _confirmDelete(
    BuildContext context,
    String title,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
        content: const Text(
          "هل أنت متأكد؟ لا يمكن استعادة البيانات بعد الحذف.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            child: const Text(
              "تأكيد الحذف",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteFolder(int folderId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:8000/teacher-materials/folder/$folderId'),
      );
      if (response.statusCode == 200) {
        selectedFolderName = "";
        fetchCourseDetails();
        bool isArabic = Directionality.of(context) == TextDirection.rtl;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    isArabic
                        ? 'تم حذف المجلد بنجاح'
                        : 'Folder deleted successfully',
                  ),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Delete Folder Error: $e");
    }
  }

  Future<void> _deleteExam(int examId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:8000/teacher-materials/exam/$examId'),
      );
      if (response.statusCode == 200) {
        fetchCourseDetails();
        bool isArabic = Directionality.of(context) == TextDirection.rtl;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    isArabic
                        ? 'تم حذف الاختبار بنجاح'
                        : 'Exam deleted successfully',
                  ),
                ],
              ),
              backgroundColor: Colors.red.shade600, // لون أحمر يدل على الحذف
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Delete Exam Error: $e");
    }
  }

  Future<void> _updateExam(int examId, String title, String status) async {
    try {
      final response = await http.put(
        Uri.parse(
          'http://localhost:8000/teacher-materials/exam/$examId?title=${Uri.encodeComponent(title)}&status=$status',
        ),
      );
      if (response.statusCode == 200) {
        fetchCourseDetails();
      }
    } catch (e) {
      debugPrint("Update Error: $e");
    }
  }

  Future<void> _handleCreateFolder() async {
    if (_folderController.text.trim().isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse(
            'http://localhost:8000/teacher-materials/add-folder/${widget.courseId}/1?name=${Uri.encodeComponent(_folderController.text.trim())}',
          ),
        );
        if (response.statusCode == 200) {
          _folderController.clear();
          if (mounted) Navigator.pop(context);
          fetchCourseDetails();
        }
      } catch (e) {
        debugPrint("Error: $e");
      }
    }
  }

  @override
  void dispose() {
    _folderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<ExamDetail> currentExams = [];
    if (folders.isNotEmpty) {
      final folder = folders.firstWhere(
        (f) => f.name == selectedFolderName,
        orElse: () => folders.first,
      );
      currentExams = folder.exams;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        bool isTablet =
            constraints.maxWidth >= 800 && constraints.maxWidth < 1150;

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
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          if (isMobile) _buildMobileAppBar(),
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(isMobile ? 16 : 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15),
                                  _buildBreadcrumbCard(selectedFolderName),
                                  const SizedBox(height: 25),
                                  _buildResponsiveFolders(isMobile),
                                  const SizedBox(height: 25),
                                  ExamTableSection(
                                    courseId: widget.courseId,
                                    courseName: courseName,
                                    specialization: specialization,
                                    levelName: levelName,
                                    folderId: selectedFolderId,
                                    folderName: selectedFolderName,
                                    exams: currentExams,
                                    currentPage: currentPage,
                                    totalPages: 1,
                                    totalFiles: currentExams.length,
                                    isMobile: isMobile,
                                    onPageChanged: (page) =>
                                        setState(() => currentPage = page),
                                    onDelete: (examId) {
                                      _confirmDelete(
                                        context,
                                        "حذف الاختبار",
                                        () => _deleteExam(examId),
                                      );
                                    },
                                    onEdit: (examId) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CreateElectronicExamPage(
                                            examIdToEdit: examId,
                                            examContext: ExamContext(
                                              courseId: widget
                                                  .courseId, // 👈 الآن متعرف عليها
                                              courseName: courseName,
                                              specialization: specialization,
                                              levelName: levelName,
                                              folderId:
                                                  selectedFolderId, // 👈 متعرف عليها
                                              folderName:
                                                  selectedFolderName, // 👈 متعرف عليها
                                            ),
                                          ),
                                        ),
                                      ).then((_) => fetchCourseDetails());
                                    },
                                    onRefresh:
                                        fetchCourseDetails, // 👈 أضيفي هذا السطر الجديد هنا
                                  ),
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
      },
    );
  }

  Widget _buildBreadcrumbCard(String currentFolder) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Material1()),
            ),
            child: Text(
              S.of(context).materials,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              isRtl ? Icons.chevron_left : Icons.chevron_right,
              color: Colors.grey,
              size: 16,
            ),
          ),
          Text(
            courseName,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              isRtl ? Icons.chevron_left : Icons.chevron_right,
              color: Colors.grey,
              size: 16,
            ),
          ),
          Text(
            currentFolder,
            style: TextStyle(
              color: AppColors.primaryTeal(context),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveFolders(bool isMobile) {
    List<Widget> folderWidgets = folders.map((f) {
      return _folderItemCard(f);
    }).toList();

    folderWidgets.add(
      InkWell(
        onTap: _showAddFolderDialog,
        borderRadius: BorderRadius.circular(20),
        child: const AddFolderCard(),
      ),
    );

    if (isMobile) {
      return SizedBox(
        height: 140,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: folderWidgets.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) =>
              SizedBox(width: 170, child: folderWidgets[index]),
        ),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: folderWidgets
              .map(
                (fw) => Container(
                  width: 240,
                  margin: const EdgeInsetsDirectional.only(end: 15),
                  child: fw,
                ),
              )
              .toList(),
        ),
      );
    }
  }

  Widget _folderItemCard(FolderDetail f) {
    return InkWell(
      onTap: () => setState(() {
        selectedFolderName = f.name;
        selectedFolderId = f.id;
        currentPage = 1;
      }),
      borderRadius: BorderRadius.circular(20),
      child: FolderCard(
        f.name,
        "${f.exams.length} ${S.of(context).files}",
        isActive: selectedFolderName == f.name,
        onDelete: () {
          _confirmDelete(context, "حذف المجلد", () => _deleteFolder(f.id));
        },
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
        bottom: false,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            const Spacer(),
            Text(
              courseName.isEmpty ? S.of(context).subject_details : courseName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false)
      Navigator.pop(context);
    if (index == 0)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    else if (index == 1)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ExamManagementPage()),
      );
    else if (index == 2)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Material1()),
      );
    else if (index == 3)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GradingPage()),
      );
    else if (index == 5)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      );
  }

  void _showAddFolderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(S.of(context).add_new_folder),
        content: TextField(
          controller: _folderController,
          decoration: InputDecoration(
            hintText: S.of(context).new_folder_name,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal(context),
            ),
            onPressed: _handleCreateFolder,
            child: Text(
              S.of(context).save,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= جدول الاختبارات ================= */
class ExamTableSection extends StatelessWidget {
  final String folderName;
  final List<ExamDetail> exams;
  final int currentPage;
  final int totalPages;
  final int totalFiles;
  final bool isMobile;
  final Function(int) onPageChanged;
  final Function(int) onDelete;
  final Function(int) onEdit;
  final VoidCallback onRefresh; // 👈 1. أضيفي هذا السطر هنا
  final int courseId;
  final String courseName;
  final String specialization;
  final String levelName;
  final int? folderId;

  const ExamTableSection({
    required this.folderName,
    required this.exams,
    required this.currentPage,
    required this.totalPages,
    required this.totalFiles,
    required this.isMobile,
    required this.onPageChanged,
    required this.onDelete,
    required this.onEdit,
    required this.onRefresh, // 👈 2. وأضيفي هذا السطر هنا
    required this.courseId,
    required this.courseName,
    required this.specialization,
    required this.levelName,
    required this.folderId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${S.of(context).exams_list} $folderName",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showExamTypeDialog(context),
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: Text(
                  S.of(context).create_exam,
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (exams.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text("لا توجد اختبارات حالياً"),
              ),
            )
          else
            _buildExpandedTable(context), // 🌟 أجبرناه يعرض الجدول للجميع
        ],
      ),
    );
  }

  Widget _buildExpandedTable(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FB)),
              columnSpacing: 20,
              columns: [
                DataColumn(label: Text(S.of(context).exam_name)), // 1
                DataColumn(label: Text(S.of(context).exam_date)), // 2
                DataColumn(
                  label: Text(S.of(context).exam_type_label),
                ), // 3 - نوع الاختبار
                DataColumn(label: Text(S.of(context).status)), // 4
                DataColumn(label: Text(S.of(context).actions)), // 5
              ],
              rows: exams.map((exam) {
                final color = exam.status == "Published"
                    ? AppColors.primaryTeal(context)
                    : Colors.grey;

                return DataRow(
                  cells: [
                    // 1. خلية اسم الاختبار
                    DataCell(Text(exam.title)),

                    // 2. خلية التاريخ
                    DataCell(Text(exam.date)),

                    // 3. خلية نوع الاختبار
                    DataCell(
                      Text(
                        exam.examType.toLowerCase() == 'ai'
                            ? S.of(context).exam_type_ai
                            : S.of(context).exam_type_manual,
                        style: TextStyle(
                          color: exam.examType.toLowerCase() == 'ai'
                              ? Colors.deepPurple
                              : Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    // 4. خلية الحالة
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          exam.status,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                    // 5. خلية الإجراءات
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // أيقونة العين: قابلة للضغط إذا كان مكتمل، وشفافة كلياً (كحاجز مساحة) إذا كان مسودة
                          exam.status.toLowerCase() == 'published'
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const FinalExamPage(),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.visibility_outlined,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                )
                              : const Icon(
                                  Icons.visibility_outlined,
                                  size: 18,
                                  color: Colors
                                      .transparent, // السحر هنا: أيقونة شفافة تحجز نفس المساحة
                                ),

                          const SizedBox(width: 12), // المسافة ثابتة دائماً
                          // أيقونة القلم: ظاهرة دائماً
                          // أيقونة القلم الذكية
                          GestureDetector(
                            onTap: () =>
                                _onEditTapped(context, exam.id, exam.status),
                            child: const Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: Colors.blue,
                            ),
                          ),

                          const SizedBox(width: 12),

                          // أيقونة الحذف
                          GestureDetector(
                            onTap: () => onDelete(exam.id),
                            child: const Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // 🌟 الدالة الذكية الجديدة للتحقق قبل التعديل
  Future<void> _onEditTapped(
    BuildContext context,
    int examId,
    String status,
  ) async {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    String cleanStatus = status.trim().toLowerCase();

    // 1. إذا كان الاختبار "مسودة" (يدخل مباشرة ويستدعي دالة onEdit الموجودة في البارامترات)
    if (cleanStatus == 'draft' || cleanStatus == 'مسودة') {
      onEdit(examId);
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
        // 🚨 تأكدي أن هذا الرابط يطابق البورت حق السيرفر عندك (مثلاً 8000)
        var url = Uri.parse(
          'http://localhost:8000/api/exams/check-answers/$examId',
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
          // مافي إجابات -> يدخل لشاشة التعديل مباشرة
          onEdit(examId);
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
  // void _showEditExamDialog(BuildContext context, ExamDetail exam) {
  //   TextEditingController titleController = TextEditingController(
  //     text: exam.title,
  //   );
  //   String currentStatus = exam.status;

  //   showDialog(
  //     context: context,
  //     builder: (context) => StatefulBuilder(
  //       builder: (context, setDialogState) => AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         title: const Text("تعديل الاختبار"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: titleController,
  //               decoration: const InputDecoration(labelText: "اسم الاختبار"),
  //             ),
  //             const SizedBox(height: 15),
  //             DropdownButton<String>(
  //               value: currentStatus,
  //               isExpanded: true,
  //               items: ["Published", "Draft"]
  //                   .map((s) => DropdownMenuItem(value: s, child: Text(s)))
  //                   .toList(),
  //               onChanged: (val) => setDialogState(() => currentStatus = val!),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text("إلغاء"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               onEdit(exam.id, titleController.text, currentStatus);
  //               Navigator.pop(context);
  //             },
  //             child: const Text("حفظ"),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildMobileList(BuildContext context) {
  //   return Column(
  //     children: exams
  //         .map(
  //           (exam) => Card(
  //             elevation: 0,
  //             color: const Color(0xFFF8F9FB),
  //             margin: const EdgeInsets.only(bottom: 8),
  //             child: ListTile(
  //               title: Text(
  //                 exam.title,
  //                 style: const TextStyle(
  //                   fontSize: 13,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               subtitle: Text(
  //                 "${exam.date} • ${exam.studentCount} ${S.of(context).student}",
  //               ),
  //               trailing: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   // زر التعديل (الذكي) للموبايل
  //                   IconButton(
  //                     icon: const Icon(
  //                       Icons.edit_outlined,
  //                       color: Colors.blue,
  //                       size: 20,
  //                     ),
  //                     onPressed: () =>
  //                         _onEditTapped(context, exam.id, exam.status),
  //                   ),
  //                   // زر الحذف
  //                   IconButton(
  //                     icon: const Icon(
  //                       Icons.delete,
  //                       color: Colors.red,
  //                       size: 20,
  //                     ),
  //                     onPressed: () => onDelete(exam.id),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         )
  //         .toList(),
  //   );
  // }

  void _showExamTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Text(
                S.of(context).choose_exam_type,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateElectronicExamPage(
                          examContext: ExamContext(
                            courseId: courseId,
                            courseName: courseName,
                            specialization: specialization,
                            levelName: levelName,
                            folderId: folderId,
                            folderName: folderName,
                          ),
                        ),
                      ),
                    ).then(
                      (_) => onRefresh(),
                    ); // 👈 استخدمي onRefresh بدلاً من fetchCourseDetails// 👈 هذا السطر السحري لتحديث الصفحة تلقائياً
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal(context),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    S.of(context).create_manual_exam,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAIExamScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F3F4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    S.of(context).create_ai_exam,
                    style: TextStyle(
                      color: AppColors.primaryTeal(context),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ================= المجلدات ================= */
class FolderCard extends StatelessWidget {
  final String title;
  final String info;
  final bool isActive;
  final VoidCallback onDelete;
  const FolderCard(
    this.title,
    this.info, {
    this.isActive = false,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isActive
            ? Border.all(color: AppColors.primaryTeal(context), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.folder, color: Color(0xFFFFD180), size: 35),
              PopupMenuButton<String>(
                onSelected: (val) {
                  if (val == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      "حذف المجلد",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
                child: const Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(info, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}

class AddFolderCard extends StatelessWidget {
  const AddFolderCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12, style: BorderStyle.solid),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.create_new_folder_outlined,
                color: Colors.grey,
                size: 35,
              ),
              Icon(Icons.add, color: Colors.grey, size: 18),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            S.of(context).new_folder,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            S.of(context).add_new_folder,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../core/colors.dart';
// import 'teacher_dashboard.dart';
// import 'grading.dart' hide HeaderWidget;
// import 'teacher_matearial.dart' hide HeaderWidget;
// import 'exam_page.dart' hide HeaderWidget;
// import '../generated/l10n.dart';
// import 'review_exam_screen.dart' hide HeaderWidget;
// import 'teacer_setting.dart';
// import 'ExamManagementPage.dart';
// import 'create_ai_exam_screen.dart';
// import 'create_electronic_exam.dart';
// import 'package:grade/models/material_detail.dart';

// class SubjectDetailsPage extends StatefulWidget {
//   final int courseId;
//   const SubjectDetailsPage({super.key, required this.courseId});

//   @override
//   State<SubjectDetailsPage> createState() => _SubjectDetailsPageState();
// }

// class _SubjectDetailsPageState extends State<SubjectDetailsPage> {
//   String courseName = "";
//   String selectedFolderName = "";
//   int? selectedFolderId;
//   int currentPage = 1;
//   final int _selectedIndex = 2;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final TextEditingController _folderController = TextEditingController();

//   List<FolderDetail> folders = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchCourseDetails();
//   }

//   Future<void> fetchCourseDetails() async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//           'http://localhost:8000/teacher-materials/detail/${widget.courseId}/1',
//         ),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(utf8.decode(response.bodyBytes));
//         setState(() {
//           courseName = data['course_name'] ?? "";

//           folders = (data['folders'] as List)
//               .map((f) => FolderDetail.fromJson(f))
//               .toList();

//           if (folders.isNotEmpty) {
//             var current = folders.any((f) => f.name == selectedFolderName)
//                 ? folders.firstWhere((f) => f.name == selectedFolderName)
//                 : folders.first;

//             selectedFolderName = current.name;
//             selectedFolderId = current.id;
//           } else {
//             selectedFolderName = "";
//             selectedFolderId = null;
//           }
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       debugPrint("Error: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   // --- نافذة تأكيد الحذف ---
//   void _confirmDelete(
//     BuildContext context,
//     String title,
//     VoidCallback onConfirm,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: [
//             const Icon(Icons.warning_amber_rounded, color: Colors.red),
//             const SizedBox(width: 10),
//             Text(title),
//           ],
//         ),
//         content: const Text(
//           "هل أنت متأكد؟ لا يمكن استعادة البيانات بعد الحذف.",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("إلغاء"),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () {
//               onConfirm();
//               Navigator.pop(context);
//             },
//             child: const Text(
//               "تأكيد الحذف",
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _deleteFolder(int folderId) async {
//     try {
//       final response = await http.delete(
//         Uri.parse('http://localhost:8000/teacher-materials/folder/$folderId'),
//       );
//       if (response.statusCode == 200) {
//         selectedFolderName = "";
//         fetchCourseDetails();
//         bool isArabic = Directionality.of(context) == TextDirection.rtl;
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   const Icon(Icons.check_circle, color: Colors.white),
//                   const SizedBox(width: 10),
//                   Text(
//                     isArabic
//                         ? 'تم حذف المجلد بنجاح'
//                         : 'Folder deleted successfully',
//                   ),
//                 ],
//               ),
//               backgroundColor: Colors.red.shade600,
//               duration: const Duration(seconds: 3),
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       debugPrint("Delete Folder Error: $e");
//     }
//   }

//   Future<void> _deleteExam(int examId) async {
//     try {
//       final response = await http.delete(
//         Uri.parse('http://localhost:8000/teacher-materials/exam/$examId'),
//       );
//       if (response.statusCode == 200) {
//         fetchCourseDetails();
//         bool isArabic = Directionality.of(context) == TextDirection.rtl;
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   const Icon(Icons.check_circle, color: Colors.white),
//                   const SizedBox(width: 10),
//                   Text(
//                     isArabic
//                         ? 'تم حذف الاختبار بنجاح'
//                         : 'Exam deleted successfully',
//                   ),
//                 ],
//               ),
//               backgroundColor: Colors.red.shade600, // لون أحمر يدل على الحذف
//               duration: const Duration(seconds: 3),
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       debugPrint("Delete Exam Error: $e");
//     }
//   }

//   Future<void> _updateExam(int examId, String title, String status) async {
//     try {
//       final response = await http.put(
//         Uri.parse(
//           'http://localhost:8000/teacher-materials/exam/$examId?title=${Uri.encodeComponent(title)}&status=$status',
//         ),
//       );
//       if (response.statusCode == 200) {
//         fetchCourseDetails();
//       }
//     } catch (e) {
//       debugPrint("Update Error: $e");
//     }
//   }

//   Future<void> _handleCreateFolder() async {
//     if (_folderController.text.trim().isNotEmpty) {
//       try {
//         final response = await http.post(
//           Uri.parse(
//             'http://localhost:8000/teacher-materials/add-folder/${widget.courseId}/1?name=${Uri.encodeComponent(_folderController.text.trim())}',
//           ),
//         );
//         if (response.statusCode == 200) {
//           _folderController.clear();
//           if (mounted) Navigator.pop(context);
//           fetchCourseDetails();
//         }
//       } catch (e) {
//         debugPrint("Error: $e");
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _folderController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<ExamDetail> currentExams = [];
//     if (folders.isNotEmpty) {
//       final folder = folders.firstWhere(
//         (f) => f.name == selectedFolderName,
//         orElse: () => folders.first,
//       );
//       currentExams = folder.exams;
//     }

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         bool isMobile = constraints.maxWidth < 800;
//         bool isTablet =
//             constraints.maxWidth >= 800 && constraints.maxWidth < 1150;

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
//               if (!isMobile)
//                 CustSidebar(
//                   selectedIndex: _selectedIndex,
//                   isCompact: isTablet,
//                   onItemSelected: _handleNavigation,
//                 ),
//               Expanded(
//                 child: isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : Column(
//                         children: [
//                           if (isMobile) _buildMobileAppBar(),
//                           Expanded(
//                             child: SingleChildScrollView(
//                               padding: EdgeInsets.all(isMobile ? 16 : 24),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 15),
//                                   _buildBreadcrumbCard(selectedFolderName),
//                                   const SizedBox(height: 25),
//                                   _buildResponsiveFolders(isMobile),
//                                   const SizedBox(height: 25),
//                                   ExamTableSection(
//                                     folderName: selectedFolderName,
//                                     exams: currentExams,
//                                     currentPage: currentPage,
//                                     totalPages: 1,
//                                     totalFiles: currentExams.length,
//                                     isMobile: isMobile,
//                                     onPageChanged: (page) =>
//                                         setState(() => currentPage = page),
//                                     onDelete: (examId) {
//                                       _confirmDelete(
//                                         context,
//                                         "حذف الاختبار",
//                                         () => _deleteExam(examId),
//                                       );
//                                     },
//                                     onEdit: (examId) {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               CreateElectronicExamPage(
//                                                 examIdToEdit: examId,
//                                               ),
//                                         ),
//                                       ).then((_) => fetchCourseDetails());
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildBreadcrumbCard(String currentFolder) {
//     bool isRtl = Directionality.of(context) == TextDirection.rtl;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8),
//         ],
//       ),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const Material1()),
//             ),
//             child: Text(
//               S.of(context).materials,
//               style: const TextStyle(
//                 color: Colors.grey,
//                 fontSize: 13,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Icon(
//               isRtl ? Icons.chevron_left : Icons.chevron_right,
//               color: Colors.grey,
//               size: 16,
//             ),
//           ),
//           Text(
//             courseName,
//             style: const TextStyle(color: Colors.grey, fontSize: 13),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Icon(
//               isRtl ? Icons.chevron_left : Icons.chevron_right,
//               color: Colors.grey,
//               size: 16,
//             ),
//           ),
//           Text(
//             currentFolder,
//             style: TextStyle(
//               color: AppColors.primaryTeal(context),
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildResponsiveFolders(bool isMobile) {
//     List<Widget> folderWidgets = folders.map((f) {
//       return _folderItemCard(f);
//     }).toList();

//     folderWidgets.add(
//       InkWell(
//         onTap: _showAddFolderDialog,
//         borderRadius: BorderRadius.circular(20),
//         child: const AddFolderCard(),
//       ),
//     );

//     if (isMobile) {
//       return SizedBox(
//         height: 140,
//         child: ListView.separated(
//           scrollDirection: Axis.horizontal,
//           itemCount: folderWidgets.length,
//           separatorBuilder: (_, __) => const SizedBox(width: 12),
//           itemBuilder: (context, index) =>
//               SizedBox(width: 170, child: folderWidgets[index]),
//         ),
//       );
//     } else {
//       return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: folderWidgets
//               .map(
//                 (fw) => Container(
//                   width: 240,
//                   margin: const EdgeInsetsDirectional.only(end: 15),
//                   child: fw,
//                 ),
//               )
//               .toList(),
//         ),
//       );
//     }
//   }

//   Widget _folderItemCard(FolderDetail f) {
//     return InkWell(
//       onTap: () => setState(() {
//         selectedFolderName = f.name;
//         selectedFolderId = f.id;
//         currentPage = 1;
//       }),
//       borderRadius: BorderRadius.circular(20),
//       child: FolderCard(
//         f.name,
//         "${f.exams.length} ${S.of(context).files}",
//         isActive: selectedFolderName == f.name,
//         onDelete: () {
//           _confirmDelete(context, "حذف المجلد", () => _deleteFolder(f.id));
//         },
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
//             Text(
//               courseName.isEmpty ? S.of(context).subject_details : courseName,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleNavigation(int index) {
//     if (_scaffoldKey.currentState?.isDrawerOpen ?? false)
//       Navigator.pop(context);
//     if (index == 0)
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const DashboardScreen()),
//       );
//     else if (index == 1)
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const ExamManagementPage()),
//       );
//     else if (index == 2)
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const Material1()),
//       );
//     else if (index == 3)
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const GradingPage()),
//       );
//     else if (index == 5)
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const SettingsScreen()),
//       );
//   }

//   void _showAddFolderDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Text(S.of(context).add_new_folder),
//         content: TextField(
//           controller: _folderController,
//           decoration: InputDecoration(
//             hintText: S.of(context).new_folder_name,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(S.of(context).cancel),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryTeal(context),
//             ),
//             onPressed: _handleCreateFolder,
//             child: Text(
//               S.of(context).save,
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /* ================= جدول الاختبارات ================= */
// class ExamTableSection extends StatelessWidget {
//   final String folderName;
//   final List<ExamDetail> exams;
//   final int currentPage;
//   final int totalPages;
//   final int totalFiles;
//   final bool isMobile;
//   final Function(int) onPageChanged;
//   final Function(int) onDelete;
//   final Function(int) onEdit;

//   const ExamTableSection({
//     required this.folderName,
//     required this.exams,
//     required this.currentPage,
//     required this.totalPages,
//     required this.totalFiles,
//     required this.isMobile,
//     required this.onPageChanged,
//     required this.onDelete,
//     required this.onEdit,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(isMobile ? 16 : 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.02),
//             blurRadius: 10,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   "${S.of(context).exams_list} $folderName",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: isMobile ? 14 : 16,
//                   ),
//                 ),
//               ),
//               ElevatedButton.icon(
//                 onPressed: () => _showExamTypeDialog(context),
//                 icon: const Icon(Icons.add, size: 18, color: Colors.white),
//                 label: Text(
//                   S.of(context).create_exam,
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primaryTeal(context),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           if (exams.isEmpty)
//             const Center(
//               child: Padding(
//                 padding: EdgeInsets.all(40),
//                 child: Text("لا توجد اختبارات حالياً"),
//               ),
//             )
//           else
//             isMobile ? _buildMobileList(context) : _buildExpandedTable(context),
//         ],
//       ),
//     );
//   }

//   Widget _buildExpandedTable(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: DataTable(
//         headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FB)),
//         columnSpacing: 20,
//         columns: [
//           DataColumn(label: Text(S.of(context).exam_name)), // 1
//           DataColumn(label: Text(S.of(context).exam_date)), // 2
//           DataColumn(
//             label: Text(S.of(context).exam_type_label),
//           ), // 3 - نوع الاختبار
//           DataColumn(label: Text(S.of(context).status)), // 4
//           DataColumn(label: Text(S.of(context).actions)), // 5
//         ],
//         rows: exams.map((exam) {
//           final color = exam.status == "Published"
//               ? AppColors.primaryTeal(context)
//               : Colors.grey;

//           return DataRow(
//             cells: [
//               DataCell(Text(exam.title)),
//               DataCell(Text(exam.date)),
//               DataCell(
//                 Text(
//                   exam.examType.toLowerCase() == 'ai'
//                       ? S.of(context).exam_type_ai
//                       : S.of(context).exam_type_manual,
//                   style: TextStyle(
//                     color: exam.examType.toLowerCase() == 'ai'
//                         ? Colors.deepPurple
//                         : Colors.blueGrey,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//               DataCell(
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: color.withValues(alpha: 0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     exam.status,
//                     style: TextStyle(
//                       color: color,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ),
//               DataCell(
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (exam.status.toLowerCase() == 'published') ...[
//                       _iconBtn(
//                         Icons.visibility_outlined,
//                         Colors.grey.shade700,
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const FinalExamPage(),
//                             ),
//                           );
//                         },
//                       ),
//                       const SizedBox(width: 5),
//                     ],
//                     _iconBtn(
//                       Icons.edit_outlined,
//                       Colors.blue,
//                       onTap: () => onEdit(exam.id),
//                     ),
//                     const SizedBox(width: 5),
//                     _iconBtn(
//                       Icons.delete_outline,
//                       Colors.redAccent,
//                       onTap: () => onDelete(exam.id),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildMobileList(BuildContext context) {
//     return Column(
//       children: exams
//           .map(
//             (exam) => Card(
//               elevation: 0,
//               color: const Color(0xFFF8F9FB),
//               margin: const EdgeInsets.only(bottom: 8),
//               child: ListTile(
//                 title: Text(
//                   exam.title,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 subtitle: Text(
//                   "${exam.date} • ${exam.studentCount} ${S.of(context).student}",
//                 ),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () => onDelete(exam.id),
//                 ),
//               ),
//             ),
//           )
//           .toList(),
//     );
//   }

//   void _showExamTypeDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
//         child: Container(
//           width: 360,
//           padding: const EdgeInsets.all(25),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Align(
//                 alignment: AlignmentDirectional.topStart,
//                 child: IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//               Text(
//                 S.of(context).choose_exam_type,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 25),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const CreateElectronicExamPage(),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryTeal(context),
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                   ),
//                   child: Text(
//                     S.of(context).create_manual_exam,
//                     style: const TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const CreateAIExamScreen(),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFF1F3F4),
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                   ),
//                   child: Text(
//                     S.of(context).create_ai_exam,
//                     style: TextStyle(
//                       color: AppColors.primaryTeal(context),
//                       fontSize: 15,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _iconBtn(IconData icon, Color color, {VoidCallback? onTap}) => InkWell(
//     onTap: onTap,
//     borderRadius: BorderRadius.circular(8),
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

// /* ================= المجلدات ================= */
// class FolderCard extends StatelessWidget {
//   final String title;
//   final String info;
//   final bool isActive;
//   final VoidCallback onDelete;
//   const FolderCard(
//     this.title,
//     this.info, {
//     this.isActive = false,
//     required this.onDelete,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: isActive
//             ? Border.all(color: AppColors.primaryTeal(context), width: 2)
//             : null,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.03),
//             blurRadius: 10,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Icon(Icons.folder, color: Color(0xFFFFD180), size: 35),
//               PopupMenuButton<String>(
//                 onSelected: (val) {
//                   if (val == 'delete') onDelete();
//                 },
//                 itemBuilder: (context) => [
//                   const PopupMenuItem(
//                     value: 'delete',
//                     child: Text(
//                       "حذف المجلد",
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ),
//                 ],
//                 child: const Icon(
//                   Icons.more_vert,
//                   color: Colors.grey,
//                   size: 18,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           Text(
//             title,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 4),
//           Text(info, style: const TextStyle(color: Colors.grey, fontSize: 11)),
//         ],
//       ),
//     );
//   }
// }

// class AddFolderCard extends StatelessWidget {
//   const AddFolderCard({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.5),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.black12, style: BorderStyle.solid),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Icon(
//                 Icons.create_new_folder_outlined,
//                 color: Colors.grey,
//                 size: 35,
//               ),
//               Icon(Icons.add, color: Colors.grey, size: 18),
//             ],
//           ),
//           const SizedBox(height: 15),
//           Text(
//             S.of(context).new_folder,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             S.of(context).add_new_folder,
//             style: const TextStyle(color: Colors.grey, fontSize: 11),
//           ),
//         ],
//       ),
//     );
//   }
// }
