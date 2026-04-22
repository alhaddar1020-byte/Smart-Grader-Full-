import 'package:flutter/material.dart';
import 'dart:ui';
import '../core/colors.dart';
import '../generated/l10n.dart'; // مكتبة الترجمة الخاصة بك

class ProfileSettingsPageStudent extends StatefulWidget {
  const ProfileSettingsPageStudent({super.key});

  @override
  State<ProfileSettingsPageStudent> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPageStudent> {
  // المتحكمات (Controllers)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // تعبئة البيانات الأولية (يمكن جلبها من الـ Database لاحقاً)
    _nameController.text = "أ. منار خالد";
    _emailController.text = "manar@gradesys.edu";
    _phoneController.text = "+966 50 123 4567";
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 850;

      return Scaffold(
        backgroundColor: const Color(0xFFE0F7F6), // الخلفية الفاتحة التي اخترتها
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 60, 
                vertical: 40),
            child: Column(
              children: [
                _buildTopHeader(),
                const SizedBox(height: 40),
                _buildMainCard(isMobile),
              ],
            ),
          ),
        ),
      );
    });
  }

  // الجزء العلوي مع زر الرجوع
  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _iconBtn(Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.pop(context)),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).profile_settings_title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTeal(context).withOpacity(0.85),
                  ),
                ),
                Text(
                  S.of(context).profile_settings_subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        _iconBtn(Icons.notifications_none),
      ],
    );
  }

  
  Widget _buildMainCard(bool isMobile) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 25,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          children: [
            // الغلاف العلوي (Cover)
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.primaryTeal(context).withOpacity(0.68),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
            ),
            // محتوى البطاقة المرتفع
            Transform.translate(
              offset: const Offset(0, -60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  // تعديل المحاذاة لتكون في الجنب الأيمن (End في RTL)
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    _buildAvatarStack(),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 20),
                      child: Text(
                        S.of(context).doctor_name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildInputGrid(isMobile),
                    const SizedBox(height: 40),
                    _buildSaveButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarStack() {
    // جلب أول حرف من الإيميل وتحويله لكبير
    String firstLetter = _emailController.text.isNotEmpty 
        ? _emailController.text[0].toUpperCase() 
        : "U"; 

    return Stack(
      alignment: Alignment.bottomLeft, // أيقونة الكاميرا تبقى في الزاوية
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: CircleAvatar(
            radius: 70,
            backgroundColor: AppColors.primaryTeal(context).withOpacity(0.1),
            // هنا نضع الحرف بدلاً من الصورة الشبكية
            child: Text(
              firstLetter,
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryTeal(context),
              ),
            ),
          ),
        ),
        // أيقونة الكاميرا
        Positioned(
          bottom: 5,
          left: 5,
          child: _iconBtn(Icons.camera_alt_outlined, isSmall: true),
        ),
      ],
    );
  }
  Widget _buildInputGrid(bool isMobile) {
  return Column(
    children: [
      if (!isMobile) ...[
        Row(
          children: [
            Expanded(child: _buildLabeledField(S.of(context).settingsFullName, _nameController, Icons.person_outline)),
            const SizedBox(width: 30),
            Expanded(child: _buildLabeledField(S.of(context).settingsEmail, _emailController, Icons.email_outlined)),
          ],
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            // ✅ تم تغيير القسم إلى المستوى هنا
            Expanded(child: _buildLabeledField(S.of(context).level_label, TextEditingController(text: S.of(context).level_example), Icons.school_outlined)),
            const SizedBox(width: 30),
            Expanded(child: _buildLabeledField(S.of(context).settingsPhone, _phoneController, Icons.phone_android_outlined)),
          ],
        ),
      ] else ...[
        _buildLabeledField(S.of(context).settingsFullName, _nameController, Icons.person_outline),
        const SizedBox(height: 20),
        _buildLabeledField(S.of(context).settingsEmail, _emailController, Icons.email_outlined),
        const SizedBox(height: 20),
        // ✅ إضافة المستوى في نسخة الموبايل أيضاً
        _buildLabeledField(S.of(context).level_label, TextEditingController(text: S.of(context).level_example), Icons.school_outlined),
        const SizedBox(height: 20),
        _buildLabeledField(S.of(context).settingsPhone, _phoneController, Icons.phone_android_outlined),
      ],
      const SizedBox(height: 25),
      _buildLabeledField(S.of(context).bio_label, _bioController, null, maxLines: 3, hint: S.of(context).bio_hint),
    ],
  );
}
  Widget _buildLabeledField(String label, TextEditingController ctrl, IconData? icon, {int maxLines = 1, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, color: Colors.grey.shade400, size: 20) : null,
            filled: true,
            fillColor: const Color(0xFFF7F9FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(18),
          ),
        ),
      ],
    );
  }

  
Widget _buildSaveButton() {
  return Center( // لضمان تمركز الزر في منتصف الحاوية الأب
    child: SizedBox(
      width: double.infinity, // يجعله يأخذ كامل العرض المتاح في الحاوية
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () {
          // هنا يتم الحفظ في Supabase
        },
        icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
        label: Text(
          S.of(context).save_changes_button,
          style: const TextStyle(
            color: Colors.white, 
            fontSize: 16, 
            fontWeight: FontWeight.bold
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryTeal(context),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    ),
  );
}
  // دالة الأيقونة الموحدة كما في كود الإعدادات الخاص بك
  Widget _iconBtn(IconData icon, {VoidCallback? onTap, bool isSmall = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(isSmall ? 8 : 12),
          decoration: BoxDecoration(
            color: isSmall ? AppColors.primaryTeal(context) : Colors.white,
            shape: BoxShape.circle,
            border: isSmall ? Border.all(color: Colors.white, width: 3) : null,
            boxShadow: isSmall ? null : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: Icon(icon, color: isSmall ? Colors.white : AppColors.primaryTeal(context), size: isSmall ? 18 : 24),
        ),
      ),
    );
  }
}