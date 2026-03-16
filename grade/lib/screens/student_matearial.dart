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

        // القاعدة الصارمة للفراغات: 16 للجوال و 30 للتابلت والويب
        double dynamicPadding = isMobile ? 16.0 : 30.0;

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
                    // نطبق الفراغ الموحد على الـ Padding الجانبي للـ ScrollView بالكامل
                    padding: EdgeInsets.symmetric(
                      horizontal: dynamicPadding,
                      vertical: 32,
                    ),
                    child: Column(
                      children: [
                        // 1. الإحصائيات (تتبع نفس المحاذاة)
                        _buildTopStatsGrid(isMobile),

                        const SizedBox(height: 48),

                        // 2. مفتاح تبديل الفصول (يتبع نفس المحاذاة)
                        _buildTermSwitcher(),

                        const SizedBox(height: 32),

                        // 3. عرض المواد (يتبع نفس المحاذاة)
                        _buildFluidSubjectsLayout(),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  // الإحصائيات مع دعم التمرير
  Widget _buildTopStatsGrid(bool isMobile) {
    double width = MediaQuery.of(context).size.width;
    bool isTablet = width >= 600 && width < 1100;

    var stats = [
      _statCard(
        context,
        "أعلى معدل",
        topGrade,
        Icons.trending_up,
        AppColors.primaryTeal(context),
        isTablet,
      ),
      _statCard(
        context,
        "المعدل العام",
        averageGrade,
        Icons.analytics,
        AppColors.primaryTeal(context),
        isTablet,
      ),
      _statCard(
        context,
        "إجمالي الامتحانات",
        totalExams,
        Icons.description,
        AppColors.primaryTeal(context),
        isTablet,
      ),
      _statCard(
        context,
        "إجمالي المواد",
        totalSubjects,
        Icons.book,
        AppColors.accentYellow(context),
        isTablet,
      ),
    ];

    if (isMobile) {
      return SingleChildScrollView(
        reverse: false,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            for (int i = 0; i < stats.length; i++)
              Container(
                width: MediaQuery.of(context).size.width * 0.33,
                margin: EdgeInsetsDirectional.only(
                  end: i == stats.length - 1 ? 0 : 12,
                ),
                child: stats[i],
              ),
          ],
        ),
      );
    }

    return Row(
      children: [
        for (int i = 0; i < stats.length; i++) ...[
          Expanded(child: stats[i]),
          if (i != stats.length - 1) const SizedBox(width: 16),
        ],
      ],
    );
  }

  Widget _statCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color cardColor,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 12 : 17),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
                  alignment: Alignment.centerRight,
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

  Widget _buildFluidSubjectsLayout() {
    final subjects = _getSubjectsByTerm();
    return LayoutBuilder(
      builder: (context, box) {
        double width = box.maxWidth;
        int crossAxisCount;

        if (width > 900) {
          crossAxisCount = 4;
        } else if (width > 650) {
          crossAxisCount = 3;
        } else if (width > 400) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        if (crossAxisCount == 1) {
          return Column(
            children: subjects
                .map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildOldStyleSubjectCard(s),
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
                Expanded(child: _buildOldStatBox("الدرجة", subject["grade"])),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildOldStatBox("الامتحانات", subject["exams"]),
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

// اسمع خلاص بغير ابغا في شاشه الجوال كل شي يكون فيه فراغ من الحواف 16 لازم كككل شييييي وفي التابلت والويب كل شي يكون 30 لازم كل العناصر تبدا من بعد 30 فراغ وتنتهي قبل 30 فراغ حتى لما اصغره واكبره بين التابلت والويب ابغا كل العناصر نفس المحاداه وحتى الاحصائيات بس  بس بشرط مهم جدددددداااا باقي الاكواد ابغاها نفسها لا تغير شييي ابدا وخلي كل شي شغال بنفس الاحجام والتغيرات وكل شي بس خذ الكود حقي عدل حق الفراغات واعطيني الكود كامل بدون ماتلمس اي شي ثاني ترا يويلك لو لصقته وطلع يختلف ولو بملي واحد عن حقي فاهم
