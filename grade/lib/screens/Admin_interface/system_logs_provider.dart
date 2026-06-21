import '../../generated/l10n.dart';
import 'package:grade/core/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class LogItem {
  final int logId;
  final String userName;
  final String userRole;
  final String actionTaken;
  final String ipAddress;
  final String actionDateTime;

  LogItem({
    required this.logId,
    required this.userName,
    required this.userRole,
    required this.actionTaken,
    required this.ipAddress,
    required this.actionDateTime,
  });

  factory LogItem.fromJson(Map<String, dynamic> json) {
    // تحويل التاريخ لصيغة مقروءة
    String rawDate = json['action_date_time'] ?? '';
    String formattedDate = rawDate;
    try {
      final dt = DateTime.parse(rawDate);
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final amPm = dt.hour >= 12 ? 'PM' : 'AM';
      final minute = dt.minute.toString().padLeft(2, '0');
      formattedDate =
          '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} | $hour:$minute $amPm';
    } catch (_) {}

    return LogItem(
      logId: json['log_id'] ?? 0,
      userName: json['user_name'] ?? "Unknown",
      userRole: json['user_role'] ?? "Not specified",
      actionTaken: json['action_taken'] ?? '',
      ipAddress: json['ip_address'] ?? '-',
      actionDateTime: formattedDate,
    );
  }
}

class SystemLogsProvider extends ChangeNotifier {
  final String baseUrl = '${AppConfig.baseUrl}/admin/logs';

  // ---- البيانات ----
  List<LogItem> logs = [];
  int totalCount = 0;
  int totalActions = 0;
  int loginRecords = 0;
  int todayCount = 0;

  // ---- حالة الفلاتر ----
  String searchQuery = '';
  String selectedRole = 'ALL';
  DateTime? selectedDate;
  bool _filterByActiveTerm = false;
  bool get filterByActiveTerm => _filterByActiveTerm;

  void toggleActiveTermFilter(bool value) {
    _filterByActiveTerm = value;
    notifyListeners();
    fetchSummary();
    fetchLogs();
  }

  // ---- حالة التحميل ----
  bool isLoading = false;
  bool isExporting = false;
  String errorMessage = '';

  // ---- Pagination ----
  int currentPage = 0;
  final int pageSize = 50;

  // ==========================================
  // جلب الإحصائيات
  // ==========================================
  Future<void> fetchSummary() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final response = await http.get(
        Uri.parse('$baseUrl/summary?active_term=$_filterByActiveTerm'),
        headers: {'Authorization': 'Bearer $token'}
      );
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        totalActions = data['total_actions'] ?? 0;
        loginRecords = data['login_records'] ?? 0;
        todayCount = data['today_count'] ?? 0;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  // ==========================================
  // جلب السجلات مع الفلاتر
  // ==========================================
  Future<void> fetchLogs({bool resetPage = true}) async {
    if (resetPage) currentPage = 0;

    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final uri = Uri.parse('$baseUrl/list').replace(queryParameters: {
        if (searchQuery.isNotEmpty) 'search': searchQuery,
        if (selectedRole != 'ALL') 'role': selectedRole,
        if (selectedDate != null)
          'selected_date':
              '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
        'active_term': _filterByActiveTerm.toString(),
        'skip': (currentPage * pageSize).toString(),
        'limit': pageSize.toString(),
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final response = await http.get(uri, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        totalCount = data['total_count'] ?? 0;
        logs = (data['logs'] as List)
            .map((e) => LogItem.fromJson(e))
            .toList();
      } else {
        errorMessage = "Error fetching data";
      }
    } catch (e) {
      errorMessage = "Connection Error";
      debugPrint("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // ==========================================
  // تحديث الفلاتر وإعادة الجلب
  // ==========================================
  void updateSearch(String query) {
    searchQuery = query;
    fetchLogs();
  }

  void updateRole(String role) {
    selectedRole = role;
    fetchLogs();
  }

  void updateDate(DateTime? date) {
    selectedDate = date;
    fetchLogs();
  }

  void clearDate() {
    selectedDate = null;
    fetchLogs();
  }

  // ==========================================
  // تصدير CSV من الباك إند
  // ==========================================
  Future<void> exportCsv(BuildContext context) async {
    isExporting = true;
    notifyListeners();

    try {
      final uri = Uri.parse('$baseUrl/export-csv').replace(queryParameters: {
        if (searchQuery.isNotEmpty) 'search': searchQuery,
        if (selectedRole != 'ALL') 'role': selectedRole,
        if (selectedDate != null)
          'selected_date':
              '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
        'active_term': _filterByActiveTerm.toString(),
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final response = await http.get(uri, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        // تحميل الملف في المتصفح
        final bytes = response.bodyBytes;
        final blob = html.Blob([bytes], 'text/csv;charset=utf-8');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..setAttribute(
              'download',
              'System_Logs_${DateTime.now().millisecondsSinceEpoch}.csv')
          ..click();
        html.Url.revokeObjectUrl(url);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).log_download_success),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception(S.of(context).export_error);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).error_occurred_with_msg(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    isExporting = false;
    notifyListeners();
  }

  // ==========================================
  // تهيئة الصفحة (يُستدعى مرة واحدة)
  // ==========================================
  Future<void> initialize() async {
    await Future.wait([fetchSummary(), fetchLogs()]);
  }

  // ==========================================
  // دالة مساعدة: ترجمة الدور
  // ==========================================
  String getRoleDisplayName(String roleKey, BuildContext context) {
    switch (roleKey.toUpperCase()) {
      case 'TEACHER':
        return S.of(context).role_teacher;
      case 'STUDENT':
        return S.of(context).role_student;
      case 'ADMIN':
        return S.of(context).role_admin;
      default:
        return roleKey;
    }
  }
}
