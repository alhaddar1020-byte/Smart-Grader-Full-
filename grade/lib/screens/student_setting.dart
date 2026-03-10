import 'package:flutter/material.dart';
import 'dart:ui';
import '../core/colors.dart'; // تأكدي من المسار الصحيح لملف الألوان
import 'package:provider/provider.dart';
import '../core/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  String userName = "احمد محمد السعيد";
  String userEmail = "Rogaya@gradesys.edu";
  String phoneNumber = "4567 123 50 966+";
  String educationLevel = "الصف الثاني ثانوي- علمي";
  bool isDarkMode = false;
  String selectedLanguage = "العربية";
  String lastPasswordChange = "منذ 3 أشهر";

  double _strengthValue = 0.0;
  String _strengthText = "ضعيفة جداً";
  Color _strengthColor = Colors.red;

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _updateProfileApi() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      userName = _nameController.text;
      userEmail = _emailController.text;
      phoneNumber = _phoneController.text;
    });
    Navigator.pop(context);
    _showSnackBar("تم تحديث البيانات الشخصية بنجاح", Colors.green);
  }

  Future<void> _changePasswordApi() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showSnackBar("كلمات المرور الجديدة غير متطابقة", Colors.red);
      return;
    }
    await Future.delayed(const Duration(seconds: 1));
    _handleSuccess();
  }

  void _handleSuccess() {
    Navigator.pop(context);
    _showSnackBar("تم تحديث كلمة المرور بنجاح", Colors.green);
    setState(() {
      lastPasswordChange = "الآن";
    });
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  void _checkPasswordStrength(String password) {
    double strength = 0;
    if (password.isNotEmpty) {
      if (password.length >= 8) strength += 0.3;
      if (password.contains(RegExp(r'[A-Z]'))) strength += 0.2;
      if (password.contains(RegExp(r'[a-z]'))) strength += 0.2;
      if (password.contains(RegExp(r'[0-9]'))) strength += 0.2;
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.1;
    }
    setState(() {
      _strengthValue = strength;
      if (strength <= 0.3) {
        _strengthText = "ضعيفة";
        _strengthColor = Colors.red;
      } else if (strength <= 0.7) {
        _strengthText = "متوسطة";
        _strengthColor = Colors.orange;
      } else {
        _strengthText = "قوية";
        _strengthColor = Colors.green;
      }
    });
  }

  void _showEditProfileDialog() {
    _nameController.text = userName;
    _emailController.text = userEmail;
    _phoneController.text = phoneNumber;
    String? dialogErrorMessage;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: const Color(0xFF101828).withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Align(
            alignment: Alignment.center,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Material(
                color: Colors.transparent,
                child: StatefulBuilder(
                  builder: (context, setDialogState) {
                    return Container(
                      width: 480,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg(context), // تعديل اللون
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "تعديل الملف الشخصي",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary(
                                  context,
                                ), // تعديل اللون
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildDialogInputField(
                              label: "الاسم الكامل",
                              controller: _nameController,
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 20),
                            _buildDialogInputField(
                              label: "البريد الإلكتروني",
                              controller: _emailController,
                              icon: Icons.alternate_email,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 20),
                            _buildDialogInputField(
                              label: "رقم الهاتف",
                              controller: _phoneController,
                              icon: Icons.phone_android_outlined,
                            ),
                            if (dialogErrorMessage != null) ...[
                              const SizedBox(height: 15),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.red.shade200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        dialogErrorMessage!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 40),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildActionBtn(
                                    "إلغاء",
                                    const Color(0xFFF7FAFC),
                                    const Color(0xFF718096),
                                    () => Navigator.pop(context),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildActionBtn(
                                    "حفظ التغييرات",
                                    AppColors.primaryTeal(
                                      context,
                                    ), // تعديل اللون
                                    Colors.white,
                                    () {
                                      if (!_isValidEmail(
                                        _emailController.text,
                                      )) {
                                        setDialogState(() {
                                          dialogErrorMessage =
                                              "يرجى إدخال بريد إلكتروني صالح";
                                        });
                                      } else {
                                        setDialogState(() {
                                          dialogErrorMessage = null;
                                        });
                                        _updateProfileApi();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPasswordDialog() {
    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    setState(() {
      _strengthValue = 0.0;
      _strengthText = "ضعيفة جداً";
      _strengthColor = Colors.red;
      _obscureOld = true;
      _obscureNew = true;
      _obscureConfirm = true;
    });

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: const Color(0xFF101828).withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Align(
            alignment: Alignment.center,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Material(
                color: Colors.transparent,
                child: StatefulBuilder(
                  builder: (context, setDialogState) {
                    return _buildFigmaDialogContent(setDialogState);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.secondaryTeal(context), // تعديل اللون
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "إعدادات النظام",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context), // تعديل اللون
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Expanded(flex: 4, child: _buildProfileCard()),
                            const SizedBox(height: 20),
                            Expanded(flex: 2, child: _buildSecurityCard()),
                          ],
                        ),
                      ),
                      const SizedBox(width: 25),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Expanded(child: _buildDisplayPreferencesCard()),
                            const SizedBox(height: 20),
                            Expanded(child: _buildDangerZoneCard()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFigmaDialogContent(StateSetter setDialogState) {
    return Container(
      width: 480,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context), // تعديل اللون
        borderRadius: BorderRadius.circular(30),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "تغيير كلمة المرور",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context), // تعديل اللون
              ),
            ),
            const SizedBox(height: 32),
            _buildDialogInputField(
              label: "كلمة المرور الحالية",
              controller: _oldPasswordController,
              isObscured: _obscureOld,
              icon: Icons.lock_outline,
              onToggle: () => setDialogState(() => _obscureOld = !_obscureOld),
            ),
            const SizedBox(height: 20),
            _buildDialogInputField(
              label: "كلمة المرور الجديدة",
              controller: _newPasswordController,
              isObscured: _obscureNew,
              icon: Icons.lock_outline,
              showStrength: true,
              onToggle: () => setDialogState(() => _obscureNew = !_obscureNew),
              onChanged: (val) =>
                  setDialogState(() => _checkPasswordStrength(val)),
            ),
            const SizedBox(height: 20),
            _buildDialogInputField(
              label: "تأكيد كلمة المرور الجديدة",
              controller: _confirmPasswordController,
              isObscured: _obscureConfirm,
              icon: Icons.lock_outline,
              onToggle: () =>
                  setDialogState(() => _obscureConfirm = !_obscureConfirm),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: _buildActionBtn(
                    "إلغاء",
                    const Color(0xFFF7FAFC),
                    const Color(0xFF718096),
                    () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionBtn(
                    "حفظ التغييرات",
                    AppColors.primaryTeal(context), // تعديل اللون
                    Colors.white,
                    _changePasswordApi,
                  ),
                ),
              ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary(context),
          ), // تعديل اللون
        ),
        const SizedBox(height: 8),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF2D3748)
                : const Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.secondaryTeal(context).withOpacity(0.5),
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: isObscured,
            onChanged: onChanged,
            keyboardType: keyboardType,

            style: TextStyle(color: AppColors.TherdTeal(context)),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.secondaryTeal(context),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 15,
              ),
              prefixIcon: Icon(
                icon ?? Icons.edit_outlined,
                size: 20,
                color: const Color(0xFFCBD5E0),
              ),
              suffixIcon: onToggle != null
                  ? IconButton(
                      icon: Icon(
                        isObscured
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: const Color(0xFFCBD5E0),
                      ),
                      onPressed: onToggle,
                    )
                  : null,
            ),
          ),
        ),
        if (showStrength) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "قوة كلمة المرور: $_strengthText",
                style: TextStyle(
                  color: _strengthColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _strengthValue,
              backgroundColor: const Color(0xFFE2E8F0),
              color: _strengthColor,
              minHeight: 6,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "بيانات الملف الشخصي",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context), // تعديل اللون
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildDynamicField(
                    "الاسم",
                    userName,
                    Icons.person_outline,
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: _buildDynamicField(
                    "رقم الهاتف",
                    phoneNumber,
                    Icons.phone_outlined,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildDynamicField(
                    "البريد الالكتروني",
                    userEmail,
                    Icons.email_outlined,
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: _buildDynamicField(
                    "المستوى",
                    educationLevel,
                    Icons.school_outlined,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: _showEditProfileDialog,
              child: _buildEditButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الأمان والمصادقة",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context), // تعديل اللون
            ),
          ),
          const SizedBox(height: 15),
          _buildActionRow(
            "إدارة كلمة المرور",
            "آخر تغيير: $lastPasswordChange",
            Icons.lock_outline,
            actionLabel: "تغيير كلمة المرور",
            onTap: _showPasswordDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicField(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: AppColors.textPrimary(context), // تعديل اللون
          ),
        ),
        // -----------------------------------------------------------------------
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF2D3748)
                : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary(context)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.TherdTeal(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionBtn(
    String text,
    Color bg,
    Color txtColor,
    VoidCallback onTap,
  ) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        minimumSize: const Size(0, 48),
      ),
      child: Text(
        text,
        style: TextStyle(color: txtColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: AppColors.cardBg(context), // تعديل اللون
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  Widget _buildEditButton() => Container(
    width: 160,
    height: 36,
    decoration: BoxDecoration(
      color: AppColors.primaryTeal(context), // تعديل اللون
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Center(
      child: Text(
        "تعديل الملف الشخصي",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    ),
  );

  Widget _buildDisplayPreferencesCard() {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
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
                "تفضيلات العرض",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context), // تعديل اللون
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "الوضع الداكن",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                ),
              ),
              Switch(
                // نستخدم القيمة من الـ Provider
                value: themeProvider.isDarkMode,
                onChanged: (v) {
                  // نأمر الـ Provider بتغيير الثيم للتطبيق بالكامل
                  themeProvider.toggleTheme(v);
                },
                activeColor: AppColors.primaryTeal(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "اللغة",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          _buildLanguageDropdown(),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D3748) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: selectedLanguage,
        isExpanded: true,
        dropdownColor: AppColors.cardBg(context),
        underline: const SizedBox(),
        items: ["العربية", "English"]
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.TherdTeal(context),
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() => selectedLanguage = v!),
      ),
    );
  }

  Widget _buildDangerZoneCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration().copyWith(
        color: isDarkMode ? const Color(0xFF441A1A) : const Color(0xFFFEF2F2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "منطقة الخطر",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.red,
            ),
          ),
          const Spacer(),
          Text(
            " سيتم حذف حسابك وجميع البيانات المرتبطة به بشكل نهائي. لا يمكن التراجع عن هذا الإجراء.",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary(context),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFB2C36),
              minimumSize: const Size(double.infinity, 42),
            ),
            child: const Text(
              "إلغاء تنشيط الحساب",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(
    String title,
    String sub,
    IconData icon, {
    String? actionLabel,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF2D3748) : const Color(0xFFF9FAFB),
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
                      color: AppColors.TherdTeal(context),
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
  }
}
