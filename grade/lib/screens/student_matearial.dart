import 'package:flutter/material.dart';
import 'student_detiles.dart'; // تأكد أن هذا الملف يحتوي على كلاس SubjectDetailsScreen

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
    // ✅ أول ما تفتح الصفحة، تأخذ الاسم القادم من الداشبورد
    if (widget.subjectName.isNotEmpty) {
      selectedSubjectName = widget.subjectName;
    }
  }

  @override
  void didUpdateWidget(covariant SubjectsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // إذا تغيرت البيانات القادمة من الداشبورد وكان الاسم فارغاً
    if (widget.subjectName.isEmpty && selectedSubjectName != null) {
      setState(() {
        selectedSubjectName = null; // يصفر الاختيار المحلي ليعود لعرض الكاردات
      });
    }
  }

  // --- 📊 متغيرات الإحصائيات ---
  String topGrade = "92.0%";
  String averageGrade = "86.0%";
  String totalExams = "13";
  String totalSubjects = "6";

  // --- 🛠️ أرقام التحكم ---
  final double horizontalPadding = 40.0;
  final double statCardWidth = 227.0;
  final double subjectCardWidth = 279.0;

  final Color primaryTeal = const Color(0xFF4FB7B5);
  final Color darkBlue = const Color(0xFF1E2939);
  final Color greyText = const Color(0xFF4A5565);
  final Color orangeIcon = const Color(0xFFF6AD55);

  // ✅ تعديل الدالة لتعمل كجسر انتقال للداشبورد
  void onSubjectTap(String name) {
    if (selectedSubjectName == name) {
      // إذا كانت المادة مفتوحة بالفعل وضغطنا "عرض التفاصيل"
      // نقوم باستدعاء الدالة القادمة من الداشبورد (SelectedIndex = 4)
      widget.onSubjectTap(name);
    } else {
      // إذا كانت أول مرة نضغط، نفتح صفحة التفاصيل فقط داخل المواد
      setState(() {
        selectedSubjectName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double responsiveStatSpacing = (screenWidth < 1200) ? 12.0 : 24.0;
    double responsiveSubjectSpacing = (screenWidth * 0.08).clamp(20.0, 120.0);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFDEF6F5),
        body: selectedSubjectName != null
            ? SubjectDetailsScreen(
                subjectName: selectedSubjectName!,
                onBack: () => setState(() => selectedSubjectName = null),
                // ✅ نمرر الدالة المعدلة لصفحة التفاصيل
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
                    _buildResponsiveRoww(
                      spacing: responsiveSubjectSpacing,
                      children: _getSubjectsByTerm()
                          .map((s) => _buildSubjectCard(s))
                          .toList(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // --- 🛠️ بناء واجهات المكونات ---

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

  Widget _buildResponsiveRoww({
    required List<Widget> children,
    double spacing = 24,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: spacing,
        runSpacing: 24,
        alignment: WrapAlignment.start,
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
        color: Colors.white,
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
                  color: orangeIcon,
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
                  style: TextStyle(color: greyText, fontSize: 14),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
        width: subjectCardWidth,
        height: 288,
        padding: const EdgeInsets.all(17.6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? primaryTeal : Colors.transparent,
            width: 1.6,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryTeal.withValues(alpha: 0.3),
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryTeal,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.menu_book,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject["name"],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkBlue,
                        ),
                      ),
                      Text(
                        subject["teacher"],
                        style: TextStyle(fontSize: 12, color: greyText),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
            const Divider(height: 32, thickness: 0.8, color: Color(0xFFE5E7EB)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSubjectStat("الدرجة", subject["grade"]),
                _buildSubjectStat("الامتحانات", subject["exams"]),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "آخر امتحان",
                    style: TextStyle(fontSize: 10, color: greyText),
                  ),
                  Text(
                    subject["lastExam"],
                    style: TextStyle(fontSize: 12, color: darkBlue),
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
      width: 116,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: greyText)),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryTeal,
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
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? primaryTeal : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

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
