import 'package:grade/core/app_config.dart';
// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert'; // تمت الإضافة للتعامل مع JSON
import 'package:http/http.dart' as http; // تمت الإضافة للاتصال بالباك إند
import '../core/colors.dart';
import 'update_password_page.dart';
import '../generated/l10n.dart'; 
import '../core/helpers/auth_helper.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email; 

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final otpCode = _otpController.text.trim();

      // 👈 الربط مع FastAPI للتحقق من الرمز
      final url = Uri.parse('${AppConfig.baseUrl}/auth/verify-otp');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'otp_code': otpCode,
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          // 🟢 تمرير الإيميل والرمز لصفحة إعادة التعيين
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(
                email: widget.email,
                otpCode: otpCode,
              ),
            ),
          );
        }
      } else {
        // إذا كان الرمز خطأ
        final responseData = jsonDecode(response.body);
        final String errorDetail = responseData['detail'] ?? "error_invalid_otp";
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
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryTeal(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back, color: AppColors.primaryTeal(context)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
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
                        child: Icon(Icons.mark_email_read_outlined, color: AppColors.primaryTeal(context), size: 50),
                      ),
                      const SizedBox(height: 25),
                      Text(S.of(context).otp_title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)), textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      Text(S.of(context).otp_subtitle + widget.email, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.5)),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: _otpController,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 6, 
                        style: const TextStyle(fontSize: 24, letterSpacing: 15, fontWeight: FontWeight.bold),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (v) => (v == null || v.length < 6) ? S.of(context).otp_validation_error : null,
                        decoration: InputDecoration(
                          counterText: "", 
                          hintText: "••••••",
                          hintStyle: TextStyle(letterSpacing: 15, color: Colors.grey[400]),
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
                          onPressed: _isLoading ? null : _verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal(context),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 4,
                          ),
                          child: _isLoading
                              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                              : Text(S.of(context).verify_otp_button, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ),
        ),
      ),
    );
  }
}