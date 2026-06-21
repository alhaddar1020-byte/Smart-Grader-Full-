import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../generated/l10n.dart'; // استيراد الترجمة

class AboutSystemScreen extends StatelessWidget {
  const AboutSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // نكتشف اتجاه اللغة الحالي
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.secondaryTeal(context),
      body: Stack(
        children: [
          // سهم العودة: PositionedDirectional يتعامل مع اليمين واليسار تلقائياً
          PositionedDirectional(
            top: 50,
            start: 30, // سيبدأ من اليمين في العربي واليسار في الإنجليزي
            child: IconButton(
              // Icons.adaptive.arrow_back يعكس نفسه تلقائياً حسب اللغة
              icon: Icon(
                Icons.adaptive.arrow_back,
                color: AppColors.primaryTeal(context),
                size: 22,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
              child: Column(
                children: [
                  Text(
                    S.of(context).about_title, // العنوان مترجم
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(context),
                      fontFamily: 'Arimo',
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: 40,
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 50),

                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildElegantCard(
                        context,
                        S.of(context).feat_accuracy_title,
                        S.of(context).feat_accuracy_desc,
                        Icons.verified_outlined,
                      ),
                      _buildElegantCard(
                        context,
                        S.of(context).feat_speed_title,
                        S.of(context).feat_speed_desc,
                        Icons.bolt_outlined,
                      ),
                      _buildElegantCard(
                        context,
                        S.of(context).feat_reports_title,
                        S.of(context).feat_reports_desc,
                        Icons.bar_chart_outlined,
                      ),
                      _buildElegantCard(
                        context,
                        S.of(context).feat_collab_title,
                        S.of(context).feat_collab_desc,
                        Icons.group_outlined,
                      ),
                      _buildElegantCard(
                        context,
                        S.of(context).feat_fairness_title,
                        S.of(context).feat_fairness_desc,
                        Icons.auto_awesome_outlined,
                      ),
                      _buildElegantCard(
                        context,
                        S.of(context).feat_integrations_title,
                        S.of(context).feat_integrations_desc,
                        Icons.auto_graph_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElegantCard(
    BuildContext context,
    String title,
    String desc,
    IconData icon,
  ) {
    return Container(
      width: 200,
      height: 230, // 🟢 تم توحيد الارتفاع لجميع المربعات
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryTeal(context).withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primaryTeal(context), size: 32),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
              fontFamily: 'Arimo',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary(context),
              fontFamily: 'Arimo',
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
