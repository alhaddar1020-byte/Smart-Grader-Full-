import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar');
  Locale get locale => _locale;

  // 1. هذه الدالة تُستدعى من الـ main (سريعة جداً لأنها لوكل)
  void setInitialLocale(String langCode) {
    _locale = Locale(langCode);
    // لا نحتاج notifyListeners هنا لأنها تُستدعى قبل بناء التطبيق
  }

  // 2. هذه الدالة تُستدعى من زر الإعدادات
  Future<void> updateLanguage(String newLang) async {
    // أ- تحديث "لوكل" فوراً (الاستجابة اللحظية)
    _locale = Locale(newLang);
    notifyListeners();

    // ب- حفظ "لوكل" في ذاكرة الجهاز (لكي يفتح بها المرة القادمة فوراً)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', newLang);

    // ج- إرسال التحديث لـ "الداتا بيس الأصلية" (في الخلفية)
    try {
      // هنا كود الـ API الخاص بكِ
      // await MyApiService.updateUserLangOnServer(userId, newLang);
      print("تمت المزامنة مع السيرفر بنجاح");
    } catch (e) {
      print("فشلت المزامنة، لكن اللغة تغيرت لوكل بنجاح");
    }
    
  }
  void setLocale(String langCode) => updateLanguage(langCode);
}
