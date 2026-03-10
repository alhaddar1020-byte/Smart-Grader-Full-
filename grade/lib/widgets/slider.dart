import 'package:flutter/material.dart';
import '../core/colors.dart';

class CustomSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: double.infinity,
      decoration: BoxDecoration(
        // استخدام اللون الأساسي من كلاس الألوان
        color: AppColors.primaryTeal(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(55),
          bottomLeft: Radius.circular(55),
        ),
      ),
      child: Column(
        children: [
          // 1. قسم الشعار والاسم
          _buildLogoSection(
            context, // تمرير الـ context لاستخدامه في الألوان
            icon: Icons.check_circle_outline,
            title: "Intelligent\nGrading System",
          ),

          // 2. أزرار القائمة
          _menuItem(context, "لوحة التحكم", Icons.home_rounded, 0),
          _menuItem(context, "المواد", Icons.library_books, 1),
          _menuItem(context, "إعدادات", Icons.settings_rounded, 2),
          // يمكنك إزالة التكرار هنا لاحقاً إذا أردت
          _menuItem(context, "التقارير", Icons.analytics_outlined, 3),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildLogoSection(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 50),
      child: Column(
        children: [
          // الأيقونة باللون الأبيض دائماً أو حسب تصميمك
          Icon(icon, size: 70, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white, // النص يبقى أبيض فوق التيل الغامق
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    String title,
    IconData icon,
    int index,
  ) {
    bool isActive = selectedIndex == index;
    // تحديد لون الخلفية النشطة بناءً على الثيم
    Color activeBgColor = AppColors.secondaryTeal(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () => onItemSelected(index),
        hoverColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerLeft,
          children: [
            if (isActive)
              Positioned(
                left: 0,
                top: -40,
                bottom: -40,
                width: 50,
                child: CustomPaint(painter: SidebarCurvePainter(activeBgColor)),
              ),
            Container(
              height: 60,
              margin: EdgeInsets.only(left: isActive ? 0 : 25, right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isActive ? activeBgColor : Colors.transparent,
                borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(30),
                  bottomRight: const Radius.circular(30),
                  topLeft: Radius.circular(isActive ? 0 : 30),
                  bottomLeft: Radius.circular(isActive ? 0 : 30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: "Arimo",
                      // اللون يتغير بناءً على حالة الزر (نشط أم لا)
                      color: isActive
                          ? AppColors.primaryTeal(context)
                          : Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Icon(
                    icon,
                    color: AppColors.accentYellow(
                      context,
                    ), // لون الأيقونة ديناميكي
                    size: 26,
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

class SidebarCurvePainter extends CustomPainter {
  final Color bgColor;
  SidebarCurvePainter(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;

    double radius = 35;
    double topY = 40;
    double bottomY = topY + 60;

    Path pathTop = Path();
    pathTop.moveTo(0, topY - radius);
    pathTop.quadraticBezierTo(0, topY, radius, topY);
    pathTop.lineTo(0, topY);
    pathTop.close();
    canvas.drawPath(pathTop, paint);

    Path pathBottom = Path();
    pathBottom.moveTo(0, bottomY + radius);
    pathBottom.quadraticBezierTo(0, bottomY, radius, bottomY);
    pathBottom.lineTo(0, bottomY);
    pathBottom.close();
    canvas.drawPath(pathBottom, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
