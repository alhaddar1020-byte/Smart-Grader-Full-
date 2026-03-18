import 'package:flutter/material.dart';
import 'dart:ui';
import '../core/colors.dart';
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

  bool _isValidEmail(String email) =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

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
      if (password.contains(RegExp(r'[0-9]'))) strength += 0.2;
    }
    setState(() {
      _strengthValue = strength;
      if (strength <= 0.3) {
        _strengthText = "ضعيفة";
        _strengthColor = Colors.red;
      } else if (strength <= 0.6) {
        _strengthText = "متوسطة";
        _strengthColor = Colors.orange;
      } else {
        _strengthText = "قوية";
        _strengthColor = Colors.green;
      }
    });
  }

  // --- دوال الـ API المحاكية ---
  Future<void> _updateProfileApi() async {
    setState(() {
      userName = _nameController.text;
      userEmail = _emailController.text;
      phoneNumber = _phoneController.text;
    });
    Navigator.pop(context);
    _showSnackBar("تم تحديث البيانات بنجاح", Colors.green);
  }

  Future<void> _changePasswordApi() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showSnackBar("كلمات المرور غير متطابقة", Colors.red);
      return;
    }
    Navigator.pop(context);
    _showSnackBar("تم تغيير كلمة المرور بنجاح", Colors.green);
    setState(() => lastPasswordChange = "الآن");
  }

  // --- تفعيل زر تعديل الملف الشخصي ---
  void _showEditProfileDialog() {
    _nameController.text = userName;
    _emailController.text = userEmail;
    _phoneController.text = phoneNumber;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: const Color(0xFF101828).withValues(alpha: 0.3),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return LayoutBuilder(
          builder: (context, dialogConstraints) {
            double dialogWidth = dialogConstraints.maxWidth < 600
                ? dialogConstraints.maxWidth * 0.9
                : 480;
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Align(
                alignment: Alignment.center,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: dialogWidth,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg(context),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "تعديل الملف الشخصي",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                            const SizedBox(height: 25),
                            _buildDialogInputField(
                              label: "الاسم الكامل",
                              controller: _nameController,
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 15),
                            _buildDialogInputField(
                              label: "البريد الإلكتروني",
                              controller: _emailController,
                              icon: Icons.alternate_email,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 15),
                            _buildDialogInputField(
                              label: "رقم الهاتف",
                              controller: _phoneController,
                              icon: Icons.phone_android_outlined,
                            ),
                            const SizedBox(height: 30),
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
                                    "حفظ",
                                    AppColors.primaryTeal(context),
                                    Colors.white,
                                    _updateProfileApi,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- تفعيل زر تغيير كلمة المرور ---
  void _showPasswordDialog() {
    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: const Color(0xFF101828).withValues(alpha: 0.3),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return LayoutBuilder(
          builder: (context, dialogConstraints) {
            double dialogWidth = dialogConstraints.maxWidth < 600
                ? dialogConstraints.maxWidth * 0.9
                : 480;
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
                          width: dialogWidth,
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg(context),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "تغيير كلمة المرور",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary(context),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                _buildDialogInputField(
                                  label: "كلمة المرور الحالية",
                                  controller: _oldPasswordController,
                                  isObscured: _obscureOld,
                                  icon: Icons.lock_outline,
                                  onToggle: () => setDialogState(
                                    () => _obscureOld = !_obscureOld,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                _buildDialogInputField(
                                  label: "كلمة المرور الجديدة",
                                  controller: _newPasswordController,
                                  isObscured: _obscureNew,
                                  icon: Icons.lock_outline,
                                  showStrength: true,
                                  onToggle: () => setDialogState(
                                    () => _obscureNew = !_obscureNew,
                                  ),
                                  onChanged: (val) => setDialogState(
                                    () => _checkPasswordStrength(val),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                _buildDialogInputField(
                                  label: "تأكيد كلمة المرور",
                                  controller: _confirmPasswordController,
                                  isObscured: _obscureConfirm,
                                  icon: Icons.lock_outline,
                                  onToggle: () => setDialogState(
                                    () => _obscureConfirm = !_obscureConfirm,
                                  ),
                                ),
                                const SizedBox(height: 30),
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
                                        "تحديث",
                                        AppColors.primaryTeal(context),
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
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.secondaryTeal(context),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            // تطبيق القاعدة: 16 للجوال و 30 للتابلت والويب
            bool isMobile = width < 750;
            double sidePadding = isMobile ? 16.0 : 30.0;

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: sidePadding,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "إعدادات النظام",
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: isMobile
                            ? _buildMobileLayout()
                            : _buildWebLayout(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWebLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildProfileCard(false),
              const SizedBox(height: 20),
              _buildSecurityCard(),
            ],
          ),
        ),
        const SizedBox(width: 25),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildDisplayPreferencesCard(false),
              const SizedBox(height: 20),
              _buildDangerZoneCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildProfileCard(true),
        const SizedBox(height: 20),
        _buildSecurityCard(),
        const SizedBox(height: 20),
        _buildDisplayPreferencesCard(true),
        const SizedBox(height: 20),
        _buildDangerZoneCard(),
      ],
    );
  }

  Widget _buildProfileCard(bool isMobile) {
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
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 25),
          isMobile
              ? Column(
                  children: [
                    _buildDynamicField("الاسم", userName, Icons.person_outline),
                    const SizedBox(height: 15),
                    _buildDynamicField(
                      "رقم الهاتف",
                      phoneNumber,
                      Icons.phone_outlined,
                    ),
                    const SizedBox(height: 15),
                    _buildDynamicField(
                      "البريد الالكتروني",
                      userEmail,
                      Icons.email_outlined,
                    ),
                    const SizedBox(height: 15),
                    _buildDynamicField(
                      "المستوى",
                      educationLevel,
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
                    const SizedBox(height: 25),
                    Row(
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
                  ],
                ),
          const SizedBox(height: 25),
          Align(
            alignment: Alignment.centerLeft,
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
              color: AppColors.textPrimary(context),
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

  Widget _buildDisplayPreferencesCard(bool isMobile) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                "تفضيلات العرض",
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
                "الوضع الداكن",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                ),
              ),
              Switch(
                value: themeProvider.isDarkMode,
                onChanged: (v) => themeProvider.toggleTheme(v),
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
          const Text(
            "منطقة الخطر",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            "سيتم حذف حسابك وجميع البيانات المرتبطة به بشكل نهائي.",
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 42),
            ),
            child: const Text(
              "إلغاء تنشيط الحساب",
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
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
          style: TextStyle(color: AppColors.textPrimary(context)),
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
            "قوة كلمة المرور: $_strengthText",
            style: TextStyle(
              color: _strengthColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: _strengthValue,
            backgroundColor: const Color(0xFFE2E8F0),
            color: _strengthColor,
            minHeight: 6,
          ),
        ],
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

  Widget _buildDynamicField(String label, String value, IconData icon) {
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary(context),
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

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: AppColors.cardBg(context),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  Widget _buildEditButton() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.primaryTeal(context),
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Text(
      "تعديل البيانات",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    ),
  );

  Widget _buildLanguageDropdown() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: AppColors.scaffoldBg(context),
      borderRadius: BorderRadius.circular(8),
    ),
    child: DropdownButton<String>(
      value: selectedLanguage,
      isExpanded: true,
      underline: const SizedBox(),
      items: ["العربية", "English"]
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(fontSize: 13)),
            ),
          )
          .toList(),
      onChanged: (v) => setState(() => selectedLanguage = v!),
    ),
  );

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
}
