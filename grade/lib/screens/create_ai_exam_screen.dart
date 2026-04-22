import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; 
import '../core/colors.dart'; 
import '../generated/l10n.dart'; 
import 'teacher_dashboard.dart';
import 'teacher_matearial.dart' hide HeaderWidget;
import 'grading.dart' hide HeaderWidget;
import 'exam_page.dart' hide HeaderWidget;
import 'review_exam_screen.dart';
import 'teacer_setting.dart';
import 'create_electronic_exam.dart';
import 'ExamManagementPage.dart';
import 'quiz_details_page.dart';
import 'teacher_profile_settings_page.dart';
class CreateAIExamScreen extends StatefulWidget {
  const CreateAIExamScreen({super.key});

  @override
  State<CreateAIExamScreen> createState() => _CreateAIExamScreenState();
}

class _CreateAIExamScreenState extends State<CreateAIExamScreen> {
  final int _selectedIndex = 1; 
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _totalQuestions = 25;
  String _selectedDifficultyKey = 'MEDIUM'; 
  String? _selectedSpecializationKey;
  String? _selectedLevelKey;
  bool _isLoading = false; 

  final List<String> specializationsKeys = ['MATH', 'PHYSICS', 'CHEMISTRY', 'BIOLOGY', 'ARABIC'];
  final List<String> levelsKeys = ['L1', 'L2', 'L3'];
  final List<String> difficultyKeys = ['EASY', 'MEDIUM', 'HARD'];

  List<PlatformFile> uploadedFiles = [];

  final TextEditingController _gradeController = TextEditingController(text: '100');
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _studentsController = TextEditingController();

  double _mcqCount = 10; double _tfCount = 5; double _essayCount = 5; double _matchCount = 5; double _fillCount = 0;
  double get currentSum => _mcqCount + _tfCount + _essayCount + _matchCount + _fillCount;

  @override
  void dispose() {
    _gradeController.dispose(); 
    _titleController.dispose(); 
    _dateController.dispose(); 
    _studentsController.dispose();
    super.dispose();
  }

  void _updateSliderValue(double newValue, int sliderType) {
    double otherSum = 0;
    if (sliderType == 1) otherSum = _tfCount + _essayCount + _matchCount + _fillCount;
    if (sliderType == 2) otherSum = _mcqCount + _essayCount + _matchCount + _fillCount;
    if (sliderType == 3) otherSum = _mcqCount + _tfCount + _matchCount + _fillCount;
    if (sliderType == 4) otherSum = _mcqCount + _tfCount + _essayCount + _fillCount;
    if (sliderType == 5) otherSum = _mcqCount + _tfCount + _essayCount + _matchCount;

    double maxAllowed = _totalQuestions - otherSum;
    setState(() {
      double val = newValue <= maxAllowed ? newValue : maxAllowed;
      if (sliderType == 1) _mcqCount = val;
      if (sliderType == 2) _tfCount = val;
      if (sliderType == 3) _essayCount = val;
      if (sliderType == 4) _matchCount = val;
      if (sliderType == 5) _fillCount = val;
    });
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

  String _getSpecName(String key) {
    switch(key) { 
      case 'MATH': return S.of(context).spec_math; 
      case 'PHYSICS': return S.of(context).spec_physics; 
      case 'CHEMISTRY': return S.of(context).spec_chemistry; 
      case 'BIOLOGY': return S.of(context).spec_biology; 
      case 'ARABIC': return S.of(context).spec_arabic; 
      default: return key; 
    }
  }

  String _getLevelName(String key) {
    switch(key) { case 'L1': return S.of(context).lvl_1; case 'L2': return S.of(context).lvl_2; case 'L3': return S.of(context).lvl_3; default: return key; }
  }

  String _getDiffName(String key) {
    switch(key) { case 'EASY': return S.of(context).diff_easy; case 'MEDIUM': return S.of(context).diff_medium; case 'HARD': return S.of(context).diff_hard; default: return key; }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030),
      builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: AppColors.primaryTeal(context), onPrimary: Colors.white, onSurface: AppColors.textPrimary(context))), child: child!),
    );
    if (picked != null) setState(() => _dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}");
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg']);
      if (result != null) setState(() => uploadedFiles.addAll(result.files));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).file_open_error)));
    }
  }

  void _generateExamWithAI() async {
    if (currentSum != _totalQuestions) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).distribution_error), backgroundColor: Colors.redAccent));
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizDetailsPage()));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 1000;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.secondaryTeal(context),
      drawer: isMobile ? Drawer(width: 260, child: SafeArea(child: CustSidebar(selectedIndex: _selectedIndex, onItemSelected: _handleNavigation))) : null,
      body: Row(
        children: [
          if (!isMobile) CustSidebar(selectedIndex: _selectedIndex, onItemSelected: _handleNavigation),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 32.0, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isMobile) IconButton(icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)), onPressed: () => _scaffoldKey.currentState?.openDrawer()),
                            _buildPageHeader(), 
                            const SizedBox(height: 24),
                            _buildExamInfoCard(context, isMobile),
                            const SizedBox(height: 24),
                            _buildTotalQuestionsRow(context),
                            const SizedBox(height: 16),
                            if (isMobile) ...[
                              _buildQuestionsDistribution(context), const SizedBox(height: 24),
                              _buildDifficultySettings(context), const SizedBox(height: 24),
                              _buildUploadArea(context),
                            ] else ...[
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(flex: 6, child: _buildQuestionsDistribution(context)), 
                                    const SizedBox(width: 24),
                                    Expanded(flex: 4, child: Column(children: [_buildDifficultySettings(context), const SizedBox(height: 24), Expanded(child: _buildUploadArea(context))])),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    _buildFooterButtons(context),
                  ],
                ),
                if (_isLoading) _buildLoadingOverlay(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildPageHeader() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(S.of(context).create_electronic_exam, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
  //             const SizedBox(height: 4),
  //             Text(S.of(context).generate_ai_exam, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 14)),
  //           ],
  //         ),
  //         Row(children: [
  //           _topIconButton(Icons.notifications_none),
  //           const SizedBox(width: 10),
  //           _topIconButton(Icons.person_outline)
  //         ])
  //       ],
  //     ),
  //   );
  // }

  // Widget _topIconButton(IconData icon) => Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle), child: Icon(icon, color: AppColors.primaryTeal(context)));
Widget _buildPageHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).create_electronic_exam,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                S.of(context).generate_ai_exam,
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _topIconButton(Icons.notifications_none, onTap: () {
                // أكشن التنبيهات
              }),
              const SizedBox(width: 10),
              
              // ربط أيقونة الشخص بصفحة ProfileSettingsPage
              _topIconButton(Icons.person_outline, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileSettingsPage()),
                );
              }),
            ],
          )
        ],
      ),
    );
  }

  // تحديث الدالة المساعدة لتصبح قابلة للضغط وتغيير شكل الماوس
  Widget _topIconButton(IconData icon, {VoidCallback? onTap}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // تظهر يد الماوس عند الوقوف عليها
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.secondaryTeal(context),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryTeal(context)),
        ),
      ),
    );
  }
  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.6), 
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitFadingCube(color: AppColors.primaryTeal(context), size: 60.0), 
            const SizedBox(height: 30),
            Text(S.of(context).analyzing_files, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.none, fontFamily: 'Arimo')),
          ],
        ),
      ),
    );
  }

  Widget _buildExamInfoCard(BuildContext context, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).exam_info_title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary(context))),
          const SizedBox(height: 24),
          if (isMobile) ...[
            _buildTextField(context, label: S.of(context).exam_title_label, icon: Icons.description_outlined, controller: _titleController, hintText: S.of(context).exam_title_hint), const SizedBox(height: 16),
            _buildTextField(context, label: S.of(context).exam_date_label, icon: Icons.calendar_month_outlined, controller: _dateController, hintText: S.of(context).exam_date_hint, readOnly: true, onTap: () => _selectDate(context)), const SizedBox(height: 16),
            _buildTextField(context, label: S.of(context).total_grade_label, icon: Icons.workspace_premium_outlined, controller: _gradeController, hintColor: AppColors.primaryTeal(context), isBoldHint: true, isNumber: true), const SizedBox(height: 16),
            _buildDropdownField(context, label: S.of(context).specialization_label, icon: Icons.category_outlined, items: specializationsKeys, value: _selectedSpecializationKey, isSpec: true, onChanged: (v) => setState(() => _selectedSpecializationKey = v)), const SizedBox(height: 16),
            _buildDropdownField(context, label: S.of(context).level_label, icon: Icons.menu_book_outlined, items: levelsKeys, value: _selectedLevelKey, isSpec: false, onChanged: (v) => setState(() => _selectedLevelKey = v)), const SizedBox(height: 16),
            _buildTextField(context, label: S.of(context).students_count_label, icon: Icons.people_outline_rounded, controller: _studentsController, isNumber: true),
          ] else ...[
            Row(
              children: [
                Expanded(flex: 2, child: _buildTextField(context, label: S.of(context).exam_title_label, icon: Icons.description_outlined, controller: _titleController, hintText: S.of(context).exam_title_hint)), const SizedBox(width: 16),
                Expanded(flex: 1, child: _buildTextField(context, label: S.of(context).exam_date_label, icon: Icons.calendar_month_outlined, controller: _dateController, hintText: S.of(context).exam_date_hint, readOnly: true, onTap: () => _selectDate(context))), const SizedBox(width: 16),
                Expanded(flex: 1, child: _buildTextField(context, label: S.of(context).total_grade_label, icon: Icons.workspace_premium_outlined, controller: _gradeController, hintColor: AppColors.primaryTeal(context), isBoldHint: true, isNumber: true)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(flex: 2, child: _buildDropdownField(context, label: S.of(context).specialization_label, icon: Icons.category_outlined, items: specializationsKeys, value: _selectedSpecializationKey, isSpec: true, onChanged: (v) => setState(() => _selectedSpecializationKey = v))), const SizedBox(width: 16),
                Expanded(flex: 1, child: _buildDropdownField(context, label: S.of(context).level_label, icon: Icons.menu_book_outlined, items: levelsKeys, value: _selectedLevelKey, isSpec: false, onChanged: (v) => setState(() => _selectedLevelKey = v))), const SizedBox(width: 16),
                Expanded(flex: 1, child: _buildTextField(context, label: S.of(context).students_count_label, icon: Icons.people_outline_rounded, controller: _studentsController, isNumber: true)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, {required String label, required IconData icon, TextEditingController? controller, String? hintText, Color? hintColor, bool isBoldHint = false, bool isNumber = false, bool readOnly = false, VoidCallback? onTap}) {
    return Container(
      height: 48, 
      decoration: BoxDecoration(color: AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.textSecondary(context).withValues(alpha: 0.2))),
      child: Row(
        children: [
          const SizedBox(width: 12), Icon(icon, color: AppColors.primaryTeal(context), size: 20), const SizedBox(width: 8),
          Flexible(child: Text(label, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)), const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller, keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : null, readOnly: readOnly, onTap: onTap,
              style: TextStyle(color: hintColor ?? AppColors.textPrimary(context), fontWeight: isBoldHint ? FontWeight.bold : FontWeight.w500, fontSize: 14),
              decoration: InputDecoration(hintText: hintText, border: InputBorder.none, contentPadding: const EdgeInsets.only(bottom: 12)),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildDropdownField(BuildContext context, {required String label, required IconData icon, required List<String> items, required String? value, required bool isSpec, required Function(String?) onChanged}) {
    return Container(
      height: 48, padding: const EdgeInsetsDirectional.only(end: 12, start: 8),
      decoration: BoxDecoration(color: AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.textSecondary(context).withValues(alpha: 0.2))),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryTeal(context), size: 20), const SizedBox(width: 8),
          Flexible(child: Text(label, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)), const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value, isExpanded: true, dropdownColor: AppColors.textWhite(context),
                hint: Text(S.of(context).select_hint, style: TextStyle(color: AppColors.textSecondary(context).withValues(alpha: 0.5), fontSize: 13)), 
                icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary(context)), 
                items: items.map((String itemKey) { return DropdownMenuItem<String>(value: itemKey, child: Text(isSpec ? _getSpecName(itemKey) : _getLevelName(itemKey), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary(context)))); }).toList(), 
                onChanged: onChanged
              )
            )
          ),
        ],
      ),
    );
  }

  Widget _buildTotalQuestionsRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(S.of(context).total_questions, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
          Row(
            children: [
              InkWell(onTap: () { setState(() { if (_totalQuestions > 1) { _totalQuestions--; if (currentSum > _totalQuestions) { _mcqCount = _totalQuestions.toDouble(); _tfCount = 0; _essayCount = 0; _matchCount = 0; _fillCount = 0; } } }); }, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.remove, color: Colors.white, size: 20))),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('$_totalQuestions', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryTeal(context)))),
              InkWell(onTap: () => setState(() => _totalQuestions++), child: Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.primaryTeal(context), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.add, color: Colors.white, size: 20))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsDistribution(BuildContext context) {
    bool isTotalValid = currentSum == _totalQuestions; Color totalColor = isTotalValid ? Colors.green : Colors.redAccent;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(S.of(context).questions_distribution, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary(context)), overflow: TextOverflow.ellipsis)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: totalColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)), child: Text('${S.of(context).sum_label} ${currentSum.toInt()} / $_totalQuestions', style: TextStyle(color: totalColor, fontWeight: FontWeight.bold, fontSize: 13))),
            ],
          ),
          const SizedBox(height: 24),
          _buildInteractiveSlider(context, S.of(context).q_mcq, Icons.check_circle_outline, Colors.green, _mcqCount, (val) => _updateSliderValue(val, 1)), const SizedBox(height: 12),
          _buildInteractiveSlider(context, S.of(context).q_tf, Icons.close, Colors.orange, _tfCount, (val) => _updateSliderValue(val, 2)), const SizedBox(height: 12),
          _buildInteractiveSlider(context, S.of(context).q_essay, Icons.edit_outlined, Colors.blue, _essayCount, (val) => _updateSliderValue(val, 3)), const SizedBox(height: 12),
          _buildInteractiveSlider(context, S.of(context).q_match, Icons.sync_alt, Colors.purple, _matchCount, (val) => _updateSliderValue(val, 4)), const SizedBox(height: 12),
          _buildInteractiveSlider(context, S.of(context).q_fill, Icons.space_bar_rounded, Colors.red, _fillCount, (val) => _updateSliderValue(val, 5)),
        ],
      ),
    );
  }

  Widget _buildInteractiveSlider(BuildContext context, String title, IconData icon, Color color, double value, Function(double) onChanged) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 18)), const SizedBox(width: 12),
        SizedBox(width: 110, child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary(context)), maxLines: 1, overflow: TextOverflow.ellipsis)),
        Expanded(child: SliderTheme(data: SliderThemeData(trackHeight: 6, activeTrackColor: color, inactiveTrackColor: AppColors.textSecondary(context).withValues(alpha: 0.2), thumbColor: color), child: Slider(value: value, min: 0, max: _totalQuestions.toDouble(), divisions: _totalQuestions > 0 ? _totalQuestions : 1, onChanged: onChanged))),
        SizedBox(width: 60, child: Text('${value.toInt()}', textAlign: TextAlign.center, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12))),
      ],
    );
  }

  Widget _buildDifficultySettings(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).difficulty_settings, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary(context))), const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(4), 
            decoration: BoxDecoration(color: AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.textSecondary(context).withValues(alpha: 0.1))), 
            child: Row(children: difficultyKeys.map((key) => _buildDifficultyOption(context, key)).toList())
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyOption(BuildContext context, String key) {
    bool isSelected = _selectedDifficultyKey == key;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedDifficultyKey = key),
        child: Container(
          alignment: Alignment.center, padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: isSelected ? BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))]) : null,
          child: Text(_getDiffName(key), style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.textPrimary(context) : AppColors.textSecondary(context))),
        ),
      ),
    );
  }

  Widget _buildUploadArea(BuildContext context) {
    return InkWell(
      onTap: _pickFiles,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        decoration: BoxDecoration(color: AppColors.primaryTeal(context).withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primaryTeal(context), width: 1.5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload, size: 40, color: AppColors.primaryTeal(context)), const SizedBox(height: 12),
            Text(uploadedFiles.isEmpty ? S.of(context).upload_files_prompt : '${S.of(context).files_selected_1} ${uploadedFiles.length} ${S.of(context).files_selected_2}', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryTeal(context))),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterButtons(BuildContext context) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(color: AppColors.textWhite(context), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, -4))]),
      child: SafeArea(
        child: Wrap(
          spacing: 16, runSpacing: 16, alignment: WrapAlignment.end,
          children: [
            
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _generateExamWithAI, 
              icon: const Icon(Icons.auto_awesome, color: Colors.white),
              label: Text(S.of(context).generate_ai_exam, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal(context), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ],
        ),
      ),
    );
  }
}