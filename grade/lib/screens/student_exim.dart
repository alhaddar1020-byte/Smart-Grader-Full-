import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../generated/l10n.dart';

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
    return Scaffold(
      backgroundColor: AppColors.secondaryTeal(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          bool isMobile = width < 650;
          double horizontalPadding = isMobile ? 16.0 : 33.0;

          return Column(
            children: [
              _buildResponsiveHeader(context, horizontalPadding),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      _buildStatsAndScoreSection(isMobile),
                      const SizedBox(height: 25),
                      _buildMainContentSection(isMobile),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatsAndScoreSection(bool isMobile) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 5, child: _ExamStatsGrid(isMobile: isMobile)),
          const SizedBox(width: 15),
          Expanded(
            flex: isMobile ? 3 : 2,
            child: _FinalScoreCard(isMobile: isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContentSection(bool isMobile) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildTabs(isMobile),
          Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Padding(
              key: ValueKey<bool>(isDetailedCorrection),
              padding: EdgeInsets.all(isMobile ? 15 : 25),
              child: isDetailedCorrection
                  ? _buildDetailedQuestionsList(isMobile)
                  : _buildOriginalPaperView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _TabButton(
            label: S.of(context).examDetailedCorrection,
            isActive: isDetailedCorrection,
            onTap: () => setState(() => isDetailedCorrection = true),
          ),
          const SizedBox(width: 10),
          _TabButton(
            label: S.of(context).examAnswerPaper,
            isActive: !isDetailedCorrection,
            onTap: () => setState(() => isDetailedCorrection = false),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedQuestionsList(bool isMobile) {
    return Column(
      children: questionsData
          .map((data) => _QuestionCard(data: data, isMobile: isMobile))
          .toList(),
    );
  }

  Widget _buildOriginalPaperView() {
    return SizedBox(
      height: 300,
      child: Center(child: Text(S.of(context).examOriginalPaperView)),
    );
  }

  Widget _buildResponsiveHeader(BuildContext context, double padding) {
    return Container(
      width: double.infinity,
      height: 43,
      margin: EdgeInsetsDirectional.fromSTEB(padding, 20, padding, 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            _headerLink(
              S.of(context).examMaterials,
              () => widget.onItemSelected(1),
            ),
            _headerSeparator(),
            _headerLink(widget.subjectName, widget.onBack),
            _headerSeparator(),
            Text(
              S.of(context).examDetails,
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

  Widget _headerLink(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(color: Colors.grey, fontSize: 13),
      ),
    );
  }

  Widget _headerSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Icon(Icons.chevron_left, color: Colors.grey, size: 16),
    );
  }
}

class _ExamStatsGrid extends StatelessWidget {
  final bool isMobile;
  const _ExamStatsGrid({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 10 : 15),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(
            context,
            S.of(context).examTotalQuestions,
            "10",
            const Color(0xFFDBEAFE),
            Icons.list_alt,
          ),
          _statItem(
            context,
            S.of(context).examWrongAnswers,
            "1",
            const Color(0xFFFFE2E2),
            Icons.close,
          ),
          _statItem(
            context,
            S.of(context).examPartialAnswers,
            "1",
            const Color(0xFFFEF9C2),
            Icons.priority_high,
          ),
          _statItem(
            context,
            S.of(context).examCorrectAnswers,
            "8",
            const Color(0xFFDCFCE7),
            Icons.check,
          ),
        ],
      ),
    );
  }

  Widget _statItem(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.black45, size: isMobile ? 16 : 22),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: isMobile ? 14 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _FinalScoreCard extends StatelessWidget {
  final bool isMobile;
  const _FinalScoreCard({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryTeal(context), const Color(0xFF006D6D)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: Text(
              S.of(context).examResultTitle,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          Text(
            "85",
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 28 : 38,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            S.of(context).examOutOf("100"),
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryTeal(context),
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                S.of(context).examDownload,
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isMobile;
  const _QuestionCard({required this.data, required this.isMobile});

  Color _getStatusColor() {
    if (data['score'] == data['total']) return const Color(0xFF00A63E);
    if (data['score'] > 0) return const Color(0xFFD08700);
    return const Color(0xFFE7000B);
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).examQuestionNumber(data['id']),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "${data['score'].toInt()}/${data['total'].toInt()}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(data['text'], style: const TextStyle(height: 1.5)),
          const SizedBox(height: 15),
          Row(
            children: [
              _answerBox(
                S.of(context).examModelAnswer,
                data['modelAnswer'],
                context,
              ),
              const SizedBox(width: 10),
              _answerBox(
                S.of(context).examYourAnswer,
                data['studentAnswer'],
                context,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cardBg(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 16,
                  color: AppColors.primaryTeal(context),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary(context),
                        fontFamily: 'Arimo',
                      ),
                      children: [
                        TextSpan(
                          text: "${S.of(context).examAiEvaluation}: ",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: data['evaluation']),
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
  }

  Widget _answerBox(String title, String content, BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.cardBg(context),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              content,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryTeal(context) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
