import 'package:flutter/material.dart';
import 'student_detiles.dart';
import '../core/colors.dart';

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
  int selectedTerm = 1;
  String? selectedSubjectName;

  @override
  void initState() {
    super.initState();
    if (widget.subjectName.isNotEmpty) {
      selectedSubjectName = widget.subjectName;
    }
  }

  @override
  void didUpdateWidget(covariant SubjectsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.subjectName.isEmpty && selectedSubjectName != null) {
      setState(() {
        selectedSubjectName = null;
      });
    }
  }

  String topGrade = "92.0%";
  String averageGrade = "86.0%";
  String totalExams = "13";
  String totalSubjects = "6";

  final double horizontalPadding = 40.0;
  final double statCardWidth = 227.0;

  void onSubjectTap(String name) {
    if (selectedSubjectName == name) {
      widget.onSubjectTap(name);
    } else {
      setState(() {
        selectedSubjectName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double responsiveStatSpacing = (screenWidth < 1200) ? 12.0 : 24.0;

    // بيانات المواد الحالية
    final currentSubjects = _getSubjectsByTerm();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.secondaryTeal(context),
        body: selectedSubjectName != null
            ? SubjectDetailsScreen(
                subjectName: selectedSubjectName!,
                onBack: () => setState(() => selectedSubjectName = null),
                onSubjectTap: onSubjectTap,
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 32,
                ),
                child: Column(
                  children: [
                    _buildResponsiveRow(
                      spacing: responsiveStatSpacing,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        _buildStatCard(
                          "أعلى معدل",
                          topGrade,
                          Icons.trending_up,
                        ),
                        _buildStatCard(
                          "المعدل العام",
                          averageGrade,
                          Icons.analytics,
                        ),
                        _buildStatCard(
                          "إجمالي الامتحانات",
                          totalExams,
                          Icons.description,
                        ),
                        _buildStatCard(
                          "إجمالي المواد",
                          totalSubjects,
                          Icons.book,
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    _buildTermSwitcher(),
                    const SizedBox(height: 32),

                    // --- استخدام GridView لضمان 4 أعمدة بالضبط ---
                    GridView.builder(
                      shrinkWrap: true, // مهم جداً داخل SingleChildScrollView
                      physics:
                          const NeverScrollableScrollPhysics(), // لمنع التعارض في السكرول
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, // عدد الكروت في الصف
                            crossAxisSpacing: 12, // المسافة الأفقية
                            mainAxisSpacing: 24, // المسافة الرأسية
                            mainAxisExtent: 250, // ارتفاع الكارت الثابت
                          ),
                      itemCount: currentSubjects.length,
                      itemBuilder: (context, index) {
                        return _buildSubjectCard(currentSubjects[index]);
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildResponsiveRow({
    required List<Widget> children,
    double spacing = 24,
    WrapAlignment alignment = WrapAlignment.spaceBetween,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: spacing,
        runSpacing: 24,
        alignment: alignment,
        children: children,
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      width: statCardWidth,
      height: 124,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentYellow(context),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> subject) {
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
                    color: AppColors.primaryTeal(
                      context,
                    ).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
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
                        subject["name"],
                        style: TextStyle(
                          fontSize: 15, // تصغير بسيط ليناسب العمود
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subject["teacher"],
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
            const Divider(height: 20, thickness: 0.8, color: Color(0xFFE5E7EB)),

            // إحصائيات المادة بداخل صف مرن
            Row(
              children: [
                Expanded(child: _buildSubjectStat("الدرجة", subject["grade"])),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildSubjectStat("الامتحانات", subject["exams"]),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _isDark(context)
                    ? const Color(0xFF262626)
                    : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "آخر امتحان",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                  Text(
                    subject["lastExam"],
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: _isDark(context)
            ? const Color(0xFF2D3748).withValues(alpha: 0.3)
            : const Color(0xFFE8F4F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary(context),
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

  Widget _buildTermSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _termButton("الفصل الدراسي الأول", 1),
          _termButton("الفصل الدراسي الثاني", 2),
        ],
      ),
    );
  }

  Widget _termButton(String title, int index) {
    bool isSelected = selectedTerm == index;
    return GestureDetector(
      onTap: () => setState(() {
        selectedTerm = index;
        selectedSubjectName = null;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cardBg(context) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? AppColors.primaryTeal(context)
                : AppColors.textSecondary(context),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  List<Map<String, dynamic>> _getSubjectsByTerm() {
    if (selectedTerm == 1) {
      return [
        {
          "name": "الرياضيات",
          "teacher": "د. محمد أحمد",
          "grade": "85.5%",
          "exams": "3",
          "lastExam": "2026-01-25",
        },
        {
          "name": "الفيزياء",
          "teacher": "د. سارة علي",
          "grade": "90%",
          "exams": "2",
          "lastExam": "2026-01-22",
        },
        {
          "name": "الكيمياء",
          "teacher": "د. خالد محمود",
          "grade": "78%",
          "exams": "2",
          "lastExam": "2026-01-20",
        },
        {
          "name": "اللغة العربية",
          "teacher": "أ. فاطمة يوسف",
          "grade": "88.5%",
          "exams": "2",
          "lastExam": "2026-02-18",
        },
        {
          "name": "اللغة العربية",
          "teacher": "أ. فاطمة يوسف",
          "grade": "88.5%",
          "exams": "2",
          "lastExam": "2026-02-18",
        },
      ];
    } else {
      return [
        {
          "name": "اللغة العربية",
          "teacher": "أ. فاطمة يوسف",
          "grade": "88.5%",
          "exams": "2",
          "lastExam": "2026-02-18",
        },
        {
          "name": "الأحياء",
          "teacher": "د. ليلى حسن",
          "grade": "94%",
          "exams": "4",
          "lastExam": "2026-02-20",
        },
        {
          "name": "الكيمياء",
          "teacher": "د. خالد محمود",
          "grade": "78%",
          "exams": "2",
          "lastExam": "2026-01-20",
        },
      ];
    }
  }
}
