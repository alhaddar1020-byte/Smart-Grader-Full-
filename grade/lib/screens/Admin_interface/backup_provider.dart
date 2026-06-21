import '../../generated/l10n.dart';
import 'package:grade/core/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

// ==========================================
// Models
// ==========================================
class BackupItem {
  final int backupId;
  final DateTime backupDate;
  final String fileSize;
  final String status;
  final String backupType;
  final String formattedDate;

  BackupItem({
    required this.backupId,
    required this.backupDate,
    required this.fileSize,
    required this.status,
    required this.backupType,
    required this.formattedDate,
  });

  factory BackupItem.fromJson(Map<String, dynamic> json) {
    final rawDate = json['backup_date'] ?? '';
    DateTime parsedDate = DateTime.now();
    String formatted = rawDate;

    try {
      parsedDate = DateTime.parse(rawDate);
      final h = parsedDate.hour;
      final amPm = h >= 12 ? "PM" : "AM";
      final h12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
      final mm = parsedDate.minute.toString().padLeft(2, '0');
      final yyyy = parsedDate.year;
      final mo = parsedDate.month.toString().padLeft(2, '0');
      final dd = parsedDate.day.toString().padLeft(2, '0');
      formatted = '$yyyy-$mo-$dd | ${h12.toString().padLeft(2, '0')}:$mm $amPm';
    } catch (_) {}

    return BackupItem(
      backupId: json['backup_id'] ?? 0,
      backupDate: parsedDate,
      fileSize: json['file_size'] ?? "Not specified",
      status: json['status'] ?? "Completed",
      backupType: json['backup_type'] ?? "Full Backup",
      formattedDate: formatted,
    );
  }
}

class RecentLog {
  final int logId;
  final String event;
  final String logType;
  final String timeAgo;

  RecentLog({
    required this.logId,
    required this.event,
    required this.logType,
    required this.timeAgo,
  });

  factory RecentLog.fromJson(Map<String, dynamic> json) {
    return RecentLog(
      logId: json['log_id'] ?? 0,
      event: json['event'] ?? '',
      logType: json['log_type'] ?? 'info',
      timeAgo: json['time_ago'] ?? '',
    );
  }
}

class SystemStats {
  final String uptime;
  final String dbSize;
  final int totalBackups;
  final String systemStatus;

  SystemStats({
    required this.uptime,
    required this.dbSize,
    required this.totalBackups,
    required this.systemStatus,
  });

  factory SystemStats.fromJson(Map<String, dynamic> json) {
    return SystemStats(
      uptime: json['uptime'] ?? "N/A",
      dbSize: json['db_size'] ?? "N/A",
      totalBackups: json['total_backups'] ?? 0,
      systemStatus: json['system_status'] ?? "Not specified",
    );
  }
}

// ==========================================
// Provider
// ==========================================
class BackupProvider extends ChangeNotifier {
  final String baseUrl = '${AppConfig.baseUrl}/admin/backup';

  List<BackupItem> backups = [];
  List<RecentLog> recentLogs = [];
  SystemStats? systemStats;
  String lastBackupDate = '--';

  bool isLoading = false;
  bool isCreatingBackup = false;
  String errorMessage = '';
  
  bool _filterByActiveTerm = false;
  bool get filterByActiveTerm => _filterByActiveTerm;

  void toggleActiveTermFilter(bool value) {
    _filterByActiveTerm = value;
    notifyListeners();
    fetchPageData();
  }

  // ==========================================
  // 1. جلب بيانات الصفحة - من الباك إند فقط
  // ==========================================
  Future<void> fetchPageData() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final response = await http.get(
        Uri.parse('$baseUrl/page-data?active_term=$_filterByActiveTerm'),
        headers: {'Authorization': 'Bearer $token'}
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        systemStats = SystemStats.fromJson(data['system_stats'] ?? {});
        lastBackupDate = data['last_backup_date'] ?? '--';

        backups = (data['backups'] as List? ?? [])
            .map((e) => BackupItem.fromJson(e))
            .toList();

        recentLogs = (data['recent_logs'] as List? ?? [])
            .map((e) => RecentLog.fromJson(e))
            .toList();
      } else {
        errorMessage = "Error ${response.statusCode}";
      }
    } catch (e) {
      errorMessage = "Connection Error";
      debugPrint('Backup fetch error: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // ==========================================
  // 2. إنشاء نسخة احتياطية جديدة
  // ==========================================
  Future<void> createBackup(BuildContext context) async {
    isCreatingBackup = true;
    notifyListeners();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).creating_new_backup_snackbar),
          backgroundColor: Colors.teal,
          duration: Duration(seconds: 2),
        ),
      );
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {'Authorization': 'Bearer $token'}
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['backup'] != null) {
          final newBackup = BackupItem.fromJson(data['backup']);
          backups.insert(0, newBackup);
          lastBackupDate = newBackup.formattedDate;

          // تحديث إجمالي النسخ
          if (systemStats != null) {
            systemStats = SystemStats(
              uptime: systemStats!.uptime,
              dbSize: systemStats!.dbSize,
              totalBackups: systemStats!.totalBackups + 1,
              systemStatus: systemStats!.systemStatus,
            );
          }

          // إضافة سجل للعملية
          recentLogs.insert(0, RecentLog(
            logId: 0,
            event: S.of(context).alert_backup_success_desc,
            logType: 'success',
            timeAgo: S.of(context).just_now,
          ));
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).alert_backup_success),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        final err = json.decode(utf8.decode(response.bodyBytes));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(err['detail'] ?? S.of(context).error_backup_creation_failed),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Connection Error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    isCreatingBackup = false;
    notifyListeners();
  }

  // ==========================================
  // 3. تحميل نسخة احتياطية - حقيقي
  // ==========================================
  Future<void> downloadBackup(
      BuildContext context, int backupId, String backupDate) async {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).loading_backup_version(backupDate)),
          backgroundColor: Colors.teal,
        ),
      );
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final response =
          await http.get(Uri.parse('$baseUrl/download/$backupId'), headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        // تحميل الملف في المتصفح
        final blob =
            html.Blob([response.bodyBytes], 'application/octet-stream');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..setAttribute('download', 'backup_$backupId.db')
          ..click();
        html.Url.revokeObjectUrl(url);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).success_downloaded),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        final err = json.decode(utf8.decode(response.bodyBytes));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(err['detail'] ?? S.of(context).error_download_failed),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).error_loading_with_msg(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ==========================================
  // 4. استعادة نسخة احتياطية
  // ==========================================
  Future<void> restoreBackup(BuildContext context, int backupId) async {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).restoring_system_snackbar),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final response =
          await http.post(Uri.parse('$baseUrl/restore/$backupId'), headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        // إضافة سجل الاستعادة
        recentLogs.insert(0, RecentLog(
          logId: 0,
          event: S.of(context).success_system_restored,
          logType: 'success',
          timeAgo: S.of(context).just_now,
        ));
        notifyListeners();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).success_restored_successfully),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        final err = json.decode(utf8.decode(response.bodyBytes));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(err['detail'] ?? S.of(context).error_restore_failed),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).error_with_msg(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ==========================================
  // 5. حذف نسخة احتياطية
  // ==========================================
  Future<void> deleteBackup(BuildContext context, int backupId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final response =
          await http.delete(Uri.parse('$baseUrl/delete/$backupId'), headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        backups.removeWhere((b) => b.backupId == backupId);

        if (systemStats != null && systemStats!.totalBackups > 0) {
          systemStats = SystemStats(
            uptime: systemStats!.uptime,
            dbSize: systemStats!.dbSize,
            totalBackups: systemStats!.totalBackups - 1,
            systemStatus: systemStats!.systemStatus,
          );
        }

        lastBackupDate =
            backups.isNotEmpty ? backups.first.formattedDate : '--';

        notifyListeners();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(S.of(context).delete_success),
                backgroundColor: Colors.green),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(S.of(context).error_delete_failed), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).error_with_msg(e.toString())), backgroundColor: Colors.red),
        );
      }
    }
  }
}
