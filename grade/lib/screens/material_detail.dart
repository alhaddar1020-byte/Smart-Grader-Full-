import 'package:flutter/material.dart';
import '../core/colors.dart';
import 'teacher_dashboard.dart'; 
import 'grading.dart' hide HeaderWidget;
import 'teacher_matearial.dart' hide HeaderWidget;
import 'exam_page.dart' hide HeaderWidget;
import '../generated/l10n.dart'; // استيراد الترجمة
import 'review_exam_screen.dart' hide HeaderWidget;
import 'teacer_setting.dart';
import 'ExamManagementPage.dart';
import 'create_ai_exam_screen.dart';
import 'create_electronic_exam.dart';
class SubjectDetailsPage extends StatefulWidget {
  const SubjectDetailsPage({super.key});

  @override
  State<SubjectDetailsPage> createState() => _SubjectDetailsPageState();
}

class _SubjectDetailsPageState extends State<SubjectDetailsPage> {
  String selectedFolderName = ""; 
  int currentPage = 1;
  final int _selectedIndex = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _folderController = TextEditingController();

  Map<String, Map<int, List<Map<String, String>>>> folderData = {};
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      // تعبئة البيانات بالترجمة
      selectedFolderName = S.of(context).first_month;
      folderData = {
        S.of(context).first_month: {
          1: [
            {"name": S.of(context).exam_calculus_a, "date": S.of(context).date_feb_12, "count": "101", "status": S.of(context).status_completed},
            {"name": S.of(context).exam_calculus_b, "date": S.of(context).date_feb_25, "count": "101", "status": S.of(context).status_completed},
            {"name": S.of(context).exam_calculus_c, "date": S.of(context).date_mar_12, "count": "101", "status": S.of(context).status_draft},
          ],
        },
        S.of(context).second_month: {
          1: [
            {"name": S.of(context).exam_integration_a, "date": S.of(context).date_apr_01, "count": "95", "status": S.of(context).status_completed},
            {"name": S.of(context).exam_integration_b, "date": S.of(context).date_apr_10, "count": "95", "status": S.of(context).status_draft},
          ],
        },
        S.of(context).final_exams: {
          1: [
            {"name": S.of(context).final_math_1, "date": S.of(context).date_jun_15, "count": "101", "status": S.of(context).status_draft},
            {"name": S.of(context).final_math_2, "date": S.of(context).date_jun_16, "count": "101", "status": S.of(context).status_draft},
            {"name": S.of(context).final_math_3, "date": S.of(context).date_jun_17, "count": "101", "status": S.of(context).status_draft},
          ],
          2: [
            {"name": S.of(context).final_physics_a, "date": S.of(context).date_jun_18, "count": "101", "status": S.of(context).status_draft},
            {"name": S.of(context).final_physics_b, "date": S.of(context).date_jun_19, "count": "101", "status": S.of(context).status_draft},
            {"name": S.of(context).final_physics_c, "date": S.of(context).date_jun_20, "count": "101", "status": S.of(context).status_draft},
          ],
          3: [
            {"name": S.of(context).final_chemistry_a, "date": S.of(context).date_jun_21, "count": "101", "status": S.of(context).status_completed},
            {"name": S.of(context).final_chemistry_b, "date": S.of(context).date_jun_22, "count": "101", "status": S.of(context).status_completed},
            {"name": S.of(context).final_chemistry_c, "date": S.of(context).date_jun_23, "count": "101", "status": S.of(context).status_draft},
          ]
        },
      };
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _folderController.dispose();
    super.dispose();
  }

  void _showAddFolderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(S.of(context).add_new_folder, textAlign: TextAlign.start),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _folderController,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: S.of(context).new_folder_name,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(S.of(context).cancel)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal(context)),
            onPressed: () {
              if (_folderController.text.trim().isNotEmpty) {
                setState(() {
                  folderData[_folderController.text.trim()] = {1: []};
                  selectedFolderName = _folderController.text.trim();
                  currentPage = 1;
                });
                _folderController.clear();
                Navigator.pop(context);
              }
            },
            child: Text(S.of(context).save, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _getUpdatedTime(String folderName) {
    if (folderName == S.of(context).first_month) return S.of(context).two_days_ago;
    if (folderName == S.of(context).second_month) return S.of(context).a_week_ago;
    if (folderName == S.of(context).final_exams) return S.of(context).a_month_ago;
    return S.of(context).just_now; 
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> currentExams = folderData[selectedFolderName]?[currentPage] ?? [];
    int totalFiles = 0;
    folderData[selectedFolderName]?.forEach((key, value) => totalFiles += value.length);
    int totalPages = folderData[selectedFolderName]?.keys.length ?? 1;

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
                      padding: EdgeInsets.all(isMobile ? 16 : 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeaderWidget(), 
                          const SizedBox(height: 15),
                          _buildBreadcrumbCard(selectedFolderName), 
                          const SizedBox(height: 25),
                          
                          _buildResponsiveFolders(isMobile),
                          
                          const SizedBox(height: 25),
                          
                          ExamTableSection(
                            folderName: selectedFolderName,
                            exams: currentExams,
                            currentPage: currentPage,
                            totalPages: totalPages,
                            totalFiles: totalFiles,
                            isMobile: isMobile,
                            onPageChanged: (page) => setState(() => currentPage = page),
                            onDelete: (index) {
                              setState(() {
                                folderData[selectedFolderName]![currentPage]!.removeAt(index);
                              });
                            },
                            onEdit: (index, newName, newDate, newCount) {
                              setState(() {
                                folderData[selectedFolderName]![currentPage]![index]['name'] = newName;
                                folderData[selectedFolderName]![currentPage]![index]['date'] = newDate;
                                folderData[selectedFolderName]![currentPage]![index]['count'] = newCount;
                              });
                            },
                          ),
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
            Text(S.of(context).subject_details, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);
    
    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
    } else if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ExamManagementPage()));
    }
    else if (index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Material1()));
    } else if (index == 3) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GradingPage()));
    }
     else if (index == 4) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ReviewExamPage()));
    }
     else if (index == 5) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
    }
  }

  Widget _buildResponsiveFolders(bool isMobile) {
    List<Widget> folderWidgets = folderData.keys.map((name) {
      int count = 0;
      folderData[name]?.forEach((k, v) => count += v.length);
      String updatedTime = _getUpdatedTime(name);
      return _folderItemCard(name, "$count ${S.of(context).files} • $updatedTime");
    }).toList();

    folderWidgets.add(
      InkWell(
        onTap: _showAddFolderDialog,
        borderRadius: BorderRadius.circular(20),
        child: const AddFolderCard(),
      ),
    );

    if (isMobile) {
      return SizedBox(
        height: 140,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: folderWidgets.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) => SizedBox(width: 170, child: folderWidgets[index]),
        ),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: folderWidgets.map((fw) => Container(
            width: 240, 
            margin: const EdgeInsetsDirectional.only(end: 15),
            child: fw,
          )).toList(),
        ),
      );
    }
  }

  Widget _folderItemCard(String title, String info) {
    return InkWell(
      onTap: () => setState(() {
        selectedFolderName = title;
        currentPage = 1;
      }),
      borderRadius: BorderRadius.circular(20),
      child: FolderCard(title, info, isActive: selectedFolderName == title),
    );
  }

  Widget _buildBreadcrumbCard(String currentFolder) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;
    IconData arrowIcon = isRtl ? Icons.chevron_left : Icons.chevron_right;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Material1())),
            child: Text(S.of(context).materials, style: const TextStyle(color: Colors.grey, fontSize: 13, decoration: TextDecoration.underline)),
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Icon(arrowIcon, color: Colors.grey, size: 16)),
          Text(S.of(context).calculus, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Icon(arrowIcon, color: Colors.grey, size: 16)),
          Text(currentFolder, style: TextStyle(color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

/* ================= جدول الاختبارات ================= */
class ExamTableSection extends StatelessWidget {
  final String folderName;
  final List<Map<String, String>> exams;
  final int currentPage;
  final int totalPages;
  final int totalFiles;
  final bool isMobile; 
  final Function(int) onPageChanged;
  final Function(int) onDelete;
  final Function(int, String, String, String) onEdit;

  const ExamTableSection({
    required this.folderName,
    required this.exams,
    required this.currentPage,
    required this.totalPages,
    required this.totalFiles,
    required this.isMobile,
    required this.onPageChanged,
    required this.onDelete,
    required this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text("${S.of(context).exams_list} $folderName", style: TextStyle(fontWeight: FontWeight.bold, fontSize: isMobile ? 14 : 16))),
              ElevatedButton.icon(
                onPressed: () => _showExamTypeDialog(context),
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: Text(S.of(context).create_exam, style: TextStyle(color: Colors.white, fontSize: isMobile ? 12 : 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal(context),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          isMobile ? _buildMobileList(context) : _buildTable(context),
          
          if (totalPages > 1) ...[
            const SizedBox(height: 20),
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPageNum("<", onTap: () => currentPage > 1 ? onPageChanged(currentPage - 1) : null),
                    for (int i = 1; i <= totalPages; i++)
                      _buildPageNum("$i", active: currentPage == i, onTap: () => onPageChanged(i)),
                    _buildPageNum(">", onTap: () => currentPage < totalPages ? onPageChanged(currentPage + 1) : null),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal, 
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FB)),
              columns: [
                DataColumn(label: Text(S.of(context).exam_name)),
                DataColumn(label: Text(S.of(context).exam_date)),
                DataColumn(label: Text(S.of(context).number_of_students)),
                DataColumn(label: Text(S.of(context).status)),
                DataColumn(label: Text(S.of(context).actions)),
              ],
              rows: exams.asMap().entries.map((entry) {
                int index = entry.key;
                var exam = entry.value;
                final isCompleted = exam['status'] == S.of(context).status_completed;
                return _buildRow(
                  context,
                  index,
                  exam, 
                  isCompleted ? AppColors.primaryTeal(context) : Colors.grey,
                );
              }).toList(),
            ),
          ),
        );
      }
    );
  }

  DataRow _buildRow(BuildContext context, int index, Map<String, String> exam, Color color) {
    return DataRow(cells: [
      DataCell(Text(exam['name']!)),
      DataCell(Text(exam['date']!)),
      DataCell(Text(exam['count']!)),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
        child: Text(exam['status']!, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      )),
      DataCell(Row(
        mainAxisSize: MainAxisSize.min, 
        children: [
          const Icon(Icons.visibility_outlined, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _showEditDialog(context, index, exam),
            child: const Icon(Icons.edit_outlined, size: 18, color: Colors.grey)
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => onDelete(index),
            child: const Icon(Icons.delete_outline, size: 18, color: Colors.red)
          ),
        ],
      )),
    ]);
  }

  void _showEditDialog(BuildContext context, int index, Map<String, String> examData) {
    TextEditingController nameController = TextEditingController(text: examData['name']);
    TextEditingController dateController = TextEditingController(text: examData['date']);
    TextEditingController countController = TextEditingController(text: examData['count']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(S.of(context).edit_exam_data, textAlign: TextAlign.start),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController, 
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                labelText: S.of(context).exam_name,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              )
            ),
            const SizedBox(height: 12),
            TextField(
              controller: dateController, 
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                labelText: S.of(context).exam_date,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              )
            ),
            const SizedBox(height: 12),
            TextField(
              controller: countController, 
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: S.of(context).number_of_students,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              )
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(S.of(context).cancel)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal(context)),
            onPressed: () {
              if(nameController.text.isNotEmpty) {
                onEdit(index, nameController.text, dateController.text, countController.text);
              }
              Navigator.pop(context);
            }, 
            child: Text(S.of(context).save, style: const TextStyle(color: Colors.white))
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList(BuildContext context) {
    return Column(
      children: exams.asMap().entries.map((entry) {
        int index = entry.key;
        var exam = entry.value;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          color: const Color(0xFFF8F9FB),
          child: ListTile(
            title: Text(exam['name']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            subtitle: Text("${exam['date']!} • ${exam['count']!} ${S.of(context).student}", style: const TextStyle(fontSize: 11)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.visibility_outlined, size: 18, color: Colors.grey)
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _showEditDialog(context, index, exam),
                  child: const Icon(Icons.edit_outlined, size: 18, color: Colors.grey)
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => onDelete(index),
                  child: const Icon(Icons.delete_outline, size: 18, color: Colors.red)
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPageNum(String label, {bool active = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.orange.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: active ? Border.all(color: Colors.orange) : null,
        ),
        child: Text(label, style: TextStyle(color: active ? Colors.orange : Colors.grey)),
      ),
    );
  }

  // void _showExamTypeDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => Dialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
  //       child: Container(
  //         width: 360,
  //         padding: const EdgeInsets.all(25),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Align(alignment: AlignmentDirectional.topStart, child: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))),
  //             Text(S.of(context).choose_exam_type, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //             const SizedBox(height: 25),
  //             SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton(
  //                 onPressed: () {},
  //                 style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal(context), padding: const EdgeInsets.symmetric(vertical: 12)),
  //                 child: Text(S.of(context).create_manual_exam, style: const TextStyle(color: Colors.white, fontSize: 16)),
  //               ),
  //             ),
  //             const SizedBox(height: 12),
  //             SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton(
  //                 onPressed: () {},
  //                 style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF1F3F4), padding: const EdgeInsets.symmetric(vertical: 12)),
  //                 child: Text(S.of(context).create_ai_exam, style: TextStyle(color: AppColors.primaryTeal(context), fontSize: 15)),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  void _showExamTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Text(
                S.of(context).choose_exam_type,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              
              // --- زر إنشاء اختبار يدوي ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // إغلاق الدايلوج
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateElectronicExamPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal(context),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    S.of(context).create_manual_exam,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // --- زر إنشاء اختبار بالذكاء الاصطناعي ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // إغلاق الدايلوج
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateAIExamScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F3F4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    S.of(context).create_ai_exam,
                    style: TextStyle(
                      color: AppColors.primaryTeal(context),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ================= المجلدات ================= */
class FolderCard extends StatelessWidget {
  final String title;
  final String info;
  final bool isActive;
  const FolderCard(this.title, this.info, {this.isActive = false, super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isActive ? Border.all(color: AppColors.primaryTeal(context), width: 2) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(Icons.folder, color: Color(0xFFFFD180), size: 35), Icon(Icons.more_vert, color: Colors.grey, size: 18)]),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(info, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}

class AddFolderCard extends StatelessWidget {
  const AddFolderCard({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5), 
        borderRadius: BorderRadius.circular(20), 
        border: Border.all(color: Colors.black12, style: BorderStyle.solid)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(Icons.create_new_folder_outlined, color: Colors.grey, size: 35), Icon(Icons.add, color: Colors.grey, size: 18)]),
          const SizedBox(height: 15),
          Text(S.of(context).new_folder, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(S.of(context).add_new_folder, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}