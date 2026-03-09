import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // --- البيانات الديناميكية (جاهزة للربط بـ API أو Database) ---
  String userName = "احمد محمد السعيد";
  String userEmail = "Rogaya@gradesys.edu";
  String phoneNumber = "4567 123 50 966+";
  String educationLevel = "الصف الثاني ثانوي- علمي";
  bool isDarkMode = false;
  String selectedLanguage = "العربية";
  bool is2FAEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFDEF6F5),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopHeader(),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // العمود الأيمن (البيانات والأمان) - يأخذ مساحة أكبر
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
                      // العمود الأيسر (التفضيلات ومنطقة الخطر)
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

  Widget _buildTopHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "إعدادات النظام",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A0A0A),
          ),
        ),
      ],
    );
  }

  // الكارد المطلوب تعديله ليكون ديناميكي ومستجيب

  Widget _buildDynamicField(String label, String value, IconData? icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // يخلي الكولوم يأخذ مساحة محتواه فقط
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 6),
        Container(
          // أزلنا الارتفاع الثابت أو جعلناه كحد أدنى
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
              ],
              Expanded(
                // هذا البطل يمنع الـ Overflow
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    return Container(
      width: 160,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF4FB7B5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          // هنا تضع وظيفة التعديل لاحقاً
        },
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
      ),
    );
  }

  // --- بقية الكروت (نفس المنطق الديناميكي) ---

  Widget _buildSecurityCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "الأمان والمصادقة",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildActionRow(
            "إدارة كلمة المرور",
            "آخر تغيير منذ 3 أشهر",
            Icons.lock_outline,
            actionLabel: "تغيير كلمة المرور",
          ),
          // const SizedBox(height: 12),
          // _buildActionRow(
          //   "المصادقة الثنائية (2FA)",
          //   "طبقة إضافية من الأمان لحسابك",
          //   Icons.verified_user_outlined,
          //   isSwitch: true,
          // ),
        ],
      ),
    );
  }

  Widget _buildDisplayPreferencesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.remove_red_eye_outlined,
                color: Color(0xFF4FB7B5),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "تفضيلات العرض",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "الوضع الداكن",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Switch(
                value: isDarkMode,
                onChanged: (v) => setState(() => isDarkMode = v),
                activeColor: const Color(0xFF4FB7B5),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text("اللغة", style: TextStyle(fontWeight: FontWeight.w600)),
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
        color: Colors.grey[100],
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

  Widget _buildDangerZoneCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration().copyWith(color: const Color(0xFFFEF2F2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "منطقة الخطر",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "سيتم حذف حسابك وجميع البيانات نهائياً.",
            style: TextStyle(color: Color(0xFF4A5565), fontSize: 12),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFB2C36),
              minimumSize: const Size(double.infinity, 42),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "إلغاء تنشيط الحساب",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
    bool isSwitch = false,
    String? actionLabel,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4FB7B5), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  sub,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          if (isSwitch)
            Switch(
              value: is2FAEnabled,
              onChanged: (v) => setState(() => is2FAEnabled = v),
              activeColor: const Color(0xFF4FB7B5),
            )
          else if (actionLabel != null)
            Text(
              actionLabel,
              style: const TextStyle(
                color: Color(0xFF4FB7B5),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(25), // توحيد البادينق
      decoration: _cardDecoration().copyWith(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "بيانات الملف الشخصي",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A0A0A),
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العمود الأيمن: يحتوي على الاسم والبريد الإلكتروني
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDynamicField(
                        "الاسم",
                        userName,
                        Icons.person_outline,
                      ),
                      const SizedBox(height: 25), // مسافة متناسقة
                      _buildDynamicField(
                        "البريد الالكتروني",
                        userEmail,
                        Icons.email_outlined,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 30), // مسافة فاصلة بين العمودين
                // العمود الأيسر: يحتوي على رقم الهاتف والمستوى
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDynamicField(
                        "رقم الهاتف",
                        phoneNumber,
                        Icons.phone_outlined,
                      ),
                      const SizedBox(height: 25),
                      _buildDynamicField(
                        "المستوى",
                        educationLevel,
                        Icons.school_outlined,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // زر التعديل في الأسفل بشكل مستقل لضمان عدم تداخله
          Align(alignment: Alignment.centerRight, child: _buildEditButton()),
        ],
      ),
    );
  }
}
