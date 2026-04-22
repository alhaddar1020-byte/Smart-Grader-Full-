import 'package:flutter/material.dart';
import '../generated/l10n.dart'; // تأكد من استيراد كلاس الترجمة المولد
import 'aboutsystempage.dart';
import 'loginpage.dart';
import '../core/colors.dart';

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
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : (isTablet ? 80 : 150),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: isMobile ? 30 : 60),
                        _buildLogoIcon(context, size: isMobile ? 80 : 130),
                        const SizedBox(height: 30),
                        
                        // العنوان الرئيسي المترجم
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: isMobile ? 32 : (isTablet ? 45 : 64), 
                              fontWeight: FontWeight.bold, 
                              fontFamily: 'Arimo'
                            ),
                            children: [
                              TextSpan(text: S.of(context).systemTitlePrefix, style: const TextStyle(color: Color(0xFF28308C))), 
                              TextSpan(text: S.of(context).systemTitleSuffix, style: TextStyle(color: AppColors.primaryTeal(context))), 
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        Text(
                          S.of(context).heroSubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF6E7881), 
                            fontSize: isMobile ? 15 : 20, 
                            height: 1.6, 
                            fontFamily: 'Arimo'
                          ),
                        ),
                        
                        const SizedBox(height: 50),
                        
                        Wrap(
                          spacing: 30,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildStatCard(context, percentage: "99.9%", label: S.of(context).accuracyLabel, iconData: Icons.check_circle_outline, width: isMobile ? 280 : 220),
                            _buildStatCard(context, percentage: "75%", label: S.of(context).timeSavingLabel, iconData: Icons.bolt, width: isMobile ? 280 : 220),
                          ],
                        ),
                        
                        const SizedBox(height: 60),
                        
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
                              horizontal: isMobile ? 50 : 80, 
                              vertical: 20
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(S.of(context).loginButton, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 10),
                              // الأيقونة تنعكس تلقائياً مع اتجاه اللغة
                              Icon(Icons.adaptive.arrow_forward, size: 22),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        // استخدام MainAxisAlignment.end سيضع العناصر في اليمين بالعربي واليسار بالإنجليزي تلقائياً
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _navItem(context, S.of(context).aboutSystem, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutSystemScreen()));
          }),
          const SizedBox(width: 30),
          _navItem(context, S.of(context).languageLabel, () {
            // هنا تضع وظيفة تغيير اللغة
          }),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.primaryTeal(context),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, {required String percentage, required String label, required IconData iconData, required double width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            // CrossAxisAlignment.end تجعل النصوص محاذاة لليمين في العربي
            // يفضل استخدام AlignmentDirectional بدقة أكبر
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(percentage, style: const TextStyle(color: Color(0xFF28308C), fontSize: 24, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: Color(0xFF6E7881), fontSize: 13)),
            ],
          ),
          const SizedBox(width: 15),
          Icon(iconData, color: AppColors.primaryTeal(context), size: 30),
        ],
      ),
    );
  }

  Widget _buildLogoIcon(BuildContext context, {required double size}) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        color: AppColors.primaryTeal(context), 
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primaryTeal(context).withOpacity(0.3), blurRadius: 15)]
      ),
      child: Icon(Icons.fact_check_outlined, color: Colors.white, size: size * 0.6),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primaryTeal(context),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(S.of(context).copyright,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}