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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.secondaryTeal(context),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            bool isMobile = width < 800; // النقطة المكسورة

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
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
                            ? _buildMobileLayout(isMobile)
                            : _buildWebLayout(isMobile),
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

  // وضع الويب (Row) - نفس تنسيقك القديم
  Widget _buildWebLayout(isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildProfileCard(false),
              const SizedBox(height: 20),
              _buildSecurityCard(isMobile),
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
              _buildDangerZoneCard(isMobile),
            ],
          ),
        ),
      ],
    );
  }

  // وضع الجوال (Column)
  Widget _buildMobileLayout(isMobile) {
    return Column(
      children: [
        _buildProfileCard(true),
        const SizedBox(height: 20),
        _buildSecurityCard(isMobile),
        const SizedBox(height: 20),
        _buildDisplayPreferencesCard(true),
        const SizedBox(height: 20),
        _buildDangerZoneCard(isMobile),
      ],
    );
  }

  Widget _buildProfileCard(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "بيانات الملف الشخصي",
            style: TextStyle(
              fontSize: isMobile ? 15 : 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 15),
          isMobile
              ? Column(
                  children: [
                    _buildDynamicField(
                      "الاسم",
                      userName,
                      Icons.person_outline,
                      isMobile,
                    ),
                    const SizedBox(height: 10),
                    _buildDynamicField(
                      "رقم الهاتف",
                      phoneNumber,
                      Icons.phone_outlined,
                      isMobile,
                    ),
                    const SizedBox(height: 10),
                    _buildDynamicField(
                      "البريد الالكتروني",
                      userEmail,
                      Icons.email_outlined,
                      isMobile,
                    ),
                    const SizedBox(height: 10),
                    _buildDynamicField(
                      "المستوى",
                      educationLevel,
                      Icons.school_outlined,
                      isMobile,
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
                            isMobile,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: _buildDynamicField(
                            "رقم الهاتف",
                            phoneNumber,
                            Icons.phone_outlined,
                            isMobile,
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
                            isMobile,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: _buildDynamicField(
                            "المستوى",
                            educationLevel,
                            Icons.school_outlined,
                            isMobile,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: _showEditProfileDialog, // تفعيل الزر
              child: _buildEditButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard(isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الأمان والمصادقة",
            style: TextStyle(
              fontSize: isMobile ? 15 : 20,
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
            onTap: _showPasswordDialog, // تفعيل الزر
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

  Widget _buildDangerZoneCard(isMobile) {
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
          const SizedBox(height: 15),
          Text(
            "سيتم حذف حسابك وجميع البيانات المرتبطة به بشكل نهائي ولا يمكن الرجوع.",
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: isMobile ? 13 : 13,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
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

  // الدوال المساعدة (نفس كودك الأصلي تماماً)
  Widget _buildDynamicField(
    String label,
    String value,
    IconData icon,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 12 : 13,
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
                    fontSize: isMobile ? 14 : 16,
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

  Widget _buildLanguageDropdown() {
    return Container(
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

  // دوال الـ Dialogs والـ API...
  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  void _showEditProfileDialog() {
    /* الكود الأصلي حقك هنا */
  }
  void _showPasswordDialog() {
    /* الكود الأصلي حقك هنا */
  }
  Future<void> _updateProfileApi() async {
    /* الكود الأصلي حقك هنا */
  }
  Future<void> _changePasswordApi() async {
    /* الكود الأصلي حقك هنا */
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      child: Text(
        text,
        style: TextStyle(color: txtColor, fontWeight: FontWeight.bold),
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
    return Column(); /* الكود الأصلي حقك هنا */
  }

  Widget _buildFigmaDialogContent(StateSetter setDialogState) {
    return Container(); /* الكود الأصلي حقك هنا */
  }
}
