// // import 'package:get/get.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:grade/core/app_config.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:grade/generated/l10n.dart'; // 🌟 استيراد ملف الترجمة
// // import '../../provider/student_dashboard_controller.dart';

// // class SubjectScreenController extends GetxController {
// //   // حالة التحميل لربط مؤشر التحميل في الواجهة
// //   var isLoading = true.obs;

// //   // الحوافظ الديناميكية لاستيعاب N من الأترام
// //   var availableSemesters = <dynamic>[].obs;
// //   var selectedTermId = 1.obs;
// //   var semesterData = <String, dynamic>{}.obs;

// //   // كاشف تغيير الإحصائيات العلوي حسب الترم المختار حالياً
// //   Map<String, dynamic> get topStats {
// //     String key = selectedTermId.value.toString();
// //     if (semesterData.containsKey(key)) {
// //       return semesterData[key]['top_stats'] ?? {};
// //     }
// //     return {
// //       'highest_score': '0%',
// //       'average_score': '0%',
// //       'total_exams': '0',
// //       'total_subjects': '0',
// //     };
// //   }

// //   // كاشف قائمة المواد المتغيرة حسب الترم المختار حالياً
// //   List<dynamic> get activeTermSubjects {
// //     String key = selectedTermId.value.toString();
// //     if (semesterData.containsKey(key)) {
// //       return semesterData[key]['subjects'] ?? [];
// //     }
// //     return [];
// //   }

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     if (Get.isRegistered<StudentDashboardController>()) {
// //       final dashController = Get.find<StudentDashboardController>();
// //       fetchSubjectsData(dashController.currentStudentId);
// //     } else {
// //       fetchSubjectsData(1); // رقم الطالب الافتراضي للتجربة كاحتياط
// //     }
// //   }

// //   // دالة الاستدعاء المربوطة بضغط الأزرار في شاشة الفلاتر
// //   void changeTerm(int id) {
// //     selectedTermId.value = id;
// //   }

// //   Future<void> fetchSubjectsData(int studentId) async {
// //     try {
// //       isLoading(true);
// //       final prefs = await SharedPreferences.getInstance();
// //       final token = prefs.getString('auth_token') ?? '';

// //       final String url =
// //           '${AppConfig.baseUrl}/views/student-subjects/$studentId';
// //       final response = await http.get(
// //         Uri.parse(url),
// //         headers: {'Authorization': 'Bearer $token'},
// //       );

// //       if (response.statusCode == 200) {
// //         var data = json.decode(response.body);

// //         // تخزين الهياكل الديناميكية المستلمة من البايثون
// //         availableSemesters.value = data['semesters'] ?? [];
// //         semesterData.value = data['semester_data'] ?? {};

// //         // تعيين الترم الأول تلقائياً كترم نشط عند فتح الصفحة لأول مرة
// //         if (availableSemesters.isNotEmpty) {
// //           selectedTermId.value = availableSemesters[0]['id'] ?? 1;
// //         }
// //       } else {
// //         Get.snackbar(
// //           S.of(Get.context!).error,
// //           S.of(Get.context!).alert_eroor, // العنوان من ملف اللغة
// //           // backgroundColor: Colors.redAccent,
// //           // colorText: Colors.white,
// //         );
// //       }
// //     } catch (e) {
// //       print(S.of(Get.context!).error);
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

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:grade/core/app_config.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:grade/generated/l10n.dart'; // 🌟 استيراد ملف الترجمة

// // 🌟 تغيير GetxController إلى ChangeNotifier
// class SubjectScreenController extends ChangeNotifier {
//   // 🌟 استبدال .obs بمتغيرات عادية مع getters
//   bool _isLoading = true;
//   bool get isLoading => _isLoading;

//   List<dynamic> _availableSemesters = [];
//   List<dynamic> get availableSemesters => _availableSemesters;

//   int _selectedTermId = 1;
//   int get selectedTermId => _selectedTermId;

//   Map<String, dynamic> _semesterData = {};
//   Map<String, dynamic> get semesterData => _semesterData;

//   // كاشف تغيير الإحصائيات العلوي حسب الترم المختار حالياً
//   Map<String, dynamic> get topStats {
//     String key = _selectedTermId.toString();
//     if (_semesterData.containsKey(key)) {
//       return _semesterData[key]['top_stats'] ?? {};
//     }
//     return {
//       'highest_score': '0%',
//       'average_score': '0%',
//       'total_exams': '0',
//       'total_subjects': '0',
//     };
//   }

//   // كاشف قائمة المواد المتغيرة حسب الترم المختار حالياً
//   List<dynamic> get activeTermSubjects {
//     String key = _selectedTermId.toString();
//     if (_semesterData.containsKey(key)) {
//       return _semesterData[key]['subjects'] ?? [];
//     }
//     return [];
//   }

//   // 🌟 دالة التهيئة الأولية (تستدعى من الواجهة بدلاً من onInit)
//   void init(int studentId, BuildContext context) {
//     fetchSubjectsData(studentId, context);
//   }

//   // دالة الاستدعاء المربوطة بضغط الأزرار في شاشة الفلاتر
//   void changeTerm(int id) {
//     _selectedTermId = id;
//     notifyListeners(); // 🌟 تحديث الواجهة
//   }

//   //   Future<void> fetchSubjectsData(int studentId, BuildContext context) async {
//   //     try {
//   //       _isLoading = true;
//   //       notifyListeners();

//   //       final prefs = await SharedPreferences.getInstance();
//   //       final token = prefs.getString('auth_token') ?? '';

//   //       final String url =
//   //           '${AppConfig.baseUrl}/views/student-subjects/$studentId';
//   //       final response = await http.get(
//   //         Uri.parse(url),
//   //         headers: {'Authorization': 'Bearer $token'},
//   //       );

//   //       if (response.statusCode == 200) {
//   //         var data = json.decode(response.body);

//   //         _availableSemesters = data['semesters'] ?? [];
//   //         _semesterData = data['semester_data'] ?? {};

//   //         if (_availableSemesters.isNotEmpty) {
//   //           _selectedTermId = _availableSemesters[0]['id'] ?? 1;
//   //         }
//   //       } else {
//   //         // 🌟 استبدال Get.snackbar بـ ScaffoldMessenger
//   //         if (context.mounted) {
//   //           ScaffoldMessenger.of(context).showSnackBar(
//   //             SnackBar(
//   //               content: Text(
//   //                 '${S.of(context).alert_eroor}: ${S.of(context).error}',
//   //               ),
//   //               backgroundColor: Colors.redAccent,
//   //             ),
//   //           );
//   //         }
//   //       }
//   //     } catch (e) {
//   //       print(e.toString());
//   //       if (context.mounted) {
//   //         ScaffoldMessenger.of(context).showSnackBar(
//   //           SnackBar(
//   //             content: Text(
//   //               '${S.of(context).alert_eroor}: ${S.of(context).network_error}',
//   //             ),
//   //             backgroundColor: Colors.redAccent,
//   //           ),
//   //         );
//   //       }
//   //     } finally {
//   //       _isLoading = false;
//   //       notifyListeners(); // 🌟 إغلاق اللودنق وتحديث الواجهة
//   //     }
//   //   }
//   // }

//   Future<void> fetchSubjectsData(int studentId, BuildContext context) async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token') ?? '';

//       final String url =
//           '${AppConfig.baseUrl}/views/student-subjects/$studentId';
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       // 🌟 🛡️ درع الحماية: لا تكمل إذا الطالب خرج من الشاشة!
//       if (!context.mounted) return;

//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);

//         _availableSemesters = data['semesters'] ?? [];
//         _semesterData = data['semester_data'] ?? {};

//         if (_availableSemesters.isNotEmpty) {
//           _selectedTermId = _availableSemesters[0]['id'] ?? 1;
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               '${S.of(context).alert_eroor}: ${S.of(context).error}',
//             ),
//             backgroundColor: Colors.redAccent,
//           ),
//         );
//       }
//     } catch (e) {
//       print(e.toString());
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               '${S.of(context).alert_eroor}: ${S.of(context).network_error}',
//             ),
//             backgroundColor: Colors.redAccent,
//           ),
//         );
//       }
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grade/core/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:grade/generated/l10n.dart';

class SubjectScreenController extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<dynamic> _availableSemesters = [];
  List<dynamic> get availableSemesters => _availableSemesters;

  int _selectedTermId = 1;
  int get selectedTermId => _selectedTermId;

  Map<String, dynamic> _semesterData = {};
  Map<String, dynamic> get semesterData => _semesterData;

  // 🌟 إضافة متغير لمعرفة هل الكنترولر حي أو ميت
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true; // 🌟 نعلم الكنترولر إنه مات
    super.dispose();
  }

  Map<String, dynamic> get topStats {
    String key = _selectedTermId.toString();
    if (_semesterData.containsKey(key)) {
      return _semesterData[key]['top_stats'] ?? {};
    }
    return {
      'highest_score': '0%',
      'average_score': '0%',
      'total_exams': '0',
      'total_subjects': '0',
    };
  }

  List<dynamic> get activeTermSubjects {
    String key = _selectedTermId.toString();
    if (_semesterData.containsKey(key)) {
      return _semesterData[key]['subjects'] ?? [];
    }
    return [];
  }

  void init(int studentId, BuildContext context) {
    fetchSubjectsData(studentId, context);
  }

  void changeTerm(int id) {
    _selectedTermId = id;
    if (!_isDisposed) notifyListeners();
  }

  Future<void> fetchSubjectsData(int studentId, BuildContext context) async {
    try {
      _isLoading = true;
      if (!_isDisposed) notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final String url =
          '${AppConfig.baseUrl}/views/student-subjects/$studentId';
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      // 🛡️ درع الحماية الأول: هل الشاشة موجودة؟
      if (!context.mounted) return;

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        _availableSemesters = data['semesters'] ?? [];
        _semesterData = data['semester_data'] ?? {};

        if (_availableSemesters.isNotEmpty) {
          _selectedTermId = _availableSemesters[0]['id'] ?? 1;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${S.of(context).alert_eroor}: ${S.of(context).error}',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      print(e.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${S.of(context).alert_eroor}: ${S.of(context).network_error}',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      // 🌟 🛡️ درع الحماية الأقوى: لا تسوي تحديث إذا الكنترولر مات!
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
