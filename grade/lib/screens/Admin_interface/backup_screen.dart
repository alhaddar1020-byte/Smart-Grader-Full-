import '../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import 'package:grade/generated/l10n.dart';
import 'backup_provider.dart';
import 'admin_settings_screen.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BackupProvider>().fetchPageData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BackupProvider>(
      builder: (context, provider, _) {
        double width = MediaQuery.of(context).size.width;
        bool isMobile = width < 600;
        bool isDesktop = width >= 1280;

        if (provider.isLoading) {
          return Scaffold(backgroundColor: AppColors.secondaryTeal(context),
            body: Center(child: CircularProgressIndicator(color: Colors.teal)),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.secondaryTeal(context),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopHeader(isMobile, provider),
                const SizedBox(height: 24),
                _buildPageHeader(provider),
                const SizedBox(height: 24),
                _buildLastBackupActionBox(isMobile, provider),
                const SizedBox(height: 24),

                if (isDesktop)
                  Column(children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildBackupsTable(isMobile, provider)),
                        const SizedBox(width: 24),
                        Expanded(flex: 1, child: _buildSystemStatsVertical(provider)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildRecentSystemLogsTable(isMobile, provider),
                  ])
                else
                  Column(children: [
                    _buildSystemStatsGrid(provider),
                    const SizedBox(height: 24),
                    _buildBackupsTable(isMobile, provider),
                    const SizedBox(height: 24),
                    _buildRecentSystemLogsTable(isMobile, provider),
                  ]),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // Header العلوي
  // ==========================================
  Widget _buildTopHeader(bool isMobile, BackupProvider provider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              S.of(context).admin_backup_title,
              style: TextStyle(fontSize: isMobile ? 16 : 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminSettingsScreen(isFullScreen: true)));
              },
              borderRadius: BorderRadius.circular(50),
              child: _buildTopIcon(Icons.person_outline_rounded),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildTopIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle),
      child: Icon(Icons.person_outline, color: AppColors.primaryTeal(context)),
    );
  }

  // ==========================================
  // عنوان الصفحة
  // ==========================================
  Widget _buildPageHeader(BackupProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(S.of(context).backup_management,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
            ),
            Row(
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
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(S.of(context).backup_management_desc,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary(context))),
      ]),
    );
  }

  // ==========================================
  // صندوق آخر نسخة + زر النسخ
  // ==========================================
  Widget _buildLastBackupActionBox(bool isMobile, BackupProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryTeal(context).withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accentYellow(context).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.cloud_done, color: AppColors.accentYellow(context), size: 28),
            ),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(S.of(context).last_backup_created,
                  style: TextStyle(color: AppColors.textSecondary(context), fontSize: 14)),
              const SizedBox(height: 4),
              Text(
                provider.lastBackupDate,
                style: TextStyle(color: AppColors.textPrimary(context), fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ]),
          ]),
          if (isMobile) const SizedBox(height: 24),
          SizedBox(
            width: isMobile ? double.infinity : null,
            child: ElevatedButton.icon(
              onPressed: provider.isCreatingBackup
                  ? null
                  : () => provider.createBackup(context),
              icon: provider.isCreatingBackup
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.backup, color: Colors.white),
              label: Text(
                provider.isCreatingBackup ? S.of(context).loading_copying : S.of(context).backup_now_button,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal(context),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // جدول النسخ الاحتياطية
  // ==========================================
  Widget _buildBackupsTable(bool isMobile, BackupProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(S.of(context).backups_history_title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
        const SizedBox(height: 16),

        LayoutBuilder(builder: (context, constraints) {
          const double minWidth = 600;
          final bool needsScroll = constraints.maxWidth < minWidth;

          Widget tableContent = SizedBox(
            width: needsScroll ? minWidth : constraints.maxWidth,
            child: Column(children: [
              // رأس الجدول
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(children: [
                  _buildCell(Text(S.of(context).date_and_time,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), 2, 200, isMobile),
                  _buildCell(Text(S.of(context).size,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), 1, 100, isMobile),
                  _buildCell(Text(S.of(context).actions, textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), 2, 200, isMobile),
                ]),
              ),
              const SizedBox(height: 8),

              // الصفوف
              if (provider.backups.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(child: Text(S.of(context).error_no_backups,
                      style: TextStyle(color: AppColors.textSecondary(context)))),
                )
              else
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: provider.backups.length,
                    itemBuilder: (context, index) {
                      final backup = provider.backups[index];
                      final isEven = index % 2 == 0;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isEven ? AppColors.cardBg(context) : AppColors.scaffoldBg(context),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(children: [
                          _buildCell(
                            Text(backup.formattedDate,
                                style: TextStyle(color: AppColors.textPrimary(context), fontWeight: FontWeight.w600, fontSize: 13)),
                            2, 200, isMobile,
                          ),
                          _buildCell(
                            Text(backup.fileSize,
                                style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13)),
                            1, 100, isMobile,
                          ),
                          _buildCell(
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              // زر التحميل الحقيقي:// زر التحميل 
TextButton.icon(
  onPressed: () {
    // نستخدم النقطة لأن backup عبارة عن كلاس BackupItem
    provider.downloadBackup(context, backup.backupId, backup.formattedDate);
  },
  icon: Icon(Icons.download, color: AppColors.primaryTeal(context), size: 18),
  label: Text(S.of(context).download_button, style: TextStyle(color: AppColors.primaryTeal(context))),
),
const SizedBox(width: 8),

// زر الاستعادة 
TextButton.icon(
  onPressed: () {
    // نستخدم النقطة لأن backup عبارة عن كلاس BackupItem
    provider.restoreBackup(context, backup.backupId);
  },
  icon: const Icon(Icons.restore, color: Colors.redAccent, size: 18),
  label: Text(S.of(context).restore_button, style: const TextStyle(color: Colors.redAccent)),
),
                            ]),
                            2, 200, isMobile,
                          ),
                        ]),
                      );
                    },
                  ),
                ),
            ]),
          );

          return needsScroll
              ? SingleChildScrollView(scrollDirection: Axis.horizontal, child: tableContent)
              : tableContent;
        }),
      ]),
    );
  }

  // ==========================================
  // جدول سجلات النظام الأخيرة
  // ==========================================
  Widget _buildRecentSystemLogsTable(bool isMobile, BackupProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(S.of(context).recent_system_logs_title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
        const SizedBox(height: 16),

        LayoutBuilder(builder: (context, constraints) {
          const double minWidth = 600;
          final bool needsScroll = constraints.maxWidth < minWidth;

          Widget tableContent = SizedBox(
            width: needsScroll ? minWidth : constraints.maxWidth,
            child: Column(children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(children: [
                  _buildCell(Text(S.of(context).event,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), 3, 300, isMobile),
                  _buildCell(Text(S.of(context).type, textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), 1, 100, isMobile),
                  _buildCell(Text(S.of(context).time, textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), 1, 150, isMobile),
                ]),
              ),
              const SizedBox(height: 8),

              if (provider.recentLogs.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(child: Text(S.of(context).error_no_records,
                      style: TextStyle(color: AppColors.textSecondary(context)))),
                )
              else
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: provider.recentLogs.length,
                    itemBuilder: (context, index) {
                      final log = provider.recentLogs[index];
                      final isEven = index % 2 == 0;

                      Color typeColor;
                      String typeLabel;
                      switch (log.logType) {
                        case 'success':
                          typeColor = AppColors.primaryTeal(context);
                          typeLabel = S.of(context).success;
                          break;
                        case 'error':
                          typeColor = Colors.redAccent;
                          typeLabel = S.of(context).error;
                          break;
                        default:
                          typeColor = AppColors.accentYellow(context);
                          typeLabel = S.of(context).info;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isEven ? AppColors.cardBg(context) : AppColors.scaffoldBg(context),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(children: [
                          _buildCell(
                            Text(log.event,
                                style: TextStyle(color: AppColors.textPrimary(context), fontWeight: FontWeight.w600, fontSize: 13)),
                            3, 300, isMobile,
                          ),
                          _buildCell(
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: typeColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: typeColor.withValues(alpha: 0.3)),
                                ),
                                child: Text(typeLabel,
                                    style: TextStyle(color: typeColor, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            1, 100, isMobile,
                          ),
                          _buildCell(
                            Text(log.timeAgo, textAlign: TextAlign.center,
                                style: TextStyle(color: AppColors.textSecondary(context), fontSize: 12)),
                            1, 150, isMobile,
                          ),
                        ]),
                      );
                    },
                  ),
                ),
            ]),
          );

          return needsScroll
              ? SingleChildScrollView(scrollDirection: Axis.horizontal, child: tableContent)
              : tableContent;
        }),
      ]),
    );
  }

  // ==========================================
  // إحصائيات النظام - عمودي (Desktop)
  // ==========================================
  Widget _buildSystemStatsVertical(BackupProvider provider) {
    final stats = provider.systemStats;
    if (stats == null) return const SizedBox();

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _buildStatCard(title: S.of(context).uptime, value: stats.uptime,
          icon: Icons.timer, color: AppColors.primaryTeal(context)),
      const SizedBox(height: 16),
      _buildStatCard(title: S.of(context).db_size, value: stats.dbSize,
          icon: Icons.storage, color: AppColors.accentYellow(context)),
      const SizedBox(height: 16),
      _buildStatCard(title: S.of(context).total_backups, value: stats.totalBackups.toString(),
          icon: Icons.library_books, color: AppColors.primaryTeal(context)),
      const SizedBox(height: 16),
      _buildStatCard(title: S.of(context).system_status, value: stats.systemStatus,
          icon: Icons.check_circle, color: Colors.green),
    ]);
  }

  // ==========================================
  // إحصائيات النظام - أفقي (Mobile/Tablet)
  // ==========================================
  Widget _buildSystemStatsGrid(BackupProvider provider) {
    final stats = provider.systemStats;
    if (stats == null) return const SizedBox();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        SizedBox(width: 250, child: _buildStatCard(title: S.of(context).uptime, value: stats.uptime,
            icon: Icons.timer, color: AppColors.primaryTeal(context))),
        const SizedBox(width: 16),
        SizedBox(width: 250, child: _buildStatCard(title: S.of(context).db_size, value: stats.dbSize,
            icon: Icons.storage, color: AppColors.accentYellow(context))),
        const SizedBox(width: 16),
        SizedBox(width: 250, child: _buildStatCard(title: S.of(context).total_backups, value: stats.totalBackups.toString(),
            icon: Icons.library_books, color: AppColors.primaryTeal(context))),
        const SizedBox(width: 16),
        SizedBox(width: 250, child: _buildStatCard(title: S.of(context).system_status, value: stats.systemStatus,
            icon: Icons.check_circle, color: Colors.green)),
      ]),
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(color: AppColors.textPrimary(context), fontSize: 16, fontWeight: FontWeight.bold)),
        ])),
      ]),
    );
  }

  // ==========================================
  // دالة مساعدة للخلايا
  // ==========================================
  Widget _buildCell(Widget child, int flex, double mobileWidth, bool isMobile) {
    if (isMobile) {
      return SizedBox(width: mobileWidth,
          child: DefaultTextStyle(style: TextStyle(color: AppColors.textSecondary(context)), child: child));
    }
    return Expanded(flex: flex,
        child: DefaultTextStyle(style: TextStyle(color: AppColors.textSecondary(context)), child: child));
  }
}