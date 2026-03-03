import 'package:flutter/material.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDEF6F5),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1440),
          child: Row(
            children: [
              Expanded(child: _MainContent()),
              const _SideBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideBar extends StatelessWidget {
  const _SideBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 389,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF4FB7B5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(55),
          bottomLeft: Radius.circular(55),
        ),
      ),
      child: Column(
        children: const [
          SizedBox(height: 60),
          Text(
            "Intelligent Grading System",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 80),
          _SideItem("لوحة التحكم"),
          _SideItem("المواد", active: true),
          _SideItem("اعدادات"),
        ],
      ),
    );
  }
}

class _SideItem extends StatelessWidget {
  final String title;
  final bool active;

  const _SideItem(this.title, {this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      decoration: active
          ? BoxDecoration(
              color: const Color(0xFFDEF6F5),
              borderRadius: BorderRadius.circular(50),
            )
          : null,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: active ? const Color(0xFF4FB7B5) : Colors.white,
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(),
          const SizedBox(height: 30),
          const _StatsRow(),
          const SizedBox(height: 30),
          const _SemesterTabs(),
          const SizedBox(height: 30),
          Expanded(child: _SubjectsGrid()),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "مرحباً أحمد!",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(
            "نتمنى لك يوماً دراسياً موفقاً",
            style: TextStyle(color: Color(0xFF4A5565)),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _StatCard("أعلى معدل", "92.0%"),
        SizedBox(width: 24),
        _StatCard("المعدل العام", "86.0%"),
        SizedBox(width: 24),
        _StatCard("إجمالي الامتحانات", "13"),
        SizedBox(width: 24),
        _StatCard("إجمالي المواد", "6"),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 227,
      height: 124,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF4A5565))),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _SemesterTabs extends StatelessWidget {
  const _SemesterTabs();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Text(
          "الفصل الدراسي الثاني",
          style: TextStyle(color: Color(0xFF4FB7B5)),
        ),
        SizedBox(width: 400),
        Column(
          children: [
            Text(
              "الفصل الدراسي الاول",
              style: TextStyle(color: Color(0xFF4FB7B5)),
            ),
            SizedBox(height: 5),
            SizedBox(
              width: 280,
              child: Divider(color: Color(0xFF3DA89C), thickness: 2),
            ),
          ],
        ),
      ],
    );
  }
}

class _SubjectsGrid extends StatelessWidget {
  final subjects = const [
    ["الرياضيات", "د. محمد أحمد الصالح", "85.5%", "3"],
    ["الفيزياء", "د. سارة علي الحسن", "90%", "2"],
    ["الكيمياء", "د. خالد محمود", "78%", "2"],
    ["اللغة العربية", "أ. فاطمة يوسف", "88.5%", "2"],
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: subjects.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final s = subjects[index];
        return _SubjectCard(
          name: s[0],
          teacher: s[1],
          grade: s[2],
          exams: s[3],
        );
      },
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final String name;
  final String teacher;
  final String grade;
  final String exams;

  const _SubjectCard({
    required this.name,
    required this.teacher,
    required this.grade,
    required this.exams,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(teacher, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 20),
          Row(
            children: [
              _SmallBox("المعدل", grade),
              const SizedBox(width: 10),
              _SmallBox("عدد الامتحانات", exams),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text("آخر امتحان"),
          ),
        ],
      ),
    );
  }
}

class _SmallBox extends StatelessWidget {
  final String title;
  final String value;

  const _SmallBox(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 10)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4DB8AC),
            ),
          ),
        ],
      ),
    );
  }
}
