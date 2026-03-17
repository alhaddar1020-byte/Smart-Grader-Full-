// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import '../core/colors.dart';
// import 'teacher_dashboard.dart';
// import 'teacher_matearial.dart';
// class GradingPage extends StatefulWidget {
//   const GradingPage({super.key});

//   @override
//   State<GradingPage> createState() => _GradingPageState();
// }

// class _GradingPageState extends State<GradingPage> {
//   final TextEditingController subjectController = TextEditingController(text: "البرمجة المتقدمة");
//   final TextEditingController examNameController = TextEditingController(text: "الامتحان النصفي");
//   final TextEditingController dateController = TextEditingController(text: "2026/03/11");
//   final TextEditingController questionsCountController = TextEditingController(text: "4");
//   final TextEditingController totalGradeController = TextEditingController(text: "50");

//   List<PlatformFile> selectedFiles = [];
//   bool isGrading = false; // التحكم في حالة التصحيح
//   bool isGradingComplete = false;
//   Future<void> pickFiles() async {
//     if (isGrading) return;
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       allowMultiple: true,
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       setState(() {
//         selectedFiles.addAll(result.files);
//       });
//     }
//   }

//   @override
//   void dispose() {
//     subjectController.dispose();
//     examNameController.dispose();
//     dateController.dispose();
//     questionsCountController.dispose();
//     totalGradeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool hasFiles = selectedFiles.isNotEmpty;

//     return Scaffold(
//       backgroundColor: AppColors.secondaryTeal,
//       body: Row(
//         children: [
//           CustSidebar(
//           selectedIndex: 3,
//           onItemSelected: (index) {

//             if (index == 0) {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const DashboardScreen()),
//               );
//             }

//             else if (index == 2) {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const Material1()),
//               );
//             }

//           },
// ), 
//           Expanded(
//             child: Directionality(
//               textDirection: TextDirection.rtl,
//               child: Container(
//                 alignment: Alignment.topCenter,
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
                      
//                       const HeaderWidget(),
//                       const SizedBox(height: 15),
//                       _buildExamInfoSection(),
//                       const SizedBox(height: 15),

//                       /// الكاردات العلوية
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildUploadCard(),
//                           const SizedBox(width: 20),
//                           _buildStatusCard(hasFiles),
//                         ],
//                       ),

//                       // القسم السفلي المتغير بناءً على الصورة
//                       const SizedBox(height: 25),
//                       if (isGradingComplete)
//                         _buildCompleteCard() 
//                       else if (isGrading)
//                         _buildProcessingCard() 
//                       else if (hasFiles)
//                         _buildFileListSection(),

//                       const SizedBox(height: 40),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//        ],
//       ),
//     );
//   }

//   /* --- 1. كارد جاري التصحيح الآلي (تصميم الصورة) --- */
//   Widget _buildProcessingCard() {
//   return Container(
//     width: double.infinity,
//     padding: const EdgeInsets.all(24),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.05),
//           blurRadius: 10,
//           offset: const Offset(0, 4),
//         )
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [

//         /// العنوان
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             Icon(Icons.warning_amber_rounded,
//                 color: Colors.orange, size: 28),
//             SizedBox(width: 8),
//             Text(
//               "جاري التصحيح الآلي...",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textprimary,
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 8),

//         const Center(
//           child: Text(
//             "يرجى عدم إغلاق هذه الصفحة أثناء عملية التصحيح الآلي، النظام يعمل على معالجة جميع الأوراق بشكل تلقائي.",
//             style: TextStyle(fontSize: 12, color: Colors.grey),
//             textAlign: TextAlign.center,
//           ),
//         ),

//         const SizedBox(height: 15),

//         /// نسبة التقدم
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: const [
            
//             Text("التقدم الكلي",
//                 style: TextStyle(fontSize: 12, color: Colors.black)),
//                 Text("29 / 120",
//                 style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.orange)),
//           ],
//         ),

//         const SizedBox(height: 10),

//         /// progress bar
//         ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: const LinearProgressIndicator(
//             value: 0.24,
//             minHeight: 10,
//             backgroundColor: Color(0xFFE5E5E5),
//             valueColor:
//                 AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
//           ),
//         ),

//         const SizedBox(height: 6),

//         const Align(
//           alignment: Alignment.centerLeft,
//           child: Text(
//             "الوقت المتبقي: 00:29",
//             style: TextStyle(fontSize: 11, color: Colors.grey),
//           ),
//         ),

//         const SizedBox(height: 15),

//         /// الإحصائيات
//         Row(
//           children: [
//              _statBox("29", "مكتملة", Icons.check_circle),
//               const SizedBox(width: 10),
//               _statBox("3", "قيد المعالجة", Icons.sync),
//               const SizedBox(width: 10),
//                _statBox("88", "في الانتظار", Icons.access_time),
//                 const SizedBox(width: 10),
//             _statBox("2", "دقيقة متبقية (تقريباً)", Icons.trending_up),
//           ],
//         )
//       ],
//     ),
//   );
  
// }

// Widget _buildCompleteCard() {
//   return Container(
//     width: double.infinity,
//     padding: const EdgeInsets.all(24),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.05),
//           blurRadius: 10,
//           offset: const Offset(0, 4),
//         )
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [

//         /// الايقونة + النص في الوسط
//         const Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.check_circle_outline,
//               color: Colors.green,
//               size: 28,
//             ),
//             SizedBox(width: 8),
//             Text(
//               "اكتمل التصحيح الآلي!",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textprimary,
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 15),

//         /// زر عرض الاوراق
//         ElevatedButton(
//           onPressed: () {},
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primaryTeal,
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           ),
//           child: const Text(
//             "عرض الاوراق المصححة",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),

//         const SizedBox(height: 10),

//         const Text(
//           "تم الانتهاء من تصحيح جميع الأوراق بنجاح، يمكنك الآن مراجعة النتائج.",
//           style: TextStyle(fontSize: 12, color: Colors.grey),
//           textAlign: TextAlign.center,
//         ),

//         const SizedBox(height: 20),

//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: const [
//             Text("التقدم الكلي"),
//             Text(
//               "120 / 120",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 10),

//         ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: const LinearProgressIndicator(
//             value: 1,
//             minHeight: 10,
//             backgroundColor: Color(0xFFE5E5E5),
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
//           ),
//         ),

//         const SizedBox(height: 20),

//         Row(
//           children: [
//             _statBox("120", "مكتملة", Icons.check_circle),
//             const SizedBox(width: 10),
//             _statBox("0", "قيد المعالجة", Icons.sync),
//             const SizedBox(width: 10),
//             _statBox("0", "في الانتظار", Icons.access_time),
//             const SizedBox(width: 10),
//             _statBox("0", "دقيقة متبقية", Icons.trending_up),
//           ],
//         ),
//       ],
//     ),
//   );
// }
// Widget _statBox(String number, String label, IconData icon) {
//   return Expanded(
//     child: Container(
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xFFE0E0E0), // رمادي مثل الأزرار
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [

//           /// الأيقونة يسار - الرقم يمين
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Icon(
//                 icon,
//                 size: 20,
//                 color: AppColors.primaryTeal,
//               ),
//               Text(
//                 number,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textprimary,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 8),

//           /// النص تحت
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 11,
//               color: AppColors.textseccondary,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//   /* --- 2. كارد رفع الملفات (مع حالة التعطيل) --- */
//   Widget _buildUploadCard() {
//     return Expanded(
//       flex: 2,
//       child: Container(
//         height: 200,
//         decoration: BoxDecoration(
//           color: AppColors.textWhite,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.black12),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.cloud_upload_outlined, size: 50, color: isGrading ? Colors.grey : AppColors.primaryTeal),
//             const SizedBox(height: 10),
//             const Text("انقر لتحديد الملفات من جهازك"),
//             const SizedBox(height: 15),
//             ElevatedButton.icon(
//               onPressed: isGrading ? null : pickFiles,
//               icon: const Icon(Icons.file_upload, color: Colors.white),
//               label: const Text("اختر الملفات", style: TextStyle(color: Colors.white)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: isGrading ? Colors.grey[400] : AppColors.primaryTeal,
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /* --- 3. كارد الحالة (مع حالة التعطيل) --- */
//   Widget _buildStatusCard(bool hasFiles) {
//     return Expanded(
//       flex: 3,
//       child: Container(
//         height: 200,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(16)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               hasFiles ? Icons.check_circle_outline_rounded : Icons.priority_high_rounded,
//               size: 40,
//               color: isGrading ? Colors.grey : (hasFiles ? AppColors.primaryTeal : Colors.orange),
//             ),
//             const SizedBox(height: 10),
//             Text(isGrading ? "جاري معالجة البيانات..." : (hasFiles ? "جاهز لبدء التصحيح الآن" : "لم يتم ارفاق الاوراق")),
//             Text("${selectedFiles.length} ورقة إجابة صالحة"),
//             const Spacer(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton.icon(
//                     onPressed: (hasFiles && !isGrading) ? () async {setState(() => isGrading = true);
//                   // محاكاة عملية التصحيح
//                     await Future.delayed(const Duration(seconds: 3));
//                     setState(() {
//                     isGrading = false;
//                     isGradingComplete = true;
//                   });

//                 } : null,
//                   icon: const Icon(Icons.update_rounded, size: 18),
//                   label: const Text("بدء التصحيح الآلي", style: TextStyle(fontSize: 13)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: (hasFiles && !isGrading) ? AppColors.primaryTeal : Colors.grey[400],
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                OutlinedButton(
//   onPressed: () {
//     setState(() {
//       if (isGrading) {
//         // إذا كان التصحيح يعمل → أوقفه فقط
//         isGrading = false;
//       } else {
//         // إذا لم يبدأ التصحيح → احذف الملفات
//         selectedFiles = [];
//       }
//     });
//   },
//   style: OutlinedButton.styleFrom(
//     side: BorderSide(color: isGrading ? Colors.grey : Colors.redAccent),
//   ),
//   child: Text(
//     "إلغاء",
//     style: TextStyle(
//       color: isGrading ? Colors.grey : Colors.redAccent,
//     ),
//   ),
// ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /* --- 4. قائمة الملفات --- */
//   Widget _buildFileListSection() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(15)),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text("الملفات المرفوعة", style: TextStyle(fontWeight: FontWeight.bold)),
//               Row(
//                 children: [
//                   TextButton(onPressed: () => setState(() => selectedFiles = []), child: const Text("حذف الكل", style: TextStyle(color: Colors.redAccent))),
//                   const SizedBox(width: 15),
//                   Text("عدد الأوراق: ${selectedFiles.length}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
//                 ],
//               ),
//             ],
//           ),
//           const Divider(height: 30),
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: selectedFiles.length,
//             separatorBuilder: (context, index) => const Divider(height: 20),
//             itemBuilder: (context, index) {
//               return Row(
//                 children: [
//                   const Icon(Icons.check_circle, color: Colors.green, size: 20),
//                   const SizedBox(width: 10),
//                   Text(selectedFiles[index].name, style: const TextStyle(fontSize: 13)),
//                   const Spacer(),
//                   IconButton(icon: const Icon(Icons.close, color: Colors.redAccent, size: 18), onPressed: () => setState(() => selectedFiles.removeAt(index))),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   /* --- 5. معلومات الامتحان --- */
//   Widget _buildExamInfoSection() {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("معلومات الامتحان", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textprimary)),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               _infoTextField("المادة الدراسية", subjectController),
//               _infoTextField("اسم الامتحان", examNameController),
//               _infoTextField("تاريخ الامتحان", dateController),
//               _infoTextField("عدد الأسئلة", questionsCountController),
//               _infoTextField("الدرجة الكلية", totalGradeController),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _infoTextField(String label, TextEditingController controller) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 4),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textseccondary)),
//             const SizedBox(height: 4),
//             TextField(
//               controller: controller,
//               enabled: !isGrading,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 11),
//               decoration: InputDecoration(
//                 isDense: true,
//                 filled: true,
//                 fillColor: AppColors.secondaryTeal.withOpacity(0.3),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// class HeaderWidget extends StatelessWidget {
//   const HeaderWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(
//         color: AppColors.textWhite,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("رفع اوراق الاجابات", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textprimary)),
//               SizedBox(height: 4),
//               Text("قم برفع أوراق الإجابة بصيغة PDF لبدء التصحيح الآلي", style: TextStyle(color: AppColors.textseccondary)),
//             ],
//           ),
//           Row(
//             children: [
//               _iconButton(Icons.notifications_none),
//               const SizedBox(width: 10),
//               _iconButton(Icons.person_outline),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget _iconButton(IconData icon) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: const BoxDecoration(
//         color: AppColors.secondaryTeal,
//         shape: BoxShape.circle,
//       ),
//       child: Icon(icon, color: AppColors.primaryTeal),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import '../core/colors.dart';
// import 'teacher_dashboard.dart';
// import 'teacher_matearial.dart';

// class GradingPage extends StatefulWidget {
//   const GradingPage({super.key});

//   @override
//   State<GradingPage> createState() => _GradingPageState();
// }

// class _GradingPageState extends State<GradingPage> {
//   final TextEditingController subjectController = TextEditingController(text: "البرمجة المتقدمة");
//   final TextEditingController examNameController = TextEditingController(text: "الامتحان النصفي");
//   final TextEditingController dateController = TextEditingController(text: "2026/03/11");
//   final TextEditingController questionsCountController = TextEditingController(text: "4");
//   final TextEditingController totalGradeController = TextEditingController(text: "50");

//   List<PlatformFile> selectedFiles = [];
//   bool isGrading = false; 
//   bool isGradingComplete = false;

//   Future<void> pickFiles() async {
//     if (isGrading) return;
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       allowMultiple: true,
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       setState(() {
//         selectedFiles.addAll(result.files);
//       });
//     }
//   }

//   @override
//   void dispose() {
//     subjectController.dispose();
//     examNameController.dispose();
//     dateController.dispose();
//     questionsCountController.dispose();
//     totalGradeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool hasFiles = selectedFiles.isNotEmpty;

//     return Scaffold(
//       backgroundColor: AppColors.secondaryTeal,
//       body: Row(
//         children: [
//           // 1. السايدبار أولاً (ثابت في مكانه يميناً)
//           CustSidebar(
//             selectedIndex: 3,
//             onItemSelected: (index) {
//               if (index == 3) return;
//               if (index == 0) {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const DashboardScreen()),
//                 );
//               } else if (index == 2) {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const Material1()),
//                 );
//               }
//             },
//           ), 

//           // 2. المحتوى (تم حذف Directionality لضمان عدم القفز)
//           Expanded(
//             child: Container(
//               alignment: Alignment.topCenter,
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const HeaderWidget(),
//                     const SizedBox(height: 15),
//                     _buildExamInfoSection(),
//                     const SizedBox(height: 15),

//                     /// الكاردات العلوية
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildUploadCard(),
//                         const SizedBox(width: 20),
//                         _buildStatusCard(hasFiles),
//                       ],
//                     ),

//                     // القسم السفلي المتغير بناءً على الحالة
//                     const SizedBox(height: 25),
//                     if (isGradingComplete)
//                       _buildCompleteCard() 
//                     else if (isGrading)
//                       _buildProcessingCard() 
//                     else if (hasFiles)
//                       _buildFileListSection(),

//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /* --- كافة الـ Widgets والـ Methods بقيت كما هي دون تغيير في التصميم --- */

//   Widget _buildProcessingCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
//               SizedBox(width: 8),
//               Text("جاري التصحيح الآلي...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textprimary)),
//             ],
//           ),
//           const SizedBox(height: 8),
//           const Center(
//             child: Text(
//               "يرجى عدم إغلاق هذه الصفحة أثناء عملية التصحيح الآلي، النظام يعمل على معالجة جميع الأوراق بشكل تلقائي.",
//               style: TextStyle(fontSize: 12, color: Colors.grey),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           const SizedBox(height: 15),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Text("التقدم الكلي", style: TextStyle(fontSize: 12, color: Colors.black)),
//               Text("29 / 120", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.orange)),
//             ],
//           ),
//           const SizedBox(height: 10),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: const LinearProgressIndicator(
//               value: 0.24,
//               minHeight: 10,
//               backgroundColor: Color(0xFFE5E5E5),
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
//             ),
//           ),
//           const SizedBox(height: 6),
//           const Align(alignment: Alignment.centerLeft, child: Text("الوقت المتبقي: 00:29", style: TextStyle(fontSize: 11, color: Colors.grey))),
//           const SizedBox(height: 15),
//           Row(
//             children: [
//               _statBox("29", "مكتملة", Icons.check_circle),
//               const SizedBox(width: 10),
//               _statBox("3", "قيد المعالجة", Icons.sync),
//               const SizedBox(width: 10),
//               _statBox("88", "في الانتظار", Icons.access_time),
//               const SizedBox(width: 10),
//               _statBox("2", "دقيقة متبقية", Icons.trending_up),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildCompleteCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.check_circle_outline, color: Colors.green, size: 28),
//               SizedBox(width: 8),
//               Text("اكتمل التصحيح الآلي!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textprimary)),
//             ],
//           ),
//           const SizedBox(height: 15),
//           ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
//             child: const Text("عرض الاوراق المصححة", style: TextStyle(color: Colors.white)),
//           ),
//           const SizedBox(height: 10),
//           const Text("تم الانتهاء من تصحيح جميع الأوراق بنجاح، يمكنك الآن مراجعة النتائج.", style: TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [Text("التقدم الكلي"), Text("120 / 120", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))],
//           ),
//           const SizedBox(height: 10),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: const LinearProgressIndicator(
//               value: 1,
//               minHeight: 10,
//               backgroundColor: Color(0xFFE5E5E5),
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               _statBox("120", "مكتملة", Icons.check_circle),
//               const SizedBox(width: 10),
//               _statBox("0", "قيد المعالجة", Icons.sync),
//               const SizedBox(width: 10),
//               _statBox("0", "في الانتظار", Icons.access_time),
//               const SizedBox(width: 10),
//               _statBox("0", "دقيقة متبقية", Icons.trending_up),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _statBox(String number, String label, IconData icon) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//         decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Icon(icon, size: 20, color: AppColors.primaryTeal),
//                 Text(number, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textprimary)),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: AppColors.textseccondary)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildUploadCard() {
//     return Expanded(
//       flex: 2,
//       child: Container(
//         height: 200,
//         decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black12)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.cloud_upload_outlined, size: 50, color: isGrading ? Colors.grey : AppColors.primaryTeal),
//             const SizedBox(height: 10),
//             const Text("انقر لتحديد الملفات من جهازك"),
//             const SizedBox(height: 15),
//             ElevatedButton.icon(
//               onPressed: isGrading ? null : pickFiles,
//               icon: const Icon(Icons.file_upload, color: Colors.white),
//               label: const Text("اختر الملفات", style: TextStyle(color: Colors.white)),
//               style: ElevatedButton.styleFrom(backgroundColor: isGrading ? Colors.grey[400] : AppColors.primaryTeal, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusCard(bool hasFiles) {
//     return Expanded(
//       flex: 3,
//       child: Container(
//         height: 200,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(16)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(hasFiles ? Icons.check_circle_outline_rounded : Icons.priority_high_rounded, size: 40, color: isGrading ? Colors.grey : (hasFiles ? AppColors.primaryTeal : Colors.orange)),
//             const SizedBox(height: 10),
//             Text(isGrading ? "جاري معالجة البيانات..." : (hasFiles ? "جاهز لبدء التصحيح الآن" : "لم يتم ارفاق الاوراق")),
//             Text("${selectedFiles.length} ورقة إجابة صالحة"),
//             const Spacer(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: (hasFiles && !isGrading) ? () async {
//                     setState(() => isGrading = true);
//                     await Future.delayed(const Duration(seconds: 3));
//                     setState(() { isGrading = false; isGradingComplete = true; });
//                   } : null,
//                   icon: const Icon(Icons.update_rounded, size: 18),
//                   label: const Text("بدء التصحيح الآلي", style: TextStyle(fontSize: 13)),
//                   style: ElevatedButton.styleFrom(backgroundColor: (hasFiles && !isGrading) ? AppColors.primaryTeal : Colors.grey[400], foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
//                 ),
//                 const SizedBox(width: 12),
//                 OutlinedButton(
//                   onPressed: () { setState(() { if (isGrading) isGrading = false; else selectedFiles = []; }); },
//                   style: OutlinedButton.styleFrom(side: BorderSide(color: isGrading ? Colors.grey : Colors.redAccent)),
//                   child: Text("إلغاء", style: TextStyle(color: isGrading ? Colors.grey : Colors.redAccent)),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFileListSection() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(15)),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text("الملفات المرفوعة", style: TextStyle(fontWeight: FontWeight.bold)),
//               Row(
//                 children: [
//                   TextButton(onPressed: () => setState(() => selectedFiles = []), child: const Text("حذف الكل", style: TextStyle(color: Colors.redAccent))),
//                   const SizedBox(width: 15),
//                   Text("عدد الأوراق: ${selectedFiles.length}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
//                 ],
//               ),
//             ],
//           ),
//           const Divider(height: 30),
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: selectedFiles.length,
//             separatorBuilder: (context, index) => const Divider(height: 20),
//             itemBuilder: (context, index) {
//               return Row(
//                 children: [
//                   const Icon(Icons.check_circle, color: Colors.green, size: 20),
//                   const SizedBox(width: 10),
//                   Text(selectedFiles[index].name, style: const TextStyle(fontSize: 13)),
//                   const Spacer(),
//                   IconButton(icon: const Icon(Icons.close, color: Colors.redAccent, size: 18), onPressed: () => setState(() => selectedFiles.removeAt(index))),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildExamInfoSection() {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("معلومات الامتحان", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textprimary)),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               _infoTextField("المادة الدراسية", subjectController),
//               _infoTextField("اسم الامتحان", examNameController),
//               _infoTextField("تاريخ الامتحان", dateController),
//               _infoTextField("عدد الأسئلة", questionsCountController),
//               _infoTextField("الدرجة الكلية", totalGradeController),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _infoTextField(String label, TextEditingController controller) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 4),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textseccondary)),
//             const SizedBox(height: 4),
//             TextField(
//               controller: controller,
//               enabled: !isGrading,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 11),
//               decoration: InputDecoration(
//                 isDense: true,
//                 filled: true,
//                 fillColor: AppColors.secondaryTeal.withOpacity(0.3),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // الـ HeaderWidget الخاص بالصفحة
// class HeaderWidget extends StatelessWidget {
//   const HeaderWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(15)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("رفع اوراق الاجابات", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textprimary)),
//               SizedBox(height: 4),
//               Text("قم برفع أوراق الإجابة بصيغة PDF لبدء التصحيح الآلي", style: TextStyle(color: AppColors.textseccondary)),
//             ],
//           ),
//           Row(
//             children: [
//               _iconButton(Icons.notifications_none),
//               const SizedBox(width: 10),
//               _iconButton(Icons.person_outline),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget _iconButton(IconData icon) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: const BoxDecoration(color: AppColors.secondaryTeal, shape: BoxShape.circle),
//       child: Icon(icon, color: AppColors.primaryTeal),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import '../core/colors.dart';
// import 'teacher_dashboard.dart';
// import 'teacher_matearial.dart';

// class GradingPage extends StatefulWidget {
//   const GradingPage({super.key});

//   @override
//   State<GradingPage> createState() => _GradingPageState();
// }

// class _GradingPageState extends State<GradingPage> {
//   final TextEditingController subjectController = TextEditingController(text: "البرمجة المتقدمة");
//   final TextEditingController examNameController = TextEditingController(text: "الامتحان النصفي");
//   final TextEditingController dateController = TextEditingController(text: "2026/03/11");
//   final TextEditingController questionsCountController = TextEditingController(text: "4");
//   final TextEditingController totalGradeController = TextEditingController(text: "50");

//   List<PlatformFile> selectedFiles = [];
//   bool isGrading = false; 
//   bool isGradingComplete = false;

//   Future<void> pickFiles() async {
//     if (isGrading) return;
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       allowMultiple: true,
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       setState(() {
//         selectedFiles.addAll(result.files);
//       });
//     }
//   }

//   @override
//   void dispose() {
//     subjectController.dispose();
//     examNameController.dispose();
//     dateController.dispose();
//     questionsCountController.dispose();
//     totalGradeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool hasFiles = selectedFiles.isNotEmpty;

//     // هنا التعديل الجوهري: جعلنا الـ Directionality تغلف الـ Scaffold بالكامل مثل صفحة المواد
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: AppColors.secondaryTeal,
//         body: Row(
//           children: [
//             // 1. القائمة الجانبية (ستظهر في اليمين لأنها أول عنصر في الصف RTL)
//             CustSidebar(
//               selectedIndex: 3,
//               onItemSelected: (index) {
//                 if (index == 3) return;
//                 if (index == 0) {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => const DashboardScreen()),
//                   );
//                 } else if (index == 2) {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => const Material1()),
//                   );
//                 }
//               },
//             ),

//             // 2. المحتوى الرئيسي
//             Expanded(
//               child: Container(
//                 alignment: Alignment.topCenter,
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const HeaderWidget(),
//                       const SizedBox(height: 15),
//                       _buildExamInfoSection(),
//                       const SizedBox(height: 15),

//                       /// الكاردات العلوية
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildUploadCard(),
//                           const SizedBox(width: 20),
//                           _buildStatusCard(hasFiles),
//                         ],
//                       ),

//                       // القسم السفلي المتغير
//                       const SizedBox(height: 25),
//                       if (isGradingComplete)
//                         _buildCompleteCard() 
//                       else if (isGrading)
//                         _buildProcessingCard() 
//                       else if (hasFiles)
//                         _buildFileListSection(),

//                       const SizedBox(height: 40),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /* --- بقية الدوال (Widgets) تبقى كما هي تماماً لضمان عدم تغير التصميم --- */
  
//   Widget _buildProcessingCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
//               SizedBox(width: 8),
//               Text("جاري التصحيح الآلي...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textprimary)),
//             ],
//           ),
//           const SizedBox(height: 8),
//           const Center(child: Text("يرجى عدم إغلاق هذه الصفحة أثناء عملية التصحيح الآلي.", style: TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center)),
//           const SizedBox(height: 15),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Text("التقدم الكلي"),
//               Text("29 / 120", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
//             ],
//           ),
//           const SizedBox(height: 10),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: const LinearProgressIndicator(value: 0.24, minHeight: 10, backgroundColor: Color(0xFFE5E5E5), valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent)),
//           ),
//           const SizedBox(height: 15),
//           Row(
//             children: [
//               _statBox("29", "مكتملة", Icons.check_circle),
//               const SizedBox(width: 10),
//               _statBox("3", "قيد المعالجة", Icons.sync),
//               const SizedBox(width: 10),
//               _statBox("88", "في الانتظار", Icons.access_time),
//               const SizedBox(width: 10),
//               _statBox("2", "دقيقة متبقية", Icons.trending_up),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildCompleteCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//       child: Column(
//         children: [
//           const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.check_circle_outline, color: Colors.green, size: 28), SizedBox(width: 8), Text("اكتمل التصحيح الآلي!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
//           const SizedBox(height: 15),
//           ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal), child: const Text("عرض الاوراق المصححة", style: TextStyle(color: Colors.white))),
//         ],
//       ),
//     );
//   }

//   Widget _statBox(String number, String label, IconData icon) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(12)),
//         child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(icon, size: 20, color: AppColors.primaryTeal), Text(number, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]), const SizedBox(height: 8), Text(label, style: const TextStyle(fontSize: 11))]),
//       ),
//     );
//   }

//   Widget _buildUploadCard() {
//     return Expanded(
//       flex: 2,
//       child: Container(
//         height: 200,
//         decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black12)),
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Icon(Icons.cloud_upload_outlined, size: 50, color: isGrading ? Colors.grey : AppColors.primaryTeal),
//           const Text("انقر لتحديد الملفات"),
//           const SizedBox(height: 15),
//           ElevatedButton(onPressed: isGrading ? null : pickFiles, child: const Text("اختر الملفات", style: TextStyle(color: Colors.white)), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal))
//         ]),
//       ),
//     );
//   }

//   Widget _buildStatusCard(bool hasFiles) {
//     return Expanded(
//       flex: 3,
//       child: Container(
//         height: 200,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(16)),
//         child: Column(children: [
//           Icon(hasFiles ? Icons.check_circle : Icons.priority_high, color: hasFiles ? AppColors.primaryTeal : Colors.orange),
//           Text(hasFiles ? "جاهز للتصحيح" : "لم يتم ارفاق أوراق"),
//           const Spacer(),
//           ElevatedButton(
//             onPressed: (hasFiles && !isGrading) ? () async { setState(() => isGrading = true); await Future.delayed(const Duration(seconds: 3)); setState(() { isGrading = false; isGradingComplete = true; }); } : null,
//             child: const Text("بدء التصحيح الآلي", style: TextStyle(color: Colors.white)),
//             style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
//           )
//         ]),
//       ),
//     );
//   }

//   Widget _buildFileListSection() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(15)),
//       child: Column(children: [
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("الملفات المرفوعة"), TextButton(onPressed: () => setState(() => selectedFiles = []), child: const Text("حذف الكل", style: TextStyle(color: Colors.red)))]),
//         const Divider(),
//         ListView.builder(shrinkWrap: true, itemCount: selectedFiles.length, itemBuilder: (context, index) => ListTile(leading: const Icon(Icons.picture_as_pdf, color: Colors.red), title: Text(selectedFiles[index].name, style: const TextStyle(fontSize: 13)))),
//       ]),
//     );
//   }

//   Widget _buildExamInfoSection() {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(12)),
//       child: Row(children: [
//         _infoTextField("المادة", subjectController),
//         _infoTextField("الامتحان", examNameController),
//         _infoTextField("التاريخ", dateController),
//         _infoTextField("الأسئلة", questionsCountController),
//         _infoTextField("الدرجة", totalGradeController),
//       ]),
//     );
//   }

//   Widget _infoTextField(String label, TextEditingController controller) {
//     return Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: TextField(controller: controller, decoration: InputDecoration(labelText: label, isDense: true, border: OutlineInputBorder()))));
//   }
// }

// class HeaderWidget extends StatelessWidget {
//   const HeaderWidget({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
//       child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         const Text("رفع اوراق الاجابات", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//         const Icon(Icons.person_pin, color: AppColors.primaryTeal, size: 30),
//       ]),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../core/colors.dart';
import 'teacher_dashboard.dart';
import 'teacher_matearial.dart';
import 'exam_page.dart';
class GradingPage extends StatefulWidget {
  const GradingPage({super.key});

  @override
  State<GradingPage> createState() => _GradingPageState();
}

class _GradingPageState extends State<GradingPage> {
  final TextEditingController subjectController = TextEditingController(text: "البرمجة المتقدمة");
  final TextEditingController examNameController = TextEditingController(text: "الامتحان النصفي");
  final TextEditingController dateController = TextEditingController(text: "2026/03/11");
  final TextEditingController questionsCountController = TextEditingController(text: "4");
  final TextEditingController totalGradeController = TextEditingController(text: "50");

  List<PlatformFile> selectedFiles = [];
  bool isGrading = false; 
  bool isGradingComplete = false;

  Future<void> pickFiles() async {
    if (isGrading) return;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFiles.addAll(result.files);
      });
    }
  }

  @override
  void dispose() {
    subjectController.dispose();
    examNameController.dispose();
    dateController.dispose();
    questionsCountController.dispose();
    totalGradeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool hasFiles = selectedFiles.isNotEmpty;

    // الحل الثابت: Directionality كأب لكل الصفحة
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.secondaryTeal,
        body: Row(
          children: [
            // القائمة الجانبية (ستبقى في اليمين تماماً مثل صفحة المواد)
            CustSidebar(
              selectedIndex: 3,
              onItemSelected: (index) {
                if (index == 0) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  );
                } else if (index == 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const FinalExamPage()),
                  );
                }
                else if (index == 2) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Material1()),
                  );
                }
              },
            ), 
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeaderWidget(),
                      const SizedBox(height: 15),
                      _buildExamInfoSection(),
                      const SizedBox(height: 15),

                      /// الكاردات العلوية
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildUploadCard(),
                          const SizedBox(width: 20),
                          _buildStatusCard(hasFiles),
                        ],
                      ),

                      const SizedBox(height: 25),
                      if (isGradingComplete)
                        _buildCompleteCard() 
                      else if (isGrading)
                        _buildProcessingCard() 
                      else if (hasFiles)
                        _buildFileListSection(),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* --- تصميم كارد جاري التصحيح الأصلي --- */
  Widget _buildProcessingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 8),
              Text("جاري التصحيح الآلي...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textprimary)),
            ],
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              "يرجى عدم إغلاق هذه الصفحة أثناء عملية التصحيح الآلي، النظام يعمل على معالجة جميع الأوراق بشكل تلقائي.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("التقدم الكلي", style: TextStyle(fontSize: 12, color: Colors.black)),
              Text("29 / 120", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.orange)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(
              value: 0.24,
              minHeight: 10,
              backgroundColor: Color(0xFFE5E5E5),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
            ),
          ),
          const SizedBox(height: 6),
          const Align(alignment: Alignment.centerLeft, child: Text("الوقت المتبقي: 00:29", style: TextStyle(fontSize: 11, color: Colors.grey))),
          const SizedBox(height: 15),
          Row(
            children: [
              _statBox("29", "مكتملة", Icons.check_circle),
              const SizedBox(width: 10),
              _statBox("3", "قيد المعالجة", Icons.sync),
              const SizedBox(width: 10),
              _statBox("88", "في الانتظار", Icons.access_time),
              const SizedBox(width: 10),
              _statBox("2", "دقيقة متبقية (تقريباً)", Icons.trending_up),
            ],
          )
        ],
      ),
    );
  }

  /* --- تصميم كارد اكتمال التصحيح الأصلي --- */
  Widget _buildCompleteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text("اكتمل التصحيح الآلي!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textprimary)),
            ],
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
            child: const Text("عرض الاوراق المصححة", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 10),
          const Text("تم الانتهاء من تصحيح جميع الأوراق بنجاح، يمكنك الآن مراجعة النتائج.", style: TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [Text("التقدم الكلي"), Text("120 / 120", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(value: 1, minHeight: 10, backgroundColor: Color(0xFFE5E5E5), valueColor: AlwaysStoppedAnimation<Color>(Colors.green)),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _statBox("120", "مكتملة", Icons.check_circle),
              const SizedBox(width: 10),
              _statBox("0", "قيد المعالجة", Icons.sync),
              const SizedBox(width: 10),
              _statBox("0", "في الانتظار", Icons.access_time),
              const SizedBox(width: 10),
              _statBox("0", "دقيقة متبقية", Icons.trending_up),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBox(String number, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 20, color: AppColors.primaryTeal),
                Text(number, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textprimary)),
              ],
            ),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: AppColors.textseccondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadCard() {
    return Expanded(
      flex: 2,
      child: Container(
        height: 200,
        decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined, size: 50, color: isGrading ? Colors.grey : AppColors.primaryTeal),
            const SizedBox(height: 10),
            const Text("انقر لتحديد الملفات من جهازك"),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: isGrading ? null : pickFiles,
              icon: const Icon(Icons.file_upload, color: Colors.white),
              label: const Text("اختر الملفات", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: isGrading ? Colors.grey[400] : AppColors.primaryTeal, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(bool hasFiles) {
    return Expanded(
      flex: 3,
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(hasFiles ? Icons.check_circle_outline_rounded : Icons.priority_high_rounded, size: 40, color: isGrading ? Colors.grey : (hasFiles ? AppColors.primaryTeal : Colors.orange)),
            const SizedBox(height: 10),
            Text(isGrading ? "جاري معالجة البيانات..." : (hasFiles ? "جاهز لبدء التصحيح الآن" : "لم يتم ارفاق الاوراق")),
            Text("${selectedFiles.length} ورقة إجابة صالحة"),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: (hasFiles && !isGrading) ? () async {
                    setState(() => isGrading = true);
                    await Future.delayed(const Duration(seconds: 3));
                    setState(() { isGrading = false; isGradingComplete = true; });
                  } : null,
                  icon: const Icon(Icons.update_rounded, size: 18),
                  label: const Text("بدء التصحيح الآلي", style: TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(backgroundColor: (hasFiles && !isGrading) ? AppColors.primaryTeal : Colors.grey[400], foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () { setState(() { if (isGrading) isGrading = false; else selectedFiles = []; }); },
                  style: OutlinedButton.styleFrom(side: BorderSide(color: isGrading ? Colors.grey : Colors.redAccent)),
                  child: Text("إلغاء", style: TextStyle(color: isGrading ? Colors.grey : Colors.redAccent)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileListSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("الملفات المرفوعة", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  TextButton(onPressed: () => setState(() => selectedFiles = []), child: const Text("حذف الكل", style: TextStyle(color: Colors.redAccent))),
                  const SizedBox(width: 15),
                  Text("عدد الأوراق: ${selectedFiles.length}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const Divider(height: 30),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedFiles.length,
            separatorBuilder: (context, index) => const Divider(height: 20),
            itemBuilder: (context, index) {
              return Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 10),
                  Text(selectedFiles[index].name, style: const TextStyle(fontSize: 13)),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.close, color: Colors.redAccent, size: 18), onPressed: () => setState(() => selectedFiles.removeAt(index))),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExamInfoSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("معلومات الامتحان", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textprimary)),
          const SizedBox(height: 10),
          Row(
            children: [
              _infoTextField("المادة الدراسية", subjectController),
              _infoTextField("اسم الامتحان", examNameController),
              _infoTextField("تاريخ الامتحان", dateController),
              _infoTextField("عدد الأسئلة", questionsCountController),
              _infoTextField("الدرجة الكلية", totalGradeController),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTextField(String label, TextEditingController controller) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textseccondary)),
            const SizedBox(height: 4),
            TextField(
              controller: controller,
              enabled: !isGrading,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: AppColors.secondaryTeal.withOpacity(0.3),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* --- تصميم الـ Header الأصلي بالكامل --- */
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(color: AppColors.textWhite, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("رفع اوراق الاجابات", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textprimary)),
              SizedBox(height: 4),
              Text("قم برفع أوراق الإجابة بصيغة PDF لبدء التصحيح الآلي", style: TextStyle(color: AppColors.textseccondary)),
            ],
          ),
          Row(children: [_iconButton(Icons.notifications_none), const SizedBox(width: 10), _iconButton(Icons.person_outline)])
        ],
      ),
    );
  }
  Widget _iconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: AppColors.secondaryTeal, shape: BoxShape.circle),
      child: Icon(icon, color: AppColors.primaryTeal),
    );
  }
}