import 'package:flutter/material.dart';
import '../../core/colors.dart'; // تأكدي من مسار ملف الألوان
import 'add_user_screen.dart';
import 'package:grade/generated/l10n.dart'; // استدعاء القاموس

// ===========================================================================
// 1. نموذج البيانات
// ===========================================================================
class UserModel {
  String id;
  String name;
  String role;   // يخزن كـ 'STUDENT', 'TEACHER', 'ADMIN'
  String status; // يخزن كـ 'ACTIVE', 'INACTIVE'

  UserModel({required this.id, required this.name, required this.role, required this.status});
}

// ===========================================================================
// 2. شاشة إدارة المستخدمين
// ===========================================================================
class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({super.key});

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  // استخدام مفاتيح إنجليزية ثابتة للفلترة لكي لا تنكسر عند تغيير لغة النظام
  String selectedFilter = 'ALL'; 
  String searchQuery = ''; 

  // بيانات وهمية (استخدمنا مفاتيح إنجليزية للرول والحالة)
  final List<UserModel> dummyUsers = [
    UserModel(id: '1001', name: 'أحمد محمد عبدالله', role: 'STUDENT', status: 'ACTIVE'),
    UserModel(id: '1002', name: 'سارة خالد القحطاني', role: 'STUDENT', status: 'ACTIVE'),
    UserModel(id: '1003', name: 'م. فهد العتيبي', role: 'TEACHER', status: 'INACTIVE'),
    UserModel(id: '1004', name: 'نورة سعد الدوسري', role: 'STUDENT', status: 'ACTIVE'),
    UserModel(id: '1005', name: 'د. عبدالله السالم', role: 'ADMIN', status: 'ACTIVE'),
    UserModel(id: '1006', name: 'خالد عبدالعزيز', role: 'TEACHER', status: 'ACTIVE'),
    UserModel(id: '1007', name: 'ريم الدوسري', role: 'STUDENT', status: 'ACTIVE'),
  ];

  // دوال مساعدة لترجمة القيم في الواجهة
  String _getRoleName(String roleKey) {
    switch (roleKey) {
      case 'ALL': return S.of(context).all;
      case 'ADMIN': return S.of(context).role_admin;
      case 'TEACHER': return S.of(context).role_teacher;
      case 'STUDENT': return S.of(context).role_student;
      default: return roleKey;
    }
  }

  String _getStatusName(String statusKey) {
    return statusKey == 'ACTIVE' ? S.of(context).status_active : S.of(context).status_inactive;
  }

  List<UserModel> get filteredUsers {
    return dummyUsers.where((user) {
      final matchesRole = selectedFilter == 'ALL' || user.role == selectedFilter;
      final matchesSearch = user.name.toLowerCase().contains(searchQuery.toLowerCase().trim()) || 
                            user.id.contains(searchQuery.trim());
      return matchesRole && matchesSearch;
    }).toList();
  }

  void _deleteUser(UserModel user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog( // تمت إزالة Directionality ليتأقلم مع النظام
        backgroundColor: AppColors.textWhite(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(S.of(context).delete_confirmation, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: Text('${S.of(context).delete_user_warning}\n\n"${user.name}"', style: TextStyle(color: AppColors.textPrimary(context))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            child: Text(S.of(context).cancel, style: TextStyle(color: AppColors.textSecondary(context), fontWeight: FontWeight.bold))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              setState(() {
                dummyUsers.remove(user);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).delete_success), backgroundColor: Colors.green));
            }, 
            child: Text(S.of(context).yes_delete, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
          )
        ],
      ),
    );
  }

  void _showEditDialog(UserModel user) {
    final nameCtrl = TextEditingController(text: user.name);
    final idCtrl = TextEditingController(text: user.id);
    String editRole = user.role;
    String editStatus = user.status;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog( // تمت إزالة Directionality هنا أيضاً
          backgroundColor: AppColors.textWhite(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(S.of(context).edit_user, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal(context))),
          content: StatefulBuilder(
            builder: (ctx, setDialogState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPopupTextField(S.of(context).full_name, nameCtrl),
                    const SizedBox(height: 16),
                    _buildPopupTextField(S.of(context).id_number, idCtrl, isNumber: true),
                    const SizedBox(height: 16),
                    Text(S.of(context).role, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(8)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: editRole,
                          isExpanded: true,
                          dropdownColor: AppColors.textWhite(context),
                          items: ['ADMIN', 'TEACHER', 'STUDENT'].map((r) => DropdownMenuItem(value: r, child: Text(_getRoleName(r), style: TextStyle(color: AppColors.textPrimary(context))))).toList(),
                          onChanged: (val) => setDialogState(() => editRole = val!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(S.of(context).status, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(8)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: editStatus,
                          isExpanded: true,
                          dropdownColor: AppColors.textWhite(context),
                          items: ['ACTIVE', 'INACTIVE'].map((s) => DropdownMenuItem(value: s, child: Text(_getStatusName(s), style: TextStyle(color: AppColors.textPrimary(context))))).toList(),
                          onChanged: (val) => setDialogState(() => editStatus = val!),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(S.of(context).cancel, style: TextStyle(color: AppColors.textSecondary(context), fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal(context), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                setState(() {
                  user.name = nameCtrl.text;
                  user.id = idCtrl.text;
                  user.role = editRole;
                  user.status = editStatus;
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).edit_success), backgroundColor: Colors.green));
              },
              child: Text(S.of(context).save_changes, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPopupTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: TextStyle(color: AppColors.textPrimary(context)),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.scaffoldBg(context),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 600;
    bool isTablet = width >= 600 && width < 1100;

    // تمت إزالة Directionality الثابتة
    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
        child: Column(
          children: [
            _buildHeader(isMobile),
            const SizedBox(height: 24),
            _buildTopCards(isMobile, isTablet),
            const SizedBox(height: 24),
            Expanded(child: _buildMainTableCard(isMobile, isTablet)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              S.of(context).users_management, 
              style: TextStyle(fontSize: isMobile ? 18 : 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: CircleAvatar(backgroundColor: AppColors.scaffoldBg(context), child: Icon(Icons.notifications_none, color: AppColors.primaryTeal(context))),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: CircleAvatar(backgroundColor: AppColors.scaffoldBg(context), child: Icon(Icons.person_outline, color: AppColors.primaryTeal(context))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopCards(bool isMobile, bool isTablet) {
    if (isMobile || isTablet) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            SizedBox(width: 250, child: _buildSingleCard(S.of(context).total_users, '1,250', Icons.people, AppColors.primaryTeal(context))),
            const SizedBox(width: 16),
            SizedBox(width: 250, child: _buildSingleCard(S.of(context).total_students, '950', Icons.school, AppColors.accentYellow(context))),
            const SizedBox(width: 16),
            SizedBox(width: 250, child: _buildSingleCard(S.of(context).total_teachers, '85', Icons.co_present, const Color(0xFF8B5CF6))),
            const SizedBox(width: 16),
            SizedBox(width: 250, child: _buildSingleCard(S.of(context).active_users_card, '1,120', Icons.check_circle_outline, const Color(0xFF10B981))), 
          ],
        ),
      );
    }
    return Row(
      children: [
        Expanded(child: _buildSingleCard(S.of(context).total_users, '1,250', Icons.people, AppColors.primaryTeal(context))),
        const SizedBox(width: 16),
        Expanded(child: _buildSingleCard(S.of(context).total_students, '950', Icons.school, AppColors.accentYellow(context))), 
        const SizedBox(width: 16),
        Expanded(child: _buildSingleCard(S.of(context).total_teachers, '85', Icons.co_present, const Color(0xFF8B5CF6))),
        const SizedBox(width: 16),
        Expanded(child: _buildSingleCard(S.of(context).active_users_card, '1,120', Icons.check_circle_outline, const Color(0xFF10B981))), 
      ],
    );
  }

  Widget _buildSingleCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textSecondary(context).withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainTableCard(bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: AppColors.textWhite(context),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.textSecondary(context).withOpacity(0.1)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTableToolbar(isMobile, isTablet),
          Divider(height: 1, color: AppColors.textSecondary(context).withOpacity(0.1)),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double minSafeWidth = 800;
                bool needsScroll = constraints.maxWidth < minSafeWidth;
                double tableWidth = needsScroll ? minSafeWidth : constraints.maxWidth;

                Widget tableContent = SizedBox(
                  width: tableWidth,
                  child: Column(
                    children: [
                      _buildTableHeader(needsScroll),
                      Divider(height: 1, color: AppColors.textSecondary(context).withOpacity(0.1)),
                      Expanded(
                        child: filteredUsers.isEmpty 
                          ? Center(child: Text(S.of(context).no_users_found, style: TextStyle(color: AppColors.textSecondary(context))))
                          : ListView.separated(
                              itemCount: filteredUsers.length,
                              separatorBuilder: (context, index) => Divider(height: 1, color: AppColors.textSecondary(context).withOpacity(0.1)),
                              itemBuilder: (context, index) {
                                return _buildTableRow(filteredUsers[index], needsScroll);
                              },
                          ),
                      ),
                    ],
                  ),
                );

                return needsScroll
                    ? SingleChildScrollView(scrollDirection: Axis.horizontal, physics: const BouncingScrollPhysics(), child: tableContent)
                    : tableContent;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableToolbar(bool isMobile, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(S.of(context).users_list, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
              const SizedBox(width: 24),
              Container(
                width: isMobile ? 150 : 250, 
                height: 40,
                decoration: BoxDecoration(color: AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(8)),
                child: TextField(
                  style: TextStyle(color: AppColors.textPrimary(context)),
                  onChanged: (val) {
                    setState(() {
                      searchQuery = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: S.of(context).search_hint,
                    hintStyle: TextStyle(fontSize: 13, color: AppColors.textSecondary(context)),
                    prefixIcon: Icon(Icons.search, color: AppColors.textSecondary(context), size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              PopupMenuButton<String>(
                onSelected: (String result) {
                  setState(() {
                    selectedFilter = result; 
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(value: 'ALL', child: Text(S.of(context).all, style: TextStyle(color: AppColors.textPrimary(context)))),
                  PopupMenuItem<String>(value: 'ADMIN', child: Text(S.of(context).role_admin, style: TextStyle(color: AppColors.textPrimary(context)))),
                  PopupMenuItem<String>(value: 'TEACHER', child: Text(S.of(context).role_teacher, style: TextStyle(color: AppColors.textPrimary(context)))),
                  PopupMenuItem<String>(value: 'STUDENT', child: Text(S.of(context).role_student, style: TextStyle(color: AppColors.textPrimary(context)))),
                ],
                color: AppColors.textWhite(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.textSecondary(context).withOpacity(0.2)), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.filter_list, color: AppColors.textSecondary(context), size: 18),
                      const SizedBox(width: 8),
                      Text('${S.of(context).filter_prefix} ${_getRoleName(selectedFilter)}', style: TextStyle(color: AppColors.textSecondary(context), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddUsersScreen()));
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 18),
                label: Text(S.of(context).add_user_btn, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal(context),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTableHeader(bool needsScroll) {
    return Container(
      color: AppColors.scaffoldBg(context), 
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildCell(child: _tableHeaderText(S.of(context).id_number), flex: 1, width: 100, needsScroll: needsScroll),
          _buildCell(child: _tableHeaderText(S.of(context).full_name), flex: 2, width: 250, needsScroll: needsScroll),
          _buildCell(child: _tableHeaderText(S.of(context).role), flex: 1, width: 100, needsScroll: needsScroll),
          _buildCell(child: _tableHeaderText(S.of(context).status), flex: 1, width: 100, needsScroll: needsScroll),
          _buildCell(child: _tableHeaderText(S.of(context).actions, align: TextAlign.center), flex: 1, width: 150, needsScroll: needsScroll),
        ],
      ),
    );
  }

  Widget _tableHeaderText(String text, {TextAlign align = TextAlign.start}) {
    return Text(text, textAlign: align, style: TextStyle(color: AppColors.textSecondary(context), fontWeight: FontWeight.bold, fontSize: 13));
  }

  Widget _buildTableRow(UserModel user, bool needsScroll) {
    return InkWell(
      onTap: () {}, 
      hoverColor: AppColors.scaffoldBg(context), 
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            _buildCell(
              child: Text(user.id, style: TextStyle(color: AppColors.textPrimary(context), fontWeight: FontWeight.w600, fontSize: 14)), 
              flex: 1, width: 100, needsScroll: needsScroll
            ),
            _buildCell(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.secondaryTeal(context),
                    child: Text(user.name.substring(0, 1), style: TextStyle(color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(user.name, style: TextStyle(color: AppColors.textPrimary(context), fontWeight: FontWeight.w500, fontSize: 14), overflow: TextOverflow.ellipsis)),
                ],
              ),
              flex: 2, width: 250, needsScroll: needsScroll
            ),
            _buildCell(child: _buildRoleBadge(user.role), flex: 1, width: 100, needsScroll: needsScroll),
            _buildCell(child: _buildStatusBadge(user.status), flex: 1, width: 100, needsScroll: needsScroll),
            _buildCell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: Icon(Icons.edit_outlined, color: AppColors.primaryTeal(context), size: 20), onPressed: () => _showEditDialog(user)),
                  IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20), onPressed: () => _deleteUser(user)),
                ],
              ),
              flex: 1, width: 150, needsScroll: needsScroll
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCell({required Widget child, required int flex, required double width, required bool needsScroll}) {
    if (needsScroll) {
      return SizedBox(width: width, child: child);
    } else {
      return Expanded(flex: flex, child: child);
    }
  }

  Widget _buildRoleBadge(String role) {
    return Align(
      // تم التعديل إلى centerStart لكي تظهر الشارات بشكل صحيح باللغتين
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(color: AppColors.secondaryTeal(context), borderRadius: BorderRadius.circular(6)),
        child: Text(_getRoleName(role), style: TextStyle(color: AppColors.primaryTeal(context), fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    bool isActive = status == 'ACTIVE';
    return Align(
      // تم التعديل إلى centerStart 
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1), 
          borderRadius: BorderRadius.circular(6)
        ),
        child: Text(_getStatusName(status), style: TextStyle(color: isActive ? Colors.green : Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }
}