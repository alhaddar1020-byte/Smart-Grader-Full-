import 'package:flutter/material.dart';
import '../core/colors.dart'; // تأكدي من مسار ملف الألوان لديك

//  // 2. استدعاء القائمة الجانبية من الملف الخارجي
//               CustomSidebar(
//                 selectedIndex: selectedIndex,
//                 onItemSelected: (index) {
//                   setState(() {
//                     selectedIndex = index;
//                   });
//                 },
//               ),

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
      decoration: const BoxDecoration(
        color: AppColors.primaryTeal,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(55),
          bottomLeft: Radius.circular(55),
        ),
      ),
      child: Column(
        children: [
          // 1. قسم الشعار والاسم (سهل التعديل)
          _buildLogoSection(
            icon: Icons.check_circle_outline,
            title: "Intelligent\nGrading System",
          ),

          // 2. أزرار القائمة
          _menuItem("لوحة التحكم", Icons.home_rounded, 0),
          _menuItem("المواد", Icons.library_books, 1),
          _menuItem("إعدادات", Icons.settings_rounded, 2),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildLogoSection({required IconData icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 50),
      child: Column(
        children: [
          Icon(icon, size: 70, color: AppColors.textWhite),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(String title, IconData icon, int index) {
    bool isActive = selectedIndex == index;

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
                child: CustomPaint(
                  painter: SidebarCurvePainter(AppColors.scaffoldBg),
                ),
              ),
            Container(
              height: 60,
              margin: EdgeInsets.only(left: isActive ? 0 : 25, right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isActive ? AppColors.scaffoldBg : Colors.transparent,
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
                      color: isActive ? AppColors.primaryTeal : Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Icon(icon, color: AppColors.accentYellow, size: 26),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// كلاس الرسم يبقى هنا لأنه مرتبط بشكل القائمة
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
