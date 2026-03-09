import 'package:flutter/material.dart';
import '../core/colors.dart';
import 'student_matearial.dart';
import 'student_setting.dart';
import 'student_exim.dart';
import 'student_detiles.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  // 0: لوحة التحكم، 1: المواد، 2: الإعدادات، 4: الاختبارات
  int selectedIndex = 0;
  String? selectedSubjectName; // ✅ أضف هذا السطر هنا

  final Map<String, dynamic> studentData = {
    "name": "أحمد محمد السعيد",
    "level": "الصف الثاني الثانوي - علمي",
    "badge": "85",
    "stats": {
      "highest_score": "95%",
      "gpa": "87.5%",
      "exams_count": "12",
      "subjects_count": "6",
    },
    "recent_results": [
      {
        "score": "98%",
        "label": "ممتاز",
        "title": "اختبار منتصف الفصل",
        "subject": "الرياضيات",
        "date": "2024-03-01",
      },
      {
        "score": "85%",
        "label": "جيد جداً",
        "title": "اختبار الوحدة الثانية",
        "subject": "الفيزياء",
        "date": "2024-02-25",
      },
      {
        "score": "85%",
        "label": "جيد جداً",
        "title": "اختبار الوحدة الثانية",
        "subject": "الفيزياء",
        "date": "2024-02-25",
      },
    ],
    "performance": {
      "graded_count": "10/12",
      "progress_value": 0.8,
      "success_rate": "92%",
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 252, 252),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(color: Color(0xFFDEF6F5)),
          child: Row(
            children: [
              // المنطقة المتغيرة (المحتوى الهيدر + الصفحة الحالية)
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                      child: _buildHeader(
                        studentData["name"],
                        studentData["level"],
                      ),
                    ),
                    Expanded(child: _buildBody()),
                  ],
                ),
              ),

              // القائمة الجانبية الموحدة
              CustSidebar(
                selectedIndex: selectedIndex,
                onItemSelected: (index) {
                  setState(() {
                    selectedIndex = index;

                    if (index != 4) {
                      selectedSubjectName = null;
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // داخل دالة الـ build الخاصة بالداشبورد (مكان الـ switch)
  Widget _buildBody() {
    switch (selectedIndex) {
      case 0:
        return _buildDashboardHome();

      case 1:
        return SubjectsScreen(
          // ✅ تأكدي أنكِ تمررين المتغير هنا وليس نصاً فارغاً ""
          subjectName: selectedSubjectName ?? "",
          onBack: () => setState(() => selectedIndex = 0),
          onSubjectTap: (name) {
            setState(() {
              selectedSubjectName = name;
              selectedIndex = 4; // ينتقل للاختبار
            });
          },
        );

      case 4:
        return StudentExamScreen(
          subjectName: selectedSubjectName ?? "المادة", // لن يظهر خطأ الآن
          onBack: () {
            // ✅ عند الضغط على اسم المادة في الـ breadcrumb يرجعه للمواد
            // ولا نصفر الاسم لكي تفتح صفحة المواد على "التفاصيل"
            setState(() => selectedIndex = 1);
          },
          onItemSelected: (index) {
            setState(() {
              if (index == 1)
                selectedSubjectName = null; // إذا ضغط "المواد" نصفر الاسم
              selectedIndex = index;
            });
          },
        );

      default:
        return const SettingsScreen();
    }
  }

  Widget _buildDashboardHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
    );
  }

  // --- دوال بناء الواجهة (نفس كودك السابق للأداء والإحصائيات) ---
  Widget _buildHeader(String name, String level) {
    String subTitle;
    switch (selectedIndex) {
      case 0:
        subTitle = "نتمنى لك يوماً دراسياً موفقاً";
        break;
      case 1:
        subTitle = "استكشف موادك الدراسية وتابع تقدمك";
        break;
      case 2:
        subTitle = "تخصيص إعدادات الحساب والتطبيقات";
        break;
      case 4:
        subTitle = "تفاصيل الاختبار والمراجعة النهائية";
        break;
      default:
        subTitle = "مرحباً بك في نظام التصحيح الذكي";
    }
    return Container(
      height: 101,
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      level,
                      style: TextStyle(
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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AnimatedSwitcher(
                // أضفت لك تأثير انتقال ناعم عند تغير النص
                duration: const Duration(milliseconds: 300),
                child: Text(
                  subTitle,
                  key: ValueKey<String>(
                    subTitle,
                  ), // مهم لعمل الـ AnimatedSwitcher
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
          "الامتحانات",
          stats["exams_count"]!,
          Icons.assignment,
          AppColors.primaryTeal,
        ),
        const SizedBox(width: 20),
        _statCard(
          "المواد",
          stats["subjects_count"]!,
          Icons.book,
          AppColors.accentYellow,
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color cardColor) {
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
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: cardColor == AppColors.accentYellow
                        ? AppColors.accentYellow
                        : AppColors.primaryTeal,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
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

  Widget _buildMainResultsList(List<dynamic> results) {
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
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            ...results
                .map((res) => _resultItem(res as Map<String, String>))
                .toList(),
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
              Text(
                data["label"]!,
                style: const TextStyle(color: Colors.blue, fontSize: 12),
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
                ),
              ),
              Text(
                data["subject"]!,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  "حافظت على معدل $badge%",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
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
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryTeal,
              minimumSize: const Size(double.infinity, 50),
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
          ),
        ),
        Text(title, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

// --- القائمة الجانبية (المصلحة بالكامل) ---
class CustSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF4FB7B5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(55),
          bottomLeft: Radius.circular(55),
        ),
      ),
      child: Column(
        children: [
          _buildLogoSection(
            icon: Icons.check_circle_outline,
            title: "Intelligent\nGrading System",
          ),
          const SizedBox(height: 20),
          _menuItem("لوحة التحكم", Icons.home_rounded, 0),
          _menuItem("المواد", Icons.library_books, 1),
          _menuItem("إعدادات", Icons.settings_rounded, 2),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _menuItem(String title, IconData icon, int index) {
    // شرط الإضاءة: يعمل إذا كان الاندكس مطابقاً أو إذا كنا في صفحة الاختبار (4) وزر المواد (1) هو المعروض
    bool isActive =
        (selectedIndex == index) || (index == 1 && selectedIndex == 4);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () => onItemSelected(index),
        hoverColor: Colors.transparent,

        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerLeft,
          children: [
            if (isActive)
              Positioned(
                left: 0,
                top: -38,
                bottom: -38,
                width: 50,
                child: CustomPaint(
                  painter: SidebarCurvePainter(const Color(0xFFDEF6F5)),
                ),
              ),
            Container(
              height: 60,
              margin: EdgeInsets.only(left: isActive ? 0 : 25, right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFDEF6F5) : Colors.transparent,
                borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(30),
                  bottomRight: const Radius.circular(30),
                  topLeft: Radius.circular(isActive ? 0 : 30),
                  bottomLeft: Radius.circular(isActive ? 0 : 30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isActive ? const Color(0xFF4FB7B5) : Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Icon(icon, color: AppColors.accentYellow, size: 26),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection({required IconData icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 30),
      child: Column(
        children: [
          Icon(icon, size: 60, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarCurvePainter extends CustomPainter {
  final Color bgColor;
  SidebarCurvePainter(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;

    double radius = 35;
    double topY = 38;
    double bottomY = topY + 60;

    Path pathTop = Path();
    pathTop.moveTo(0, topY - radius);
    pathTop.quadraticBezierTo(0, topY, radius, topY);
    pathTop.lineTo(0, topY);
    pathTop.close();
    canvas.drawPath(pathTop, paint);

    Path pathBottom = Path();
    pathBottom.moveTo(0, bottomY + radius);
    pathBottom.quadraticBezierTo(0, bottomY, radius, bottomY);
    pathBottom.lineTo(0, bottomY);
    pathBottom.close();
    canvas.drawPath(pathBottom, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
