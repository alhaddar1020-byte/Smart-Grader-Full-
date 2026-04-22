import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../generated/l10n.dart'; // تفعيل ملفات الترجمة
import 'create_electronic_exam.dart';
import 'teacher_dashboard.dart';
import 'create_ai_exam_screen.dart';
import 'teacher_matearial.dart' hide HeaderWidget;
import 'grading.dart' hide HeaderWidget;
import 'review_exam_screen.dart';
import 'teacer_setting.dart';
import 'teacher_profile_settings_page.dart';
class ExamManagementPage extends StatefulWidget {
  const ExamManagementPage({super.key});

  @override
  State<ExamManagementPage> createState() => _ExamManagementPageState();
}

class _ExamManagementPageState extends State<ExamManagementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int _selectedIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  String searchQuery = "";

  // بيانات الاختبارات اليدوية
  List<Map<String, dynamic>> manualExams = [
    {"id": "1", "title": "الجبر المتقدم واللوغاريتمات", "subject": "الرياضيات", "date": "10 أكتوبر 2023", "q": "15", "status": "مكتمل", "icon": Icons.calculate_outlined},
    {"id": "2", "title": "أساسيات الفيزياء النووية", "subject": "الفيزياء", "date": "12 أكتوبر 2023", "q": "20", "status": "مكتمل", "icon": Icons.hub_outlined},
    {"id": "3", "title": "تطبيقات النحو والصرف", "subject": "اللغة العربية", "date": "05 أكتوبر 2023", "q": "30", "status": "مكتمل", "icon": Icons.translate},
    {"id": "4", "title": "الكيمياء العضوية", "subject": "الكيمياء", "date": "01 أكتوبر 2023", "q": "25", "status": "مسودة", "icon": Icons.science_outlined},
  ];

  // بيانات المسودات
  List<Map<String, dynamic>> draftsData = [
    {"id": "d1", "title": "اختبار الرياضيات - الشهر الأول", "time": "آخر تعديل: 5 أكتوبر", "progress": 0.45, "percent": "45%", "icon": Icons.calculate_outlined},
    {"id": "d2", "title": "اختبار اللغة العربية - نهائي", "time": "آخر تعديل: قبل 3 أيام", "progress": 0.90, "percent": "90%", "icon": Icons.menu_book_outlined},
  ];

  // بيانات الذكاء الاصطناعي
  List<Map<String, dynamic>> aiExams = [
    {"id": "ai_1", "title": "اختبار التفاضل - نموذج A", "date": "12 فبراير 2026", "students": "101", "status": "مكتمل"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {})); 
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ✅ دالة التنقل الموحدة المطلوبة
  void _handleNavigation(int index) {
    if (index == _selectedIndex) return;
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);

    Widget? targetPage;
    switch (index) {
      case 0: targetPage = const DashboardScreen(); break;
      case 1: targetPage = const ExamManagementPage(); break;
      case 2: targetPage = const Material1(); break;
      case 3: targetPage = const GradingPage(); break;
      case 4: targetPage = const ReviewExamPage(); break;
      case 5: targetPage = const SettingsScreen(); break;
    }
    if (targetPage != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => targetPage!));
    }
  }

  @override
  Widget build(BuildContext context) {
    var filteredManual = manualExams.where((e) => e['title'].contains(searchQuery)).toList();
    var filteredDrafts = draftsData.where((e) => e['title'].contains(searchQuery)).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFE0F2F1),
      drawer: CustSidebar(selectedIndex: _selectedIndex, onItemSelected: _handleNavigation),
      body: Directionality(
        // تجعل السايدبار والمحتوى ينتقل تلقائياً يمين/يسار حسب اللغة
        textDirection: Directionality.of(context),
        child: Row(
          children: [
            CustSidebar(selectedIndex: _selectedIndex, onItemSelected: _handleNavigation),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildStatsRow(),
                    const SizedBox(height: 25),
                    _buildTabBar(),
                    const SizedBox(height: 15),
                    _buildSearchAndActionRow(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildManualExamsGrid(filteredManual),
                          _buildAIExamsTable(),
                          _buildDraftsGrid(filteredDrafts),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).exam_management, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(S.of(context).manage_your_materials_and_exams, 
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
          const Spacer(),
          _headerIcon(Icons.notifications_none, onTap: () {
            // أكشن التنبيهات إذا أردتِ
          }),
          const SizedBox(width: 12),
          
          // ربط أيقونة البروفايل بصفحة ProfileSettingsPage
          _headerIcon(Icons.person_outline, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileSettingsPage()),
            );
          }),
        ],
      ),
    );
  }

  // تحديث الدالة لتستقبل onTap
  Widget _headerIcon(IconData icon, {VoidCallback? onTap}) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(50), // لضمان تأثير الضغط الدائري
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: Color(0xFFE0F2F1), shape: BoxShape.circle),
      child: Icon(icon, color: const Color(0xFF4DB6AC)),
    ),
  );

  // ✅ 2. كروت الإحصائيات (الأيقونة والرقم يمين، العنوان يسار الكرت - يدعم الترجمة)
  Widget _buildStatsRow() {
    return Row(
      children: [
        _statCard(draftsData.length.toString(), S.of(context).save_as_draft, Icons.description, Colors.blueGrey),
        const SizedBox(width: 15),
        _statCard(manualExams.length.toString(), S.of(context).create_manual_exam, Icons.edit_document, Colors.orangeAccent),
        const SizedBox(width: 15),
        _statCard(aiExams.length.toString(), S.of(context).generate_ai_exam, Icons.psychology, Colors.teal),
      ],
    );
  }

  Widget _statCard(String count, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const Spacer(),
            Row(
              children: [
                Text(count, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: color, size: 24),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 3. شريط البحث والزر (يدعم تبادل الأماكن والترجمة)
  Widget _buildSearchAndActionRow() {
    bool isDrafts = _tabController.index == 2;
    bool isAI = _tabController.index == 1;

    return Row(
      children: [
        
        
        // مربع البحث
        SizedBox(
          width: 350,
          child: TextField(
            onChanged: (val) => setState(() => searchQuery = val),
            decoration: InputDecoration(
              hintText: S.of(context).exam_title_hint,
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
          ),
        ),
        const Spacer(),
        // زر إنشاء اختبار (يظهر يسار في العربي ويمين في الإنجليزي تلقائياً)
        if (!isDrafts)
          ElevatedButton.icon(
            onPressed: () {
              if (isAI) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAIExamScreen()));
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateElectronicExamPage()));
              }
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(isAI ? S.of(context).generate_ai_exam : S.of(context).create_manual_exam, 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4DB6AC),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
      ],
    );
  }

  // ✅ 4. شبكة الاختبارات اليدوية
  Widget _buildManualExamsGrid(List<Map<String, dynamic>> data) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20, childAspectRatio: 1.8),
      itemCount: data.length,
      itemBuilder: (context, index) {
        var item = data[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_statusChip(item['status']), Icon(item['icon'], color: Colors.orange[200])],
              ),
              const SizedBox(height: 10),
              Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              _infoRow(Icons.book_outlined, item['subject']),
              _infoRow(Icons.calendar_today_outlined, item['date']),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF4DB6AC))),
                      child: Text(S.of(context).edit_exam, style: const TextStyle(color: Color(0xFF4DB6AC))),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _iconBtn(Icons.visibility_outlined, Colors.blueGrey, onTap: (){}),
                  const SizedBox(width: 4),
                  _iconBtn(Icons.delete_outline, Colors.redAccent, onTap: () {
                    setState(() => manualExams.removeWhere((e) => e['id'] == item['id']));
                  }),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // ✅ 5. جدول الذكاء الاصطناعي
  Widget _buildAIExamsTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF5F5F5)),
          columns: [
            DataColumn(label: Text(S.of(context).exam_title_label)),
            DataColumn(label: Text(S.of(context).exam_date_label)),
            DataColumn(label: Text(S.of(context).students_count_label)),
            DataColumn(label: Text(S.of(context).status_label)),
            DataColumn(label: Text(S.of(context).actions)),
          ],
          rows: aiExams.map((item) => DataRow(cells: [
            DataCell(Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold))),
            DataCell(Text(item['date'])),
            DataCell(Text(item['students'])),
            DataCell(_statusChip(item['status'])),
            DataCell(Row(
              children: [
                  // أيقونة المعاينة (جديدة)
                  _iconBtn(Icons.visibility_outlined, Colors.grey.shade700, onTap: () {
                    // هنا تضعين الكود لفتح معاينة الاختبار
                  }),
                  const SizedBox(width: 5),
                  
                  // أيقونة التعديل
                  _iconBtn(Icons.edit_outlined, Colors.blue, onTap: () {}),
                  const SizedBox(width: 5),
                  
                  // أيقونة الحذف
                  _iconBtn(Icons.delete_outline, Colors.redAccent, onTap: () {
                    setState(() => aiExams.removeWhere((e) => e['id'] == item['id']));
                  }),
                ],
            )),
          ])).toList(),
        ),
      ),
    );
  }

  // ✅ 6. شبكة المسودات
  Widget _buildDraftsGrid(List<Map<String, dynamic>> data) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20, childAspectRatio: 1.5),
      itemCount: data.length,
      itemBuilder: (context, index) {
        var d = data[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statusChip(S.of(context).save_as_draft),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFE0F2F1), borderRadius: BorderRadius.circular(10)),
                    child: Icon(d['icon'], color: const Color(0xFF4DB6AC)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(d['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(d['time'], style: const TextStyle(color: Colors.grey, fontSize: 11)),
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(value: d['progress'], minHeight: 6, backgroundColor: const Color(0xFFE0F2F1), color: const Color(0xFF4DB6AC)),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                 
                 
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_note, color: Colors.white),
                      label: Text(S.of(context).edit_exam, style: const TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4DB6AC), elevation: 0),
                    ),
                  ),
                   const SizedBox(width: 8),
                  _iconBtn(Icons.delete_outline, Colors.redAccent, onTap: () {
                    setState(() => draftsData.removeAt(index));
                  }),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // --- دالات مساعدة ---
  Widget _buildTabBar() => Align(
    alignment: Alignment.centerRight,
    child: TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorColor: const Color(0xFF4DB6AC),
      labelColor: const Color(0xFF4DB6AC),
      tabs: [
        Tab(text: S.of(context).manual_tab), 
        Tab(text: S.of(context).ai_tab), 
        Tab(text: S.of(context).drafts_tab)
      ],
    ),
  );

  Widget _statusChip(String statusKey) {
  String displayStatus;
  Color textColor;
  Color bgColor;

  // التحقق من المفتاح وعرض الترجمة المناسبة
  if (statusKey == "completed" || statusKey == "مكتمل") {
    displayStatus = S.of(context).completed_status; // سيظهر "Completed" أو "مكتمل" حسب اللغة
    textColor = Colors.green;
    bgColor = Colors.green[50]!;
  } else {
    displayStatus = S.of(context).draft_status; // سيظهر "Draft" أو "مسودة"
    textColor = Colors.grey;
    bgColor = Colors.grey[100]!;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: bgColor, 
      borderRadius: BorderRadius.circular(5)
    ),
    child: Text(
      displayStatus, 
      style: TextStyle(
        color: textColor, 
        fontSize: 10, 
        fontWeight: FontWeight.bold
      )
    ),
  );
}

  Widget _infoRow(IconData icon, String text) => Row(children: [Icon(icon, size: 14, color: Colors.grey), const SizedBox(width: 8), Text(text, style: const TextStyle(fontSize: 11, color: Colors.grey))]);

  Widget _iconBtn(IconData icon, Color color, {VoidCallback? onTap}) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: color, size: 18),
    ),
  );
}