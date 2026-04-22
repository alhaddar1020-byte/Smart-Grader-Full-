import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../core/colors.dart';
import 'teacher_dashboard.dart';
import 'teacher_matearial.dart';
import 'exam_page.dart';
import '../generated/l10n.dart'; // استيراد كلاس الترجمة
import 'review_exam_screen.dart';
import 'teacer_setting.dart';
import 'ExamManagementPage.dart';
import 'teacher_profile_settings_page.dart';
class GradingPage extends StatefulWidget {
  const GradingPage({super.key});

  @override
  State<GradingPage> createState() => _GradingPageState();
}

class _GradingPageState extends State<GradingPage> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController examNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController(text: "2026/03/11");
  final TextEditingController questionsCountController = TextEditingController(text: "4");
  final TextEditingController totalGradeController = TextEditingController(text: "50");

  List<PlatformFile> selectedFiles = [];
  bool isGrading = false;
  bool isGradingComplete = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      // تعبئة القيم المبدئية مع الترجمة
      subjectController.text = S.of(context).advanced_programming;
      examNameController.text = S.of(context).midterm_exam;
      _isInit = true;
    }
  }

  Future<void> pickFiles() async {
    if (isGrading) return;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFiles.addAll(result.files);
      });
    }
  }

  @override
  void dispose() {
    subjectController.dispose();
    examNameController.dispose();
    dateController.dispose();
    questionsCountController.dispose();
    totalGradeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool hasFiles = selectedFiles.isNotEmpty;

    // تم إزالة Directionality الثابت
    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 850;
      bool isTablet = constraints.maxWidth >= 850 && constraints.maxWidth < 1150;

      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.secondaryTeal(context),
        drawer: isMobile
            ? Drawer(
                width: 260,
                backgroundColor: AppColors.primaryTeal(context),
                child: SafeArea(
                  child: CustSidebar(
                    selectedIndex: 3,
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
                selectedIndex: 3,
                isCompact: isTablet,
                onItemSelected: _handleNavigation,
              ),
            Expanded(
              child: Column(
                children: [
                  if (isMobile) _buildMobileAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 12 : 24,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeaderWidget(),
                          const SizedBox(height: 15),
                          _buildExamInfoSection(isMobile, isTablet),
                          const SizedBox(height: 15),
                          _buildResponsiveUploadRow(isMobile, hasFiles),
                          const SizedBox(height: 25),
                          if (isGradingComplete)
                            _buildCompleteCard()
                          else if (isGrading)
                            _buildProcessingCard()
                          else if (hasFiles)
                            _buildFileListSection(),
                          const SizedBox(height: 40),
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
            Text(S.of(context).auto_grading, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveUploadRow(bool isMobile, bool hasFiles) {
    if (isMobile) {
      return Column(
        children: [
          _buildUploadCard(isFullWidth: true),
          const SizedBox(height: 16),
          _buildStatusCard(hasFiles, isFullWidth: true),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUploadCard(isFullWidth: false),
        const SizedBox(width: 20),
        _buildStatusCard(hasFiles, isFullWidth: false),
      ],
    );
  }

  Widget _buildUploadCard({required bool isFullWidth}) {
    Widget card = Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload_outlined,
              size: 50, color: isGrading ? Colors.grey : AppColors.primaryTeal(context)),
          const SizedBox(height: 10),
          Text(S.of(context).click_to_select_files),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: isGrading ? null : pickFiles,
            icon: const Icon(Icons.file_upload, color: Colors.white),
            label: Text(S.of(context).choose_files, style: const TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: isGrading ? Colors.grey[400] : AppColors.primaryTeal(context),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
    return isFullWidth ? card : Expanded(flex: 2, child: card);
  }

  Widget _buildStatusCard(bool hasFiles, {required bool isFullWidth}) {
    Widget card = Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFiles ? Icons.check_circle_outline_rounded : Icons.priority_high_rounded,
            size: 40,
            color: isGrading ? Colors.grey : (hasFiles ? AppColors.primaryTeal(context) : Colors.orange),
          ),
          const SizedBox(height: 10),
          Text(isGrading
              ? S.of(context).processing_data
              : (hasFiles ? S.of(context).ready_to_start_grading : S.of(context).no_papers_attached)),
          Text("${selectedFiles.length} ${S.of(context).valid_answer_sheets}"),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: (hasFiles && !isGrading)
                    ? () async {
                        setState(() => isGrading = true);
                        await Future.delayed(const Duration(seconds: 3));
                        setState(() {
                          isGrading = false;
                          isGradingComplete = true;
                        });
                      }
                    : null,
                icon: const Icon(Icons.update_rounded, size: 18),
                label: Text(S.of(context).start_auto_grading, style: const TextStyle(fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: (hasFiles && !isGrading) ? AppColors.primaryTeal(context) : Colors.grey[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () => setState(() { if (isGrading) isGrading = false; else selectedFiles = []; }),
                style: OutlinedButton.styleFrom(side: BorderSide(color: isGrading ? Colors.grey : Colors.redAccent)),
                child: Text(S.of(context).cancel, style: TextStyle(color: isGrading ? Colors.grey : Colors.redAccent)),
              ),
            ],
          ),
        ],
      ),
    );
    return isFullWidth ? card : Expanded(flex: 3, child: card);
  }

  Widget _buildProcessingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              const SizedBox(width: 8),
              Text(S.of(context).auto_grading_in_progress, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(S.of(context).do_not_close_page_during_grading, style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).overall_progress, style: const TextStyle(fontSize: 12, color: Colors.black)),
              Text("${(selectedFiles.length * 0.24).toInt()} / ${selectedFiles.length}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.orange)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(value: 0.24, minHeight: 10, backgroundColor: Color(0xFFE5E5E5), valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent)),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _statBox("29", S.of(context).completed, Icons.check_circle),
              const SizedBox(width: 10),
              _statBox("3", S.of(context).in_progress, Icons.sync),
              const SizedBox(width: 10),
              _statBox("88", S.of(context).waiting, Icons.access_time),
              const SizedBox(width: 10),
              _statBox("2", S.of(context).remaining, Icons.trending_up),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCompleteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.check_circle_outline, color: Colors.green, size: 28), const SizedBox(width: 8), Text(S.of(context).auto_grading_completed, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)))]),
          const SizedBox(height: 15),
          ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal(context), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)), child: Text(S.of(context).view_graded_papers, style: const TextStyle(color: Colors.white))),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(S.of(context).overall_progress), Text("${selectedFiles.length} / ${selectedFiles.length}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))]),
          const SizedBox(height: 10),
          ClipRRect(borderRadius: BorderRadius.circular(20), child: const LinearProgressIndicator(value: 1, minHeight: 10, backgroundColor: Color(0xFFE5E5E5), valueColor: AlwaysStoppedAnimation<Color>(Colors.green))),
          const SizedBox(height: 20),
          Row(
            children: [
              _statBox("${selectedFiles.length}", S.of(context).completed, Icons.check_circle),
              const SizedBox(width: 10),
              _statBox("0", S.of(context).in_progress, Icons.sync),
              const SizedBox(width: 10),
              _statBox("0", S.of(context).waiting, Icons.access_time),
              const SizedBox(width: 10),
              _statBox("0", S.of(context).remaining, Icons.trending_up),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBox(String number, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(icon, size: 20, color: AppColors.primaryTeal(context)), Text(number, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)))]),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildExamInfoSection(bool isMobile, bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity, 
      decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).exam_information, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _infoTextField(S.of(context).course_subject, subjectController, isMobile, isTablet),
              _infoTextField(S.of(context).exam_name, examNameController, isMobile, isTablet),
              _infoTextField(S.of(context).exam_date, dateController, isMobile, isTablet),
              _infoTextField(S.of(context).number_of_questions, questionsCountController, isMobile, isTablet),
              _infoTextField(S.of(context).total_grade, totalGradeController, isMobile, isTablet),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTextField(String label, TextEditingController controller, bool isMobile, bool isTablet) {
    double fieldWidth;
    if (isMobile) {
      fieldWidth = MediaQuery.of(context).size.width - 60; 
    } else if (isTablet) {
      fieldWidth = (MediaQuery.of(context).size.width - 320) / 2; 
    } else {
      fieldWidth = 180; 
    }

    return SizedBox(
      width: fieldWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            enabled: !isGrading,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: AppColors.secondaryTeal(context).withValues(alpha: 0.3),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileListSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(S.of(context).uploaded_files, style: const TextStyle(fontWeight: FontWeight.bold)), TextButton(onPressed: () => setState(() => selectedFiles = []), child: Text(S.of(context).delete_all, style: const TextStyle(color: Colors.redAccent)))]),
          const Divider(height: 30),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedFiles.length,
            separatorBuilder: (context, index) => const Divider(height: 20),
            itemBuilder: (context, index) => Row(children: [const Icon(Icons.check_circle, color: Colors.green, size: 20), const SizedBox(width: 10), Expanded(child: Text(selectedFiles[index].name, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)), IconButton(icon: const Icon(Icons.close, color: Colors.redAccent, size: 18), onPressed: () => setState(() => selectedFiles.removeAt(index)))]),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(int index) {
    if (index == 3) return;
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);

    Widget? page;
    if (index == 0) page = const DashboardScreen();
    if (index == 1) page = const ExamManagementPage();
    if (index == 2) page = const Material1();
    if (index == 4)  page = const ReviewExamPage(); 
    if (index == 5)  page = const SettingsScreen(); 

    if (page != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => page!),
        (route) => false,
      );
    }
  }
}

// class HeaderWidget extends StatelessWidget {
//   const HeaderWidget({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(15)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(S.of(context).upload_answer_sheets, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))), const SizedBox(height: 4), Text(S.of(context).upload_answer_sheets_desc, style: const TextStyle(fontSize: 12, color: Colors.grey))]),
//           Row(children: [_iconButton(context, Icons.notifications_none), const SizedBox(width: 10), _iconButton(context, Icons.person_outline)])
//         ],
//       ),
//     );
//   }
//   Widget _iconButton(BuildContext context, IconData icon) => Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle), child: Icon(icon, color: AppColors.primaryTeal(context)));
// }


class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context), 
        borderRadius: BorderRadius.circular(15)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // القسم النصي (يسار)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Text(
                S.of(context).upload_answer_sheets, 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))
              ), 
              const SizedBox(height: 4), 
              Text(
                S.of(context).upload_answer_sheets_desc, 
                style: const TextStyle(fontSize: 12, color: Colors.grey)
              )
            ]
          ),

          // قسم الأيقونات (يمين)
          Row(
            children: [
              _iconButton(context, Icons.notifications_none, () {
                // أكشن التنبيهات
              }),
              const SizedBox(width: 10),
              
              // ربط أيقونة الشخص بصفحة ProfileSettingsPage
              _iconButton(context, Icons.person_outline, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileSettingsPage()),
                );
              }),
            ]
          )
        ],
      ),
    );
  }

  // دالة الأيقونة المحدثة لتكون قابلة للضغط
  Widget _iconButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // تغيير شكل الماوس ليد عند الوقوف عليها
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.secondaryTeal(context), 
            shape: BoxShape.circle
          ),
          child: Icon(icon, color: AppColors.primaryTeal(context)),
        ),
      ),
    );
  }
}