import 'package:flutter/material.dart';
// تأكد من استيراد ملف الألوان الخاص بك
// import 'path_to_your_app_colors.dart';
import '../core/colors.dart';

class SubjectDetailsScreen extends StatelessWidget {
  final String subjectName;
  final VoidCallback onBack;
  final Function(String) onSubjectTap;

  const SubjectDetailsScreen({
    super.key,
    required this.subjectName,
    required this.onBack,
    required this.onSubjectTap,
  });

  @override
  Widget build(BuildContext context) {
    // إحصائيات المادة
    final Map<String, String> subjectStats = {
      "min": "78%",
      "max": "92%",
      "avg": "86.6%",
      "count": "5",
    };

    // قائمة الامتحانات
    final List<Map<String, String>> examsData = [
      {
        "title": "امتحان نهاية الفصل",
        "grade": "85",
        "date": "2026-01-25",
        "answers": "8/10",
        "rating": "جيد جداً",
        "total": "15",
        "totalgrade": "100",
      },
      {
        "title": "امتحان التكامل والتفاضل",
        "grade": "88",
        "date": "2026-01-18",
        "answers": "9/10",
        "rating": "امتياز",
        "total": "20",
        "totalgrade": "100",
      },
      {
        "title": "امتحان الجبر الخطي",
        "grade": "75",
        "date": "2026-01-10",
        "answers": "7/10",
        "rating": "جيد",
        "total": "12",
        "totalgrade": "60",
      },
    ];

    final List<String> strengths = ["أداء ممتاز", "سرعة البديهة"];
    final List<String> improvements = ["إدارة الوقت", "التركيز"];

    return Scaffold(
      // استخدام لون الخلفية الديناميكي
      backgroundColor: AppColors.secondaryTeal(context),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              _buildFixedHeader(context), // تمرير context للهيدر
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFullWidthStatsRow(context, subjectStats),
                      const SizedBox(height: 32),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: examsData.map((exam) {
                                return _buildExamCard(
                                  context,
                                  exam["title"]!,
                                  exam["grade"]!,
                                  exam["date"]!,
                                  exam["answers"]!,
                                  exam["rating"]!,
                                  exam["total"]!,
                                  exam["totalgrade"]!,
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 1,
                            child: _buildSideSection(
                              context,
                              strengths,
                              improvements,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFixedHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 43,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context), // لون الكارت الديناميكي
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 7,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Icon(
              Icons.chevron_left,
              color: AppColors.textSecondary(context),
              size: 18,
            ),
            InkWell(
              onTap: onBack,
              child: Text(
                "المواد",
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.chevron_left,
              color: AppColors.textSecondary(context),
              size: 18,
            ),
            Text(
              subjectName,
              style: TextStyle(
                color: AppColors.primaryTeal(context), // لون التركواز الأساسي
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullWidthStatsRow(
    BuildContext context,
    Map<String, String> stats,
  ) {
    return Row(
      children: [
        Expanded(
          child: _statItem(
            context,
            "أقل درجة",
            stats["min"]!,
            AppColors.accentYellow(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statItem(
            context,
            "أعلى درجة",
            stats["max"]!,
            AppColors.primaryTeal(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statItem(
            context,
            "المعدل العام",
            stats["avg"]!,
            const Color(0xFF63B3ED),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statItem(
            context,
            "إجمالي الامتحانات",
            stats["count"]!,
            AppColors.accentYellow(context),
          ),
        ),
      ],
    );
  }

  Widget _statItem(
    BuildContext context,
    String label,
    String value,
    Color iconBg,
  ) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.bar_chart,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
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

  Widget _buildExamCard(
    BuildContext context,
    String title,
    String grade,
    String date,
    String answers,
    String rating,
    String totalQ,
    String totalG,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _badgeInfo(context, "التاريخ", date),
                    _badgeInfo(context, "الأسئلة", totalQ),
                    _badgeInfo(context, "الإجابات", answers),
                    _badgeInfo(context, "التقدير", rating, isBlue: true),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: InkWell(
                    onTap: () => onSubjectTap(subjectName),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal(context),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "عرض التفاصيل",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 100,
            height: 130,
            decoration: BoxDecoration(
              color: AppColors.primaryTeal(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "الدرجة",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  grade,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "من",
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
                Text(
                  totalG,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _badgeInfo(
    BuildContext context,
    String label,
    String value, {
    bool isBlue = false,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondaryTeal(
          context,
        ), // استخدام لون الخلفية الفاتح من كلاسك
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary(context),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isBlue
                  ? Colors.blueAccent
                  : AppColors.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideSection(
    BuildContext context,
    List<String> strengths,
    List<String> improvements,
  ) {
    return Column(
      children: [
        _sideCard(
          context,
          "نقاط القوة",
          strengths,
          AppColors.primaryTeal(context),
        ),
        const SizedBox(height: 20),
        _sideCard(
          context,
          "مجالات التحسين",
          improvements,
          AppColors.accentYellow(context),
        ),
      ],
    );
  }

  Widget _sideCard(
    BuildContext context,
    String title,
    List<String> items,
    Color bgColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Text(
                    "• ",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  Flexible(
                    child: Text(
                      item,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
