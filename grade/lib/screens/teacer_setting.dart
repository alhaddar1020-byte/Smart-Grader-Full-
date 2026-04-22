import 'package:flutter/material.dart';
import 'dart:ui';
import '../core/colors.dart';
import 'package:provider/provider.dart';
import '../core/theme_provider.dart';
import '../core/locale_provider.dart';
import '../generated/l10n.dart';
import 'teacher_dashboard.dart'; 
import 'teacher_matearial.dart' hide HeaderWidget;
import 'grading.dart' hide HeaderWidget;
import 'exam_page.dart' hide HeaderWidget;
import 'review_exam_screen.dart';
import 'ExamManagementPage.dart';
import 'teacher_profile_settings_page.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 5;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // بيانات المعلم
  String userName = "أ. منار خالد";
  String userEmail = "manar@gradesys.edu";
  String phoneNumber = "+966 50 123 4567";
  String departmentName = "قسم تقنية المعلومات";
  String lastPasswordChange = "منذ 3 أشهر";

  // متغيرات قوة كلمة المرور
  double _strengthValue = 0.0;
  String _strengthText = "";
  Color _strengthColor = Colors.red;
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  void _handleNavigation(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);

    Widget? targetPage;
    if (index == 0) targetPage = const DashboardScreen();
    if (index == 1) targetPage = const ExamManagementPage();
    if (index == 2) targetPage = const Material1();
    if (index == 3) targetPage = const GradingPage();
    if (index == 4) targetPage = const ReviewExamPage();
    if (index == 5) targetPage = const SettingsScreen();

    if (targetPage != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => targetPage!));
    }
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
        _strengthText = S.of(context).settingsStrengthWeak;
        _strengthColor = Colors.red;
      } else if (strength <= 0.6) {
        _strengthText = S.of(context).settingsStrengthMedium;
        _strengthColor = Colors.orange;
      } else {
        _strengthText = S.of(context).settingsStrengthStrong;
        _strengthColor = Colors.green;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 850;
      bool isTablet = constraints.maxWidth >= 850 && constraints.maxWidth < 1150;

      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.secondaryTeal(context),
        drawer: isMobile ? Drawer(width: 260, child: SafeArea(child: CustSidebar(selectedIndex: _selectedIndex, onItemSelected: _handleNavigation))) : null,
        body: Row(
          children: [
            if (!isMobile) CustSidebar(selectedIndex: _selectedIndex, isCompact: isTablet, onItemSelected: _handleNavigation),
            Expanded(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 15 : 40, vertical: 30),
                  child: Column(
                    children: [
                      if (isMobile) _buildMobileMenuBtn(),
                      _buildPageHeader(),
                      const SizedBox(height: 30),
                      isMobile ? _buildMobileLayout() : _buildWebLayout(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Widget _buildPageHeader() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
  //     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //           Text(S.of(context).settings, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
  //           const SizedBox(height: 4),
  //           Text(S.of(context).settings_subtitle, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 14)),
  //         ]),
  //         Row(children: [_iconBtn(Icons.notifications_none), const SizedBox(width: 10), _iconBtn(Icons.person_outline)])
  //       ],
  //     ),
  //   );
  // }

  // Widget _iconBtn(IconData icon) => Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle), child: Icon(icon, color: AppColors.primaryTeal(context)));
Widget _buildPageHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16), 
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Text(S.of(context).settings, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
              const SizedBox(height: 4),
              Text(S.of(context).settings_subtitle, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 14)),
            ]
          ),
          Row(
            children: [
              _iconBtn(Icons.notifications_none, onTap: () {
                // أكشن التنبيهات
              }),
              const SizedBox(width: 10),
              
              // ربط أيقونة الشخص بصفحة ProfileSettingsPage
              _iconBtn(Icons.person_outline, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileSettingsPage()),
                );
              }),
            ]
          )
        ],
      ),
    );
  }

  // دالة الأيقونة المحدثة لتكون قابلة للضغط وتغيير شكل الماوس
  Widget _iconBtn(IconData icon, {VoidCallback? onTap}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // تظهر يد الماوس عند الوقوف عليها (مهم للويب)
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8), 
          decoration: BoxDecoration(
            color: AppColors.secondaryTeal(context), 
            shape: BoxShape.circle
          ), 
          child: Icon(icon, color: AppColors.primaryTeal(context))
        ),
      ),
    );
  }
  Widget _buildMobileMenuBtn() => Align(alignment: Alignment.centerRight, child: IconButton(icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)), onPressed: () => _scaffoldKey.currentState?.openDrawer()));

  Widget _buildWebLayout() => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 2, child: Column(children: [_buildProfileCard(false), const SizedBox(height: 25), _buildSecurityCard()])),
        const SizedBox(width: 25),
        Expanded(flex: 1, child: Column(children: [_buildDisplayPreferencesCard(), const SizedBox(height: 25), _buildDangerZoneCard()])),
      ]);

  Widget _buildMobileLayout() => Column(children: [_buildProfileCard(true), const SizedBox(height: 20), _buildSecurityCard(), const SizedBox(height: 20), _buildDisplayPreferencesCard(), const SizedBox(height: 20), _buildDangerZoneCard()]);

  Widget _buildProfileCard(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(30), decoration: _cardDecoration(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(S.of(context).settingsProfileData, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
        const SizedBox(height: 30),
        if (isMobile)
          Column(children: [_buildInfoField(S.of(context).settingsFullName, userName, Icons.person_outline), const SizedBox(height: 15), _buildInfoField(S.of(context).department, departmentName, Icons.business_outlined), const SizedBox(height: 15), _buildInfoField(S.of(context).settingsEmail, userEmail, Icons.email_outlined), const SizedBox(height: 15), _buildInfoField(S.of(context).settingsPhone, phoneNumber, Icons.phone_android_outlined)])
        else
          Column(children: [
            Row(children: [Expanded(child: _buildInfoField(S.of(context).settingsFullName, userName, Icons.person_outline)), const SizedBox(width: 20), Expanded(child: _buildInfoField(S.of(context).department, departmentName, Icons.business_outlined))]),
            const SizedBox(height: 20),
            Row(children: [Expanded(child: _buildInfoField(S.of(context).settingsEmail, userEmail, Icons.email_outlined)), const SizedBox(width: 20), Expanded(child: _buildInfoField(S.of(context).settingsPhone, phoneNumber, Icons.phone_android_outlined))]),
          ]),
        const SizedBox(height: 35),
        Center(child: _buildPrimaryBtn(S.of(context).settingsEditProfile, _showEditProfileDialog)),
      ]),
    );
  }

  // --- نافذة تعديل كافة البيانات ---
  void _showEditProfileDialog() {
    _nameController.text = userName;
    _emailController.text = userEmail;
    _phoneController.text = phoneNumber;
    showGeneralDialog(
      context: context, barrierDismissible: true, barrierLabel: "", barrierColor: Colors.black.withValues(alpha: 0.4),
      pageBuilder: (ctx, anim1, anim2) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Center(
          child: Material(color: Colors.transparent, child: Container(
            width: 480, padding: const EdgeInsets.all(30), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(S.of(context).settingsEditProfile, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),
              _buildDialogInput(S.of(context).settingsFullName, _nameController, Icons.person_outline),
              const SizedBox(height: 15),
              _buildDialogInput(S.of(context).settingsEmail, _emailController, Icons.alternate_email, kType: TextInputType.emailAddress),
              const SizedBox(height: 15),
              _buildDialogInput(S.of(context).settingsPhone, _phoneController, Icons.phone_android_outlined),
              const SizedBox(height: 30),
              Row(children: [
                Expanded(child: _buildSecondaryBtn(S.of(context).settingsCancel, () => Navigator.pop(context))),
                const SizedBox(width: 12),
                Expanded(child: _buildPrimaryBtn(S.of(context).settingsSave, () {
                  setState(() { userName = _nameController.text; userEmail = _emailController.text; phoneNumber = _phoneController.text; });
                  Navigator.pop(context);
                })),
              ])
            ])),
          )),
        ),
      ),
    );
  }

  Widget _buildSecurityCard() => Container(padding: const EdgeInsets.all(25), decoration: _cardDecoration(), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(S.of(context).settingsSecurityTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 20), _buildActionRow(S.of(context).settingsManagePassword, S.of(context).settingsLastChange(lastPasswordChange), Icons.lock_outline, onTap: _showPasswordDialog)]));

  // --- نافذة تغيير كلمة المرور (التصميم الأصلي المطلب) ---
  void _showPasswordDialog() {
    _oldPassController.clear(); _newPassController.clear(); _confirmPassController.clear();
    showGeneralDialog(
      context: context, barrierDismissible: true, barrierLabel: "", barrierColor: Colors.black.withValues(alpha: 0.4),
      pageBuilder: (ctx, anim1, anim2) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Center(
          child: Material(color: Colors.transparent, child: StatefulBuilder(builder: (context, setDialogState) {
            return Container(
              width: 480, padding: const EdgeInsets.all(30), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(S.of(context).settingsChangePassword, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 25),
                _buildDialogInput(S.of(context).settingsCurrentPassword, _oldPassController, Icons.lock_outline, isPass: true, isObs: _obscureOld, onToggle: () => setDialogState(() => _obscureOld = !_obscureOld)),
                const SizedBox(height: 15),
                _buildDialogInput(S.of(context).settingsNewPassword, _newPassController, Icons.lock_outline, isPass: true, isObs: _obscureNew, onToggle: () => setDialogState(() => _obscureNew = !_obscureNew), onChanged: (v) => setDialogState(() => _checkPasswordStrength(v))),
                // مؤشر القوة
                const SizedBox(height: 12),
                Align(alignment: Alignment.centerRight, child: Text(S.of(context).settingsStrengthLabel(_strengthText), style: TextStyle(color: _strengthColor, fontSize: 11, fontWeight: FontWeight.bold))),
                const SizedBox(height: 5),
                LinearProgressIndicator(value: _strengthValue, backgroundColor: const Color(0xFFE2E8F0), color: _strengthColor, minHeight: 6),
                const SizedBox(height: 15),
                _buildDialogInput(S.of(context).settingsConfirmPassword, _confirmPassController, Icons.lock_outline, isPass: true, isObs: _obscureConfirm, onToggle: () => setDialogState(() => _obscureConfirm = !_obscureConfirm)),
                const SizedBox(height: 30),
                Row(children: [
                  Expanded(child: _buildSecondaryBtn(S.of(context).settingsCancel, () => Navigator.pop(context))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildPrimaryBtn(S.of(context).settingsUpdate, () => Navigator.pop(context))),
                ])
              ])),
            );
          })),
        ),
      ),
    );
  }

  Widget _buildDisplayPreferencesCard() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    return Container(padding: const EdgeInsets.all(25), decoration: _cardDecoration(), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(Icons.visibility_outlined, size: 20, color: AppColors.primaryTeal(context)), const SizedBox(width: 10), Text(S.of(context).settingsDisplayPrefs, style: const TextStyle(fontWeight: FontWeight.bold))]),
      const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(S.of(context).settingsDarkMode), Switch(value: themeProvider.isDarkMode, onChanged: (v) => themeProvider.toggleTheme(v), activeColor: AppColors.primaryTeal(context))]),
      const SizedBox(height: 20),
      Text(S.of(context).settingsLanguage, style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      _buildLanguageDropdown(localeProvider),
    ]));
  }

  Widget _buildDangerZoneCard() => Container(padding: const EdgeInsets.all(25), decoration: _cardDecoration().copyWith(color: const Color(0xFFFFEEEE)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(S.of(context).settingsDangerZone, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w900, fontSize: 18)), const SizedBox(height: 10), Text(S.of(context).settingsDangerDesc, style: const TextStyle(fontSize: 12, color: Colors.redAccent)), const SizedBox(height: 20), ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size(double.infinity, 45), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(S.of(context).settingsDeactivate, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))]));

  BoxDecoration _cardDecoration() => BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))]);

  Widget _buildInfoField(String label, String value, IconData icon) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), const SizedBox(height: 8), Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(12)), child: Row(children: [Icon(icon, size: 18, color: Colors.grey), const SizedBox(width: 10), Expanded(child: Text(value, style: const TextStyle(fontSize: 14)))]))]);

  Widget _buildDialogInput(String label, TextEditingController ctrl, IconData icon, {bool isPass = false, bool? isObs, VoidCallback? onToggle, Function(String)? onChanged, TextInputType kType = TextInputType.text}) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(controller: ctrl, obscureText: isObs ?? false, onChanged: onChanged, keyboardType: kType, decoration: InputDecoration(prefixIcon: Icon(icon, size: 20, color: const Color(0xFFCBD5E0)), suffixIcon: isPass ? IconButton(icon: Icon(isObs! ? Icons.visibility_off : Icons.visibility, size: 20), onPressed: onToggle) : null, filled: true, fillColor: const Color(0xFFF3F4F6), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
      ]);

  Widget _buildPrimaryBtn(String text, VoidCallback onTap) => ElevatedButton(onPressed: onTap, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal(context), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))), child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));

  Widget _buildSecondaryBtn(String text, VoidCallback onTap) => OutlinedButton(onPressed: onTap, style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)), side: const BorderSide(color: Color(0xFFE2E8F0))), child: Text(text, style: const TextStyle(color: Color(0xFF718096), fontWeight: FontWeight.bold)));

  Widget _buildLanguageDropdown(LocaleProvider lp) => Container(padding: const EdgeInsets.symmetric(horizontal: 15), decoration: BoxDecoration(color: AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(12)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: lp.locale.languageCode, isExpanded: true, items: const [DropdownMenuItem(value: 'ar', child: Text("العربية")), DropdownMenuItem(value: 'en', child: Text("English"))], onChanged: (v) => lp.setLocale(v!))));

  Widget _buildActionRow(String title, String sub, IconData icon, {required VoidCallback onTap}) => InkWell(onTap: onTap, child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(15)), child: Row(children: [Icon(icon, color: AppColors.primaryTeal(context)), const SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey))])), Text(S.of(context).settingsChangePassword, style: TextStyle(color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold, fontSize: 12))])));
}