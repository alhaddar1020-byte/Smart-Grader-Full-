import 'package:flutter/material.dart';
import '../core/colors.dart';
import 'teacher_dashboard.dart';
import 'teacher_matearial.dart';
import 'grading.dart';
import 'exam_page2.dart';
import '../generated/l10n.dart'; // استيراد كلاس الترجمة
import 'review_exam_screen.dart';
import 'teacer_setting.dart';
class FinalExamPage extends StatefulWidget {
  const FinalExamPage({super.key});

  @override
  State<FinalExamPage> createState() => _FinalExamPageState();
}

class _FinalExamPageState extends State<FinalExamPage> {
  int _selectedIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // إزالة Directionality الثابت ليعمل بشكل ديناميكي
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
                          
                          // حاوية اللغة (تتجه يسار أو يمين حسب اللغة)
                          const Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: LanguageSwitcherWidget(),
                          ),
                          
                          const SizedBox(height: 10),
                          
                          // ورقة الاختبار الرئيسية
                          const ExamPaperWidget(),
                          
                          const SizedBox(height: 20),
                          
                          // زر الصفحة التالية
                          _buildNextButton(isMobile),
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
            Text(S.of(context).exam_formatting, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(bool isMobile) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return Align(
      alignment: isMobile ? Alignment.center : AlignmentDirectional.centerEnd,
      child: SizedBox(
        width: 150,
        height: 40,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FinalExamNextPage()),
            );
          },
          // عكس الأيقونة إذا كانت اللغة إنجليزية
          icon: Icon(isRtl ? Icons.arrow_forward : Icons.arrow_forward, size: 16),
          label: Text(S.of(context).next_page, style: const TextStyle(fontSize: 12)),
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
}

// --- ورقة الاختبار ---
class ExamPaperWidget extends StatelessWidget {
  const ExamPaperWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // نضع Directionality للورقة بحيث تعكس شكل الامتحان المطلوب
    // هنا نفترض أن الامتحان يتبع لغة التطبيق الحالية
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleLogo(context),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.edit_outlined, size: 16, color: AppColors.primaryTeal(context)),
                      const SizedBox(width: 5),
                      _collegeHeader(context),
                    ],
                  ),
                  _circleLogo(context),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoGroup(context, [
                    S.of(context).academic_year_value,
                    S.of(context).exam_date_value,
                    S.of(context).examiner_value,
                    S.of(context).allowed_time_value,
                  ]),
                  _infoGroup(context, [
                    S.of(context).semester_value,
                    S.of(context).level_value,
                    S.of(context).department_value,
                    S.of(context).subject_value,
                  ]),
                ],
              ),
              const SizedBox(height: 20),
              _studentNameRow(context),
              const SizedBox(height: 15),
              _questionsTable(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleLogo(BuildContext context) => Container(
        width: 55, height: 55,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey[300]!)),
        child: Center(child: Text(S.of(context).logo, style: const TextStyle(fontSize: 9, color: Colors.grey))),
      );

  Widget _collegeHeader(BuildContext context) => Column(
        children: [
          Text(S.of(context).university_name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Text(S.of(context).college_name, style: const TextStyle(fontSize: 11)),
          Text(S.of(context).monthly_exam, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      );

  Widget _infoGroup(BuildContext context, List<String> items) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.edit_outlined, size: 14, color: AppColors.primaryTeal(context)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(item, style: const TextStyle(fontSize: 10, color: Colors.black87)),
              )).toList(),
        ),
      ],
    );
  }

  Widget _studentNameRow(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: Colors.grey[300]!, width: 0.5)),
      ),
      child: Row(
        children: [
          Text(S.of(context).student_name_label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const Spacer(),
          Icon(Icons.edit_outlined, size: 14, color: AppColors.primaryTeal(context)),
        ],
      ),
    );
  }

  Widget _questionsTable(BuildContext context) => Table(
        columnWidths: const {
          0: FixedColumnWidth(50),
          1: FlexColumnWidth(),
          2: FixedColumnWidth(50),
        },
        border: TableBorder.all(color: Colors.grey[300]!, width: 0.8),
        children: [
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFFF9F9F9)),
            children: [
              _Cell(txt: S.of(context).question_label, isBold: true),
              _Cell(txt: S.of(context).answer_all_questions, isBold: true),
              _Cell(txt: S.of(context).grade_label, isBold: true),
            ],
          ),
          _questionRow("1", "4"),
          _questionRow("2", "5"),
        ],
      );

  TableRow _questionRow(String q, String mark) => TableRow(
        children: [
          _Cell(txt: q, isBold: true),
          Container(height: 180, color: Colors.white),
          _Cell(txt: mark, isBold: true),
        ],
      );
}

// --- محول اللغة ---
class LanguageSwitcherWidget extends StatelessWidget {
  const LanguageSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // تحديد اللغة النشطة حالياً لتغيير الشكل
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

// --- الهيدر ---
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
            S.of(context).exam_formatting,
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
  final bool isBold;
  const _Cell({required this.txt, this.isBold = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(txt, textAlign: TextAlign.center, 
        style: TextStyle(fontSize: 11, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
    );
  }
}
