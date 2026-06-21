import '../../generated/l10n.dart';
import 'package:grade/core/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class ImportHistoryRecord {
  final int id;
  final String fileOrName;
  final String uploadDate;
  final String recordsCount;
  final String status;
  final bool isSuccess;

  ImportHistoryRecord({
    required this.id,
    required this.fileOrName,
    required this.uploadDate,
    required this.recordsCount,
    required this.status,
    required this.isSuccess,
  });

  factory ImportHistoryRecord.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.parse(json['upload_date']);
    String formattedDate = "${parsedDate.day}-${parsedDate.month}-${parsedDate.year}";

    return ImportHistoryRecord(
      id: json['id'],
      fileOrName: json['file_or_name'] ?? 'Unknown',
      uploadDate: formattedDate,
      recordsCount: json['records_count'].toString(),
      status: json['status'] ?? "Completed",
      isSuccess: json['is_success'] ?? false,
    );
  }
}

class AddUsersProvider extends ChangeNotifier {
  final String baseUrl = '${AppConfig.baseUrl}/admin/import';

  List<ImportHistoryRecord> historyRecords = [];
  bool isLoading = false;
  
  String? selectedFileName;
  List<int>? selectedFileBytes; 

  // دالة ذكية لاستخراج مفتاح الخطأ من الباك إند
  String _extractBackendMessage(String responseBody) {
    try {
      final data = json.decode(responseBody);
      return data['detail'] ?? data['message'] ?? 'KEY_SERVER_ERROR';
    } catch (_) {
      return 'KEY_SERVER_ERROR';
    }
  }

  Future<void> fetchHistory() async {
    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final response = await http.get(Uri.parse('$baseUrl/history'), headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        historyRecords = data.map((json) => ImportHistoryRecord.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching history: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<String?> pickExcelFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx', 'csv'],
        withData: true, 
      );

      if (result != null && result.files.single.bytes != null) {
        selectedFileName = result.files.single.name;
        selectedFileBytes = result.files.single.bytes;
        notifyListeners();
        return null; 
      }
      return 'KEY_NO_FILE_SELECTED';
    } catch (e) {
      return 'KEY_FILE_OPEN_ERROR';
    }
  }

  Future<Map<String, dynamic>> uploadExcelFile(String categoryKey) async {
    if (selectedFileBytes == null || selectedFileName == null) {
      return {'success': false, 'message': 'KEY_SELECT_FILE_FIRST'};
    }

    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/excel'));
      request.headers.addAll({'Authorization': 'Bearer $token'});
      
      request.fields['category'] = categoryKey; // نرسل المفتاح الثابت (STUDENT, TEACHER...)
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        selectedFileBytes!,
        filename: selectedFileName,
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        selectedFileName = null;
        selectedFileBytes = null;
        await fetchHistory(); 
        return {'success': true, 'message': _extractBackendMessage(response.body)};
      } else {
        return {'success': false, 'message': _extractBackendMessage(response.body)};
      }
    } catch (e) {
      return {'success': false, 'message': 'KEY_CONNECTION_ERROR'};
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> addManualUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String categoryKey,
    String? academicId,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final response = await http.post(
        Uri.parse('$baseUrl/manual'),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
        body: json.encode({
          "first_name": firstName,
          "last_name": lastName,
          "academic_id": academicId ?? "", 
          "email": email,
          "phone_number": phone,
          "category": categoryKey // نرسل المفتاح الثابت
        }),
      );

      if (response.statusCode == 200) {
        await fetchHistory(); 
        return {'success': true, 'message': _extractBackendMessage(response.body)};
      } else {
        return {'success': false, 'message': _extractBackendMessage(response.body)};
      }
    } catch (e) {
      return {'success': false, 'message': 'KEY_CONNECTION_ERROR'};
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteHistoryRecord(int recordId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final response = await http.delete(Uri.parse('$baseUrl/history/$recordId'), headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        historyRecords.removeWhere((item) => item.id == recordId);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
