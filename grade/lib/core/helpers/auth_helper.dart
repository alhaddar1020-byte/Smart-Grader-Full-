import 'package:flutter/material.dart';
import '../../generated/l10n.dart';

class AuthHelper {
  static String translateError(String key, BuildContext context) {
    switch (key) {
      case 'error_invalid_credentials':
        return S.of(context).error_invalid_credentials;
      case 'error_no_role':
        return S.of(context).error_no_role;
      case 'error_email_not_found':
        return S.of(context).error_email_not_found;
      case 'error_email_already_registered':
        return S.of(context).error_email_already_registered;
      case 'error_account_not_activated':
        return S.of(context).error_account_not_activated;
      case 'error_invalid_otp':
        return S.of(context).error_invalid_otp;
      case 'error_expired_otp':
        return S.of(context).error_expired_otp;
      case 'error_update_password_failed':
        return S.of(context).error_update_password_failed;
      case 'error_connection_failed':
        return S.of(context).error_connection_failed;
      default:
        // إذا لم يكن المفتاح معروفاً، نرجعه كما هو، أو نرجع رسالة عامة
        return key.startsWith('error_') ? S.of(context).error_connection_failed : key;
    }
  }
}
