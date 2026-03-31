import 'package:flutter/material.dart';
import '../core/colors.dart';
import 'teacher_dashboard.dart'; 
import 'grading.dart' hide HeaderWidget;
import 'teacher_matearial.dart' hide HeaderWidget;
import 'exam_page.dart' hide HeaderWidget;

class SubjectDetailsPage extends StatefulWidget {
  const SubjectDetailsPage({super.key});

  @override
  State<SubjectDetailsPage> createState() => _SubjectDetailsPageState();
}

class _SubjectDetailsPageState extends State<SubjectDetailsPage> {
  String selectedFolderName = "الشهر الأول";
  int currentPage = 1;
  final int _selectedIndex = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _folderController = TextEditingController();

  final Map<String, Map<int, List<Map<String, String>>>> folderData = {
    "الشهر الأول": {
      1: [
        {"name": "اختبار التفاضل - نموذج A", "date": "12 فبراير 2026", "count": "101", "status": "مكتمل"},
        {"name": "اختبار التفاضل - نموذج B", "date": "25 فبراير 2026", "count": "101", "status": "مكتمل"},
        {"name": "اختبار التفاضل - نموذج C", "date": "12 مارس 2026", "count": "101", "status": "مسودة"},
      ],
    },
    "الشهر الثاني": {
      1: [
        {"name": "اختبار التكامل - نموذج A", "date": "01 أبريل 2026", "count": "95", "status": "مكتمل"},
        {"name": "اختبار التكامل - نموذج B", "date": "10 أبريل 2026", "count": "95", "status": "مسودة"},
      ],
    },
    "الاختبارات النهائية": {
      1: [
        {"name": "النهائي - رياضيات 1", "date": "15 يونيو 2026", "count": "101", "status": "مسودة"},
        {"name": "النهائي - رياضيات 2", "date": "16 يونيو 2026", "count": "101", "status": "مسودة"},
        {"name": "النهائي - رياضيات 3", "date": "17 يونيو 2026", "count": "101", "status": "مسودة"},
      ],
      2: [
        {"name": "النهائي - فيزياء A", "date": "18 يونيو 2026", "count": "101", "status": "مسودة"},
        {"name": "النهائي - فيزياء B", "date": "19 يونيو 2026", "count": "101", "status": "مسودة"},
        {"name": "النهائي - فيزياء C", "date": "20 يونيو 2026", "count": "101", "status": "مسودة"},
      ],
      3: [
        {"name": "النهائي - كيمياء A", "date": "21 يونيو 2026", "count": "101", "status": "مكتمل"},
        {"name": "النهائي - كيمياء B", "date": "22 يونيو 2026", "count": "101", "status": "مكتمل"},
        {"name": "النهائي - كيمياء C", "date": "23 يونيو 2026", "count": "101", "status": "مسودة"},
      ]
    },
  };

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
        title: const Text("إضافة مجلد جديد", textAlign: TextAlign.right),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _folderController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: "اسم المجلد الجديد",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
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
            child: const Text("حفظ", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _getUpdatedTime(String folderName) {
    if (folderName == "الشهر الأول") return "منذ يومين";
    if (folderName == "الشهر الثاني") return "منذ أسبوع";
    if (folderName == "الاختبارات النهائية") return "منذ شهر";
    return "الآن"; 
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> currentExams = folderData[selectedFolderName]?[currentPage] ?? [];
    int totalFiles = 0;
    folderData[selectedFolderName]?.forEach((key, value) => totalFiles += value.length);
    int totalPages = folderData[selectedFolderName]?.keys.length ?? 1;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: LayoutBuilder(builder: (context, constraints) {
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
                              // دالة التعديل أصبحت تستقبل 3 قيم (الاسم، التاريخ، عدد الطلاب)
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
            const Text("تفاصيل المادة", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);
    
    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
    } else if (index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Material1()));
    } else if (index == 3) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GradingPage()));
    }
  }

  Widget _buildResponsiveFolders(bool isMobile) {
    List<Widget> folderWidgets = folderData.keys.map((name) {
      int count = 0;
      folderData[name]?.forEach((k, v) => count += v.length);
      String updatedTime = _getUpdatedTime(name);
      return _folderItemCard(name, "$count ملفات • $updatedTime");
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
            margin: const EdgeInsets.only(left: 15),
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
            child: const Text("المواد", style: TextStyle(color: Colors.grey, fontSize: 13, decoration: TextDecoration.underline)),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.chevron_left, color: Colors.grey, size: 16)),
          const Text("التفاضل", style: TextStyle(color: Colors.grey, fontSize: 13)),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.chevron_left, color: Colors.grey, size: 16)),
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
  // دالة التعديل أصبحت تتطلب 3 بيانات
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
              Expanded(child: Text("قائمة اختبارات $folderName", style: TextStyle(fontWeight: FontWeight.bold, fontSize: isMobile ? 14 : 16))),
              ElevatedButton.icon(
                onPressed: () => _showExamTypeDialog(context),
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: Text("إنشاء اختبار", style: TextStyle(color: Colors.white, fontSize: isMobile ? 12 : 14)),
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
              columns: const [
                DataColumn(label: Text("اسم الاختبار")),
                DataColumn(label: Text("تاريخ الاختبار")),
                DataColumn(label: Text("عدد الطلاب")),
                DataColumn(label: Text("الحالة")),
                DataColumn(label: Text("الإجراءات")),
              ],
              rows: exams.asMap().entries.map((entry) {
                int index = entry.key;
                var exam = entry.value;
                final isCompleted = exam['status'] == "مكتمل";
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
            // تمرير كائن الاختبار بالكامل لتعبئة الحقول
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

  // دالة التعديل المحسنة لتشمل 3 حقول
  void _showEditDialog(BuildContext context, int index, Map<String, String> examData) {
    TextEditingController nameController = TextEditingController(text: examData['name']);
    TextEditingController dateController = TextEditingController(text: examData['date']);
    TextEditingController countController = TextEditingController(text: examData['count']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("تعديل بيانات الاختبار", textAlign: TextAlign.right),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController, 
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                labelText: "اسم الاختبار",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              )
            ),
            const SizedBox(height: 12),
            TextField(
              controller: dateController, 
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                labelText: "تاريخ الاختبار",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              )
            ),
            const SizedBox(height: 12),
            TextField(
              controller: countController, 
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "عدد الطلاب",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              )
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal(context)),
            onPressed: () {
              if(nameController.text.isNotEmpty) {
                // إرسال البيانات الثلاثة لحفظها
                onEdit(index, nameController.text, dateController.text, countController.text);
              }
              Navigator.pop(context);
            }, 
            child: const Text("حفظ", style: TextStyle(color: Colors.white))
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
        Color statusColor = exam['status'] == "مكتمل" ? AppColors.primaryTeal(context) : Colors.grey;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          color: const Color(0xFFF8F9FB),
          child: ListTile(
            title: Text(exam['name']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            subtitle: Text("${exam['date']!} • ${exam['count']!} طالب", style: const TextStyle(fontSize: 11)),
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
              Align(alignment: Alignment.topLeft, child: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))),
              const Text("اختر نوع الاختبار", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal(context), padding: const EdgeInsets.symmetric(vertical: 12)),
                  child: const Text("انشاء اختبار يدوي", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF1F3F4), padding: const EdgeInsets.symmetric(vertical: 12)),
                  child: Text("انشاء اختبار بالذكاء الاصطناعي", style: TextStyle(color: AppColors.primaryTeal(context), fontSize: 15)),
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(Icons.create_new_folder_outlined, color: Colors.grey, size: 35), Icon(Icons.add, color: Colors.grey, size: 18)]),
          SizedBox(height: 15),
          Text("مجلد جديد", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
          SizedBox(height: 4),
          Text("إضافة مجلد جديد", style: TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}