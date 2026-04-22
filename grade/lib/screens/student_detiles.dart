
import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../generated/l10n.dart'; // استيراد ملف الترجمة

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
    final Map<String, String> subjectStats = {
      "min": "78%",
      "max": "92%",
      "avg": "86.6%",
      "count": "5",
    };

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

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        bool showSideLayout = width > 750;
        bool isMobile = constraints.maxWidth < 600;
        double horizontalPadding = isMobile ? 14.0 : 30.0;

        return Scaffold(
          backgroundColor: AppColors.secondaryTeal(context),
          body: SafeArea(
            child: Column(
              children: [
                _buildFixedHeader(context, horizontalPadding),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFullWidthStatsRow(context, subjectStats, width),
                        const SizedBox(height: 20),
                        if (showSideLayout)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: examsData
                                      .map((e) => _buildExamCard(context, e))
                                      .toList(),
                                ),
                              ),
                              const SizedBox(width: 24),
                              SizedBox(
                                width: width > 900 ? 300 : 220,
                                child: _buildSideSection(
                                  context,
                                  strengths,
                                  improvements,
                                  false,
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              _buildSideSection(
                                context,
                                strengths,
                                improvements,
                                true,
                              ),
                              const SizedBox(height: 20),
                              ...examsData
                                  .map((e) => _buildExamCard(context, e))
                                  .toList(),
                            ],
                          ),
                      ],
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

  Widget _buildFullWidthStatsRow(
    BuildContext context,
    Map<String, String> stats,
    double width,
  ) {
    bool isTablet = width >= 600 && width < 1100;
    var items = [
      _statItem(
        context,
        S.of(context).statMinGrade,
        stats["min"]!,
        Icons.arrow_downward,
        AppColors.accentYellow(context),
        isTablet,
      ),
      _statItem(
        context,
        S.of(context).statMaxGrade,
        stats["max"]!,
        Icons.arrow_upward,
        AppColors.primaryTeal(context),
        isTablet,
      ),
      _statItem(
        context,
        S.of(context).statAverage,
        stats["avg"]!,
        Icons.analytics,
        const Color(0xFF4F85E2),
        isTablet,
      ),
      _statItem(
        context,
        S.of(context).statExams,
        stats["count"]!,
        Icons.assignment,
        AppColors.accentYellow(context),
        isTablet,
      ),
    ];

    if (width < 600) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: items
              .map(
                (i) => Container(
                  width: 145,
                  margin: const EdgeInsetsDirectional.only(end: 12),
                  child: i,
                ),
              )
              .toList(),
        ),
      );
    }
    return Row(
      children: items
          .map(
            (i) => Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: i,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _statItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color bgColor,
    bool isTablet,
  ) {
    return Container(
      height: 97,
      padding: EdgeInsets.all(isTablet ? 12 : 17),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                    label,
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

  Widget _buildExamCard(BuildContext context, Map<String, String> exam) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
                  exam["title"]!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _badgeInfo(
                        context,
                        S.of(context).examDate,
                        exam["date"]!,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _badgeInfo(
                        context,
                        S.of(context).examQuestions,
                        exam["total"]!,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _badgeInfo(
                        context,
                        S.of(context).examAnswers,
                        exam["answers"]!,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _badgeInfo(
                        context,
                        S.of(context).examRating,
                        exam["rating"]!,
                        isBlue: true,
                      ),
                    ),
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
                      child: Text(
                        S.of(context).viewDetails,
                        style: const TextStyle(
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
                Text(
                  S.of(context).gradeLabel,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  exam["grade"]!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  S.of(context).gradeOf,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
                Text(
                  exam["totalgrade"]!,
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

  Widget _buildSideSection(
    BuildContext context,
    List<String> strengths,
    List<String> improvements,
    bool isHorizontal,
  ) {
    if (isHorizontal) {
      return Row(
        children: [
          Expanded(
            child: _sideCard(
              context,
              S.of(context).strengths,
              strengths,
              AppColors.primaryTeal(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _sideCard(
              context,
              S.of(context).improvements,
              improvements,
              AppColors.accentYellow(context),
            ),
          ),
        ],
      );
    }
    return Column(
      children: [
        _sideCard(
          context,
          S.of(context).strengths,
          strengths,
          AppColors.primaryTeal(context),
        ),
        const SizedBox(height: 20),
        _sideCard(
          context,
          S.of(context).improvements,
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
      height: 150,
      padding: const EdgeInsets.all(16),
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: items
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const Text(
                              "• ",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg(context).withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary(context),
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isBlue
                    ? Colors.blueAccent
                    : AppColors.textPrimary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedHeader(BuildContext context, double horizontalPadding) {
    return Container(
      width: double.infinity,
      height: 43,
      // هنا استبدلنا الـ 30 بمتغير المحاذاة الديناميكي
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
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
            InkWell(
              onTap: onBack,
              child: Text(
                S.of(context).backToMaterials,
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 14,
                ),
              ),
            ),
            // أيقونة السهم ستنقلب تلقائياً حسب اللغة (Directionality)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.chevron_left, color: Colors.grey, size: 16),
            ),
            Text(
              subjectName,
              style: TextStyle(
                color: AppColors.primaryTeal(context),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
