import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/locale_provider.dart';
import '../core/colors.dart';
import 'student_matearial.dart';
import 'student_setting.dart';
import 'student_exim.dart';
import 'student_detiles.dart';
import '../generated/l10n.dart';

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
      },
      {
        "score": "85%",
        "label": "جيد جداً",
        "title": "اختبار الوحدة الثانية",
        "subject": "الفيزياء",
      },
      {
        "score": "85%",
        "label": "جيد جداً",
        "title": "اختبار الوحدة الثانية",
        "subject": "الفيزياء",
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
    final localeProvider = Provider.of<LocaleProvider>(context);
    final bool isArabic = localeProvider.locale.languageCode == 'ar';

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        bool isMobile = width < 600;
        bool isTablet = width >= 600 && width < 1100;
        bool isWeb = width >= 1100;

        // الهامش العام (13 للجوال و 30 للويب/تابلت)
        double currentPadding = isMobile ? 13.0 : 30.0;
        // قرار التمرير للإحصائيات (أقل من 900 بكسل تلتصق بالحافة)
        bool shouldStatsScroll = width < 900;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.secondaryTeal(context),
          drawer: isMobile
              ? Drawer(
                  width: 280,
                  backgroundColor: Colors.transparent,
                  child: CustSidebar(
                    isCompact: false,
                    selectedIndex: selectedIndex,
                    isArabic: isArabic,
                    onItemSelected: _handleNavigation,
                  ),
                )
              : null,
          body: Row(
            children: [
              if (!isMobile)
                CustSidebar(
                  isCompact: isTablet,
                  selectedIndex: selectedIndex,
                  isArabic: isArabic,
                  onItemSelected: _handleNavigation,
                ),
              Expanded(
                child: Column(
                  children: [
                    if (isMobile) _buildMobileTopBar(),
                    if (!isMobile)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          currentPadding,
                          32,
                          currentPadding,
                          0,
                        ),
                        child: _buildHeader(context, isWeb, currentPadding),
                      ),
                    Expanded(
                      child: _buildBody(
                        isMobile,
                        isTablet,
                        isWeb,
                        isArabic,
                        shouldStatsScroll,
                        currentPadding,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleNavigation(int index) {
    setState(() {
      if (index == 1) selectedSubjectName = null;
      selectedIndex = index;
    });
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      _scaffoldKey.currentState?.closeDrawer();
    }
  }

  Widget _buildMobileTopBar() {
    String subTitle;
    switch (selectedIndex) {
      case 0:
        subTitle = S.of(context).goodDay;
        break;
      case 1:
        subTitle = S.of(context).subExplore;
        break;
      case 2:
        subTitle = S.of(context).subSettings;
        break;
      case 4:
        subTitle = S.of(context).subExam;
        break;
      default:
        subTitle = S.of(context).appName;
    }
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
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
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF636262), size: 30),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).welcome(studentData["name"].split(' ')[0]),
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

  Widget _buildBody(
    bool isMobile,
    bool isTablet,
    bool isWeb,
    bool isArabic,
    bool shouldStatsScroll,
    double contentPadding,
  ) {
    switch (selectedIndex) {
      case 0:
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ), // نلغي الأفقي هنا للتحكم اليدوي
          child: _buildDashboardHome(
            isMobile,
            isTablet,
            isArabic,
            shouldStatsScroll,
            contentPadding,
          ),
        );
      case 1:
        return SubjectsScreen(
          subjectName: "",
          onBack: () => setState(() => selectedIndex = 0),
          onSubjectTap: (name) => setState(() {
            selectedSubjectName = name;
            selectedIndex = 4;
          }),
        );
      case 2:
        return const SettingsScreen();
      case 4:
        return SubjectsScreen(
          subjectName: selectedSubjectName ?? "",
          onBack: () => setState(() => selectedIndex = 1),
          onSubjectTap: (name) => setState(() {
            selectedSubjectName = name;
            selectedIndex = 5;
          }),
        );
      case 5:
        return StudentExamScreen(
          subjectName: selectedSubjectName ?? "",
          onBack: () => setState(() => selectedIndex = 4),
          onItemSelected: _handleNavigation,
        );
      default:
        return Center(child: Text(S.of(context).pageNotFound));
    }
  }

  Widget _buildDashboardHome(
    bool isMobile,
    bool isTablet,
    bool isArabic,
    bool shouldStatsScroll,
    double contentPadding,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الإحصائيات: تلتصق بالحافة (0) في وضع التمرير
        _buildTopStatsGrid(
          context,
          isMobile,
          isTablet,
          shouldStatsScroll,
          contentPadding,
        ),

        const SizedBox(height: 15),

        // المحتوى الباقي: يلتزم بالهامش (13 للجوال و 30 للويب)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: contentPadding),
          child: isMobile
              ? Column(
                  children: [
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
                    const SizedBox(height: 15),
                    _buildMainResultsList(isMobile: true),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainResultsList(isMobile: false),
                    const SizedBox(width: 32),
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
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildTopStatsGrid(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    bool shouldScroll,
    double contentPadding,
  ) {
    var stats = studentData["stats"];
    var children = [
      _statCard(
        S.of(context).statMaterials,
        stats["subjects_count"].toString(),
        Icons.book,
        AppColors.accentYellow(context),
        isTablet,
      ),
      _statCard(
        S.of(context).statExams,
        stats["exams_count"],
        Icons.assignment,
        AppColors.primaryTeal(context),
        isTablet,
      ),
      _statCard(
        S.of(context).statAverage,
        stats["gpa"],
        Icons.trending_up,
        AppColors.primaryTeal(context),
        isTablet,
      ),
      _statCard(
        S.of(context).statHighScore,
        stats["highest_score"],
        Icons.military_tech,
        AppColors.primaryTeal(context),
        isTablet,
      ),
    ];

    if (shouldScroll) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsetsDirectional.only(
          start: contentPadding,
          end: 0,
        ), // تلتصق بالنهاية
        child: Row(
          children: children
              .map(
                (card) => Container(
                  width: MediaQuery.of(context).size.width < 400 ? 140 : 180,
                  margin: const EdgeInsetsDirectional.only(end: 12),
                  child: card,
                ),
              )
              .toList(),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: contentPadding),
      child: Row(
        children: children
            .map(
              (card) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: card,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 8 : 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: isTablet ? 18 : 25),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isWeb, double contentPadding) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth < 1100;
    String subTitle = (selectedIndex == 0)
        ? S.of(context).goodDay
        : S.of(context).appName;

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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).welcome(studentData["name"].split(' ')[0]),
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              Text(
                subTitle,
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: isSmallScreen ? 12 : 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    studentData["name"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 10 : 16,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  Text(
                    studentData["level"],
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: isSmallScreen ? 8 : 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: isSmallScreen ? 18 : 20,
                backgroundColor: AppColors.primaryTeal(context),
                child: const Icon(Icons.person, color: Colors.white, size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainResultsList({required bool isMobile}) {
    List results = studentData["recent_results"];
    return Expanded(
      flex: isMobile ? 0 : 3,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).recentResults,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => selectedIndex = 1),
                  child: Text(S.of(context).viewAll),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ...results.map((r) => _resultItem(r)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _resultItem(Map data) {
    return InkWell(
      onTap: () => setState(() {
        selectedSubjectName = data["subject"];
        selectedIndex = 4;
      }),
      borderRadius: BorderRadius.circular(18),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["title"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  data["subject"],
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  data["score"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  data["label"],
                  style: const TextStyle(color: Colors.blue, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeCard(
    BuildContext context,
    String badge, {
    bool isSmall = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmall ? 18 : 20),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.accentYellow(context),
            radius: isSmall ? 20 : 30,
            child: Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: isSmall ? 25 : 35,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context).distinguishedStudent,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isSmall ? 14 : 16,
            ),
          ),
          Text(
            S.of(context).badgeMaintain(badge),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: isSmall ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(
    BuildContext context,
    Map<String, dynamic>? perf, {
    bool isSmall = false,
  }) {
    final String gradedCount = perf?["graded_count"] ?? "0/0";
    final String successRate = perf?["success_rate"] ?? "0%";
    double progress = 0.0;
    try {
      List<String> parts = gradedCount.split('/');
      progress = double.parse(parts[0]) / double.parse(parts[1]);
    } catch (_) {}
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmall ? 12 : 20),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              S.of(context).performanceSummary,
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmall ? 12 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _rowInfoDesign(S.of(context).gradedMaterials, gradedCount, isSmall),
          const SizedBox(height: 16),
          _buildResponsiveProgressBar(progress, isSmall),
          const SizedBox(height: 16),
          _rowInfoDesign(S.of(context).successRate, successRate, isSmall),
        ],
      ),
    );
  }

  Widget _rowInfoDesign(String label, String value, bool isSmall) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: isSmall ? 9 : 14),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmall ? 12 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildResponsiveProgressBar(double progress, bool isSmall) {
    return Stack(
      children: [
        Container(
          height: isSmall ? 6 : 8,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0),
          child: Container(
            height: isSmall ? 6 : 8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

class CustSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool isCompact;
  final bool isArabic;

  const CustSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.isCompact,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isCompact ? 110 : 280,
      decoration: BoxDecoration(
        color: AppColors.primaryTeal(context),
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(isMobile ? 0 : 55),
          bottomEnd: Radius.circular(isMobile ? 0 : 55),
        ),
      ),
      child: Column(
        children: [
          _buildLogoSection(context, isCompact),
          const SizedBox(height: 20),
          _menuItem(
            context,
            S.of(context).sidebarHome,
            Icons.home_rounded,
            0,
            isMobile,
          ),
          _menuItem(
            context,
            S.of(context).sidebarMaterials,
            Icons.library_books,
            1,
            isMobile,
          ),
          _menuItem(
            context,
            S.of(context).sidebarSettings,
            Icons.settings_rounded,
            2,
            isMobile,
          ),
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
    bool isMobile,
  ) {
    bool isActive =
        (selectedIndex == index) || (index == 1 && selectedIndex == 4);
    Color activeBg = AppColors.secondaryTeal(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () => onItemSelected(index),
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          clipBehavior: Clip.none,
          children: [
            if (isActive && !isMobile)
              PositionedDirectional(
                end: -1,
                top: -38,
                bottom: -38,
                width: 50,
                child: CustomPaint(
                  painter: SidebarCurvePainter(activeBg, isArabic),
                ),
              ),
            Container(
              height: 60,
              margin: EdgeInsetsDirectional.only(
                end: isMobile ? 12 : (isActive ? 0 : 25),
                start: isCompact ? 10 : 20,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isActive ? activeBg : Colors.transparent,
                borderRadius: BorderRadiusDirectional.horizontal(
                  start: const Radius.circular(30),
                  end: Radius.circular(isActive && !isMobile ? 0 : 30),
                ),
              ),
              child: Row(
                mainAxisAlignment: isCompact
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Icon(icon, color: const Color(0xFFF6AD55), size: 30),
                  if (!isCompact) ...[
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: isActive
                              ? AppColors.primaryTeal(context)
                              : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection(BuildContext context, bool isCompact) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 30),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome, size: 50, color: Colors.white),
          if (!isCompact)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                S.of(context).appName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SidebarCurvePainter extends CustomPainter {
  final Color bgColor;
  final bool isArabic;
  SidebarCurvePainter(this.bgColor, this.isArabic);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;
    double radius = 35;
    double topY = 38;
    double bottomY = topY + 60;
    double startX = isArabic ? 0 : size.width;
    double curveControlX = isArabic ? size.width : 0;

    Path pathTop = Path();
    pathTop.moveTo(startX, topY - radius);
    pathTop.quadraticBezierTo(startX, topY, curveControlX, topY);
    pathTop.lineTo(startX, topY);
    pathTop.close();
    canvas.drawPath(pathTop, paint);

    Path pathBottom = Path();
    pathBottom.moveTo(startX, bottomY + radius);
    pathBottom.quadraticBezierTo(startX, bottomY, curveControlX, bottomY);
    pathBottom.lineTo(startX, bottomY);
    pathBottom.close();
    canvas.drawPath(pathBottom, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
