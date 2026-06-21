import '../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import 'package:grade/generated/l10n.dart';
import 'system_logs_provider.dart';
import 'admin_settings_screen.dart';

class SystemLogsScreen extends StatefulWidget {
  const SystemLogsScreen({super.key});

  @override
  State<SystemLogsScreen> createState() => _SystemLogsScreenState();
}

class _SystemLogsScreenState extends State<SystemLogsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SystemLogsProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, SystemLogsProvider provider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryTeal(context),
            onPrimary: Colors.white,
            onSurface: AppColors.textPrimary(context),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) provider.updateDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SystemLogsProvider>(
      builder: (context, provider, _) {
        double width = MediaQuery.of(context).size.width;
        bool isMobile = width < 600;
        bool isTablet = width >= 600 && width < 1100;

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
                _buildStatsCards(isMobile, isTablet, provider),
                const SizedBox(height: 32),
                _buildFiltersBox(isMobile, isTablet, provider),
                const SizedBox(height: 24),
                _buildLogsTable(provider),
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
  Widget _buildTopHeader(bool isMobile, SystemLogsProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              S.of(context).admin_system_logs_title,
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
  Widget _buildPageHeader(SystemLogsProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.cardBg(context), borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(S.of(context).system_logs_title,
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
        Text(S.of(context).system_logs_desc,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary(context))),
      ]),
    );
  }

  // ==========================================
  // بطاقات الإحصائيات
  // ==========================================
  Widget _buildStatsCards(bool isMobile, bool isTablet, SystemLogsProvider provider) {
    final cards = [
      _buildSingleCard(
        title: S.of(context).total_actions,
        value: _formatNumber(provider.totalActions),
        icon: Icons.list_alt,
        color: AppColors.primaryTeal(context),
      ),
      _buildSingleCard(
        title: S.of(context).login_records,
        value: _formatNumber(provider.loginRecords),
        icon: Icons.login,
        color: AppColors.accentYellow(context),
      ),
      _buildSingleCard(
        title: S.of(context).today,
        value: _formatNumber(provider.todayCount),
        icon: Icons.calendar_month,
        color: AppColors.primaryTeal(context),
      ),
    ];

    if (isMobile || isTablet) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(children: [
          SizedBox(width: 250, child: cards[0]),
          const SizedBox(width: 16),
          SizedBox(width: 250, child: cards[1]),
          const SizedBox(width: 16),
          SizedBox(width: 250, child: cards[2]),
        ]),
      );
    }

    return Row(children: [
      Expanded(child: cards[0]),
      const SizedBox(width: 24),
      Expanded(child: cards[1]),
      const SizedBox(width: 24),
      Expanded(child: cards[2]),
    ]);
  }

  Widget _buildSingleCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(title, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
          ),
        ])),
      ]),
    );
  }

  // ==========================================
  // صندوق الفلاتر
  // ==========================================
  Widget _buildFiltersBox(bool isMobile, bool isTablet, SystemLogsProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.cardBg(context), borderRadius: BorderRadius.circular(16)),
      child: isMobile || isTablet
          ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              _buildSearchField(provider),
              const SizedBox(height: 16),
              _buildRoleDropdown(provider),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _buildDateButton(provider)),
                if (provider.selectedDate != null) ...[
                  const SizedBox(width: 8),
                  _buildClearDateBtn(provider),
                ]
              ]),
              const SizedBox(height: 16),
              _buildExportButton(provider),
            ])
          : Row(children: [
              Expanded(flex: 2, child: _buildSearchField(provider)),
              const SizedBox(width: 16),
              Expanded(flex: 1, child: _buildRoleDropdown(provider)),
              const SizedBox(width: 16),
              _buildDateButton(provider),
              if (provider.selectedDate != null) ...[
                const SizedBox(width: 8),
                _buildClearDateBtn(provider),
              ],
              const SizedBox(width: 16),
              _buildExportButton(provider),
            ]),
    );
  }

  Widget _buildSearchField(SystemLogsProvider provider) {
    return TextField(
      controller: _searchController,
      style: TextStyle(color: AppColors.textPrimary(context)),
      onChanged: (value) => provider.updateSearch(value),
      decoration: InputDecoration(
        hintText: S.of(context).search_user_hint,
        prefixIcon: Icon(Icons.search, color: AppColors.textSecondary(context)),
        filled: true,
        fillColor: AppColors.scaffoldBg(context),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildRoleDropdown(SystemLogsProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: provider.selectedRole,
          isExpanded: true,
          dropdownColor: AppColors.cardBg(context),
          items: <Map<String, String>>[
            {'key': 'ALL', 'label': S.of(context).all_roles},
            {'key': 'TEACHER', 'label': S.of(context).role_teacher},
            {'key': 'STUDENT', 'label': S.of(context).role_student},
            {'key': 'ADMIN', 'label': S.of(context).role_admin},
          ].map((item) => DropdownMenuItem<String>(
            value: item['key'],
            child: Text(item['label']!, style: TextStyle(color: AppColors.textPrimary(context))),
          )).toList(),
          onChanged: (val) { if (val != null) provider.updateRole(val); },
        ),
      ),
    );
  }

  Widget _buildDateButton(SystemLogsProvider provider) {
    final hasDate = provider.selectedDate != null;
    return OutlinedButton.icon(
      onPressed: () => _selectDate(context, provider),
      icon: Icon(Icons.calendar_today, color: AppColors.textPrimary(context), size: 20),
      label: Text(
        hasDate
            ? '${provider.selectedDate!.year}-${provider.selectedDate!.month.toString().padLeft(2, '0')}-${provider.selectedDate!.day.toString().padLeft(2, '0')}'
            : S.of(context).date_range,
        style: TextStyle(color: AppColors.textPrimary(context)),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        side: BorderSide(color: hasDate ? AppColors.primaryTeal(context) : AppColors.secondaryTeal(context)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildClearDateBtn(SystemLogsProvider provider) {
    return IconButton(
      icon: const Icon(Icons.clear, color: Colors.red),
      onPressed: provider.clearDate,
    );
  }

  Widget _buildExportButton(SystemLogsProvider provider) {
    return ElevatedButton.icon(
      onPressed: provider.isExporting ? null : () => provider.exportCsv(context),
      icon: provider.isExporting
          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : const Icon(Icons.download, color: Colors.white, size: 20),
      label: Text(
        provider.isExporting ? S.of(context).loading_exporting : S.of(context).export_log_button,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryTeal(context),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ==========================================
  // جدول السجلات
  // ==========================================
  Widget _buildLogsTable(SystemLogsProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.cardBg(context), borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // عنوان الجدول + عدد النتائج
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(S.of(context).action_logs_title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
          if (!provider.isLoading)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.secondaryTeal(context),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${provider.totalCount} ${S.of(context).total_actions}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryTeal(context)),
              ),
            ),
        ]),
        const SizedBox(height: 24),

        if (provider.isLoading)
          const Center(child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(color: Colors.teal),
          ))
        else if (provider.errorMessage.isNotEmpty)
          Center(child: Column(children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(provider.errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: provider.fetchLogs,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: Text(S.of(context).retry, style: const TextStyle(color: Colors.white)),
            ),
          ]))
        else
          LayoutBuilder(builder: (context, constraints) {
            const double minWidth = 900;
            final bool needsScroll = constraints.maxWidth < minWidth;

            Widget tableContent = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // رأس الجدول
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(children: [
                  Expanded(flex: 2, child: _headerCell(S.of(context).username_col)),
                  Expanded(flex: 1, child: _headerCell(S.of(context).role_col)),
                  Expanded(flex: 3, child: _headerCell(S.of(context).action_col)),
                  Expanded(flex: 2, child: _headerCell(S.of(context).datetime_col)),
                  Expanded(flex: 2, child: _headerCell(S.of(context).ip_col)),
                ]),
              ),
              const SizedBox(height: 12),

              // الصفوف
              if (provider.logs.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  alignment: Alignment.center,
                  child: Text(S.of(context).no_matching_logs,
                      style: TextStyle(color: AppColors.textSecondary(context), fontSize: 16)),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.logs.length,
                  itemBuilder: (context, index) {
                    final log = provider.logs[index];
                    final isEven = index % 2 == 0;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isEven ? AppColors.cardBg(context) : AppColors.scaffoldBg(context),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(children: [
                        Expanded(flex: 2, child: _dataCell(log.userName, bold: true)),
                        Expanded(flex: 1, child: _roleChip(provider.getRoleDisplayName(log.userRole, context))),
                        Expanded(flex: 3, child: _dataCell(log.actionTaken)),
                        Expanded(flex: 2, child: _dataCell(log.actionDateTime)),
                        Expanded(flex: 2, child: _dataCell(log.ipAddress)),
                      ]),
                    );
                  },
                ),

              // Pagination
              if (provider.totalCount > provider.pageSize)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: provider.currentPage > 0
                          ? () {
                              provider.currentPage--;
                              provider.fetchLogs(resetPage: false);
                            }
                          : null,
                      color: AppColors.primaryTeal(context),
                    ),
                    Text(
                      '${provider.currentPage + 1} / ${(provider.totalCount / provider.pageSize).ceil()}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: (provider.currentPage + 1) * provider.pageSize < provider.totalCount
                          ? () {
                              provider.currentPage++;
                              provider.fetchLogs(resetPage: false);
                            }
                          : null,
                      color: AppColors.primaryTeal(context),
                    ),
                  ]),
                ),
            ]);

            return needsScroll
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(width: minWidth, child: tableContent),
                  )
                : tableContent;
          }),
      ]),
    );
  }

  // ---- مساعدات الجدول ----
  Widget _headerCell(String text) {
    return Text(text,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        overflow: TextOverflow.ellipsis);
  }

  Widget _dataCell(String text, {bool bold = false}) {
    final bool hasArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
    return Text(
      text,
      textDirection: hasArabic ? TextDirection.rtl : TextDirection.ltr,
      style: TextStyle(
        color: bold ? AppColors.textPrimary(context) : AppColors.textSecondary(context),
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _roleChip(String role) {
    Color chipColor;
    if (role == S.of(context).role_teacher) {
      chipColor = Colors.blue;
    } else if (role == S.of(context).role_student) {
      chipColor = Colors.green;
    } else if (role == S.of(context).role_admin) {
      chipColor = Colors.purple;
    } else {
      chipColor = Colors.grey;
    }
    return Text(
      role,
      style: TextStyle(
        color: chipColor, 
        fontSize: 13, 
        fontWeight: FontWeight.bold
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(1)}K';
    }
    return n.toString();
  }
}