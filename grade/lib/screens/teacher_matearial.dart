import 'package:flutter/material.dart';
import 'dart:convert'; // للتعامل مع JSON
import 'package:http/http.dart' as http; // للاتصال بالسيرفر
import 'teacher_dashboard.dart';
import '../core/colors.dart';
import 'material_detail.dart';
import 'grading.dart';
import 'exam_page.dart';
import '../generated/l10n.dart';
import 'review_exam_screen.dart';
import 'teacer_setting.dart';
import 'ExamManagementPage.dart';
import 'teacher_profile_settings_page.dart';
import 'package:grade/models/teacher_matearial.dart';

class Material1 extends StatefulWidget {
  const Material1({super.key});

  @override
  State<Material1> createState() => _Material1State();
}

class _Material1State extends State<Material1> {
  int _selectedIndex = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // كائن لتخزين كافة البيانات القادمة من الداتابيس
  TeacherMaterialsWrapper? fullData;

  // دالة لتحديث البيانات بالكامل (المواد + الإحصائيات العلوية)
  void updateFullData(TeacherMaterialsWrapper data) {
    setState(() {
      fullData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              if (!isMobile) ...[
                CustSidebar(
                  selectedIndex: _selectedIndex,
                  isCompact: isTablet,
                  onItemSelected: _handleNavigation,
                ),
              ],
              Expanded(
                child: Column(
                  children: [
                    if (isMobile) ...[_buildMobileAppBar(context)],
                    Expanded(
                      child: MainContent(
                        isMobile: isMobile,
                        isTablet: isTablet,
                        fullData: fullData,
                        onDataLoaded: updateFullData,
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

  Widget _buildMobileAppBar(BuildContext context) {
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
              S.of(context).materials,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.pop(context);
    }

    Widget? page;
    if (index == 0) {
      page = const DashboardScreen();
    }
    if (index == 1) {
      page = const ExamManagementPage();
    }
    if (index == 3) {
      page = const GradingPage();
    }
    if (index == 4) {
      page = const ReviewExamPage();
    }
    if (index == 5) {
      page = const SettingsScreen();
    }
    if (page != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => page!),
        (route) => false,
      );
    }
  }
}

class MainContent extends StatelessWidget {
  final bool isMobile, isTablet;
  final TeacherMaterialsWrapper? fullData;
  final Function(TeacherMaterialsWrapper) onDataLoaded;

  const MainContent({
    super.key,
    required this.isMobile,
    required this.isTablet,
    required this.fullData,
    required this.onDataLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderWidget(),
          const SizedBox(height: 25),
          // تمرير البيانات للـ TopStatsGrid باستخدام كائن الداتابيس الحقيقي
          TopStatsGrid(
            isMobile: isMobile,
            isTablet: isTablet,
            data: TeacherDashboard(
              totalStudents: fullData?.totalStudents ?? 0,
              correctedPapers: fullData?.totalCorrectedPapers ?? 0,
              createdExams: fullData?.totalExams ?? 0,
              drafts: fullData?.totalDrafts ?? 0,
            ),
          ),
          const SizedBox(height: 35),
          SubjectsGrid(onDataLoaded: onDataLoaded),
        ],
      ),
    );
  }
}

// --- الهيدر (بدون تغيير في التصميم) ---
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).materials,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                S.of(context).manage_your_materials_and_exams,
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileSettingsPage(),
                    ),
                  );
                },
                child: _iconButton(context, Icons.person_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(BuildContext context, IconData icon) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: AppColors.secondaryTeal(context),
      shape: BoxShape.circle,
    ),
    child: Icon(icon, color: AppColors.primaryTeal(context)),
  );
}

// --- الإحصائيات العلوية المرتبطة بالداتابيس ---
class TopStatsGrid extends StatelessWidget {
  final bool isMobile, isTablet;
  final TeacherDashboard data;

  const TopStatsGrid({
    super.key,
    required this.isMobile,
    required this.isTablet,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile || isTablet) {
      double cardWidth = 220;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            _statCardFixed(
              context,
              S.of(context).students,
              data.totalStudents.toString(),
              AppColors.accentYellow(context),
              Icons.people,
              cardWidth,
            ),
            _statCardFixed(
              context,
              S.of(context).corrected_papers,
              data.correctedPapers.toString(),
              AppColors.primaryTeal(context),
              Icons.description,
              cardWidth,
            ),
            _statCardFixed(
              context,
              S.of(context).created_exams,
              data.createdExams.toString(),
              AppColors.primaryTeal(context),
              Icons.create,
              cardWidth,
            ),
            _statCardFixed(
              context,
              S.of(context).drafts,
              data.drafts.toString(),
              AppColors.primaryTeal(context),
              Icons.edit_note,
              cardWidth,
            ),
          ],
        ),
      );
    }
    return Row(
      children: [
        _statCardExpanded(
          context,
          S.of(context).students,
          data.totalStudents.toString(),
          AppColors.accentYellow(context),
          Icons.people,
        ),
        _statCardExpanded(
          context,
          S.of(context).corrected_papers,
          data.correctedPapers.toString(),
          AppColors.primaryTeal(context),
          Icons.description,
        ),
        _statCardExpanded(
          context,
          S.of(context).created_exams,
          data.createdExams.toString(),
          AppColors.primaryTeal(context),
          Icons.create,
        ),
        _statCardExpanded(
          context,
          S.of(context).drafts,
          data.drafts.toString(),
          AppColors.primaryTeal(context),
          Icons.edit_note,
        ),
      ],
    );
  }

  Widget _statCardFixed(context, t, v, c, i, w) => Container(
    width: w,
    margin: const EdgeInsets.only(left: 16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: c,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              v,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              t,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        Icon(i, color: Colors.white54, size: 40),
      ],
    ),
  );
  Widget _statCardExpanded(context, t, v, c, i) => Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                v,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                t,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          Icon(i, color: Colors.white54, size: 40),
        ],
      ),
    ),
  );
}

// --- شبكة المواد الديناميكية ---
class SubjectsGrid extends StatefulWidget {
  final Function(TeacherMaterialsWrapper) onDataLoaded;
  const SubjectsGrid({super.key, required this.onDataLoaded});

  @override
  State<SubjectsGrid> createState() => _SubjectsGridState();
}

class _SubjectsGridState extends State<SubjectsGrid> {
  int? _selectedLevelId;
  bool _isOther = false;
  List<Map<String, dynamic>> _levels = [];
  TextEditingController _newLevelController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _studentsController = TextEditingController();

  List<CourseMaterial> coursesList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMaterials();
  }

  Future<void> fetchMaterials() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/teacher-materials/1'),
      );
      if (response.statusCode == 200) {
        var decodedData = json.decode(utf8.decode(response.bodyBytes));
        var wrapper = TeacherMaterialsWrapper.fromJson(decodedData);

        setState(() {
          coursesList = wrapper.courses;
          isLoading = false;
        });
        widget.onDataLoaded(wrapper); // تمرير كافة البيانات للداتابيس
      }
    } catch (e) {
      debugPrint("Error fetching materials: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        bool isWebScreen = width >= 1150;
        bool isTabletScreen = width >= 800 && width < 1150;

        int crossAxisCount = (isWebScreen || isTabletScreen) ? 3 : 2;
        double cardWidth = (width - (crossAxisCount - 1) * 20) / crossAxisCount;

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            ...coursesList.map((course) {
              return GestureDetector(
                // 🔥 التعديل هنا: نمرر الـ id الخاص بكل مادة
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SubjectDetailsPage(courseId: course.id),
                  ),
                ),
                child: _subjectCard(
                  context,
                  course.id, // 👈 تمرير الـ ID هنا ضروري
                  cardWidth,
                  course.name,
                  course.dept,
                  course.exams.toString(),
                  course.folders.toString(),
                  isWebScreen,
                ),
              );
            }),
            _addSubjectCard(context, cardWidth, isWebScreen),
          ],
        );
      },
    );
  }

  Widget _subjectCard(
    BuildContext context,
    int courseId, // 👈 استقبلنا الـ ID
    double width,
    String title,
    String dept,
    String exams,
    String folders,
    bool isWeb,
  ) {
    return Container(
      width: width,
      padding: EdgeInsets.all(isWeb ? 22 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isWeb ? 28 : 20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary(context).withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.book_outlined,
                color: AppColors.primaryTeal(context),
                size: isWeb ? 30 : 22,
              ),
              Row(
                // 👈 وضعنا التخصص وزر الحذف في صف واحد
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 10 : 8,
                      vertical: isWeb ? 6 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryTeal(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      dept,
                      style: TextStyle(
                        fontSize: isWeb ? 11 : 9,
                        color: AppColors.primaryTeal(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 👈 أيقونة الحذف الجديدة
                  GestureDetector(
                    onTap: () => _confirmDeleteCourse(context, courseId, title),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: isWeb ? 25 : 15),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isWeb ? 17 : 13,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: isWeb ? 35 : 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoTile(context, S.of(context).exams, exams, isWeb),
              _infoTile(context, "عدد المجلدات", folders, isWeb),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(
    BuildContext context,
    String label,
    String value,
    bool isWeb,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary(context),
            fontSize: isWeb ? 13 : 10,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isWeb ? 18 : 14,
            color: AppColors.textPrimary(context),
          ),
        ),
      ],
    );
  }

  Widget _addSubjectCard(BuildContext context, double width, bool isWeb) {
    return InkWell(
      onTap: () => _showAddSubjectDialog(context),
      borderRadius: BorderRadius.circular(isWeb ? 28 : 20),
      child: Container(
        width: width,
        height: isWeb ? 220 : 130,
        decoration: BoxDecoration(
          color: AppColors.secondaryTeal(context).withOpacity(0.4),
          borderRadius: BorderRadius.circular(isWeb ? 28 : 20),
          border: Border.all(
            color: AppColors.primaryTeal(context).withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: AppColors.primaryTeal(context),
              size: isWeb ? 50 : 35,
            ),
            SizedBox(height: isWeb ? 12 : 8),
            Text(
              S.of(context).add_subject,
              style: TextStyle(
                color: AppColors.primaryTeal(context),
                fontWeight: FontWeight.bold,
                fontSize: isWeb ? 15 : 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. دالة جلب المستويات (استدعيها عند فتح الـ Dialog)
  Future<void> _fetchLevels() async {
    // final response = await http.get(Uri.parse('http://127.0.0.1:8000/teacher-materials/levels'));
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/teacher-materials/academic-levels'),
    );
    if (response.statusCode == 200) {
      setState(() {
        _levels = List<Map<String, dynamic>>.from(
          json.decode(utf8.decode(response.bodyBytes)),
        );
      });
    }
  }

  void _showAddSubjectDialog(BuildContext parentContext) async {
    await _fetchLevels(); // جلب البيانات قبل فتح النافذة

    // نتحقق من أن الشاشة ما زالت موجودة قبل فتح النافذة
    if (!parentContext.mounted) return;

    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        // 👈 سمينا هذا dialogContext عشان ما يتلخبط
        return StatefulBuilder(
          builder: (statefulContext, setDialogState) {
            // 👈 وسمينا هذا statefulContext
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(parentContext).add_new_subject,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildField(
                      parentContext,
                      S.of(parentContext).subject_name,
                      _nameController,
                    ),
                    _buildField(
                      parentContext,
                      S
                          .of(parentContext)
                          .dept_hint_optional, // 👈 استدعاء النص المترجم بالكامل
                      _deptController,
                    ),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        hintText: "اختر المستوى الدراسي",
                        filled: true,
                      ),
                      items: [
                        ..._levels.map(
                          (l) => DropdownMenuItem(
                            value: l['level_id'] as int,
                            child: Text(l['level_name'] as String),
                          ),
                        ),
                        const DropdownMenuItem(
                          value: 0,
                          child: Text("أخرى..."),
                        ),
                      ],
                      onChanged: (value) => setDialogState(() {
                        _selectedLevelId = value;
                        _isOther = (value == 0);
                      }),
                    ),
                    if (_isOther)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextField(
                          controller: _newLevelController,
                          decoration: const InputDecoration(
                            hintText: "أدخل اسم المستوى الجديد",
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final url =
                            'http://127.0.0.1:8000/teacher-materials/add-course/1';

                        final response = await http.post(
                          Uri.parse(url),
                          headers: {"Content-Type": "application/json"},
                          body: json.encode({
                            "name": _nameController.text,
                            "dept_name": _deptController.text.trim().isEmpty
                                ? "عام"
                                : _deptController.text.trim(),
                            "level_id": _selectedLevelId,
                            "new_level_name": _isOther
                                ? _newLevelController.text
                                : null,
                          }),
                        );

                        if (response.statusCode == 200) {
                          // 1. نغلق النافذة المنبثقة أولاً
                          if (dialogContext.mounted) {
                            Navigator.pop(dialogContext);
                          }

                          // 2. نحدث البيانات في الشاشة الخلفية
                          fetchMaterials();

                          // 3. نظهر الرسالة باستخدام سياق الشاشة الرئيسية الآمن!
                          if (parentContext.mounted) {
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              const SnackBar(
                                content: Text("تمت الإضافة بنجاح ✅"),
                              ),
                            );
                          }
                        } else {
                          debugPrint("خطأ: ${response.body}");
                        }
                      },
                      child: Text(S.of(parentContext).save),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _deleteCourse(int courseId) async {
    try {
      final response = await http.delete(
        Uri.parse(
          'http://localhost:8000/teacher-materials/course/$courseId/1',
        ), // 1 هو teacher_id المؤقت
      );

      if (response.statusCode == 200) {
        fetchMaterials(); // تحديث الشاشة بعد الحذف
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم حذف المادة وكل محتوياتها بنجاح"),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Delete error: $e");
    }
  }

  void _confirmDeleteCourse(
    BuildContext context,
    int courseId,
    String courseName,
  ) {
    bool isArabic = Directionality.of(context) == TextDirection.rtl;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 28,
            ),
            const SizedBox(width: 10),
            Text(
              isArabic ? "تأكيد حذف المادة" : "Confirm Course Deletion",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          isArabic
              ? "هل أنت متأكد من حذف مادة ($courseName)؟\nسيتم حذف كافة المجلدات والاختبارات التابعة لها بشكل نهائي ولا يمكن التراجع عن هذا الإجراء."
              : "Are you sure you want to delete ($courseName)?\nAll associated folders and exams will be permanently deleted.",
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isArabic ? "إلغاء" : "Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteCourse(courseId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              isArabic ? "نعم، احذف" : "Yes, Delete",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    bool isNumber = false,
    String? hintText, // 👈 ضفنا هذا السطر هنا عشان نستقبل التلميح
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label, // النص الأساسي
          hintText: hintText, // 👈 التلميح (هنا راح يشتغل الحين)
          filled: true,
          fillColor: AppColors.secondaryTeal(context).withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
