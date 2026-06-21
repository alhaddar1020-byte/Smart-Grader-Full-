// import 'package:flutter/material.dart';
// import '../core/colors.dart';
// import 'verification_code_page.dart'; // استيراد صفحة الرمز للانتقال إليها

// class RegisterEmailScreen extends StatelessWidget {
//   const RegisterEmailScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.secondaryTeal(context),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.adaptive.arrow_back, color: AppColors.primaryTeal(context)),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             double width = constraints.maxWidth;
//             bool isMobile = width < 600;

//             return Center(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80),
//                 child: Container(
//                   constraints: const BoxConstraints(maxWidth: 500),
//                   padding: const EdgeInsets.all(30),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(24),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 15,
//                         offset: const Offset(0, 5),
//                       )
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // أيقونة الواجهة
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: AppColors.secondaryTeal(context),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           Icons.mark_email_read_outlined,
//                           color: AppColors.primaryTeal(context),
//                           size: 40,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
                      
//                       // العنوان الرئيسي
//                       const Text(
//                         "مستخدم جديد",
//                         style: TextStyle(
//                           fontSize: 26,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF28308C),
//                           fontFamily: 'Arimo',
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         "أدخل بريدك الإلكتروني لإنشاء الحساب وتلقي رمز التحقق",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Color(0xFF6E7881),
//                           fontFamily: 'Arimo',
//                         ),
//                       ),
//                       const SizedBox(height: 30),

//                       // حقل إدخال الإيميل
//                       Directionality(
//                         textDirection: TextDirection.rtl,
//                         child: TextField(
//                           keyboardType: TextInputType.emailAddress,
//                           textAlign: TextAlign.right,
//                           decoration: InputDecoration(
//                             hintText: "أدخل إيميلك",
//                             hintStyle: const TextStyle(color: Color(0xFF9EA6AD), fontSize: 15),
//                             prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryTeal(context)),
//                             filled: true,
//                             fillColor: const Color(0xFFF8FAFC),
//                             contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                               borderSide: BorderSide.none,
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                               borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                               borderSide: BorderSide(color: AppColors.primaryTeal(context), width: 1.5),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 30),

//                       // زر إرسال الرمز
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             // الانتقال لواجهة رمز التحقق المكونة من 6 خانات
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => const VerificationCodeScreen()),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.primaryTeal(context),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 18),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                             elevation: 0,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text(
//                                 "ارسال الرمز",
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Arimo'),
//                               ),
//                               const SizedBox(width: 10),
//                               Icon(Icons.adaptive.arrow_forward, size: 22),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }



import 'package:grade/core/app_config.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/colors.dart';
import 'verification_code_page.dart';
import '../generated/l10n.dart';
import '../core/helpers/auth_helper.dart';

class RegisterEmailScreen extends StatefulWidget {
  const RegisterEmailScreen({super.key});

  @override
  State<RegisterEmailScreen> createState() => _RegisterEmailScreenState();
}

class _RegisterEmailScreenState extends State<RegisterEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendOtp() async {
    final String email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar(S.of(context).email_empty_error, Colors.orange);
      return;
    }

    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      _showSnackBar(S.of(context).email_invalid_error, Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // بما أنكِ تستخدمين كروم، localhost يعمل بشكل ممتاز
      final url = Uri.parse('${AppConfig.baseUrl}/auth/send-new-user-otp');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        _showSnackBar(S.of(context).link_sent_success, Colors.green);
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationCodeScreen(email: email),
            ),
          );
        }
      } 
      // 👈 التعديل هنا: التعامل مع حالة المستخدم المسجل مسبقاً وأخطاء أخرى من الباك إند
      else {
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            bool isMobile = width < 600;
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80),
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
                        child: Icon(Icons.mark_email_read_outlined, color: AppColors.primaryTeal(context), size: 40),
                      ),
                      const SizedBox(height: 24),
                      Text(S.of(context).register_title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context), fontFamily: 'Arimo')),
                      const SizedBox(height: 8),
                      Text(S.of(context).register_subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppColors.textSecondary(context), fontFamily: 'Arimo')),
                      const SizedBox(height: 30),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          enabled: !_isLoading,
                          decoration: InputDecoration(
                            hintText: S.of(context).email_hint,
                            prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryTeal(context)),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal(context),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: _isLoading
                              ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(S.of(context).send_code_btn, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Arimo')),
                                    const SizedBox(width: 10),
                                  ],
                                ),
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
      ],
      ),
    );
  }
}