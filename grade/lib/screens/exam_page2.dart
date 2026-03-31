import 'package:flutter/material.dart';
import '../core/colors.dart';
import 'teacher_dashboard.dart' hide HeaderWidget;
import 'teacher_matearial.dart' hide HeaderWidget;
import 'grading.dart' hide HeaderWidget;
import 'exam_page.dart';

class FinalExamNextPage extends StatefulWidget {
  const FinalExamNextPage({super.key});

  @override
  State<FinalExamNextPage> createState() => _FinalExamNextPageState();
}

class _FinalExamNextPageState extends State<FinalExamNextPage> {
  int _selectedIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: LayoutBuilder(builder: (context, constraints) {
        // تحديد القياسات بدقة
        bool isMobile = constraints.maxWidth < 800;
        bool isTablet = constraints.maxWidth >= 800 && constraints.maxWidth < 1150;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.secondaryTeal(context),
          // Drawer للموبايل فقط
          drawer: isMobile
              ? Drawer(
                  width: 260,
                  backgroundColor: AppColors.primaryTeal(context),
                  child: SafeArea(
                    child: CustSidebar(
                      selectedIndex: _selectedIndex,
                      isCompact: false,
                      onItemSelected: _handleNavigation,
                    ),
                  ),
                )
              : null,
          body: Row(
            children: [
              // السايدبار للويب والتابلت
              if (!isMobile)
                CustSidebar(
                  selectedIndex: _selectedIndex,
                  isCompact: isTablet,
                  onItemSelected: _handleNavigation,
                ),
              Expanded(
                child: Column(
                  children: [
                    if (isMobile) _buildMobileAppBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const HeaderWidget(),
                            const SizedBox(height: 20),

                            // ✅ محول اللغة
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: LanguageSwitcherWidget(),
                            ),
                            const SizedBox(height: 10),

                            // ✅ الورقة مع ضبط مكان القلم
                            _buildExamPaperSection(),

                            const SizedBox(height: 30),

                            // ✅ الأزرار الموحدة (تحميل PDF والرجوع)
                            _buildActionButtons(isMobile),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMobileAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            const Spacer(),
            const Text("معاينة الاختبار", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildExamPaperSection() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                children: [
                  _questionsTableNext(),
                  const SizedBox(height: 20),
                  const Text(
                    "--- بالتوفيق ---",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // ✏️ القلم الأخضر مرفوع عند حدود الجدول
            Positioned(
              top: 10,
              right: 25,
              child: Icon(
                Icons.edit_outlined,
                size: 18,
                color: const Color(0xFF65BBAE),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isMobile) {
    return Align(
      alignment: isMobile ? Alignment.center : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          // زر تحميل PDF
          SizedBox(
            width: 150,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.file_download_outlined, size: 18, color: Colors.white),
              label: const Text("تحميل PDF", style: TextStyle(fontSize: 12, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF65BBAE),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // زر الصفحة السابقة
          SizedBox(
            width: 150,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, size: 18, color: AppColors.primaryTeal(context)),
              label: const Text("الصفحة السابقة", style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryTeal(context),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.black12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(int index) {
    if (index == _selectedIndex) return;
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);

    Widget? nextPage;
    if (index == 0) nextPage = const DashboardScreen();
    if (index == 2) nextPage = const Material1();
    if (index == 3) nextPage = const GradingPage();

    if (nextPage != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => nextPage!),
        (route) => false,
      );
    }
  }

  Widget _questionsTableNext() => Table(
        columnWidths: const {
          0: FixedColumnWidth(50),
          1: FlexColumnWidth(),
          2: FixedColumnWidth(50),
        },
        border: TableBorder.all(color: Colors.black87, width: 0.8),
        children: [
          _questionRow("3", "3"),
          _questionRow("4", "4"),
          _questionRow("5", "5"),
        ],
      );

  TableRow _questionRow(String q, String mark) => TableRow(
        children: [
          _Cell(txt: q),
          Container(height: 180, color: Colors.white),
          _Cell(txt: mark),
        ],
      );
}

// ✅ حاوية اللغة الموحدة
class LanguageSwitcherWidget extends StatelessWidget {
  const LanguageSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLangBtn("English", false),
          _buildLangBtn("العربية", true),
        ],
      ),
    );
  }

  Widget _buildLangBtn(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF65BBAE) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: isSelected ? Colors.white : Colors.black54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

// ✅ الهيدر الموحد
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "معاينة الاختبار",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context)),
          ),
          Row(
            children: [
              _iconButton(context, Icons.notifications_none),
              const SizedBox(width: 10),
              _iconButton(context, Icons.person_outline),
            ],
          )
        ],
      ),
    );
  }

  Widget _iconButton(BuildContext context, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.secondaryTeal(context),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primaryTeal(context)),
    );
  }
}

class _Cell extends StatelessWidget {
  final String txt;
  const _Cell({required this.txt});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Text(
          txt,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}