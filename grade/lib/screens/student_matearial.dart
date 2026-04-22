import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../generated/l10n.dart';
import 'student_detiles.dart';

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
  final String topGrade = "92.0%";
  final String averageGrade = "86.0%";
  final String totalExams = "13";
  final String totalSubjects = "6";

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
        double horizontalPadding = isMobile ? 14.0 : 30.0;

        if (selectedSubjectName != null) {
          return SubjectDetailsScreen(
            subjectName: selectedSubjectName!,
            onBack: () => setState(() => selectedSubjectName = null),
            onSubjectTap: onSubjectTap,
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
                _buildTopStatsGrid(context, isMobile),
                const SizedBox(height: 40),
                _buildTermSwitcher(context),
                const SizedBox(height: 32),
                _buildFluidSubjectsLayout(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopStatsGrid(BuildContext context, bool isMobile) {
    double width = MediaQuery.of(context).size.width;
    bool isTablet = width >= 600 && width < 1100;

    var stats = [
      // تم تعديل المسميات لتطابق ملف الـ ARB الخاص بكِ بدقة
      _statTopCard(
        context,
        S.of(context).statHighScore,
        topGrade,
        Icons.trending_up,
        isTablet,
      ),
      _statTopCard(
        context,
        S.of(context).statAverage,
        averageGrade,
        Icons.analytics,
        isTablet,
      ),
      _statTopCard(
        context,
        S.of(context).statExams,
        totalExams,
        Icons.description,
        isTablet,
      ),
      _statTopCard(
        context,
        S.of(context).statMaterials,
        totalSubjects,
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

  Widget _buildTermSwitcher(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _termButton(S.of(context).termFirst, 1),
            _termButton(S.of(context).termSecond, 2),
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

  Widget _buildFluidSubjectsLayout(BuildContext context) {
    final subjects = _getSubjectsByTerm();
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
                // تم استخدام gradeLabel من ملفك
                Expanded(
                  child: _buildOldStatBox(
                    S.of(context).gradeLabel,
                    subject["grade"],
                  ),
                ),
                const SizedBox(width: 8),
                // تم استخدام examsLabel من ملفك
                Expanded(
                  child: _buildOldStatBox(
                    S.of(context).examsLabel,
                    subject["exams"],
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
                  // تم استخدام lastExam من ملفك
                  Text(
                    S.of(context).lastExam,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
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
