import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../core/colors.dart';
import '../generated/l10n.dart';
import 'teacher_dashboard.dart';
import 'teacher_matearial.dart' hide HeaderWidget;
import 'grading.dart' hide HeaderWidget;
import 'exam_page.dart' hide HeaderWidget;
import 'review_exam_screen.dart';
import 'teacer_setting.dart';
import 'ExamManagementPage.dart';
import 'teacher_profile_settings_page.dart';
import 'create_ai_exam_provider.dart';
import '../provider/ExamProvider.dart';

import 'create_electronic_exam.dart' show ExamContext, CourseModel, FolderModel;

class CreateAIExamScreen extends StatelessWidget {
  final ExamContext? examContext;
  const CreateAIExamScreen({super.key, this.examContext});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateAIExamProvider()..initWithContext(examContext),
      child: const _CreateAIExamBody(),
    );
  }
}

class _CreateAIExamBody extends StatefulWidget {
  const _CreateAIExamBody();
  @override
  State<_CreateAIExamBody> createState() => _CreateAIExamBodyState();
}

class _CreateAIExamBodyState extends State<_CreateAIExamBody> {
  final int _selectedIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> difficultyKeys = ['EASY', 'MEDIUM', 'HARD'];

  void _handleNavigation(int index) {
    if (index == _selectedIndex) return;
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false)
      Navigator.pop(context);
    Widget? targetPage;
    switch (index) {
      case 0:
        targetPage = const DashboardScreen();
        break;
      case 1:
        targetPage = const ExamManagementPage();
        break;
      case 2:
        targetPage = const Material1();
        break;
      case 3:
        targetPage = const GradingPage();
        break;
      case 4:
        targetPage = const ReviewExamPage();
        break;
      case 5:
        targetPage = const SettingsScreen();
        break;
    }
    if (targetPage != null)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => targetPage!),
      );
  }

  String _getDiffName(String key) {
    switch (key) {
      case 'EASY':
        return S.of(context).diff_easy;
      case 'MEDIUM':
        return S.of(context).diff_medium;
      case 'HARD':
        return S.of(context).diff_hard;
      default:
        return key;
    }
  }

  Future<void> _selectDate(CreateAIExamProvider provider) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryTeal(ctx),
            onPrimary: Colors.white,
            onSurface: AppColors.textPrimary(ctx),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null)
      provider.setDate(
        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}",
      );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateAIExamProvider>();
    final isMobile = MediaQuery.of(context).size.width < 1000;

    if (provider.isLoadingContext) {
      return Scaffold(
        backgroundColor: AppColors.secondaryTeal(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primaryTeal(context)),
              const SizedBox(height: 16),
              const Text(
                'جاري تحميل بيانات المادة...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.secondaryTeal(context),
      drawer: isMobile
          ? Drawer(
              width: 260,
              child: SafeArea(
                child: CustSidebar(
                  selectedIndex: _selectedIndex,
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
              onItemSelected: _handleNavigation,
            ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : 32,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isMobile)
                              IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: AppColors.primaryTeal(context),
                                ),
                                onPressed: () =>
                                    _scaffoldKey.currentState?.openDrawer(),
                              ),
                            _buildPageHeader(provider),
                            const SizedBox(height: 24),
                            _buildCourseInfoBanner(context, provider),
                            const SizedBox(height: 16),
                            _buildExamInfoCard(context, isMobile, provider),
                            const SizedBox(height: 24),
                            _buildTotalQuestionsRow(context, provider),
                            const SizedBox(height: 16),
                            if (isMobile) ...[
                              _buildQuestionsDistribution(context, provider),
                              const SizedBox(height: 24),
                              _buildDifficultySettings(context, provider),
                              const SizedBox(height: 24),
                              _buildUploadArea(context, provider),
                            ] else
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: _buildQuestionsDistribution(
                                        context,
                                        provider,
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        children: [
                                          _buildDifficultySettings(
                                            context,
                                            provider,
                                          ),
                                          const SizedBox(height: 24),
                                          Expanded(
                                            child: _buildUploadArea(
                                              context,
                                              provider,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                    _buildFooterButtons(context, provider),
                  ],
                ),
                if (provider.isLoading) _buildLoadingOverlay(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageHeader(CreateAIExamProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
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
              _iconBtn(Icons.notifications_none),
              const SizedBox(width: 10),
              _iconBtn(
                Icons.person_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileSettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, {VoidCallback? onTap}) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.secondaryTeal(context),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primaryTeal(context)),
    ),
  );

  Widget _buildCourseInfoBanner(
    BuildContext context,
    CreateAIExamProvider provider,
  ) {
    if (provider.folderContext != null && provider.folderContext!.isComplete) {
      final ctx = provider.folderContext!;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primaryTeal(context).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.folder_open_outlined,
              color: AppColors.primaryTeal(context),
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Wrap(
                spacing: 24,
                runSpacing: 6,
                children: [
                  _infoChip(context, Icons.book_outlined, ctx.courseName ?? ''),
                  _infoChip(
                    context,
                    Icons.category_outlined,
                    ctx.specialization ?? '',
                  ),
                  _infoChip(
                    context,
                    Icons.menu_book_outlined,
                    ctx.levelName ?? '',
                  ),
                  _infoChip(
                    context,
                    Icons.folder_outlined,
                    ctx.folderName ?? '',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Row(
        children: [
          Expanded(flex: 2, child: _buildCourseDropdown(context, provider)),
          const SizedBox(width: 16),
          Expanded(flex: 1, child: _buildFolderDropdown(context, provider)),
        ],
      );
    }
  }

  Widget _buildCourseDropdown(
    BuildContext context,
    CreateAIExamProvider provider,
  ) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.textSecondary(context).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.menu_book,
            color: AppColors.primaryTeal(context),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<CourseModel>(
                value: provider.selectedCourse,
                isExpanded: true,
                hint: Text(
                  provider.myCourses.isEmpty
                      ? 'جاري التحميل...'
                      : 'اختر المادة',
                  style: TextStyle(
                    color: provider.myCourses.isEmpty
                        ? Colors.red
                        : AppColors.textSecondary(context),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primaryTeal(context),
                  size: 18,
                ),
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                items: provider.myCourses.map((c) {
                  return DropdownMenuItem<CourseModel>(
                    value: c,
                    child: Text(c.name, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) provider.selectCourse(val);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderDropdown(
    BuildContext context,
    CreateAIExamProvider provider,
  ) {
    final folders = provider.selectedCourse?.folders ?? [];
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.textSecondary(context).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.folder_outlined,
            color: AppColors.primaryTeal(context),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<FolderModel>(
                value: provider.selectedFolder,
                isExpanded: true,
                hint: Text(
                  provider.selectedCourse == null
                      ? 'اختر المادة أولاً'
                      : (folders.isEmpty ? 'لا يوجد مجلدات' : 'اختر المجلد'),
                  style: TextStyle(
                    color: (provider.selectedCourse == null || folders.isEmpty)
                        ? Colors.red
                        : AppColors.textSecondary(context),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primaryTeal(context),
                  size: 18,
                ),
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                items: folders.map((f) {
                  return DropdownMenuItem<FolderModel>(
                    value: f,
                    child: Text(f.name, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) provider.selectFolder(val);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(BuildContext context, IconData icon, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: AppColors.primaryTeal(context)),
      const SizedBox(width: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary(context),
        ),
      ),
    ],
  );

  Widget _buildExamInfoCard(
    BuildContext context,
    bool isMobile,
    CreateAIExamProvider provider,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).exam_info_title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 24),
          if (isMobile) ...[
            _buildTextField(
              label: S.of(context).exam_title_label,
              icon: Icons.description_outlined,
              controller: provider.titleController,
              hint: S.of(context).exam_title_hint,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: S.of(context).exam_date_label,
              icon: Icons.calendar_month_outlined,
              controller: provider.dateController,
              hint: S.of(context).exam_date_hint,
              readOnly: true,
              onTap: () => _selectDate(provider),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: S.of(context).total_grade_label,
              icon: Icons.workspace_premium_outlined,
              controller: provider.gradeController,
              hintColor: AppColors.primaryTeal(context),
              isBoldHint: true,
              isNumber: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: S.of(context).students_count_label,
              icon: Icons.people_outline_rounded,
              controller: provider.studentsController,
              isNumber: true,
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    label: S.of(context).exam_title_label,
                    icon: Icons.description_outlined,
                    controller: provider.titleController,
                    hint: S.of(context).exam_title_hint,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: _buildTextField(
                    label: S.of(context).exam_date_label,
                    icon: Icons.calendar_month_outlined,
                    controller: provider.dateController,
                    hint: S.of(context).exam_date_hint,
                    readOnly: true,
                    onTap: () => _selectDate(provider),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    label: S.of(context).total_grade_label,
                    icon: Icons.workspace_premium_outlined,
                    controller: provider.gradeController,
                    hintColor: AppColors.primaryTeal(context),
                    isBoldHint: true,
                    isNumber: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: _buildTextField(
                    label: S.of(context).students_count_label,
                    icon: Icons.people_outline_rounded,
                    controller: provider.studentsController,
                    isNumber: true,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    TextEditingController? controller,
    String? hint,
    Color? hintColor,
    bool isBoldHint = false,
    bool isNumber = false,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.textSecondary(context).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(icon, color: AppColors.primaryTeal(context), size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary(context),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              keyboardType: isNumber
                  ? TextInputType.number
                  : TextInputType.text,
              inputFormatters: isNumber
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
              style: TextStyle(
                color: hintColor ?? AppColors.textPrimary(context),
                fontSize: 14,
                fontWeight: isBoldHint ? FontWeight.bold : FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(bottom: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTotalQuestionsRow(
    BuildContext context,
    CreateAIExamProvider provider,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.of(context).total_questions,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          Row(
            children: [
              _counterBtn(
                Icons.remove,
                Colors.redAccent,
                provider.decrementTotal,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '${provider.totalQuestions}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTeal(context),
                  ),
                ),
              ),
              _counterBtn(
                Icons.add,
                AppColors.primaryTeal(context),
                provider.incrementTotal,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _counterBtn(IconData icon, Color color, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    ),
  );

  Widget _buildQuestionsDistribution(
    BuildContext context,
    CreateAIExamProvider provider,
  ) {
    final isValid = provider.isDistributionValid;
    final totalColor = isValid ? Colors.green : Colors.redAccent;
    final types = [
      {
        'label': S.of(context).q_mcq,
        'icon': Icons.check_circle_outline,
        'color': Colors.green,
        'value': provider.mcqCount,
        'type': 1,
      },
      {
        'label': S.of(context).q_tf,
        'icon': Icons.close,
        'color': Colors.orange,
        'value': provider.tfCount,
        'type': 2,
      },
      {
        'label': S.of(context).q_essay,
        'icon': Icons.edit_outlined,
        'color': Colors.blue,
        'value': provider.essayCount,
        'type': 3,
      },
      {
        'label': S.of(context).q_match,
        'icon': Icons.sync_alt,
        'color': Colors.purple,
        'value': provider.matchCount,
        'type': 4,
      },
      {
        'label': S.of(context).q_fill,
        'icon': Icons.space_bar_rounded,
        'color': Colors.red,
        'value': provider.fillCount,
        'type': 5,
      },
    ];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    S.of(context).questions_distribution,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.textPrimary(context),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: totalColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${S.of(context).sum_label} ${provider.currentSum.toInt()} / ${provider.totalQuestions}',
                    style: TextStyle(
                      color: totalColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            if (!isValid) ...[
              const SizedBox(height: 8),
              Text(
                S.of(context).unassigned_questions_warning,
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ],
            const SizedBox(height: 20),
            ...types.map(
              (t) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: (t['color'] as Color).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        t['icon'] as IconData,
                        color: t['color'] as Color,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 110,
                      child: Text(
                        t['label'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 6,
                          activeTrackColor: t['color'] as Color,
                          inactiveTrackColor: AppColors.textSecondary(
                            context,
                          ).withValues(alpha: 0.2),
                          thumbColor: t['color'] as Color,
                        ),
                        child: Slider(
                          value: (t['value'] as double),
                          min: 0,
                          max: provider.totalQuestions.toDouble(),
                          divisions: provider.totalQuestions > 0
                              ? provider.totalQuestions
                              : 1,
                          onChanged: (v) =>
                              provider.updateSliderValue(v, t['type'] as int),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        '${(t['value'] as double).toInt()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: t['color'] as Color,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultySettings(
    BuildContext context,
    CreateAIExamProvider provider,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).difficulty_settings,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.textSecondary(context).withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: difficultyKeys.map((key) {
                final isSelected = provider.selectedDifficultyKey == key;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => provider.updateDifficulty(key),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: isSelected
                          ? BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                ),
                              ],
                            )
                          : null,
                      child: Text(
                        _getDiffName(key),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? AppColors.textPrimary(context)
                              : AppColors.textSecondary(context),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadArea(BuildContext context, CreateAIExamProvider provider) {
    return InkWell(
      onTap: () => provider.pickFiles(context, S.of(context).file_open_error),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.primaryTeal(context).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryTeal(context), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload,
              size: 40,
              color: AppColors.primaryTeal(context),
            ),
            const SizedBox(height: 12),
            Text(
              provider.uploadedFiles.isEmpty
                  ? S.of(context).upload_files_prompt
                  : '${S.of(context).files_selected_1} ${provider.uploadedFiles.length} ${S.of(context).files_selected_2}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.primaryTeal(context),
              ),
            ),
            if (provider.uploadedFiles.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...provider.uploadedFiles.asMap().entries.map(
                (e) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.insert_drive_file_outlined,
                      size: 14,
                      color: AppColors.textSecondary(context),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        e.value.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary(context),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => provider.removeFile(e.key),
                      child: const Icon(
                        Icons.close,
                        size: 14,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFooterButtons(
    BuildContext context,
    CreateAIExamProvider provider,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton.icon(
          onPressed: provider.isLoading
              ? null
              : () => provider.generateExamWithAI(
                  context,
                  S.of(context).distribution_error,
                  'الرجاء إدخال اسم الاختبار',
                ),
          icon: const Icon(Icons.auto_awesome, color: Colors.white),
          label: Text(
            S.of(context).generate_ai_exam,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryTeal(context),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: AppColors.primaryTeal(
              context,
            ).withValues(alpha: 0.5),
          ),
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
            SpinKitFadingCube(color: AppColors.primaryTeal(context), size: 60),
            const SizedBox(height: 30),
            Text(
              S.of(context).analyzing_files,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
                fontFamily: 'Arimo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
