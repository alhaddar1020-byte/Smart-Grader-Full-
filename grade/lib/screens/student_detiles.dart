import 'package:flutter/material.dart';
import 'student_exim.dart';

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
    // --- قسم المتغيرات (هنا تضع القيم التي ستأتي من قاعدة البيانات لاحقاً) ---

    // 1. إحصائيات المادة
    final Map<String, String> subjectStats = {
      "min": "78%",
      "max": "92%",
      "avg": "86.6%",
      "count": "5",
    };

    // 2. قائمة الامتحانات (Map داخل List)
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

    // 3. نقاط القوة والتحسين
    final List<String> strengths = [
      "أداء ممتاز",
      "سرااااااااااااااااااااااااااااااااااااااااااااااااااااااااااعة البديهة",
      "أداء ممتاز",
      "أداء ممتاز",
      "أداء ممتاز",
      "أداء ممتاز",
    ];
    final List<String> improvements = ["إدارة الوقت", "التركيز"];

    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F1),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              // 1. الهيدر المحدث (تم تصغير الطول عبر زيادة المارجن الجانبي)
              _buildFixedHeader(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. صف الإحصائيات باستخدام الماب
                      _buildFullWidthStatsRow(subjectStats),

                      const SizedBox(height: 32),

                      // 3. الجزء السفلي الموزع
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // قائمة الاختبارات الديناميكية
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: examsData.map((exam) {
                                return _buildExamCard(
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

                          // نقاط القوة والضعف
                          Expanded(
                            flex: 1,
                            child: _buildSideSection(strengths, improvements),
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

  // الهيدر بتعديل المارجن ليكون "أصغر" في العرض
  Widget _buildFixedHeader() {
    return Container(
      width: double.infinity,
      height: 60,
      // زيادة المارجن الأفقي (من 16 إلى 40 مثلاً) تجعل الشريط يبدو أقصر
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
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
            IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: Color(0xFF009689),
              ),
            ),
            const Text(
              "المواد",
              style: TextStyle(color: Color(0xFF6A7282), fontSize: 14),
            ),
            const Icon(Icons.chevron_left, color: Colors.grey),
            Text(
              subjectName,
              style: const TextStyle(
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

  Widget _buildFullWidthStatsRow(Map<String, String> stats) {
    return Row(
      children: [
        Expanded(
          child: _statItem("أقل درجة", stats["min"]!, const Color(0xFFF6AD55)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statItem("أعلى درجة", stats["max"]!, const Color(0xFF4FB7B5)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statItem(
            "المعدل العام",
            stats["avg"]!,
            const Color(0xFF63B3ED),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statItem(
            "إجمالي الامتحانات",
            stats["count"]!,
            const Color(0xFFF6AD55),
          ),
        ),
      ],
    );
  }

  Widget _statItem(String label, String value, Color iconBg) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8),

      decoration: BoxDecoration(
        color: Colors.white,
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.all(6),
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
              Flexible(
                child: Text(
                  label,

                  style: const TextStyle(
                    color: Color(0xFF4A5565),
                    fontSize: 15,
                    fontFamily: "Arimo",
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamCard(
    String title,
    String grade,
    String date,
    String answers,
    String rating,
    String totalQuestions,
    String totalgrade,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        left: 0, // مارجن من اليسار
        right: 8, // مارجن من اليمين
        bottom: 20, // المارجن الأسفل الذي تريده
        top: 0, // من الأعلى (اختياري، القيمة الافتراضية 0)
      ),
      padding: const EdgeInsets.only(
        left: 20, // مارجن من اليسار
        right: 16, // مارجن من اليمين
        bottom: 16, // المارجن الأسفل الذي تريده
        top: 16, // من الأعلى (اختياري، القيمة الافتراضية 0)
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2939),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 119,

                      child: _badgeInfo("التاريخ", date),
                      padding: EdgeInsets.only(left: 30, right: 3),

                      decoration: BoxDecoration(
                        color: Color(0xFFF3F4F6),

                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 119,

                      child: _badgeInfo("الأسئلة", totalQuestions),
                      padding: EdgeInsets.only(left: 30, right: 3),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F4F6),

                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 119,

                      child: _badgeInfo("الإجابات", answers),

                      padding: EdgeInsets.only(left: 30, right: 3),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F4F6),

                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 119,
                      child: _badgeInfo("التقدير", rating, isBlue: true),

                      padding: EdgeInsets.only(left: 30, right: 3),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F4F6),

                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: // استبدل الـ Align والـ Container الداخلي بهذا الكود
                  InkWell(
                    onTap: () {
                      // نرسل اسم المادة أو معرف الاختبار للأب (الداش بورد)
                      onSubjectTap(subjectName);
                    },
                    child: // لا تنسى إضافة الودجت التي سيتم الضغط عليها هنا
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4DB8AC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "عرض التفاصيل",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
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
            width: 110,
            height: 140,
            decoration: BoxDecoration(
              color: Color(0xFF4FB7B5),

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
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "من ",
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
                Text(
                  totalgrade,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
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

  Widget _badgeInfo(String label, String value, {bool isBlue = false}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF718096)),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isBlue ? const Color(0xFFDBEAFE) : const Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isBlue ? const Color(0xFF1447E6) : const Color(0xFF2D3748),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSideSection(List<String> strengths, List<String> improvements) {
    return Column(
      children: [
        _sideCard(
          "نقاط القوة",
          strengths,
          const Color(0xFF4FB7B5),
          const Color(0xFFB9F8CF),
        ),
        const SizedBox(height: 20),
        _sideCard(
          "مجالات التحسين",
          improvements,
          const Color(0xFFF6AD55),
          const Color(0xFFFFD6A8),
        ),
      ],
    );
  }

  Widget _sideCard(
    String title,
    List<String> items,
    Color bgColor,
    Color bulletColor,
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
                  Text(
                    "• ",
                    style: TextStyle(color: bulletColor, fontSize: 18),
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
