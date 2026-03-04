import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../widgets/slider.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int selectedIndex = 0;

  // هذه البيانات هي التي ستأتي من Python لاحقاً
  final Map<String, dynamic> studentData = {
    "name": "أحمد محمد السعيد",
    "level": "الصف الثاني الثانوي - علمي",
    "badge": "85%", // النص المطلوب
    "stats": {
      "highest_score": "95%",
      "gpa": "87.5%",
      "exams_count": "12",
      "subjects_count": "6",
    },
    "recent_results": [
      {
        "score": "85/100",
        "label": "جيد جداً",
        "title": "امتحان نهاية الفصل",
        "subject": "الرياضيات",
        "date": "2026-01-25",
      },
      {
        "score": "92/100",
        "label": "ممتاز",
        "title": "امتحان الوحدة الثالثة",
        "subject": "الفيزياء",
        "date": "2026-01-22",
      },
      {
        "score": "78/100",
        "label": "جيد",
        "title": "امتحان الفصل الأول",
        "subject": "الكيمياء",
        "date": "2026-01-20",
      },
    ],
    "performance": {
      "graded_count": "12/15",
      "success_rate": "100%",
      "progress_value": 0.8,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 252, 252),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1440),
          decoration: const BoxDecoration(color: Color(0xFFDEF6F5)),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(studentData["name"], studentData["level"]),
                      const SizedBox(height: 32),
                      _buildTopStatsGrid(studentData["stats"]),
                      const SizedBox(height: 32),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLeftSummaryColumn(
                            studentData["performance"],
                            studentData["badge"],
                          ),
                          const SizedBox(width: 32),
                          _buildMainResultsList(studentData["recent_results"]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              CustomSidebar(
                selectedIndex: selectedIndex,
                onItemSelected: (index) =>
                    setState(() => selectedIndex = index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- الهيدر (بنفس التصميم والظلال الأصلية) ---
  Widget _buildHeader(String name, String level) {
    return Container(
      height: 101,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: "Arimo",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1E2939),
                      ),
                    ),
                    Text(
                      level,
                      style: TextStyle(
                        fontFamily: "Arimo",
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFF4DB8AC),
                  child: Icon(Icons.person, color: Colors.white, size: 24),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "مرحباً ${name.split(' ')[0]}!",
                style: const TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2939),
                ),
              ),
              const Text(
                "نتمنى لك يوماً دراسياً موفقاً",
                style: TextStyle(
                  fontFamily: "Arimo",
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- شبكة الإحصائيات ---
  Widget _buildTopStatsGrid(Map<String, String> stats) {
    return Row(
      children: [
        _statCard(
          "أعلى درجة",
          stats["highest_score"]!,
          Icons.military_tech,
          AppColors.primaryTeal,
        ),
        const SizedBox(width: 20),
        _statCard(
          "المعدل العام",
          stats["gpa"]!,
          Icons.trending_up,
          AppColors.primaryTeal,
        ),
        const SizedBox(width: 20),
        _statCard(
          "الامتحانات المنشورة",
          stats["exams_count"]!,
          Icons.assignment,
          AppColors.primaryTeal,
        ),
        const SizedBox(width: 20),
        _statCard(
          "المواد الدراسية",
          stats["subjects_count"]!,
          Icons.book,
          AppColors.accentYellow,
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color cardColor) {
    Color iconColor = (cardColor == AppColors.accentYellow)
        ? AppColors.accentYellow
        : AppColors.primaryTeal;
    return Expanded(
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    title,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: iconColor, size: 25),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- قائمة النتائج الأخيرة ---
  Widget _buildMainResultsList(List<Map<String, String>> results) {
    return Expanded(
      flex: 3,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "النتائج الأخيرة",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textprimary,
              ),
            ),
            const SizedBox(height: 25),
            ...results.map((res) => _resultItem(res)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _resultItem(Map<String, String> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                data["score"]!,
                style: const TextStyle(
                  color: AppColors.primaryTeal,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data["label"]!,
                  style: const TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data["title"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textprimary,
                ),
              ),
              Text(
                data["subject"]!,
                style: const TextStyle(color: AppColors.textseccondary),
              ),
              Text(
                data["date"]!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textseccondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- العمود الجانبي الأيسر (البطاقة المتميزة وملخص الأداء) ---
  Widget _buildLeftSummaryColumn(Map<String, dynamic> perf, String badge) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.accentYellow,
                  radius: 35,
                  child: Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "طالب متميز",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textprimary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "   حافظت على معدل أعلى من $badge% في جميع المواد     ",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textseccondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          _buildPerformanceCard(perf),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(Map<String, dynamic> perf) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4DB8AC), Color(0xFF3DA89C)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            "ملخص الأداء",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          _rowInfo(perf["graded_count"], "المواد المصححة"),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: perf["progress_value"],
            backgroundColor: Colors.white24,
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          _rowInfo(perf["success_rate"], "معدل النجاح"),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryTeal,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              "عرض التقرير الكامل",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowInfo(String val, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          val,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}
