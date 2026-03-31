

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../core/colors.dart';
import 'teacher_dashboard.dart';
import 'teacher_matearial.dart';
import 'exam_page.dart';

class GradingPage extends StatefulWidget {
  const GradingPage({super.key});

  @override
  State<GradingPage> createState() => _GradingPageState();
}

class _GradingPageState extends State<GradingPage> {
  final TextEditingController subjectController = TextEditingController(text: "البرمجة المتقدمة");
  final TextEditingController examNameController = TextEditingController(text: "الامتحان النصفي");
  final TextEditingController dateController = TextEditingController(text: "2026/03/11");
  final TextEditingController questionsCountController = TextEditingController(text: "4");
  final TextEditingController totalGradeController = TextEditingController(text: "50");

  List<PlatformFile> selectedFiles = [];
  bool isGrading = false;
  bool isGradingComplete = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: LayoutBuilder(builder: (context, constraints) {
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
                            // تصميم الحاويات المطلوب (flex 2 للرفع و flex 3 للحالة)
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
            const Text("التصحيح الآلي", style: TextStyle(fontWeight: FontWeight.bold)),
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
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload_outlined,
              size: 50, color: isGrading ? Colors.grey : AppColors.primaryTeal(context)),
          const SizedBox(height: 10),
          const Text("انقر لتحديد الملفات من جهازك"),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: isGrading ? null : pickFiles,
            icon: const Icon(Icons.file_upload, color: Colors.white),
            label: const Text("اختر الملفات", style: TextStyle(color: Colors.white)),
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
        color: AppColors.textWhite,
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
              ? "جاري معالجة البيانات..."
              : (hasFiles ? "جاهز لبدء التصحيح الآن" : "لم يتم ارفاق الاوراق")),
          Text("${selectedFiles.length} ورقة إجابة صالحة"),
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
                label: const Text("بدء التصحيح الآلي", style: TextStyle(fontSize: 13)),
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
                child: Text("إلغاء", style: TextStyle(color: isGrading ? Colors.grey : Colors.redAccent)),
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
              Text("جاري التصحيح الآلي...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
            ],
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text("يرجى عدم إغلاق هذه الصفحة أثناء عملية التصحيح الآلي.", style: TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("التقدم الكلي", style: TextStyle(fontSize: 12, color: Colors.black)),
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
              _statBox("29", "مكتملة", Icons.check_circle),
              const SizedBox(width: 10),
              _statBox("3", "جاري", Icons.sync),
              const SizedBox(width: 10),
              _statBox("88", "انتظار", Icons.access_time),
              const SizedBox(width: 10),
              _statBox("2", "متبقي", Icons.trending_up),
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
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.check_circle_outline, color: Colors.green, size: 28), const SizedBox(width: 8), Text("اكتمل التصحيح الآلي!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)))]),
          const SizedBox(height: 15),
          ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal(context), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)), child: const Text("عرض الاوراق المصححة", style: TextStyle(color: Colors.white))),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("التقدم الكلي"), Text("${selectedFiles.length} / ${selectedFiles.length}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))]),
          const SizedBox(height: 10),
          ClipRRect(borderRadius: BorderRadius.circular(20), child: const LinearProgressIndicator(value: 1, minHeight: 10, backgroundColor: Color(0xFFE5E5E5), valueColor: AlwaysStoppedAnimation<Color>(Colors.green))),
          const SizedBox(height: 20),
          Row(
            children: [
              _statBox("${selectedFiles.length}", "مكتملة", Icons.check_circle),
              const SizedBox(width: 10),
              _statBox("0", "جاري", Icons.sync),
              const SizedBox(width: 10),
              _statBox("0", "انتظار", Icons.access_time),
              const SizedBox(width: 10),
              _statBox("0", "متبقي", Icons.trending_up),
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

  // Widget _buildExamInfoSection(bool isMobile, bool isTablet) {
  //   return Container(
  //     padding: const EdgeInsets.all(14),
  //     decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(12)),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text("معلومات الامتحان", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
  //         const SizedBox(height: 12),
  //         Wrap(
  //           spacing: 10,
  //           runSpacing: 10,
  //           children: [
  //             _infoTextField("المادة الدراسية", subjectController, isMobile),
  //             _infoTextField("اسم الامتحان", examNameController, isMobile),
  //             _infoTextField("تاريخ الامتحان", dateController, isMobile),
  //             _infoTextField("عدد الأسئلة", questionsCountController, isMobile),
  //             _infoTextField("الدرجة الكلية", totalGradeController, isMobile),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _infoTextField(String label, TextEditingController controller, bool isMobile) {
  //   double width = isMobile ? (MediaQuery.of(context).size.width - 60) : 180;
  //   return SizedBox(
  //     width: width,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(label, style: const TextStyle(fontSize: 10)),
  //         const SizedBox(height: 4),
  //         TextField(
  //           controller: controller,
  //           enabled: !isGrading,
  //           textAlign: TextAlign.center,
  //           style: const TextStyle(fontSize: 11),
  //           decoration: InputDecoration(
  //             isDense: true,
  //             filled: true,
  //             fillColor: AppColors.secondaryTeal(context).withValues(alpha: 0.3),
  //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
// --- تحديث قسم معلومات الامتحان ليكون بعرض الشاشة في التابلت والموبايل ---
  Widget _buildExamInfoSection(bool isMobile, bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity, // يضمن أن الحاوية تأخذ كامل العرض المتاح
      decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("معلومات الامتحان", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          // الـ Wrap سيقوم بتوزيع الحقول تلقائياً
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _infoTextField("المادة الدراسية", subjectController, isMobile, isTablet),
              _infoTextField("اسم الامتحان", examNameController, isMobile, isTablet),
              _infoTextField("تاريخ الامتحان", dateController, isMobile, isTablet),
              _infoTextField("عدد الأسئلة", questionsCountController, isMobile, isTablet),
              _infoTextField("الدرجة الكلية", totalGradeController, isMobile, isTablet),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTextField(String label, TextEditingController controller, bool isMobile, bool isTablet) {
    // التعديل الذكي هنا:
    // إذا كان موبايل أو تابلت، نعطي عرض كبير (أو نستخدم LayoutBuilder للحساب الدقيق)
    // هنا جعلناه في التابلت يأخذ مساحة كافية وإذا زاد العدد ينزل للسطر التالي
    double fieldWidth;
    if (isMobile) {
      fieldWidth = MediaQuery.of(context).size.width - 60; // عرض كامل للموبايل
    } else if (isTablet) {
      fieldWidth = (MediaQuery.of(context).size.width - 320) / 2; // حقلين في الصف للتابلت ليكون العرض ممتازاً
    } else {
      fieldWidth = 180; // العرض الأصلي للويب
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
      decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("الملفات المرفوعة", style: TextStyle(fontWeight: FontWeight.bold)), TextButton(onPressed: () => setState(() => selectedFiles = []), child: const Text("حذف الكل", style: TextStyle(color: Colors.redAccent)))]),
          const Divider(height: 30),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedFiles.length,
            separatorBuilder: (context, index) => const Divider(height: 20),
            itemBuilder: (context, index) => Row(children: [const Icon(Icons.check_circle, color: Colors.green, size: 20), const SizedBox(width: 10), Text(selectedFiles[index].name, style: const TextStyle(fontSize: 13)), const Spacer(), IconButton(icon: const Icon(Icons.close, color: Colors.redAccent, size: 18), onPressed: () => setState(() => selectedFiles.removeAt(index)))]),
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
    if (index == 1) page = const FinalExamPage();
    if (index == 2) page = const Material1();

    if (page != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => page!),
        (route) => false,
      );
    }
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("رفع اوراق الاجابات", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))), const SizedBox(height: 4), const Text("قم برفع أوراق الإجابة بصيغة PDF لبدء التصحيح الآلي")]),
          Row(children: [_iconButton(context, Icons.notifications_none), const SizedBox(width: 10), _iconButton(context, Icons.person_outline)])
        ],
      ),
    );
  }
  Widget _iconButton(BuildContext context, IconData icon) => Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle), child: Icon(icon, color: AppColors.primaryTeal(context)));
}