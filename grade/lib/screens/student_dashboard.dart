import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentDashboard(),
    ),
  );
}

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFE8F4F2),
        body: Row(
          children: [
            // --- 1. القائمة الجانبية (Sidebar) ---
            const SidebarWidget(),

            // --- 2. المحتوى الرئيسي ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 30,
                ),
                child: Column(
                  children: [
                    // الهيدر مع خلفية بيضاء منحنية
                    const HeaderWidget(),
                    const SizedBox(height: 30),

                    // البطاقات الإحصائية
                    const StatsSection(),
                    const SizedBox(height: 30),

                    // القسم السفلي (الإنجازات والنتائج)
                    const BottomSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- مكون الهيدر العلوي (بخلفية بيضاء منحنية) ---
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // انحناء الحواف
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // جملة الترحيب (يمين)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "مرحباً أحمد!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D2838),
                ),
              ),
              Text(
                "نتمنى لك يوماً دراسياً موفقاً",
                style: TextStyle(color: Color(0xFF495565), fontSize: 16),
              ),
            ],
          ),
          // معلومات الطالب والتنبيهات (يسار)
          Row(
            children: [
              const Icon(
                Icons.notifications_none_outlined,
                color: Color(0xFF4FB7B5),
                size: 30,
              ),
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4F2),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          "أحمد محمد السعيد",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "الصف الثاني الثانوي - علمي",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF495565),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Color(0xFF4FB7B5)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- قسم البطاقات الإحصائية (الأيقونة على اليمين) ---
class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statCard(
          "المواد الدراسية",
          "6",
          const Color(0xFFF6AD55),
          Icons.book_outlined,
        ),
        const SizedBox(width: 20),
        _statCard(
          "الامتحانات المنشورة",
          "12",
          const Color(0xFF4FB7B5),
          Icons.assignment_outlined,
        ),
        const SizedBox(width: 20),
        _statCard(
          "المعدل العام",
          "87.5%",
          const Color(0xFF4FB7B5),
          Icons.analytics_outlined,
        ),
        const SizedBox(width: 20),
        _statCard(
          "أعلى درجة",
          "95%",
          const Color(0xFF4FB7B5),
          Icons.emoji_events_outlined,
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 24), // الأيقونة لليمين
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- قائمة النتائج (الأيقونة لليمين) ---
class RecentResults extends StatelessWidget {
  const RecentResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "النتائج الأخيرة",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          _resultItem(
            "امتحان نهاية الفصل",
            "الرياضيات",
            "85/100",
            "جيد جداً",
            "2026-01-25",
          ),
          _resultItem(
            "امتحان الوحدة الثالثة",
            "الفيزياء",
            "92/100",
            "ممتاز",
            "2026-01-22",
          ),
          _resultItem(
            "امتحان الفصل الأول",
            "الكيمياء",
            "78/100",
            "جيد",
            "2026-01-20",
          ),
        ],
      ),
    );
  }

  Widget _resultItem(
    String title,
    String subject,
    String score,
    String status,
    String date,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // الأيقونة في أقصى اليمين
          const Icon(
            Icons.description_outlined,
            color: Color(0xFF4DB8AC),
            size: 35,
          ),
          const SizedBox(width: 15),
          // تفاصيل المادة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subject,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          // الدرجة والحالة (يسار)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4DB8AC),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Color(0xFF1347E5),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- القائمة الجانبية (Sidebar) ---
class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Color(0xFF4FB7B5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(55),
          bottomLeft: Radius.circular(55),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 50),
          const Icon(Icons.grid_view_rounded, size: 60, color: Colors.white),
          const SizedBox(height: 10),
          const Text(
            "Intelligent Grading System",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 60),
          _sidebarItem(Icons.home_outlined, "لوحة التحكم", isSelected: true),
          _sidebarItem(Icons.book_outlined, "المواد"),
          _sidebarItem(Icons.settings_outlined, "اعدادات"),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String title, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFDDF6F5) : Colors.transparent,
        borderRadius: BorderRadius.circular(50),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF4FB7B5) : Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF4FB7B5) : Colors.white,
            fontSize: 18,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// --- باقي الأجزاء (الإنجازات وملخص الأداء) ---
class BottomSection extends StatelessWidget {
  const BottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(flex: 2, child: RecentResults()),
        const SizedBox(width: 25),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _achievementCard(),
              const SizedBox(height: 20),
              _performanceSummary(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _achievementCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: const [
          Icon(Icons.stars_rounded, size: 60, color: Color(0xFFF6AD55)),
          SizedBox(height: 15),
          Text(
            "طالب متميز",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            "حافظت على معدل أعلى من 85% في جميع المواد",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _performanceSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4DB8AC), Color(0xFF3DA89C)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ملخص الأداء",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          _progressRow("المواد المصححة", "12/15"),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.8,
            backgroundColor: Colors.white24,
            color: Colors.white,
            minHeight: 6,
          ),
          const SizedBox(height: 15),
          _progressRow("معدل النجاح", "100%"),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4DB8AC),
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
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

  Widget _progressRow(String label, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        Text(
          val,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
