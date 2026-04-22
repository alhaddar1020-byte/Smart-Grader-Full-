import 'package:flutter/material.dart';
import '../../core/colors.dart'; 
import 'package:grade/generated/l10n.dart'; 

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  // ===========================================================================
  // 1. قواعد البيانات الوهمية (تم إزالة final لنتمكن من التعديل عليها ديناميكياً)
  // ===========================================================================
  List<Map<String, String>> backupsList = [
    {'date': '2023-10-25 | 04:00 PM', 'size': '45 MB'},
    {'date': '2023-10-20 | 01:30 PM', 'size': '42 MB'},
    {'date': '2023-10-15 | 09:00 AM', 'size': '38 MB'},
  ];

  List<Map<String, String>> recentLogsList = [
    {'event': 'Login: System Admin', 'type': 'info', 'time': '45 mins ago'},
    {'event': 'Backup taken successfully', 'type': 'success', 'time': '2 hours ago'},
    {'event': 'Failed to send grade notifications', 'type': 'error', 'time': '3 hours ago'},
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 600;
    bool isTablet = width >= 600 && width < 1280;
    bool isDesktop = width >= 1280;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopHeader(isMobile),
            const SizedBox(height: 24),

            _buildPageHeader(),
            const SizedBox(height: 24),

            _buildLastBackupActionBox(isMobile),
            const SizedBox(height: 24),

            // =================================================================
            // 2. التخطيط الجديد (Layout): جدول السجلات صار تحت وياخذ العرض كامل!
            // =================================================================
            if (isDesktop)
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // القسم الأيمن: جدول النسخ
                      Expanded(
                        flex: 2,
                        child: _buildBackupsTable(isMobile),
                      ),
                      const SizedBox(width: 24),
                      // القسم الأيسر: بطاقات حالة النظام
                      Expanded(
                        flex: 1, 
                        child: _buildSystemStatsVertical()
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // جدول السجلات صار برا الـ Row عشان ياخذ العرض كامل
                  _buildRecentSystemLogsTable(isMobile),
                ],
              )
            else
              Column(
                children: [
                  _buildSystemStatsGrid(isMobile),
                  const SizedBox(height: 24),
                  _buildBackupsTable(isMobile),
                  const SizedBox(height: 24),
                  _buildRecentSystemLogsTable(isMobile),
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

  Widget _buildTopHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 16),
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
              S.of(context).admin_backup_title, 
              style: TextStyle(
                fontSize: isMobile ? 16 : 18, 
                fontWeight: FontWeight.bold, 
                color: AppColors.textPrimary(context)
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              _buildTopIcon(icon: Icons.notifications_none_rounded, onTap: () {}),
              const SizedBox(width: 8),
              _buildTopIcon(icon: Icons.person_outline_rounded, onTap: () {}),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTopIcon({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.scaffoldBg(context), shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.primaryTeal(context), size: 24),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).backup_management, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
          const SizedBox(height: 8),
          Text(S.of(context).backup_management_desc, style: TextStyle(fontSize: 14, color: AppColors.textSecondary(context))),
        ],
      ),
    );
  }

  Widget _buildLastBackupActionBox(bool isMobile) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryTeal(context).withOpacity(0.3), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.accentYellow(context).withOpacity(0.2), shape: BoxShape.circle),
                child: Icon(Icons.cloud_done, color: AppColors.accentYellow(context), size: 28),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).last_backup_created, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    backupsList.isNotEmpty ? backupsList.first['date']! : '--', 
                    style: TextStyle(color: AppColors.textPrimary(context), fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                ],
              ),
            ],
          ),
          if (isMobile) const SizedBox(height: 24),
          SizedBox(
            width: isMobile ? double.infinity : null,
            child: ElevatedButton.icon(
              onPressed: () {
                // رسالة جاري النسخ
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.of(context).creating_new_backup_snackbar), backgroundColor: AppColors.primaryTeal(context)),
                );

                // =============================================================
                // 🚀 الدالة السحرية: الانتظار ثانيتين ثم إضافة النسخة للجدول
                // =============================================================
                Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    // حساب الوقت الحالي
                    final now = DateTime.now();
                    String hour = now.hour > 12 ? (now.hour - 12).toString().padLeft(2, '0') : now.hour.toString().padLeft(2, '0');
                    if (hour == '00') hour = '12';
                    String amPm = now.hour >= 12 ? (isRtl ? 'م' : 'PM') : (isRtl ? 'ص' : 'AM');
                    String minute = now.minute.toString().padLeft(2, '0');
                    String currentDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} | $hour:$minute $amPm';

                    // 1. إضافتها في أول جدول النسخ
                    backupsList.insert(0, {
                      'date': currentDate,
                      'size': '45 MB', // حجم وهمي
                    });

                    // 2. توثيق العملية في أول جدول سجلات النظام
                    recentLogsList.insert(0, {
                      'event': S.of(context).alert_backup_success_desc,
                      'type': 'success',
                      'time': isRtl ? 'الآن' : 'Just now',
                    });
                  });

                  // رسالة النجاح
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S.of(context).alert_backup_success), backgroundColor: Colors.green),
                  );
                });
              },
              icon: const Icon(Icons.backup, color: Colors.white),
              label: Text(S.of(context).backup_now_button, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildBackupsTable(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).backups_history_title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
          const SizedBox(height: 16),

          LayoutBuilder(
            builder: (context, constraints) {
              double minSafeWidth = 600; 
              bool needsScroll = constraints.maxWidth < minSafeWidth;
              double tableWidth = needsScroll ? minSafeWidth : constraints.maxWidth;

              Widget tableContent = SizedBox(
                width: tableWidth,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(color: AppColors.primaryTeal(context), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          _buildCell(Text(S.of(context).date_and_time, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), 2, 200, isMobile),
                          _buildCell(Text(S.of(context).size, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), 1, 100, isMobile),
                          _buildCell(Text(S.of(context).actions, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), 2, 200, isMobile),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: backupsList.length,
                        itemBuilder: (context, index) {
                          final backup = backupsList[index];
                          bool isEven = index % 2 == 0;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(color: isEven ? AppColors.textWhite(context) : AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                _buildCell(Text(backup['date']!, style: TextStyle(color: AppColors.textPrimary(context), fontWeight: FontWeight.w600, fontSize: 13)), 2, 200, isMobile),
                                _buildCell(Text(backup['size']!, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13)), 1, 100, isMobile),
                                _buildCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${S.of(context).downloading_backup_snackbar} ${backup['date']}'), backgroundColor: AppColors.primaryTeal(context)));
                                        },
                                        icon: Icon(Icons.download, color: AppColors.primaryTeal(context), size: 18),
                                        label: Text(S.of(context).download_button, style: TextStyle(color: AppColors.primaryTeal(context))),
                                      ),
                                      const SizedBox(width: 8),
                                      TextButton.icon(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).restoring_system_snackbar), backgroundColor: Colors.redAccent));
                                        },
                                        icon: const Icon(Icons.restore, color: Colors.redAccent, size: 18),
                                        label: Text(S.of(context).restore_button, style: const TextStyle(color: Colors.redAccent)),
                                      ),
                                    ],
                                  ),
                                  2, 200, isMobile
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );

              return needsScroll
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: tableContent,
                    )
                  : tableContent;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSystemLogsTable(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).recent_system_logs_title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
          const SizedBox(height: 16),

          LayoutBuilder(
            builder: (context, constraints) {
              double minSafeWidth = 600; 
              bool needsScroll = constraints.maxWidth < minSafeWidth;
              double tableWidth = needsScroll ? minSafeWidth : constraints.maxWidth;

              Widget tableContent = SizedBox(
                width: tableWidth,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(color: AppColors.primaryTeal(context), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          _buildCell(Text(S.of(context).event, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), 3, 300, isMobile),
                          _buildCell(Text(S.of(context).type, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), 1, 100, isMobile),
                          _buildCell(Text(S.of(context).time, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), 1, 150, isMobile),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: recentLogsList.length,
                        itemBuilder: (context, index) {
                          final log = recentLogsList[index];
                          bool isEven = index % 2 == 0;

                          Color typeColor;
                          String typeLabel;

                          if (log['type'] == 'success') {
                            typeColor = AppColors.primaryTeal(context);
                            typeLabel = S.of(context).success;
                          } else if (log['type'] == 'error') {
                            typeColor = Colors.redAccent;
                            typeLabel = S.of(context).error;
                          } else {
                            typeColor = AppColors.accentYellow(context);
                            typeLabel = S.of(context).info;
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(color: isEven ? AppColors.textWhite(context) : AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                _buildCell(Text(log['event']!, style: TextStyle(color: AppColors.textPrimary(context), fontWeight: FontWeight.w600, fontSize: 13)), 3, 300, isMobile),
                                _buildCell(
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: typeColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: typeColor.withOpacity(0.3)),
                                      ),
                                      child: Text(typeLabel, style: TextStyle(color: typeColor, fontSize: 11, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  1, 100, isMobile
                                ),
                                _buildCell(Text(log['time']!, textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 12)), 1, 150, isMobile),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );

              return needsScroll
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: tableContent,
                    )
                  : tableContent;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCell(Widget child, int flex, double mobileWidth, bool isMobile) {
    if (isMobile) {
      return SizedBox(width: mobileWidth, child: DefaultTextStyle(style: TextStyle(color: AppColors.textSecondary(context)), child: child));
    }
    return Expanded(flex: flex, child: DefaultTextStyle(style: TextStyle(color: AppColors.textSecondary(context)), child: child));
  }

  Widget _buildSystemStatsVertical() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildVerticalStatCard(title: S.of(context).uptime, value: '14 Days, 5 Hours', icon: Icons.timer, color: AppColors.primaryTeal(context)),
        const SizedBox(height: 16),
        _buildVerticalStatCard(title: S.of(context).db_size, value: '128 MB', icon: Icons.storage, color: AppColors.accentYellow(context)),
        const SizedBox(height: 16),
        _buildVerticalStatCard(title: S.of(context).total_backups, value: '24', icon: Icons.library_books, color: AppColors.primaryTeal(context)),
        const SizedBox(height: 16),
        _buildVerticalStatCard(title: S.of(context).system_status, value: S.of(context).system_stable, icon: Icons.check_circle, color: Colors.green),
      ],
    );
  }

  Widget _buildSystemStatsGrid(bool isMobile) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 250, child: _buildVerticalStatCard(title: S.of(context).uptime, value: '14 Days, 5 Hours', icon: Icons.timer, color: AppColors.primaryTeal(context))),
          const SizedBox(width: 16),
          SizedBox(width: 250, child: _buildVerticalStatCard(title: S.of(context).db_size, value: '128 MB', icon: Icons.storage, color: AppColors.accentYellow(context))),
          const SizedBox(width: 16),
          SizedBox(width: 250, child: _buildVerticalStatCard(title: S.of(context).total_backups, value: '24', icon: Icons.library_books, color: AppColors.primaryTeal(context))),
          const SizedBox(width: 16),
          SizedBox(width: 250, child: _buildVerticalStatCard(title: S.of(context).system_status, value: S.of(context).system_stable, icon: Icons.check_circle, color: Colors.green)),
        ],
      ),
    );
  }

  Widget _buildVerticalStatCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(value, style: TextStyle(color: AppColors.textPrimary(context), fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}