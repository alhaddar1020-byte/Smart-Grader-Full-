import '../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../../core/colors.dart'; 
import 'package:grade/generated/l10n.dart'; 
import 'admin_dashboard_provider.dart'; 
import 'admin_settings_screen.dart'; 
import 'dart:math'; 

class StatData {
  final String title; final String value; final String percentage;
  final IconData icon; final Color iconColor; final Color accentColor;
  StatData({required this.title, required this.value, required this.percentage, required this.icon, required this.iconColor, required this.accentColor});
}

class AlertData {
  final String title; final String subtitle; final String time;
  final IconData icon; final Color iconColor;
  AlertData({required this.title, required this.subtitle, required this.time, required this.icon, required this.iconColor});
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String adminName = ""; 

  @override
  void initState() {
    super.initState();
    _loadAdminName(); 
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminDashboardProvider>().fetchDashboardFilters(); 
    });
  }

  Future<void> _loadAdminName() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return; 
    setState(() {
      adminName = prefs.getString('full_name') ?? S.of(context).system_admin;
    });
  }

  // --- دوال مساعدة لترجمة المفاتيح القادمة من السيرفر ---
  String _translateStatPercentage(String key) {
    if (key == 'KEY_REGISTERED') return S.of(context).registered;
    if (key == 'KEY_ACTIVE_NOW') return S.of(context).active_now;
    if (key.contains('_KEY_GRADED')) return key.replaceAll('_KEY_GRADED', ' ${S.of(context).graded}');
    return key;
  }

  String _translateAlertTitle(String key) {
    if (key == 'KEY_ALERT_BACKUP') return S.of(context).alert_backup_success;
    if (key == 'KEY_ALERT_LOGIN') return S.of(context).alert_new_login;
    if (key == 'KEY_ALERT_IMPORT') return S.of(context).alert_data_import;
    return key;
  }

  String _translateAlertSubtitle(String titleKey, String rawData) {
    if (titleKey == 'KEY_ALERT_BACKUP') return "${S.of(context).completed_on} $rawData";
    if (titleKey == 'KEY_ALERT_LOGIN') return "${S.of(context).system_login_at} $rawData";
    if (titleKey == 'KEY_ALERT_IMPORT') {
      final parts = rawData.split('|');
      if(parts.length == 2) return "${S.of(context).file_name} ${parts[0]} (${parts[1]} ${S.of(context).records})";
    }
    return rawData;
  }

  List<StatData> _getStats(BuildContext context, AdminDashboardProvider provider) {
    return [
      StatData(icon: Icons.school_outlined, iconColor: const Color(0xFF00796B), title: S.of(context).stat_students, value: provider.topStats['total_students']?.toString() ?? '0', percentage: _translateStatPercentage(provider.topStats['students_percentage'] ?? ''), accentColor: const Color(0xFF00ACC1)),
      StatData(icon: Icons.people_outline, iconColor: const Color(0xFFFF9800), title: S.of(context).stat_teachers, value: provider.topStats['total_teachers']?.toString() ?? '0', percentage: _translateStatPercentage(provider.topStats['teachers_percentage'] ?? ''), accentColor: const Color(0xFFFF9800)),
      StatData(icon: Icons.assignment_outlined, iconColor: const Color(0xFF7B1FA2), title: S.of(context).stat_exams, value: provider.topStats['total_exams']?.toString() ?? '0', percentage: _translateStatPercentage(provider.topStats['exams_percentage'] ?? ''), accentColor: const Color(0xFF7B1FA2)),
      StatData(icon: Icons.show_chart, iconColor: const Color(0xFFE65100), title: S.of(context).stat_active_users, value: provider.topStats['active_users']?.toString() ?? '0', percentage: _translateStatPercentage(provider.topStats['active_users_percentage'] ?? ''), accentColor: const Color(0xFFE65100)),
    ];
  }

  List<AlertData> _getAlerts(AdminDashboardProvider provider) {
    return provider.alertsData.map((alert) {
      IconData icon = Icons.info; Color color = Colors.grey;
      if (alert['icon_type'] == 'security') { icon = Icons.security; color = Colors.orange; } 
      else if (alert['icon_type'] == 'backup') { icon = Icons.backup; color = Colors.green; } 
      else if (alert['icon_type'] == 'storage') { icon = Icons.storage; color = Colors.blue; }
      else if (alert['icon_type'] == 'import') { icon = Icons.cloud_upload; color = Colors.purple; }
      
      return AlertData(
        title: _translateAlertTitle(alert['title'] ?? ''), 
        subtitle: _translateAlertSubtitle(alert['title'] ?? '', alert['subtitle'] ?? ''), 
        time: alert['time_ago'] == 'KEY_RECENTLY' ? S.of(context).recently : alert['time_ago'], 
        icon: icon, 
        iconColor: color
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminDashboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Scaffold(backgroundColor: AppColors.secondaryTeal(context), body: const Center(child: CircularProgressIndicator(color: Colors.teal)));
        }

        if (provider.errorMessage.isNotEmpty) {
          return Scaffold(
            backgroundColor: AppColors.secondaryTeal(context),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0), child: Text(provider.errorMessage, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center)),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () => provider.fetchDashboardFilters(), style: ElevatedButton.styleFrom(backgroundColor: Colors.teal), child: Text(S.of(context).retry_button, style: const TextStyle(color: Colors.white)))
                ],
              ),
            ),
          );
        }

        double width = MediaQuery.of(context).size.width;
        bool isMobile = width < 600;
        bool isTablet = width >= 600 && width < 1280;
        bool isDesktop = width >= 1280;

        final stats = _getStats(context, provider);
        final alerts = _getAlerts(provider);

        return Scaffold(
          backgroundColor: AppColors.secondaryTeal(context),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
            child: Column(children: [
              _buildHeader(isMobile, context),
              const SizedBox(height: 16),
              _buildFiltersRow(context, provider),
              const SizedBox(height: 24),
              _buildStatsCardsRow(isMobile, isTablet, stats, context),
              const SizedBox(height: 24),
              if (isDesktop)
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(flex: 7, child: Column(children: [_buildSystemUsageChartContainer(context, provider), const SizedBox(height: 24), _buildThreeBottomCardsRow(isMobile, isDesktop, context, provider)])),
                  const SizedBox(width: 24),
                  Expanded(flex: 3, child: _buildAlertsSection(alerts, isDesktop, context)),
                ])
              else
                Column(children: [_buildSystemUsageChartContainer(context, provider), const SizedBox(height: 24), _buildAlertsSection(alerts, isDesktop, context), const SizedBox(height: 24), _buildThreeBottomCardsRow(isMobile, isDesktop, context, provider)]),
            ]),
          ),
        );
      },
    );
  }

  // --- دوال بناء الواجهة (Helper Widgets) ---
  Widget _buildHeader(bool isMobile, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(color: AppColors.cardBg(context), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(child: Text(S.of(context).welcome_admin(adminName), style: TextStyle(fontSize: isMobile ? 20 : 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)), overflow: TextOverflow.ellipsis)),
        InkWell(onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminSettingsScreen(isFullScreen: true))); }, borderRadius: BorderRadius.circular(50), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle), child: Icon(Icons.person_outline, color: AppColors.primaryTeal(context)))),
      ]),
    );
  }

  Widget _buildFiltersRow(BuildContext context, AdminDashboardProvider provider) {
    String? safeYear = provider.dynamicYearsList.contains(provider.selectedYear) ? provider.selectedYear : provider.dynamicYearsList.first;
    String? safeSemester = provider.dynamicSemestersList.any((s) => s['id'].toString() == provider.selectedSemesterId) ? provider.selectedSemesterId : provider.dynamicSemestersList.first['id'].toString();

    return Row(children: [
        Tooltip(message: S.of(context).refresh_filters_data, child: InkWell(onTap: () => provider.fetchDashboardFilters(), borderRadius: BorderRadius.circular(12), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.refresh, color: Colors.teal, size: 22)))),
        const SizedBox(width: 12),
        Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.teal.withValues(alpha: 0.1))), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: safeYear, isExpanded: true, items: provider.dynamicYearsList.map((String y) => DropdownMenuItem(value: y, child: Text(y == "ALL_YEARS" ? S.of(context).all_text : y))).toList(), onChanged: (val) => provider.updateFilters(val, null))))),
        const SizedBox(width: 12),
        Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.teal.withValues(alpha: 0.1))), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: safeSemester, isExpanded: true, items: provider.dynamicSemestersList.map((s) => DropdownMenuItem(value: s['id'].toString(), child: Text(s['name'] == 'ALL_SYSTEM' ? S.of(context).total_system_all : (s['name'] == 'ALL_SEMESTERS' ? S.of(context).all_semesters_of_year(safeYear) : s['name'].toString())))).toList(), onChanged: (val) => provider.updateFilters(null, val))))),
    ]);
  }

  Widget _buildStatsCardsRow(bool isMobile, bool isTablet, List<StatData> stats, BuildContext context) {
    if (isMobile) return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: stats.map((stat) => Padding(padding: EdgeInsetsDirectional.only(end: stat == stats.last ? 0 : 16.0), child: SizedBox(width: 260, child: _buildSingleStatCard(stat, context)))).toList()));
    if (isTablet) return Column(children: [Row(children: [Expanded(child: _buildSingleStatCard(stats[0], context)), const SizedBox(width: 16), Expanded(child: _buildSingleStatCard(stats[1], context))]), const SizedBox(height: 16), Row(children: [Expanded(child: _buildSingleStatCard(stats[2], context)), const SizedBox(width: 16), Expanded(child: _buildSingleStatCard(stats[3], context))])]);
    return Row(children: stats.map((stat) => Expanded(child: Padding(padding: EdgeInsetsDirectional.only(start: stat == stats.first ? 0 : 16.0), child: _buildSingleStatCard(stat, context)))).toList());
  }

  Widget _buildSingleStatCard(StatData stat, BuildContext context) {
    return Stack(children: [
        Container(height: 140, padding: const EdgeInsets.only(top: 8), decoration: BoxDecoration(color: stat.iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16))),
        Container(margin: const EdgeInsets.only(top: 12), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.cardBg(context), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: stat.iconColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)), child: Icon(stat.icon, color: stat.iconColor, size: 24)), Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text(stat.title, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13, fontWeight: FontWeight.bold))))]), const SizedBox(height: 16), Text(stat.value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)), overflow: TextOverflow.ellipsis), const SizedBox(height: 8), FittedBox(fit: BoxFit.scaleDown, child: Text(stat.percentage, style: TextStyle(color: AppColors.primaryTeal(context), fontSize: 12, fontWeight: FontWeight.bold)))])),
        PositionedDirectional(top: 0, end: 16, start: 16, child: Container(height: 12, decoration: BoxDecoration(color: stat.accentColor, borderRadius: BorderRadius.circular(16)))),
    ]);
  }

  Widget _buildSystemUsageChartContainer(BuildContext context, AdminDashboardProvider provider) {
    return Container(
      height: 350, padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.cardBg(context), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(S.of(context).system_usage_rate, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
        Text(S.of(context).weekly_usage_percentage, style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context))),
        const SizedBox(height: 24),
        Expanded(child: _buildUsageChart(context, provider)),
      ]),
    );
  }

  Widget _buildUsageChart(BuildContext context, AdminDashboardProvider provider) {
    List<FlSpot> spots = provider.chartData.isEmpty 
        ? [const FlSpot(0, 0)] 
        : List.generate(provider.chartData.length, (i) => FlSpot(i.toDouble(), provider.chartData[i]));
    
    double maxChartValue = provider.chartData.isNotEmpty ? provider.chartData.reduce(max) : 10;
    double yMax = maxChartValue > 0 ? maxChartValue + (maxChartValue * 0.2) : 10;
    double yInterval = maxChartValue > 5 ? (maxChartValue / 5).ceilToDouble() : 1.0;

    return LineChart(LineChartData(
      gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: yInterval, getDrawingHorizontalLine: (value) => FlLine(color: AppColors.textSecondary(context).withValues(alpha: 0.1), strokeWidth: 1)),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true, reservedSize: 30, interval: 1,
            getTitlesWidget: (value, meta) {
              final style = TextStyle(color: AppColors.textSecondary(context), fontSize: 10);
              switch (value.toInt()) {
                case 6: return SideTitleWidget(meta: meta, child: Text(S.of(context).today, style: style)); // 👈 مفتاح ترجمة
                case 5: return SideTitleWidget(meta: meta, child: Text(S.of(context).yesterday, style: style)); // 👈 مفتاح ترجمة
                case 4: return SideTitleWidget(meta: meta, child: Text("-2", style: style));
                case 3: return SideTitleWidget(meta: meta, child: Text("-3", style: style));
                case 2: return SideTitleWidget(meta: meta, child: Text("-4", style: style));
                case 1: return SideTitleWidget(meta: meta, child: Text("-5", style: style));
                case 0: return SideTitleWidget(meta: meta, child: Text("-6", style: style));
                default: return SideTitleWidget(meta: meta, child: const Text(''));
              }
            }
          )
        ),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: yInterval, reservedSize: 42, getTitlesWidget: (value, meta) => Text('${value.toInt()}', style: TextStyle(color: AppColors.textSecondary(context), fontSize: 12))))),
      borderData: FlBorderData(show: false), 
      minX: 0, 
      maxX: 6, 
      minY: 0, 
      maxY: yMax,
      lineBarsData: [LineChartBarData(spots: spots, isCurved: true, color: AppColors.primaryTeal(context), barWidth: 4, isStrokeCapRound: true, dotData: const FlDotData(show: false), belowBarData: BarAreaData(show: true, color: AppColors.primaryTeal(context).withValues(alpha: 0.15)))]
    ));
  }

  Widget _buildThreeBottomCardsRow(bool isMobile, bool isDesktop, BuildContext context, AdminDashboardProvider provider) {
    double examsRateValue = ((provider.performanceStats['exams_completion_rate'] ?? 0) / 100).toDouble();
    double successRateValue = ((provider.performanceStats['success_rate'] ?? 0) / 100).toDouble();
    double avgScoreValue = ((provider.performanceStats['average_score'] ?? 0) / 100).toDouble();
    return isDesktop ? Row(children: [Expanded(child: _buildBottomStatCard(S.of(context).exams_count, '${provider.performanceStats['exams_completion_rate'] ?? 0}%', examsRateValue, AppColors.accentYellow(context), context)), const SizedBox(width: 16), Expanded(child: _buildBottomStatCard(S.of(context).success_rate, '${provider.performanceStats['success_rate'] ?? 0}%', successRateValue, AppColors.primaryTeal(context), context)), const SizedBox(width: 16), Expanded(child: _buildBottomStatCard(S.of(context).average_score, '${provider.performanceStats['average_score'] ?? 0}%', avgScoreValue, const Color(0xFF7B1FA2), context))]) : SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [SizedBox(width: 250, child: _buildBottomStatCard(S.of(context).exams_count, '${provider.performanceStats['exams_completion_rate'] ?? 0}%', examsRateValue, AppColors.accentYellow(context), context)), const SizedBox(width: 16), SizedBox(width: 250, child: _buildBottomStatCard(S.of(context).success_rate, '${provider.performanceStats['success_rate'] ?? 0}%', successRateValue, AppColors.primaryTeal(context), context)), const SizedBox(width: 16), SizedBox(width: 250, child: _buildBottomStatCard(S.of(context).average_score, '${provider.performanceStats['average_score'] ?? 0}%', avgScoreValue, const Color(0xFF7B1FA2), context))]));
  }

  Widget _buildBottomStatCard(String title, String valueStr, double percentage, Color barColor, BuildContext context) {
    return Container(height: 140, padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16), decoration: BoxDecoration(color: AppColors.cardBg(context), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(title, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text(valueStr, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))), const SizedBox(height: 12), ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: percentage.clamp(0.0, 1.0), backgroundColor: barColor.withValues(alpha: 0.2), valueColor: AlwaysStoppedAnimation<Color>(barColor), minHeight: 6))]));
  }

  Widget _buildAlertsSection(List<AlertData> alerts, bool isDesktop, BuildContext context) {
    Widget listContent = ListView.separated(shrinkWrap: true, physics: const BouncingScrollPhysics(), itemCount: alerts.length, separatorBuilder: (context, index) => const Divider(height: 20, color: Colors.transparent), itemBuilder: (context, index) { final alert = alerts[index]; return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: alert.iconColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)), child: Icon(alert.icon, color: alert.iconColor, size: 20)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(alert.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary(context))), const SizedBox(height: 4), Text(alert.subtitle, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 12, height: 1.4))])), Text(alert.time, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 10))]); });
    return Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: AppColors.cardBg(context), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(S.of(context).administrative_alerts, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))), const SizedBox(height: 24), alerts.isEmpty ? Padding(padding: const EdgeInsets.symmetric(vertical: 20.0), child: Center(child: Text(S.of(context).no_live_alerts))) : isDesktop ? SizedBox(height: 350, child: listContent) : listContent]));
  }
}