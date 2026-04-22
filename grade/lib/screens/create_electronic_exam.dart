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

// نموذج بيانات السؤال
class QuestionModel {
  String type;
  String text;
  List<TextEditingController> optionControllers;
  int grade;
  int correctOptionIndex;

  QuestionModel({
    required this.type,
    this.text = "",
    required List<String> options,
    this.grade = 5,
    this.correctOptionIndex = 0,
  }) : optionControllers = options.map((e) => TextEditingController(text: e)).toList();
}

class CreateElectronicExamPage extends StatefulWidget {
  const CreateElectronicExamPage({super.key});

  @override
  State<CreateElectronicExamPage> createState() => _CreateElectronicExamPageState();
}

class _CreateElectronicExamPageState extends State<CreateElectronicExamPage> {
  final int _selectedIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _timeLimitController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  List<QuestionModel> questions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // تهيئة الأسئلة الافتراضية باستخدام الترجمة عند أول تشغيل
    if (questions.isEmpty) {
      _timeLimitController.text = S.of(context).confirm; // قيمة افتراضية
      questions = [
        QuestionModel(
          type: 'mcq',
          text: "",
          options: [S.of(context).new_option, S.of(context).new_option],
          grade: 10,
        ),
      ];
    }
  }

  int _getTotalGrade() {
    return questions.fold(0, (sum, item) => sum + item.grade);
  }

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: AppColors.primaryTeal(context)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _dateController.text = "${picked.year}-${picked.month}-${picked.day}");
    }
  }

  void _showTimeLimitDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      barrierColor: Colors.black.withValues(alpha: 0.6),
      pageBuilder: (context, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(30),
                width: 420,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                    ),
                    Text(S.of(context).write_time_limit, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 25),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal(context).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.primaryTeal(context).withValues(alpha: 0.3)),
                      ),
                      child: TextField(
                        controller: _timeLimitController,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(height: 35),
                    Row(children: [
                      Expanded(child: _dialogBtn(S.of(context).confirm, AppColors.primaryTeal(context))),
                      const SizedBox(width: 15),
                      Expanded(child: _dialogBtn(S.of(context).cancel, const Color(0xFFB35A5A))),
                    ])
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dialogBtn(String label, Color color) => ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 0),
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 1000;
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.secondaryTeal(context),
        drawer: isMobile
            ? Drawer(
                width: 260,
                child: SafeArea(child: CustSidebar(selectedIndex: _selectedIndex, onItemSelected: _handleNavigation)))
            : null,
        body: Row(
          children: [
            if (!isMobile) CustSidebar(selectedIndex: _selectedIndex, onItemSelected: _handleNavigation),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Column(
                      children: [
                        if (isMobile)
                          Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: IconButton(
                                  icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)),
                                  onPressed: () => _scaffoldKey.currentState?.openDrawer())),
                        _buildHeader(context),
                        const SizedBox(height: 32),
                        _buildExamInfoCard(context),
                        const SizedBox(height: 24),
                        ...questions.asMap().entries.map((entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: _buildDynamicQuestionCard(context, entry.key, entry.value))),
                        const SizedBox(height: 32),
                        _buildAddQuestionButton(context),
                        const SizedBox(height: 40),
                        _buildFooterButtons(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(S.of(context).create_electronic_exam,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
            const SizedBox(height: 4),
            Text(S.of(context).add_questions_manually,
                style: TextStyle(color: AppColors.textSecondary(context), fontSize: 14)),
          ]),
          Row(children: [
            _headerIconButton(context, Icons.notifications_none_rounded),
            const SizedBox(width: 12),
            _headerIconButton(context, Icons.person_outline_rounded),
          ]),
        ],
      ),
    );
  }

  Widget _headerIconButton(BuildContext context, IconData icon) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColors.secondaryTeal(context).withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: AppColors.primaryTeal(context), size: 24),
      );

  // Widget _buildExamInfoCard(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(16),
  //         boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(S.of(context).exam_info,
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary(context))),
  //         const SizedBox(height: 24),
  //         Row(children: [
  //           Expanded(
  //               flex: 2,
  //               child: _infoTextField(context,
  //                   label: S.of(context).exam_title_label,
  //                   icon: Icons.description_outlined,
  //                   controller: _titleController,
  //                   hint: S.of(context).exam_title_hint)),
  //           const SizedBox(width: 16),
  //           Expanded(
  //               flex: 1,
  //               child: _infoTextField(context,
  //                   label: S.of(context).exam_date_label,
  //                   icon: Icons.calendar_month_outlined,
  //                   controller: _dateController,
  //                   hint: "",
  //                   readOnly: true,
  //                   onTap: () => _selectDate(context))),
  //           const SizedBox(width: 16),
  //           _gradeBox(context),
  //         ]),
  //       ],
  //     ),
  //   );
  // }
Widget _buildExamInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).exam_info, // "معلومات الامتحان"
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary(context)),
          ),
          const SizedBox(height: 24),
          
          // السطر الأول: العنوان، التاريخ، والدرجة الكلية
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _infoTextField(
                  context,
                  label: S.of(context).exam_title_label, // "اسم الاختبار"
                  icon: Icons.description_outlined,
                  controller: _titleController,
                  hint: S.of(context).exam_title_hint,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: _infoTextField(
                  context,
                  label: S.of(context).exam_date_label, // "تاريخ الاختبار"
                  icon: Icons.calendar_month_outlined,
                  controller: _dateController,
                  hint: "",
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
              ),
              const SizedBox(width: 16),
              _gradeBox(context), // الدرجة الكلية
            ],
          ),
          
          const SizedBox(height: 16),

          // السطر الثاني: التخصص، المستوى الدراسي، عدد الطلاب
          Row(
            children: [
              Expanded(
                child: _infoTextField(
                  context,
                  label: S.of(context).specialization_label, // أضيفي هذا المفتاح في ARB "التخصص"
                  icon: Icons.category_outlined,
                  hint: S.of(context).specialization_hint,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _infoTextField(
                  context,
                  label: S.of(context).level_label, // "المستوى الدراسي"
                  icon: Icons.menu_book_outlined,
                  hint: S.of(context).level_hint,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _infoTextField(
                  context,
                  label: S.of(context).students_count_label, // "عدد الطلاب"
                  icon: Icons.people_outline_rounded,
                  hint: "0",
                  isNumber: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _infoTextField(BuildContext context,
      {required String label,
      required IconData icon,
      TextEditingController? controller,
      String? hint,
      bool isNumber = false,
      bool readOnly = false,
      VoidCallback? onTap}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
          color: AppColors.scaffoldBg(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.textSecondary(context).withValues(alpha: 0.2))),
      child: Row(children: [
        const SizedBox(width: 12),
        Icon(icon, color: AppColors.primaryTeal(context), size: 20),
        const SizedBox(width: 8),
        Flexible(
            child: Text(label,
                style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 12),
        Expanded(
            child: TextField(
                controller: controller,
                readOnly: readOnly,
                onTap: onTap,
                keyboardType: isNumber ? TextInputType.number : TextInputType.text,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                    hintText: hint, border: InputBorder.none, contentPadding: const EdgeInsets.only(bottom: 12)))),
      ]),
    );
  }

  Widget _gradeBox(BuildContext context) {
    return Column(children: [
      Text(S.of(context).total_grade, style: TextStyle(fontSize: 11, color: AppColors.textSecondary(context))),
      const SizedBox(height: 5),
      Container(
          width: 80,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColors.primaryTeal(context).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primaryTeal(context).withValues(alpha: 0.2))),
          child: Text("${_getTotalGrade()}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primaryTeal(context)))),
    ]);
  }

  Widget _buildDynamicQuestionCard(BuildContext context, int index, QuestionModel q) {
    return _whiteCard(
      context: context,
      title: _getQuestionTitle(context, index),
      isQuestion: true,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _questionInput(context, q),
        const SizedBox(height: 15),
        if (q.type == 'mcq') _buildMCQView(context, q),
        if (q.type == 'tf') _buildTFView(context),
        if (q.type == 'essay') _buildEssayView(context),
        const Divider(height: 30),
        _questionFooter(context, index, q),
      ]),
    );
  }

  Widget _buildMCQView(BuildContext context, QuestionModel q) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ...q.optionControllers.asMap().entries.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _editableOption(
              context,
              entry.value,
              q.correctOptionIndex == entry.key,
              () => setState(() => q.correctOptionIndex = entry.key),
              () => setState(() => q.optionControllers.removeAt(entry.key))))),
      TextButton(
          onPressed: () => setState(() => q.optionControllers.add(TextEditingController(text: S.of(context).new_option))),
          child: Text("+ ${S.of(context).add_option}",
              style: TextStyle(color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold))),
    ]);
  }

  Widget _editableOption(
      BuildContext context, TextEditingController ctrl, bool isSelected, VoidCallback onSelect, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          color: AppColors.scaffoldBg(context),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: isSelected ? AppColors.primaryTeal(context) : Colors.grey.shade300, width: isSelected ? 1.5 : 1)),
      child: Row(children: [
        GestureDetector(
            onTap: onSelect,
            child: Icon(isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? AppColors.primaryTeal(context) : Colors.grey)),
        const SizedBox(width: 10),
        Expanded(child: TextField(controller: ctrl, decoration: const InputDecoration(border: InputBorder.none, isDense: true))),
        IconButton(icon: const Icon(Icons.close, size: 16), onPressed: onRemove),
      ]),
    );
  }

  Widget _buildTFView(BuildContext context) => Row(children: [
        Expanded(child: _tfBtn(S.of(context).true_word)),
        const SizedBox(width: 10),
        CircleAvatar(
            radius: 18, backgroundColor: AppColors.primaryTeal(context), child: const Icon(Icons.add, color: Colors.white)),
        const SizedBox(width: 10),
        Expanded(child: _tfBtn(S.of(context).false_word))
      ]);

  Widget _tfBtn(String label) => Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(color: AppColors.primaryTeal(context))),
      child: Center(child: Text(label, style: TextStyle(color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold))));

  Widget _buildEssayView(BuildContext context) => Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.secondaryTeal(context).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200)),
      child: Center(child: Text(S.of(context).essay_answer_area, style: const TextStyle(color: Colors.grey))));

  Widget _questionFooter(BuildContext context, int index, QuestionModel q) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(icon: const Icon(Icons.delete_outline, color: Colors.grey), onPressed: () => setState(() => questions.removeAt(index))),
          IconButton(
              icon: const Icon(Icons.copy_all, color: Colors.grey),
              onPressed: () => setState(() => questions.insert(
                  index + 1,
                  QuestionModel(
                      type: q.type,
                      text: q.text,
                      options: q.optionControllers.map((c) => c.text).toList(),
                      grade: q.grade)))),
        ]),
        const SizedBox(width: 10),
        Text("${S.of(context).grade_label} ", style: TextStyle(color: AppColors.textSecondary(context), fontSize: 12)),
        SizedBox(
            width: 40,
            child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: InputBorder.none),
                controller: TextEditingController(text: q.grade.toString())
                  ..selection = TextSelection.collapsed(offset: q.grade.toString().length),
                onChanged: (val) => setState(() => q.grade = int.tryParse(val) ?? 0))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: AppColors.secondaryTeal(context).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
          child: DropdownButton<String>(
              value: q.type,
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(value: 'mcq', child: Text(S.of(context).q_mcq, style: const TextStyle(fontSize: 12))),
                DropdownMenuItem(value: 'tf', child: Text(S.of(context).q_tf, style: const TextStyle(fontSize: 12))),
                DropdownMenuItem(value: 'essay', child: Text(S.of(context).q_essay, style: const TextStyle(fontSize: 12)))
              ],
              onChanged: (v) => setState(() => q.type = v!)),
        ),
      ],
    );
  }

  Widget _buildAddQuestionButton(BuildContext context) => InkWell(
        onTap: () => setState(() => questions.add(QuestionModel(type: 'mcq', text: "", options: [S.of(context).new_option], grade: 5))),
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.primaryTeal(context).withValues(alpha: 0.3))),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.add, color: AppColors.primaryTeal(context)),
              const SizedBox(width: 10),
              Text(S.of(context).add_new_question,
                  style: TextStyle(color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold, fontSize: 16))
            ])),
      );

  Widget _buildFooterButtons(BuildContext context) => Row(children: [
        Expanded(
            child: ElevatedButton(
                onPressed: _showTimeLimitDialog,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal(context),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: Text(S.of(context).save_and_approve, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
        const SizedBox(width: 20),
        Expanded(
            child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    side: BorderSide(color: AppColors.primaryTeal(context)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: Text(S.of(context).save_as_draft, style: TextStyle(color: AppColors.primaryTeal(context))))),
      ]);

  String _getQuestionTitle(BuildContext context, int index) {
    if (index == 0) return S.of(context).question_first;
    if (index == 1) return S.of(context).question_second;
    if (index == 2) return S.of(context).question_third;
    return "${S.of(context).question_label} ${index + 1}";
  }

  Widget _whiteCard({required BuildContext context, required String title, required Widget child, bool isQuestion = false}) =>
      Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: isQuestion ? Border.all(color: AppColors.primaryTeal(context).withValues(alpha: 0.3), width: 2) : null,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: TextStyle(color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 15),
            child
          ]));

  Widget _questionInput(BuildContext context, QuestionModel q) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
          color: AppColors.secondaryTeal(context).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(15)),
      child: TextField(
          onChanged: (v) => q.text = v,
          controller: TextEditingController(text: q.text)..selection = TextSelection.collapsed(offset: q.text.length),
          textAlign: TextAlign.center,
          decoration: InputDecoration(hintText: S.of(context).write_question_hint, border: InputBorder.none)));
}