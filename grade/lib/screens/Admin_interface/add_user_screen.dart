import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/core/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:grade/generated/l10n.dart'; 

class AddUsersScreen extends StatefulWidget {
  const AddUsersScreen({super.key});

  @override
  State<AddUsersScreen> createState() => _AddUsersScreenState();
}

class _AddUsersScreenState extends State<AddUsersScreen> {
  int selectedTabIndex = 0; 
  String? selectedFileName; 

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // ==========================================
  // 💾 قاعدة بيانات وهمية (List) لتخزين سجل الرفع
  // ==========================================
  List<Map<String, dynamic>> historyRecords = [
    {'name': 'students_batch_01.xlsx', 'date': '15 May 2024', 'count': '45', 'status': 'مكتمل', 'isSuccess': true},
    {'name': 'teachers_2024.xlsx', 'date': '14 May 2024', 'count': '12', 'status': 'مكتمل', 'isSuccess': true},
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickExcelFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx', 'csv'],
      );

      if (result != null) {
        setState(() {
          selectedFileName = result.files.single.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).error_opening_file), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 800; 

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(isMobile),
              const SizedBox(height: 32),
              isMobile
                  ? Column(
                      children: [
                        _buildWorkspaceCard(isMobile),
                        const SizedBox(height: 24),
                        _buildInstructionsCard(),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _buildWorkspaceCard(isMobile)),
                        const SizedBox(width: 24),
                        Expanded(flex: 3, child: _buildInstructionsCard()),
                      ],
                    ),
              const SizedBox(height: 32),
              _buildImportHistoryTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(bool isMobile) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.scaffoldBg(context), shape: BoxShape.circle),
                  child: Icon(isRtl ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded, color: AppColors.primaryTeal(context), size: 24),
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
              _buildTopIcon(icon: Icons.notifications_none_rounded, onTap: () {}),
              const SizedBox(width: 8),
              _buildTopIcon(icon: Icons.person_outline_rounded, onTap: () {}),
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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.scaffoldBg(context), shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.primaryTeal(context), size: 24),
      ),
    );
  }

  Widget _buildWorkspaceCard(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
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
          selectedTabIndex == 0 ? _buildBulkUploadTab() : _buildManualEntryTab(isMobile),
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

  Widget _buildBulkUploadTab() {
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
            selectedFileName != null ? '${S.of(context).ready_to_upload_file}\n$selectedFileName' : S.of(context).drag_drop_excel,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _pickExcelFile,
            icon: Icon(Icons.folder_open, color: AppColors.primaryTeal(context), size: 20),
            label: Text(selectedFileName != null ? S.of(context).change_file : S.of(context).browse_files, style: TextStyle(color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold)),
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
                if (selectedFileName == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S.of(context).please_select_file_first), backgroundColor: Colors.red),
                  );
                } else {
                  _showCategorySelectionDialog(isFileUpload: true);
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

  Widget _buildManualEntryTab(bool isMobile) {
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
                  _buildTextField(S.of(context).id_number, _idController, isNumber: true),
                  const SizedBox(height: 16),
                  _buildTextField(S.of(context).email_address, _emailController, isEmail: true),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildTextField(S.of(context).id_number, _idController, isNumber: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(S.of(context).email_address, _emailController, isEmail: true)),
                ],
              ),
          const SizedBox(height: 24),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _showCategorySelectionDialog(isFileUpload: false);
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

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false, bool isEmail = false}) {
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
            if (value == null || value.trim().isEmpty) {
              return S.of(context).field_required;
            }
            if (isEmail) {
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return isRtl ? 'صيغة البريد الإلكتروني غير صحيحة' : 'Invalid email format';
              }
            }
            if (isNumber && value.length < 10) {
              return isRtl ? 'رقم الهوية يجب أن يتكون من 10 أرقام' : 'ID must be at least 10 digits';
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

  void _showCategorySelectionDialog({required bool isFileUpload}) {
    List<String> categories = [
      S.of(context).students_category, 
      S.of(context).teachers_category, 
      S.of(context).admins_category
    ];
    String selectedCategory = categories.first;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: Directionality.of(context),
          child: AlertDialog(
            backgroundColor: AppColors.textWhite(context),
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
                      value: selectedCategory,
                      dropdownColor: AppColors.textWhite(context),
                      style: TextStyle(color: AppColors.textPrimary(context)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem(value: category, child: Text(category));
                      }).toList(),
                      onChanged: (value) => setStatePopup(() => selectedCategory = value!),
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).cancel, style: TextStyle(color: AppColors.textSecondary(context), fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  
                  // ==========================================
                  // 🚀 هنا السحر: إضافة العملية للجدول فوراً!
                  // ==========================================
                  setState(() {
                    String todayDate = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";

                    if (isFileUpload) {
                      // إضافة ملف في الجدول
                      historyRecords.insert(0, {
                        'name': selectedFileName ?? 'Unknown File',
                        'date': todayDate,
                        'count': 'جارِ الحساب', 
                        'status': S.of(context).completed,
                        'isSuccess': true
                      });
                      selectedFileName = null;
                    } else {
                      // إضافة شخص يدوي في الجدول
                      String fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
                      historyRecords.insert(0, {
                        'name': fullName,
                        'date': todayDate,
                        'count': '1',
                        'status': S.of(context).completed,
                        'isSuccess': true
                      });
                      _firstNameController.clear();
                      _lastNameController.clear();
                      _idController.clear();
                      _emailController.clear();
                    }
                  }); 

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${S.of(context).operation_successful_for_category} $selectedCategory'), backgroundColor: Colors.green),
                  );
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

  Widget _buildImportHistoryTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
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
                          // ⬅️ تم تغيير العنوان هنا إلى S.of(context).upload_name
                          Expanded(flex: 3, child: Text(S.of(context).upload_name, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary(context)))),
                          Expanded(flex: 2, child: Text(S.of(context).upload_date, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary(context)))),
                          Expanded(flex: 1, child: Center(child: Text(S.of(context).count, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary(context))))),
                          Expanded(flex: 1, child: Center(child: Text(S.of(context).status, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary(context))))),
                          Expanded(flex: 2, child: Text(S.of(context).actions, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary(context)))),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: AppColors.textSecondary(context).withOpacity(0.1)),
                    
                    // ==========================================
                    // ♻️ حلقة تكرار (Loop) لرسم الجدول تلقائياً من البيانات!
                    // ==========================================
                    ...historyRecords.map((record) => Column(
                      children: [
                        _buildTableRow(
                          record['name'], 
                          record['date'], 
                          record['count'], 
                          record['status'], 
                          record['isSuccess']
                        ),
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

  Widget _buildTableRow(String name, String date, String count, String status, bool isSuccess) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                // تغيير الأيقونة بناءً على نوع الرفع (شخص أو ملف)
                Icon(name.contains('.xls') || name.contains('.csv') ? Icons.insert_drive_file : Icons.person, color: AppColors.textSecondary(context), size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(name, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary(context)))),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text(date, style: TextStyle(color: AppColors.textSecondary(context)))),
          Expanded(flex: 1, child: Center(child: Text(count, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))))),
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: isSuccess ? const Color(0xFFD1FAE5).withOpacity(0.2) : const Color(0xFFFEE2E2).withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                child: Text(status, style: TextStyle(color: isSuccess ? Colors.green[500] : Colors.red[500], fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${S.of(context).viewing_file} $name'), backgroundColor: AppColors.primaryTeal(context)),
                    );
                  }, 
                  child: Icon(Icons.visibility_outlined, color: AppColors.primaryTeal(context), size: 20)
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${S.of(context).downloading_file} $name'), backgroundColor: AppColors.primaryTeal(context)),
                    );
                  }, 
                  child: Icon(Icons.download_outlined, color: AppColors.primaryTeal(context), size: 20)
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    setState(() {
                      historyRecords.removeWhere((item) => item['name'] == name);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(S.of(context).file_deleted_successfully), backgroundColor: Colors.red),
                    );
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