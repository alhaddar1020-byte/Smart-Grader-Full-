// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   // 👈 1. عدلنا الرابط الأساسي ليكون نظيف
//   final String baseUrl = "${AppConfig.baseUrl}/exams";

//   // دالة لجلب الاختبارات
//   Future<List<dynamic>> fetchExams(String status, int teacherId) async {
//     try {
//       // 👈 2. عدلنا التركيب عشان يصير: /api/exams/list
//       final url = Uri.parse(
//         '$baseUrl/list?status=$status&teacher_id=$teacherId',
//       );
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         return json.decode(utf8.decode(response.bodyBytes));
//       } else {
//         print("Error fetching exams: ${response.statusCode}");
//         return [];
//       }
//     } catch (e) {
//       print("Exception: $e");
//       return [];
//     }
//   }

//   // دالة لحذف الاختبار
//   Future<bool> deleteExam(int examId) async {
//     try {
//       // 👈 3. عدلنا التركيب عشان يصير: /api/exams/delete/1
//       final url = Uri.parse('$baseUrl/delete/$examId');
//       final response = await http.delete(url);

//       // نقبل 200 أو 204 (أكواد النجاح)
//       return response.statusCode == 200 || response.statusCode == 204;
//     } catch (e) {
//       print("Delete Error: $e");
//       return false;
//     }
//   }
// }
import 'package:grade/core/app_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // 👈 1. استيراد المكتبة

class ApiService {
  final String baseUrl = "${AppConfig.baseUrl}/exams";

  // دالة مساعدة صغيرة لجلب التوكن
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  // دالة لجلب الاختبارات
  Future<List<dynamic>> fetchExams(String status, int teacherId) async {
    try {
      final String token = await _getToken(); // 👈 2. جلب التوكن

      final url = Uri.parse(
        '$baseUrl/list?status=$status&teacher_id=$teacherId',
      );
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // 👈 3. إرفاق التوكن مع الطلب
        },
      );

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        print("Error fetching exams: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  // دالة لحذف الاختبار
  Future<bool> deleteExam(int examId) async {
    try {
      final String token = await _getToken(); // 👈 2. جلب التوكن

      final url = Uri.parse('$baseUrl/delete/$examId');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // 👈 3. إرفاق التوكن مع الطلب
        },
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Delete Error: $e");
      return false;
    }
  }
}