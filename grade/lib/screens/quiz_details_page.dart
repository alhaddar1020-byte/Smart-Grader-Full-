import 'package:flutter/material.dart';
import 'dart:ui';
import '../core/colors.dart'; 
import '../generated/l10n.dart'; 
import 'teacher_dashboard.dart';
import 'teacher_matearial.dart' hide HeaderWidget;
import 'grading.dart' hide HeaderWidget;
import 'exam_page.dart' hide HeaderWidget;
import 'review_exam_screen.dart';
import 'teacer_setting.dart';
import 'ExamManagementPage.dart';
class QuizDetailsPage extends StatefulWidget {
  const QuizDetailsPage({super.key});

  @override
  State<QuizDetailsPage> createState() => _QuizDetailsPageState();
}

class _QuizDetailsPageState extends State<QuizDetailsPage> {
  final int _selectedIndex = 1; // إدارة الامتحانات
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final int totalQuestions = 10;
  final double totalGrade = 100.0;
  final double aiAccuracy = 98.5;
  final List<String> aiKeywords = ['تعلم آلي', 'AI', 'ذكاء', 'خوارزميات', 'برمجة', 'تطبيقات'];
  bool isEditingMode = false; 

  // ✅ دالة التنقل الموحدة
  void _handleNavigation(int index) {
    if (index == _selectedIndex) return;
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);

    Widget? targetPage;
    switch (index) {
      case 0: targetPage = const DashboardScreen(); break;
      case 1: targetPage = const ExamManagementPage(); break;
      case 2: targetPage = const Material1(); break;
      case 3: targetPage = const GradingPage(); break;
      case 4: targetPage = const ReviewExamPage(); break;
      case 5: targetPage = const SettingsScreen(); break;
    }

    if (targetPage != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => targetPage!));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 950;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.scaffoldBg(context), 
      drawer: isMobile ? Drawer(width: 260, child: SafeArea(child: CustSidebar(selectedIndex: _selectedIndex, onItemSelected: _handleNavigation))) : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile)
            CustSidebar(selectedIndex: _selectedIndex, onItemSelected: _handleNavigation),
          
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.textWhite(context),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Row(
                      children: [
                        if (isMobile) IconButton(icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)), onPressed: () => _scaffoldKey.currentState?.openDrawer()),
                        Text(S.of(context).ai_generation_results, style: TextStyle(color: AppColors.textPrimary(context), fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: isMobile 
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                _buildRightColumn(isMobile: true), 
                                const SizedBox(height: 24),
                                _buildLeftColumn(isMobile: true), 
                              ],
                            ),
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start, 
                            children: [
                              Expanded(flex: 7, child: _buildRightColumn(isMobile: false)), 
                              const SizedBox(width: 24), 
                              Expanded(flex: 3, child: _buildLeftColumn(isMobile: false))
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
  }

  Widget _buildRightColumn({required bool isMobile}) {
    return ListView(
      shrinkWrap: true, 
      physics: isMobile ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
      children: [
        DynamicQuestionCard(
          questionNumber: '1', 
          aiGeneratedQuestionText: 'أي من التالي يعتبر مثالاً على عملية البناء الضوئي؟', 
          aiModelAnswer: 'البناء الضوئي هو عملية تقوم بها النباتات لتحويل طاقة الشمس إلى طاقة كيميائية...', 
          isEditing: isEditingMode
        ),
        const SizedBox(height: 24),
        DynamicQuestionCard(
          questionNumber: '2', 
          aiGeneratedQuestionText: 'ما هي المركبات العضوية التي تعتبر المصدر الرئيسي للطاقة في جسم الإنسان؟', 
          aiModelAnswer: 'الكربوهيدرات هي المصدر الرئيسي للطاقة في جسم الإنسان، حيث تتحول إلى جلوكوز يغذي الخلايا...', 
          isEditing: isEditingMode
        ),
      ],
    );
  }

  Widget _buildLeftColumn({required bool isMobile}) {
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTestDetailsCard(), 
        const SizedBox(height: 16), 
        _buildKeywordsCard(), 
        const SizedBox(height: 24), 
        _buildActionButtons(), 
        const SizedBox(height: 24)
      ],
    );
    return isMobile ? content : SingleChildScrollView(physics: const BouncingScrollPhysics(), child: content);
  }

  Widget _buildTestDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text(S.of(context).exam_details, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)))),
          const SizedBox(height: 24),
          _buildStatRow(icon: Icons.list_alt, iconColor: AppColors.accentYellow(context), title: S.of(context).total_questions, value: '$totalQuestions'), 
          Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Divider(color: AppColors.textSecondary(context).withValues(alpha: 0.1), thickness: 1)),
          _buildStatRow(icon: Icons.military_tech_outlined, iconColor: AppColors.primaryTeal(context), title: S.of(context).total_grade, value: '$totalGrade'), 
          Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Divider(color: AppColors.textSecondary(context).withValues(alpha: 0.1), thickness: 1)),
          _buildStatRow(icon: Icons.auto_awesome, iconColor: const Color(0xFF3FA9A7), title: S.of(context).ai_accuracy, value: '%$aiAccuracy'), 
        ],
      ),
    );
  }

  Widget _buildStatRow({required IconData icon, required Color iconColor, required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [Container(width: 36, height: 36, decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: iconColor, size: 18)), const SizedBox(width: 12), Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary(context)))]),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
      ],
    );
  }

  Widget _buildKeywordsCard() {
    return Container(
      padding: const EdgeInsets.all(24), width: double.infinity,
      decoration: BoxDecoration(color: AppColors.primaryTeal(context), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: AppColors.primaryTeal(context).withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text(S.of(context).keywords, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8, runSpacing: 8, alignment: WrapAlignment.center,
            children: aiKeywords.map((kw) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: AppColors.accentYellow(context).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.accentYellow(context).withValues(alpha: 0.3))), child: Text(kw, style: TextStyle(color: AppColors.accentYellow(context), fontWeight: FontWeight.w600, fontSize: 13)))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Container(
          width: double.infinity, height: 54,
          decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primaryTeal(context), const Color(0xFF3FA9A7)]), borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: AppColors.primaryTeal(context).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))]),
          child: Material(color: Colors.transparent, child: InkWell(borderRadius: BorderRadius.circular(14), onTap: () {}, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(S.of(context).approve_exam, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(width: 8), const Icon(Icons.check_circle_outline, color: Colors.white, size: 22)]))),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity, height: 54,
          child: OutlinedButton.icon(
            onPressed: () { setState(() { isEditingMode = !isEditingMode; }); },
            icon: Icon(isEditingMode ? Icons.close : Icons.edit, color: isEditingMode ? Colors.red : AppColors.primaryTeal(context)),
            label: Text(isEditingMode ? S.of(context).cancel_edit : S.of(context).edit_exam, style: TextStyle(color: isEditingMode ? Colors.red : AppColors.primaryTeal(context), fontSize: 16, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(side: BorderSide(color: isEditingMode ? Colors.red : AppColors.primaryTeal(context), width: 1.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          ),
        ),
      ],
    );
  }
}

class DynamicQuestionCard extends StatefulWidget {
  final String questionNumber;
  final String aiGeneratedQuestionText; 
  final String aiModelAnswer;   
  final bool isEditing; 

  const DynamicQuestionCard({super.key, required this.questionNumber, required this.aiGeneratedQuestionText, required this.aiModelAnswer, required this.isEditing});

  @override
  State<DynamicQuestionCard> createState() => _DynamicQuestionCardState();
}

class _DynamicQuestionCardState extends State<DynamicQuestionCard> {
  late TextEditingController _questionTextController;
  late TextEditingController _modelAnswerController;

  @override
  void initState() {
    super.initState();
    _questionTextController = TextEditingController(text: widget.aiGeneratedQuestionText);
    _modelAnswerController = TextEditingController(text: widget.aiModelAnswer);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context), 
        borderRadius: BorderRadius.circular(16), 
        border: Border.all(color: widget.isEditing ? AppColors.accentYellow(context).withValues(alpha: 0.5) : Colors.transparent, width: 2), 
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(), const SizedBox(height: 24),
          _buildQuestionTextField(), const SizedBox(height: 24),
          Divider(color: AppColors.textSecondary(context).withValues(alpha: 0.1), thickness: 1), const SizedBox(height: 20),
          _buildModelAnswerSection(), 
        ],
      ),
    );
  }

  Widget _buildCardHeader() {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: AppColors.primaryTeal(context), borderRadius: BorderRadius.circular(10)), child: Text(widget.questionNumber, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)));
  }

  Widget _buildQuestionTextField() {
    return TextFormField(
      controller: _questionTextController, maxLines: null, readOnly: !widget.isEditing,
      style: TextStyle(fontSize: 16, color: AppColors.textPrimary(context), fontWeight: FontWeight.bold, height: 1.5),
      decoration: InputDecoration(
        filled: true, fillColor: widget.isEditing ? AppColors.accentYellow(context).withValues(alpha: 0.05) : AppColors.scaffoldBg(context),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildModelAnswerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Icon(Icons.check_circle_outline, color: AppColors.primaryTeal(context), size: 22), const SizedBox(width: 8), Text(S.of(context).model_answer, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 16),
        TextField(
          controller: _modelAnswerController, maxLines: null, readOnly: !widget.isEditing,
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary(context), height: 1.6),
          decoration: InputDecoration(filled: true, fillColor: widget.isEditing ? AppColors.accentYellow(context).withValues(alpha: 0.05) : AppColors.scaffoldBg(context), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
        ),
      ],
    );
  }
}