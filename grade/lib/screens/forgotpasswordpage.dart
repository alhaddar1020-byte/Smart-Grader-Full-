import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../generated/l10n.dart'; // استيراد ملف الترجمة

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryTeal(context),
      body: Stack(
        children: [
          // سهم العودة: استخدام PositionedDirectional مع start يضمن مكانه الصحيح في اللغتين
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: 420,
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
                      // أيقونة القفل المحدثة بـ withValues
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
                        S.of(context).forgot_pw_title, // العنوان مترجم
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        S.of(context).forgot_pw_subtitle, // النص الفرعي مترجم
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.5),
                      ),
                      const SizedBox(height: 40),
                      
                      // حقل الإيميل
                      TextFormField(
                        controller: _emailController,
                        textAlign: TextAlign.start, // يبدأ من اليسار للإنجليزي واليمين للعربي تلقائياً
                        validator: (v) => (v == null || !v.contains('@')) ? S.of(context).email_validation_error : null,
                        decoration: InputDecoration(
                          labelText: S.of(context).email_label,
                          prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryTeal(context)),
                          filled: true,
                          fillColor: Colors.grey[50],
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey[200]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: AppColors.primaryTeal(context), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // زر الإرسال
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(S.of(context).link_sent_success),
                                  backgroundColor: AppColors.primaryTeal(context),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal(context),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 4,
                          ),
                          child: Text(
                            S.of(context).send_link_button, // زر الإرسال مترجم
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
}