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

  // بيانات تجريبية
  String topGrade = "92.0%";
  String averageGrade = "86.0%";
  String totalExams = "13";
  String totalSubjects = "6";

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
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        bool isTablet =
            constraints.maxWidth >= 600 && constraints.maxWidth < 1100;
        bool isWeb = constraints.maxWidth >= 1100;

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
                      horizontal: isWeb ? 40 : 16,
                      vertical: 32,
                    ),
                    child: Column(
                      children: [
                        // 1. الإحصائيات (تدعم اليمين لليسار في الجوال)
                        _buildTopStatsGrid(isMobile, isTablet),

                        const SizedBox(height: 48),

                        // 2. مفتاح تبديل الفصول
                        _buildTermSwitcher(),

                        const SizedBox(height: 32),

                        // 3. عرض المواد (مرن: 4 ويب، 3 تابلت، طولي جوال)
                        _buildSubjectsResponsiveLayout(
                          isMobile,
                          isTablet,
                          isWeb,
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  // الإحصائيات مع ضبط اتجاه الجوال
  Widget _buildTopStatsGrid(bool isMobile, bool isTablet) {
    var stats = [
      _buildStatCard("أعلى معدل", topGrade, Icons.trending_up),
      _buildStatCard("المعدل العام", averageGrade, Icons.analytics),
      _buildStatCard("إجمالي الامتحانات", totalExams, Icons.description),
      _buildStatCard("إجمالي المواد", totalSubjects, Icons.book),
    ];

    if (isMobile) {
      return SingleChildScrollView(
        reverse: true, // يضمن البدء من اليمين في العربية
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: stats
              .map(
                (card) => Container(
                  width: MediaQuery.of(context).size.width * 0.42,
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

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.accentYellow(context), size: 24),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }

  // توزيع الكروت حسب حجم الشاشة
  Widget _buildSubjectsResponsiveLayout(
    bool isMobile,
    bool isTablet,
    bool isWeb,
  ) {
    final subjects = _getSubjectsByTerm();

    return LayoutBuilder(
      builder: (context, subjectsConstraints) {
        double width = subjectsConstraints.maxWidth;

        // المنطق الجديد لعدد الأعمدة:
        int crossAxisCount;
        if (width > 1100) {
          crossAxisCount = 4; // وضع الويب
        } else if (width > 750) {
          crossAxisCount = 3; // تابلت (العرض واسع)
        } else if (width > 500) {
          crossAxisCount = 2; // تابلت (العرض ضيق - الحجم اللي في صورتك)
        } else {
          crossAxisCount = 1; // جوال
        }

        // إذا كان عمود واحد (جوال)، نستخدم Column، وإذا أكثر نستخدم Grid
        if (crossAxisCount == 1) {
          return Column(
            children: subjects
                .map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildOldStyleSubjectCard(s, true),
                  ),
                )
                .toList(),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
            // تحكمي في هذا الرقم لضبط "طول" الكارت (كل ما قل الرقم زاد الطول)
            childAspectRatio: crossAxisCount == 2 ? 1.3 : 1.1,
          ),
          itemCount: subjects.length,
          itemBuilder: (context, index) =>
              _buildOldStyleSubjectCard(subjects[index], false),
        );
      },
    );
  }

  // الكارد بتنسيقك القديم المفضل
  Widget _buildOldStyleSubjectCard(
    Map<String, dynamic> subject,
    bool isListMode,
  ) {
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
                        subject["name"],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
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
            const Divider(height: 20, thickness: 0.8),
            Row(
              children: [
                Expanded(child: _buildOldStatBox("الدرجة", subject["grade"])),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildOldStatBox("الامتحانات", subject["exams"]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // الجزء الرمادي في الأسفل لآخر امتحان
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
                  const Text(
                    "آخر امتحان",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  Text(
                    subject["lastExam"],
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
        color: const Color.fromARGB(255, 148, 147, 147).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
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
    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _termButton("الفصل الأول", 1),
            _termButton("الفصل الثاني", 2),
          ],
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cardBg(context) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.primaryTeal(context) : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getSubjectsByTerm() {
    return selectedTerm == 1
        ? [
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
              "name": "اللغة الإنجليزية",
              "teacher": "أ. سامي فهد",
              "grade": "82%",
              "exams": "3",
              "lastExam": "2026-03-01",
            },
          ]
        : [
            {
              "name": "الأحياء",
              "teacher": "د. ليلى حسن",
              "grade": "94%",
              "exams": "4",
              "lastExam": "2026-02-20",
            },
          ];
  }
}
