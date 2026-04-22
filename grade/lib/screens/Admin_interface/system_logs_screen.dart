import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection; 
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart'; 
import '../../core/colors.dart'; // تأكدي من مسار الألوان
import 'package:grade/generated/l10n.dart'; // استدعاء القاموس

class SystemLogsScreen extends StatefulWidget {
  const SystemLogsScreen({super.key});

  @override
  State<SystemLogsScreen> createState() => _SystemLogsScreenState();
}

class _SystemLogsScreenState extends State<SystemLogsScreen> {
  // 1. متغيرات حفظ حالة البحث والفلترة
  String searchQuery = '';
  String selectedRole = 'ALL'; // تم توحيد المنطق البرمجي (لا يتأثر باللغة)
  DateTime? selectedDate; 

  // بيانات وهمية للجدول
  final List<Map<String, String>> dummyLogs = [
    {'name': 'أحمد محمد', 'role': 'TEACHER', 'action': 'إضافة درجات مادة الرياضيات', 'datetime': '2023-10-25 | 10:30 AM', 'ip': '192.168.1.15'},
    {'name': 'منى خالد', 'role': 'ADMIN', 'action': 'تصدير تقرير الأداء العام', 'datetime': '2023-10-25 | 09:15 AM', 'ip': '192.168.1.22'},
    {'name': 'سعد العتيبي', 'role': 'TEACHER', 'action': 'تسجيل الدخول للنظام', 'datetime': '2023-10-25 | 08:00 AM', 'ip': '10.0.0.5'},
    {'name': 'نورة فهد', 'role': 'STUDENT', 'action': 'استعراض نتيجة الاختبار', 'datetime': '2023-10-24 | 11:45 PM', 'ip': '172.16.254.1'},
    {'name': 'محمد صالح', 'role': 'TEACHER', 'action': 'تعديل بيانات ورقة الإجابة', 'datetime': '2023-10-24 | 02:20 PM', 'ip': '192.168.1.11'},
  ];

  // دالة مساعدة لترجمة الأدوار في الواجهة
  String _getRoleDisplayName(String roleKey) {
    switch (roleKey) {
      case 'ALL': return S.of(context).all_roles;
      case 'TEACHER': return S.of(context).role_teacher;
      case 'STUDENT': return S.of(context).role_student;
      case 'ADMIN': return S.of(context).role_admin;
      default: return roleKey;
    }
  }

  // 2. الفلترة الذكية
  List<Map<String, String>> get filteredLogs {
    return dummyLogs.where((log) {
      final matchesName = log['name']!.toLowerCase().contains(searchQuery.toLowerCase().trim());
      final matchesRole = selectedRole == 'ALL' || log['role'] == selectedRole;
      
      bool matchesDate = true;
      if (selectedDate != null) {
        String logDateString = log['datetime']!.split(' | ')[0]; 
        String selectedDateString = DateFormat('yyyy-MM-dd').format(selectedDate!);
        matchesDate = logDateString == selectedDateString;
      }
      return matchesName && matchesRole && matchesDate;
    }).toList();
  }

  // دالة اختيار التاريخ
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2023, 10, 25),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryTeal(context), 
              onPrimary: Colors.white, 
              onSurface: AppColors.textPrimary(context), 
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  // دالة تصدير السجل وتحميله كإكسيل
  Future<void> _exportToExcel() async {
    try {
      String csvData = '\uFEFF'; 
      // ترجمة عناوين ملف الإكسيل أيضاً
      csvData += "${S.of(context).username_col},${S.of(context).role_col},${S.of(context).action_col},${S.of(context).datetime_col},${S.of(context).ip_col}\n";

      for (var log in filteredLogs) {
        // ترجمة الدور داخل ملف الإكسيل لتجنب الرموز الإنجليزية للعميل العربي
        String translatedRole = _getRoleDisplayName(log['role']!);
        csvData += "${log['name']},$translatedRole,${log['action']},${log['datetime']},${log['ip']}\n";
      }

      Uint8List bytes = Uint8List.fromList(utf8.encode(csvData));
      String fileName = 'System_Logs_${DateTime.now().millisecondsSinceEpoch}';
      
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: bytes,
        ext: 'csv',
        mimeType: MimeType.csv,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).log_download_success), backgroundColor: Colors.green));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${S.of(context).error_occurred} $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 600;
    bool isTablet = width >= 600 && width < 1100;

    // تمت إزالة Directionality الثابتة لتقرأ الصفحة الاتجاه من لغة النظام
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopHeader(isMobile),
            const SizedBox(height: 24),
            _buildPageHeader(),
            const SizedBox(height: 24),
            _buildStatsCards(isMobile, isTablet),
            const SizedBox(height: 32),
            _buildFiltersBox(isMobile, isTablet),
            const SizedBox(height: 24),
            
            // الجدول المحمي ضد الانهيار تماماً
            _buildLogsTable(),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // المكونات (Widgets)
  // ===========================================================================

  Widget _buildTopHeader(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(S.of(context).admin_system_logs_title, style: TextStyle(fontSize: isMobile ? 16 : 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)), overflow: TextOverflow.ellipsis)),
          Row(
            children: [
              _buildTopIcon(icon: Icons.notifications_none_rounded, onTap: () {}),
              const SizedBox(width: 12),
              _buildTopIcon(icon: Icons.person_outline_rounded, onTap: () {}),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTopIcon({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.scaffoldBg(context), shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.primaryTeal(context), size: 24),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).system_logs_title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
          const SizedBox(height: 8),
          Text(S.of(context).system_logs_desc, style: TextStyle(fontSize: 14, color: AppColors.textSecondary(context))),
        ],
      ),
    );
  }

  Widget _buildStatsCards(bool isMobile, bool isTablet) {
    if (isMobile || isTablet) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            SizedBox(width: 250, child: _buildSingleCard(title: S.of(context).total_actions, value: '14,520', icon: Icons.list_alt, color: AppColors.primaryTeal(context))),
            const SizedBox(width: 16),
            SizedBox(width: 250, child: _buildSingleCard(title: S.of(context).login_records, value: '3,240', icon: Icons.login, color: AppColors.accentYellow(context))),
            const SizedBox(width: 16),
            SizedBox(width: 250, child: _buildSingleCard(title: S.of(context).today, value: '156', icon: Icons.calendar_month, color: AppColors.primaryTeal(context))),
          ],
        ),
      );
    }
    return Row(
      children: [
        Expanded(child: _buildSingleCard(title: S.of(context).total_actions, value: '14,520', icon: Icons.list_alt, color: AppColors.primaryTeal(context))),
        const SizedBox(width: 24),
        Expanded(child: _buildSingleCard(title: S.of(context).login_records, value: '3,240', icon: Icons.login, color: AppColors.accentYellow(context))),
        const SizedBox(width: 24),
        Expanded(child: _buildSingleCard(title: S.of(context).today, value: '156', icon: Icons.calendar_month, color: AppColors.primaryTeal(context))),
      ],
    );
  }

  Widget _buildSingleCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersBox(bool isMobile, bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: isMobile || isTablet
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearchField(),
                const SizedBox(height: 16),
                _buildRoleDropdown(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildDateButton()),
                    if (selectedDate != null) ...[
                      const SizedBox(width: 8),
                      IconButton(icon: const Icon(Icons.clear, color: Colors.red), onPressed: () => setState(() => selectedDate = null))
                    ]
                  ],
                ),
                const SizedBox(height: 16),
                _buildExportButton(),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 2, child: _buildSearchField()),
                const SizedBox(width: 16),
                Expanded(flex: 1, child: _buildRoleDropdown()),
                const SizedBox(width: 16),
                _buildDateButton(),
                if (selectedDate != null) ...[
                  const SizedBox(width: 8),
                  IconButton(icon: const Icon(Icons.clear, color: Colors.red), onPressed: () => setState(() => selectedDate = null))
                ],
                const SizedBox(width: 16),
                _buildExportButton(),
              ],
            ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      style: TextStyle(color: AppColors.textPrimary(context)),
      onChanged: (value) => setState(() => searchQuery = value),
      decoration: InputDecoration(
        hintText: S.of(context).search_user_hint,
        prefixIcon: Icon(Icons.search, color: AppColors.textSecondary(context)),
        filled: true,
        fillColor: AppColors.scaffoldBg(context),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedRole,
          isExpanded: true,
          dropdownColor: AppColors.textWhite(context),
          items: <String>['ALL', 'TEACHER', 'STUDENT', 'ADMIN'].map((String valueKey) {
            return DropdownMenuItem<String>(
              value: valueKey, 
              child: Text(_getRoleDisplayName(valueKey), style: TextStyle(color: AppColors.textPrimary(context)))
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) setState(() => selectedRole = newValue);
          },
        ),
      ),
    );
  }

  Widget _buildDateButton() {
    return OutlinedButton.icon(
      onPressed: () => _selectDate(context),
      icon: Icon(Icons.calendar_today, color: AppColors.textPrimary(context), size: 20),
      label: Text(selectedDate == null ? S.of(context).date_range : DateFormat('yyyy-MM-dd').format(selectedDate!), style: TextStyle(color: AppColors.textPrimary(context))),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        side: BorderSide(color: selectedDate != null ? AppColors.primaryTeal(context) : AppColors.secondaryTeal(context)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildExportButton() {
    return ElevatedButton.icon(
      onPressed: _exportToExcel,
      icon: const Icon(Icons.download, color: Colors.white, size: 20),
      label: Text(S.of(context).export_log_button, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryTeal(context),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildLogsTable() {
    final displayLogs = filteredLogs;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).action_logs_title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
          const SizedBox(height: 24),
          
          LayoutBuilder(
            builder: (context, constraints) {
              double minSafeWidth = 900; 
              bool needsScroll = constraints.maxWidth < minSafeWidth;

              Widget tableContent = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(color: AppColors.primaryTeal(context), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Text(S.of(context).username_col, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.ellipsis)),
                        Expanded(flex: 1, child: Text(S.of(context).role_col, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.ellipsis)),
                        Expanded(flex: 3, child: Text(S.of(context).action_col, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.ellipsis)),
                        Expanded(flex: 2, child: Text(S.of(context).datetime_col, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.ellipsis)),
                        Expanded(flex: 2, child: Text(S.of(context).ip_col, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (displayLogs.isEmpty)
                    Container(padding: const EdgeInsets.symmetric(vertical: 40), alignment: Alignment.center, child: Text(S.of(context).no_matching_logs, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 16)))
                  else
                    ListView.builder(
                      shrinkWrap: true, 
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayLogs.length,
                      itemBuilder: (context, index) {
                        final log = displayLogs[index];
                        bool isEven = index % 2 == 0; 
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(color: isEven ? AppColors.textWhite(context) : AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text(log['name']!, style: TextStyle(color: AppColors.textPrimary(context), fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis)),
                              Expanded(flex: 1, child: Text(_getRoleDisplayName(log['role']!), style: TextStyle(color: AppColors.textSecondary(context), fontWeight: FontWeight.w600, fontSize: 13), overflow: TextOverflow.ellipsis)),
                              Expanded(flex: 3, child: Text(log['action']!, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13), overflow: TextOverflow.ellipsis)),
                              Expanded(flex: 2, child: Text(log['datetime']!, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13), overflow: TextOverflow.ellipsis)),
                              Expanded(flex: 2, child: Text(log['ip']!, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13), overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              );

              return needsScroll
                  ? SingleChildScrollView(scrollDirection: Axis.horizontal, child: SizedBox(width: minSafeWidth, child: tableContent))
                  : tableContent;
            },
          ),
        ],
      ),
    );
  }
}