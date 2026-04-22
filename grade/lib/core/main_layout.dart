import 'package:flutter/material.dart';
import '../core/colors.dart'; 
import '../core/custom_sidebar_admin.dart'; 
import 'package:grade/generated/l10n.dart'; 

import '../screens/Admin_interface/admin_dashboard_screen.dart';
import '../screens/Admin_interface/users_management_screen.dart'; 
import '../screens/Admin_interface/dashboard_report_screen.dart';
import '../screens/Admin_interface/system_logs_screen.dart';
import '../screens/Admin_interface/BackupScreen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0; 

  Widget _getScreen() {
    switch (_selectedIndex) {
      case 0:
        return const AdminDashboardScreen(); 
      case 1:
        return const UsersManagementScreen(); 
      case 2:
        return const ReportsScreen(); 
      case 3:
        return const SystemLogsScreen(); 
      case 4:
        return const BackupScreen(); 
      case 5:
        return Center(
          child: Text(
            S.of(context).settings_under_development, 
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey)
          )
        );
      default:
        return Center(
          child: Text(
            S.of(context).page_not_found, 
            style: const TextStyle(color: Colors.red, fontSize: 20)
          )
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 600;
    bool isTablet = width >= 600 && width < 1100;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      
      appBar: isMobile
          ? AppBar(
              backgroundColor: AppColors.scaffoldBg(context),
              iconTheme: IconThemeData(color: AppColors.primaryTeal(context)),
              elevation: 0,
            )
          : null,
          
      // القائمة الجانبية للموبايل (يتم الإغلاق هنا فقط!)
      drawer: isMobile 
          ? Drawer(
              child: CustomSidebar( 
                currentIndex: _selectedIndex, 
                isMobile: true,
                isTablet: false,
                onNavigate: (index) { 
                  setState(() => _selectedIndex = index); 
                  // ✅ أمر الإغلاق موجود هنا فقط ليقفل الـ Drawer
                  Navigator.pop(context); 
                },
              ),
            ) 
          : null,

      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // القائمة الجانبية للكمبيوتر والتابلت
          if (!isMobile)
            CustomSidebar( 
              currentIndex: _selectedIndex, 
              isMobile: false,
              isTablet: isTablet,
              onNavigate: (index) { 
                setState(() => _selectedIndex = index); 
              },
            ),

          // المحتوى المتغير (الشاشات)
          Expanded(
            child: _getScreen(),
          ),
        ],
      ),
    );
  }
}