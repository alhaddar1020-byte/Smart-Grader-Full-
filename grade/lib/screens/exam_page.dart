import 'package:flutter/material.dart';
import '../core/colors.dart';
import 'teacher_dashboard.dart'; 
import 'teacher_matearial.dart';
import 'grading.dart';
import 'exam_page2.dart';

class FinalExamPage extends StatefulWidget {
  const FinalExamPage({super.key});

  @override
  State<FinalExamPage> createState() => _FinalExamPageState();
}

class _FinalExamPageState extends State<FinalExamPage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.secondaryTeal,
        body: Row(
          children: [
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderWidget(),
                    const SizedBox(height: 20),
                    
                    // ✅ حاوية اللغة المعدلة (نفس تصميم الصفحة الثانية)
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: LanguageSwitcherWidget(),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // ورقة الاختبار الرئيسية
                    const ExamPaperWidget(),
                    
                    const SizedBox(height: 20),
                    
                    // ✅ زر الصفحة التالية (تم توحيد الحجم مع الصفحة الثانية)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 150, // الحجم الموحد
                        height: 40, // الطول الموحد
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FinalExamNextPage()),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward, size: 16),
                          label: const Text("الصفحة التالية", style: TextStyle(fontSize: 12)),
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
}

class ExamPaperWidget extends StatelessWidget {
  const ExamPaperWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0), 
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), 
                blurRadius: 10,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleLogo(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.edit_outlined, size: 16, color: AppColors.primaryTeal),
                      const SizedBox(width: 5),
                      _collegeHeader(),
                    ],
                  ),
                  _circleLogo(),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoGroup([
                    "العام الدراسي: 2025/2024",
                    "تاريخ الاختبار: 2025/11/5",
                    "الممتحن: محمد علي مطر",
                    "الوقت المسموح: ساعة واحدة",
                  ]),
                  _infoGroup([
                    "الفصل الدراسي: 1 (شهري)",
                    "المستوى: 4",
                    "القسم: تقنية المعلومات",
                    "المادة: تطوير تطبيقات الموبايل",
                  ]),
                ],
              ),
              const SizedBox(height: 20),
              _studentNameRow(),
              const SizedBox(height: 15),
              _questionsTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleLogo() => Container(
    width: 55, height: 55,
    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey[300]!)),
    child: const Center(child: Text("شعار", style: TextStyle(fontSize: 9, color: Colors.grey))),
  );

  Widget _collegeHeader() => const Column(
    children: [
      Text("جامعة حضرموت", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      Text("كلية الحاسبات وتكنولوجيا المعلومات", style: TextStyle(fontSize: 11)),
      Text("اختبار شهري", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
    ],
  );

  Widget _infoGroup(List<String> items) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.edit_outlined, size: 14, color: AppColors.primaryTeal),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(item, style: const TextStyle(fontSize: 10, color: Colors.black87)),
          )).toList(),
        ),
      ],
    );
  }

  Widget _studentNameRow() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: Colors.grey[300]!, width: 0.5)),
      ),
      child: Row(
        children: [
          const Text("اسم الطالب:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const Spacer(),
          const Icon(Icons.edit_outlined, size: 14, color: AppColors.primaryTeal),
        ],
      ),
    );
  }

  Widget _questionsTable() => Table(
    columnWidths: const {
      0: FixedColumnWidth(50),
      1: FlexColumnWidth(),
      2: FixedColumnWidth(50),
    },
    border: TableBorder.all(color: Colors.grey[300]!, width: 0.8),
    children: [
      const TableRow(
        decoration: BoxDecoration(color: Color(0xFFF9F9F9)),
        children: [
          _Cell(txt: "سؤال", isBold: true),
          _Cell(txt: "أجب عن جميع الأسئلة التالية", isBold: true),
          _Cell(txt: "درجة", isBold: true),
        ],
      ),
      _questionRow("1", "4"),
      _questionRow("2", "5"),
    ],
  );

  TableRow _questionRow(String q, String mark) => TableRow(
    children: [
      _Cell(txt: q, isBold: true),
      Container(height: 180, color: Colors.white), 
      _Cell(txt: mark, isBold: true),
    ],
  );
}

// ✅ حاوية اللغة بنفس تصميم الصفحة السابقة (المحدث)
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

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "الاختبار",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textprimary),
          ),
          Row(
            children: [
              _iconButton(Icons.notifications_none),
              const SizedBox(width: 10),
              _iconButton(Icons.person_outline),
            ],
          )
        ],
      ),
    );
  }

  static Widget _iconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: AppColors.secondaryTeal,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primaryTeal),
    );
  }
}

class _Cell extends StatelessWidget {
  final String txt;
  final bool isBold;
  const _Cell({required this.txt, this.isBold = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(txt, textAlign: TextAlign.center, 
        style: TextStyle(fontSize: 11, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
    );
  }
}