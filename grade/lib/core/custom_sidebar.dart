import 'package:flutter/material.dart';
import '../core/colors.dart'; // تأكدي من مسار الألوان الصحيح
import 'package:grade/generated/l10n.dart'; // استدعاء القاموس للترجمة

class CustSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool isTablet;
  final bool isMobile;

  const CustSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.isTablet = false,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    // قراءة اتجاه لغة التطبيق لقلب الواجهة تلقائياً
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    double sidebarWidth = isTablet ? 220 : 280;

    return Container(
      width: sidebarWidth,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryTeal(context),
        // الحواف الدائرية الذكية (ستكون على اليسار في العربي، وعلى اليمين في الإنجليزي)
        borderRadius: isMobile 
            ? BorderRadius.zero 
            : const BorderRadiusDirectional.only(
                topEnd: Radius.circular(55),
                bottomEnd: Radius.circular(55),
              ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Icon(
            Icons.check_circle_outline,
            size: isTablet ? 50 : 70, 
            color: AppColors.textWhite(context),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context).app_name, 
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textWhite(context), 
              fontSize: isTablet ? 14 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50),
          
          // أزرار القائمة (ربطناها بالقاموس لتدعم اللغتين)
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _menuItem(context, S.of(context).dashboard, Icons.home_rounded, 0, isRtl),
                _menuItem(context, S.of(context).users_management, Icons.people, 1, isRtl),
                _menuItem(context, S.of(context).grades_management, Icons.assessment, 2, isRtl),
                _menuItem(context, S.of(context).system_logs, Icons.history, 3, isRtl),
                _menuItem(context, S.of(context).backup, Icons.backup, 4, isRtl),
                _menuItem(context, S.of(context).settings, Icons.settings_rounded, 5, isRtl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // تصميم زر التنقل (أم منحنى الديناميكية)
  // ===========================================================================
  Widget _menuItem(BuildContext context, String title, IconData icon, int index, bool isRtl) {
    bool isActive = selectedIndex == index; 
    Color activeBgColor = AppColors.scaffoldBg(context); 
    double radius = 30.0; // حجم المنحنى

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () {
          if (isMobile) Navigator.pop(context); 
          onItemSelected(index); 
        },
        hoverColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // رسم المنحنى (القصة) إذا كان الزر فعال
            // استخدمنا PositionedDirectional ليرمي القصة يمين أو يسار تلقائياً
            if (isActive)
              PositionedDirectional(
                top: -radius,
                bottom: -radius,
                end: 0,
                width: radius,
                child: CustomPaint(
                  painter: SidebarCurvePainter(activeBgColor, isRtl, radius),
                ),
              ),
            
            // محتوى الزر نفسه (الحواف والمسافات مرنة Directional)
            Container(
              height: 60,
              margin: EdgeInsetsDirectional.only(
                start: isActive ? 20 : 25, 
                end: isActive ? 0 : 20
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isActive ? activeBgColor : Colors.transparent,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: const Radius.circular(30),
                  bottomStart: const Radius.circular(30),
                  topEnd: Radius.circular(isActive ? 0 : 30),
                  bottomEnd: Radius.circular(isActive ? 0 : 30),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    icon, 
                    color: isActive ? AppColors.primaryTeal(context) : AppColors.accentYellow(context), 
                    size: isTablet ? 22 : 26
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: "Arimo", 
                        color: isActive ? AppColors.primaryTeal(context) : Colors.white,
                        fontSize: isTablet ? 15 : 18, 
                        fontWeight: FontWeight.w900,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// رسّام المنحنى (Curve Painter) الذكي للـ LTR و RTL
// ===========================================================================
class SidebarCurvePainter extends CustomPainter {
  final Color bgColor;
  final bool isRtl;
  final double radius;

  SidebarCurvePainter(this.bgColor, this.isRtl, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;
      
    Path path = Path();
    
    if (isRtl) {
      // رسم المنحنى للغة العربية (القصة تكون على اليسار جهة المحتوى)
      path.moveTo(0, 0);
      path.quadraticBezierTo(0, radius, radius, radius);
      path.lineTo(0, radius);
      path.close();
      
      path.moveTo(0, size.height);
      path.quadraticBezierTo(0, size.height - radius, radius, size.height - radius);
      path.lineTo(0, size.height - radius);
      path.close();
    } else {
      // رسم المنحنى للغة الإنجليزية (القصة تكون على اليمين جهة المحتوى)
      path.moveTo(size.width, 0);
      path.quadraticBezierTo(size.width, radius, size.width - radius, radius);
      path.lineTo(size.width, radius);
      path.close();
      
      path.moveTo(size.width, size.height);
      path.quadraticBezierTo(size.width, size.height - radius, size.width - radius, size.height - radius);
      path.lineTo(size.width, size.height - radius);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}