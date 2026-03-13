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
        bool isMobile = constraints.maxWidth < 650;
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
        SizedBox(height: isMobile ? 15 : 32),

        // القسم المتوسط (البوكسات)
        if (isMobile)
          Column(
            children: [
              // في الجوال: الطالب المتميز والملخص بجانب بعضهما (Row)
              Row(
                children: [
                  Expanded(
                    child: _buildPerformanceCard(
                      context,
                      studentData["performance"],
                      isSmall: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildBadgeCard(
                      context,
                      studentData["badge"],
                      isSmall: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 15 : 23),
              // النتائج الأخيرة تأخذ العرض الكامل بالأسفل
              _buildMainResultsList(
                context,
                studentData["recent_results"],
                isMobile: true,
              ),
            ],
          )
        else
          // في التابلت والويب: الطالب والملخص في عمود جانبي، والنتائج بجانبهما
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildBadgeCard(
                      context,
                      studentData["badge"],
                      isSmall: isTablet,
                    ),
                    const SizedBox(height: 20),
                    _buildPerformanceCard(
                      context,
                      studentData["performance"],
                      isSmall: isTablet,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              _buildMainResultsList(
                context,
                studentData["recent_results"],
                isMobile: false,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, String name, String level) {
    // تحديد حجم الخط بناءً على عرض الشاشة
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth < 1100; // تابلت أو أقل

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
          // القسم الأيمن: صورة الملف الشخصي والاسم (مغلف بـ Flexible لمنع الـ Overflow)
          Flexible(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.secondaryTeal(context).withOpacity(0.5),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // نصوص الملف الشخصي (تتأثر بالحجم)
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen
                                ? 14
                                : 16, // تصغير الخط في التابلت
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        Text(
                          level,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textSecondary(context),
                            fontSize: isSmallScreen
                                ? 10
                                : 12, // تصغير الخط في التابلت
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    radius: isSmallScreen ? 18 : 20,
                    backgroundColor: AppColors.primaryTeal(context),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10), // مسافة أمان صغيرة
          // القسم الأيسر: رسالة الترحيب (مغلف بـ Expanded ليأخذ المساحة المتبقية فقط)
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "مرحباً ${name.split(' ')[0]}!",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 22, // تصغير الخط في التابلت
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    subTitle,
                    key: ValueKey(subTitle),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: isSmallScreen
                          ? 12
                          : 14, // تصغير الخط في التابلت
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

  Widget _buildTopStatsGrid(
    BuildContext context,
    Map<String, dynamic> stats,
    bool isMobile,
    bool isTablet,
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

    if (isMobile) {
      return SingleChildScrollView(
        reverse: true, // اتركيها false للغة العربية
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              Container(
                width: MediaQuery.of(context).size.width * 0.42,
                margin: EdgeInsetsDirectional.only(
                  // نستخدم end لتعني "اليسار" في العربية و "اليمين" في الإنجليزية
                  end: i == children.length - 1 ? 0 : 12,
                ),
                child: children[i],
              ),
            ],
          ],
        ),
      );
    }
    // حالة التابلت والويب
    return Row(
      children: [
        for (int i = 0; i < children.length; i++) ...[
          Expanded(child: children[i]),
          // إضافة مسافة فقط إذا لم يكن هذا هو الكرت الأخير
          if (i != children.length - 1) const SizedBox(width: 16),
        ],
      ],
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
                  fontSize: isTablet ? 11 : 16,
                  fontWeight: FontWeight.bold,
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

  Widget _buildMainResultsList(
    BuildContext context,
    List<dynamic> results, {
    bool isMobile = false,
  }) {
    return Expanded(
      flex: isMobile
          ? 0
          : 3, // في الجوال لا نستخدم flex كبير لمنع التمدد الزائد
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ليأخذ حجم المحتوى فقط
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
                  _resultItem(context, results[index], isMobile: isMobile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultItem(
    BuildContext context,
    Map<String, dynamic> data, {
    bool isMobile = false,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSubjectName = data["subject"];
          selectedIndex = 4;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg(context).withOpacity(0.5),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // النتيجة والتقييم (يسار)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
            // اسم المادة والاختبار (يمين)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data["title"]!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 13 : 15,
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

  Widget _buildBadgeCard(
    BuildContext context,
    String badge, {
    bool isSmall = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: isSmall ? 12 : 20,
        right: isSmall ? 12 : 20,
        bottom: isSmall ? 23 : 2,
        top: isSmall ? 23 : 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.accentYellow(context),
            radius: isSmall ? 20 : 30, // تصغير الأيقونة
            child: Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: isSmall ? 25 : 35,
            ),
          ),
          SizedBox(height: isSmall ? 5 : 10),
          Text(
            "طالب متميز",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isSmall ? 12 : 16,
              color: AppColors.textPrimary(context),
            ),
          ),
          Text(
            "معدل %$badge",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: isSmall ? 10 : 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(
    BuildContext context,
    Map<String, dynamic>? perf, { // يقبل بيانات حقيقية
    bool isSmall = false,
  }) {
    // 1. استخراج البيانات أو وضع قيم افتراضية (كما في كودك القديم)
    final String gradedCount = perf?["graded_count"] ?? "0/0";
    final String successRate = perf?["success_rate"] ?? "0%";

    // 2. منطق الحساب الذكي الذي كان في كودك (مهم جداً للربط مع قاعدة البيانات)
    double calculateProgress() {
      try {
        List<String> parts = gradedCount.split('/');
        double current = double.parse(parts[0]);
        double total = double.parse(parts[1]);
        return (total > 0) ? (current / total) : 0.0;
      } catch (e) {
        return 0.0;
      }
    }

    // 3. التصميم المستجيب باستخدام قيم isSmall
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmall ? 12 : 24), // يتغير الحجم حسب الشاشة
      decoration: BoxDecoration(
        color: AppColors.primaryTeal(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "ملخص الأداء",
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmall ? 14 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: isSmall ? 12 : 16),

          // عرض الرقم الأول (المواد المصححة)
          _rowInfoDesign(
            gradedCount,
            isSmall ? "المنتهية" : "المواد المصححة",
            isSmall,
          ),

          SizedBox(height: isSmall ? 12 : 16),

          // شريط التقدم المستجيب (من كودك القديم)
          _buildResponsiveProgressBar(calculateProgress(), isSmall),

          SizedBox(height: isSmall ? 5 : 16),

          // عرض الرقم الثاني (معدل النجاح)
          _rowInfoDesign(successRate, "معدل النجاح", isSmall),
        ],
      ),
    );
  }

  // دالة الصف (المعدلة لتناسب الحجمين)
  Widget _rowInfoDesign(String value, String title, bool isSmall) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmall ? 16 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            title,
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.white, fontSize: isSmall ? 11 : 14),
          ),
        ),
      ],
    );
  }

  // شريط التقدم (المحسن من كودك)
  Widget _buildResponsiveProgressBar(double progress, bool isSmall) {
    return Stack(
      children: [
        Container(
          height: isSmall ? 6 : 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: isSmall ? 6 : 8,
              width: constraints.maxWidth * progress.clamp(0.0, 1.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          },
        ),
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
