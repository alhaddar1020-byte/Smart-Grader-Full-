import 'package:flutter/material.dart';
import '../core/colors.dart';
import 'teacher_dashboard.dart' hide HeaderWidget;
import 'teacher_matearial.dart' hide HeaderWidget;
import 'grading.dart' hide HeaderWidget;
import 'exam_page.dart';
import '../generated/l10n.dart'; 
import 'review_exam_screen.dart';
import 'teacer_setting.dart';
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
    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 800;
      bool isTablet = constraints.maxWidth >= 800 && constraints.maxWidth < 1150;

      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.secondaryTeal(context),
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

                          // محول اللغة (رجعتيه للعرض فقط عشان ما يطلع خطأ)
                          const Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: LanguageSwitcherWidget(),
                          ),
                          const SizedBox(height: 10),

                          _buildExamPaperSection(),

                          const SizedBox(height: 30),

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
    });
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
            Text(S.of(context).exam_preview, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildExamPaperSection() {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;
    
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
                  Text(
                    S.of(context).good_luck,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: isRtl ? null : 25,
              left: isRtl ? 25 : null,
              child: const Icon(
                Icons.edit_outlined,
                size: 18,
                color: Color(0xFF65BBAE),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isMobile) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;
    
    return Align(
      alignment: isMobile ? Alignment.center : AlignmentDirectional.centerEnd,
      child: Column(
        crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.file_download_outlined, size: 18, color: Colors.white),
              label: Text(S.of(context).download_pdf, style: const TextStyle(fontSize: 12, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF65BBAE),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 150,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(isRtl ? Icons.arrow_back : Icons.arrow_back, size: 18, color: AppColors.primaryTeal(context)),
              label: Text(S.of(context).previous_page, style: const TextStyle(fontSize: 12)),
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
    if (index == 4) nextPage = const ReviewExamPage();
    if (index == 5) nextPage = const SettingsScreen();

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

// الكلاس المعدل (للعرض فقط وبدون أخطاء)
class LanguageSwitcherWidget extends StatelessWidget {
  const LanguageSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLangBtn("English", !isArabic),
          _buildLangBtn("العربية", isArabic),
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
            S.of(context).exam_preview,
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