import 'package:flutter/material.dart';
import '../core/colors.dart';

class Material1 extends StatelessWidget {
  const Material1({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.secondaryTeal,
        body: Row(
          children: const [
            SidebarWidget(),
            Expanded(
              child: MainContent(),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= MAIN CONTENT ================= */

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          HeaderWidget(),
          SizedBox(height: 25),
          StatsTopRow(),
          SizedBox(height: 35),
          SubjectsGrid(),
        ],
      ),
    );
  }
}

/* ================= SIDEBAR ================= */

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.symmetric(vertical: 35),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          Center(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.textWhite.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(Icons.auto_graph_rounded, size: 42, color: AppColors.textWhite),
            ),
          ),
          const SizedBox(height: 18),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Intelligent Grading System",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textWhite, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 45),
          _menuItem(Icons.dashboard_outlined, "لوحة التحكم"),
          _menuItem(Icons.assignment_outlined, "إدارة الامتحانات"),
          _menuItem(Icons.menu_book_outlined, "المواد", active: true),
          _menuItem(Icons.verified_outlined, "تصحيح"),
          _menuItem(Icons.fact_check_outlined, "مراجعة"),
          _menuItem(Icons.settings_outlined, "إعدادات"),
        ],
      ),
    );
  }

  static Widget _menuItem(IconData icon, String title, {bool active = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: active ? AppColors.textWhite.withValues(alpha: 0.20) : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textWhite, size: 23),
          const SizedBox(width: 18),
          Expanded(
            child: Text(title, style: const TextStyle(color: AppColors.textWhite, fontSize: 15, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

/* ================= HEADER ================= */

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(18)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("المواد الدراسية", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textprimary)),
              SizedBox(height: 4),
              Text("قم بإدارة جميع المواد والامتحانات الخاصة بك", style: TextStyle(color: AppColors.textseccondary, fontSize: 13)),
            ],
          ),
          Row(children: [ _icon(Icons.notifications_none), const SizedBox(width: 10), _icon(Icons.person_outline) ])
        ],
      ),
    );
  }
  static Widget _icon(IconData icon) {
    return Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: AppColors.secondaryTeal, shape: BoxShape.circle), child: Icon(icon, color: AppColors.primaryTeal, size: 20));
  }
}

/* ================= STATS ================= */

class StatsTopRow extends StatelessWidget {
  const StatsTopRow({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statCard("الطلاب", "340", Icons.people, AppColors.accentYellow),
        _statCard("الأوراق المصححة", "780", Icons.description, AppColors.primaryTeal),
        _statCard("الاختبارات المنشئة", "13", Icons.quiz, AppColors.primaryTeal),
        _statCard("المسودات", "5", Icons.edit_note, AppColors.primaryTeal),
      ],
    );
  }
  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(value, style: const TextStyle(color: AppColors.textWhite, fontSize: 22, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: AppColors.textWhite, fontSize: 13)),
            ]),
            Icon(icon, color: AppColors.textWhite.withValues(alpha: 0.7), size: 32),
          ],
        ),
      ),
    );
  }
}

/* ================= SUBJECTS GRID WITH DIALOG ================= */

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
            _subjectCard(cardWidth, "discrete - المستوى الأول", "علوم حاسوب", "1", "340"),
            _subjectCard(cardWidth, "فيزياء عملي - المستوى الأول", "تقنية معلومات", "0", "101"),
            // هنا تم فصل التفاضل والتكامل
            _subjectCard(cardWidth, "تفاضل - المستوى الأول", "تقنية معلومات", "9", "101"),
            _subjectCard(cardWidth, "تكامل - المستوى الأول", "تقنية معلومات", "0", "101"),
            _addSubjectCard(context, cardWidth),
          ],
        );
      },
    );
  }

  void _showAddSubjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
                const Text("إضافة مادة جديدة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textprimary)),
                const SizedBox(height: 5),
                const Text("يرجى إدخال بيانات المادة أدناه", style: TextStyle(fontSize: 12, color: AppColors.textseccondary)),
                const SizedBox(height: 25),
                _buildField("اسم المادة"),
                _buildField("التخصص"),
                _buildField("المستوى الدراسي"),
                _buildField("عدد الطلاب"),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryTeal,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text("إضافة مادة", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primaryTeal),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text("إلغاء", style: TextStyle(color: AppColors.primaryTeal)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          filled: true,
          fillColor: AppColors.secondaryTeal.withValues(alpha: 0.2),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        ),
      ),
    );
  }

  Widget _subjectCard(double width, String title, String dept, String exams, String students) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(28)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.book_outlined, color: AppColors.primaryTeal, size: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: AppColors.secondaryTeal, borderRadius: BorderRadius.circular(12)),
                child: Text(dept, style: const TextStyle(fontSize: 11, color: AppColors.primaryTeal)),
              )
            ],
          ),
          const SizedBox(height: 25),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.textprimary)),
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

  Widget _infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textseccondary, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textprimary)),
      ],
    );
  }

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
          border: Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.3), width: 1.5),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: AppColors.primaryTeal, size: 50),
            SizedBox(height: 12),
            Text("إضافة مادة", style: TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
