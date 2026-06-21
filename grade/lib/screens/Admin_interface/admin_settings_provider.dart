import 'package:grade/core/app_config.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

// 1. إصلاح مسار الاستيراد للرجوع مجلدين للخلف
import '../../core/locale_provider.dart';
import '../../generated/l10n.dart'; // استدعاء ملف الترجمة

class AdminSettingsProvider extends ChangeNotifier {
  // ==========================================
  // الروابط والإعدادات الأساسية
  // ==========================================
  final String adminUrl = '${AppConfig.baseUrl}/settings';
  final String academicUrl = '${AppConfig.baseUrl}/academic';
  final Duration _timeout = const Duration(seconds: 15);

  int currentUserId = 0;

  // ==========================================
  // بيانات الحساب
  // ==========================================
  String userRole = '';
  String userName = '';
  String userEmail = '';
  String phoneNumber = '';
  String educationLevel = '';
  String departmentName = '';
  String lastPasswordChange = '';
  Map<String, dynamic>? _rawResponseData;

  // 2. إضافة حالات التحميل المفقودة
  bool isLoadingProfile = false;
  bool isUpdatingProfile = false;
  bool isSendingOtp = false;
  bool isVerifyingOtp = false;
  bool isSendingForgotOtp = false;
  bool isVerifyingForgotOtp = false;
  bool isResettingForgotPass = false;
  
  // قوة كلمة المرور
  double passwordStrengthValue = 0.0;
  String passwordStrengthText = '';
  Color passwordStrengthColor = Colors.red;

  String get levelAndDepartment {
    if (departmentName.isEmpty) return educationLevel;
    return "$educationLevel - $departmentName";
  }

  // ==========================================
  // دوال مساعدة لرسائل الخطأ والنجاح
  // ==========================================
  void _showSuccess(BuildContext context, String msg) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [const Icon(Icons.check_circle, color: Colors.white), const SizedBox(width: 10), Expanded(child: Text(msg, style: const TextStyle(color: Colors.white)))]),
        backgroundColor: Colors.teal, behavior: SnackBarBehavior.floating,
      ));
    }
  }

  void _showError(BuildContext context, String msg) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [const Icon(Icons.error_outline, color: Colors.white), const SizedBox(width: 10), Expanded(child: Text(msg, style: const TextStyle(color: Colors.white)))]),
        backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 4),
      ));
    }
  }

  // الترجمة الديناميكية لأخطاء الباك إند
  // الترجمة الديناميكية لأخطاء الباك إند
  String _extractBackendError(String responseBody, BuildContext context) {
    try {
      final data = json.decode(responseBody);
      final String code = data['detail'] ?? 'UNKNOWN_ERROR';
      
      // مطابقة كود الخطأ مع لغة التطبيق بناءً على مفاتيح الباك إند
      switch(code) {
        case 'INVALID_OTP': return S.of(context).settingsOtpIncorrect;
        case 'USER_NOT_FOUND': return S.of(context).no_users_found;
        case 'PASSWORDS_DO_NOT_MATCH': return S.of(context).settingsPasswordNotMatch;
        case 'INCORRECT_CURRENT_PASSWORD': return S.of(context).settingsIncorrectCurrentPassword;
        case 'FAILED_TO_SEND_EMAIL': return S.of(context).connection_error; // أو رسالة تفيد بفشل الإرسال
        default: return S.of(context).error_occurred; // خطأ عام (Fallback)
      }
    } catch (_) {
      return S.of(context).error_occurred;
    }
  }

  // ==========================================
  // الملف الشخصي وإدارة الأمان
  // ==========================================


  Future<void> initializeProvider(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getInt('user_id') ?? 1;
    userRole = prefs.getString('role') ?? 'ADMIN';
    if (!context.mounted) return;
    await fetchProfile(context);
    if (!context.mounted) return;
    await fetchSemesters(context);
  }

  Future<void> fetchProfile(BuildContext context) async {

    isLoadingProfile = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.get(Uri.parse('$adminUrl/profile/$currentUserId'), headers: headers).timeout(_timeout);
      if (!context.mounted) return; // 3. حل تحذير الـ Context
      
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        _rawResponseData = data;
        
        final localeProvider = context.read<LocaleProvider>();
        bool isEn = localeProvider.locale.languageCode == 'en';

        userName = data['full_name'] ?? '';
        educationLevel = isEn ? (data['level_name_en'] ?? data['level_name'] ?? '') : (data['level_name'] ?? '');
        departmentName = isEn ? (data['department_name_en'] ?? data['department_name'] ?? '') : (data['department_name'] ?? '');
        userEmail = data['email'] ?? '';
        phoneNumber = data['phone_number'] ?? '';
        lastPasswordChange = data['last_password_change'] != null ? data['last_password_change'].toString().split(' ')[0] : '';
      }
    } catch (e) {
      print('Error in fetchProfile: $e');
      debugPrint("Profile fetch error: $e");
    } finally {
      isLoadingProfile = false;
      notifyListeners();
    }
  }

  Future<void> updateProfileName(String fullName, String phone, String email, BuildContext context) async {
    isUpdatingProfile = true; notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.put(
        Uri.parse('$adminUrl/update-profile'),
        headers: headers,
        body: jsonEncode({'user_id': currentUserId, 'full_name': fullName, 'phone_number': phone, 'email': email}),
      ).timeout(_timeout);
      
      if (!context.mounted) return;
      if (res.statusCode == 200) {
        userName = fullName;
        phoneNumber = phone;
        userEmail = email;
        _showSuccess(context, S.of(context).edit_success);
      } else {
        _showError(context, _extractBackendError(res.body, context));
      }
    } catch (e) {
      print('Error in updateProfileName: $e');
      if (!context.mounted) return;
      _showError(context, S.of(context).connection_error);
    } finally {
      isUpdatingProfile = false; notifyListeners();
    }
  }

  Future<bool> sendEmailChangeOtp(String newEmail, BuildContext context) async {

    isSendingOtp = true; notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(
        Uri.parse('$adminUrl/send-email-otp'),
        headers: headers,
        body: jsonEncode({'user_id': currentUserId, 'new_email': newEmail}),
      ).timeout(_timeout);
      
      if (!context.mounted) return false;
      if (res.statusCode == 200) return true;
      
      _showError(context, _extractBackendError(res.body, context)); return false;
    } catch (e) {
      print('Error in sendEmailChangeOtp: $e');
      if (!context.mounted) return false;
      _showError(context, S.of(context).connection_error); return false;
    } finally {
      isSendingOtp = false; notifyListeners();
    }
  }

  Future<bool> verifyEmailOtp(String otpCode, String newEmail, BuildContext context) async {

    isVerifyingOtp = true; notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(
        Uri.parse('$adminUrl/verify-email-otp'),
        headers: headers,
        body: jsonEncode({'user_id': currentUserId, 'new_email': newEmail, 'otp_code': otpCode}),
      ).timeout(_timeout);
      
      if (!context.mounted) return false;
      if (res.statusCode == 200) {
        userEmail = newEmail; notifyListeners();
        return true;
      }
      _showError(context, _extractBackendError(res.body, context)); return false;
    } catch (e) {
      print('Error in verifyEmailOtp: $e');
      if (!context.mounted) return false;
      _showError(context, S.of(context).connection_error); return false;
    } finally {
      isVerifyingOtp = false; notifyListeners();
    }
  }

  void checkPasswordStrength(String password, BuildContext context) {
    double strength = 0;
    if (password.length >= 8) strength += 0.3;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.3;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.4;
    passwordStrengthValue = strength;
    
    if (strength <= 0.3) { passwordStrengthText = S.of(context).password_weak; passwordStrengthColor = Colors.red; } 
    else if (strength <= 0.6) { passwordStrengthText = S.of(context).password_medium; passwordStrengthColor = Colors.orange; } 
    else { passwordStrengthText = S.of(context).password_strong; passwordStrengthColor = Colors.green; }
    notifyListeners();
  }

  Future<bool> changePassword(String oldPass, String newPass, String confirmPass, BuildContext context) async {

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.put(
        Uri.parse('$adminUrl/change-password'),
        headers: headers,
        body: jsonEncode({'user_id': currentUserId, 'old_password': oldPass, 'new_password': newPass, 'confirm_password': confirmPass}),
      ).timeout(_timeout);
      
      if (!context.mounted) return false;
      if (res.statusCode == 200) {
        lastPasswordChange = DateTime.now().toString().split(' ')[0];
        _showSuccess(context, S.of(context).settingsPasswordUpdated);
        notifyListeners();
        return true;
      }
      _showError(context, _extractBackendError(res.body, context));
      return false;
    } catch (e) {
      print('Error in changePassword: $e');
      if (!context.mounted) return false;
      _showError(context, S.of(context).connection_error);
      return false;
    }
  }

  Future<bool> sendForgotPasswordOtp(BuildContext context) async {

    isSendingForgotOtp = true; notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(Uri.parse('$adminUrl/forgot-password/send-otp'), headers: headers, body: jsonEncode({'user_id': currentUserId})).timeout(_timeout);
      if (!context.mounted) return false;
      if (res.statusCode == 200) return true;
      _showError(context, _extractBackendError(res.body, context)); return false;
    } catch (e) { 
      print('Error in sendForgotPasswordOtp: $e');
      if (!context.mounted) return false;
      _showError(context, S.of(context).connection_error); return false; 
    } finally {
      isSendingForgotOtp = false; notifyListeners();
    }
  }

  Future<bool> verifyForgotPasswordOtp(String otp, BuildContext context) async {

    isVerifyingForgotOtp = true; notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(Uri.parse('$adminUrl/forgot-password/verify-otp'), headers: headers, body: jsonEncode({'user_id': currentUserId, 'otp_code': otp})).timeout(_timeout);
      if (!context.mounted) return false;
      if (res.statusCode == 200) return true;
      _showError(context, _extractBackendError(res.body, context)); return false;
    } catch (e) { 
      print('Error in verifyForgotPasswordOtp: $e');
      if (!context.mounted) return false;
      _showError(context, S.of(context).connection_error); return false; 
    } finally {
      isVerifyingForgotOtp = false; notifyListeners();
    }
  }

  Future<bool> resetPasswordWithOtp(String otp, String newPassword, BuildContext context) async {

    isResettingForgotPass = true; notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(Uri.parse('$adminUrl/forgot-password/reset'), headers: headers, body: jsonEncode({'user_id': currentUserId, 'otp_code': otp, 'new_password': newPassword})).timeout(_timeout);
      if (!context.mounted) return false;
      if (res.statusCode == 200) { 
        lastPasswordChange = DateTime.now().toString().split(' ')[0]; 
        _showSuccess(context, S.of(context).settingsPasswordUpdated); 
        notifyListeners(); 
        return true; 
      }
      _showError(context, _extractBackendError(res.body, context)); return false;
    } catch (e) { 
      print('Error in resetPasswordWithOtp: $e');
      if (!context.mounted) return false;
      _showError(context, S.of(context).connection_error); return false; 
    } finally {
      isResettingForgotPass = false; notifyListeners();
    }
  }

  // ==========================================
  // الإعدادات الأكاديمية (الفصول الدراسية)
  // ==========================================
  bool isLoadingSemesters = false;
  List<Map<String, dynamic>> semestersList = [];

  Future<void> fetchSemesters(BuildContext context) async {

    isLoadingSemesters = true; notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.get(Uri.parse('$academicUrl/semesters'), headers: headers).timeout(_timeout);
      if (!context.mounted) return;
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data is List) {
          semestersList = List<Map<String, dynamic>>.from(data);
        } else if (data['semesters'] != null) {
          semestersList = List<Map<String, dynamic>>.from(data['semesters']);
        }
      }
    } catch (e) {
      print('Error in fetchSemesters: $e');
      debugPrint('Error fetching semesters: $e');
    } finally {
      isLoadingSemesters = false; notifyListeners();
    }
  }

  Future<void> addSemester(String name, String year, String start, String end, BuildContext context) async {

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.post(Uri.parse('$academicUrl/semesters'), headers: headers, body: json.encode({"semester_name": name, "academic_year": year, "start_date": start.isEmpty ? null : start, "end_date": end.isEmpty ? null : end}));
      if (!context.mounted) return;
      if (response.statusCode == 200) { 
        await fetchSemesters(context); 
        if(!context.mounted) return;
        _showSuccess(context, S.of(context).settingsSuccess); 
      } else { 
        _showError(context, _extractBackendError(response.body, context)); 
      }
    } catch (e) { 
      print('Error in addSemester: $e');
      if (!context.mounted) return;
      _showError(context, S.of(context).connection_error); 
    }
  }

  Future<void> toggleCurrentSemester(int index, BuildContext context) async {

    final semesterId = semestersList[index]['semester_id'];
    for (int i = 0; i < semestersList.length; i++) { semestersList[i]['is_current'] = (i == index); } notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.put(Uri.parse('$academicUrl/semesters/$semesterId/toggle-current'), headers: headers);
      if (!context.mounted) return;
      if (response.statusCode != 200) { 
        _showError(context, _extractBackendError(response.body, context)); 
        await fetchSemesters(context); 
      }
    } catch (e) { 
      print('Error in toggleCurrentSemester: $e');
      if (!context.mounted) return;
      await fetchSemesters(context); 
    }
  }

  Future<void> deleteSemester(int semesterId, BuildContext context) async {

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.delete(Uri.parse('$academicUrl/semesters/$semesterId'), headers: headers);
      if (!context.mounted) return;
      if (response.statusCode == 200) { 
        await fetchSemesters(context);
        if(!context.mounted) return;
        _showSuccess(context, S.of(context).delete_success); 
      } else { 
        _showError(context, _extractBackendError(response.body, context)); 
      }
    } catch (e) { 
      print('Error in deleteSemester: $e');
      if (!context.mounted) return;
      _showError(context, S.of(context).connection_error); 
    }
  }

  Future<void> updateSemester(int semesterId, String name, String year, String start, String end, BuildContext context) async {

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.put(Uri.parse('$academicUrl/semesters/$semesterId'), headers: headers, body: json.encode({"semester_name": name, "academic_year": year, "start_date": start, "end_date": end}));
      if (!context.mounted) return;
      if (response.statusCode == 200) { 
        await fetchSemesters(context); 
        if(!context.mounted) return;
        _showSuccess(context, S.of(context).edit_success); 
      } else { 
        _showError(context, _extractBackendError(response.body, context)); 
      }
    } catch (e) { 
      print('Error in updateSemester: $e');
      if (!context.mounted) return;
      _showError(context, S.of(context).connection_error); 
    }
  }

  void updateLanguageLocally(String newLang) {
    bool isEn = newLang == 'en';
    if (_rawResponseData != null) {
      userName = _rawResponseData!['full_name'] ?? '';
      educationLevel = isEn ? (_rawResponseData!['level_name_en'] ?? _rawResponseData!['level_name']) : (_rawResponseData!['level_name'] ?? '');
      departmentName = isEn ? (_rawResponseData!['department_name_en'] ?? _rawResponseData!['department_name']) : (_rawResponseData!['department_name'] ?? '');
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('language_code');
    final theme = prefs.getBool('theme_mode');
    
    await prefs.clear();
    
    if (lang != null) await prefs.setString('language_code', lang);
    if (theme != null) await prefs.setBool('theme_mode', theme);
    
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }
}
