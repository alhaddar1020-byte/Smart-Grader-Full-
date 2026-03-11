import 'package:flutter/material.dart';
import '../core/colors.dart';
import 'student_matearial.dart';
import 'student_setting.dart';
import 'student_exim.dart';
import 'student_detiles.dart';
import 'student_detiles.dart';
import 'student_matearial.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int selectedIndex = 0;
  String? selectedSubjectName;

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
      // استخدام لون خلفية التطبيق من AppColors
      backgroundColor: AppColors.secondaryTeal(context),
      body: Center(
        child: Container(
          // استخدام لون الخلفية المساعد (secondary) بدلاً من الكود الثابت
          decoration: BoxDecoration(color: AppColors.secondaryTeal(context)),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                      child: _buildHeader(
                        context, // تمرير الكونتكس للألوان
                        studentData["name"],
                        studentData["level"],
                      ),
                    ),
                    Expanded(child: _buildBody()),
                  ],
                ),
              ),
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

  Widget _buildBody() {
    switch (selectedIndex) {
      case 0:
        return _buildDashboardHome();
      case 1:
        return SubjectsScreen(
          subjectName: selectedSubjectName ?? "",
          onBack: () => setState(() => selectedIndex = 0),
          onSubjectTap: (name) {
            setState(() {
              selectedSubjectName = name;
              selectedIndex = 4;
            });
          },
        );
      case 4:
        return StudentExamScreen(
          subjectName: selectedSubjectName ?? "المادة",
          onBack: () => setState(() => selectedIndex = 1),
          onItemSelected: (index) {
            setState(() {
              if (index == 1) selectedSubjectName = null;
              selectedIndex = index;
            });
          },
        );
      default:
        return const SettingsScreen();
    }
  }

  Widget _buildDashboardHome() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // قسم الإحصائيات العلوية - ارتفاع ثابت
          _buildTopStatsGrid(context, studentData["stats"]),

          const SizedBox(height: 32),

          // الجزء السفلي - نستخدم Expanded ليأخذ باقي مساحة الشاشة
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العمود الأيسر (ملخص الأداء)
                _buildLeftSummaryColumn(
                  context,
                  studentData["performance"],
                  studentData["badge"],
                ),
                const SizedBox(width: 32),
                // العمود الأيمن (النتائج الأخيرة)
                _buildMainResultsList(context, studentData["recent_results"]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name, String level) {
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
        color: AppColors.cardBg(context), // لون الكارد متفاعل مع الدارك مود
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
              color: AppColors.secondaryTeal(context).withOpacity(0.5),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    Text(
                      level,
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryTeal(context),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
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
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  subTitle,
                  key: ValueKey<String>(subTitle),
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopStatsGrid(BuildContext context, Map<String, String> stats) {
    return Row(
      children: [
        _statCard(
          context,
          "أعلى درجة",
          stats["highest_score"]!,
          Icons.military_tech,
          AppColors.primaryTeal(context),
        ),
        const SizedBox(width: 20),
        _statCard(
          context,
          "المعدل العام",
          stats["gpa"]!,
          Icons.trending_up,
          AppColors.primaryTeal(context),
        ),
        const SizedBox(width: 20),
        _statCard(
          context,
          "الامتحانات",
          stats["exams_count"]!,
          Icons.assignment,
          AppColors.primaryTeal(context),
        ),
        const SizedBox(width: 20),
        _statCard(
          context,
          "المواد",
          stats["subjects_count"]!,
          Icons.book,
          AppColors.accentYellow(context),
        ),
      ],
    );
  }

  Widget _statCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color cardColor,
  ) {
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
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: cardColor, size: 25),
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

  Widget _buildMainResultsList(BuildContext context, List<dynamic> results) {
    final lastThreeResults = results.take(3).toList();

    return Expanded(
      flex: 3,
      child: Container(
        padding: const EdgeInsets.all(24), // تقليل البادينج قليلاً لتوفير مساحة
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => setState(() => selectedIndex = 1),
                  child: Text(
                    "عرض جميع المواد",
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "النتائج الأخيرة",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // نستخدم Expanded مع ListView هنا لضمان عدم حدوث Overflow
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // لمنع السكرول الداخلي إذا كانت الشاشة تكفي
                itemCount: lastThreeResults.length,
                itemBuilder: (context, index) {
                  return _resultItem(
                    context,
                    lastThreeResults[index] as Map<String, String>,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultItem(BuildContext context, Map<String, String> data) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSubjectName =
              data["subject"]; // نحدد اسم المادة التي ضغطنا عليها
          selectedIndex =
              4; // ننتقل لصفحة تفاصيل الاختبار (التي تحمل رقم 4 في كودك)
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg(context).withOpacity(0.5),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // جزء الدرجة (Score)
            Column(
              children: [
                Text(
                  data["score"]!,
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
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
            // جزء اسم المادة والوصف
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data["title"]!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                Text(
                  data["subject"]!,
                  style: TextStyle(color: AppColors.textSecondary(context)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSummaryColumn(
    BuildContext context,
    Map<String, dynamic> perf,
    String badge,
  ) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          // كارد الطالب المتميز
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBg(context),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.accentYellow(context),
                  radius: 30, // تصغير بسيط للقطر
                  child: const Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "طالب متميز",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                Text(
                  "حافظت على معدل $badge%",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // كارد ملخص الأداء - نجعله مرن
          Expanded(child: _buildPerformanceCard(context, perf)),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(
    BuildContext context,
    Map<String, dynamic> perf,
  ) {
    // --- التعديل هنا: المتغيرات التي ستحمل الأرقام ---
    final String gradedCount = "12/15"; // الرقم الذي سيظهر في "المواد المصححة"
    final String successRate = "100%"; // الرقم الذي سيظهر في "معدل النجاح"

    // دالة تحول "12/15" إلى نسبة مئوية لتحريك الشريط
    double calculateProgress() {
      try {
        List<String> parts = gradedCount.split('/');
        return double.parse(parts[0]) / double.parse(parts[1]);
      } catch (e) {
        return 0.0;
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 400, minWidth: 250),
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            // --- التعديل هنا: إضافة التدرج اللوني كما في التصميم ---
            color: AppColors.primaryTeal(context),

            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "ملخص الأداء",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // عرض الرقم الأول
              _rowInfoDesign(gradedCount, "المواد المصححة"),

              const SizedBox(height: 16),

              // شريط التقدم الذي يحسب النسبة تلقائياً
              _buildResponsiveProgressBar(calculateProgress()),

              const SizedBox(height: 16),

              // عرض الرقم الثاني
              _rowInfoDesign(successRate, "معدل النجاح"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResponsiveProgressBar(double progress) {
    return Stack(
      children: [
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(268435),
          ),
        ),
        // LayoutBuilder هنا يضمن أن الشريط الأبيض يتحرك بدقة بناءً على عرض الأب
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: 8,
              width: constraints.maxWidth * progress,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(268435),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _rowInfoDesign(String value, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // استخدام FittedBox لضمان عدم خروج النص عن الحواف في الشاشات الصغيرة جداً
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ],
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

// --- القائمة الجانبية المحدثة بالألوان الديناميكية ---
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
      decoration: BoxDecoration(
        color: AppColors.primaryTeal(context), // لون السايدبار الأساسي
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(55),
          bottomLeft: Radius.circular(55),
        ),
      ),
      child: Column(
        children: [
          _buildLogoSection(
            icon: Icons.auto_awesome,
            title: "Intelligent\nGrading System",
          ),
          const SizedBox(height: 20),
          _menuItem(context, "لوحة التحكم", Icons.home_rounded, 0),
          _menuItem(context, "المواد", Icons.library_books, 1),
          _menuItem(context, "إعدادات", Icons.settings_rounded, 2),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    String title,
    IconData icon,
    int index,
  ) {
    bool isActive =
        (selectedIndex == index) || (index == 1 && selectedIndex == 4);
    Color activeBg = AppColors.secondaryTeal(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () => onItemSelected(index),
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
                child: CustomPaint(painter: SidebarCurvePainter(activeBg)),
              ),
            Container(
              height: 60,
              margin: EdgeInsets.only(left: isActive ? 0 : 25, right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isActive ? activeBg : Colors.transparent,
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
                      color: isActive
                          ? AppColors.primaryTeal(context)
                          : Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Icon(icon, color: AppColors.accentYellow(context), size: 26),
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
