import 'package:flutter/material.dart';
import '../core/colors.dart';

class StudentExamScreen extends StatefulWidget {
  final String subjectName;
  final VoidCallback onBack;
  final Function(int) onItemSelected;

  const StudentExamScreen({
    super.key,
    required this.subjectName,
    required this.onBack,
    required this.onItemSelected,
  });

  @override
  State<StudentExamScreen> createState() => _StudentExamScreenState();
}

class _StudentExamScreenState extends State<StudentExamScreen> {
  bool isDetailedCorrection = true;

  final List<Map<String, dynamic>> questionsData = [
    {
      "id": "1",
      "text": "احسب قيمة التكامل: ∫(2x + 3)dx",
      "score": 10.0,
      "total": 10.0,
      "modelAnswer": "x² + 3x + C",
      "studentAnswer": "x² + 3x + C",
      "evaluation": "إجابة صحيحة ومكتملة",
    },
    {
      "id": "2",
      "text": "أوجد مشتقة الدالة: f(x) = 3x³ + 2x² - 5x + 1",
      "score": 7.0,
      "total": 10.0,
      "modelAnswer": "9x² + 4x - 5",
      "studentAnswer": "9x² + 4x",
      "evaluation": "إجابة صحيحة لكن ناقصة ثابت التكامل أو جزئية",
    },
    {
      "id": "3",
      "text": "حل المعادلة التالية: 2x + 5 = 15",
      "score": 0.0,
      "total": 10.0,
      "modelAnswer": "x = 5",
      "studentAnswer": "x = 10",
      "evaluation": "إجابة خاطئة تماماً",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.secondaryTeal(context),
        body: Column(
          children: [
            _buildFixedHeader(),
            Expanded(
              child: SingleChildScrollView(
                // تم تعديل الـ Padding الجانبي ليكون 33 بكسل تماماً مثل الهيدر
                padding: const EdgeInsets.symmetric(
                  horizontal: 33,
                  vertical: 10,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    bool isSmall = constraints.maxWidth < 750;

                    return Column(
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 5,
                                child: _buildStatsGrid(isSmall),
                              ),
                              SizedBox(width: isSmall ? 10 : 20),
                              Expanded(
                                flex: isSmall ? 3 : 2,
                                child: _buildFinalScoreCard(isSmall),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildMainContentSection(isSmall),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- دوال البناء (تم الحفاظ عليها كما هي) ---

  Widget _buildStatsGrid(bool isSmall) {
    return Container(
      padding: EdgeInsets.all(isSmall ? 8 : 15),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _statItem(
              "إجمالي الأسئلة",
              "10",
              const Color(0xFFDBEAFE),
              Icons.list_alt,
              isSmall,
            ),
          ),
          Expanded(
            child: _statItem(
              "إجابات خاطئة",
              "1",
              const Color(0xFFFFE2E2),
              Icons.close,
              isSmall,
            ),
          ),
          Expanded(
            child: _statItem(
              "إجابات جزئية",
              "1",
              const Color(0xFFFEF9C2),
              Icons.priority_high,
              isSmall,
            ),
          ),
          Expanded(
            child: _statItem(
              "إجابات صحيحة",
              "8",
              const Color(0xFFDCFCE7),
              Icons.check,
              isSmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(
    String label,
    String value,
    Color bgColor,
    IconData icon,
    bool isSmall,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: isSmall ? 28 : 45,
          height: isSmall ? 28 : 45,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.black45, size: isSmall ? 14 : 22),
        ),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              fontSize: isSmall ? 9 : 12,
              color: AppColors.textSecondary(context),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmall ? 13 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFinalScoreCard(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 8 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryTeal(context),
            AppColors.primaryTeal(context).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: Text(
              "النتيجة النهائية",
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 10 : 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            "85",
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 28 : 44,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "من 100",
            style: TextStyle(
              color: Colors.white70,
              fontSize: isMobile ? 12 : 19,
            ),
          ),
          if (isMobile)
            const SizedBox(height: 4)
          else
            const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryTeal(context),
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 8),
              minimumSize: Size(double.infinity, isMobile ? 25 : 35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text("تحميل", style: TextStyle(fontSize: isMobile ? 9 : 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContentSection(bool isSmall) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton(
                  "التصحيح التفصيلي",
                  isDetailedCorrection,
                  isSmall,
                  () => setState(() => isDetailedCorrection = true),
                ),
                const SizedBox(width: 10),
                _buildTabButton(
                  "ورقة الاجابة",
                  !isDetailedCorrection,
                  isSmall,
                  () => setState(() => isDetailedCorrection = false),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.textSecondary(context).withValues(alpha: 0.2),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Padding(
              key: ValueKey<bool>(isDetailedCorrection),
              padding: EdgeInsets.all(isSmall ? 15 : 25),
              child: isDetailedCorrection
                  ? _buildDetailedList(isSmall)
                  : _buildOriginalPaperPlaceholder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedList(bool isMobile) {
    return Column(
      children: questionsData
          .map(
            (data) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildQuestionCard(isMobile: isMobile, data: data),
            ),
          )
          .toList(),
    );
  }

  Widget _buildQuestionCard({
    required bool isMobile,
    required Map<String, dynamic> data,
  }) {
    final Color statusColor = _getStatusColor(data['score'], data['total']);
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 20),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "السؤال ${data['id']}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 14 : 16,
                ),
              ),
              Row(
                children: [
                  Text(
                    "${data['score'].toInt()}/${data['total'].toInt()}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                      fontSize: isMobile ? 15 : 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    data['score'] == data['total']
                        ? Icons.check_circle_outline
                        : Icons.error_outline,
                    color: statusColor,
                    size: isMobile ? 20 : 24,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            data['text'],
            style: TextStyle(
              fontSize: isMobile ? 13 : 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildAnswerBox("النموذجية:", data['modelAnswer'], isMobile),
              const SizedBox(width: 10),
              _buildAnswerBox("إجابتك:", data['studentAnswer'], isMobile),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.secondaryTeal(context).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: isMobile ? 11 : 13,
                  color: AppColors.textPrimary(context),
                  fontFamily: 'Cairo',
                ),
                children: [
                  TextSpan(
                    text: "تقييم AI: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTeal(context),
                    ),
                  ),
                  TextSpan(text: data['evaluation']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(double score, double total) {
    if (score == total) return const Color(0xFF00A63E);
    if (score > 0) return const Color(0xFFD08700);
    return const Color(0xFFE7000B);
  }

  Widget _buildAnswerBox(String title, String content, bool isMobile) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: isMobile ? 10 : 12, color: Colors.grey),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.cardBg(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                content,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    String label,
    bool isActive,
    bool isSmall,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 15 : 30,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryTeal(context) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: isSmall ? 12 : 14,
          ),
        ),
      ),
    );
  }

  Widget _buildFixedHeader() {
    return Container(
      width: double.infinity,
      height: 43,
      // الـ margin الجانبي 33 بكسل
      margin: const EdgeInsets.fromLTRB(33, 20, 33, 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            InkWell(
              onTap: () => widget.onItemSelected(1),
              child: const Text(
                "المواد",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(Icons.chevron_left, color: Colors.grey, size: 16),
            ),
            InkWell(
              onTap: widget.onBack,
              child: Text(
                widget.subjectName,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(Icons.chevron_left, color: Colors.grey, size: 16),
            ),
            Text(
              "التفاصيل",
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

  Widget _buildOriginalPaperPlaceholder() =>
      const Center(child: Text("ورقة الإجابة الأصلية"));
}
