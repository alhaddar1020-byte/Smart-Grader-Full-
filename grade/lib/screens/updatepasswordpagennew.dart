
import 'package:grade/core/app_config.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/colors.dart';
import '../generated/l10n.dart';
import '../core/helpers/auth_helper.dart';

// --- استدعاء الواجهات بناءً على الكود الخاص بك ---
import 'package:grade/core/main_layout.dart';
import 'teacher_dashboard.dart'; 
import 'student_dashboard.dart';
import 'loginpage.dart';

class UpdatePasswordScreen extends StatefulWidget {
  final String email;   
  final String otpCode; 

  const UpdatePasswordScreen({
    super.key,
    required this.email,
    required this.otpCode,
  });

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> _setNewPassword() async {
    final String newPassword = _passwordController.text.trim();

    if (newPassword.isEmpty) {
      _showSnackBar(S.of(context).password_empty_error, Colors.orange);
      return;
    }

    if (newPassword.length < 6) {
      _showSnackBar(S.of(context).password_length_error, Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('${AppConfig.baseUrl}/auth/verify-and-set-password');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,         
          'otp_code': widget.otpCode,    
          'new_password': newPassword,   
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        _showSnackBar(responseData['message'] ?? "تم تعيين كلمة المرور بنجاح!", Colors.green);

        if (mounted) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen(fromRegistration: true)),
              (route) => false,
            );
          });
        }
      } else {
        String errorDetail = responseData['detail'] ?? "error_connection_failed";
        _showSnackBar(AuthHelper.translateError(errorDetail, context), Colors.red);
      }
    } catch (e) {
      _showSnackBar(S.of(context).server_connection_error, Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textDirection: TextDirection.rtl, style: const TextStyle(fontFamily: 'Arimo')),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryTeal(context),
      body: Stack(
        children: [
          PositionedDirectional(
            top: 50,
            start: 20, 
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: IconButton(
                icon: Icon(Icons.adaptive.arrow_back, color: AppColors.primaryTeal(context), size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppColors.cardBg(context),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle),
                    child: Icon(Icons.lock_reset_outlined, color: AppColors.primaryTeal(context), size: 40),
                  ),
                  const SizedBox(height: 24),
                  Text(S.of(context).new_password_title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context), fontFamily: 'Arimo')),
                  const SizedBox(height: 8),
                  Text(S.of(context).new_password_subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppColors.textSecondary(context), fontFamily: 'Arimo')),
                  const SizedBox(height: 30),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      textAlign: TextAlign.right,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        hintText: S.of(context).new_password_hint,
                        prefixIcon: Icon(Icons.lock_outline, color: AppColors.primaryTeal(context)),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        ),
                        filled: true,
                        fillColor: AppColors.scaffoldBg(context),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _setNewPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal(context),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: _isLoading
                          ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                          : Text(S.of(context).save_account_btn, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Arimo', color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      ],
      ),
    );
  }
}