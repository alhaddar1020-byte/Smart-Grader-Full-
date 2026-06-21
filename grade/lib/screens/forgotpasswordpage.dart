import 'package:grade/core/app_config.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // تمت الإضافة للتعامل مع JSON
import 'package:http/http.dart' as http; // تمت الإضافة للاتصال بالباك إند
import '../core/colors.dart';
import '../generated/l10n.dart'; 
import '../core/helpers/auth_helper.dart';
import 'OTP Verification.dart'; // تأكدي من المسار

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();

      // 👈 الربط مع الدالة الجديدة في FastAPI
      final url = Uri.parse('${AppConfig.baseUrl}/auth/send-forgot-password-otp');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        // في حال النجاح
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).link_sent_success),
              backgroundColor: AppColors.primaryTeal(context),
            ),
          );
          
          // الانتقال لشاشة التحقق وتمرير الإيميل
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(email: email),
            ),
          );
          
          _emailController.clear();
        }
      } else {
        // التقاط رسائل الخطأ من الباك إند
        final responseData = jsonDecode(response.body);
        final errorDetail = responseData['detail'] ?? "error_connection_failed";
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AuthHelper.translateError(errorDetail, context)), backgroundColor: Colors.redAccent),
          );
        }
      }
    } catch (error) {
      // أخطاء الاتصال بالإنترنت أو توقف السيرفر
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).server_connection_error), backgroundColor: Colors.redAccent),
        );
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
    _emailController.dispose();
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: 420,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: AppColors.cardBg(context),
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
                        child: Icon(Icons.lock_reset_rounded, color: AppColors.primaryTeal(context), size: 50),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        S.of(context).forgot_pw_title,
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        S.of(context).forgot_pw_subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary(context), fontSize: 14, height: 1.5),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: _emailController,
                        enabled: !_isLoading, 
                        textAlign: TextAlign.start,
                        validator: (v) => (v == null || !v.contains('@')) ? S.of(context).email_validation_error : null,
                        decoration: InputDecoration(
                          labelText: S.of(context).email_label,
                          prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryTeal(context)),
                          filled: true,
                          fillColor: AppColors.scaffoldBg(context),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: AppColors.primaryTeal(context), width: 2)),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleResetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal(context),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 4,
                          ),
                          child: _isLoading
                              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                              : Text(S.of(context).send_code_btn, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
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