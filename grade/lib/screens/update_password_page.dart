import 'package:grade/core/app_config.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // تمت الإضافة
import 'package:http/http.dart' as http; // تمت الإضافة
import '../core/colors.dart';
import '../generated/l10n.dart';
import '../core/helpers/auth_helper.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;    // 🟢 أضفنا متغير الإيميل
  final String otpCode;  // 🟢 أضفنا متغير الرمز

  const ResetPasswordScreen({
    super.key, 
    required this.email, 
    required this.otpCode,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _isSuccess = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newPassword = _passwordController.text.trim();

      // 👈 الربط مع دالة FastAPI لتحديث كلمة المرور
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

      if (response.statusCode == 200) {
        setState(() {
          _isSuccess = true;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).settingsPasswordUpdated), backgroundColor: AppColors.primaryTeal(context)),
          );
        }
      } else {
        // إذا حدث خطأ (مثلاً الرمز انتهت صلاحيته فجأة)
        final responseData = jsonDecode(response.body);
        final errorDetail = responseData['detail'] ?? "error_update_password_failed";
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AuthHelper.translateError(errorDetail, context)), backgroundColor: Colors.redAccent));
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).server_connection_error), backgroundColor: Colors.redAccent));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryTeal(context),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 25, offset: const Offset(0, 10)),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal(context).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isSuccess ? Icons.check_circle_outline_rounded : Icons.lock_open_rounded, 
                      color: AppColors.primaryTeal(context), 
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    _isSuccess ? S.of(context).success_operation : S.of(context).update_pw_title,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isSuccess 
                        ? S.of(context).password_updated_success_msg
                        : S.of(context).update_pw_subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  
                  if (!_isSuccess) ...[
                    TextFormField(
                      controller: _passwordController,
                      enabled: !_isLoading,
                      obscureText: _obscurePassword,
                      validator: (v) => (v == null || v.length < 6) ? S.of(context).password_length_error : null,
                      decoration: InputDecoration(
                        labelText: S.of(context).new_password_label,
                        prefixIcon: Icon(Icons.lock_outline, color: AppColors.primaryTeal(context)),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: AppColors.primaryTeal(context), width: 2)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      enabled: !_isLoading,
                      obscureText: _obscureConfirmPassword,
                      validator: (v) => (v != _passwordController.text) ? S.of(context).passwords_dont_match_error : null,
                      decoration: InputDecoration(
                        labelText: S.of(context).confirm_password_label,
                        prefixIcon: Icon(Icons.lock_clock_outlined, color: AppColors.primaryTeal(context)),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: AppColors.primaryTeal(context), width: 2)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updatePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryTeal(context),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 4,
                        ),
                        child: _isLoading
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : Text(S.of(context).save_password_button, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          // الرجوع إلى شاشة تسجيل الدخول
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryTeal(context),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 4,
                        ),
                        child: Text(S.of(context).go_to_login_button, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}