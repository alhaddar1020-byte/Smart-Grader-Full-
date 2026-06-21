// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:grade/core/theme_provider.dart';
// import 'package:grade/generated/l10n.dart'; // 🌟 استيراد ملف الترجمة
// import 'package:grade/core/app_config.dart';

// class StudentDashboardController extends GetxController {
//   var isLoading = true.obs;
//   var studentData = {}.obs;
//   late int currentStudentId;
//   RxList<String> viewedExams = <String>[].obs;

//   Future<void> loadViewedExams() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? savedExams = prefs.getStringList('viewed_exams_list');
//     if (savedExams != null) {
//       viewedExams.assignAll(savedExams); // تحديث قائمة GetX بأمان
//     }
//   }

//   Future<void> markExamAsViewed(String examId) async {
//     if (!viewedExams.contains(examId)) {
//       viewedExams.add(examId);

//       final prefs = await SharedPreferences.getInstance();
//       // 🔴 التعديل هنا: ضفنا .toList() عشان المتصفح يقبلها بدون أخطاء مخفية
//       await prefs.setStringList('viewed_exams_list', viewedExams.toList());
//     }
//   }

//   // 🔴 3. تعديل دالة الـ Init لاستدعاء التحميل أول ما يفتح حساب الطالب
//   void initController(int id) {
//     currentStudentId = id;
//     loadViewedExams(); // نجيب الاختبارات القديمة اللي شافها عشان ما تطلع عليها نقطة
//     fetchDashboardData(currentStudentId);
//   }

//   Future<void> fetchDashboardData(
//     int studentId, {
//     bool isSilent = false,
//   }) async {
//     try {
//       if (!isSilent) {
//         isLoading(true);
//       }
//       currentStudentId = studentId;

//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token') ?? '';

//       final String url =
//           '${AppConfig.baseUrl}/views/student-dashboard/$studentId';

//       print('🚀 [fetchDashboardData] URL: $url');
//       print('🔑 [fetchDashboardData] Token: $token');

//       final response = await http
//           .get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'})
//           .timeout(
//             const Duration(seconds: 15),
//           ); // Added timeout to prevent hanging forever

//       print('📡 [fetchDashboardData] StatusCode: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         final data = json.decode(utf8.decode(response.bodyBytes));
//         print('📦 [fetchDashboardData] Received Data Structure: $data');

//         // Check if the backend accidentally returned a login payload
//         if (data is Map && data.containsKey('access_token')) {
//           print(
//             '⚠️ [fetchDashboardData] Received login payload! Triggering secondary call...',
//           );
//           final newToken = data['access_token'];

//           // Re-run the request with the new token
//           final secondResponse = await http
//               .get(
//                 Uri.parse(url),
//                 headers: {'Authorization': 'Bearer $newToken'},
//               )
//               .timeout(const Duration(seconds: 15));

//           if (secondResponse.statusCode == 200) {
//             final secondData = json.decode(
//               utf8.decode(secondResponse.bodyBytes),
//             );
//             print('📦 [fetchDashboardData] Second call data: $secondData');

//             if (secondData is Map && secondData.containsKey('stats')) {
//               studentData.value = secondData;
//               studentData.refresh();
//             } else {
//               print(
//                 '🔴 [fetchDashboardData] Second call data is also invalid!',
//               );
//               Get.snackbar(
//                 S.of(Get.context!).error,
//                 "هيكل بيانات غير متوقع من السيرفر",
//               );
//             }
//           } else {
//             Get.snackbar(
//               S.of(Get.context!).error,
//               'خطأ بالخادم: ${secondResponse.statusCode}',
//             );
//           }
//         }
//         // Validate if it's the actual expected dashboard data
//         else if (data is Map && data.containsKey('stats')) {
//           studentData.value = data;
//           studentData.refresh();
//         }
//         // If data is something else entirely
//         else {
//           print(
//             '🔴 [fetchDashboardData] Unexpected data structure received. Aborting UI update to prevent crash.',
//           );
//           Get.snackbar(
//             S.of(Get.context!).error,
//             "بيانات غير متوقعة من السيرفر",
//           );
//         }
//       } else {
//         isLoading(false); // Stop spinner explicitly
//         Get.snackbar(
//           S.of(Get.context!).error,
//           'خطأ بالخادم: ${response.statusCode}', // Show actual status code
//         );
//       }
//     } catch (e) {
//       print('🔴 [fetchDashboardData] Error caught: $e');
//       isLoading(false); // Stop spinner explicitly
//       Get.snackbar(
//         S.of(Get.context!).network_error,
//         e.toString(), // Show the exact error message in the snackbar
//       );
//     } finally {
//       if (!isSilent) {
//         isLoading(false);
//       }
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grade/generated/l10n.dart';
import 'package:grade/core/app_config.dart';

class StudentDashboardController extends ChangeNotifier {
  bool isLoading = true;
  Map<String, dynamic> studentData = {};
  int currentStudentId = 0;
  List<String> viewedExams = [];

  Future<void> loadViewedExams() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedExams = prefs.getStringList('viewed_exams_list');
    if (savedExams != null) {
      viewedExams = List.from(savedExams);
      notifyListeners();
    }
  }

  Future<void> markExamAsViewed(String examId) async {
    if (!viewedExams.contains(examId)) {
      viewedExams.add(examId);
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('viewed_exams_list', viewedExams.toList());
    }
  }

  void initController(int id, {BuildContext? context}) {
    currentStudentId = id;
    loadViewedExams();
    fetchDashboardData(currentStudentId, context: context);
  }

  Future<void> fetchDashboardData(
    int studentId, {
    bool isSilent = false,
    BuildContext? context,
  }) async {
    try {
      if (!isSilent) {
        isLoading = true;
        notifyListeners();
      }
      currentStudentId = studentId;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final String url =
          '${AppConfig.baseUrl}/views/student-dashboard/$studentId';

      debugPrint('🚀 [fetchDashboardData] URL: $url');
      debugPrint('🔑 [fetchDashboardData] Token: $token');

      final response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 15));

      debugPrint('📡 [fetchDashboardData] StatusCode: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        debugPrint('📦 [fetchDashboardData] Received Data Structure: $data');

        if (data is Map && data.containsKey('access_token')) {
          debugPrint(
            '⚠️ [fetchDashboardData] Received login payload! Triggering secondary call...',
          );
          final newToken = data['access_token'];

          final secondResponse = await http
              .get(
                Uri.parse(url),
                headers: {'Authorization': 'Bearer $newToken'},
              )
              .timeout(const Duration(seconds: 15));

          if (secondResponse.statusCode == 200) {
            final secondData = json.decode(
              utf8.decode(secondResponse.bodyBytes),
            );
            debugPrint('📦 [fetchDashboardData] Second call data: $secondData');

            if (secondData is Map && secondData.containsKey('stats')) {
              studentData = Map<String, dynamic>.from(secondData);
              notifyListeners();
            } else {
              debugPrint(
                '🔴 [fetchDashboardData] Second call data is also invalid!',
              );
              _showError(context, "هيكل بيانات غير متوقع من السيرفر");
            }
          } else {
            _showError(context, 'خطأ بالخادم: ${secondResponse.statusCode}');
          }
        } else if (data is Map && data.containsKey('stats')) {
          studentData = Map<String, dynamic>.from(data);
          notifyListeners();
        } else {
          debugPrint(
            '🔴 [fetchDashboardData] Unexpected data structure received. Aborting UI update.',
          );
          _showError(context, "بيانات غير متوقعة من السيرفر");
        }
      } else {
        isLoading = false;
        notifyListeners();
        _showError(context, 'خطأ بالخادم: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('🔴 [fetchDashboardData] Error caught: $e');
      isLoading = false;
      notifyListeners();
      _showError(context, e.toString());
    } finally {
      if (!isSilent) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  // دالة ذكية بديلة لـ Get.snackbar تعرض الخطأ بأمان
  void _showError(BuildContext? context, String msg) {
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
      );
    }
  }
}
