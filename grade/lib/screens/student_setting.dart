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
                            Expanded(child: _buildProfileCard()),
                            const SizedBox(height: 20),
                            Expanded(child: _buildSecurityCard()),
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
        Text(
          "إدارة حسابك وتفضيلات النظام",
          style: TextStyle(fontSize: 16, color: Color(0xFF6A7282)),
        ),
      ],
    );
  }

  // الكارد المطلوب تعديله ليكون ديناميكي ومستجيب

  Widget _buildDynamicField(String label, String value, IconData? icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 6),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              if (icon != null) Icon(icon, size: 16, color: Colors.grey),
              if (icon != null) const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
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
          const Spacer(),
          _buildActionRow(
            "إدارة كلمة المرور",
            "آخر تغيير منذ 3 أشهر",
            Icons.lock_outline,
            actionLabel: "تغيير كلمة المرور",
          ),
          const SizedBox(height: 12),
          _buildActionRow(
            "المصادقة الثنائية (2FA)",
            "طبقة إضافية من الأمان لحسابك",
            Icons.verified_user_outlined,
            isSwitch: true,
          ),
          const Spacer(),
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
      padding: const EdgeInsets.only(left: 20, top: 20, right: 35, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. العناوين (الهيدر)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "بيانات الملف الشخصي",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A0A0A),
                    ),
                  ),
                ],
              ),

              const Spacer(), // يوزع المساحة ديناميكياً
              // 2. الصف الرئيسي الذي يحتوي على (البيانات يميناً والصورة/الاسم يساراً)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Container(
                              width: 55,
                              height: 55,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3F4F6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                size: 30,
                                color: Color(0xFF6A7282),
                              ),
                            ),
                            const SizedBox(width: 12),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  userEmail,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6A7282),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildEditButton(),
                      ],
                    ),
                  ),
                  // جهة اليمين (رقم الهاتف والمستوى) - Expanded عشان ياخذ المساحة المتاحة
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
                        const SizedBox(height: 12),
                        _buildDynamicField("المستوى", educationLevel, null),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  // جهة اليسار (الأفاتار، الاسم، وزر التعديل)
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
