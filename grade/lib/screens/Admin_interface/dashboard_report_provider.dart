import '../../generated/l10n.dart';
import 'package:grade/core/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html;
import 'package:shared_preferences/shared_preferences.dart';

class SubjectPerformance {
  final String subjectName;
  final double successRate;
  final double failRate;

  SubjectPerformance({
    required this.subjectName,
    required this.successRate,
    required this.failRate,
  });

  factory SubjectPerformance.fromJson(Map<String, dynamic> json) {
    return SubjectPerformance(
      subjectName: json['subject_name'] ?? '',
      successRate: (json['success_rate'] ?? 0).toDouble(),
      failRate: (json['fail_rate'] ?? 0).toDouble(),
    );
  }
}

class TeacherUsage {
  final int rank;
  final String teacherName;
  final int tasksCount;
  final double progress;

  TeacherUsage({
    required this.rank,
    required this.teacherName,
    required this.tasksCount,
    required this.progress,
  });

  factory TeacherUsage.fromJson(Map<String, dynamic> json) {
    return TeacherUsage(
      rank: json['rank'] ?? 0,
      teacherName: json['teacher_name'] ?? '',
      tasksCount: json['tasks_count'] ?? 0,
      progress: (json['progress'] ?? 0).toDouble(),
    );
  }
}

class DashboardReportProvider extends ChangeNotifier {
  final String baseUrl = '${AppConfig.baseUrl}/admin/reports';

  // البيانات
  int totalStudents = 0;
  double generalAverage = 0;
  int activeTeachers = 0;
  double passPercentage = 75;
  double failPercentage = 25;

  List<SubjectPerformance> subjectsPerformance = [];
  List<TeacherUsage> teachersUsage = [];

  bool _isLoading = false;
  bool _isExporting = false;
  bool _filterByActiveTerm = false;

  bool get isLoading => _isLoading;
  bool get isExporting => _isExporting;
  bool get filterByActiveTerm => _filterByActiveTerm;

  void toggleActiveTermFilter(bool value) {
    _filterByActiveTerm = value;
    notifyListeners();
    fetchReportsData();
  }

  String errorMessage = '';

  Future<void> fetchReportsData() async {
    _isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      final url = Uri.parse('$baseUrl/data?active_term=$_filterByActiveTerm');
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
      
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final summary = data['summary'];

        totalStudents = summary['total_students'] ?? 0;
        generalAverage = (summary['general_average'] ?? 0).toDouble();
        activeTeachers = summary['active_teachers'] ?? 0;
        passPercentage = (summary['pass_percentage'] ?? 75).toDouble();
        failPercentage = (summary['fail_percentage'] ?? 25).toDouble();

        subjectsPerformance = (data['subjects_performance'] as List)
            .map((e) => SubjectPerformance.fromJson(e))
            .toList();

        teachersUsage = (data['teachers_usage'] as List)
            .map((e) => TeacherUsage.fromJson(e))
            .toList();
      } else {
        errorMessage = S.current.error_fetch_data_simple;
      }
    } catch (e) {
      errorMessage = S.current.connection_error_with_msg(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  // تصدير PDF من الباك إند مباشرة
  Future<void> exportPdfFromBackend(BuildContext context) async {
  _isExporting = true;
  notifyListeners();

  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Generating PDF..."), backgroundColor: Colors.teal),
      );
    }

    final lang = Localizations.localeOf(context).languageCode;
    final url = Uri.parse('$baseUrl/export-pdf?active_term=$_filterByActiveTerm&lang=$lang');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      // للويب: إنشاء رابط تحميل مباشر
      final bytes = response.bodyBytes;
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      html.AnchorElement(href: url)
        ..setAttribute('download', 'SmartGrader_Report.pdf')
        ..click();
      
      html.Url.revokeObjectUrl(url);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Report Downloaded"), backgroundColor: Colors.green),
        );
      }
    } else {
      throw Exception("Export Failed ${response.statusCode}");
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  _isExporting = false;
  notifyListeners();
}
}
