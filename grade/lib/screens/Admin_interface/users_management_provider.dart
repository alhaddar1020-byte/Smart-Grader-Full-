import '../../generated/l10n.dart';
import 'package:grade/core/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  String id;
  String name;
  String role;   
  String status; 

  UserModel({required this.id, required this.name, required this.role, required this.status});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] ?? '', 
      role: json['role'] ?? 'STUDENT',
      status: json['status'] ?? 'INACTIVE',
    );
  }
}

class UsersManagementProvider extends ChangeNotifier {
  final String baseUrl = '${AppConfig.baseUrl}/admin/users';

  List<UserModel> _allUsers = [];
  bool isLoading = false;
  String errorKey = "";   
  String selectedFilter = 'ALL'; 
  String searchQuery = ''; 
  bool showActiveOnly = false; // 👈 المتغير الجديد للفلترة بالترم النشط

  String get totalUsers => _allUsers.length.toString();
  String get totalStudents => _allUsers.where((u) => u.role == 'STUDENT').length.toString();
  String get totalTeachers => _allUsers.where((u) => u.role == 'TEACHER').length.toString();
  String get activeUsers => _allUsers.where((u) => u.status == 'ACTIVE').length.toString();

  List<UserModel> get filteredUsers {
    return _allUsers.where((user) {
      final matchesRole = selectedFilter == 'ALL' || user.role == selectedFilter;
      final matchesSearch = user.name.toLowerCase().contains(searchQuery.toLowerCase().trim()) || 
                            user.id.contains(searchQuery.trim());
      return matchesRole && matchesSearch;
    }).toList();
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void updateFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  // 👈 دالة تبديل الترم النشط
  void toggleActiveFilter(bool value) {
    showActiveOnly = value;
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading = true;
    errorKey = "";
    notifyListeners();

    try {
      // 👈 تم إضافة parameter active_only للرابط
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      
      final response = await http.get(
        Uri.parse('$baseUrl/list?active_only=$showActiveOnly'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        _allUsers = data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        errorKey = "error_server_failed";      
      }
    } catch (e) {
      errorKey = "error_network_connection";    
    }

    isLoading = false;
    notifyListeners();
  }

  String _extractBackendError(String responseBody) {
    try {
      final data = json.decode(responseBody);
      return data['detail'] ?? 'error_occurred'; 
    } catch (_) {
      return 'error_occurred';
    }
  }

  Future<String?> updateUser(String originalId, String newId, String name, String role, String status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      
      final response = await http.put(
        Uri.parse('$baseUrl/update/$originalId'), 
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode({
          "id": newId,
          "name": name,
          "role": role,
          "status": status
        }),
      );

      if (response.statusCode == 200) {
        final index = _allUsers.indexWhere((u) => u.id == originalId);
        if (index != -1) {
          _allUsers[index] = UserModel(id: newId, name: name, role: role, status: status);
          notifyListeners();
        }
        return null; 
      }
      return _extractBackendError(response.body); 
    } catch (e) {
      return 'error_network_connection';
    }
  }

  Future<String?> deleteUser(String academicId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      
      final response = await http.delete(
        Uri.parse('$baseUrl/delete/$academicId'),
        headers: {
          "Authorization": "Bearer $token"
        },
      );
      if (response.statusCode == 200) {
        _allUsers.removeWhere((u) => u.id == academicId);
        notifyListeners();
        return null; 
      }
      return _extractBackendError(response.body); 
    } catch (e) {
      return 'error_network_connection';
    }
  } 
}