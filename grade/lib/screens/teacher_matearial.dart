import 'package:flutter/material.dart';
import 'teacher_dashboard.dart';
import '../core/colors.dart';
import 'material_detail.dart';
import 'grading.dart';
import 'exam_page.dart';
class Material1 extends StatefulWidget {
  const Material1({super.key});

  @override
  State<Material1> createState() => _Material1State();
}

class _Material1State extends State<Material1> {

  int _selectedIndex = 2;

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
              setState(() {
                _selectedIndex = index;
              });

                if (index == 0) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  );
                }
                else if (index == 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const FinalExamPage()),
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

            const Expanded(
              child: MainContent(),
            ),
          ],
        ),
      ),
    );
  }
}
////////////////////////////////////////////////////////////
/// المحتوى الرئيسي
////////////////////////////////////////////////////////////

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWidget(),
          SizedBox(height: 25),
          TopStatsGrid(),
          SizedBox(height: 35),
          SubjectsGrid(),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// الهيدر
////////////////////////////////////////////////////////////

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "المواد الدراسية",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textprimary),
              ),
              SizedBox(height: 4),
              Text(
                "قم بإدارة جميع المواد والامتحانات الخاصة بك",
                style: TextStyle(color: AppColors.textseccondary),
              ),
            ],
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

////////////////////////////////////////////////////////////
/// البطاقات العلوية
////////////////////////////////////////////////////////////

class TopStatsGrid extends StatelessWidget {
  const TopStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statCard("الطلاب", "340", AppColors.accentYellow, Icons.people),
        _statCard("الأوراق المصححة", "780", AppColors.primaryTeal, Icons.description),
        _statCard("الاختبارات المنشئة", "13", AppColors.primaryTeal, Icons.create),
        _statCard("المسودات", "5", AppColors.primaryTeal, Icons.edit_note),
      ],
    );
  }

  Widget _statCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                Text(title,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 14)),
              ],
            ),
            Icon(icon, color: Colors.white54, size: 40),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// شبكة المواد
////////////////////////////////////////////////////////////

class SubjectsGrid extends StatelessWidget {
  const SubjectsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        double width = constraints.maxWidth;
        double cardWidth = (width - 40) / 3;

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [

            _subjectCard(context, cardWidth,
                "discrete - المستوى الأول", "علوم حاسوب", "1", "340"),

            _subjectCard(context, cardWidth,
                "فيزياء عملي - المستوى الأول", "تقنية معلومات", "0", "101"),

            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubjectDetailsPage(),
                  ),
                );
              },
              child: _subjectCard(context, cardWidth,
                  "تفاضل - المستوى الأول", "تقنية معلومات", "9", "101"),
            ),

            _subjectCard(context, cardWidth,
                "تكامل - المستوى الأول", "تقنية معلومات", "0", "101"),

            _addSubjectCard(context, cardWidth),
          ],
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////

  Widget _subjectCard(BuildContext context, double width,
      String title, String dept, String exams, String students) {

    return Container(
      width: width,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.textprimary.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.book_outlined,
                  color: AppColors.primaryTeal, size: 30),

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondaryTeal,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  dept,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.primaryTeal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 25),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: AppColors.textprimary,
            ),
          ),

          const SizedBox(height: 35),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoTile("الامتحانات", exams),
              _infoTile("عدد الطلاب", students),
            ],
          )
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////

  Widget _infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textseccondary, fontSize: 13)),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.textprimary)),
      ],
    );
  }

  ////////////////////////////////////////////////////////////

  Widget _addSubjectCard(BuildContext context, double width) {

    return InkWell(
      onTap: () => _showAddSubjectDialog(context),

      borderRadius: BorderRadius.circular(28),

      child: Container(
        width: width,
        height: 220,

        decoration: BoxDecoration(
          color: AppColors.secondaryTeal.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
              color: AppColors.primaryTeal.withValues(alpha: 0.3),
              width: 1.5),
        ),

        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline,
                color: AppColors.primaryTeal, size: 50),
            SizedBox(height: 12),
            Text("إضافة مادة",
                style: TextStyle(
                    color: AppColors.primaryTeal,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////

  void _showAddSubjectDialog(BuildContext context) {

    showDialog(
      context: context,
      builder: (context) {

        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)),

          child: Container(
            width: 400,
            padding: const EdgeInsets.all(25),

            decoration: BoxDecoration(
              color: AppColors.textWhite,
              borderRadius: BorderRadius.circular(25),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                const Text("إضافة مادة جديدة",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textprimary)),

                const SizedBox(height: 20),

                _buildField("اسم المادة"),
                _buildField("التخصص"),
                _buildField("المستوى الدراسي"),
                _buildField("عدد الطلاب"),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("إضافة مادة"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////

  Widget _buildField(String label) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: TextField(
        textAlign: TextAlign.right,

        decoration: InputDecoration(
          hintText: label,

          filled: true,
          fillColor: AppColors.secondaryTeal.withValues(alpha: 0.3),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
