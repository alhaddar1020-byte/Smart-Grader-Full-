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
  int selectedIndex = 0;
  String? selectedSubjectName;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        bool isTablet =
            constraints.maxWidth >= 600 && constraints.maxWidth < 1100;
        bool isWeb = constraints.maxWidth >= 1100;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.secondaryTeal(context),
          endDrawer: isMobile
              ? Drawer(
                  width: 280,
                  backgroundColor: Colors.transparent,
                  child: CustSidebar(
                    isCompact: false,
                    selectedIndex: selectedIndex,
                    onItemSelected: (index) {
                      setState(() => selectedIndex = index);
                      _scaffoldKey.currentState?.closeEndDrawer();
                    },
                  ),
                )
              : null,
          body: Row(
            children: [
              // 1. المحتوى الأساسي مع التمرير
              Expanded(
                child: Column(
                  children: [
                    if (isMobile) _buildMobileTopBar(),
                    if (!isMobile)
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          isWeb ? 32 : 16,
                          32,
                          isWeb ? 32 : 16,
                          0,
                        ),
                        child: _buildHeader(
                          context,
                          studentData["name"],
                          studentData["level"],
                        ),
                      ),
                    // استخدمنا Expanded هنا لضمان أن الجسم يأخذ المساحة المتبقية
                    // لكن داخله يجب أن يكون هناك تمرير
                    Expanded(child: _buildBody(isMobile, isTablet, isWeb)),
                  ],
                ),
              ),
              // 2. السايدبار في اليمين
              if (!isMobile)
                CustSidebar(
                  isCompact: isTablet,
                  selectedIndex: selectedIndex,
                  onItemSelected: (index) =>
                      setState(() => selectedIndex = index),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(bool isMobile, bool isTablet, bool isWeb) {
    switch (selectedIndex) {
      case 0:
        return SingleChildScrollView(
          padding: EdgeInsets.all(isWeb ? 32 : 16),
          child: _buildDashboardHome(isMobile, isTablet),
        );
      case 1:
        // تم إصلاح الخطأ هنا بتمرير subjectName و onBack
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
      case 2:
        return const SettingsScreen();
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
        return const Center(child: Text("الصفحة غير موجودة"));
    }
  }

  Widget _buildMobileTopBar() {
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
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // لتوزيع العناصر على الأطراف
        children: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Color.fromARGB(255, 99, 98, 98),
              size: 30,
            ),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          // نص الترحيب في جهة اليمين
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "مرحباً ${studentData["name"].split(' ')[0]}!",
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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

          // زر القائمة في جهة اليسار
        ],
      ),
    );
  }

  Widget _buildDashboardHome(bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopStatsGrid(context, studentData["stats"], isMobile, isTablet),
        const SizedBox(height: 32),
        if (isMobile)
          Column(
            children: [
              _buildPerformanceSection(
                context,
                studentData["performance"],
                studentData["badge"],
              ),
              const SizedBox(height: 20),
              _buildMainResultsList(context, studentData["recent_results"]),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLeftSummaryColumn(
                context,
                studentData["performance"],
                studentData["badge"],
              ),
              const SizedBox(width: 32),
              _buildMainResultsList(context, studentData["recent_results"]),
            ],
          ),
      ],
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
        color: AppColors.cardBg(context),
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
                  key: ValueKey(subTitle),
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

  Widget _buildTopStatsGrid(
    BuildContext context,
    Map<String, dynamic> stats,
    bool isMobile,
    bool isTablet, // أضفنا هذا المتغير
  ) {
    var children = [
      _statCard(
        context,
        "أعلى درجة",
        stats["highest_score"]!,
        Icons.military_tech,
        AppColors.primaryTeal(context),
        isTablet,
      ),
      _statCard(
        context,
        "المعدل العام",
        stats["gpa"]!,
        Icons.trending_up,
        AppColors.primaryTeal(context),
        isTablet,
      ),
      _statCard(
        context,
        "الامتحانات",
        stats["exams_count"]!,
        Icons.assignment,
        AppColors.primaryTeal(context),
        isTablet,
      ),
      _statCard(
        context,
        "المواد",
        stats["subjects_count"]!,
        Icons.book,
        AppColors.accentYellow(context),
        isTablet,
      ),
    ];

    // حالة الويب: صف واحد ثابت متساوي الأحجام
    if (isMobile) {
      return SingleChildScrollView(
        // جعل التمرير يبدأ من اليمين (يناسب اللغة العربية)
        reverse: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: children
              .map(
                (e) => Container(
                  width: MediaQuery.of(context).size.width * 0.42,
                  // غيري الهامش ليكون جهة اليمين ليظهر الفراغ بشكل صحيح في الاتجاه العربي
                  margin: const EdgeInsets.only(right: 12),
                  child: e,
                ),
              )
              .toList(),
        ),
      );
    }
    // حالة التابلت والويب: صف واحد ثابت (No Scroll)
    return Row(
      children: children
          .map(
            (e) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: e,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _statCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color cardColor,
    bool isTablet, // أضفنا هذا المتغير
  ) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 12 : 17), // تقليل البادينق في التابلت
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 11 : 16, // تصغير الخط
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                icon,
                color: Colors.white,
                size: isTablet ? 16 : 20,
              ), // تصغير الأيقونة
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 18 : 22, // تصغير القيمة
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainResultsList(BuildContext context, List<dynamic> results) {
    return Expanded(
      flex: 3,
      child: Container(
        padding: const EdgeInsets.all(24),
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.take(3).length,
              itemBuilder: (context, index) =>
                  _resultItem(context, results[index]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultItem(BuildContext context, Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSubjectName = data["subject"];
          selectedIndex = 4;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg(context).withOpacity(0.5),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  data["score"]!,
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  data["label"]!,
                  style: const TextStyle(color: Colors.blue, fontSize: 11),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data["title"]!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                Text(
                  data["subject"]!,
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 12,
                  ),
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
          _buildBadgeCard(context, badge),
          const SizedBox(height: 20),
          _buildPerformanceCard(context, perf),
        ],
      ),
    );
  }

  Widget _buildPerformanceSection(
    BuildContext context,
    Map<String, dynamic> perf,
    String badge,
  ) {
    return Column(
      children: [
        _buildBadgeCard(context, badge),
        const SizedBox(height: 20),
        _buildPerformanceCard(context, perf),
      ],
    );
  }

  Widget _buildBadgeCard(BuildContext context, String badge) {
    return Container(
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
            radius: 30,
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
    );
  }

  Widget _buildPerformanceCard(
    BuildContext context,
    Map<String, dynamic> perf,
  ) {
    final String gradedCount = perf["graded_count"] ?? "0/0";
    final String successRate = perf["success_rate"] ?? "0%";

    double calculateProgress() {
      try {
        List<String> parts = gradedCount.split('/');
        return double.parse(parts[0]) / double.parse(parts[1]);
      } catch (e) {
        return 0.0;
      }
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
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
          _rowInfoDesign(gradedCount, "المواد المصححة"),
          const SizedBox(height: 16),
          _buildProgressBar(calculateProgress()),
          const SizedBox(height: 16),
          _rowInfoDesign(successRate, "معدل النجاح"),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      height: 8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _rowInfoDesign(String value, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }
}

class CustSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool isCompact;

  const CustSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد ما إذا كان الجهاز جوال بناءً على العرض
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isCompact ? 110 : 280,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryTeal(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(55),
          bottomLeft: Radius.circular(55),
        ),
      ),
      child: Column(
        children: [
          _buildLogoSection(isCompact),
          const SizedBox(height: 20),
          _menuItem(context, "لوحة التحكم", Icons.home_rounded, 0, isMobile),
          _menuItem(context, "المواد", Icons.library_books, 1, isMobile),
          _menuItem(context, "إعدادات", Icons.settings_rounded, 2, isMobile),
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
    bool isMobile, // أضفنا المتغير هنا
  ) {
    bool isActive =
        (selectedIndex == index) || (index == 1 && selectedIndex == 4);
    Color activeBg = AppColors.secondaryTeal(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () => onItemSelected(index),
        child: Stack(
          alignment: Alignment.centerLeft,
          clipBehavior: Clip.none,
          children: [
            // تظهر الفجوة فقط إذا كان العنصر نشطاً و الجهاز ليس جوالاً
            if (isActive && !isMobile)
              Positioned(
                left: 0,
                top: -38,
                bottom: -38,
                width: 50,
                child: CustomPaint(painter: SidebarCurvePainter(activeBg)),
              ),
            Container(
              height: 60,
              margin: EdgeInsets.only(
                // في الجوال يبتعد عن الحافة، في التابلت والويب يلتصق
                left: isMobile ? 12 : (isActive ? 0 : 25),
                right: isCompact ? 10 : 20,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isActive ? activeBg : Colors.transparent,
                // حواف دائرية كاملة للجوال فقط
                borderRadius: isMobile
                    ? BorderRadius.circular(30)
                    : BorderRadius.only(
                        topRight: const Radius.circular(30),
                        bottomRight: const Radius.circular(30),
                        topLeft: Radius.circular(isActive ? 0 : 30),
                        bottomLeft: Radius.circular(isActive ? 0 : 30),
                      ),
              ),
              child: Row(
                mainAxisAlignment: isCompact
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.end,
                children: [
                  if (!isCompact)
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: isActive
                              ? AppColors.primaryTeal(context)
                              : Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  if (!isCompact) const SizedBox(width: 15),
                  Icon(icon, color: AppColors.accentYellow(context), size: 26),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection(bool isCompact) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 30),
      child: Column(
        children: [
          Icon(
            Icons.auto_awesome,
            size: isCompact ? 40 : 60,
            color: Colors.white,
          ),
          if (!isCompact) ...[
            const SizedBox(height: 10),
            const Text(
              "نظام التصحيح الذكي",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
