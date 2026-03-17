
import 'package:flutter/material.dart';
import '../core/colors.dart';
import 'teacher_dashboard.dart'; // تأكدي من استيراد الملف الذي يحتوي على كلاس CustSidebar
import 'grading.dart'hide HeaderWidget;
import 'teacher_matearial.dart' hide HeaderWidget;
class SubjectDetailsPage extends StatefulWidget {
  const SubjectDetailsPage({super.key});

  @override
  State<SubjectDetailsPage> createState() => _SubjectDetailsPageState();
}

class _SubjectDetailsPageState extends State<SubjectDetailsPage> {
  String selectedFolderName = "الشهر الأول";
  int currentPage = 1;
  
  // نحدد 2 لأن هذه الصفحة تتبع قسم "المواد" في القائمة الجانبية
  final int _selectedIndex = 2;

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
    },
  };

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
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
            onPressed: () => Navigator.pop(context),
            child: const Text("حفظ", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> currentExams = folderData[selectedFolderName]?[currentPage] ?? [];
    int totalFiles = 0;
    folderData[selectedFolderName]?.forEach((key, value) => totalFiles += value.length);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.secondaryTeal,
        body: Row(
          children: [
            // القائمة الجانبية الموحدة
            CustSidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                if (index == 0) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  );
                } else if (index == 2) {
                  Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Material1()),
              );
                }
                else if (index == 3) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const GradingPage()),
                  );
                }
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderWidget(),
                    const SizedBox(height: 15),
                    _buildBreadcrumbCard(selectedFolderName),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        _folderItem("الشهر الأول", "3 ملفات • منذ يومين"),
                        const SizedBox(width: 15),
                        _folderItem("الشهر الثاني", "2 ملفات • منذ أسبوع"),
                        const SizedBox(width: 15),
                        _folderItem("الاختبارات النهائية", "9 ملفات • منذ شهر"),
                        const SizedBox(width: 15),
                        Expanded(
                          child: InkWell(
                            onTap: _showAddFolderDialog,
                            borderRadius: BorderRadius.circular(20),
                            child: const AddFolderCard(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    ExamTableSection(
                      folderName: selectedFolderName,
                      exams: currentExams,
                      currentPage: currentPage,
                      totalFiles: totalFiles,
                      onPageChanged: (page) => setState(() => currentPage = page),
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

  Widget _folderItem(String title, String info) {
    return Expanded(
      child: InkWell(
        onTap: () => setState(() {
          selectedFolderName = title;
          currentPage = 1;
        }),
        child: FolderCard(title, info, isActive: selectedFolderName == title),
      ),
    );
  }
}

/* ================= شريط المسار المحدث ================= */

Widget _buildBreadcrumbCard(String currentFolder) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Row(
      children: [
        const Text("المواد", style: TextStyle(color: Colors.grey, fontSize: 13)),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.chevron_left, color: Colors.grey, size: 16)),
        const Text("التفاضل", style: TextStyle(color: Colors.grey, fontSize: 13)),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.chevron_left, color: Colors.grey, size: 16)),
        Text(currentFolder, style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    ),
  );
}

/* ================= جدول الاختبارات ================= */

class ExamTableSection extends StatelessWidget {
  final String folderName;
  final List<Map<String, String>> exams;
  final int currentPage;
  final int totalFiles;
  final Function(int) onPageChanged;

  const ExamTableSection({
    required this.folderName,
    required this.exams,
    required this.currentPage,
    required this.totalFiles,
    required this.onPageChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("قائمة اختبارات $folderName", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ElevatedButton.icon(
                onPressed: () => _showExamTypeDialog(context),
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: const Text("إنشاء اختبار", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTable(),
          if (totalFiles > 3) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPageNum("<", onTap: () => currentPage > 1 ? onPageChanged(currentPage - 1) : null),
                _buildPageNum("1", active: currentPage == 1, onTap: () => onPageChanged(1)),
                _buildPageNum("2", active: currentPage == 2, onTap: () => onPageChanged(2)),
                _buildPageNum("3", active: currentPage == 3, onTap: () => onPageChanged(3)),
                _buildPageNum(">", onTap: () => currentPage < 3 ? onPageChanged(currentPage + 1) : null),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTable() {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(const Color(0xFFF8F9FB)),
        columns: const [
          DataColumn(label: Text("اسم الاختبار")),
          DataColumn(label: Text("تاريخ الاختبار")),
          DataColumn(label: Text("عدد الطلاب")),
          DataColumn(label: Text("الحالة")),
          DataColumn(label: Text("الإجراءات")),
        ],
        rows: exams.map((exam) => _buildRow(
          exam['name']!, exam['date']!, exam['count']!, exam['status']!,
          exam['status'] == "مكتمل" ? AppColors.primaryTeal : Colors.grey,
        )).toList(),
      ),
    );
  }

  DataRow _buildRow(String name, String date, String count, String status, Color color) {
    return DataRow(cells: [
      DataCell(Text(name)),
      DataCell(Text(date)),
      DataCell(Text(count)),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      )),
      const DataCell(Row(
        children: [
          Icon(Icons.visibility_outlined, size: 18, color: Colors.grey),
          SizedBox(width: 10),
          Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
          SizedBox(width: 10),
          Icon(Icons.delete_outline, size: 18, color: Colors.red),
        ],
      )),
    ]);
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
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
                  child: const Text("انشاء اختبار يدوي", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF1F3F4)),
                  child: const Text("انشاء اختبار بالذكاء الاصطناعي", style: TextStyle(color: AppColors.primaryTeal)),
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
        border: isActive ? Border.all(color: AppColors.primaryTeal, width: 2) : null,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(Icons.folder, color: Color(0xFFFFD180), size: 35), Icon(Icons.more_vert, color: Colors.grey, size: 18)]),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
        color: Colors.white.withOpacity(0.5), 
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