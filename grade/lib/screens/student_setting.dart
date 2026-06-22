import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grade/provider/student_dashboard_controller.dart';

import '../core/colors.dart';
import '../core/theme_provider.dart';
import '../core/locale_provider.dart';
import '../generated/l10n.dart';
import '../provider/settings_controller.dart';
import 'homepage.dart'; // تأكدي من مسار شاشة SmartCorrectorUI
import '../provider/subject_screen_controller.dart'; // مسار ملف البروفايدر الذي أنشأناه بالأعلى

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // 🛡️ حماية

      // جلب رقم الطالب من الداشبورد
      final studentId = context
          .read<StudentDashboardController>()
          .currentStudentId;

      // طلب البيانات وتمرير الـ context لتفعيل درع الحماية اللي سويناه
      context.read<SettingsController>().fetchProfile(
        studentId,
        context: context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🌟 السطر الوحيد الذي يربط الشاشة بالكنترولر في Provider
    final ctrl = context.watch<SettingsController>();

    return Scaffold(
      backgroundColor: AppColors.secondaryTeal(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          bool isMobile = width < 850;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 13 : 40,
                vertical: isMobile ? 15 : 30,
              ),
              child: SingleChildScrollView(
                child: isMobile
                    ? _buildMobileLayout(ctrl)
                    : _buildWebLayout(ctrl),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // التنسيقات (Layouts)
  // ==========================================

  Widget _buildWebLayout(SettingsController ctrl) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildProfileCard(false, ctrl),
              const SizedBox(height: 20),
              _buildSecurityCard(ctrl),
            ],
          ),
        ),
        const SizedBox(width: 25),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildDisplayPreferencesCard(false, ctrl),
              const SizedBox(height: 20),
              _buildDangerZoneCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(SettingsController ctrl) {
    return Column(
      children: [
        _buildProfileCard(true, ctrl),
        const SizedBox(height: 20),
        _buildSecurityCard(ctrl),
        const SizedBox(height: 20),
        _buildDisplayPreferencesCard(true, ctrl),
        const SizedBox(height: 20),
        _buildDangerZoneCard(),
      ],
    );
  }

  // ==========================================
  // كرت الملف الشخصي
  // ==========================================
  Widget _buildProfileCard(bool isMobile, SettingsController ctrl) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).settingsProfileData,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 25),

          if (ctrl.isLoadingProfile)
            const Center(child: CircularProgressIndicator())
          else
            isMobile
                ? Column(
                    children: [
                      _buildDynamicField(
                        S.of(context).settingsFullName,
                        ctrl.userName,
                        Icons.person_outline,
                        showEdit: false,
                      ),
                      const SizedBox(height: 15),
                      _buildDynamicField(
                        S.of(context).settingsEmail,
                        ctrl.userEmail,
                        Icons.email_outlined,
                        showEdit: true,
                        onEdit: _showEmailChangeDialog,
                      ),
                      const SizedBox(height: 15),
                      _buildDynamicField(
                        S.of(context).settingsLevel,
                        ctrl.levelAndDepartment,
                        Icons.school_outlined,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildDynamicField(
                              S.of(context).settingsFullName,
                              ctrl.userName,
                              Icons.person_outline,
                              showEdit: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDynamicField(
                              S.of(context).settingsEmail,
                              ctrl.userEmail,
                              Icons.email_outlined,
                              showEdit: true,
                              onEdit: _showEmailChangeDialog,
                            ),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: _buildDynamicField(
                              S.of(context).settingsLevel,
                              ctrl.levelAndDepartment,
                              Icons.school_outlined,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
        ],
      ),
    );
  }

  Widget _buildDynamicField(
    String label,
    String value,
    IconData icon, {
    bool showEdit = false,
    VoidCallback? onEdit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.scaffoldBg(context),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary(context)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value.isEmpty ? "..." : value,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (showEdit)
                IconButton(
                  icon: const Icon(
                    Icons.edit_note,
                    size: 22,
                    color: Colors.orange,
                  ),
                  onPressed: onEdit,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // الدوال والحوارات (Dialogs)
  // ==========================================

  void _showEmailChangeDialog() {
    _emailController.clear();
    _otpController.clear();

    bool isOtpStep = false;
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final ctrl = context
                .read<
                  SettingsController
                >(); // 🌟 استدعاء الكنترولر بأمان داخل الديالوج
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                isOtpStep
                    ? S.of(context).settingsIdentityVerification
                    : S.of(context).settingsChangeEmail,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isOtpStep) ...[
                    Text(
                      S.of(context).settingsOtpSentToCurrentEmail,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildDialogInputField(
                      label: S.of(context).settingsNewEmail,
                      controller: _emailController,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                  if (isOtpStep) ...[
                    Text(
                      S.of(context).settingsEnterOtpSent,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      ctrl.userEmail,
                      style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDialogInputField(
                      label: S.of(context).settingsOtpCode,
                      controller: _otpController,
                      icon: Icons.security,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.pop(dialogContext);
                        },
                  child: Text(S.of(context).settingsCancel),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!isOtpStep) {
                            if (_emailController.text.isEmpty ||
                                !_emailController.text.contains('@')) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    S.of(context).settingsEnterValidEmail,
                                  ),
                                ),
                              );
                              return;
                            }
                            setState(() => isLoading = true);
                            bool success = await ctrl.sendEmailChangeOtp(
                              newEmail: _emailController.text,
                              context: context,
                            );

                            if (!mounted)
                              return; // 👈 🛡️ أضيفي هذا السطر هنا فوراً بعد الـ await

                            setState(() => isLoading = false);
                            if (success) {
                              setState(() {
                                isOtpStep = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    S.of(context).settingsOtpSentSuccess,
                                  ),
                                ),
                              );
                            }
                          } else {
                            if (_otpController.text.length != 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    S.of(context).settingsEnter6DigitOtp,
                                  ),
                                ),
                              );
                              return;
                            }
                            setState(() => isLoading = true);
                            bool success = await ctrl.verifyEmailOtp(
                              otpCode: _otpController.text,
                              newEmail: _emailController.text,
                              context: context,
                            );

                            if (!mounted)
                              return; // 👈 🛡️ وأضيفي هذا السطر هنا أيضاً بعد الـ await सेकंड

                            setState(() => isLoading = false);
                            if (success) {
                              Navigator.pop(dialogContext);
                              await Future.delayed(
                                const Duration(milliseconds: 300),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    S.of(context).settingsEmailUpdated,
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    S.of(context).settingsOtpIncorrect,
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          isOtpStep
                              ? S.of(context).settingsConfirm
                              : S.of(context).settingsSendCode,
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPasswordDialog() {
    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    _showCustomDialog(
      title: S.of(context).settingsChangePassword,
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          final ctrl = context.read<SettingsController>();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogInputField(
                label: S.of(context).settingsCurrentPassword,
                controller: _oldPasswordController,
                isObscured: _obscureOld,
                icon: Icons.lock_outline,
                onToggle: () =>
                    setDialogState(() => _obscureOld = !_obscureOld),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showForgotPasswordFlow();
                  },
                  child: Text(
                    S.of(context).settingsForgotPassword,
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _buildDialogInputField(
                label: S.of(context).settingsNewPassword,
                controller: _newPasswordController,
                isObscured: _obscureNew,
                icon: Icons.lock_outline,
                showStrength: true,
                onToggle: () =>
                    setDialogState(() => _obscureNew = !_obscureNew),
                onChanged: (val) {
                  ctrl.checkPasswordStrength(val, context: context);
                  setDialogState(() {});
                },
              ),
              const SizedBox(height: 15),
              _buildDialogInputField(
                label: S.of(context).settingsConfirmPassword,
                controller: _confirmPasswordController,
                isObscured: _obscureConfirm,
                icon: Icons.lock_outline,
                onToggle: () =>
                    setDialogState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ],
          );
        },
      ),
      onConfirm: () {
        final oldPass = _oldPasswordController.text;
        final newPass = _newPasswordController.text;
        final confirmPass = _confirmPasswordController.text;

        if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).settingsFillAllFields),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        if (newPass != confirmPass) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).settingsPasswordNotMatch),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        context.read<SettingsController>().changePassword(
          oldPassword: oldPass,
          newPassword: newPass,
          confirmPassword: confirmPass,
          context: context,
        );
      },
    );
  }

  void _showForgotPasswordFlow() {
    _otpController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    int step = 1;
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final ctrl = context.read<SettingsController>();
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                step == 1
                    ? S.of(context).forgot_pw_title
                    : step == 2
                    ? S.of(context).settingsIdentityVerification
                    : S.of(context).settingsChangePassword,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (step == 1) ...[
                    Text(
                      S.of(context).settingsOtpSentToCurrentEmail,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      ctrl.userEmail,
                      style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                  if (step == 2) ...[
                    Text(
                      S.of(context).settingsEnterOtpSent,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildDialogInputField(
                      label: S.of(context).settingsOtpCode,
                      controller: _otpController,
                      icon: Icons.security,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                  if (step == 3) ...[
                    _buildDialogInputField(
                      label: S.of(context).settingsNewPassword,
                      controller: _newPasswordController,
                      isObscured: _obscureNew,
                      icon: Icons.lock_outline,
                      showStrength: true,
                      onToggle: () =>
                          setState(() => _obscureNew = !_obscureNew),
                      onChanged: (val) {
                        ctrl.checkPasswordStrength(val, context: context);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildDialogInputField(
                      label: S.of(context).settingsConfirmPassword,
                      controller: _confirmPasswordController,
                      isObscured: _obscureConfirm,
                      icon: Icons.lock_outline,
                      onToggle: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: Text(S.of(context).settingsCancel),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (step == 1) {
                            setState(() => isLoading = true);
                            bool sent = await ctrl.sendForgotPasswordOtp(
                              context: context,
                            );
                            if (!mounted) return; // 👈 🛡️ حماية هنا
                            setState(() => isLoading = false);
                            if (sent) setState(() => step = 2);
                          } else if (step == 2) {
                            if (_otpController.text.length != 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    S.of(context).settingsEnter6DigitOtp,
                                  ),
                                ),
                              );
                              return;
                            }
                            setState(() => isLoading = true);
                            bool verified = await ctrl.verifyForgotPasswordOtp(
                              _otpController.text,
                              context: context,
                            );
                            if (!mounted) return; // 👈 🛡️ حماية هنا
                            setState(() => isLoading = false);
                            if (verified) setState(() => step = 3);
                          } else if (step == 3) {
                            if (_newPasswordController.text !=
                                _confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    S.of(context).settingsPasswordNotMatch,
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            setState(() => isLoading = true);
                            bool success = await ctrl.resetPasswordWithOtp(
                              _otpController.text,
                              _newPasswordController.text,
                              context: context,
                            );
                            if (!mounted) return; // 👈 🛡️ حماية هنا
                            setState(() => isLoading = false);
                            if (success) {
                              Navigator.pop(dialogContext);
                            }
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          step == 1
                              ? S.of(context).settingsSendCode
                              : step == 2
                              ? S.of(context).settingsConfirm
                              : S.of(context).settingsUpdate,
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSecurityCard(SettingsController ctrl) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).settingsSecurityTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 15),
          _buildActionRow(
            S.of(context).settingsManagePassword,
            S.of(context).settingsLastChange(ctrl.lastPasswordChange),
            Icons.lock_outline,
            actionLabel: S.of(context).settingsChangePassword,
            onTap: _showPasswordDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayPreferencesCard(bool isMobile, SettingsController ctrl) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    return Container(
      constraints: BoxConstraints(minHeight: isMobile ? 0 : 250),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.remove_red_eye_outlined,
                color: AppColors.primaryTeal(context),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                S.of(context).settingsDisplayPrefs,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).settingsDarkMode,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                ),
              ),
              Switch(
                value: themeProvider.isDarkMode,
                onChanged: (v) {
                  themeProvider.toggleTheme(v);
                },
                activeColor: AppColors.primaryTeal(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context).settingsLanguage,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          _buildLanguageSelector(localeProvider, ctrl),
        ],
      ),
    );
  }

  Widget _buildDangerZoneCard() {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration().copyWith(
        color: isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFFFEEEE),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).settingsDangerZone,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            S.of(context).settingsDangerDesc,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _showDeactivateDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 42),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              S.of(context).settingsDeactivate,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomDialog({
    required String title,
    required Widget content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(child: content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).settingsCancel),
            ),
            ElevatedButton(
              onPressed: onConfirm,
              child: Text(S.of(context).settingsUpdate),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogInputField({
    required String label,
    required TextEditingController controller,
    bool isObscured = false,
    VoidCallback? onToggle,
    bool showStrength = false,
    Function(String)? onChanged,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final ctrl = context.read<SettingsController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: AppColors.textPrimary(context)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isObscured,
          onChanged: onChanged,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: isDarkMode
                ? const Color(0xFF363636)
                : const Color(0xFFF3F4F6),
            prefixIcon: Icon(icon, color: const Color(0xFFCBD5E0), size: 20),
            suffixIcon: onToggle != null
                ? IconButton(
                    icon: Icon(
                      isObscured ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                    ),
                    onPressed: onToggle,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (showStrength) ...[
          const SizedBox(height: 12),
          Text(
            ctrl.passwordStrengthText,
            style: TextStyle(
              color: ctrl.passwordStrengthColor ?? Colors.red,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: ctrl.passwordStrength,
            backgroundColor: const Color(0xFFE2E8F0),
            color: ctrl.passwordStrengthColor ?? Colors.red,
            minHeight: 6,
          ),
        ],
      ],
    );
  }

  Widget _buildActionRow(
    String title,
    String sub,
    IconData icon, {
    String? actionLabel,
    VoidCallback? onTap,
  }) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg(context),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryTeal(context)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                Text(
                  sub,
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (actionLabel != null)
            Text(
              actionLabel,
              style: TextStyle(
                color: AppColors.primaryTeal(context),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    ),
  );

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: AppColors.cardBg(context),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Widget _buildLanguageSelector(
  //   LocaleProvider lp,
  //   SettingsController ctrl,
  // ) => Container(
  //   padding: const EdgeInsets.symmetric(horizontal: 12),
  //   decoration: BoxDecoration(
  //     color: AppColors.scaffoldBg(context),
  //     borderRadius: BorderRadius.circular(8),
  //   ),
  //   child: DropdownButtonHideUnderline(
  //     child: DropdownButton<String>(
  //       value: lp.locale.languageCode,
  //       isExpanded: true,
  //       items: const [
  //         DropdownMenuItem(value: 'ar', child: Text("العربية")),
  //         DropdownMenuItem(value: 'en', child: Text("English")),
  //       ],
  //       onChanged: (v) async {
  //         if (v != null) {
  //           await lp.updateLanguage(v);
  //           ctrl.updateLanguageLocally(v);
  //           if (context.mounted) {
  //             context.read<StudentDashboardController>().fetchDashboardData(
  //               ctrl.currentStudentId,
  //               isSilent: true,
  //             );
  //           }
  //           if (context.mounted) {
  //             // تأكدي من اسم الكلاس، إذا سميتيه SubjectScreenProvider استخدميه بدال القديم
  //             context.read<SubjectScreenController>().fetchSubjectsData(
  //               ctrl.currentStudentId,
  //               context, // 👈 التعديل هنا: أضفنا الكونتكست كمتغير ثاني
  //             );
  //           }
  //         }
  //       },
  //     ),
  //   ),
  // );

  Widget _buildLanguageSelector(
    LocaleProvider lp,
    SettingsController ctrl,
  ) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: AppColors.scaffoldBg(context),
      borderRadius: BorderRadius.circular(8),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: lp.locale.languageCode,
        isExpanded: true,
        items: const [
          DropdownMenuItem(value: 'ar', child: Text("العربية")),
          DropdownMenuItem(value: 'en', child: Text("English")),
        ],
        onChanged: (v) async {
          if (v != null) {
            // 1. تحديث اللغة
            await lp.updateLanguage(v);
            ctrl.updateLanguageLocally(v);

            // 2. تحديث الداش بورد فقط (لأنه موجود دائماً في الخلفية)
            if (context.mounted) {
              context.read<StudentDashboardController>().fetchDashboardData(
                ctrl.currentStudentId,
                isSilent: true,
              );
            }

            // ❌ تم حذف استدعاء SubjectScreenController لأنه يسبب تعليق التطبيق ❌
          }
        },
      ),
    ),
  );

  void _showDeactivateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            S.of(context).settingsWarning,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Text(S.of(context).logoutConfirmationDesc),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                S.of(context).settingsCancel,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                Navigator.of(ctx).pop();
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // الانتقال بدون GetX
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SmartCorrectorUI(),
                    ),
                    (route) => false,
                  );
                }
              },
              child: Text(
                S.of(context).confirmLogout,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
