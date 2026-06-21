import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/locale_provider.dart';
import '../generated/l10n.dart'; // تأكد من استيراد كلاس الترجمة المولد
import 'aboutsystempage.dart';
import 'loginpage.dart';
import 'register_pages.dart'; // تم استيراد واجهة إدخال البريد الإلكتروني الجديدة هنا
import '../core/colors.dart';
import '../core/theme_provider.dart';

class SmartCorrectorUI extends StatelessWidget {
  const SmartCorrectorUI({super.key});

  @override
  Widget build(BuildContext context) {
    // نعتمد على نظام الـ Localization الخاص بالتطبيق بدلاً من تثبيته يدوياً
    return Scaffold(
      backgroundColor: AppColors.secondaryTeal(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            bool isMobile = width < 600;
            bool isTablet = width >= 600 && width < 1024;

            return Column(
              children: [
                _buildHeader(context, isMobile, isTablet),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 15 : (isTablet ? 60 : 120),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 1),
                        _buildLogoIcon(context, size: isMobile ? 80 : (isTablet ? 110 : 130)),
                        SizedBox(height: isMobile ? 15 : 25),
                        
                        // العنوان الرئيسي المترجم
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: isMobile ? 26 : (isTablet ? 40 : 54), 
                              fontWeight: FontWeight.bold, 
                              fontFamily: 'Arimo'
                            ),
                            children: [
                              TextSpan(text: S.of(context).systemTitlePrefix, style: TextStyle(color: AppColors.textPrimary(context))), 
                              TextSpan(text: S.of(context).systemTitleSuffix, style: TextStyle(color: AppColors.primaryTeal(context))), 
                            ],
                          ),
                        ),
                        
                        SizedBox(height: isMobile ? 10 : 20),
                        Text(
                          S.of(context).heroSubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary(context), 
                            fontSize: isMobile ? 13 : (isTablet ? 16 : 18), 
                            height: 1.5, 
                            fontFamily: 'Arimo'
                          ),
                        ),
                        
                        SizedBox(height: isMobile ? 20 : 40),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStatCard(context, percentage: "99.9%", label: S.of(context).accuracyLabel, iconData: Icons.check_circle_outline, width: isMobile ? 160 : 220, isMobile: isMobile),
                            SizedBox(width: isMobile ? 10 : 30),
                            _buildStatCard(context, percentage: "75%", label: S.of(context).timeSavingLabel, iconData: Icons.bolt, width: isMobile ? 160 : 220, isMobile: isMobile),
                          ],
                        ),
                        
                        SizedBox(height: isMobile ? 25 : 50),
                        
                        // أزرار التحكم (تسجيل الدخول ومستخدم جديد)
                        Wrap(
                          spacing: 15, // المسافة الأفقية بين الزرين
                          runSpacing: 10, // المسافة الرأسية
                          alignment: WrapAlignment.center,
                          children: [
                            // زر تسجيل الدخول الأساسي
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryTeal(context),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 30 : 50, 
                                  vertical: isMobile ? 15 : 20
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(S.of(context).loginButton, style: TextStyle(fontSize: isMobile ? 16 : 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  Icon(Icons.adaptive.arrow_forward, size: isMobile ? 18 : 22),
                                ],
                              ),
                            ),

                            // زر مستخدم جديد
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const RegisterEmailScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryTeal(context),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 30 : 50, 
                                  vertical: isMobile ? 15 : 20
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(S.of(context).registerButton, style: TextStyle(fontSize: isMobile ? 16 : 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  Icon(Icons.person_add_outlined, size: isMobile ? 18 : 22), 
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                ),
                _buildFooter(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile, bool isTablet) {
    // قراءة القيم خارج الكول باك لتفادي الأخطاء عند فتح القائمة
    final currentLang = context.watch<LocaleProvider>().locale.languageCode;
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 20, vertical: isMobile ? 10 : 20),
      child: Row(
        children: [
          const Spacer(), // يدفع القائمة لليسار/اليمين
          // قائمة النظام واللغة
          PopupMenuButton<int>(
            icon: Icon(Icons.menu, color: AppColors.primaryTeal(context), size: isMobile ? 26 : 30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            tooltip: 'القائمة',
            onSelected: (value) {
              if (value == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutSystemScreen()));
              }
            },
            itemBuilder: (context) => [
              // 1. عن النظام
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primaryTeal(context), size: 22),
                    const SizedBox(width: 10),
                    Text(
                      S.of(context).aboutSystem,
                      style: TextStyle(
                        color: AppColors.primaryTeal(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              // 2. خيار اللغة مع Dropdown
              PopupMenuItem(
                enabled: false, // كي لا تغلق القائمة عند الضغط خارج الـ Dropdown
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.language, color: AppColors.primaryTeal(context), size: 22),
                        const SizedBox(width: 10),
                        Text(
                          S.of(context).language_label,
                          style: TextStyle(
                            color: AppColors.primaryTeal(context),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    DropdownButton<String>(
                      value: currentLang,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      style: TextStyle(
                        color: AppColors.textPrimary(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      items: [
                        DropdownMenuItem(value: 'ar', child: Text(S.of(context).lang_ar)),
                        DropdownMenuItem(value: 'en', child: Text(S.of(context).lang_en)),
                      ],
                      onChanged: (String? newLang) async {
                        if (newLang != null) {
                          final localeProvider = context.read<LocaleProvider>();
                          localeProvider.setInitialLocale(newLang);
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('language_code', newLang);
                          await prefs.setBool('visitor_preferences_changed', true);
                          if (context.mounted) Navigator.pop(context); // إغلاق القائمة بعد اختيار اللغة
                        }
                      },
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              // 3. خيار المظهر مع Dropdown
              PopupMenuItem(
                enabled: false, 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: AppColors.primaryTeal(context), size: 22),
                        const SizedBox(width: 10),
                        Text(
                          S.of(context).theme_label,
                          style: TextStyle(
                            color: AppColors.primaryTeal(context),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    DropdownButton<bool>(
                      value: isDark,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      style: TextStyle(
                        color: AppColors.textPrimary(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      items: [
                        DropdownMenuItem(value: false, child: Text(S.of(context).theme_light)),
                        DropdownMenuItem(value: true, child: Text(S.of(context).theme_dark)),
                      ],
                      onChanged: (bool? isDarkValue) async {
                        if (isDarkValue != null) {
                          context.read<ThemeProvider>().toggleTheme(isDarkValue, 0);
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('visitor_preferences_changed', true);
                          if (context.mounted) Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, {required String percentage, required String label, required IconData iconData, required double width, required bool isMobile}) {
    return Container(
      width: width,
      padding: EdgeInsets.all(isMobile ? 15 : 25),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(isMobile ? 15 : 20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(percentage, style: TextStyle(color: AppColors.textPrimary(context), fontSize: isMobile ? 18 : 24, fontWeight: FontWeight.bold)),
                Text(label, style: TextStyle(color: AppColors.textSecondary(context), fontSize: isMobile ? 11 : 13), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          SizedBox(width: isMobile ? 5 : 15),
          Icon(iconData, color: AppColors.primaryTeal(context), size: isMobile ? 24 : 30),
        ],
      ),
    );
  }

  Widget _buildLogoIcon(BuildContext context, {required double size}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryTeal(context),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(15),
      child: Image.asset(
        'assets/emaige/logo.PNG',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }

  bool isMobileLogoCheck(double size) {
    return size <= 80;
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primaryTeal(context),
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Center(
        child: Text(S.of(context).copyright,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}