import 'package:flutter/material.dart';
import '../core/colors.dart';
import 'teacher_dashboard.dart' hide HeaderWidget;
import 'teacher_matearial.dart' hide HeaderWidget;
import 'grading.dart' hide HeaderWidget;
import 'exam_page.dart'; 

class FinalExamNextPage extends StatefulWidget {
  const FinalExamNextPage({super.key});

  @override
  State<FinalExamNextPage> createState() => _FinalExamNextPageState();
}

class _FinalExamNextPageState extends State<FinalExamNextPage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.secondaryTeal,
        body: Row(
          children: [
            // ✅ Sidebar
          CustSidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                if (index == _selectedIndex) return;
                setState(() => _selectedIndex = index);
                if (index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
                if (index == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Material1()));
                if (index == 3) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GradingPage()));
              },
            ),

            // ✅ Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderWidget(),
                    const SizedBox(height: 20),

                    // ✅ Language Switcher
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: LanguageSwitcherWidget(),
                    ),
                    const SizedBox(height: 10),

                    // ✅ الورقة مع ضبط مكان القلم
                    Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 700),
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  _questionsTableNext(),
                                  const SizedBox(height: 20),
                                  const Text(
                                    " بالتوفيق ---",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            // ✏️ القلم الأخضر مرفوع عند حدود الجدول
                            Positioned(
                              top: 10, // تقليل القيمة لرفعه للأعلى
                              right: 25, // محاذاة القلم مع بداية الجدول أفقياً
                              child: Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: const Color(0xFF65BBAE), // اللون الأخضر
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ✅ الأزرار الموحدة
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // زر تحميل PDF
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.file_download_outlined, size: 18, color: Colors.white),
                              label: const Text("تحميل PDF", style: TextStyle(fontSize: 12, color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF65BBAE),
                                elevation: 2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // زر الصفحة السابقة
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back, size: 18, color: AppColors.primaryTeal),
                              label: const Text("الصفحة السابقة", style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primaryTeal,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(color: Colors.black12),
                                ),
                              ),
                            ),
                          ),
                        ],
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

  Widget _questionsTableNext() => Table(
        columnWidths: const {
          0: FixedColumnWidth(50),
          1: FlexColumnWidth(),
          2: FixedColumnWidth(50),
        },
        border: TableBorder.all(color: Colors.black87, width: 0.8),
        children: [
          _questionRow("3", "3"),
          _questionRow("4", "4"),
          _questionRow("5", "5"),
        ],
      );

  TableRow _questionRow(String q, String mark) => TableRow(
        children: [
          _Cell(txt: q),
          Container(height: 180, color: Colors.white),
          _Cell(txt: mark),
        ],
      );
}

class LanguageSwitcherWidget extends StatelessWidget {
  const LanguageSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLangBtn("English", false),
          _buildLangBtn("العربية", true),
        ],
      ),
    );
  }

  Widget _buildLangBtn(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF65BBAE) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: isSelected ? Colors.white : Colors.black54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String txt;
  const _Cell({required this.txt});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Text(
          txt,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}