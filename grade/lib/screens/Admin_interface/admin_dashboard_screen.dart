import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/colors.dart'; 
import 'package:grade/generated/l10n.dart'; 

// ===========================================================================
// 1. نماذج البيانات 
// ===========================================================================
class StatData {
  final String title;
  final String value;
  final String percentage;
  final bool isPositive;
  final IconData icon;
  final Color iconColor;
  final Color accentColor;

  StatData({
    required this.title,
    required this.value,
    required this.percentage,
    this.isPositive = true,
    required this.icon,
    required this.iconColor,
    required this.accentColor,
  });
}

class AlertData {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;

  AlertData({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
  });
}

class DummyPage extends StatelessWidget {
  final String title;
  const DummyPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title, style: const TextStyle(color: Colors.white)), backgroundColor: AppColors.primaryTeal(context)),
      body: Center(child: Text(title, style: const TextStyle(fontSize: 24))),
    );
  }
}

// ===========================================================================
// 2. الشاشة الرئيسية (لوحة التحكم) 
// ===========================================================================
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {

  List<StatData> _getStats(BuildContext context) {
    return [
      StatData(
        icon: Icons.school_outlined,
        iconColor: const Color(0xFF00796B),
        title: S.of(context).stat_students,
        value: '2,847',
        percentage: S.of(context).stat_students_desc,
        accentColor: const Color(0xFF00ACC1),
      ),
      StatData(
        icon: Icons.people_outline,
        iconColor: const Color(0xFFFF9800),
        title: S.of(context).stat_teachers,
        value: '156',
        percentage: S.of(context).stat_teachers_desc,
        accentColor: const Color(0xFFFF9800),
      ),
      StatData(
        icon: Icons.assignment_outlined,
        iconColor: const Color(0xFF7B1FA2),
        title: S.of(context).stat_exams,
        value: '1,429',
        percentage: S.of(context).stat_exams_desc,
        accentColor: const Color(0xFF7B1FA2),
      ),
      StatData(
        icon: Icons.show_chart,
        iconColor: const Color(0xFFE65100),
        title: S.of(context).stat_active_users,
        value: '892',
        percentage: S.of(context).stat_active_users_desc,
        accentColor: const Color(0xFFE65100),
      ),
    ];
  }

  List<AlertData> _getAlerts(BuildContext context) {
    return [
      AlertData(
        title: S.of(context).alert_login_failed,
        subtitle: S.of(context).alert_login_failed_desc,
        time: S.of(context).alert_time_5m,
        icon: Icons.security,
        iconColor: Colors.orange,
      ),
      AlertData(
        title: S.of(context).alert_storage_low,
        subtitle: S.of(context).alert_storage_low_desc,
        time: S.of(context).alert_time_15m,
        icon: Icons.storage,
        iconColor: Colors.blue,
      ),
      AlertData(
        title: S.of(context).alert_backup_success,
        subtitle: S.of(context).alert_backup_success_desc,
        time: S.of(context).alert_time_1h,
        icon: Icons.backup,
        iconColor: Colors.green,
      ),
      // مكررة لتجربة التمرير الداخلي براحة
      AlertData(
        title: S.of(context).alert_storage_low,
        subtitle: S.of(context).alert_storage_low_desc,
        time: S.of(context).alert_time_15m,
        icon: Icons.storage,
        iconColor: Colors.blue,
      ),
      AlertData(
        title: S.of(context).alert_backup_success,
        subtitle: S.of(context).alert_backup_success_desc,
        time: S.of(context).alert_time_1h,
        icon: Icons.backup,
        iconColor: Colors.green,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 600;
    bool isTablet = width >= 600 && width < 1280;
    bool isDesktop = width >= 1280;

    final stats = _getStats(context);
    final alerts = _getAlerts(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
        child: Column(
          children: [
            _buildHeader(isMobile),
            const SizedBox(height: 24),
            
            _buildStatsCardsRow(isMobile, isTablet, stats),
            const SizedBox(height: 24),
            
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7, 
                    child: Column(
                      children: [
                        _buildSystemUsageChartContainer(), // 350px
                        const SizedBox(height: 24),        // 24px
                        _buildThreeBottomCardsRow(isMobile, isDesktop), // 140px
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // هنا نعطي التنبيهات نفس طول اليسار בדיبط! (350+24+140 = 514)
                  Expanded(flex: 3, child: _buildAlertsSection(alerts, isDesktop)),
                ],
              )
            else
              Column(
                children: [
                  _buildSystemUsageChartContainer(),
                  const SizedBox(height: 24),
                  _buildAlertsSection(alerts, isDesktop),
                  const SizedBox(height: 24),
                  _buildThreeBottomCardsRow(isMobile, isDesktop),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // المكونات (Widgets)
  // ===========================================================================

  Widget _buildHeader(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context), 
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              S.of(context).welcome_user, 
              style: TextStyle(
                fontSize: isMobile ? 20 : 24, 
                fontWeight: FontWeight.bold, 
                color: AppColors.textPrimary(context)
              ),
              overflow: TextOverflow.ellipsis,
            )
          ),
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DummyPage(title: S.of(context).notifications))),
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.scaffoldBg(context), shape: BoxShape.circle),
                  child: Icon(Icons.notifications_none, color: AppColors.primaryTeal(context)),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DummyPage(title: S.of(context).profile))),
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.scaffoldBg(context), shape: BoxShape.circle),
                  child: Icon(Icons.person_outline, color: AppColors.primaryTeal(context)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCardsRow(bool isMobile, bool isTablet, List<StatData> stats) {
    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: stats.map((stat) => Padding(
            padding: EdgeInsetsDirectional.only(end: stat == stats.last ? 0 : 16.0),
            child: SizedBox(width: 260, child: _buildSingleStatCard(stat)),
          )).toList(),
        ),
      );
    } else if (isTablet) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildSingleStatCard(stats[0])),
              const SizedBox(width: 16),
              Expanded(child: _buildSingleStatCard(stats[1])),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildSingleStatCard(stats[2])),
              const SizedBox(width: 16),
              Expanded(child: _buildSingleStatCard(stats[3])),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: stats.map((stat) => Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: stat == stats.first ? 0 : 16.0),
            child: _buildSingleStatCard(stat),
          ),
        )).toList(),
      );
    }
  }

  Widget _buildSingleStatCard(StatData stat) {
    return Stack(
      children: [
        Container(
          height: 140,
          padding: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: AppColors.accentYellow(context),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.textWhite(context),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: stat.iconColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                    child: Icon(stat.icon, color: stat.iconColor, size: 24),
                  ),
                  FittedBox(fit: BoxFit.scaleDown, child: Text(stat.title, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13, fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 16),
              Text(stat.value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown, 
                child: Text(stat.percentage, style: TextStyle(color: stat.title.contains('المعلمين') ? AppColors.textSecondary(context) : AppColors.primaryTeal(context), fontSize: 11, fontWeight: FontWeight.bold))
              ),
            ],
          ),
        ),
        PositionedDirectional(
          top: 0, end: 16, start: 16,
          child: Container(
            height: 12,
            decoration: BoxDecoration(color: stat.accentColor, borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemUsageChartContainer() {
    return Container(
      height: 350, 
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context), 
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).system_usage_rate, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
          Text(S.of(context).weekly_usage_desc, style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context))),
          const SizedBox(height: 24),
          Expanded(child: _buildUsageChart()),
        ],
      ),
    );
  }

  Widget _buildUsageChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: AppColors.textSecondary(context).withOpacity(0.1), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final style = TextStyle(color: AppColors.textSecondary(context), fontSize: 12);
                Widget text;
                switch (value.toInt()) {
                  case 0: text = Text(S.of(context).month_1, style: style); break;
                  case 2: text = Text(S.of(context).month_2, style: style); break;
                  case 4: text = Text(S.of(context).month_3, style: style); break;
                  case 6: text = Text(S.of(context).current_month, style: style); break;
                  default: text = Text('', style: style); break;
                }
                // return SideTitleWidget(axisSide: meta.axisSide, child: text);
                return SideTitleWidget(meta: meta,  // استبدل axisSide بـ meta
                child: text,
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              reservedSize: 42,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()}%', style: TextStyle(color: AppColors.textSecondary(context), fontSize: 12), textAlign: TextAlign.start);
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0, maxX: 6, minY: 0, maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 30), FlSpot(1, 55), FlSpot(2, 45), FlSpot(3, 75),
              FlSpot(4, 65), FlSpot(5, 85), FlSpot(6, 92),
            ],
            isCurved: true,
            color: AppColors.primaryTeal(context),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primaryTeal(context).withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreeBottomCardsRow(bool isMobile, bool isDesktop) {
    if (isDesktop) {
      return Row(
        children: [
          Expanded(child: _buildBottomStatCard(S.of(context).number_of_exams, '85%', 0.85, AppColors.accentYellow(context))),
          const SizedBox(width: 16),
          Expanded(child: _buildBottomStatCard(S.of(context).success_rate, '92.7%', 0.927, AppColors.primaryTeal(context))),
          const SizedBox(width: 16),
          Expanded(child: _buildBottomStatCard(S.of(context).average_scores, '85.4%', 0.854, const Color(0xFF7B1FA2))),
        ],
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            SizedBox(width: isMobile ? 250 : 300, child: _buildBottomStatCard(S.of(context).number_of_exams, '85%', 0.85, AppColors.accentYellow(context))),
            const SizedBox(width: 16),
            SizedBox(width: isMobile ? 250 : 300, child: _buildBottomStatCard(S.of(context).success_rate, '92.7%', 0.927, AppColors.primaryTeal(context))),
            const SizedBox(width: 16),
            SizedBox(width: isMobile ? 250 : 300, child: _buildBottomStatCard(S.of(context).average_scores, '85.4%', 0.854, const Color(0xFF7B1FA2))),
          ],
        ),
      );
    }
  }

  Widget _buildBottomStatCard(String title, String valueStr, double percentage, Color barColor) {
    return Container(
      height: 140, // ⬅️ قمنا بتثبيت الطول هنا لضمان التناسق الدقيق
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context), 
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(valueStr, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: barColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsSection(List<AlertData> alerts, bool isDesktop) {
    Widget listContent = ListView.separated(
      shrinkWrap: !isDesktop, 
      physics: isDesktop ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
      itemCount: alerts.length,
      separatorBuilder: (context, index) => const Divider(height: 30, color: Colors.transparent),
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: alert.iconColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
              child: Icon(alert.icon, color: alert.iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(alert.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary(context))),
                  const SizedBox(height: 4),
                  Text(alert.subtitle, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 12, height: 1.4)),
                ],
              ),
            ),
            Text(alert.time, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 10)),
          ],
        );
      },
    );

    return Container(
      height: isDesktop ? 514 : null, // ⬅️ قمنا بتثبيت الطول هنا (350+24+140) ليتساوى مع اليسار تماماً
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context), 
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).alerts_log, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DummyPage(title: S.of(context).all_alerts))), 
                child: Text(S.of(context).view_all, style: TextStyle(color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold))
              ),
            ],
          ),
          const SizedBox(height: 16),
          // يتمدد ويسمح بالتمرير الداخلي في الديسكتوب
          isDesktop ? Expanded(child: listContent) : listContent,
        ],
      ),
    );
  }
}