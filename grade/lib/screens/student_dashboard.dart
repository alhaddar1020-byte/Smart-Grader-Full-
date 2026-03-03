import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../widgets/slider.dart'; // تأكدي أن هذا هو مسار ملف القائمة الجديد

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  // المتغير الوحيد للتحكم في القائمة المختار حالياً
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1440),
          child: Row(
            children: [
              // 1. المحتوى الرئيسي (Expanded يأخذ المساحة المتبقية)
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildTopStatsGrid(),
                      const SizedBox(height: 32),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLeftSummaryColumn(),
                          const SizedBox(width: 32),
                          _buildMainResultsList(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 2. استدعاء القائمة الجانبية من الملف الخارجي
              CustomSidebar(
                selectedIndex: selectedIndex,
                onItemSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- دوال المحتوى الرئيسي ---

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.primaryTeal,
                child: Icon(Icons.person, color: AppColors.textWhite, size: 30),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "أحمد محمد السعيد",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.textprimary,
                    ),
                  ),
                  Text(
                    "الصف الثاني الثانوي - علمي",
                    style: TextStyle(
                      color: AppColors.textseccondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "مرحباً أحمد!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2939),
                ),
              ),
              Text(
                "نتمنى لك يوماً دراسياً موفقاً",
                style: TextStyle(color: AppColors.textseccondary, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopStatsGrid() {
    return Row(
      children: [
        _statCard(
          "أعلى درجة",
          "95%",
          Icons.military_tech,
          AppColors.primaryTeal,
        ),
        const SizedBox(width: 20),
        _statCard(
          "المعدل العام",
          "87.5%",
          Icons.trending_up,
          AppColors.primaryTeal,
        ),
        const SizedBox(width: 20),
        _statCard(
          "الامتحانات المنشورة",
          "12",
          Icons.assignment,
          AppColors.primaryTeal,
        ),
        const SizedBox(width: 20),
        _statCard("المواد الدراسية", "6", Icons.book, AppColors.accentYellow),
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

  Widget _buildMainResultsList() {
    return Expanded(
      flex: 3,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: AppColors.textWhite,
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
            _resultItem(
              "85/100",
              "جيد جداً",
              "امتحان نهاية الفصل",
              "الرياضيات",
              "2026-01-25",
            ),
            _resultItem(
              "92/100",
              "ممتاز",
              "امتحان الوحدة الثالثة",
              "الفيزياء",
              "2026-01-22",
            ),
            _resultItem(
              "78/100",
              "جيد",
              "امتحان الفصل الأول",
              "الكيمياء",
              "2026-01-20",
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultItem(
    String score,
    String label,
    String title,
    String subject,
    String date,
  ) {
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
                score,
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
                  label,
                  style: const TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textprimary,
                ),
              ),
              Text(
                subject,
                style: const TextStyle(color: AppColors.textseccondary),
              ),
              Text(
                date,
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

  Widget _buildLeftSummaryColumn() {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: AppColors.textWhite,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.accentYellow,
                  radius: 35,
                  child: Icon(
                    Icons.star_rounded,
                    color: AppColors.textWhite,
                    size: 40,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "طالب متميز",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textprimary,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "حافظت على معدل أعلى من 85% في جميع المواد",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textseccondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          _buildPerformanceCard(),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard() {
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
              color: AppColors.textWhite,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          _rowInfo("12/15", "المواد المصححة"),
          const SizedBox(height: 10),
          const LinearProgressIndicator(
            value: 0.8,
            backgroundColor: Colors.white24,
            color: AppColors.textWhite,
          ),
          const SizedBox(height: 20),
          _rowInfo("100%", "معدل النجاح"),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.textWhite,
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
            color: AppColors.textWhite,
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
