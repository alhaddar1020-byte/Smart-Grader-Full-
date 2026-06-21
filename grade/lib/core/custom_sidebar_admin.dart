import 'package:flutter/material.dart';
import '../core/colors.dart';
import 'package:grade/generated/l10n.dart';

class CustomSidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigate;
  final bool isTablet;
  final bool isMobile;

  const CustomSidebar({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
    this.isTablet = false,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    double sidebarWidth = isTablet ? 220 : 280;

    return Container(
      width: sidebarWidth,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryTeal(context),
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
          Image.asset(
            'assets/emaige/logo.PNG',
            height: isTablet ? 70 : 110,
            width: isTablet ? 70 : 110,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 50),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _menuItem(
                  context,
                  S.of(context).dashboard,
                  Icons.home_rounded,
                  0,
                  isRtl,
                ),
                _menuItem(
                  context,
                  S.of(context).users_management,
                  Icons.people,
                  1,
                  isRtl,
                ),
                _menuItem(
                  context,
                  S.of(context).reports_statistics,
                  Icons.insert_chart,
                  2,
                  isRtl,
                ),
                _menuItem(
                  context,
                  S.of(context).system_logs,
                  Icons.history,
                  3,
                  isRtl,
                ),
                _menuItem(
                  context,
                  S.of(context).backup,
                  Icons.backup,
                  4,
                  isRtl,
                ),
                _menuItem(
                  context,
                  S.of(context).settings,
                  Icons.settings_rounded,
                  5,
                  isRtl,
                ),
              ],
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
    bool isRtl,
  ) {
    bool isActive = currentIndex == index;
    Color activeBgColor = AppColors.secondaryTeal(context);
    double radius = 30.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () {
          // ✅ التعديل هنا: حذفنا Navigator.pop عشان ما يسبب إغلاق مزدوج
          onNavigate(index);
        },
        hoverColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
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
            Container(
              height: 60,
              margin: EdgeInsetsDirectional.only(
                start: isActive ? 20 : 25,
                end: isActive ? 0 : 20,
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
                    color: isActive
                        ? AppColors.primaryTeal(context)
                        : AppColors.accentYellow(context),
                    size: isTablet ? 22 : 26,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: "Arimo",
                        color: isActive
                            ? AppColors.primaryTeal(context)
                            : Colors.white,
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
      path.moveTo(0, 0);
      path.quadraticBezierTo(0, radius, radius, radius);
      path.lineTo(0, radius);
      path.close();

      path.moveTo(0, size.height);
      path.quadraticBezierTo(
        0,
        size.height - radius,
        radius,
        size.height - radius,
      );
      path.lineTo(0, size.height - radius);
      path.close();
    } else {
      path.moveTo(size.width, 0);
      path.quadraticBezierTo(size.width, radius, size.width - radius, radius);
      path.lineTo(size.width, radius);
      path.close();

      path.moveTo(size.width, size.height);
      path.quadraticBezierTo(
        size.width,
        size.height - radius,
        size.width - radius,
        size.height - radius,
      );
      path.lineTo(size.width, size.height - radius);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
