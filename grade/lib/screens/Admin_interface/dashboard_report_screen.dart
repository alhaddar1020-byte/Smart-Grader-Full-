import '../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import 'package:grade/generated/l10n.dart';
import 'dashboard_report_provider.dart';
import 'admin_settings_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardReportProvider>().fetchReportsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardReportProvider>(
      builder: (context, provider, child) {
        double width = MediaQuery.of(context).size.width;
        bool isMobile = width < 600;

        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.teal));
        }

        return Scaffold(
          backgroundColor: AppColors.secondaryTeal(context),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopHeader(context, isMobile, provider),
                const SizedBox(height: 32),
                isMobile
                    ? Column(children: [
                        _buildHorizontalCardsGroup(context, provider),
                        const SizedBox(height: 24),
                        _buildOverallPerformance(context, provider),
                      ])
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _buildOverallPerformance(context, provider)),
                          const SizedBox(width: 24),
                          Expanded(flex: 1, child: _buildVerticalCardsGroup(context, provider)),
                        ],
                      ),
                const SizedBox(height: 32),
                isMobile
                    ? Column(children: [
                        _buildSubjectsPerformance(context, provider),
                        const SizedBox(height: 24),
                        _buildSystemUsage(context, provider),
                      ])
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 1, child: _buildSystemUsage(context, provider)),
                          const SizedBox(width: 24),
                          Expanded(flex: 2, child: _buildSubjectsPerformance(context, provider)),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopHeader(BuildContext context, bool isMobile, DashboardReportProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: isMobile
                ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(S.of(context).reports_statistics,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
                    const SizedBox(height: 12),
                    _buildExportButton(context, provider),
                    const SizedBox(height: 12),
                    _buildActiveTermFilter(context, provider),
                  ])
                : Row(children: [
                    Text(S.of(context).reports_statistics,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
                    const SizedBox(width: 24),
                    _buildExportButton(context, provider),
                    const SizedBox(width: 24),
                    _buildActiveTermFilter(context, provider),
                  ]),
          ),
          Row(children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminSettingsScreen(isFullScreen: true)));
              },
              borderRadius: BorderRadius.circular(50),
              child: _buildTopIcon(context: context, icon: Icons.person_outline_rounded),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildActiveTermFilter(BuildContext context, DashboardReportProvider provider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(
          value: provider.filterByActiveTerm,
          onChanged: provider.toggleActiveTermFilter,
          activeColor: AppColors.primaryTeal(context),
        ),
        const SizedBox(width: 8),
        Text(
          S.of(context).active_term_filter,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: provider.filterByActiveTerm ? AppColors.primaryTeal(context) : AppColors.textSecondary(context),
          ),
        ),
      ],
    );
  }

  Widget _buildExportButton(BuildContext context, DashboardReportProvider provider) {
    return ElevatedButton.icon(
      onPressed: provider.isExporting ? null : () => provider.exportPdfFromBackend(context),
      icon: provider.isExporting
          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : const Icon(Icons.picture_as_pdf, color: Colors.white, size: 20),
      label: Text(
        provider.isExporting ? S.of(context).loading_exporting : S.of(context).export_pdf_button,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryTeal(context),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildTopIcon({required BuildContext context, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle),
      child: Icon(Icons.person_outline, color: AppColors.primaryTeal(context)),
    );
  }

  Widget _buildHorizontalCardsGroup(BuildContext context, DashboardReportProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        SizedBox(width: 260, child: _buildStatCard(context,
            title: S.of(context).total_students,
            value: provider.totalStudents.toString(),
            icon: Icons.group, iconColor: AppColors.primaryTeal(context))),
        const SizedBox(width: 16),
        SizedBox(width: 260, child: _buildStatCard(context,
            title: S.of(context).general_average,
            value: '${provider.generalAverage}%',
            icon: Icons.bar_chart, iconColor: AppColors.accentYellow(context))),
        const SizedBox(width: 16),
        SizedBox(width: 260, child: _buildStatCard(context,
            title: S.of(context).active_teachers,
            value: provider.activeTeachers.toString(),
            icon: Icons.person_pin, iconColor: AppColors.primaryTeal(context))),
      ]),
    );
  }

  Widget _buildVerticalCardsGroup(BuildContext context, DashboardReportProvider provider) {
    return Column(children: [
      _buildStatCard(context, title: S.of(context).total_students,
          value: provider.totalStudents.toString(),
          icon: Icons.group, iconColor: AppColors.primaryTeal(context)),
      const SizedBox(height: 16),
      _buildStatCard(context, title: S.of(context).general_average,
          value: '${provider.generalAverage}%',
          icon: Icons.bar_chart, iconColor: AppColors.accentYellow(context)),
      const SizedBox(height: 16),
      _buildStatCard(context, title: S.of(context).active_teachers,
          value: provider.activeTeachers.toString(),
          icon: Icons.person_pin, iconColor: AppColors.primaryTeal(context)),
    ]);
  }

  Widget _buildStatCard(BuildContext context, {required String title, required String value, required IconData icon, required Color iconColor}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FittedBox(fit: BoxFit.scaleDown, child: Text(title, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13, fontWeight: FontWeight.w600))),
          const SizedBox(height: 4),
          FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)))),
        ])),
      ]),
    );
  }

  Widget _buildOverallPerformance(BuildContext context, DashboardReportProvider provider) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      height: isMobile ? 400 : 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(S.of(context).overall_performance_title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
        const SizedBox(height: 32),
        Expanded(
          child: Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            children: [
              Expanded(
                child: PieChart(PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: isMobile ? 40 : 60,
                  sections: [
                    PieChartSectionData(
                      color: AppColors.primaryTeal(context),
                      value: provider.passPercentage,
                      title: '${provider.passPercentage}%',
                      radius: 30,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      color: AppColors.accentYellow(context),
                      value: provider.failPercentage,
                      title: '${provider.failPercentage}%',
                      radius: 30,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
              ),
              if (isMobile) const SizedBox(height: 24),
              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                _buildLegendItem(context, S.of(context).pass_status, AppColors.primaryTeal(context)),
                const SizedBox(height: 16),
                _buildLegendItem(context, S.of(context).fail_status, AppColors.accentYellow(context)),
              ]),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildLegendItem(BuildContext context, String title, Color color) {
    return Row(children: [
      Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 8),
      Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary(context))),
    ]);
  }

  Widget _buildSystemUsage(BuildContext context, DashboardReportProvider provider) {
    return Container(
      height: 420,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(S.of(context).system_usage_title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
        const SizedBox(height: 24),
        Expanded(
          child: provider.teachersUsage.isEmpty
              ? Center(child: Text(S.of(context).error_no_data, style: TextStyle(color: AppColors.textSecondary(context))))
              : ListView(
                  children: provider.teachersUsage.map((t) =>
                    _buildTeacherUsageRow(context, t.rank, t.teacherName, t.progress, t.tasksCount)
                  ).toList(),
                ),
        ),
      ]),
    );
  }

  Widget _buildTeacherUsageRow(BuildContext context, int rank, String name, double progress, int tasks) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(width: 30, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('$rank', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary(context))),
          Icon(Icons.keyboard_arrow_up, color: AppColors.primaryTeal(context), size: 18),
        ])),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary(context), fontSize: 13)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.secondaryTeal(context),
            color: AppColors.primaryTeal(context),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 4),
          Text('$tasks ${S.of(context).task_word}', style: TextStyle(color: AppColors.textSecondary(context), fontSize: 12)),
        ])),
      ]),
    );
  }

  Widget _buildSubjectsPerformance(BuildContext context, DashboardReportProvider provider) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      height: 420,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        isMobile
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(S.of(context).pdf_subjects_performance,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
                const SizedBox(height: 16),
                Row(children: [
                  _buildLegendItem(context, S.of(context).pass_status, AppColors.primaryTeal(context)),
                  const SizedBox(width: 16),
                  _buildLegendItem(context, S.of(context).fail_status, AppColors.accentYellow(context)),
                ]),
              ])
            : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(S.of(context).pdf_subjects_performance,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
                Row(children: [
                  _buildLegendItem(context, S.of(context).pass_status, AppColors.primaryTeal(context)),
                  const SizedBox(width: 16),
                  _buildLegendItem(context, S.of(context).fail_status, AppColors.accentYellow(context)),
                ]),
              ]),
        const SizedBox(height: 32),
        Expanded(
          child: provider.subjectsPerformance.isEmpty
              ? Center(child: Text(S.of(context).error_no_data, style: TextStyle(color: AppColors.textSecondary(context))))
              : ListView(
                  children: provider.subjectsPerformance.map((s) =>
                    _buildSubjectBarItem(context, s.subjectName, s.successRate.toInt(), s.failRate.toInt())
                  ).toList(),
                ),
        ),
      ]),
    );
  }

  Widget _buildSubjectBarItem(BuildContext context, String subjectName, int successRate, int failRate) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(children: [
        SizedBox(width: 100, child: Text(subjectName,
            style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary(context), fontSize: 13))),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 12, clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
            child: Row(children: [
              Expanded(flex: successRate, child: Container(color: AppColors.primaryTeal(context))),
              Expanded(flex: failRate, child: Container(color: AppColors.accentYellow(context))),
            ]),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(width: 40, child: Text('$successRate%',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)))),
      ]),
    );
  }
}