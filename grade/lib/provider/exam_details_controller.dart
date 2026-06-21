// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:grade/core/app_config.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart';

// class ExamDetailsController extends GetxController {
//   var isLoading = true.obs;
//   RxList<String> originalPaperImages = <String>[].obs;

//   var stats = {}.obs;
//   var questions = [].obs;

//   Future<void> fetchExamDetails(int studentId, String examTitle) async {
//     if (examTitle.trim().isEmpty) {
//       print("تم إيقاف الطلب: اسم الاختبار فارغ!");
//       isLoading(false);
//       return;
//     }

//     try {
//       isLoading(true);

//       String encodedTitle = Uri.encodeComponent(examTitle);

//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token') ?? '';

//       final String url =
//           '${AppConfig.baseUrl}/views/exam-details/$studentId/$encodedTitle';

//       final response = await http.get(
//         Uri.parse(url),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         var data = json.decode(utf8.decode(response.bodyBytes));
//         stats.value = data['stats'] ?? {};
//         questions.value = data['questions'] ?? [];
//         stats.refresh();
//         questions.refresh();
//         originalPaperImages.value = List<String>.from(
//           data['paper_images'] ?? [],
//         );
//       } else {
//         Get.snackbar('خطأ', 'فشل في جلب تفاصيل الاختبار');
//       }
//     } catch (e) {
//       print("خطأ: $e");
//     } finally {
//       isLoading(false);
//     }
//   }

//   // تأكدي من استدعاء مكتبة url_launcher في أعلى الملف إذا لم تكن موجودة
//   // import 'package:url_launcher/url_launcher.dart';

//   Future<void> downloadExamReport(int studentId, int examId) async {
//     // جلب اللغة الحالية للتطبيق (اختياري، يمكنك تثبيتها على 'ar' مؤقتاً)
//     String lang = Get.locale?.languageCode ?? 'ar';

//     // الرابط الديناميكي الصحيح
//     final String url =
//         '${AppConfig.baseUrl}/api/download-exam-report/$studentId/$examId?lang=$lang&theme=light';

//     try {
//       final Uri pdfUri = Uri.parse(url);

//       // نستخدم url_launcher لفتح الـ PDF في المتصفح أو تطبيق خارجي للتحميل
//       if (await canLaunchUrl(pdfUri)) {
//         await launchUrl(pdfUri, mode: LaunchMode.externalApplication);
//       } else {
//         Get.snackbar('خطأ', 'لا يمكن فتح رابط التقرير');
//       }
//     } catch (e) {
//       print("خطأ في فتح الـ PDF: $e");
//       Get.snackbar('خطأ', 'حدثت مشكلة أثناء محاولة تحميل التقرير');
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grade/core/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ExamDetailsController extends ChangeNotifier {
  bool isLoading = true;
  List<String> originalPaperImages = [];
  Map<String, dynamic> stats = {};
  List<dynamic> questions = [];

  Future<void> fetchExamDetails(
    int studentId,
    int examId, {
    BuildContext? context,
  }) async {
    if (examId <= 0) {
      debugPrint("تم إيقاف الطلب: رقم الاختبار غير صالح!");
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      // 🌟 الحل هنا: أضفنا /views/ للرابط عشان يتطابق مع الباك إند حقك!
      final String url =
          '${AppConfig.baseUrl}/views/exam-details/$studentId/$examId';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));
        stats = data['stats'] ?? {};
        questions = data['questions'] ?? [];
        originalPaperImages = List<String>.from(data['paper_images'] ?? []);
      } else {
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('فشل في جلب تفاصيل الاختبار')),
          );
        }
      }
    } catch (e) {
      debugPrint("خطأ: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> downloadExamReport(
    int studentId,
    int examId, {
    BuildContext? context,
  }) async {
    // جلب اللغة الحالية للتطبيق بأمان
    String lang = 'ar';
    if (context != null && context.mounted) {
      lang = Localizations.localeOf(context).languageCode;
    }

    // الرابط الديناميكي الصحيح
    final String url =
        '${AppConfig.baseUrl}/api/download-exam-report/$studentId/$examId?lang=$lang&theme=light';

    try {
      final Uri pdfUri = Uri.parse(url);

      // نستخدم url_launcher لفتح الـ PDF في المتصفح أو تطبيق خارجي للتحميل
      if (await canLaunchUrl(pdfUri)) {
        await launchUrl(pdfUri, mode: LaunchMode.externalApplication);
      } else {
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('لا يمكن فتح رابط التقرير')),
          );
        }
      }
    } catch (e) {
      debugPrint("خطأ في فتح الـ PDF: $e");
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدثت مشكلة أثناء محاولة تحميل التقرير'),
          ),
        );
      }
    }
  }
}
