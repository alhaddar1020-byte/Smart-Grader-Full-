import '../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:grade/generated/l10n.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../core/theme_provider.dart';
import '../../core/locale_provider.dart';
import 'admin_settings_provider.dart';

class AdminSettingsScreen extends StatefulWidget {
  final bool isFullScreen;
  const AdminSettingsScreen({super.key, this.isFullScreen = false});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _semesterNameController = TextEditingController();
  final TextEditingController _academicYearController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminSettingsProvider>().initializeProvider(context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose(); _phoneController.dispose(); _emailController.dispose(); _otpController.dispose();
    _oldPassController.dispose(); _newPassController.dispose(); _confirmPassController.dispose();
    _semesterNameController.dispose(); _academicYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminSettingsProvider>(
      builder: (context, provider, child) {
        return LayoutBuilder(builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 850;

          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: AppColors.secondaryTeal(context),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(isMobile ? 15 : 40, 30, isMobile ? 15 : 40, 0),
                    child: _buildPageHeader(isMobile),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 15 : 40),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: AppColors.primaryTeal(context), 
                        unselectedLabelColor: Colors.grey, 
                        indicatorColor: AppColors.primaryTeal(context), 
                        indicatorWeight: 3, 
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Arimo', fontSize: 16),
                        tabs: [
                          Tab(text: S.of(context).account_settings_tab), 
                          Tab(text: S.of(context).academic_settings_tab)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(padding: EdgeInsets.all(isMobile ? 15 : 40), child: isMobile ? _buildAccountMobileLayout(provider) : _buildAccountWebLayout(provider)),
                        SingleChildScrollView(padding: EdgeInsets.all(isMobile ? 15 : 40), child: _buildAcademicLayout(isMobile, provider)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }
    );
  }

  Widget _buildAccountWebLayout(AdminSettingsProvider provider) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 2, child: Column(children: [_buildProfileCard(false, provider), const SizedBox(height: 25), _buildSecurityCard(provider)])),
        const SizedBox(width: 25),
        Expanded(flex: 1, child: Column(children: [_buildDisplayPreferencesCard(provider), const SizedBox(height: 25), _buildDangerZoneCard(provider)])),
      ]);

  Widget _buildAccountMobileLayout(AdminSettingsProvider provider) => Column(children: [_buildProfileCard(true, provider), const SizedBox(height: 20), _buildSecurityCard(provider), const SizedBox(height: 20), _buildDisplayPreferencesCard(provider), const SizedBox(height: 20), _buildDangerZoneCard(provider)]);

  Widget _buildProfileCard(bool isMobile, AdminSettingsProvider provider) {
    if (!provider.isLoadingProfile && _nameController.text.isEmpty && provider.userName.isNotEmpty) {
      _nameController.text = provider.userName;
    }
    if (!provider.isLoadingProfile && _phoneController.text.isEmpty && provider.phoneNumber.isNotEmpty) {
      _phoneController.text = provider.phoneNumber;
    }
    if (!provider.isLoadingProfile && _emailController.text.isEmpty && provider.userEmail.isNotEmpty) {
      _emailController.text = provider.userEmail;
    }

    return Container(
      padding: const EdgeInsets.all(30), decoration: _cardDecoration(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(S.of(context).settingsProfileData, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
        const SizedBox(height: 25),
        if (provider.isLoadingProfile)
          const Center(child: CircularProgressIndicator())
        else
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: _buildDialogInputField(label: S.of(context).settingsFullName, controller: _nameController, icon: Icons.person_outline)), 
              if (!isMobile) const SizedBox(width: 20), 
              if (!isMobile) Expanded(child: _buildDialogInputField(label: S.of(context).settingsPhone, controller: _phoneController, icon: Icons.phone_android_outlined, keyboardType: TextInputType.phone))
            ]),
            if (isMobile) const SizedBox(height: 15),
            if (isMobile) _buildDialogInputField(label: S.of(context).settingsPhone, controller: _phoneController, icon: Icons.phone_android_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 15),
            _buildDialogInputField(label: S.of(context).settingsEmail, controller: _emailController, icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (_nameController.text.trim().isNotEmpty && _emailController.text.trim().isNotEmpty) {
                    provider.updateProfileName(_nameController.text.trim(), _phoneController.text.trim(), _emailController.text.trim(), context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).err_missing_data), backgroundColor: Colors.red));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal(context),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                child: Text(S.of(context).settingsUpdate, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
      ]),
    );
  }

  Widget _buildDynamicField(String label, String value, IconData icon, {bool showEdit = false, VoidCallback? onEdit}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary(context))),
      const SizedBox(height: 6),
      Container(
        height: 50, padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Icon(icon, size: 18, color: AppColors.textSecondary(context)),
          const SizedBox(width: 8),
          Expanded(child: Text(value.isEmpty ? "..." : value, style: TextStyle(fontSize: 14, color: AppColors.textPrimary(context)), overflow: TextOverflow.ellipsis, maxLines: 1)),
          if (showEdit) IconButton(icon: const Icon(Icons.edit_note, size: 22, color: Colors.orange), onPressed: onEdit, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
        ]),
      ),
    ]);
  }


  Widget _buildSecurityCard(AdminSettingsProvider provider) {
    return Container(
      padding: const EdgeInsets.all(25), decoration: _cardDecoration(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(S.of(context).settingsSecurityTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
        const SizedBox(height: 15),
        _buildActionRow(S.of(context).settingsManagePassword, S.of(context).settingsLastChange(provider.lastPasswordChange.isEmpty ? S.of(context).not_specified : provider.lastPasswordChange), Icons.lock_outline, actionLabel: S.of(context).settingsChangePassword, onTap: () => _showPasswordDialog(provider)),
      ]),
    );
  }

  void _showPasswordDialog(AdminSettingsProvider provider) {
    _oldPassController.clear(); _newPassController.clear(); _confirmPassController.clear();
    bool obsOld = true; bool obsNew = true; bool obsConfirm = true;
    provider.checkPasswordStrength("", context); // التحقق من اللغة مبدئياً

    _showCustomDialog(
      title: S.of(context).settingsChangePassword,
      content: StatefulBuilder(builder: (context, setDialogState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogInputField(label: S.of(context).settingsCurrentPassword, controller: _oldPassController, isObscured: obsOld, icon: Icons.lock_outline, onToggle: () => setDialogState(() => obsOld = !obsOld)),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showForgotPasswordFlow(provider);
                },
                child: Text(S.of(context).settingsForgotPassword, style: const TextStyle(fontSize: 12, color: Colors.blue)),
              ),
            ),
            const SizedBox(height: 10),
            _buildDialogInputField(label: S.of(context).settingsNewPassword, controller: _newPassController, isObscured: obsNew, icon: Icons.lock_outline, showStrength: true, provider: provider, onToggle: () => setDialogState(() => obsNew = !obsNew), onChanged: (val) => setDialogState(() => provider.checkPasswordStrength(val, context))),
            const SizedBox(height: 15),
            _buildDialogInputField(label: S.of(context).settingsConfirmPassword, controller: _confirmPassController, isObscured: obsConfirm, icon: Icons.lock_outline, onToggle: () => setDialogState(() => obsConfirm = !obsConfirm)),
          ],
        );
      }),
      onConfirm: () async {
        if (_oldPassController.text.isEmpty || _newPassController.text.isEmpty || _confirmPassController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).settingsFillAllFields), backgroundColor: Colors.red));
          return;
        }
        if (_newPassController.text != _confirmPassController.text) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).settingsPasswordNotMatch), backgroundColor: Colors.red));
          return;
        }
        await provider.changePassword(_oldPassController.text, _newPassController.text, _confirmPassController.text, context);
      },
    );
  }

  void _showForgotPasswordFlow(AdminSettingsProvider provider) {
    _otpController.clear(); _newPassController.clear(); _confirmPassController.clear();
    int step = 1; 
    bool obsNew = true; bool obsConfirm = true;

    showDialog(
      context: context, barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(builder: (context, setState) {
          bool isLoading = provider.isSendingForgotOtp || provider.isVerifyingForgotOtp || provider.isResettingForgotPass;
          
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(step == 1 ? S.of(context).forgot_pw_title : step == 2 ? S.of(context).settingsIdentityVerification : S.of(context).settingsChangePassword, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (step == 1) ...[
                  Text(S.of(context).settingsOtpSentToCurrentEmail, textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Text(provider.userEmail, style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold), textDirection: TextDirection.ltr),
                ],
                if (step == 2) ...[
                  Text(S.of(context).settingsEnterOtpSent, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  _buildDialogInputField(label: S.of(context).settingsOtpCode, controller: _otpController, icon: Icons.security, keyboardType: TextInputType.number),
                ],
                if (step == 3) ...[
                  _buildDialogInputField(label: S.of(context).settingsNewPassword, controller: _newPassController, isObscured: obsNew, icon: Icons.lock_outline, showStrength: true, provider: provider, onToggle: () => setState(() => obsNew = !obsNew), onChanged: (val) => setState(() => provider.checkPasswordStrength(val, context))),
                  const SizedBox(height: 15),
                  _buildDialogInputField(label: S.of(context).settingsConfirmPassword, controller: _confirmPassController, isObscured: obsConfirm, icon: Icons.lock_outline, onToggle: () => setState(() => obsConfirm = !obsConfirm)),
                ],
              ],
            ),
            actions: [
              TextButton(onPressed: isLoading ? null : () => Navigator.pop(dialogContext), child: Text(S.of(context).settingsCancel)),
              ElevatedButton(
                onPressed: isLoading ? null : () async {
                  if (step == 1) {
                    bool sent = await provider.sendForgotPasswordOtp(context);
                    if (sent) setState(() => step = 2);
                  } else if (step == 2) {
                    if (_otpController.text.length != 6) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).settingsEnter6DigitOtp), backgroundColor: Colors.red));
                      return;
                    }
                    bool verified = await provider.verifyForgotPasswordOtp(_otpController.text, context);
                    if (verified) setState(() => step = 3);
                  } else if (step == 3) {
                    if (_newPassController.text != _confirmPassController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).settingsPasswordNotMatch), backgroundColor: Colors.red));
                      return;
                    }
                    bool success = await provider.resetPasswordWithOtp(_otpController.text, _newPassController.text, context);
                    if (success) Navigator.pop(dialogContext);
                  }
                },
                child: isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(step == 1 ? S.of(context).settingsSendCode : step == 2 ? S.of(context).settingsConfirm : S.of(context).settingsUpdate),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _buildDisplayPreferencesCard(AdminSettingsProvider provider) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    bool isMobile = MediaQuery.of(context).size.width < 850;
    
    return Container(
      constraints: BoxConstraints(minHeight: isMobile ? 0 : 250),
      padding: const EdgeInsets.all(20), decoration: _cardDecoration(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(Icons.remove_red_eye_outlined, color: AppColors.primaryTeal(context), size: 20), const SizedBox(width: 8), Text(S.of(context).settingsDisplayPrefs, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)))]),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(S.of(context).settingsDarkMode, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary(context))),
          Switch(value: themeProvider.isDarkMode, onChanged: (v) => themeProvider.toggleTheme(v, provider.currentUserId), activeColor: AppColors.primaryTeal(context)),
        ]),
        const SizedBox(height: 10),
        Text(S.of(context).settingsLanguage, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary(context))),
        const SizedBox(height: 8),
        _buildLanguageSelector(localeProvider, provider),
      ]),
    );
  }

  Widget _buildLanguageSelector(LocaleProvider lp, AdminSettingsProvider provider) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(8)),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: lp.locale.languageCode, isExpanded: true,
        items: [DropdownMenuItem(value: 'ar', child: Text(S.of(context).arabic_lang)), DropdownMenuItem(value: 'en', child: Text("English"))],
        onChanged: (v) async {
          if (v != null) {
            await lp.updateLanguage(v, provider.currentUserId);
            provider.updateLanguageLocally(v);
          }
        },
      ),
    ),
  );

  Widget _buildDangerZoneCard(AdminSettingsProvider provider) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20), decoration: _cardDecoration().copyWith(color: isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFFFEEEE)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(S.of(context).settingsDangerZone, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.red)),
        const SizedBox(height: 20),
        Text(S.of(context).settingsDangerDesc, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13)),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _showDeactivateDialog(provider),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size(double.infinity, 42), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: Text(S.of(context).settingsDeactivate, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }

  void _showDeactivateDialog(AdminSettingsProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).settingsDeactivate, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(S.of(context).logoutConfirmationDesc),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(S.of(context).cancel, style: const TextStyle(color: Colors.grey))),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () => provider.logout(context), child: Text(S.of(context).confirmLogout, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  // ======================== 2. تبويب الإعدادات الأكاديمية ============================
  Widget _buildAcademicLayout(bool isMobile, AdminSettingsProvider provider) {
    return Container(
      padding: const EdgeInsets.all(25), decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).academic_semesters_title, style: TextStyle(fontSize: isMobile ? 16 : 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
              ElevatedButton(onPressed: () => _showAddSemesterDialog(provider), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal(context), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(S.of(context).add_new_semester, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),
          provider.isLoadingSemesters 
            ? const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: Colors.teal)))
            : provider.semestersList.isEmpty 
              ? _buildEmptyState() 
              : _buildSemestersTable(isMobile, provider),
        ],
      ),
    );
  }

  Widget _buildEmptyState() => Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 60), child: Column(children: [Icon(Icons.folder_open_outlined, size: 80, color: Colors.grey.shade300), const SizedBox(height: 16), Text(S.of(context).no_semesters_added, style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold))])));

  Widget _buildSemestersTable(bool isMobile, AdminSettingsProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        columns: [
          DataColumn(label: Text(S.of(context).semester_name)),
          DataColumn(label: Text(S.of(context).academic_year)),
          DataColumn(label: Text(S.of(context).start_date)),
          DataColumn(label: Text(S.of(context).end_date)),
          DataColumn(label: Text(S.of(context).current_semester_active)),
          DataColumn(label: Text(S.of(context).actions)),
        ],
        rows: List.generate(provider.semestersList.length, (index) {
          final semester = provider.semestersList[index];
          return DataRow(cells: [
            DataCell(Text(semester['semester_name'].toString())),
            DataCell(Text(semester['academic_year'].toString())),
            DataCell(Text(semester['start_date'] ?? S.of(context).not_specified)),
            DataCell(Text(semester['end_date'] ?? S.of(context).not_specified)),
            DataCell(Switch(value: semester['is_current'] == 1 || semester['is_current'] == true, activeColor: AppColors.primaryTeal(context), onChanged: (val) => provider.toggleCurrentSemester(index, context))),
            DataCell(Row(children: [
              IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20), onPressed: () => _showEditSemesterDialog(provider, semester)),
              IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20), onPressed: () => _showConfirmDeleteDialog(provider, semester)),
            ])),
          ]);
        }),
      ),
    );
  }

  void _showAddSemesterDialog(AdminSettingsProvider provider) {
    _semesterNameController.clear(); _academicYearController.clear(); _startDate = null; _endDate = null;
    _showCustomDialog(
      title: S.of(context).add_new_semester_dialog_title,
      content: StatefulBuilder(builder: (context, setDialogState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogInputField(label: S.of(context).semester_name_hint, controller: _semesterNameController, icon: Icons.bookmark_border),
            const SizedBox(height: 15),
            _buildDialogInputField(label: S.of(context).academic_year_hint, controller: _academicYearController, icon: Icons.date_range),
            const SizedBox(height: 15),
            Row(children: [
              Expanded(child: _buildDateSelector(S.of(context).start_date, _startDate, () async { DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030)); if (picked != null) setDialogState(() => _startDate = picked); })),
              const SizedBox(width: 15),
              Expanded(child: _buildDateSelector(S.of(context).end_date, _endDate, () async { DateTime? picked = await showDatePicker(context: context, initialDate: _startDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030)); if (picked != null) setDialogState(() => _endDate = picked); })),
            ]),
          ],
        );
      }),
      onConfirm: () async {
        if (_semesterNameController.text.isEmpty || _startDate == null || _endDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).err_missing_data), backgroundColor: Colors.red)); return;
        }
        String startStr = "${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}";
        String endStr = "${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}";
        await provider.addSemester(_semesterNameController.text.trim(), _academicYearController.text.trim(), startStr, endStr, context);
        if (context.mounted) Navigator.pop(context);
      },
    );
  }

  void _showEditSemesterDialog(AdminSettingsProvider provider, Map<String, dynamic> semester) {
    _semesterNameController.text = semester['semester_name'] ?? ""; _academicYearController.text = semester['academic_year'] ?? "";
    _startDate = semester['start_date'] != null ? DateTime.tryParse(semester['start_date']) : null;
    _endDate = semester['end_date'] != null ? DateTime.tryParse(semester['end_date']) : null;
    _showCustomDialog(
      title: S.of(context).edit_exam_data,
      content: StatefulBuilder(builder: (context, setDialogState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogInputField(label: S.of(context).semester_name_hint, controller: _semesterNameController, icon: Icons.bookmark_border),
            const SizedBox(height: 15),
            _buildDialogInputField(label: S.of(context).academic_year_hint, controller: _academicYearController, icon: Icons.date_range),
            const SizedBox(height: 15),
            Row(children: [
              Expanded(child: _buildDateSelector(S.of(context).start_date, _startDate, () async { DateTime? picked = await showDatePicker(context: context, initialDate: _startDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030)); if (picked != null) setDialogState(() => _startDate = picked); })),
              const SizedBox(width: 15),
              Expanded(child: _buildDateSelector(S.of(context).end_date, _endDate, () async { DateTime? picked = await showDatePicker(context: context, initialDate: _endDate ?? _startDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030)); if (picked != null) setDialogState(() => _endDate = picked); })),
            ]),
          ],
        );
      }),
      onConfirm: () async {
        if (_semesterNameController.text.isEmpty || _startDate == null || _endDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).err_missing_data), backgroundColor: Colors.red)); return;
        }
        String startStr = "${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}";
        String endStr = "${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}";
        await provider.updateSemester(semester['semester_id'], _semesterNameController.text.trim(), _academicYearController.text.trim(), startStr, endStr, context);
        if (context.mounted) Navigator.pop(context);
      },
    );
  }

  void _showConfirmDeleteDialog(AdminSettingsProvider provider, Map<String, dynamic> semester) {
    showDialog(context: context, builder: (ctx) => AlertDialog(title: Text(S.of(context).delete_confirmation), content: Text(S.of(context).delete_user_warning), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(S.of(context).settingsCancel)), TextButton(onPressed: () { Navigator.pop(ctx); provider.deleteSemester(semester['semester_id'], context); }, child: Text(S.of(context).yes_delete, style: const TextStyle(color: Colors.red)))]));
  }

  // --- Components المساعدة للواجهة ---
  Widget _buildDialogInputField({required String label, required TextEditingController controller, bool isObscured = false, VoidCallback? onToggle, bool showStrength = false, AdminSettingsProvider? provider, Function(String)? onChanged, IconData? icon, TextInputType keyboardType = TextInputType.text}) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontSize: 14, color: AppColors.textPrimary(context), fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(
        controller: controller, obscureText: isObscured, onChanged: onChanged, keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true, fillColor: isDarkMode ? const Color(0xFF363636) : const Color(0xFFF3F4F6),
          prefixIcon: Icon(icon, color: const Color(0xFFCBD5E0), size: 20),
          suffixIcon: onToggle != null ? IconButton(icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility, size: 20), onPressed: onToggle) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        ),
      ),
      if (showStrength && provider != null && provider.passwordStrengthText.isNotEmpty) ...[
        const SizedBox(height: 12),
        Text(S.of(context).settingsStrengthLabel(provider.passwordStrengthText), style: TextStyle(color: provider.passwordStrengthColor, fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        LinearProgressIndicator(value: provider.passwordStrengthValue, backgroundColor: const Color(0xFFE2E8F0), color: provider.passwordStrengthColor, minHeight: 6),
      ]
    ]);
  }

  Widget _buildDateSelector(String label, DateTime? date, VoidCallback onTap) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), const SizedBox(height: 8), InkWell(onTap: onTap, borderRadius: BorderRadius.circular(14), child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(14)), child: Row(children: [const Icon(Icons.calendar_month_outlined, size: 20, color: Color(0xFFCBD5E0)), const SizedBox(width: 10), Text(date != null ? "${date.year}-${date.month}-${date.day}" : S.of(context).choose_date, style: const TextStyle(color: Colors.grey))]))),]);

  Widget _buildActionRow(String title, String sub, IconData icon, {String? actionLabel, VoidCallback? onTap}) => InkWell(onTap: onTap, child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(10)), child: Row(children: [Icon(icon, color: AppColors.primaryTeal(context)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))), Text(sub, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 11))])), if (actionLabel != null) Text(actionLabel, style: TextStyle(color: AppColors.primaryTeal(context), fontSize: 12, fontWeight: FontWeight.bold))])));

  BoxDecoration _cardDecoration() => BoxDecoration(color: AppColors.cardBg(context), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]);

  Widget _buildPageHeader(bool isMobile) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(color: AppColors.cardBg(context), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (widget.isFullScreen) ...[
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.adaptive.arrow_back, color: AppColors.primaryTeal(context), size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(S.of(context).admin_settings_title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
                  const SizedBox(height: 4),
                  Text(S.of(context).admin_settings_subtitle, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 14))
                ]),
              ],
            ),
            Row(children: [_iconBtn(Icons.person_outline)])
          ]
        )
      );

  Widget _iconBtn(IconData icon) => Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle), child: Icon(icon, color: AppColors.primaryTeal(context)));

  void _showCustomDialog({required String title, required Widget content, required VoidCallback onConfirm}) {
    showDialog(context: context, builder: (context) => BackdropFilter(filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), child: AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), title: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)), content: SingleChildScrollView(child: content), actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(S.of(context).settingsCancel)), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal(context), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: onConfirm, child: Text(S.of(context).settingsUpdate, style: const TextStyle(color: Colors.white)))])));
  }
}
