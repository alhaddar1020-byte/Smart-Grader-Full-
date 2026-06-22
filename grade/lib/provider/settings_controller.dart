// import 'dart:convert';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';

// // تأكدي من مطابقة هذه المسارات لمشروعكِ
// import 'package:grade/core/theme_provider.dart';
// import 'package:grade/core/locale_provider.dart';
// import 'package:grade/generated/l10n.dart';
// import 'package:grade/core/app_config.dart';

// class SettingsController extends ChangeNotifier {
//   // 1. الإعدادات الأساسية
//   final String _baseUrl = AppConfig.baseUrl;
//   final Duration _timeout = const Duration(seconds: 15);

//   int currentStudentId = 0;

//   // 2. المتغيرات التفاعلية
//   String userName = '...';
//   String userEmail = '...';
//   String phoneNumber = '...';
//   String educationLevel = '...';
//   String departmentName = '';
//   String lastPasswordChange = ' ';

//   // حالات التحميل
//   bool isLoadingProfile = false;
//   bool isUpdatingProfile = false;
//   bool isChangingPassword = false;
//   bool isSendingOtp = false;
//   bool isVerifyingOtp = false;
//   bool isSendingForgotOtp = false;
//   bool isVerifyingForgotOtp = false;
//   bool isResettingForgotPass = false;

//   // إدارة رسائل الخطأ لكل ديالوج
//   String? profileDialogError;
//   String? passwordDialogError;

//   // متغيرات قوة كلمة المرور
//   double passwordStrength = 0.0;
//   String passwordStrengthText = '';
//   Color? passwordStrengthColor = Colors.red;

//   // متغير احتياطي لحفظ الـ JSON الأصلي
//   Map<String, dynamic>? _rawResponseData;

//   // بديل onInit الخاص بـ GetX
//   SettingsController() {
//     _initializeController();
//   }

//   Future<void> _initializeController() async {
//     final prefs = await SharedPreferences.getInstance();
//     int studentId = prefs.getInt('user_id') ?? 1;
//     currentStudentId = studentId;
//     fetchProfile(studentId);
//   }

//   String get levelAndDepartment {
//     if (departmentName.isEmpty ||
//         departmentName == '...' ||
//         departmentName == '...') {
//       return educationLevel;
//     }
//     return "$educationLevel - $departmentName";
//   }

//   // ===========================================================================
//   // 🌟 دوال مساعدة احترافية لمعالجة الأخطاء والرسائل
//   // ===========================================================================

//   void _showSuccess(String msg, BuildContext? context) {
//     if (context == null) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle_outline, color: Colors.white),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(msg, style: const TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.teal,
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(10),
//       ),
//     );
//   }

//   void _showError(String msg, BuildContext? context) {
//     if (context == null) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.error_outline, color: Colors.white),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(msg, style: const TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.redAccent,
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(10),
//         duration: const Duration(seconds: 4),
//       ),
//     );
//   }

//   void _handleNetworkError(Object e, BuildContext? context) {
//     debugPrint("Network/Server Error: $e");
//     if (context != null) {
//       _showError(S.of(context).network_error, context);
//     }
//   }

//   String _extractBackendError(String responseBody, String defaultMsg) {
//     try {
//       final data = json.decode(responseBody);
//       return data['detail'] ?? data['message'] ?? defaultMsg;
//     } catch (_) {
//       return defaultMsg;
//     }
//   }

//   // ===========================================================================
//   // العمليات الأساسية (API Calls)
//   // ===========================================================================

//   // Future<void> fetchProfile(int id, {BuildContext? context}) async {
//   //   isLoadingProfile = true;
//   //   notifyListeners();
//   //   try {
//   //     final prefs = await SharedPreferences.getInstance();
//   //     final token = prefs.getString('auth_token') ?? '';

//   //     final response = await http
//   //         .get(
//   //           Uri.parse('$_baseUrl/settings/profile/$id'),
//   //           headers: {'Authorization': 'Bearer $token'},
//   //         )
//   //         .timeout(_timeout);

//   //     if (response.statusCode == 200) {
//   //       final data = json.decode(response.body);
//   //       _rawResponseData = data;

//   //       bool isEn = false;
//   //       if (context != null) {
//   //         final localeProvider = context.read<LocaleProvider>();
//   //         isEn = localeProvider.locale.languageCode == 'en';
//   //       }

//   //       userName = data['full_name'] ?? '';
//   //       educationLevel = isEn
//   //           ? (data['level_name_en'] ?? data['level_name'])
//   //           : (data['level_name'] ?? '');
//   //       departmentName = isEn
//   //           ? (data['department_name_en'] ?? data['department_name'])
//   //           : (data['department_name'] ?? '');

//   //       userEmail = data['email'] ?? '';
//   //       phoneNumber = data['phone_number'] ?? '';
//   //       lastPasswordChange = data['last_password_change'] != null
//   //           ? data['last_password_change'].toString().split(' ')[0]
//   //           : (context != null ? S.of(context).not_specified : 'غير محدد');

//   //       await prefs.setString('language_code', data['language_code'] ?? 'ar');
//   //       await prefs.setBool('theme_mode', data['is_dark_mode'] ?? false);
//   //     } else {
//   //       debugPrint("Profile fetch error: ${response.statusCode}");
//   //     }
//   //   } catch (e) {
//   //     _handleNetworkError(e, context);
//   //   } finally {
//   //     isLoadingProfile = false;
//   //     notifyListeners();
//   //   }
//   // }

//   Future<void> fetchProfile(int id, {BuildContext? context}) async {
//     isLoadingProfile = true;
//     notifyListeners();
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token') ?? '';

//       final response = await http
//           .get(
//             Uri.parse('$_baseUrl/settings/profile/$id'),
//             headers: {'Authorization': 'Bearer $token'},
//           )
//           .timeout(_timeout);

//       // 🌟 🛡️ درع الحماية القاتل للتعليق (هذا السطر أنقذ التطبيق)
//       if (context != null && !context.mounted) return;

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         _rawResponseData = data;

//         bool isEn = false;
//         if (context != null) {
//           final localeProvider = context.read<LocaleProvider>();
//           isEn = localeProvider.locale.languageCode == 'en';
//         }

//         userName = data['full_name'] ?? '';
//         educationLevel = isEn
//             ? (data['level_name_en'] ?? data['level_name'])
//             : (data['level_name'] ?? '');
//         departmentName = isEn
//             ? (data['department_name_en'] ?? data['department_name'])
//             : (data['department_name'] ?? '');

//         userEmail = data['email'] ?? '';
//         phoneNumber = data['phone_number'] ?? '';
//         lastPasswordChange = data['last_password_change'] != null
//             ? data['last_password_change'].toString().split(' ')[0]
//             : (context != null ? S.of(context).not_specified : 'غير محدد');

//         await prefs.setString('language_code', data['language_code'] ?? 'ar');
//         await prefs.setBool('theme_mode', data['is_dark_mode'] ?? false);
//       } else {
//         debugPrint("Profile fetch error: ${response.statusCode}");
//       }
//     } catch (e) {
//       _handleNetworkError(e, context);
//     } finally {
//       isLoadingProfile = false;
//       notifyListeners();
//     }
//   }

//   Future<bool> sendEmailChangeOtp({
//     required String newEmail,
//     BuildContext? context,
//   }) async {
//     isSendingOtp = true;
//     notifyListeners();
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token') ?? '';

//       final res = await http
//           .post(
//             Uri.parse('$_baseUrl/settings/send-email-otp'),
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $token',
//             },
//             body: jsonEncode({
//               'user_id': currentStudentId,
//               'new_email': newEmail,
//             }),
//           )
//           .timeout(_timeout);

//       if (res.statusCode == 200) return true;

//       if (context != null) {
//         _showError(
//           _extractBackendError(res.body, S.of(context).failed_to_send_code),
//           context,
//         );
//       }
//       return false;
//     } catch (e) {
//       _handleNetworkError(e, context);
//       return false;
//     } finally {
//       isSendingOtp = false;
//       notifyListeners();
//     }
//   }

//   Future<bool> verifyEmailOtp({
//     required String otpCode,
//     required String newEmail,
//     BuildContext? context,
//   }) async {
//     isVerifyingOtp = true;
//     notifyListeners();
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token') ?? '';

//       final res = await http
//           .post(
//             Uri.parse('$_baseUrl/settings/verify-email-otp'),
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $token',
//             },
//             body: jsonEncode({
//               'user_id': currentStudentId,
//               'new_email': newEmail,
//               'otp_code': otpCode,
//             }),
//           )
//           .timeout(_timeout);

//       if (res.statusCode == 200) {
//         userEmail = newEmail;
//         notifyListeners();
//         return true;
//       }

//       if (context != null) {
//         _showError(
//           _extractBackendError(res.body, S.of(context).invalid_otp),
//           context,
//         );
//       }
//       return false;
//     } catch (e) {
//       _handleNetworkError(e, context);
//       return false;
//     } finally {
//       isVerifyingOtp = false;
//       notifyListeners();
//     }
//   }

//   Future<bool> sendForgotPasswordOtp({BuildContext? context}) async {
//     isSendingForgotOtp = true;
//     notifyListeners();
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token') ?? '';

//       final res = await http
//           .post(
//             Uri.parse('$_baseUrl/settings/forgot-password/send-otp'),
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $token',
//             },
//             body: jsonEncode({'user_id': currentStudentId}),
//           )
//           .timeout(_timeout);

//       if (res.statusCode == 200) return true;

//       if (context != null) {
//         _showError(
//           _extractBackendError(res.body, S.of(context).failed_to_send_otp),
//           context,
//         );
//       }
//       return false;
//     } catch (e) {
//       _handleNetworkError(e, context);
//       return false;
//     } finally {
//       isSendingForgotOtp = false;
//       notifyListeners();
//     }
//   }

//   Future<bool> verifyForgotPasswordOtp(
//     String otp, {
//     BuildContext? context,
//   }) async {
//     isVerifyingForgotOtp = true;
//     notifyListeners();
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token') ?? '';

//       final res = await http
//           .post(
//             Uri.parse('$_baseUrl/settings/forgot-password/verify-otp'),
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $token',
//             },
//             body: jsonEncode({'user_id': currentStudentId, 'otp_code': otp}),
//           )
//           .timeout(_timeout);

//       if (res.statusCode == 200) return true;

//       if (context != null) {
//         _showError(
//           _extractBackendError(res.body, S.of(context).invalid_or_expired_otp),
//           context,
//         );
//       }
//       return false;
//     } catch (e) {
//       _handleNetworkError(e, context);
//       return false;
//     } finally {
//       isVerifyingForgotOtp = false;
//       notifyListeners();
//     }
//   }

//   Future<bool> resetPasswordWithOtp(
//     String otp,
//     String newPassword, {
//     BuildContext? context,
//   }) async {
//     isResettingForgotPass = true;
//     notifyListeners();
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token') ?? '';

//       final res = await http
//           .post(
//             Uri.parse('$_baseUrl/settings/forgot-password/reset'),
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $token',
//             },
//             body: jsonEncode({
//               'user_id': currentStudentId,
//               'otp_code': otp,
//               'new_password': newPassword,
//             }),
//           )
//           .timeout(_timeout);

//       if (res.statusCode == 200) {
//         lastPasswordChange = DateTime.now().toString().split(' ')[0];
//         if (context != null) {
//           _showSuccess(S.of(context).password_changed_success, context);
//         }
//         return true;
//       }

//       if (context != null) {
//         _showError(
//           _extractBackendError(res.body, S.of(context).error_updating_password),
//           context,
//         );
//       }
//       return false;
//     } catch (e) {
//       _handleNetworkError(e, context);
//       return false;
//     } finally {
//       isResettingForgotPass = false;
//       notifyListeners();
//     }
//   }

//   Future<void> updateProfile({
//     required String fullName,
//     BuildContext? context,
//   }) async {
//     isUpdatingProfile = true;
//     profileDialogError = null;
//     notifyListeners();

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token') ?? '';

//       final res = await http
//           .put(
//             Uri.parse('$_baseUrl/settings/update-profile'),
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $token',
//             },
//             body: jsonEncode({
//               'user_id': currentStudentId,
//               'full_name': fullName,
//               'email': userEmail,
//             }),
//           )
//           .timeout(_timeout);

//       if (res.statusCode == 200) {
//         userName = fullName;
//         if (context != null) {
//           Navigator.pop(context);
//           _showSuccess(S.of(context).name_updated_success, context);
//         }
//       } else {
//         if (context != null) {
//           profileDialogError = _extractBackendError(
//             res.body,
//             S.of(context).update_failed,
//           );
//         }
//       }
//     } catch (e) {
//       _handleNetworkError(e, context);
//       if (context != null)
//         profileDialogError = S.of(context).no_server_connection;
//     } finally {
//       isUpdatingProfile = false;
//       notifyListeners();
//     }
//   }

//   Future<void> changePassword({
//     required String oldPassword,
//     required String newPassword,
//     required String confirmPassword,
//     BuildContext? context,
//   }) async {
//     isChangingPassword = true;
//     passwordDialogError = null;
//     notifyListeners();

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token') ?? '';

//       final res = await http
//           .put(
//             Uri.parse('$_baseUrl/settings/change-password'),
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $token',
//             },
//             body: jsonEncode({
//               'user_id': currentStudentId,
//               'old_password': oldPassword,
//               'new_password': newPassword,
//               'confirm_password': confirmPassword,
//             }),
//           )
//           .timeout(_timeout);

//       if (res.statusCode == 200) {
//         if (context != null) Navigator.pop(context);
//         lastPasswordChange = DateTime.now().toString().split(' ')[0];
//         if (context != null) {
//           _showSuccess(S.of(context).password_updated_success, context);
//         }
//       } else {
//         if (context != null) {
//           passwordDialogError = _extractBackendError(
//             res.body,
//             S.of(context).update_error,
//           );
//           _showError(passwordDialogError!, context);
//         }
//       }
//     } catch (e) {
//       _handleNetworkError(e, context);
//       if (context != null) passwordDialogError = S.of(context).no_connection;
//     } finally {
//       isChangingPassword = false;
//       notifyListeners();
//     }
//   }

//   void checkPasswordStrength(String password, {BuildContext? context}) {
//     double strength = 0;
//     if (password.length >= 8) strength += 0.3;
//     if (password.contains(RegExp(r'[A-Z]'))) strength += 0.3;
//     if (password.contains(RegExp(r'[0-9]'))) strength += 0.4;

//     passwordStrength = strength;

//     if (context != null) {
//       if (strength <= 0.3) {
//         passwordStrengthText = S.of(context).weak_password;
//         passwordStrengthColor = Colors.red;
//       } else if (strength <= 0.6) {
//         passwordStrengthText = S.of(context).medium_password;
//         passwordStrengthColor = Colors.orange;
//       } else {
//         passwordStrengthText = S.of(context).strong_password;
//         passwordStrengthColor = Colors.green;
//       }
//     }
//     notifyListeners();
//   }

//   void updateLanguageLocally(String newLang) {
//     bool isEn = newLang == 'en';
//     if (_rawResponseData != null) {
//       userName = _rawResponseData!['full_name'] ?? '';
//       educationLevel = isEn
//           ? (_rawResponseData!['level_name_en'] ??
//                 _rawResponseData!['level_name'])
//           : (_rawResponseData!['level_name'] ?? '');
//       departmentName = isEn
//           ? (_rawResponseData!['department_name_en'] ??
//                 _rawResponseData!['department_name'])
//           : (_rawResponseData!['department_name'] ?? '');
//       notifyListeners();
//     }
//   }

//   Future<void> logout({BuildContext? context}) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//   }
// }

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:grade/core/theme_provider.dart';
import 'package:grade/core/locale_provider.dart';
import 'package:grade/generated/l10n.dart';
import 'package:grade/core/app_config.dart';

class SettingsController extends ChangeNotifier {
  final String _baseUrl = AppConfig.baseUrl;
  final Duration _timeout = const Duration(seconds: 15);

  int currentStudentId = 0;

  String userName = '...';
  String userEmail = '...';
  String phoneNumber = '...';
  String educationLevel = '...';
  String departmentName = '';
  String lastPasswordChange = ' ';

  bool isLoadingProfile = false;
  bool isUpdatingProfile = false;
  bool isChangingPassword = false;
  bool isSendingOtp = false;
  bool isVerifyingOtp = false;
  bool isSendingForgotOtp = false;
  bool isVerifyingForgotOtp = false;
  bool isResettingForgotPass = false;

  String? profileDialogError;
  String? passwordDialogError;

  double passwordStrength = 0.0;
  String passwordStrengthText = '';
  Color? passwordStrengthColor = Colors.red;

  Map<String, dynamic>? _rawResponseData;

  // 🌟 حماية ضد التعليق إذا مات الكنترولر
  bool _isDisposed = false;
  // 🌟 لتتبع الطلب الحالي وإلغاء القديم
  String _currentFetchId = '';

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // 🌟 دالة آمنة للتحديث
  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  SettingsController() {
    _initializeController();
  }

  Future<void> _initializeController() async {
    final prefs = await SharedPreferences.getInstance();
    int studentId = prefs.getInt('user_id') ?? 1;
    currentStudentId = studentId;
    fetchProfile(studentId);
  }

  String get levelAndDepartment {
    if (departmentName.isEmpty ||
        departmentName == '...' ||
        departmentName == '...') {
      return educationLevel;
    }
    return "$educationLevel - $departmentName";
  }

  void _showSuccess(String msg, BuildContext? context) {
    if (context == null || !context.mounted) return; // 🌟 حماية
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(msg, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  void _showError(String msg, BuildContext? context) {
    if (context == null || !context.mounted) return; // 🌟 حماية
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(msg, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _handleNetworkError(Object e, BuildContext? context) {
    debugPrint("Network/Server Error: $e");
    if (context != null && context.mounted) {
      _showError(S.of(context).network_error, context);
    }
  }

  String _extractBackendError(String responseBody, String defaultMsg) {
    try {
      final data = json.decode(responseBody);
      return data['detail'] ?? data['message'] ?? defaultMsg;
    } catch (_) {
      return defaultMsg;
    }
  }

  Future<void> fetchProfile(int id, {BuildContext? context}) async {
    // 🌟 نعطي هذا الطلب رقم تعريفي خاص
    String fetchId = DateTime.now().millisecondsSinceEpoch.toString();
    _currentFetchId = fetchId;

    isLoadingProfile = true;
    _safeNotify();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http
          .get(
            Uri.parse('$_baseUrl/settings/profile/$id'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(_timeout);

      // 🌟 🛡️ الحماية المزدوجة: نلغي الطلب إذا الطالب طلع، أو إذا طلب طلب جديد!
      if (_currentFetchId != fetchId) return;
      if (context != null && !context.mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _rawResponseData = data;

        bool isEn = false;
        if (context != null) {
          final localeProvider = context.read<LocaleProvider>();
          isEn = localeProvider.locale.languageCode == 'en';
        }

        userName = data['full_name'] ?? '';
        educationLevel = isEn
            ? (data['level_name_en'] ?? data['level_name'])
            : (data['level_name'] ?? '');
        departmentName = isEn
            ? (data['department_name_en'] ?? data['department_name'])
            : (data['department_name'] ?? '');

        userEmail = data['email'] ?? '';
        phoneNumber = data['phone_number'] ?? '';
        lastPasswordChange = data['last_password_change'] != null
            ? data['last_password_change'].toString().split(' ')[0]
            : (context != null ? S.of(context).not_specified : 'غير محدد');

        await prefs.setString('language_code', data['language_code'] ?? 'ar');
        await prefs.setBool('theme_mode', data['is_dark_mode'] ?? false);
      } else {
        debugPrint("Profile fetch error: ${response.statusCode}");
      }
    } catch (e) {
      _handleNetworkError(e, context);
    } finally {
      // 🌟 لا نقفل التحميل إلا للطلب الأخير الفعلي
      if (_currentFetchId == fetchId) {
        isLoadingProfile = false;
        _safeNotify();
      }
    }
  }

  // Future<void> fetchProfile(int id, {BuildContext? context}) async {
  //   // 🌟 نعطي هذا الطلب رقم تعريفي خاص
  //   String fetchId = DateTime.now().millisecondsSinceEpoch.toString();
  //   _currentFetchId = fetchId;

  //   isLoadingProfile = true;
  //   _safeNotify();
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('auth_token') ?? '';

  //     final response = await http
  //         .get(
  //           Uri.parse('$_baseUrl/settings/profile/$id'),
  //           headers: {'Authorization': 'Bearer $token'},
  //         )
  //         .timeout(_timeout);

  //     // 🌟 🛡️ الحماية المزدوجة: نلغي الطلب إذا الطالب طلع، أو إذا طلب طلب جديد!
  //     if (_currentFetchId != fetchId) return;
  //     if (context != null && !context.mounted) return;

  //     if (response.statusCode == 200) { {
  //       final data = json.decode(response.body);
  //       _rawResponseData = data;

  //       bool isEn = false;
  //       if (context != null) {
  //         final localeProvider = context.read<LocaleProvider>();
  //         isEn = localeProvider.locale.languageCode == 'en';
  //       }

  //       userName = data['full_name'] ?? '';
  //       educationLevel = isEn
  //           ? (data['level_name_en'] ?? data['level_name'])
  //           : (data['level_name'] ?? '');
  //       departmentName = isEn
  //           ? (data['department_name_en'] ?? data['department_name'])
  //           : (data['department_name'] ?? '');

  //       userEmail = data['email'] ?? '';
  //       phoneNumber = data['phone_number'] ?? '';
  //       lastPasswordChange = data['last_password_change'] != null
  //           ? data['last_password_change'].toString().split(' ')[0]
  //           : (context != null ? S.of(context).not_specified : 'غير محدد');

  //       await prefs.setString('language_code', data['language_code'] ?? 'ar');
  //       await prefs.setBool('theme_mode', data['is_dark_mode'] ?? false);
  //     } else {
  //       debugPrint("Profile fetch error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     _handleNetworkError(e, context);
  //   } } finally {
  //     // 🌟 لا نقفل التحميل إلا للطلب الأخير الفعلي
  //     if (_currentFetchId == fetchId) {
  //       isLoadingProfile = false;
  //       _safeNotify();
  //     }
  //   }
  // }
  // }

  Future<bool> sendEmailChangeOtp({
    required String newEmail,
    BuildContext? context,
  }) async {
    isSendingOtp = true;
    _safeNotify();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final res = await http
          .post(
            Uri.parse('$_baseUrl/settings/send-email-otp'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'user_id': currentStudentId,
              'new_email': newEmail,
            }),
          )
          .timeout(_timeout);

      // 🌟 🛡️ درع الحماية
      if (context != null && !context.mounted) return false;

      if (res.statusCode == 200) return true;

      if (context != null) {
        _showError(
          _extractBackendError(res.body, S.of(context).failed_to_send_code),
          context,
        );
      }
      return false;
    } catch (e) {
      _handleNetworkError(e, context);
      return false;
    } finally {
      isSendingOtp = false;
      _safeNotify();
    }
  }

  Future<bool> verifyEmailOtp({
    required String otpCode,
    required String newEmail,
    BuildContext? context,
  }) async {
    isVerifyingOtp = true;
    _safeNotify();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final res = await http
          .post(
            Uri.parse('$_baseUrl/settings/verify-email-otp'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'user_id': currentStudentId,
              'new_email': newEmail,
              'otp_code': otpCode,
            }),
          )
          .timeout(_timeout);

      // 🌟 🛡️ درع الحماية
      if (context != null && !context.mounted) return false;

      if (res.statusCode == 200) {
        userEmail = newEmail;
        _safeNotify();
        return true;
      }

      if (context != null) {
        _showError(
          _extractBackendError(res.body, S.of(context).invalid_otp),
          context,
        );
      }
      return false;
    } catch (e) {
      _handleNetworkError(e, context);
      return false;
    } finally {
      isVerifyingOtp = false;
      _safeNotify();
    }
  }

  Future<bool> sendForgotPasswordOtp({BuildContext? context}) async {
    isSendingForgotOtp = true;
    _safeNotify();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final res = await http
          .post(
            Uri.parse('$_baseUrl/settings/forgot-password/send-otp'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'user_id': currentStudentId}),
          )
          .timeout(_timeout);

      // 🌟 🛡️ درع الحماية
      if (context != null && !context.mounted) return false;

      if (res.statusCode == 200) return true;

      if (context != null) {
        _showError(
          _extractBackendError(res.body, S.of(context).failed_to_send_otp),
          context,
        );
      }
      return false;
    } catch (e) {
      _handleNetworkError(e, context);
      return false;
    } finally {
      isSendingForgotOtp = false;
      _safeNotify();
    }
  }

  Future<bool> verifyForgotPasswordOtp(
    String otp, {
    BuildContext? context,
  }) async {
    isVerifyingForgotOtp = true;
    _safeNotify();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final res = await http
          .post(
            Uri.parse('$_baseUrl/settings/forgot-password/verify-otp'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'user_id': currentStudentId, 'otp_code': otp}),
          )
          .timeout(_timeout);

      // 🌟 🛡️ درع الحماية
      if (context != null && !context.mounted) return false;

      if (res.statusCode == 200) return true;

      if (context != null) {
        _showError(
          _extractBackendError(res.body, S.of(context).invalid_or_expired_otp),
          context,
        );
      }
      return false;
    } catch (e) {
      _handleNetworkError(e, context);
      return false;
    } finally {
      isVerifyingForgotOtp = false;
      _safeNotify();
    }
  }

  Future<bool> resetPasswordWithOtp(
    String otp,
    String newPassword, {
    BuildContext? context,
  }) async {
    isResettingForgotPass = true;
    _safeNotify();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final res = await http
          .post(
            Uri.parse('$_baseUrl/settings/forgot-password/reset'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'user_id': currentStudentId,
              'otp_code': otp,
              'new_password': newPassword,
            }),
          )
          .timeout(_timeout);

      // 🌟 🛡️ درع الحماية
      if (context != null && !context.mounted) return false;

      if (res.statusCode == 200) {
        lastPasswordChange = DateTime.now().toString().split(' ')[0];
        if (context != null)
          _showSuccess(S.of(context).password_changed_success, context);
        return true;
      }

      if (context != null) {
        _showError(
          _extractBackendError(res.body, S.of(context).error_updating_password),
          context,
        );
      }
      return false;
    } catch (e) {
      _handleNetworkError(e, context);
      return false;
    } finally {
      isResettingForgotPass = false;
      _safeNotify();
    }
  }

  Future<void> updateProfile({
    required String fullName,
    BuildContext? context,
  }) async {
    isUpdatingProfile = true;
    profileDialogError = null;
    _safeNotify();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final res = await http
          .put(
            Uri.parse('$_baseUrl/settings/update-profile'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'user_id': currentStudentId,
              'full_name': fullName,
              'email': userEmail,
            }),
          )
          .timeout(_timeout);

      // 🌟 🛡️ درع الحماية
      if (context != null && !context.mounted) return;

      if (res.statusCode == 200) {
        userName = fullName;
        if (context != null) {
          Navigator.pop(context);
          _showSuccess(S.of(context).name_updated_success, context);
        }
      } else {
        if (context != null) {
          profileDialogError = _extractBackendError(
            res.body,
            S.of(context).update_failed,
          );
        }
      }
    } catch (e) {
      _handleNetworkError(e, context);
      if (context != null)
        profileDialogError = S.of(context).no_server_connection;
    } finally {
      isUpdatingProfile = false;
      _safeNotify();
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
    BuildContext? context,
  }) async {
    isChangingPassword = true;
    passwordDialogError = null;
    _safeNotify();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final res = await http
          .put(
            Uri.parse('$_baseUrl/settings/change-password'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'user_id': currentStudentId,
              'old_password': oldPassword,
              'new_password': newPassword,
              'confirm_password': confirmPassword,
            }),
          )
          .timeout(_timeout);

      // 🌟 🛡️ درع الحماية
      if (context != null && !context.mounted) return;

      if (res.statusCode == 200) {
        if (context != null) Navigator.pop(context);
        lastPasswordChange = DateTime.now().toString().split(' ')[0];
        if (context != null)
          _showSuccess(S.of(context).password_updated_success, context);
      } else {
        if (context != null) {
          passwordDialogError = _extractBackendError(
            res.body,
            S.of(context).update_error,
          );
          _showError(passwordDialogError!, context);
        }
      }
    } catch (e) {
      _handleNetworkError(e, context);
      if (context != null) passwordDialogError = S.of(context).no_connection;
    } finally {
      isChangingPassword = false;
      _safeNotify();
    }
  }

  void checkPasswordStrength(String password, {BuildContext? context}) {
    double strength = 0;
    if (password.length >= 8) strength += 0.3;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.3;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.4;

    passwordStrength = strength;

    if (context != null) {
      if (strength <= 0.3) {
        passwordStrengthText = S.of(context).weak_password;
        passwordStrengthColor = Colors.red;
      } else if (strength <= 0.6) {
        passwordStrengthText = S.of(context).medium_password;
        passwordStrengthColor = Colors.orange;
      } else {
        passwordStrengthText = S.of(context).strong_password;
        passwordStrengthColor = Colors.green;
      }
    }
    _safeNotify();
  }

  void updateLanguageLocally(String newLang) {
    bool isEn = newLang == 'en';
    if (_rawResponseData != null) {
      userName = _rawResponseData!['full_name'] ?? '';
      educationLevel = isEn
          ? (_rawResponseData!['level_name_en'] ??
                _rawResponseData!['level_name'])
          : (_rawResponseData!['level_name'] ?? '');
      departmentName = isEn
          ? (_rawResponseData!['department_name_en'] ??
                _rawResponseData!['department_name'])
          : (_rawResponseData!['department_name'] ?? '');
      _safeNotify();
    }
  }

  Future<void> logout({BuildContext? context}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
