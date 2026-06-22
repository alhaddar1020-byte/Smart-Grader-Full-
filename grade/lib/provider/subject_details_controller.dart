// // import 'package:get/get.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:grade/core/app_config.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:grade/generated/l10n.dart'; // 🌟 استيراد ملف الترجمة

// // class SubjectDetailsController extends GetxController {
// //   var isLoading = true.obs;

// //   // المتغيرات التي ستحفظ البيانات
// //   var stats = {}.obs;
// //   var exams = [].obs;
// //   var strengths = <String>[].obs;
// //   var improvements = <String>[].obs;

// //   Future<void> fetchSubjectDetails(int studentId, String courseName) async {
// //     try {
// //       isLoading(true);

// //       // تشفير اسم المادة لأنها باللغة العربية وتمر عبر الرابط
// //       String encodedCourseName = Uri.encodeComponent(courseName);

// //       final prefs = await SharedPreferences.getInstance();
// //       final token = prefs.getString('auth_token') ?? '';

// //       final String url =
// //           '${AppConfig.baseUrl}/views/subject-details/$studentId/$encodedCourseName';

// //       final response = await http.get(
// //         Uri.parse(url),
// //         headers: {'Authorization': 'Bearer $token'},
// //       );

// //       if (response.statusCode == 200) {
// //         // استخدام utf8.decode مهم جداً لكي تظهر النصوص العربية بشكل صحيح ولا تظهر كرموز غريبة
// //         var data = json.decode(utf8.decode(response.bodyBytes));

// //         stats.value = data['stats'] ?? {};
// //         exams.value = data['exams'] ?? [];
// //         strengths.value = List<String>.from(data['strengths'] ?? []);
// //         improvements.value = List<String>.from(data['improvements'] ?? []);
// //       } else {
// //         Get.snackbar(
// //           S.of(Get.context!).error,
// //           S.of(Get.context!).alert_eroor, // العنوان من ملف اللغة
// //           // backgroundColor: Colors.redAccent,
// //           // colorText: Colors.white,
// //         );
// //       }
// //     } catch (e) {
// //       print("خطأ في الاتصال: $e");
// //       Get.snackbar(
// //         S.of(Get.context!).network_error,
// //         S.of(Get.context!).alert_eroor, // العنوان من ملف اللغة
// //         // backgroundColor: Colors.redAccent,
// //         // colorText: Colors.white,
// //       );
// //     } finally {
// //       isLoading(false);
// //     }
// //   }
// // }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:grade/core/app_config.dart';
// import 'package:http/http.dart' as http;
// import 'package:grade/generated/l10n.dart'; // استيراد ملف الترجمة

// class SubjectDetailsController extends ChangeNotifier {
//   bool isLoading = true;

//   // المتغيرات التي ستحفظ البيانات
//   Map<String, dynamic> stats = {};
//   List<dynamic> exams = [];
//   List<String> strengths = [];
//   List<String> improvements = [];

//   // Future<void> fetchSubjectDetails(
//   //   int studentId,
//   //   String courseName, {
//   //   BuildContext? context,
//   // }) async {
//   //   try {
//   //     isLoading = true;
//   //     notifyListeners();

//   //     // تشفير اسم المادة لأنها باللغة العربية وتمر عبر الرابط
//   //     String encodedCourseName = Uri.encodeComponent(courseName);

//   //     final prefs = await SharedPreferences.getInstance();
//   //     final token = prefs.getString('auth_token') ?? '';

//   //     final String url =
//   //         '${AppConfig.baseUrl}/views/subject-details/$studentId/$encodedCourseName';

//   //     final response = await http.get(
//   //       Uri.parse(url),
//   //       headers: {'Authorization': 'Bearer $token'},
//   //     );

//   //     if (response.statusCode == 200) {
//   //       // استخدام utf8.decode مهم جداً لكي تظهر النصوص العربية بشكل صحيح ولا تظهر كرموز غريبة
//   //       var data = json.decode(utf8.decode(response.bodyBytes));

//   //       stats = data['stats'] ?? {};
//   //       exams = data['exams'] ?? [];
//   //       strengths = List<String>.from(data['strengths'] ?? []);
//   //       improvements = List<String>.from(data['improvements'] ?? []);
//   //     } else {
//   //       if (context != null && context.mounted) {
//   //         ScaffoldMessenger.of(context).showSnackBar(
//   //           SnackBar(
//   //             content: Text(S.of(context).alert_eroor),
//   //             backgroundColor: Colors.redAccent,
//   //           ),
//   //         );
//   //       }
//   //     }
//   //   } catch (e) {
//   //     debugPrint("خطأ في الاتصال: $e");
//   //     if (context != null && context.mounted) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(
//   //           content: Text(S.of(context).network_error),
//   //           backgroundColor: Colors.redAccent,
//   //         ),
//   //       );
//   //     }
//   //   } finally {
//   //     isLoading = false;
//   //     notifyListeners();
//   //   }
//   // }

//   Future<void> fetchSubjectDetails(
//     int studentId,
//     String courseName, {
//     BuildContext? context,
//   }) async {
//     try {
//       isLoading = true;
//       notifyListeners();

//       String encodedCourseName = Uri.encodeComponent(courseName);

//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token') ?? '';

//       final String url =
//           '${AppConfig.baseUrl}/views/subject-details/$studentId/$encodedCourseName';

//       final response = await http.get(
//         Uri.parse(url),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       // 🌟 🛡️ درع الحماية هنا!
//       if (context != null && !context.mounted) return;

//       if (response.statusCode == 200) {
//         var data = json.decode(utf8.decode(response.bodyBytes));
//         stats = data['stats'] ?? {};
//         exams = data['exams'] ?? [];
//         strengths = List<String>.from(data['strengths'] ?? []);
//         improvements = List<String>.from(data['improvements'] ?? []);
//       } else {
//         if (context != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(S.of(context).alert_eroor),
//               backgroundColor: Colors.redAccent,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       debugPrint("خطأ في الاتصال: $e");
//       if (context != null && context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(S.of(context).network_error),
//             backgroundColor: Colors.redAccent,
//           ),
//         );
//       }
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grade/core/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:grade/generated/l10n.dart';

class SubjectDetailsController extends ChangeNotifier {
  bool isLoading = true;

  // 🌟 السحر هنا: متغير لتعقب آخر طلب، عشان نلغي الطلبات القديمة المتداخلة
  String _currentFetchId = '';

  // المتغيرات التي ستحفظ البيانات
  Map<String, dynamic> stats = {};
  List<dynamic> exams = [];
  List<String> strengths = [];
  List<String> improvements = [];

  Future<void> fetchSubjectDetails(
    int studentId,
    String courseName, {
    BuildContext? context,
  }) async {
    // 🌟 إنشاء رقم تعريفي فريد لهذا الطلب بالذات
    String fetchId = DateTime.now().millisecondsSinceEpoch.toString();
    _currentFetchId = fetchId;

    try {
      isLoading = true;
      notifyListeners();

      String encodedCourseName = Uri.encodeComponent(courseName);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final String url =
          '${AppConfig.baseUrl}/views/subject-details/$studentId/$encodedCourseName';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      // 🌟 🛡️ الحماية الذكية: إذا كان هذا الطلب "قديم" والطالب طلب مادة غيرها، نقتله بصمت!
      if (_currentFetchId != fetchId) return;

      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));
        stats = data['stats'] ?? {};
        exams = data['exams'] ?? [];
        strengths = List<String>.from(data['strengths'] ?? []);
        improvements = List<String>.from(data['improvements'] ?? []);
      } else {
        // 🛡️ درع الحماية العادي نستخدمه "فقط" قبل رسائل الواجهة
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).alert_eroor),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("خطأ في الاتصال: $e");
      // 🌟 حماية الطلبات القديمة حتى في الأخطاء
      if (_currentFetchId != fetchId) return;

      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).network_error),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      // 🌟 لا نقوم بإيقاف التحميل إلا إذا كان هذا هو الطلب الأخير الفعلي!
      if (_currentFetchId == fetchId) {
        isLoading = false;
        notifyListeners();
      }
    }
  }
}
