
// import 'package:flutter/material.dart';
// import 'teacher_dashboard.dart';
// import '../core/colors.dart';
// import 'material_detail.dart';
// import 'grading.dart';
// import 'exam_page.dart';

// class Material1 extends StatefulWidget {
//   const Material1({super.key});

//   @override
//   State<Material1> createState() => _Material1State();
// }

// class _Material1State extends State<Material1> {
//   int _selectedIndex = 2;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: LayoutBuilder(builder: (context, constraints) {
//         bool isMobile = constraints.maxWidth < 800;
//         bool isTablet = constraints.maxWidth >= 800 && constraints.maxWidth < 1150;

//         return Scaffold(
//           key: _scaffoldKey,
//           backgroundColor: AppColors.secondaryTeal(context),
//           drawer: isMobile
//               ? Drawer(
//                   width: 260,
//                   backgroundColor: AppColors.primaryTeal(context),
//                   child: SafeArea(
//                     child: CustSidebar(
//                       selectedIndex: _selectedIndex,
//                       isCompact: false,
//                       onItemSelected: _handleNavigation,
//                     ),
//                   ),
//                 )
//               : null,
//           body: Row(
//             children: [
//               if (!isMobile)
//                 CustSidebar(
//                   selectedIndex: _selectedIndex,
//                   isCompact: isTablet,
//                   onItemSelected: _handleNavigation,
//                 ),
//               Expanded(
//                 child: Column(
//                   children: [
//                     if (isMobile) _buildMobileAppBar(),
//                     const Expanded(
//                       child: MainContent(),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildMobileAppBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Row(
//           children: [
//             IconButton(
//               icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)),
//               onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//             ),
//             const Spacer(),
//             const Text("المواد الدراسية", style: TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleNavigation(int index) {
//     if (index == _selectedIndex) return;
//     setState(() => _selectedIndex = index);
//     if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);

//     Widget? page;
//     if (index == 0) page = const DashboardScreen();
//     if (index == 1) page = const FinalExamPage();
//     if (index == 3) page = const GradingPage();

//     if (page != null) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => page!),
//         (route) => false,
//       );
//     }
//   }
// }

// class MainContent extends StatelessWidget {
//   const MainContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(24),
//       child: const Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           HeaderWidget(),
//           SizedBox(height: 25),
//           TopStatsGrid(), 
//           SizedBox(height: 35),
//           SubjectsGrid(), 
//         ],
//       ),
//     );
//   }
// }

// // --- الهيدر ---
// class HeaderWidget extends StatelessWidget {
//   const HeaderWidget({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("المواد الدراسية", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
//               const SizedBox(height: 4),
//               Text("قم بإدارة جميع المواد والامتحانات الخاصة بك", style: TextStyle(color: AppColors.textSecondary(context), fontSize: 12)),
//             ],
//           ),
//           Row(children: [_iconButton(context, Icons.notifications_none), const SizedBox(width: 10), _iconButton(context, Icons.person_outline)])
//         ],
//       ),
//     );
//   }
//   Widget _iconButton(BuildContext context, IconData icon) => Container(
//     padding: const EdgeInsets.all(8), 
//     decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle), 
//     child: Icon(icon, color: AppColors.primaryTeal(context))
//   );
// }

// // --- الإحصائيات العلوية ---
// class TopStatsGrid extends StatelessWidget {
//   const TopStatsGrid({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       double screenWidth = MediaQuery.of(context).size.width;
//       bool isWeb = screenWidth >= 1150;
//       bool isMobile = screenWidth < 800;

//       // 1. التابلت والفون: جعلها قابلة للتمرير أفقياً
//       if (!isWeb) {
//         // حجم الكارت في الفون 180، وفي التابلت 260 ليطابق حجم الويب تقريباً
//         double cardWidth = isMobile ? 180 : 260; 
        
//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           physics: const BouncingScrollPhysics(),
//           child: Row(
//             children: [
//               _statCard(context, "الطلاب", "340", AppColors.accentYellow(context), Icons.people, isWeb: false, customWidth: cardWidth),
//               _statCard(context, "الأوراق المصححة", "780", AppColors.primaryTeal(context), Icons.description, isWeb: false, customWidth: cardWidth),
//               _statCard(context, "الاختبارات المنشئة", "13", AppColors.primaryTeal(context), Icons.create, isWeb: false, customWidth: cardWidth),
//               _statCard(context, "المسودات", "5", AppColors.primaryTeal(context), Icons.edit_note, isWeb: false, customWidth: cardWidth),
//             ],
//           ),
//         );
//       }

//       // 2. الويب: يبقى كما هو تماماً (صف واحد ممتد)
//       return Row(
//         children: [
//           _statCard(context, "الطلاب", "340", AppColors.accentYellow(context), Icons.people, isWeb: true),
//           _statCard(context, "الأوراق المصححة", "780", AppColors.primaryTeal(context), Icons.description, isWeb: true),
//           _statCard(context, "الاختبارات المنشئة", "13", AppColors.primaryTeal(context), Icons.create, isWeb: true),
//           _statCard(context, "المسودات", "5", AppColors.primaryTeal(context), Icons.edit_note, isWeb: true),
//         ],
//       );
//     });
//   }

//   Widget _statCard(BuildContext context, String title, String value, Color color, IconData icon, {required bool isWeb, double? customWidth}) {
//     Widget cardContent = Container(
//       width: customWidth, // سيأخذ العرض المخصص في حالة الجوال والتابلت
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
//               Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
//             ],
//           ),
//           Icon(icon, color: Colors.white54, size: 35),
//         ],
//       ),
//     );

//     return isWeb ? Expanded(child: cardContent) : cardContent;
//   }
// }

// // --- شبكة المواد ---
// class SubjectsGrid extends StatefulWidget {
//   const SubjectsGrid({super.key});

//   @override
//   State<SubjectsGrid> createState() => _SubjectsGridState();
// }

// class _SubjectsGridState extends State<SubjectsGrid> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _deptController = TextEditingController();
//   final TextEditingController _levelController = TextEditingController();
//   final TextEditingController _studentsController = TextEditingController();

//   List<Map<String, String>> subjectsList = [
//     {"title": "discrete - المستوى الأول", "dept": "علوم حاسوب", "exams": "1", "students": "340"},
//     {"title": "فيزياء عملي - المستوى الأول", "dept": "تقنية معلومات", "exams": "0", "students": "101"},
//     {"title": "تفاضل - المستوى الأول", "dept": "تقنية معلومات", "exams": "9", "students": "101"},
//     {"title": "تكامل - المستوى الأول", "dept": "تقنية معلومات", "exams": "0", "students": "101"},
//   ];

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _deptController.dispose();
//     _levelController.dispose();
//     _studentsController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         double width = constraints.maxWidth;
//         // نحدد إذا كان التصميم الحالي هو ويب أم لا للحفاظ على تصميمه
//         bool isWeb = width >= 800; 
        
//         // الويب يأخذ 3 أعمدة (نفس الكود حقك)، الفون والتابلت جعلناهم عمودين لكي يصغر المربع
//         int crossAxisCount = isWeb ? 3 : 2; 
//         double cardWidth = (width - (crossAxisCount - 1) * 20) / crossAxisCount;

//         return Wrap(
//           spacing: 20,
//           runSpacing: 20,
//           children: [
//             ...subjectsList.map((subject) {
//               return GestureDetector(
//                 onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SubjectDetailsPage())),
//                 child: _subjectCard(
//                   context, 
//                   cardWidth, 
//                   subject["title"] ?? "", 
//                   subject["dept"] ?? "", 
//                   subject["exams"] ?? "0", 
//                   subject["students"] ?? "0",
//                   isWeb 
//                 ),
//               );
//             }),
//             _addSubjectCard(context, cardWidth, isWeb),
//           ],
//         );
//       },
//     );
//   }

//   Widget _subjectCard(BuildContext context, double width, String title, String dept, String exams, String students, bool isWeb) {
//     return Container(
//       width: width,
//       // الويب يأخذ Padding 22 كما برمجته، الفون يصغر إلى 14
//       padding: EdgeInsets.all(isWeb ? 22 : 14),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(isWeb ? 28 : 20),
//         boxShadow: [BoxShadow(color: AppColors.textPrimary(context).withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5))]),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Icon(Icons.book_outlined, color: AppColors.primaryTeal(context), size: isWeb ? 30 : 22),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: isWeb ? 10 : 8, vertical: isWeb ? 6 : 4),
//                 decoration: BoxDecoration(color: AppColors.secondaryTeal(context), borderRadius: BorderRadius.circular(12)),
//                 child: Text(dept, style: TextStyle(fontSize: isWeb ? 11 : 9, color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold)),
//               )
//             ],
//           ),
//           SizedBox(height: isWeb ? 25 : 15),
//           Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isWeb ? 17 : 13, color: AppColors.textPrimary(context))),
//           SizedBox(height: isWeb ? 35 : 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _infoTile(context, "الامتحانات", exams, isWeb),
//               _infoTile(context, "عدد الطلاب", students, isWeb),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget _infoTile(BuildContext context, String label, String value, bool isWeb) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(color: AppColors.textSecondary(context), fontSize: isWeb ? 13 : 10)),
//         Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isWeb ? 18 : 14, color: AppColors.textPrimary(context))),
//       ],
//     );
//   }

//   Widget _addSubjectCard(BuildContext context, double width, bool isWeb) {
//     return InkWell(
//       onTap: () => _showAddSubjectDialog(context),
//       borderRadius: BorderRadius.circular(isWeb ? 28 : 20),
//       child: Container(
//         width: width,
//         // الويب يبقى ارتفاعه 220، الفون والتابلت يصغر ليتناسب مع البطاقات المصغرة
//         height: isWeb ? 220 : 130,
//         decoration: BoxDecoration(
//           color: AppColors.secondaryTeal(context).withValues(alpha: 0.4),
//           borderRadius: BorderRadius.circular(isWeb ? 28 : 20),
//           border: Border.all(color: AppColors.primaryTeal(context).withValues(alpha: 0.3), width: 1.5),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.add_circle_outline, color: AppColors.primaryTeal(context), size: isWeb ? 50 : 35),
//             SizedBox(height: isWeb ? 12 : 8),
//             Text("إضافة مادة", style: TextStyle(color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold, fontSize: isWeb ? 15 : 12)),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showAddSubjectDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//           child: Container(
//             width: 400,
//             padding: const EdgeInsets.all(25),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(25),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text("إضافة مادة جديدة",
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.textPrimary(context))),
//                 const SizedBox(height: 20),
//                 _buildField(context, "اسم المادة", _nameController),
//                 _buildField(context, "التخصص", _deptController),
//                 _buildField(context, "المستوى الدراسي", _levelController),
//                 _buildField(context, "عدد الطلاب", _studentsController, isNumber: true),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primaryTeal(context),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                     onPressed: () {
//                       if (_nameController.text.isNotEmpty) {
//                         setState(() {
//                           subjectsList.add({
//                             "title": "${_nameController.text} - ${_levelController.text.isNotEmpty ? _levelController.text : 'عام'}",
//                             "dept": _deptController.text.isNotEmpty ? _deptController.text : "تخصص عام",
//                             "exams": "0",
//                             "students": _studentsController.text.isNotEmpty ? _studentsController.text : "0",
//                           });
//                         });
//                         _nameController.clear();
//                         _deptController.clear();
//                         _levelController.clear();
//                         _studentsController.clear();
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: const Text("إضافة مادة", style: TextStyle(fontSize: 16)),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildField(BuildContext context, String label, TextEditingController controller, {bool isNumber = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextField(
//         controller: controller,
//         textAlign: TextAlign.right,
//         keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//         decoration: InputDecoration(
//           hintText: label,
//           filled: true,
//           fillColor: AppColors.secondaryTeal(context).withValues(alpha: 0.3),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'teacher_dashboard.dart';
// import '../core/colors.dart';
// import 'material_detail.dart';
// import 'grading.dart';
// import 'exam_page.dart';

// class Material1 extends StatefulWidget {
//   const Material1({super.key});

//   @override
//   State<Material1> createState() => _Material1State();
// }

// class _Material1State extends State<Material1> {
//   int _selectedIndex = 2;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: LayoutBuilder(builder: (context, constraints) {
//         bool isMobile = constraints.maxWidth < 800;
//         bool isTablet = constraints.maxWidth >= 800 && constraints.maxWidth < 1150;

//         return Scaffold(
//           key: _scaffoldKey,
//           backgroundColor: AppColors.secondaryTeal(context),
//           drawer: isMobile
//               ? Drawer(
//                   width: 260,
//                   backgroundColor: AppColors.primaryTeal(context),
//                   child: SafeArea(
//                     child: CustSidebar(
//                       selectedIndex: _selectedIndex,
//                       isCompact: false,
//                       onItemSelected: _handleNavigation,
//                     ),
//                   ),
//                 )
//               : null,
//           body: Row(
//             children: [
//               if (!isMobile)
//                 CustSidebar(
//                   selectedIndex: _selectedIndex,
//                   isCompact: isTablet,
//                   onItemSelected: _handleNavigation,
//                 ),
//               Expanded(
//                 child: Column(
//                   children: [
//                     if (isMobile) _buildMobileAppBar(),
//                     const Expanded(
//                       child: MainContent(),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildMobileAppBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Row(
//           children: [
//             IconButton(
//               icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)),
//               onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//             ),
//             const Spacer(),
//             const Text("المواد الدراسية", style: TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleNavigation(int index) {
//     if (index == _selectedIndex) return;
//     setState(() => _selectedIndex = index);
//     if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);

//     Widget? page;
//     if (index == 0) page = const DashboardScreen();
//     if (index == 1) page = const FinalExamPage();
//     if (index == 3) page = const GradingPage();

//     if (page != null) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => page!),
//         (route) => false,
//       );
//     }
//   }
// }

// class MainContent extends StatelessWidget {
//   const MainContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(24),
//       child: const Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           HeaderWidget(),
//           SizedBox(height: 25),
//           TopStatsGrid(), 
//           SizedBox(height: 35),
//           SubjectsGrid(), 
//         ],
//       ),
//     );
//   }
// }

// // --- الهيدر ---
// class HeaderWidget extends StatelessWidget {
//   const HeaderWidget({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("المواد الدراسية", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
//               const SizedBox(height: 4),
//               Text("قم بإدارة جميع المواد والامتحانات الخاصة بك", style: TextStyle(color: AppColors.textSecondary(context), fontSize: 12)),
//             ],
//           ),
//           Row(children: [_iconButton(context, Icons.notifications_none), const SizedBox(width: 10), _iconButton(context, Icons.person_outline)])
//         ],
//       ),
//     );
//   }
//   Widget _iconButton(BuildContext context, IconData icon) => Container(
//     padding: const EdgeInsets.all(8), 
//     decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle), 
//     child: Icon(icon, color: AppColors.primaryTeal(context))
//   );
// }

// // --- الإحصائيات العلوية ---
// class TopStatsGrid extends StatelessWidget {
//   const TopStatsGrid({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       double screenWidth = MediaQuery.of(context).size.width;
//       bool isWeb = screenWidth >= 1150;
//       bool isMobile = screenWidth < 800;

//       // 1. التابلت والفون: جعلها قابلة للتمرير أفقياً
//       if (!isWeb) {
//         // حجم الكارت في الفون 180، وفي التابلت 260 ليطابق حجم الويب تقريباً
//         double cardWidth = isMobile ? 180 : 260; 
        
//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           physics: const BouncingScrollPhysics(),
//           child: Row(
//             children: [
//               _statCard(context, "الطلاب", "340", AppColors.accentYellow(context), Icons.people, isWeb: false, customWidth: cardWidth),
//               _statCard(context, "الأوراق المصححة", "780", AppColors.primaryTeal(context), Icons.description, isWeb: false, customWidth: cardWidth),
//               _statCard(context, "الاختبارات المنشئة", "13", AppColors.primaryTeal(context), Icons.create, isWeb: false, customWidth: cardWidth),
//               _statCard(context, "المسودات", "5", AppColors.primaryTeal(context), Icons.edit_note, isWeb: false, customWidth: cardWidth),
//             ],
//           ),
//         );
//       }

//       // 2. الويب: يبقى كما هو تماماً (صف واحد ممتد)
//       return Row(
//         children: [
//           _statCard(context, "الطلاب", "340", AppColors.accentYellow(context), Icons.people, isWeb: true),
//           _statCard(context, "الأوراق المصححة", "780", AppColors.primaryTeal(context), Icons.description, isWeb: true),
//           _statCard(context, "الاختبارات المنشئة", "13", AppColors.primaryTeal(context), Icons.create, isWeb: true),
//           _statCard(context, "المسودات", "5", AppColors.primaryTeal(context), Icons.edit_note, isWeb: true),
//         ],
//       );
//     });
//   }

//   Widget _statCard(BuildContext context, String title, String value, Color color, IconData icon, {required bool isWeb, double? customWidth}) {
//     Widget cardContent = Container(
//       width: customWidth, // سيأخذ العرض المخصص في حالة الجوال والتابلت
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
//               Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
//             ],
//           ),
//           Icon(icon, color: Colors.white54, size: 35),
//         ],
//       ),
//     );

//     return isWeb ? Expanded(child: cardContent) : cardContent;
//   }
// }

// // --- شبكة المواد ---
// class SubjectsGrid extends StatefulWidget {
//   const SubjectsGrid({super.key});

//   @override
//   State<SubjectsGrid> createState() => _SubjectsGridState();
// }

// class _SubjectsGridState extends State<SubjectsGrid> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _deptController = TextEditingController();
//   final TextEditingController _levelController = TextEditingController();
//   final TextEditingController _studentsController = TextEditingController();

//   List<Map<String, String>> subjectsList = [
//     {"title": "discrete - المستوى الأول", "dept": "علوم حاسوب", "exams": "1", "students": "340"},
//     {"title": "فيزياء عملي - المستوى الأول", "dept": "تقنية معلومات", "exams": "0", "students": "101"},
//     {"title": "تفاضل - المستوى الأول", "dept": "تقنية معلومات", "exams": "9", "students": "101"},
//     {"title": "تكامل - المستوى الأول", "dept": "تقنية معلومات", "exams": "0", "students": "101"},
//   ];

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _deptController.dispose();
//     _levelController.dispose();
//     _studentsController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         double width = constraints.maxWidth;
        
//         // --- التعديل فقط هنا لضبط التابلت ---
//         bool isWebScreen = width >= 1150; 
//         bool isTabletScreen = width >= 800 && width < 1150;
        
//         // الويب والتابلت يأخذون 3 أعمدة، الفون عمودين 
//         int crossAxisCount = (isWebScreen || isTabletScreen) ? 3 : 2; 
//         double cardWidth = (width - (crossAxisCount - 1) * 20) / crossAxisCount;

//         return Wrap(
//           spacing: 20,
//           runSpacing: 20,
//           children: [
//             ...subjectsList.map((subject) {
//               return GestureDetector(
//                 onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SubjectDetailsPage())),
//                 child: _subjectCard(
//                   context, 
//                   cardWidth, 
//                   subject["title"] ?? "", 
//                   subject["dept"] ?? "", 
//                   subject["exams"] ?? "0", 
//                   subject["students"] ?? "0",
//                   isWebScreen // التابلت هنا سيتعامل كـ false ليأخذ الحجم الصغير زي الفون
//                 ),
//               );
//             }),
//             _addSubjectCard(context, cardWidth, isWebScreen),
//           ],
//         );
//       },
//     );
//   }

//   Widget _subjectCard(BuildContext context, double width, String title, String dept, String exams, String students, bool isWeb) {
//     return Container(
//       width: width,
//       // الويب يأخذ Padding 22 كما برمجته، الفون والتابلت يصغر إلى 14
//       padding: EdgeInsets.all(isWeb ? 22 : 14),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(isWeb ? 28 : 20),
//         boxShadow: [BoxShadow(color: AppColors.textPrimary(context).withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5))]),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Icon(Icons.book_outlined, color: AppColors.primaryTeal(context), size: isWeb ? 30 : 22),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: isWeb ? 10 : 8, vertical: isWeb ? 6 : 4),
//                 decoration: BoxDecoration(color: AppColors.secondaryTeal(context), borderRadius: BorderRadius.circular(12)),
//                 child: Text(dept, style: TextStyle(fontSize: isWeb ? 11 : 9, color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold)),
//               )
//             ],
//           ),
//           SizedBox(height: isWeb ? 25 : 15),
//           Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isWeb ? 17 : 13, color: AppColors.textPrimary(context))),
//           SizedBox(height: isWeb ? 35 : 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _infoTile(context, "الامتحانات", exams, isWeb),
//               _infoTile(context, "عدد الطلاب", students, isWeb),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget _infoTile(BuildContext context, String label, String value, bool isWeb) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(color: AppColors.textSecondary(context), fontSize: isWeb ? 13 : 10)),
//         Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isWeb ? 18 : 14, color: AppColors.textPrimary(context))),
//       ],
//     );
//   }

//   Widget _addSubjectCard(BuildContext context, double width, bool isWeb) {
//     return InkWell(
//       onTap: () => _showAddSubjectDialog(context),
//       borderRadius: BorderRadius.circular(isWeb ? 28 : 20),
//       child: Container(
//         width: width,
//         // الويب يبقى ارتفاعه 220، الفون والتابلت يصغر ليتناسب مع البطاقات المصغرة
//         height: isWeb ? 220 : 130,
//         decoration: BoxDecoration(
//           color: AppColors.secondaryTeal(context).withValues(alpha: 0.4),
//           borderRadius: BorderRadius.circular(isWeb ? 28 : 20),
//           border: Border.all(color: AppColors.primaryTeal(context).withValues(alpha: 0.3), width: 1.5),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.add_circle_outline, color: AppColors.primaryTeal(context), size: isWeb ? 50 : 35),
//             SizedBox(height: isWeb ? 12 : 8),
//             Text("إضافة مادة", style: TextStyle(color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold, fontSize: isWeb ? 15 : 12)),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showAddSubjectDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//           child: Container(
//             width: 400,
//             padding: const EdgeInsets.all(25),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(25),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text("إضافة مادة جديدة",
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.textPrimary(context))),
//                 const SizedBox(height: 20),
//                 _buildField(context, "اسم المادة", _nameController),
//                 _buildField(context, "التخصص", _deptController),
//                 _buildField(context, "المستوى الدراسي", _levelController),
//                 _buildField(context, "عدد الطلاب", _studentsController, isNumber: true),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primaryTeal(context),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                     onPressed: () {
//                       if (_nameController.text.isNotEmpty) {
//                         setState(() {
//                           subjectsList.add({
//                             "title": "${_nameController.text} - ${_levelController.text.isNotEmpty ? _levelController.text : 'عام'}",
//                             "dept": _deptController.text.isNotEmpty ? _deptController.text : "تخصص عام",
//                             "exams": "0",
//                             "students": _studentsController.text.isNotEmpty ? _studentsController.text : "0",
//                           });
//                         });
//                         _nameController.clear();
//                         _deptController.clear();
//                         _levelController.clear();
//                         _studentsController.clear();
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: const Text("إضافة مادة", style: TextStyle(fontSize: 16)),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildField(BuildContext context, String label, TextEditingController controller, {bool isNumber = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextField(
//         controller: controller,
//         textAlign: TextAlign.right,
//         keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//         decoration: InputDecoration(
//           hintText: label,
//           filled: true,
//           fillColor: AppColors.secondaryTeal(context).withValues(alpha: 0.3),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'teacher_dashboard.dart'; // تأكدي إن CustSidebar موجود هنا أو استدعيه من مساره الصحيح
// import '../core/colors.dart';
// import 'material_detail.dart';
// import 'grading.dart';
// import 'exam_page.dart';
// import '../generated/l10n.dart'; // استيراد كلاس الترجمة

// class Material1 extends StatefulWidget {
//   const Material1({super.key});

//   @override
//   State<Material1> createState() => _Material1State();
// }

// class _Material1State extends State<Material1> {
//   int _selectedIndex = 2;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     // تم إزالة Directionality الثابت ليعمل مع اللغتين
//     return LayoutBuilder(builder: (context, constraints) {
//       bool isMobile = constraints.maxWidth < 800;
//       bool isTablet = constraints.maxWidth >= 800 && constraints.maxWidth < 1150;

//       return Scaffold(
//         key: _scaffoldKey,
//         backgroundColor: AppColors.secondaryTeal(context),
//         drawer: isMobile
//             ? Drawer(
//                 width: 260,
//                 backgroundColor: AppColors.primaryTeal(context),
//                 child: SafeArea(
//                   child: CustSidebar(
//                     selectedIndex: _selectedIndex,
//                     isCompact: false,
//                     onItemSelected: _handleNavigation,
//                   ),
//                 ),
//               )
//             : null,
//         body: Row(
//           children: [
//             if (!isMobile)
//               CustSidebar(
//                 selectedIndex: _selectedIndex,
//                 isCompact: isTablet,
//                 onItemSelected: _handleNavigation,
//               ),
//             Expanded(
//               child: Column(
//                 children: [
//                   if (isMobile) _buildMobileAppBar(context),
//                   const Expanded(
//                     child: MainContent(),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }

//   Widget _buildMobileAppBar(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Row(
//           children: [
//             IconButton(
//               icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)),
//               onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//             ),
//             const Spacer(),
//             Text(S.of(context).materials, style: const TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleNavigation(int index) {
//     if (index == _selectedIndex) return;
//     setState(() => _selectedIndex = index);
//     if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);

//     Widget? page;
//     if (index == 0) page = const DashboardScreen();
//     if (index == 1) page = const FinalExamPage();
//     if (index == 3) page = const GradingPage();

//     if (page != null) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => page!),
//         (route) => false,
//       );
//     }
//   }
// }

// class MainContent extends StatelessWidget {
//   const MainContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(24),
//       child: const Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           HeaderWidget(),
//           SizedBox(height: 25),
//           TopStatsGrid(), 
//           SizedBox(height: 35),
//           SubjectsGrid(), 
//         ],
//       ),
//     );
//   }
// }

// // --- الهيدر ---
// class HeaderWidget extends StatelessWidget {
//   const HeaderWidget({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(S.of(context).materials, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
//               const SizedBox(height: 4),
//               Text(S.of(context).manage_your_materials_and_exams, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 12)),
//             ],
//           ),
//           Row(children: [_iconButton(context, Icons.notifications_none), const SizedBox(width: 10), _iconButton(context, Icons.person_outline)])
//         ],
//       ),
//     );
//   }
//   Widget _iconButton(BuildContext context, IconData icon) => Container(
//     padding: const EdgeInsets.all(8), 
//     decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle), 
//     child: Icon(icon, color: AppColors.primaryTeal(context))
//   );
// }

// // --- الإحصائيات العلوية ---
// class TopStatsGrid extends StatelessWidget {
//   const TopStatsGrid({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       double screenWidth = MediaQuery.of(context).size.width;
//       bool isWeb = screenWidth >= 1150;
//       bool isMobile = screenWidth < 800;

//       if (!isWeb) {
//         double cardWidth = isMobile ? 180 : 260; 
//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           physics: const BouncingScrollPhysics(),
//           child: Row(
//             children: [
//               _statCard(context, S.of(context).students, "340", AppColors.accentYellow(context), Icons.people, isWeb: false, customWidth: cardWidth),
//               _statCard(context, S.of(context).corrected_papers, "780", AppColors.primaryTeal(context), Icons.description, isWeb: false, customWidth: cardWidth),
//               _statCard(context, S.of(context).created_exams, "13", AppColors.primaryTeal(context), Icons.create, isWeb: false, customWidth: cardWidth),
//               _statCard(context, S.of(context).drafts, "5", AppColors.primaryTeal(context), Icons.edit_note, isWeb: false, customWidth: cardWidth),
//             ],
//           ),
//         );
//       }

//       return Row(
//         children: [
//           _statCard(context, S.of(context).students, "340", AppColors.accentYellow(context), Icons.people, isWeb: true),
//           _statCard(context, S.of(context).corrected_papers, "780", AppColors.primaryTeal(context), Icons.description, isWeb: true),
//           _statCard(context, S.of(context).created_exams, "13", AppColors.primaryTeal(context), Icons.create, isWeb: true),
//           _statCard(context, S.of(context).drafts, "5", AppColors.primaryTeal(context), Icons.edit_note, isWeb: true),
//         ],
//       );
//     });
//   }

//   Widget _statCard(BuildContext context, String title, String value, Color color, IconData icon, {required bool isWeb, double? customWidth}) {
//     Widget cardContent = Container(
//       width: customWidth, 
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
//               Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
//             ],
//           ),
//           Icon(icon, color: Colors.white54, size: 35),
//         ],
//       ),
//     );

//     return isWeb ? Expanded(child: cardContent) : cardContent;
//   }
// }

// // --- شبكة المواد ---
// class SubjectsGrid extends StatefulWidget {
//   const SubjectsGrid({super.key});

//   @override
//   State<SubjectsGrid> createState() => _SubjectsGridState();
// }

// class _SubjectsGridState extends State<SubjectsGrid> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _deptController = TextEditingController();
//   final TextEditingController _levelController = TextEditingController();
//   final TextEditingController _studentsController = TextEditingController();

//   List<Map<String, String>> subjectsList = [
//     {"title": "discrete - المستوى الأول", "dept": "علوم حاسوب", "exams": "1", "students": "340"},
//     {"title": "فيزياء عملي - المستوى الأول", "dept": "تقنية معلومات", "exams": "0", "students": "101"},
//     {"title": "تفاضل - المستوى الأول", "dept": "تقنية معلومات", "exams": "9", "students": "101"},
//     {"title": "تكامل - المستوى الأول", "dept": "تقنية معلومات", "exams": "0", "students": "101"},
//   ];

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _deptController.dispose();
//     _levelController.dispose();
//     _studentsController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         double width = constraints.maxWidth;
//         bool isWebScreen = width >= 1150; 
//         bool isTabletScreen = width >= 800 && width < 1150;
        
//         int crossAxisCount = (isWebScreen || isTabletScreen) ? 3 : 2; 
//         double cardWidth = (width - (crossAxisCount - 1) * 20) / crossAxisCount;

//         return Wrap(
//           spacing: 20,
//           runSpacing: 20,
//           children: [
//             ...subjectsList.map((subject) {
//               return GestureDetector(
//                 onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SubjectDetailsPage())),
//                 child: _subjectCard(
//                   context, 
//                   cardWidth, 
//                   subject["title"] ?? "", 
//                   subject["dept"] ?? "", 
//                   subject["exams"] ?? "0", 
//                   subject["students"] ?? "0",
//                   isWebScreen 
//                 ),
//               );
//             }),
//             _addSubjectCard(context, cardWidth, isWebScreen),
//           ],
//         );
//       },
//     );
//   }

//   Widget _subjectCard(BuildContext context, double width, String title, String dept, String exams, String students, bool isWeb) {
//     return Container(
//       width: width,
//       padding: EdgeInsets.all(isWeb ? 22 : 14),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(isWeb ? 28 : 20),
//         boxShadow: [BoxShadow(color: AppColors.textPrimary(context).withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5))]),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Icon(Icons.book_outlined, color: AppColors.primaryTeal(context), size: isWeb ? 30 : 22),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: isWeb ? 10 : 8, vertical: isWeb ? 6 : 4),
//                 decoration: BoxDecoration(color: AppColors.secondaryTeal(context), borderRadius: BorderRadius.circular(12)),
//                 child: Text(dept, style: TextStyle(fontSize: isWeb ? 11 : 9, color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold)),
//               )
//             ],
//           ),
//           SizedBox(height: isWeb ? 25 : 15),
//           Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isWeb ? 17 : 13, color: AppColors.textPrimary(context))),
//           SizedBox(height: isWeb ? 35 : 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // ترجمنا العناوين هنا
//               _infoTile(context, S.of(context).exams, exams, isWeb),
//               _infoTile(context, S.of(context).number_of_students, students, isWeb),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget _infoTile(BuildContext context, String label, String value, bool isWeb) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(color: AppColors.textSecondary(context), fontSize: isWeb ? 13 : 10)),
//         Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isWeb ? 18 : 14, color: AppColors.textPrimary(context))),
//       ],
//     );
//   }

//   Widget _addSubjectCard(BuildContext context, double width, bool isWeb) {
//     return InkWell(
//       onTap: () => _showAddSubjectDialog(context),
//       borderRadius: BorderRadius.circular(isWeb ? 28 : 20),
//       child: Container(
//         width: width,
//         height: isWeb ? 220 : 130,
//         decoration: BoxDecoration(
//           color: AppColors.secondaryTeal(context).withValues(alpha: 0.4),
//           borderRadius: BorderRadius.circular(isWeb ? 28 : 20),
//           border: Border.all(color: AppColors.primaryTeal(context).withValues(alpha: 0.3), width: 1.5),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.add_circle_outline, color: AppColors.primaryTeal(context), size: isWeb ? 50 : 35),
//             SizedBox(height: isWeb ? 12 : 8),
//             Text(S.of(context).add_subject, style: TextStyle(color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold, fontSize: isWeb ? 15 : 12)),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showAddSubjectDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//           child: Container(
//             width: 400,
//             padding: const EdgeInsets.all(25),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(25),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(S.of(context).add_new_subject,
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.textPrimary(context))),
//                 const SizedBox(height: 20),
//                 _buildField(context, S.of(context).subject_name, _nameController),
//                 _buildField(context, S.of(context).department, _deptController),
//                 _buildField(context, S.of(context).study_level, _levelController),
//                 _buildField(context, S.of(context).number_of_students, _studentsController, isNumber: true),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primaryTeal(context),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                     onPressed: () {
//                       if (_nameController.text.isNotEmpty) {
//                         setState(() {
//                           subjectsList.add({
//                             "title": "${_nameController.text} - ${_levelController.text.isNotEmpty ? _levelController.text : S.of(context).general}",
//                             "dept": _deptController.text.isNotEmpty ? _deptController.text : S.of(context).general_department,
//                             "exams": "0",
//                             "students": _studentsController.text.isNotEmpty ? _studentsController.text : "0",
//                           });
//                         });
//                         _nameController.clear();
//                         _deptController.clear();
//                         _levelController.clear();
//                         _studentsController.clear();
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: Text(S.of(context).add_subject, style: const TextStyle(fontSize: 16)),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildField(BuildContext context, String label, TextEditingController controller, {bool isNumber = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextField(
//         controller: controller,
//         // تم تغيير textAlign ليكون ذكي حسب اللغة
//         textAlign: TextAlign.start,
//         keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//         decoration: InputDecoration(
//           hintText: label,
//           filled: true,
//           fillColor: AppColors.secondaryTeal(context).withValues(alpha: 0.3),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'teacher_dashboard.dart'; // تأكدي إن CustSidebar موجود هنا أو استدعيه من مساره الصحيح
import '../core/colors.dart';
import 'material_detail.dart';
import 'grading.dart';
import 'exam_page.dart';
import '../generated/l10n.dart'; // استيراد كلاس الترجمة

class Material1 extends StatefulWidget {
  const Material1({super.key});

  @override
  State<Material1> createState() => _Material1State();
}

class _Material1State extends State<Material1> {
  int _selectedIndex = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 800;
      bool isTablet = constraints.maxWidth >= 800 && constraints.maxWidth < 1150;

      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.secondaryTeal(context),
        drawer: isMobile
            ? Drawer(
                width: 260,
                backgroundColor: AppColors.primaryTeal(context),
                child: SafeArea(
                  child: CustSidebar(
                    selectedIndex: _selectedIndex,
                    isCompact: false,
                    onItemSelected: _handleNavigation,
                  ),
                ),
              )
            : null,
        body: Row(
          children: [
            if (!isMobile) ...[
              CustSidebar(
                selectedIndex: _selectedIndex,
                isCompact: isTablet,
                onItemSelected: _handleNavigation,
              )
            ],
            Expanded(
              child: Column(
                children: [
                  if (isMobile) ...[
                    _buildMobileAppBar(context)
                  ],
                  const Expanded(
                    child: MainContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMobileAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            const Spacer(),
            Text(S.of(context).materials, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.pop(context);
    }

    Widget? page;
    if (index == 0) { page = const DashboardScreen(); }
    if (index == 1) { page = const FinalExamPage(); }
    if (index == 3) { page = const GradingPage(); }

    if (page != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => page!),
        (route) => false,
      );
    }
  }
}

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWidget(),
          SizedBox(height: 25),
          TopStatsGrid(), 
          SizedBox(height: 35),
          SubjectsGrid(), 
        ],
      ),
    );
  }
}

// --- الهيدر ---
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).materials, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
              const SizedBox(height: 4),
              Text(S.of(context).manage_your_materials_and_exams, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 12)),
            ],
          ),
          Row(children: [_iconButton(context, Icons.notifications_none), const SizedBox(width: 10), _iconButton(context, Icons.person_outline)])
        ],
      ),
    );
  }
  Widget _iconButton(BuildContext context, IconData icon) => Container(
    padding: const EdgeInsets.all(8), 
    decoration: BoxDecoration(color: AppColors.secondaryTeal(context), shape: BoxShape.circle), 
    child: Icon(icon, color: AppColors.primaryTeal(context))
  );
}

// --- الإحصائيات العلوية ---
class TopStatsGrid extends StatelessWidget {
  const TopStatsGrid({super.key});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double screenWidth = MediaQuery.of(context).size.width;
      bool isWeb = screenWidth >= 1150;
      bool isMobile = screenWidth < 800;

      if (!isWeb) {
        double cardWidth = isMobile ? 180 : 260; 
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _statCard(context, S.of(context).students, "340", AppColors.accentYellow(context), Icons.people, isWeb: false, customWidth: cardWidth),
              _statCard(context, S.of(context).corrected_papers, "780", AppColors.primaryTeal(context), Icons.description, isWeb: false, customWidth: cardWidth),
              _statCard(context, S.of(context).created_exams, "13", AppColors.primaryTeal(context), Icons.create, isWeb: false, customWidth: cardWidth),
              _statCard(context, S.of(context).drafts, "5", AppColors.primaryTeal(context), Icons.edit_note, isWeb: false, customWidth: cardWidth),
            ],
          ),
        );
      }

      return Row(
        children: [
          _statCard(context, S.of(context).students, "340", AppColors.accentYellow(context), Icons.people, isWeb: true),
          _statCard(context, S.of(context).corrected_papers, "780", AppColors.primaryTeal(context), Icons.description, isWeb: true),
          _statCard(context, S.of(context).created_exams, "13", AppColors.primaryTeal(context), Icons.create, isWeb: true),
          _statCard(context, S.of(context).drafts, "5", AppColors.primaryTeal(context), Icons.edit_note, isWeb: true),
        ],
      );
    });
  }

  Widget _statCard(BuildContext context, String title, String value, Color color, IconData icon, {required bool isWeb, double? customWidth}) {
    Widget cardContent = Container(
      width: customWidth, 
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          Icon(icon, color: Colors.white54, size: 35),
        ],
      ),
    );

    return isWeb ? Expanded(child: cardContent) : cardContent;
  }
}

// --- شبكة المواد ---
class SubjectsGrid extends StatefulWidget {
  const SubjectsGrid({super.key});

  @override
  State<SubjectsGrid> createState() => _SubjectsGridState();
}

class _SubjectsGridState extends State<SubjectsGrid> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _studentsController = TextEditingController();

  List<Map<String, String>> subjectsList = [];
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      subjectsList = [
        {"title": S.of(context).subject_discrete, "dept": S.of(context).dept_cs, "exams": "1", "students": "340"},
        {"title": S.of(context).subject_physics, "dept": S.of(context).dept_it, "exams": "0", "students": "101"},
        {"title": S.of(context).subject_calculus, "dept": S.of(context).dept_it, "exams": "9", "students": "101"},
        {"title": S.of(context).subject_integration, "dept": S.of(context).dept_it, "exams": "0", "students": "101"},
      ];
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _deptController.dispose();
    _levelController.dispose();
    _studentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        bool isWebScreen = width >= 1150; 
        bool isTabletScreen = width >= 800 && width < 1150;
        
        int crossAxisCount = (isWebScreen || isTabletScreen) ? 3 : 2; 
        double cardWidth = (width - (crossAxisCount - 1) * 20) / crossAxisCount;

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            ...subjectsList.map((subject) {
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SubjectDetailsPage())),
                child: _subjectCard(
                  context, 
                  cardWidth, 
                  subject["title"] ?? "", 
                  subject["dept"] ?? "", 
                  subject["exams"] ?? "0", 
                  subject["students"] ?? "0",
                  isWebScreen 
                ),
              );
            }),
            _addSubjectCard(context, cardWidth, isWebScreen),
          ],
        );
      },
    );
  }

  Widget _subjectCard(BuildContext context, double width, String title, String dept, String exams, String students, bool isWeb) {
    return Container(
      width: width,
      padding: EdgeInsets.all(isWeb ? 22 : 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(isWeb ? 28 : 20),
        boxShadow: [BoxShadow(color: AppColors.textPrimary(context).withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.book_outlined, color: AppColors.primaryTeal(context), size: isWeb ? 30 : 22),
              Container(
                padding: EdgeInsets.symmetric(horizontal: isWeb ? 10 : 8, vertical: isWeb ? 6 : 4),
                decoration: BoxDecoration(color: AppColors.secondaryTeal(context), borderRadius: BorderRadius.circular(12)),
                child: Text(dept, style: TextStyle(fontSize: isWeb ? 11 : 9, color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold)),
              )
            ],
          ),
          SizedBox(height: isWeb ? 25 : 15),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isWeb ? 17 : 13, color: AppColors.textPrimary(context))),
          SizedBox(height: isWeb ? 35 : 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoTile(context, S.of(context).exams, exams, isWeb),
              _infoTile(context, S.of(context).number_of_students, students, isWeb),
            ],
          )
        ],
      ),
    );
  }

  Widget _infoTile(BuildContext context, String label, String value, bool isWeb) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColors.textSecondary(context), fontSize: isWeb ? 13 : 10)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isWeb ? 18 : 14, color: AppColors.textPrimary(context))),
      ],
    );
  }

  Widget _addSubjectCard(BuildContext context, double width, bool isWeb) {
    return InkWell(
      onTap: () => _showAddSubjectDialog(context),
      borderRadius: BorderRadius.circular(isWeb ? 28 : 20),
      child: Container(
        width: width,
        height: isWeb ? 220 : 130,
        decoration: BoxDecoration(
          color: AppColors.secondaryTeal(context).withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(isWeb ? 28 : 20),
          border: Border.all(color: AppColors.primaryTeal(context).withValues(alpha: 0.3), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: AppColors.primaryTeal(context), size: isWeb ? 50 : 35),
            SizedBox(height: isWeb ? 12 : 8),
            Text(S.of(context).add_subject, style: TextStyle(color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold, fontSize: isWeb ? 15 : 12)),
          ],
        ),
      ),
    );
  }

  void _showAddSubjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(S.of(context).add_new_subject,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context))),
                const SizedBox(height: 20),
                _buildField(context, S.of(context).subject_name, _nameController),
                _buildField(context, S.of(context).department, _deptController),
                _buildField(context, S.of(context).study_level, _levelController),
                _buildField(context, S.of(context).number_of_students, _studentsController, isNumber: true),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTeal(context),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (_nameController.text.isNotEmpty) {
                        setState(() {
                          subjectsList.add({
                            "title": "${_nameController.text} - ${_levelController.text.isNotEmpty ? _levelController.text : S.of(context).general}",
                            "dept": _deptController.text.isNotEmpty ? _deptController.text : S.of(context).general_department,
                            "exams": "0",
                            "students": _studentsController.text.isNotEmpty ? _studentsController.text : "0",
                          });
                        });
                        _nameController.clear();
                        _deptController.clear();
                        _levelController.clear();
                        _studentsController.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: Text(S.of(context).add_subject, style: const TextStyle(fontSize: 16)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildField(BuildContext context, String label, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.start,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: AppColors.secondaryTeal(context).withValues(alpha: 0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}