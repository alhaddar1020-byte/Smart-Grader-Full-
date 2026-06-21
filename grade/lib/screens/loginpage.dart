import 'package:flutter/material.dart';
import 'package:grade/core/main_layout.dart';
import 'forgotpasswordpage.dart';
import '../core/colors.dart';
import '../generated/l10n.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../core/locale_provider.dart';
import '../core/theme_provider.dart';
import 'package:grade/core/app_config.dart';
// --- استدعاء صفحات الطالب بناءً على ملفاتك ---
import 'student_dashboard.dart';
import 'student_detiles.dart';
import 'student_exim.dart';
import 'student_matearial.dart';
import 'student_setting.dart';
import 'student_profile_settings_page.dart';

// --- استدعاء صفحات المدرس والادمن ---
import 'teacher_dashboard.dart';
import 'Admin_interface/admin_dashboard_screen.dart';
import 'exam_page.dart';
import 'ExamManagementPage.dart';
import 'grading.dart';

class LoginScreen extends StatefulWidget {
  final bool fromRegistration;
  const LoginScreen({super.key, this.fromRegistration = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loginAndNavigate() async {
    setState(() {
      _isLoading = true;
    });

    final String apiUrl = '${AppConfig.baseUrl}/auth/login';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      // 1. إذا البيانات صحيحة 100% والسيرفر شغال
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("🚨 البيانات القادمة من الباك إند هي: $data");

        final String token = data['access_token'] ?? '';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        final dynamic roleData = data['role_id'];
        final int roleId = (roleData != null)
            ? int.parse(roleData.toString())
            : 0;

        final dynamic userIdData = data['user_id'] ?? data['student_id'] ?? 1;
        final int userId = int.parse(userIdData.toString());

        await prefs.setInt('role_id', roleId);
        await prefs.setInt('user_id', userId);
        await prefs.setInt('student_id', userId);
        print(
          "✅ تم حفظ رقم الطالب بنجاح في الذاكرة: $userId",
        ); // 👈 أضيفي هذا السطر

        if (roleId == 0) {
          _showErrorSnackBar(
            'عذراً، لم يتم العثور على صلاحية محددة لهذا الحساب',
          );
          return;
        }

        // --- تحديث التفضيلات ---
        if (mounted) {
          final localeProvider = context.read<LocaleProvider>();
          final themeProvider = context.read<ThemeProvider>();
          final prefs = await SharedPreferences.getInstance();
          bool visitorChanged =
              prefs.getBool('visitor_preferences_changed') ?? false;

          if (widget.fromRegistration || visitorChanged) {
            // الزائر اختار إعدادات بنفسه قبل الدخول، نرسلها للباك إند لتُحفظ كإعداداته الافتراضية
            final currentLang = localeProvider.locale.languageCode;
            final isDark = themeProvider.isDarkMode;

            try {
              await http.put(
                Uri.parse(
                  '${AppConfig.baseUrl}/settings/update-display-preferences',
                ),
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
                body: jsonEncode({
                  'user_id': userId,
                  'language_code': currentLang,
                  'is_dark_mode': isDark,
                }),
              );
            } catch (e) {
              print("Error syncing preferences to backend: $e");
            }
            await prefs.setBool('visitor_preferences_changed', false);
          } else {
            // 🌟 نسخة محصنة ومطابقة تماماً لـ main.dart لقراءة إعدادات الطالب فوراً
            try {
              final profileUrl = Uri.parse(
                '${AppConfig.baseUrl}/settings/profile/$userId',
              );
              final profileRes = await http
                  .get(profileUrl)
                  .timeout(const Duration(seconds: 5));

              if (profileRes.statusCode == 200) {
                final decodedData = jsonDecode(
                  utf8.decode(profileRes.bodyBytes),
                );
                Map<String, dynamic>? serverSettings;

                // 💡 هنا السحر: قبول البيانات سواء جاءت List أو Map لمنع التخطّي الصامت
                if (decodedData is List && decodedData.isNotEmpty) {
                  serverSettings = decodedData[0] as Map<String, dynamic>;
                } else if (decodedData is Map<String, dynamic>) {
                  serverSettings = decodedData;
                }

                if (serverSettings != null) {
                  // 1. تحديث وتطبيق اللغة فوراً
                  final String userLang =
                      serverSettings['language_code'] ??
                      data['language_code'] ??
                      'ar';
                  localeProvider.setInitialLocale(userLang);
                  await prefs.setString('language_code', userLang);

                  // 2. تحديث وتطبيق الثيم بذكاء لحمايته من نوع البيانات
                  var fetchedTheme = serverSettings['is_dark_mode'];
                  bool isDark = false;
                  if (fetchedTheme != null) {
                    if (fetchedTheme is bool)
                      isDark = fetchedTheme;
                    else if (fetchedTheme is int)
                      isDark = (fetchedTheme == 1);
                    else if (fetchedTheme is String)
                      isDark =
                          (fetchedTheme.toLowerCase() == 'true' ||
                          fetchedTheme == '1');
                  }

                  themeProvider.toggleTheme(isDark);
                  await prefs.setBool('theme_mode', isDark);

                  print(
                    "🎯 [نجاح] تم تطبيق الإعدادات الحية: اللغة = $userLang | دارك مود = $isDark",
                  );
                }
              } else {
                print(
                  "⚠️ السيرفر رد بكود خطأ أثناء جلب الملف شخصي: ${profileRes.statusCode}",
                );
              }
            } catch (e) {
              print("⚠️ فشل جلب الإعدادات الحية بسبب الاتصال: $e");
            }
          }
        }

        if (!mounted) return;

        // الدخول للواجهة المحددة
        switch (roleId) {
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainLayout()),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const StudentDashboardScreen(),
              ),
            );
            break;
          default:
            _showErrorSnackBar('عذراً، صلاحية هذا المستخدم غير معروفة بالنظام');
        }
      }
      // 2. إذا السيرفر شغال ولكن كلمة المرور أو الإيميل خطأ
      else {
        _showErrorSnackBar('كلمة المرور خاطئة');
      }
    } catch (e) {
      // 3. إذا السيرفر مغلق أو لا يوجد اتصال أصلاً
      print("Error: $e");
      _showErrorSnackBar('كلمة المرور خاطئة .');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Arimo')),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                icon: Icon(
                  Icons.adaptive.arrow_back,
                  color: AppColors.primaryTeal(context),
                  size: 20,
                ),
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
                  color: AppColors.cardBg(context),
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
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      _buildInputField(
                        context,
                        label: S.of(context).email_label,
                        icon: Icons.email_outlined,
                        controller: _emailController,
                        validator: (v) => (v == null || !v.contains('@'))
                            ? S.of(context).email_error
                            : null,
                      ),
                      const SizedBox(height: 20),

                      _buildInputField(
                        context,
                        label: S.of(context).password_label,
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        isObscured: _isObscured,
                        controller: _passwordController,
                        onSuffixTap: () =>
                            setState(() => _isObscured = !_isObscured),
                        validator: (v) => (v == null || v.length < 6)
                            ? S.of(context).password_error
                            : null,
                      ),

                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            S.of(context).forgot_password,
                            style: TextStyle(
                              color: AppColors.primaryTeal(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _loginAndNavigate();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  S.of(context).login_button,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
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
      child: Icon(
        Icons.fact_check_rounded,
        color: AppColors.primaryTeal(context),
        size: 40,
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required String label,
    required IconData icon,
    TextEditingController? controller,
    bool isPassword = false,
    bool isObscured = false,
    VoidCallback? onSuffixTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: AppColors.textSecondary(context),
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: AppColors.primaryTeal(context), size: 22),
        suffixIcon: isPassword
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(
                  isObscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                ),
              )
            : null,
        filled: true,
        fillColor: AppColors.scaffoldBg(context),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppColors.primaryTeal(context),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
