import 'package:flutter/material.dart';
import '../core/colors.dart';
import 'teacher_dashboard.dart'; 
import 'teacher_matearial.dart'  hide  HeaderWidget;
import 'grading.dart'  hide  HeaderWidget ;
import 'exam_page.dart' hide  HeaderWidget ;
import '../generated/l10n.dart';
import 'teacer_setting.dart';
import 'ExamManagementPage.dart';

enum QuestionType { essay, trueFalse, multipleChoice }

class QuestionData {
  final String questionText;
  final QuestionType type;
  final String? studentTextAnswer;
  final bool? studentTFAnswer;
  final String? studentMCAnswer;
  final String modelAnswer;
  String achievedGrade;
  final String maxGrade;

  QuestionData({
    required this.questionText,
    required this.type,
    this.studentTextAnswer,
    this.studentTFAnswer,
    this.studentMCAnswer,
    required this.modelAnswer,
    required this.achievedGrade,
    required this.maxGrade,
  });
}

class ReviewExamPage extends StatefulWidget {
  const ReviewExamPage({super.key});

  @override
  State<ReviewExamPage> createState() => _ReviewExamPageState();
}

class _ReviewExamPageState extends State<ReviewExamPage> {
  final int _selectedIndex = 4;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isEditing = false;
  List<QuestionData> questionsList = [];
  bool _isInit = false;

  int get totalAchieved {
    double total = 0;
    for (var q in questionsList) total += double.tryParse(q.achievedGrade) ?? 0;
    return total.toInt();
  }

  int get totalMax {
    double total = 0;
    for (var q in questionsList) total += double.tryParse(q.maxGrade) ?? 0;
    return total.toInt();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      questionsList = [
        QuestionData(
          questionText: S.of(context).question_example_1,
          type: QuestionType.essay,
          studentTextAnswer: S.of(context).student_answer_example_1,
          modelAnswer: S.of(context).model_answer_example_1,
          achievedGrade: "8",
          maxGrade: "10",
        ),
        QuestionData(
          questionText: S.of(context).question_example_2,
          type: QuestionType.trueFalse,
          studentTFAnswer: true,
          modelAnswer: S.of(context).true_word,
          achievedGrade: "5",
          maxGrade: "5",
        ),
      ];
      _isInit = true;
    }
  }

  Map<String, dynamic> _getCardStyle(BuildContext context, String achievedStr, String maxStr) {
    double achieved = double.tryParse(achievedStr) ?? 0;
    double max = double.tryParse(maxStr) ?? 10;
    if (achieved >= max) {
      return {'text': S.of(context).perfect_match, 'color': Colors.teal, 'icon': Icons.check_circle};
    } else if (achieved <= 0) {
      return {'text': S.of(context).incorrect_answer, 'color': Colors.red, 'icon': Icons.cancel};
    } else {
      return {'text': S.of(context).incomplete_answer, 'color': Colors.orange, 'icon': Icons.warning_rounded};
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 1000;
      bool isTablet = constraints.maxWidth >= 1000 && constraints.maxWidth < 1200;

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
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: _buildMainHeader(context),
                          ),
                          _buildQuestionsList(isMobile),
                          _buildBottomFooter(context),
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

  Widget _buildMainHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).welcome_teacher,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  S.of(context).review_subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // تم تغليف الدرجة بـ FittedBox لمنع الـ Overflow في الهيدر
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isEditing ? const Color(0xFFFFF9E6) : const Color(0xFFF4F9F8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isEditing 
                      ? Colors.orange.withOpacity(0.5) 
                      : AppColors.primaryTeal(context).withOpacity(0.3),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$totalAchieved',
                      style: TextStyle(
                        fontSize: 28,
                        color: AppColors.primaryTeal(context),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      ' ${S.of(context).of_total} $totalMax',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            const Spacer(),
            Text(S.of(context).review, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsList(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 32.0, vertical: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: questionsList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildQuestionCard(context, isMobile, questionsList[index], index),
          );
        },
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, bool isMobile, QuestionData questionData, int index) {
    var style = _getCardStyle(context, questionData.achievedGrade, questionData.maxGrade);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (style['color'] as Color).withOpacity(0.5), width: 1.5),
        boxShadow: [BoxShadow(color: (style['color'] as Color).withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: isMobile 
          ? _buildMobileLayout(context, questionData, style, index) 
          : _buildDesktopLayout(context, questionData, style, index),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, QuestionData questionData, Map<String, dynamic> style, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6, // تم تقليص الـ flex لإعطاء مساحة أكبر لجهة الدرجات
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${S.of(context).question_label} ${index + 1}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context))),
              const SizedBox(height: 8),
              Text(questionData.questionText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
              const SizedBox(height: 16),
              _buildAnswerContent(context, questionData),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => _showModelAnswer(context, index, questionData.modelAnswer),
                child: Text(S.of(context).show_model_answer, style: TextStyle(color: AppColors.primaryTeal(context), fontSize: 13, decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 4, // زيادة المساحة هنا لمنع الـ Overflow في النصوص الإنجليزية
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Wrap(
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  Icon(style['icon'], color: style['color'], size: 20),
                  Text(style['text'], 
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: style['color']),
                    softWrap: true,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildGradeInput(context, questionData, style, index),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, QuestionData questionData, Map<String, dynamic> style, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${S.of(context).question_label} ${index + 1}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context))),
        const SizedBox(height: 8),
        Text(questionData.questionText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
        const SizedBox(height: 16),
        _buildAnswerContent(context, questionData),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _showModelAnswer(context, index, questionData.modelAnswer),
          child: Text(S.of(context).show_model_answer, style: TextStyle(color: AppColors.primaryTeal(context), fontSize: 13, decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 20),
        Divider(color: (style['color'] as Color).withOpacity(0.2), height: 1),
        const SizedBox(height: 20),
        // استخدام Wrap في الموبايل لضمان عدم حدوث Overflow
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 10,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(style['icon'], color: style['color'], size: 18),
                const SizedBox(width: 8),
                Text(style['text'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: style['color'])),
              ],
            ),
            _buildGradeInput(context, questionData, style, index),
          ],
        ),
      ],
    );
  }

  Widget _buildGradeInput(BuildContext context, QuestionData questionData, Map<String, dynamic> style, int index) {
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 4,
      children: [
        Text(S.of(context).earned_grade, style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context))),
        if (isEditing)
          SizedBox(
            width: 50, height: 35,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryTeal(context), width: 1.5), borderRadius: BorderRadius.circular(8)),
              ),
              controller: TextEditingController(text: questionData.achievedGrade)..selection = TextSelection.collapsed(offset: questionData.achievedGrade.length),
              onChanged: (val) => _handleGradeValidation(val, questionData.maxGrade, index),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(border: Border.all(color: style['color'], width: 1.2), borderRadius: BorderRadius.circular(8)),
            child: Text(questionData.achievedGrade, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: style['color'])),
          ),
        Text('${S.of(context).out_of} ${questionData.maxGrade}', 
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context))),
      ],
    );
  }

  void _handleGradeValidation(String val, String maxGradeStr, int index) {
    setState(() {
      if (val.isEmpty) { questionsList[index].achievedGrade = '0'; return; }
      double entered = double.tryParse(val) ?? 0;
      double max = double.tryParse(maxGradeStr) ?? 0;
      if (entered > max) {
        questionsList[index].achievedGrade = max.toInt().toString();
      } else {
        questionsList[index].achievedGrade = val;
      }
    });
  }

  Widget _buildAnswerContent(BuildContext context, QuestionData questionData) {
    if (questionData.type == QuestionType.essay) {
      return Text(questionData.studentTextAnswer ?? '', style: TextStyle(fontSize: 15, height: 1.6, color: AppColors.textPrimary(context)));
    }
    String answerText = (questionData.type == QuestionType.trueFalse)
        ? ((questionData.studentTFAnswer == true) ? S.of(context).true_word : S.of(context).false_word)
        : (questionData.studentMCAnswer ?? '');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: AppColors.secondaryTeal(context).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("${S.of(context).student_answer} ", style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13)),
          Flexible(child: Text(answerText, style: TextStyle(color: AppColors.textPrimary(context), fontWeight: FontWeight.bold, fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildBottomFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.textSecondary(context).withOpacity(0.1), width: 1)),
      ),
      child: SafeArea(
        child: Wrap(
          spacing: 16, runSpacing: 16, alignment: WrapAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              label: Text(S.of(context).save_approve_result, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal(context), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
            OutlinedButton.icon(
              onPressed: () => setState(() => isEditing = !isEditing),
              icon: Icon(isEditing ? Icons.close : Icons.edit, color: isEditing ? Colors.redAccent : AppColors.primaryTeal(context), size: 20),
              label: Text(isEditing ? S.of(context).finish_editing : S.of(context).edit_grades, style: TextStyle(color: isEditing ? Colors.redAccent : AppColors.primaryTeal(context), fontWeight: FontWeight.bold, fontSize: 14)),
              style: OutlinedButton.styleFrom(side: BorderSide(color: isEditing ? Colors.redAccent : AppColors.primaryTeal(context), width: 1.5), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ],
        ),
      ),
    );
  }

  void _showModelAnswer(BuildContext context, int index, String modelAnswer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${S.of(context).model_answer_for} ${S.of(context).question_label} ${index + 1}:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
            const SizedBox(height: 16),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.primaryTeal(context).withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryTeal(context))),
              child: Text(modelAnswer, style: TextStyle(fontSize: 14, height: 1.6, color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal(context), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(S.of(context).close_btn, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    if (index == _selectedIndex) return;
    Widget? page;
    if (index == 0) page = const DashboardScreen();
    if (index == 1) page = const ExamManagementPage();
    if (index == 2) page = const Material1();
    if (index == 3) page = const GradingPage();
    if (index == 5) page = const SettingsScreen();

    if (page != null) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page!));
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); 
  }
}