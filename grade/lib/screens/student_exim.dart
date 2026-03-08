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
                    // هنا التعديل الأساسي لجعل الارتفاع مرناً ومتساوياً
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // كرت النتيجة الأخضر (تمت إزالة العرض الثابت وتصغير المحتوى ليصغر الكرت)

                          // شبكة الإحصائيات (تم توزيع العناصر بـ Expanded لتصغر بمرونة)
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

  // --- 1. شريط المسار ---
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

  // --- 2. كرت النتيجة (تم تصغير الخطوط والحشو ليسمح للبوكس بالانكماش) ---
  Widget _buildFinalScoreCard() {
    return Container(
      padding: const EdgeInsets.all(16), // تقليل الحشو من 24 لـ 16
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
              fontSize: 14, // أصغر قليلاً
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "85",
            style: TextStyle(
              color: Colors.white,
              fontSize: 44, // تقليل من 64 لـ 44 ليصغر حجم البوكس
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "من 100",
            style: TextStyle(color: Colors.white70, fontSize: 13),
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
            child: const Text("تقرير", style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  // --- 3. شبكة الإحصائيات (تم استخدام Expanded لضمان المرونة) ---
  Widget _buildStatsGrid() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
          width: 100, // تصغير المربعات الملونة من 80 لـ 50
          height: 38, // تصغير من 50 لـ 38
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
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // --- 4. المحتوى الرئيسي ---
  Widget _buildMainContentSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton("التصحيح التفصيلي", isDetailedCorrection, () {
                  setState(() => isDetailedCorrection = true);
                }),
                const SizedBox(width: 15),
                _buildTabButton(
                  "ورقة الاجابة الاصلية",
                  !isDetailedCorrection,
                  () {
                    setState(() => isDetailedCorrection = false);
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(25),
            child: isDetailedCorrection
                ? _buildDetailedCorrectionList()
                : _buildOriginalPaperPlaceholder(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedCorrectionList() {
    return Column(
      children: [
        _buildQuestionCard(
          questionNum: "1",
          type: "حسابية",
          questionText: "احسب قيمة التكامل: ∫(2x + 3)dx",
          score: "10/10",
          modelAnswer: "x² + 3x + C",
          studentAnswer:
              "x² + 3nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnx + C",
          aiEvaluation: "إجابة صحيحة ومكتملة",
          statusColor: const Color(0xFF00A63E),
          statusIcon: Icons.check_circle_outline,
        ),
        const SizedBox(height: 20),
        _buildQuestionCard(
          questionNum: "2",
          type: "حسابية",
          questionText: "أوجد مشتقة الدالة: f(x) = 3x³ + 2x² - 5x + 1",
          score: "7/10",
          modelAnswer: "9x² + 4x - 5",
          studentAnswer: "9x² + 4x",
          aiEvaluation: "إجابة صحيحة لكن ناقصة ثابت التكامل أو جزئية",
          statusColor: const Color(0xFFD08700),
          statusIcon: Icons.error_outline,
        ),
        const SizedBox(height: 20),
        _buildQuestionCard(
          questionNum: "3",
          type: "حسابية",
          questionText: "أوجد مشتقة الدالة: f(x) = 3x³ + 2x² - 5x + 1",
          score: "7/10",
          modelAnswer: "9x² + 4x - 5",
          studentAnswer: "9x² + 4x",
          aiEvaluation: "إجابة صحيحة لكن ناقصة ثابت التكامل أو جزئية",
          statusColor: const Color(0xFFE7000B),
          statusIcon: Icons.error_outline,
        ),
      ],
    );
  }

  Widget _buildQuestionCard({
    required String questionNum,
    required String type,
    required String questionText,
    required String score,
    required String modelAnswer,
    required String studentAnswer,
    required String aiEvaluation,
    required Color statusColor,
    required IconData statusIcon,
  }) {
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
              Row(
                children: [
                  Text(
                    "السؤال $questionNum",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(color: statusColor, fontSize: 12),
                    ),
                  ),
                ],
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
                        score,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Icon(statusIcon, color: statusColor, size: 28),
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

  Widget _buildOriginalPaperPlaceholder() {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text("هنا تُعرض ورقة الإجابة الأصلية المصورة"),
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

  Widget _dividerIcon() => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 5),
    child: Icon(Icons.chevron_left, color: Color(0xFFCBD5E1), size: 18),
  );
}
