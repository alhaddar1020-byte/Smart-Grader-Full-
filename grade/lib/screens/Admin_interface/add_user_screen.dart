import '../../generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import 'package:grade/generated/l10n.dart'; 
import 'add_users_provider.dart'; 
import 'users_management_provider.dart';
import 'admin_settings_screen.dart';

class AddUsersScreen extends StatefulWidget {
  const AddUsersScreen({super.key});

  @override
  State<AddUsersScreen> createState() => _AddUsersScreenState();
}

class _AddUsersScreenState extends State<AddUsersScreen> {
  int selectedTabIndex = 0; 

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddUsersProvider>().fetchHistory();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // --- دالة مساعدة لترجمة مفاتيح الباك إند ---
  String _translateBackendMessage(String key, BuildContext context) {
    if (key == 'KEY_EMAIL_ALREADY_EXISTS') return S.of(context).email_exists_error;
    if (key == 'KEY_USER_ADDED_SUCCESSFULLY') return S.of(context).success_user_added;
    if (key == 'KEY_INVALID_EXCEL_COLUMNS') return S.of(context).error_check_excel_columns;
    if (key == 'KEY_NO_FILE_SELECTED') return S.of(context).error_no_file_selected;
    if (key == 'KEY_SELECT_FILE_FIRST') return S.of(context).please_select_file_first;
    if (key == 'KEY_SERVER_ERROR' || key == 'KEY_CONNECTION_ERROR') return S.of(context).connection_error;
    if (key.startsWith('KEY_USERS_ADDED|')) {
      final count = key.split('|')[1];
      return S.of(context).success_users_added(count);
    }
    return key; // يرجع النص كما هو لو لم يتعرف عليه
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 800; 

    return Consumer<AddUsersProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppColors.secondaryTeal(context),
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopHeader(isMobile),
                      const SizedBox(height: 32),
                      isMobile
                          ? Column(
                              children: [
                                _buildWorkspaceCard(isMobile, provider),
                                const SizedBox(height: 24),
                                _buildInstructionsCard(),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 7, child: _buildWorkspaceCard(isMobile, provider)),
                                const SizedBox(width: 24),
                                Expanded(flex: 3, child: _buildInstructionsCard()),
                              ],
                            ),
                      const SizedBox(height: 32),
                      _buildImportHistoryTable(provider),
                    ],
                  ),
                ),
                if (provider.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(child: CircularProgressIndicator(color: AppColors.primaryTeal(context))),
                  ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildTopHeader(bool isMobile) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context), // متناسق مع الدارك مود
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: IconButton(
                  icon: Icon(Icons.adaptive.arrow_back, color: AppColors.primaryTeal(context), size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                S.of(context).add_new_user, 
                style: TextStyle(
                  fontSize: isMobile ? 18 : 24, 
                  fontWeight: FontWeight.bold, 
                  color: AppColors.textPrimary(context)
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildTopIcon(icon: Icons.person_outline_rounded, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminSettingsScreen(isFullScreen: true)));
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTopIcon({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle),
        child: Icon(Icons.person_outline, color: AppColors.primaryTeal(context)),
      ),
    );
  }

  Widget _buildWorkspaceCard(bool isMobile, AddUsersProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context), // متناسق مع الدارك مود
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textSecondary(context).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, 
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: AppColors.scaffoldBg(context), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(child: _buildTabButton(title: S.of(context).bulk_upload_excel, index: 0)),
                Expanded(child: _buildTabButton(title: S.of(context).manual_entry, index: 1)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          selectedTabIndex == 0 ? _buildBulkUploadTab(provider) : _buildManualEntryTab(isMobile, provider),
        ],
      ),
    );
  }

  Widget _buildTabButton({required String title, required int index}) {
    final isActive = selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: isActive ? AppColors.primaryTeal(context) : Colors.transparent, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isActive ? Colors.white : AppColors.textSecondary(context))),
          ),
        ),
      ),
    );
  }

  Widget _buildBulkUploadTab(AddUsersProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryTeal(context).withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.secondaryTeal(context).withOpacity(0.5), shape: BoxShape.circle),
            child: Icon(Icons.cloud_upload_outlined, color: AppColors.primaryTeal(context), size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            provider.selectedFileName != null ? '${S.of(context).ready_to_upload_file}\n${provider.selectedFileName}' : S.of(context).drag_drop_excel,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              String? error = await provider.pickExcelFile();
              if (error != null && mounted) {
                // ترجمة رسالة الخطأ إذا كانت مسجلة في الدالة
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_translateBackendMessage(error, context)), backgroundColor: Colors.red));
              }
            },
            icon: Icon(Icons.folder_open, color: AppColors.primaryTeal(context), size: 20),
            label: Text(provider.selectedFileName != null ? S.of(context).change_file : S.of(context).browse_files, style: TextStyle(color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primaryTeal(context)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),
          Text(S.of(context).supported_file_formats, style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context))),
          const SizedBox(height: 24),
          
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: ElevatedButton(
              onPressed: () {
                if (provider.selectedFileName == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S.of(context).please_select_file_first), backgroundColor: Colors.red),
                  );
                } else {
                  _showCategorySelectionDialog(isFileUpload: true, provider: provider);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal(context),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(S.of(context).save_and_upload_file, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualEntryTab(bool isMobile, AddUsersProvider provider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile 
            ? Column(
                children: [
                  _buildTextField(S.of(context).first_name, _firstNameController),
                  const SizedBox(height: 16),
                  _buildTextField(S.of(context).last_name, _lastNameController),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildTextField(S.of(context).first_name, _firstNameController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(S.of(context).last_name, _lastNameController)),
                ],
              ),
          const SizedBox(height: 16),
          
          isMobile 
            ? Column(
                children: [
                  _buildTextField('${S.of(context).id_number} ${S.of(context).optional_field}', _idController, isNumber: true, isOptional: true),
                  const SizedBox(height: 16),
                  _buildTextField(S.of(context).email_address, _emailController, isEmail: true),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildTextField('${S.of(context).id_number} ${S.of(context).optional_field}', _idController, isNumber: true, isOptional: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(S.of(context).email_address, _emailController, isEmail: true)),
                ],
              ),
          const SizedBox(height: 16),

          isMobile 
            ? _buildTextField('${S.of(context).phone_number} ${S.of(context).optional_field}', _phoneController, isNumber: true, isPhone: true, isOptional: true)
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildTextField('${S.of(context).phone_number} ${S.of(context).optional_field}', _phoneController, isNumber: true, isPhone: true, isOptional: true)),
                  const SizedBox(width: 16),
                  const Expanded(child: SizedBox()), 
                ],
              ),
          const SizedBox(height: 24),
          
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _showCategorySelectionDialog(isFileUpload: false, provider: provider);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S.of(context).fill_all_required_fields), backgroundColor: Colors.red),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal(context),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(S.of(context).save_and_add, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false, bool isEmail = false, bool isPhone = false, bool isOptional = false}) {
    bool isName = !isNumber && !isEmail;
    bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : (isEmail ? TextInputType.emailAddress : TextInputType.text),
          inputFormatters: [
            if (isNumber) FilteringTextInputFormatter.digitsOnly, 
            if (isName) FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\u0600-\u06FF\s]')), 
          ],
          style: TextStyle(color: AppColors.textPrimary(context)),
          validator: (value) {
            if (!isOptional && (value == null || value.trim().isEmpty)) {
              return S.of(context).field_required;
            }
            if (value != null && value.trim().isNotEmpty) {
              if (isEmail) {
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value)) {
                  return isRtl ? S.of(context).err_invalid_email_format : 'Invalid email format';
                }
              }
              if (isPhone && value.length < 9) {
                return isRtl ? S.of(context).error_phone_too_short : 'Phone number is too short';
              }
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.scaffoldBg(context),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.primaryTeal(context))),
            errorStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _showCategorySelectionDialog({required bool isFileUpload, required AddUsersProvider provider}) {
    // 💡 استخدام Map لربط المفتاح الإنجليزي بالنص المترجم للعرض
    Map<String, String> categories = {
      'STUDENT': S.of(context).students_category, 
      'TEACHER': S.of(context).teachers_category, 
      'ADMIN': S.of(context).admins_category
    };
    String selectedCategoryKey = 'STUDENT'; // الافتراضي هو مفتاح الطالب

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: Directionality.of(context),
          child: AlertDialog(
            backgroundColor: AppColors.cardBg(context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              isFileUpload ? S.of(context).confirm_file_upload : S.of(context).select_user_category,
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal(context), fontSize: 18),
            ),
            content: StatefulBuilder(
              builder: (context, setStatePopup) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isFileUpload ? S.of(context).file_will_be_saved_as : S.of(context).please_select_category_to_add,
                      style: TextStyle(color: AppColors.textPrimary(context)),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategoryKey,
                      dropdownColor: AppColors.cardBg(context),
                      style: TextStyle(color: AppColors.textPrimary(context)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      // نعرض القيمة المترجمة ونحتفظ بالمفتاح
                      items: categories.entries.map((entry) {
                        return DropdownMenuItem(value: entry.key, child: Text(entry.value));
                      }).toList(),
                      onChanged: (value) => setStatePopup(() => selectedCategoryKey = value!),
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(S.of(context).cancel, style: TextStyle(color: AppColors.textSecondary(context), fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: () async {
                  // الفحص يعتمد الآن على المفتاح STUDENT بدلاً من النص المترجم
                  if (!isFileUpload && 
                      selectedCategoryKey == 'STUDENT' && 
                      _idController.text.trim().isEmpty) {
                    
                    Navigator.pop(dialogContext); 
                    
                    ScaffoldMessenger.of(context).showSnackBar( 
                      SnackBar(
                        content: Text(S.of(context).id_required_for_students),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  Navigator.pop(dialogContext); 
                  
                  Map<String, dynamic> result;
                  
                  if (isFileUpload) {
                    // نرسل المفتاح للباك إند
                    result = await provider.uploadExcelFile(selectedCategoryKey);
                  } else {
                    // نرسل المفتاح للباك إند
                    result = await provider.addManualUser(
                      firstName: _firstNameController.text.trim(),
                      lastName: _lastNameController.text.trim(),
                      academicId: _idController.text.trim(), 
                      email: _emailController.text.trim(),
                      phone: _phoneController.text.trim(),
                      categoryKey: selectedCategoryKey 
                    );
                    
                    if (result['success']) {
                      _firstNameController.clear();
                      _lastNameController.clear();
                      _idController.clear();
                      _emailController.clear();
                      _phoneController.clear();
                    }
                  }

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        // 💡 ترجمة الرسالة القادمة من السيرفر قبل عرضها
                        content: Text(_translateBackendMessage(result['message'], context)),
                        backgroundColor: result['success'] ? Colors.green : Colors.red,
                      ),
                    );
                    
                    if (result['success']) {
                      context.read<UsersManagementProvider>().fetchUsers();
                      if (isFileUpload) {
                        Navigator.pop(context);
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal(context),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(S.of(context).confirm_and_save, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondaryTeal(context).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryTeal(context).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primaryTeal(context), size: 24),
              const SizedBox(width: 8),
              Text(S.of(context).upload_instructions, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryTeal(context))),
            ],
          ),
          const SizedBox(height: 16),
          _buildInstructionBullet(S.of(context).instruction_1),
          _buildInstructionBullet(S.of(context).instruction_2),
          _buildInstructionBullet(S.of(context).instruction_3),
          _buildInstructionBullet(S.of(context).instruction_4),
          _buildInstructionBullet(S.of(context).instruction_5),
        ],
      ),
    );
  }

  Widget _buildInstructionBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: CircleAvatar(radius: 3, backgroundColor: AppColors.primaryTeal(context)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: AppColors.textPrimary(context), height: 1.5))),
        ],
      ),
    );
  }

  Widget _buildImportHistoryTable(AddUsersProvider provider) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg(context), // متناسق مع الدارك مود
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textSecondary(context).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(S.of(context).import_history, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
          ),
          Divider(height: 1, color: AppColors.textSecondary(context).withOpacity(0.1)),
          
          LayoutBuilder(
            builder: (context, constraints) {
              double minSafeWidth = 900; 
              bool needsScroll = constraints.maxWidth < minSafeWidth;
              double tableWidth = needsScroll ? minSafeWidth : constraints.maxWidth;

              Widget tableContent = SizedBox(
                width: tableWidth,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(flex: 3, child: Text(S.of(context).upload_name, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary(context)))),
                          Expanded(flex: 2, child: Text(S.of(context).upload_date, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary(context)))),
                          Expanded(flex: 1, child: Center(child: Text(S.of(context).count, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary(context))))),
                          Expanded(flex: 1, child: Center(child: Text(S.of(context).status, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary(context))))),
                          Expanded(flex: 2, child: Text(S.of(context).actions, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary(context)))),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: AppColors.textSecondary(context).withOpacity(0.1)),
                    
                    if (provider.historyRecords.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(child: Text(S.of(context).error_no_recorded_operations, style: TextStyle(color: AppColors.textSecondary(context)))),
                      ),

                    ...provider.historyRecords.map((record) => Column(
                      children: [
                        _buildTableRow(record, provider),
                        Divider(height: 1, color: AppColors.textSecondary(context).withOpacity(0.1)),
                      ],
                    )).toList(),
                  ],
                ),
              );

              return needsScroll
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: tableContent,
                    )
                  : tableContent;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(ImportHistoryRecord record, AddUsersProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(record.fileOrName.contains('.xls') || record.fileOrName.contains('.csv') ? Icons.insert_drive_file : Icons.person, color: AppColors.textSecondary(context), size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(record.fileOrName, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary(context)), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text(record.uploadDate, style: TextStyle(color: AppColors.textSecondary(context)))),
          Expanded(flex: 1, child: Center(child: Text(record.recordsCount, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))))),
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: record.isSuccess ? const Color(0xFFD1FAE5).withOpacity(0.2) : const Color(0xFFFEE2E2).withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                child: Text(
                  (record.status == 'مكتمل' || record.status == 'KEY_COMPLETED') 
                      ? (Localizations.localeOf(context).languageCode == 'en' ? 'Completed' : 'مكتمل') 
                      : record.status, 
                  style: TextStyle(color: record.isSuccess ? Colors.green[500] : Colors.red[500], fontSize: 12, fontWeight: FontWeight.bold)
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    bool deleted = await provider.deleteHistoryRecord(record.id);
                    if (deleted && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).file_deleted_successfully), backgroundColor: Colors.red));
                    }
                  }, 
                  child: const Icon(Icons.delete_outline, color: Colors.red, size: 20)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}