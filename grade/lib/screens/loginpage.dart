import 'package:flutter/material.dart';
import 'forgotpasswordpage.dart';
import '../core/colors.dart';
import '../generated/l10n.dart'; // استيراد ملف الترجمة
import 'homepage.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryTeal(context),
      body: Stack(
        children: [
          // سهم العودة التكيفي: يستخدم start بدلاً من right
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
                // Icons.adaptive.arrow_back يعكس نفسه تلقائياً (يمين في العربي، يسار في الإنجليزي)
                icon: Icon(Icons.adaptive.arrow_back, color: AppColors.primaryTeal(context), size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 420,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLogoBadge(context),
                      const SizedBox(height: 25),
                      Text(
                        S.of(context).login_title,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                          fontFamily: 'Arimo',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        S.of(context).login_subtitle,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      
                      _buildInputField(
                        context,
                        label: S.of(context).email_label,
                        icon: Icons.email_outlined,
                        validator: (v) => (v == null || !v.contains('@')) ? S.of(context).email_error : null,
                      ),
                      const SizedBox(height: 20),
                      
                      _buildInputField(
                        context,
                        label: S.of(context).password_label,
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        isObscured: _isObscured,
                        onSuffixTap: () => setState(() => _isObscured = !_isObscured),
                        validator: (v) => (v == null || v.length < 6) ? S.of(context).password_error : null,
                      ),
                      
                      Align(
                        alignment: AlignmentDirectional.centerStart, // لضمان بقائه في البداية حسب اللغة
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                          },
                          child: Text(
                            S.of(context).forgot_password,
                            style: TextStyle(color: AppColors.primaryTeal(context), fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(S.of(context).logging_in),
                                  backgroundColor: AppColors.primaryTeal(context),
                                ),
                              );
                              // منطق الانتقال...
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal(context),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 5,
                          ),
                          child: Text(
                            S.of(context).login_button,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
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

  Widget _buildLogoBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal(context).withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.fact_check_rounded, color: AppColors.primaryTeal(context), size: 40),
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isObscured = false,
    VoidCallback? onSuffixTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      obscureText: isObscured,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.primaryTeal(context), size: 22),
        suffixIcon: isPassword 
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey),
              )
            : null,
        filled: true,
        fillColor: Colors.grey[50],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.primaryTeal(context), width: 1.5),
        ),
      ),
    );
  }
}