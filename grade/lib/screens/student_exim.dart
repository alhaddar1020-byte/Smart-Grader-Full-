import 'package:flutter/material.dart';

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

  // هذه المصفوفة هي التي ستربطها لاحقاً بالبيانات القادمة من البايثون (Database)
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

    {
      "id": "3",
      "text": "حل المعادلة التالية: 2x + 5 = 15",
      "score": 2.0,
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
        backgroundColor: const Color(0xFFDEF6F5),
        body: Column(
          children: [
            _buildFixedHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 33,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(flex: 5, child: _buildStatsGrid()),
                          const SizedBox(width: 20),
                          Expanded(flex: 2, child: _buildFinalScoreCard()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildMainContentSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة لتحديد اللون ديناميكياً بناءً على الدرجة
  Color _getStatusColor(double score, double total) {
    if (score == total) return const Color(0xFF00A63E); // أخضر (كاملة)
    if (score > 0) return const Color(0xFFD08700); // برتقالي (جزئية)
    return const Color(0xFFE7000B); // أحمر (خطأ)
  }

  //   // --- 1. شريط المسار ---
  Widget _buildFixedHeader() {
    return Container(
      width: double.infinity,
      height: 43,
      margin: const EdgeInsets.fromLTRB(33, 20, 33, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            const SizedBox(width: 8),
            _breadcrumbItem("المواد", () => widget.onItemSelected(1)),
            _dividerIcon(),
            _breadcrumbItem(widget.subjectName, widget.onBack),
            _dividerIcon(),
            const Text(
              "عرض التفاصيل",
              style: TextStyle(
                color: Color(0xFF009689),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _breadcrumbItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title,
        style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
      ),
    );
  }

  // --- 2. كرت النتيجة النهائية ---
  Widget _buildFinalScoreCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4DB8AC), Color(0xFF3DA89C)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            "النتيجة النهائية",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "85",
            style: TextStyle(
              color: Colors.white,
              fontSize: 44,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "من 100",
            style: TextStyle(color: Colors.white70, fontSize: 19),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4DB8AC),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(double.infinity, 35), // تقليل ارتفاع الزر
            ),
            child: const Text(
              "تحميل التقرير  ",
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. شبكة الإحصائيات ---
  Widget _buildStatsGrid() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
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
            ),
          ),
          Expanded(
            child: _statItem(
              "إجابات خاطئة",
              "1",
              const Color(0xFFFFE2E2),
              Icons.close,
            ),
          ),
          Expanded(
            child: _statItem(
              "إجابات جزئية",
              "1",
              const Color(0xFFFEF9C2),
              Icons.priority_high,
            ),
          ),
          Expanded(
            child: _statItem(
              "إجابات صحيحة",
              "8",
              const Color(0xFFDCFCE7),
              Icons.check,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, Color bgColor, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 38,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.black45, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // --- 4. الجزء الرئيسي (Tabs & List) ---
  Widget _buildMainContentSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
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
                  () => setState(() => isDetailedCorrection = true),
                ),
                const SizedBox(width: 15),
                _buildTabButton(
                  "ورقة الاجابة الاصلية",
                  !isDetailedCorrection,
                  () => setState(() => isDetailedCorrection = false),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(25),
            child: isDetailedCorrection
                ? _buildDetailedList()
                : _buildOriginalPaperPlaceholder(),
          ),
        ],
      ),
    );
  }

  // توليد قائمة الكروت بناءً على مصفوفة البيانات
  Widget _buildDetailedList() {
    return Column(
      children: questionsData.map((data) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _buildQuestionCard(
            questionNum: data['id'],
            questionText: data['text'],
            score: data['score'],
            total: data['total'],
            modelAnswer: data['modelAnswer'],
            studentAnswer: data['studentAnswer'],
            aiEvaluation: data['evaluation'],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuestionCard({
    required String questionNum,
    required String questionText,
    required double score,
    required double total,
    required String modelAnswer,
    required String studentAnswer,
    required String aiEvaluation,
  }) {
    final Color statusColor = _getStatusColor(score, total);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "السؤال $questionNum",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "الدرجة",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        "${score.toInt()}/${total.toInt()}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Icon(
                    score == total
                        ? Icons.check_circle_outline
                        : Icons.error_outline,
                    color: statusColor,
                    size: 28,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            questionText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildAnswerBox("الإجابة النموذجية:", modelAnswer),
              const SizedBox(width: 15),
              _buildAnswerBox("إجابة الطالب:", studentAnswer),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Text(
                  "تقييم AI:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A5565),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    aiEvaluation,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerBox(String title, String content) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 5),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              content,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF4DB8AC) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF64748B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildOriginalPaperPlaceholder() => Container(
    height: 400,
    decoration: BoxDecoration(
      color: const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Center(child: Text("ورقة الإجابة الأصلية")),
  );

  Widget _dividerIcon() => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 5),
    child: Icon(Icons.chevron_left, color: Color(0xFFCBD5E1), size: 18),
  );
}
