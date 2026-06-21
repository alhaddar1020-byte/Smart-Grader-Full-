import '../../generated/l10n.dart';
import 'package:grade/core/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:grade/generated/l10n.dart'; 

class AdminDashboardProvider extends ChangeNotifier {
  final String baseUrl = '${AppConfig.baseUrl}/admin';

  late String selectedYear = "ALL_YEARS";
  String? selectedSemesterId = "0";

  late List<String> dynamicYearsList = ["ALL_YEARS"];
  List<Map<String, dynamic>> allSemestersRaw = [];
  late List<Map<String, dynamic>> dynamicSemestersList = [{"id": "0", "name": S.current.total_system_all}];

  Map<String, dynamic> topStats = {};
  Map<String, dynamic> performanceStats = {};
  List<dynamic> alertsData = [];
  List<double> chartData = [];
  
  bool isLoading = false;
  String errorMessage = "";

  // نظام معالجة الأخطاء عبر المفاتيح
  String _extractBackendError(String responseBody) {
    try {
      final data = json.decode(responseBody);
      final String code = data['detail'] ?? 'UNKNOWN_ERROR';
      switch(code) {
        case 'ERROR_FETCH_FILTERS': return S.current.error_fetch_filters;
        case 'ERROR_LOADING_STATS': return S.current.error_fetch_real_stats;
        default: return S.current.error_occurred;
      }
    } catch (_) {
      return S.current.error_occurred;
    }
  }

  Future<void> fetchDashboardFilters() async {
    isLoading = true;
    errorMessage = "";
    notifyListeners();
    try {
      final response = await http.get(Uri.parse('$baseUrl/dashboard-filters'));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        dynamicYearsList = ["ALL_YEARS", ...List<String>.from(data['years'])];
        allSemestersRaw = List<Map<String, dynamic>>.from(data['semesters']);
        updateFilters("ALL_YEARS", "0");
      } else {
        errorMessage = _extractBackendError(response.body);
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      errorMessage = S.current.connection_error;
      isLoading = false;
      notifyListeners();
    }
  }

  void updateFilters(String? year, String? semesterId) {
    if (year != null) {
      selectedYear = year;
      if (year == "ALL_YEARS") {
        dynamicSemestersList = [{"id": "0", "name": "ALL_SYSTEM"}];
        selectedSemesterId = "0";
      } else {
        var filtered = allSemestersRaw.where((s) => s['year'].toString() == year).toList();
        dynamicSemestersList = [{"id": "0", "name": "ALL_SEMESTERS"}, ...filtered];
        selectedSemesterId = "0"; 
      }
    }
    if (semesterId != null) selectedSemesterId = semesterId;
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    isLoading = true;
    errorMessage = "";
    notifyListeners();
    try {
      final url = Uri.parse('$baseUrl/dashboard-stats?semester_id=$selectedSemesterId');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        topStats = data['top_stats'] ?? {};
        performanceStats = data['performance_stats'] ?? {};
        alertsData = data['alerts'] ?? [];
        chartData = data['system_usage_chart'] != null 
            ? List<double>.from(data['system_usage_chart'].map((x) => x.toDouble())) : [];
      } else {
        errorMessage = _extractBackendError(response.body);
      }
    } catch (e) {
      errorMessage = S.current.connection_error;
    }
    isLoading = false;
    notifyListeners();
  }
}