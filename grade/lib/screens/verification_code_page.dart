
import 'package:grade/core/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/colors.dart';
import 'updatepasswordpagennew.dart'; 
import '../generated/l10n.dart';
import '../core/helpers/auth_helper.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String email; 

  const VerificationCodeScreen({super.key, required this.email});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false; 

  Future<void> _verifyAndNavigate() async {
    String otpCode = "";
    for (var controller in _controllers) {
      otpCode += controller.text.trim();
    }

    if (otpCode.length < 6) {
      _showSnackBar(S.of(context).otp_incomplete_error, Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('${AppConfig.baseUrl}/auth/verify-otp');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'otp_code': otpCode,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _showSnackBar(S.of(context).otp_success, Colors.green);
        
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdatePasswordScreen(
                email: widget.email, 
                otpCode: otpCode,    
              ),
            ),
          );
        }
      } else {
        String errorDetail = responseData['detail'] ?? "error_invalid_otp";
        _showSnackBar(AuthHelper.translateError(errorDetail, context), Colors.red);
      }
    } catch (e) {
      _showSnackBar(S.of(context).server_connection_error, Colors.red);
    } finally { // 👈 تم حذف الكلمة الزائدة هنا وإصلاح الخطأ تماماً
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
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            bool isMobile = width < 600;

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg(context),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle),
                        child: Icon(Icons.security_outlined, color: AppColors.primaryTeal(context), size: 40),
                      ),
                      const SizedBox(height: 24),
                      Text(S.of(context).otp_title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context), fontFamily: 'Arimo')),
                      const SizedBox(height: 8),
                      Text(S.of(context).otp_subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppColors.textSecondary(context), fontFamily: 'Arimo')),
                      const SizedBox(height: 35),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: isMobile ? 45 : 55,
                              height: isMobile ? 55 : 60,
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                enabled: !_isLoading,
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)),
                                inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.scaffoldBg(context),
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primaryTeal(context), width: 2)),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    if (index < 5) {
                                      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                                    } else {
                                      _focusNodes[index].unfocus();
                                    }
                                  } else {
                                    if (index > 0) {
                                      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                                    }
                                  }
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 35),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _verifyAndNavigate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal(context),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: _isLoading
                              ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                              : Text(S.of(context).confirm_code_btn, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Arimo', color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}