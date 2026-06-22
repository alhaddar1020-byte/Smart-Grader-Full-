// // import 'dart:convert';
// // import 'dart:ui';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;

// // import '../core/colors.dart';
// // import '../generated/l10n.dart';
// // import 'teacher_dashboard.dart';
// // import 'teacher_matearial.dart' hide HeaderWidget;
// // import 'grading.dart' hide HeaderWidget;
// // import 'exam_page.dart' hide HeaderWidget;
// // import 'review_exam_screen.dart';
// // import 'teacer_setting.dart';
// // import 'ExamManagementPage.dart';
// // import 'package:flutter/cupertino.dart';

// // // ══════════════════════════════════════════════════════════════
// // // نماذج البيانات (Data Models)
// // // ══════════════════════════════════════════════════════════════

// // class McqOptionModel {
// //   TextEditingController controller;
// //   bool isCorrect;
// //   McqOptionModel({String text = '', this.isCorrect = false})
// //     : controller = TextEditingController(text: text);
// // }

// // class MatchingPairModel {
// //   TextEditingController termController;
// //   TextEditingController matchController;
// //   MatchingPairModel({String term = '', String match = ''})
// //     : termController = TextEditingController(text: term),
// //       matchController = TextEditingController(text: match);
// // }

// // class BranchModel {
// //   TextEditingController questionController;
// //   double grade;
// //   List<McqOptionModel> mcqOptions;
// //   String? tfAnswer;
// //   TextEditingController fillBlankAnswerController;
// //   List<MatchingPairModel> matchingPairs;
// //   TextEditingController essayModelAnswerController;
// //   TextEditingController essayKeywordsController;
// //   String numberingStyle;

// //   BranchModel({
// //     this.numberingStyle = 'numbers',
// //     String questionText = '',
// //     this.grade = 5,
// //     List<McqOptionModel>? mcqOptions,
// //     this.tfAnswer,
// //     String fillBlankAnswer = '',
// //     List<MatchingPairModel>? matchingPairs,
// //     String essayModelAnswer = '',
// //     String essayKeywords = '',
// //   }) : questionController = TextEditingController(text: questionText),
// //        fillBlankAnswerController = TextEditingController(text: fillBlankAnswer),
// //        essayModelAnswerController = TextEditingController(
// //          text: essayModelAnswer,
// //        ),
// //        essayKeywordsController = TextEditingController(text: essayKeywords),
// //        mcqOptions = mcqOptions ?? [McqOptionModel(), McqOptionModel()],
// //        matchingPairs = matchingPairs ?? [MatchingPairModel()];
// // }

// // class QuestionSectionModel {
// //   String sectionType;
// //   TextEditingController titleController;
// //   List<BranchModel> items;
// //   String numberingStyle;

// //   QuestionSectionModel({
// //     this.numberingStyle = 'letters_ar',
// //     this.sectionType = 'mcq',
// //     String title = '',
// //     List<BranchModel>? items,
// //   }) : titleController = TextEditingController(text: title),
// //        items = items ?? [BranchModel()];
// // }

// // class QuestionGroupModel {
// //   TextEditingController titleController;
// //   List<QuestionSectionModel> sections;
// //   String numberingStyle;

// //   QuestionGroupModel({
// //     this.numberingStyle = 'numbers',
// //     String title = '',
// //     List<QuestionSectionModel>? sections,
// //   }) : titleController = TextEditingController(text: title),
// //        sections = sections ?? [QuestionSectionModel()];
// // }

// // class ExamContext {
// //   final int? courseId;
// //   final String? courseName;
// //   final String? specialization;
// //   final String? levelName;
// //   final int? folderId;
// //   final String? folderName;

// //   const ExamContext({
// //     this.courseId,
// //     this.courseName,
// //     this.specialization,
// //     this.levelName,
// //     this.folderId,
// //     this.folderName,
// //   });

// //   bool get isComplete =>
// //       courseId != null &&
// //       courseName != null &&
// //       folderId != null &&
// //       folderName != null;
// // }

// // class FolderModel {
// //   final int id;
// //   final String name;
// //   FolderModel({required this.id, required this.name});
// // }

// // class CourseModel {
// //   final int id;
// //   final String name;
// //   final String specialization;
// //   final String level;
// //   final List<FolderModel> folders;

// //   const CourseModel({
// //     required this.id,
// //     required this.name,
// //     required this.specialization,
// //     required this.level,
// //     required this.folders,
// //   });
// // }

// // // ══════════════════════════════════════════════════════════════
// // // الصفحة الرئيسية
// // // ══════════════════════════════════════════════════════════════

// // class CreateElectronicExamPage extends StatefulWidget {
// //   final ExamContext? examContext;
// //   final int? examIdToEdit;
// //   const CreateElectronicExamPage({
// //     super.key,
// //     this.examContext,
// //     this.examIdToEdit,
// //   });

// //   @override
// //   State<CreateElectronicExamPage> createState() =>
// //       _CreateElectronicExamPageState();
// // }

// // class _CreateElectronicExamPageState extends State<CreateElectronicExamPage> {
// //   int? _currentExamId;
// //   bool _isExamSaved = true;

// //   void _markAsUnsaved() {
// //     if (_isExamSaved) {
// //       setState(() => _isExamSaved = false);
// //     }
// //   }

// //   final int _selectedIndex = 1;
// //   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

// //   final TextEditingController _titleController = TextEditingController();
// //   final TextEditingController _dateController = TextEditingController();
// //   final TextEditingController _timeLimitController = TextEditingController();

// //   final TextEditingController _specializationController =
// //       TextEditingController();
// //   final TextEditingController _levelController = TextEditingController();
// //   final TextEditingController _folderController = TextEditingController();

// //   List<QuestionGroupModel> _groups = [];
// //   bool _isSaving = false;

// //   bool _isLoadingCourses = true;
// //   List<CourseModel> _myCourses = [];
// //   CourseModel? _selectedCourse;
// //   FolderModel? _selectedFolder;
// //   int _selectedHours = 1;
// //   int _selectedMinutes = 0;
// //   int? _totalDurationMinutes;
// //   bool get _isReadOnlyMode =>
// //       widget.examContext != null && widget.examContext!.isComplete;

// //   @override
// //   void initState() {
// //     super.initState();
// //     if (widget.examIdToEdit != null) {
// //       _currentExamId = widget.examIdToEdit;
// //     }

// //     if (widget.examContext != null && widget.examContext!.isComplete) {
// //       _isLoadingCourses = false;
// //       _specializationController.text = widget.examContext!.specialization ?? '';
// //       _levelController.text = widget.examContext!.levelName ?? '';
// //       _folderController.text = widget.examContext!.folderName ?? '';

// //       if (_currentExamId != null) {
// //         _loadExamDetails(_currentExamId!);
// //       }
// //     } else {
// //       _fetchCoursesFromDatabase().then((_) {
// //         if (_currentExamId != null) {
// //           _loadExamDetails(_currentExamId!);
// //         }
// //       });
// //     }
// //   }

// //   Future<void> _loadExamDetails(int examId) async {
// //     setState(() => _isSaving = true);
// //     try {
// //       final response = await http.get(
// //         Uri.parse('http://localhost:8000/api/exams/get-full-exam/$examId'),
// //       );
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(utf8.decode(response.bodyBytes));

// //         setState(() {
// //           _titleController.text = data['exam_title'] ?? '';
// //           _dateController.text = data['exam_date'] ?? '';
// //           String? rawTime = data['time_limit']?.toString();

// //           if (rawTime != null && rawTime.isNotEmpty && rawTime != '0') {
// //             _totalDurationMinutes = int.tryParse(
// //               rawTime.replaceAll(RegExp(r'[^0-9]'), ''),
// //             );

// //             if (_totalDurationMinutes != null) {
// //               int h = _totalDurationMinutes! ~/ 60;
// //               int m = _totalDurationMinutes! % 60;

// //               String formatted = '';
// //               if (h > 0) formatted += '$h ${S.of(context).hour_word}';
// //               if (m > 0 || h == 0) {
// //                 if (formatted.isNotEmpty) formatted += ' ';
// //                 formatted += '$m ${S.of(context).minute_word}';
// //               }
// //               _timeLimitController.text = formatted;
// //             }
// //           } else {
// //             _totalDurationMinutes = null;
// //             _timeLimitController.text = '';
// //           }

// //           if (!_isReadOnlyMode) {
// //             int loadedFolderId = data['folder_id'];
// //             for (var c in _myCourses) {
// //               for (var f in c.folders) {
// //                 if (f.id == loadedFolderId) {
// //                   _selectedCourse = c;
// //                   _selectedFolder = f;
// //                   _specializationController.text = c.specialization;
// //                   _levelController.text = c.level;
// //                   break;
// //                 }
// //               }
// //             }
// //           }

// //           if (data['question_groups'] != null) {
// //             _groups.clear();
// //             for (var g in data['question_groups']) {
// //               var newGroup = QuestionGroupModel(
// //                 title: g['group_title'] ?? '',
// //                 numberingStyle: g['group_numbering_style'] ?? 'numbers',
// //                 sections: [],
// //               );

// //               for (var s in g['sections']) {
// //                 var newSection = QuestionSectionModel(
// //                   title: s['section_title'] ?? '',
// //                   sectionType: s['section_type'] ?? 'mcq',
// //                   numberingStyle: s['section_numbering_style'] ?? 'letters_ar',
// //                   items: [],
// //                 );

// //                 for (var b in s['items']) {
// //                   var newBranch = BranchModel(
// //                     questionText: b['question_text'] ?? '',
// //                     grade: (b['question_mark'] ?? 0).toDouble(),
// //                     numberingStyle: b['question_numbering_style'] ?? 'numbers',
// //                   );

// //                   if (newSection.sectionType == 'mcq' &&
// //                       b['mcq_options'] != null) {
// //                     newBranch.mcqOptions.clear();
// //                     for (var opt in b['mcq_options']) {
// //                       newBranch.mcqOptions.add(
// //                         McqOptionModel(
// //                           text: opt['option_text'] ?? '',
// //                           isCorrect: opt['is_correct'] ?? false,
// //                         ),
// //                       );
// //                     }
// //                   } else if (newSection.sectionType == 'true_false' &&
// //                       b['true_false_answer'] != null) {
// //                     newBranch.tfAnswer =
// //                         b['true_false_answer']['correct_answer'];
// //                   } else if (newSection.sectionType == 'fill_blank' &&
// //                       b['fill_blank_answer'] != null) {
// //                     newBranch.fillBlankAnswerController.text =
// //                         b['fill_blank_answer']['correct_word'] ?? '';
// //                   } else if (newSection.sectionType == 'matching' &&
// //                       b['matching_pairs'] != null) {
// //                     newBranch.matchingPairs.clear();
// //                     for (var pair in b['matching_pairs']) {
// //                       newBranch.matchingPairs.add(
// //                         MatchingPairModel(
// //                           term: pair['term'] ?? '',
// //                           match: pair['match'] ?? '',
// //                         ),
// //                       );
// //                     }
// //                   } else if (newSection.sectionType == 'essay' &&
// //                       b['essay_answer'] != null) {
// //                     newBranch.essayModelAnswerController.text =
// //                         b['essay_answer']['model_answer'] ?? '';
// //                     newBranch.essayKeywordsController.text =
// //                         b['essay_answer']['keywords'] ?? '';
// //                   }
// //                   newSection.items.add(newBranch);
// //                 }
// //                 newGroup.sections.add(newSection);
// //               }
// //               _groups.add(newGroup);
// //             }
// //           }
// //           _isExamSaved = true;
// //         });
// //       }
// //     } catch (e) {
// //       _showSnackbar('${S.of(context).error_prefix} $e', isError: true);
// //     } finally {
// //       setState(() => _isSaving = false);
// //     }
// //   }

// //   Future<void> _fetchCoursesFromDatabase() async {
// //     try {
// //       final response = await http.get(
// //         Uri.parse('http://localhost:8000/api/exams/teacher/1/courses-dropdown'),
// //       );

// //       if (response.statusCode == 200) {
// //         final List<dynamic> data = jsonDecode(response.body);

// //         setState(() {
// //           _myCourses = data.map((json) {
// //             final foldersList = (json['folders'] as List<dynamic>?) ?? [];
// //             return CourseModel(
// //               id: json['id'] ?? 0,
// //               name: json['name'] ?? S.of(context).untitled_exam,
// //               specialization: json['specialization'] ?? '',
// //               level: json['level'] ?? '',
// //               folders: foldersList
// //                   .map((f) => FolderModel(id: f['id'], name: f['name']))
// //                   .toList(),
// //             );
// //           }).toList();
// //           _isLoadingCourses = false;
// //         });

// //         if (_myCourses.isEmpty) {
// //           WidgetsBinding.instance.addPostFrameCallback((_) {
// //             _showNoCourseDialog();
// //           });
// //         }
// //       } else {
// //         setState(() => _isLoadingCourses = false);
// //         _showSnackbar(S.of(context).connection_error, isError: true);
// //       }
// //     } catch (e) {
// //       setState(() => _isLoadingCourses = false);
// //       _showSnackbar('${S.of(context).connection_error} $e', isError: true);
// //     }
// //   }

// //   @override
// //   void didChangeDependencies() {
// //     super.didChangeDependencies();
// //     if (_groups.isEmpty) {
// //       _groups = [QuestionGroupModel()];
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _titleController.dispose();
// //     _dateController.dispose();
// //     _timeLimitController.dispose();
// //     _specializationController.dispose();
// //     _levelController.dispose();
// //     _folderController.dispose();
// //     super.dispose();
// //   }

// //   double _getTotalGrade() {
// //     double total = 0;
// //     for (final g in _groups) {
// //       for (final s in g.sections) {
// //         for (final b in s.items) {
// //           total += b.grade;
// //         }
// //       }
// //     }
// //     return total;
// //   }

// //   int get _effectiveFolderId {
// //     // 1. في حالة التعديل (القراءة من سياق مسبق)
// //     if (_isReadOnlyMode) {
// //       return widget.examContext!.folderId ?? 1;
// //     }

// //     // 2. إذا المعلم اختار المادة والمجلد معاً
// //     if (_selectedFolder != null) {
// //       return _selectedFolder!.id;
// //     }

// //     // 3. اللوجيك الجديد: إذا اختار المادة، بس نسى يختار المجلد
// //     // ➔ نحفظه في أول مجلد داخل هذي المادة اللي اختارها
// //     if (_selectedCourse != null && _selectedCourse!.folders.isNotEmpty) {
// //       return _selectedCourse!.folders.first.id;
// //     }

// //     // 4. اللوجيك الجديد: إذا ما اختار لا مادة ولا مجلد
// //     // ➔ نحفظه في أول مجلد تابع لأول مادة موجودة في حسابه
// //     if (_myCourses.isNotEmpty && _myCourses.first.folders.isNotEmpty) {
// //       return _myCourses.first.folders.first.id;
// //     }

// //     // خط دفاع أخير عشان ما يضرب الفلاتر
// //     return 1;
// //   }

// //   Future<void> _handleNavigation(int index) async {
// //     if (index == _selectedIndex) return;

// //     // 🌟 1. إغلاق القائمة الجانبية (Drawer) فوراً لفك أي تجميد في الشاشة
// //     if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
// //       Navigator.of(context).pop();
// //       await Future.delayed(const Duration(milliseconds: 200));
// //     }

// //     // 🌟 2. إذا كان فيه تعديلات لم تُحفظ
// //     if (!_isExamSaved) {
// //       final action = await showDialog<String>(
// //         context: context,
// //         barrierDismissible: false, // نمنع الإغلاق بالضغط خارج النافذة
// //         builder: (ctx) => AlertDialog(
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(20),
// //           ),
// //           title: Text(
// //             S.of(context).exit_warning_title,
// //             style: const TextStyle(fontWeight: FontWeight.bold),
// //           ),
// //           content: Text(S.of(context).exit_warning_content),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.of(ctx).pop('leave'),
// //               child: Text(
// //                 S.of(context).exit_without_saving,
// //                 style: const TextStyle(color: Colors.red),
// //               ),
// //             ),
// //             ElevatedButton(
// //               onPressed: () => Navigator.of(ctx).pop('save'),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: AppColors.primaryTeal(context),
// //               ),
// //               child: Text(
// //                 S.of(context).save_draft_and_exit,
// //                 style: const TextStyle(color: Colors.white),
// //               ),
// //             ),
// //           ],
// //         ),
// //       );

// //       if (action == null) return;

// //       if (action == 'save') {
// //         // 🌟 3. إظهار دائرة تحميل (Dialog) إجبارية وواضحة للمستخدم
// //         showDialog(
// //           context: context,
// //           barrierDismissible: false,
// //           barrierColor: Colors.black.withValues(alpha: 0.1), // خلفية شفافة جداً
// //           builder: (ctx) => const Center(child: CircularProgressIndicator()),
// //         );

// //         // حفظ الاختبار في الباك إند
// //         bool success = await _saveExam(isDraft: true);

// //         // 🌟 4. السطر السحري لحل مشكلة التعليق: إغلاق دائرة التحميل بالقوة
// //         if (mounted) Navigator.of(context).pop();

// //         if (!success) return; // إذا فشل الحفظ بسبب النت، وقّف الانتقال

// //         // إظهار رسالة النجاح والانتظار ثانية واحدة ليقرأها المستخدم براحته قبل لا تطير الشاشة
// //         await Future.delayed(const Duration(seconds: 1));
// //       } else if (action != 'leave') {
// //         return;
// //       }
// //     }

// //     // 🌟 5. الانتقال للصفحة الجديدة بأمان تام ونظافة
// //     Widget? target;
// //     switch (index) {
// //       case 0:
// //         target = const DashboardScreen();
// //         break;
// //       case 1:
// //         target = const ExamManagementPage();
// //         break;
// //       case 2:
// //         target = const Material1();
// //         break;
// //       case 3:
// //         target = const GradingPage();
// //         break;
// //       case 4:
// //         target = const ReviewExamPage();
// //         break;
// //       case 5:
// //         target = const SettingsScreen();
// //         break;
// //     }

// //     if (target != null && mounted) {
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (_) => target!),
// //       );
// //     }
// //   }

// //   Future<void> _selectDate() async {
// //     final picked = await showDatePicker(
// //       context: context,
// //       initialDate: DateTime.now(),
// //       firstDate: DateTime.now(),
// //       lastDate: DateTime(2030),
// //       builder: (ctx, child) => Theme(
// //         data: Theme.of(ctx).copyWith(
// //           colorScheme: ColorScheme.light(
// //             primary: AppColors.primaryTeal(context),
// //           ),
// //         ),
// //         child: child!,
// //       ),
// //     );
// //     if (picked != null) {
// //       setState(
// //         () => _dateController.text =
// //             '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}',
// //       );
// //       _markAsUnsaved();
// //     }
// //   }

// //   String _getNumberingString(int index, String style) {
// //     if (style == 'none') return '';
// //     if (style == 'letters_ar') {
// //       const letters = [
// //         'أ',
// //         'ب',
// //         'ج',
// //         'د',
// //         'هـ',
// //         'و',
// //         'ز',
// //         'ح',
// //         'ط',
// //         'ي',
// //         'ك',
// //         'ل',
// //         'م',
// //         'ن',
// //         'س',
// //         'ع',
// //         'ف',
// //         'ص',
// //         'ق',
// //         'ر',
// //         'ش',
// //         'ت',
// //         'ث',
// //         'خ',
// //         'ذ',
// //         'ض',
// //         'ظ',
// //         'غ',
// //       ];
// //       return letters[index % letters.length];
// //     }
// //     if (style == 'letters_en') {
// //       return String.fromCharCode(65 + (index % 26));
// //     }
// //     if (style == 'roman') {
// //       const roman = [
// //         'I',
// //         'II',
// //         'III',
// //         'IV',
// //         'V',
// //         'VI',
// //         'VII',
// //         'VIII',
// //         'IX',
// //         'X',
// //         'XI',
// //         'XII',
// //         'XIII',
// //         'XIV',
// //         'XV',
// //         'XVI',
// //         'XVII',
// //         'XVIII',
// //         'XIX',
// //         'XX',
// //       ];
// //       if (index < roman.length) return roman[index];
// //       return (index + 1).toString();
// //     }
// //     return (index + 1).toString();
// //   }

// //   void _showNoCourseDialog() {
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (ctx) => AlertDialog(
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //         title: Row(
// //           children: [
// //             Icon(
// //               Icons.warning_amber_rounded,
// //               color: AppColors.primaryTeal(context),
// //               size: 28,
// //             ),
// //             const SizedBox(width: 10),
// //             Text(
// //               S.of(context).no_course_dialog_title,
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.bold,
// //                 color: AppColors.textPrimary(context),
// //               ),
// //             ),
// //           ],
// //         ),
// //         content: Text(
// //           S.of(context).no_course_dialog_body,
// //           style: TextStyle(
// //             color: AppColors.textSecondary(context),
// //             height: 1.6,
// //           ),
// //         ),
// //         actions: [
// //           ElevatedButton(
// //             onPressed: () {
// //               Navigator.pop(ctx);
// //               Navigator.pop(context);
// //             },
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: AppColors.primaryTeal(context),
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //             ),
// //             child: Text(
// //               S.of(context).go_back,
// //               style: const TextStyle(color: Colors.white),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   String? _getValidationError() {
// //     if (_titleController.text.trim().isEmpty)
// //       return S.of(context).err_exam_title;
// //     if (_dateController.text.trim().isEmpty) return S.of(context).err_exam_date;
// //     if (!_isReadOnlyMode && _selectedCourse == null)
// //       return S.of(context).err_exam_course;
// //     if (!_isReadOnlyMode && _selectedFolder == null)
// //       return S.of(context).err_exam_folder;
// //     if (_totalDurationMinutes == null || _totalDurationMinutes == 0)
// //       return S.of(context).err_empty_time_limit;

// //     bool hasQuestions = false;
// //     for (var group in _groups) {
// //       for (var section in group.sections) {
// //         for (var branch in section.items) {
// //           hasQuestions = true;
// //           if (branch.questionController.text.trim().isEmpty)
// //             return S.of(context).err_empty_question;
// //           if (branch.grade <= 0) return S.of(context).err_zero_grade;

// //           switch (section.sectionType) {
// //             case 'mcq':
// //               if (branch.mcqOptions.every((o) => !o.isCorrect))
// //                 return S.of(context).err_no_correct_mcq;
// //               break;
// //             case 'true_false':
// //               if (branch.tfAnswer == null)
// //                 return S.of(context).err_no_tf_answer;
// //               break;
// //             case 'fill_blank':
// //               if (branch.fillBlankAnswerController.text.trim().isEmpty)
// //                 return S.of(context).err_empty_fill_blank;
// //               break;
// //             case 'matching':
// //               if (branch.matchingPairs.any(
// //                 (p) =>
// //                     p.termController.text.trim().isEmpty ||
// //                     p.matchController.text.trim().isEmpty,
// //               ))
// //                 return S.of(context).err_empty_matching;
// //               break;
// //             case 'essay':
// //               if (branch.essayModelAnswerController.text.trim().isEmpty)
// //                 return S.of(context).err_empty_essay;
// //               break;
// //           }
// //         }
// //       }
// //     }
// //     if (!hasQuestions) return S.of(context).err_empty_exam;
// //     return null;
// //   }

// //   Future<bool> _saveExam({bool isDraft = false}) async {
// //     if (!isDraft) {
// //       String? errorMessage = _getValidationError();
// //       if (errorMessage != null) {
// //         _showSnackbar(errorMessage, isError: true);
// //         return false;
// //       }
// //     } else {
// //       if (_titleController.text.trim().isEmpty) {
// //         _titleController.text = S.of(context).untitled_exam;
// //       }
// //     }

// //     setState(() => _isSaving = true);

// //     try {
// //       final groupsJson = _groups.asMap().entries.map((gEntry) {
// //         final gi = gEntry.key;
// //         final g = gEntry.value;
// //         final sectionsJson = g.sections.asMap().entries.map((sEntry) {
// //           final si = sEntry.key;
// //           final s = sEntry.value;
// //           final branchesJson = s.items.asMap().entries.map((bEntry) {
// //             final bi = bEntry.key;
// //             final b = bEntry.value;
// //             final Map<String, dynamic> branchMap = {
// //               'question_text': b.questionController.text.trim(),
// //               'question_mark': b.grade,
// //               'question_order': bi + 1,
// //               'question_numbering_style': b.numberingStyle,
// //             };
// //             switch (s.sectionType) {
// //               case 'mcq':
// //                 branchMap['mcq_options'] = b.mcqOptions
// //                     .map(
// //                       (o) => {
// //                         'option_text': o.controller.text.trim(),
// //                         'is_correct': o.isCorrect,
// //                       },
// //                     )
// //                     .toList();
// //                 break;
// //               case 'true_false':
// //                 if (b.tfAnswer != null)
// //                   branchMap['true_false_answer'] = {
// //                     'correct_answer': b.tfAnswer,
// //                   };
// //                 break;
// //               case 'fill_blank':
// //                 branchMap['fill_blank_answer'] = {
// //                   'correct_word': b.fillBlankAnswerController.text.trim(),
// //                 };
// //                 break;
// //               case 'matching':
// //                 branchMap['matching_pairs'] = b.matchingPairs
// //                     .map(
// //                       (p) => {
// //                         'term': p.termController.text.trim(),
// //                         'match': p.matchController.text.trim(),
// //                       },
// //                     )
// //                     .toList();
// //                 break;
// //               case 'essay':
// //                 branchMap['essay_answer'] = {
// //                   'model_answer': b.essayModelAnswerController.text.trim(),
// //                   'keywords': b.essayKeywordsController.text.trim(),
// //                 };
// //                 break;
// //             }
// //             return branchMap;
// //           }).toList();
// //           return {
// //             'section_title': s.titleController.text.trim(),
// //             'section_type': s.sectionType,
// //             'section_order': si + 1,
// //             'section_numbering_style': s.numberingStyle,
// //             'items': branchesJson,
// //           };
// //         }).toList();
// //         return {
// //           'group_title': g.titleController.text.trim(),
// //           'group_order': gi + 1,
// //           'group_numbering_style': g.numberingStyle,
// //           'sections': sectionsJson,
// //         };
// //       }).toList();

// //       final body = jsonEncode({
// //         if (_currentExamId != null) 'exam_id': _currentExamId,
// //         'exam_title': _titleController.text.trim(),
// //         'exam_date': _dateController.text.trim().isNotEmpty
// //             ? _dateController.text.trim()
// //             : DateTime.now().toIso8601String().substring(0, 10),
// //         'time_limit': _totalDurationMinutes?.toString() ?? '',
// //         'folder_id': _effectiveFolderId,
// //         'question_groups': groupsJson,
// //         'status': isDraft ? 'Draft' : 'Published',
// //         'exam_type': 'manual',
// //       });

// //       final response = await http
// //           .post(
// //             Uri.parse('http://localhost:8000/api/exams/create-full-exam'),
// //             headers: {'Content-Type': 'application/json'},
// //             body: body,
// //           )
// //           .timeout(const Duration(seconds: 15));

// //       if (mounted)
// //         setState(() {
// //           _isSaving = false;
// //         });

// //       if (response.statusCode == 201 || response.statusCode == 200) {
// //         final responseData = jsonDecode(response.body);
// //         _currentExamId = responseData['exam_id'];
// //         if (mounted) setState(() => _isExamSaved = true);

// //         _showSnackbar(
// //           isDraft
// //               ? S.of(context).saved_as_draft_success
// //               : S.of(context).saved_and_approved_success,
// //         );
// //         return true;
// //       } else {
// //         final err = jsonDecode(response.body);
// //         _showSnackbar(
// //           '${S.of(context).error_prefix} ${err['detail'] ?? response.body}',
// //           isError: true,
// //         );
// //         return false;
// //       }
// //     } catch (e) {
// //       if (mounted) setState(() => _isSaving = false);
// //       _showSnackbar('${S.of(context).connection_error} $e', isError: true);
// //       return false;
// //     }
// //   }

// //   void _showSnackbar(String msg, {bool isError = false}) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(msg),
// //         backgroundColor: isError
// //             ? Colors.red.shade700
// //             : AppColors.primaryTeal(context),
// //       ),
// //     );
// //   }

// //   Widget _buildNumberingDropdown(
// //     String currentValue,
// //     ValueChanged<String?> onChanged,
// //   ) {
// //     return Container(
// //       height: 28,
// //       padding: const EdgeInsets.symmetric(horizontal: 8),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(6),
// //         border: Border.all(
// //           color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
// //         ),
// //       ),
// //       child: DropdownButtonHideUnderline(
// //         child: DropdownButton<String>(
// //           value: currentValue,
// //           icon: Icon(
// //             Icons.arrow_drop_down,
// //             size: 14,
// //             color: AppColors.primaryTeal(context),
// //           ),
// //           style: TextStyle(
// //             color: AppColors.primaryTeal(context),
// //             fontSize: 12,
// //             fontWeight: FontWeight.bold,
// //           ),
// //           items: [
// //             DropdownMenuItem(
// //               value: 'numbers',
// //               child: Text(S.of(context).num_numbers),
// //             ),
// //             DropdownMenuItem(
// //               value: 'letters_ar',
// //               child: Text(S.of(context).num_letters_ar),
// //             ),
// //             DropdownMenuItem(
// //               value: 'letters_en',
// //               child: Text(S.of(context).num_letters_en),
// //             ),
// //             DropdownMenuItem(
// //               value: 'roman',
// //               child: Text(S.of(context).num_roman),
// //             ),
// //             DropdownMenuItem(
// //               value: 'none',
// //               child: Text(S.of(context).num_none),
// //             ),
// //           ],
// //           onChanged: (val) {
// //             _markAsUnsaved();
// //             onChanged(val);
// //           },
// //         ),
// //       ),
// //     );
// //   }

// //   Future<bool> _onWillPop() async {
// //     if (_isExamSaved) return true;

// //     final shouldPop = await showDialog<bool>(
// //       context: context,
// //       builder: (ctx) => AlertDialog(
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //         title: Text(
// //           S.of(context).exit_warning_title,
// //           style: const TextStyle(fontWeight: FontWeight.bold),
// //         ),
// //         content: Text(S.of(context).exit_warning_content),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.of(ctx).pop(true),
// //             child: Text(
// //               S.of(context).exit_without_saving,
// //               style: const TextStyle(color: Colors.red),
// //             ),
// //           ),
// //           ElevatedButton(
// //             onPressed: () async {
// //               Navigator.of(ctx).pop(false);
// //               bool success = await _saveExam(isDraft: true);
// //               if (success && mounted) {
// //                 Navigator.of(context).pop(true);
// //               }
// //             },
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: AppColors.primaryTeal(context),
// //             ),
// //             child: Text(
// //               S.of(context).save_draft_and_exit,
// //               style: const TextStyle(color: Colors.white),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //     return shouldPop ?? false;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return WillPopScope(
// //       onWillPop: _onWillPop,
// //       child: LayoutBuilder(
// //         builder: (context, constraints) {
// //           final isMobile = constraints.maxWidth < 1000;
// //           return Scaffold(
// //             key: _scaffoldKey,
// //             backgroundColor: AppColors.secondaryTeal(context),
// //             drawer: isMobile
// //                 ? Drawer(
// //                     width: 260,
// //                     child: SafeArea(
// //                       child: CustSidebar(
// //                         selectedIndex: _selectedIndex,
// //                         onItemSelected: _handleNavigation,
// //                       ),
// //                     ),
// //                   )
// //                 : null,
// //             body: Stack(
// //               children: [
// //                 Row(
// //                   children: [
// //                     if (!isMobile)
// //                       CustSidebar(
// //                         selectedIndex: _selectedIndex,
// //                         onItemSelected: _handleNavigation,
// //                       ),
// //                     Expanded(
// //                       child: Column(
// //                         children: [
// //                           if (isMobile) _buildMobileAppBar(),
// //                           Expanded(
// //                             child: SingleChildScrollView(
// //                               padding: EdgeInsets.all(isMobile ? 16 : 32),
// //                               child: Center(
// //                                 child: Container(
// //                                   constraints: const BoxConstraints(
// //                                     maxWidth: 1000,
// //                                   ),
// //                                   child: Column(
// //                                     crossAxisAlignment:
// //                                         CrossAxisAlignment.start,
// //                                     children: [
// //                                       _buildBreadcrumbCard(),
// //                                       const SizedBox(height: 24),
// //                                       _buildExamInfoCard(context),
// //                                       const SizedBox(height: 24),
// //                                       ...List.generate(
// //                                         _groups.length,
// //                                         (gi) => Padding(
// //                                           padding: const EdgeInsets.only(
// //                                             bottom: 24,
// //                                           ),
// //                                           child: _buildGroupCard(context, gi),
// //                                         ),
// //                                       ),
// //                                       _buildAddButton(
// //                                         context,
// //                                         label: S
// //                                             .of(context)
// //                                             .add_main_question_btn,
// //                                         onTap: () => setState(() {
// //                                           String currentStyle =
// //                                               _groups.isNotEmpty
// //                                               ? _groups.first.numberingStyle
// //                                               : 'numbers';
// //                                           _groups.add(
// //                                             QuestionGroupModel(
// //                                               numberingStyle: currentStyle,
// //                                             ),
// //                                           );
// //                                         }),
// //                                       ),
// //                                       const SizedBox(height: 40),
// //                                       _buildFooterButtons(context),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 if (_isSaving)
// //                   Positioned.fill(
// //                     child: Container(
// //                       color: Colors.black.withOpacity(0.3),
// //                       child: const Center(child: CircularProgressIndicator()),
// //                     ),
// //                   ),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildMobileAppBar() {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //       decoration: const BoxDecoration(
// //         color: Colors.white,
// //         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
// //       ),
// //       child: SafeArea(
// //         bottom: false,
// //         child: Row(
// //           children: [
// //             IconButton(
// //               icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)),
// //               onPressed: () => _scaffoldKey.currentState?.openDrawer(),
// //             ),
// //             const SizedBox(width: 8),
// //             Text(
// //               S.of(context).create_electronic_exam,
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 18,
// //                 color: AppColors.textPrimary(context),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildBreadcrumbCard() {
// //     bool isRtl = Directionality.of(context) == TextDirection.rtl;
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(15),
// //         boxShadow: [
// //           BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           GestureDetector(
// //             onTap: () async {
// //               bool canNavigate = await _onWillPop();
// //               if (canNavigate && mounted) Navigator.pop(context);
// //             },
// //             child: Text(
// //               S.of(context).exam_management_title,
// //               style: const TextStyle(
// //                 color: Colors.grey,
// //                 fontSize: 13,
// //                 decoration: TextDecoration.underline,
// //               ),
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 8),
// //             child: Icon(
// //               isRtl ? Icons.chevron_left : Icons.chevron_right,
// //               color: Colors.grey,
// //               size: 16,
// //             ),
// //           ),
// //           Text(
// //             S.of(context).create_electronic_exam,
// //             style: TextStyle(
// //               color: AppColors.primaryTeal(context),
// //               fontWeight: FontWeight.bold,
// //               fontSize: 14,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildExamInfoCard(BuildContext context) {
// //     final bool isMobile = MediaQuery.of(context).size.width < 800;
// //     return Container(
// //       padding: const EdgeInsets.all(18),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withValues(alpha: 0.02),
// //             blurRadius: 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             children: [
// //               Text(
// //                 S.of(context).exam_info,
// //                 style: TextStyle(
// //                   fontWeight: FontWeight.bold,
// //                   fontSize: 18,
// //                   color: AppColors.textPrimary(context),
// //                 ),
// //               ),
// //               if (isMobile) _gradeBox(context),
// //             ],
// //           ),
// //           const SizedBox(height: 15),
// //           isMobile
// //               ? Column(
// //                   children: [
// //                     _infoTextField(
// //                       context,
// //                       label: S.of(context).exam_title_label,
// //                       icon: Icons.description_outlined,
// //                       controller: _titleController,
// //                       hint: " ",
// //                     ),
// //                     const SizedBox(height: 16),
// //                     InkWell(
// //                       onTap: _showTimeLimitDialog,
// //                       borderRadius: BorderRadius.circular(10),
// //                       child: AbsorbPointer(
// //                         child: _infoTextField(
// //                           context,
// //                           label: S.of(context).time_limit_label,
// //                           icon: Icons.timer_outlined,
// //                           controller: _timeLimitController,
// //                           hint: '',
// //                           readOnly: true,
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16),
// //                     InkWell(
// //                       onTap: _selectDate,
// //                       borderRadius: BorderRadius.circular(10),
// //                       child: AbsorbPointer(
// //                         child: _infoTextField(
// //                           context,
// //                           label: S.of(context).exam_date_label,
// //                           icon: Icons.calendar_month_outlined,
// //                           controller: _dateController,
// //                           hint: ' ',
// //                           readOnly: true,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 )
// //               : Row(
// //                   crossAxisAlignment: CrossAxisAlignment.end,
// //                   children: [
// //                     Expanded(
// //                       flex: 2,
// //                       child: _infoTextField(
// //                         context,
// //                         label: S.of(context).exam_title_label,
// //                         icon: Icons.description_outlined,
// //                         controller: _titleController,
// //                         hint: " ",
// //                       ),
// //                     ),
// //                     const SizedBox(width: 16),
// //                     Expanded(
// //                       flex: 1,
// //                       child: InkWell(
// //                         onTap: _showTimeLimitDialog,
// //                         borderRadius: BorderRadius.circular(10),
// //                         child: AbsorbPointer(
// //                           child: _infoTextField(
// //                             context,
// //                             label: S.of(context).time_limit_label,
// //                             icon: Icons.timer_outlined,
// //                             controller: _timeLimitController,
// //                             hint: ' ',
// //                             readOnly: true,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 16),
// //                     Expanded(
// //                       flex: 1,
// //                       child: InkWell(
// //                         onTap: _selectDate,
// //                         borderRadius: BorderRadius.circular(10),
// //                         child: AbsorbPointer(
// //                           child: _infoTextField(
// //                             context,
// //                             label: S.of(context).exam_date_label,
// //                             icon: Icons.calendar_month_outlined,
// //                             controller: _dateController,
// //                             hint: ' ',
// //                             readOnly: true,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 16),
// //                     if (!isMobile) _gradeBox(context),
// //                   ],
// //                 ),
// //           const SizedBox(height: 16),
// //           _buildContextualFields(context),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildContextualFields(BuildContext context) {
// //     final bool isMobile = MediaQuery.of(context).size.width < 800;
// //     bool hasSpecialization = false;
// //     if (_isReadOnlyMode) {
// //       final spec = widget.examContext!.specialization;
// //       hasSpecialization =
// //           spec != null && spec.trim().isNotEmpty && spec.trim() != 'عام';
// //     } else {
// //       final spec = _specializationController.text;
// //       hasSpecialization = spec.trim().isNotEmpty && spec.trim() != 'عام';
// //     }

// //     List<Widget> fields = [];
// //     if (_isReadOnlyMode) {
// //       final ctx = widget.examContext!;
// //       fields.add(
// //         _infoTextField(
// //           context,
// //           label: S.of(context).course_name_label,
// //           icon: Icons.book_outlined,
// //           hint: ctx.courseName ?? '',
// //           readOnly: true,
// //         ),
// //       );
// //       fields.add(
// //         _infoTextField(
// //           context,
// //           label: S.of(context).folder_name_label,
// //           icon: Icons.folder_outlined,
// //           hint: ctx.folderName ?? '',
// //           readOnly: true,
// //         ),
// //       );
// //       fields.add(
// //         _infoTextField(
// //           context,
// //           label: S.of(context).level_label,
// //           icon: Icons.menu_book_outlined,
// //           hint: ctx.levelName ?? '',
// //           readOnly: true,
// //         ),
// //       );
// //       if (hasSpecialization)
// //         fields.add(
// //           _infoTextField(
// //             context,
// //             label: S.of(context).specialization_label,
// //             icon: Icons.category_outlined,
// //             hint: ctx.specialization ?? '',
// //             readOnly: true,
// //           ),
// //         );
// //     } else {
// //       fields.add(
// //         _isLoadingCourses
// //             ? const Center(child: CircularProgressIndicator())
// //             : _infoDropdown<CourseModel>(
// //                 context,
// //                 label: S.of(context).course_name_label,
// //                 icon: Icons.book_outlined,
// //                 value: _selectedCourse,
// //                 items: _myCourses,
// //                 itemLabel: (e) => e.name,
// //                 onChanged: (v) {
// //                   setState(() {
// //                     _selectedCourse = v;
// //                     _selectedFolder = null;
// //                     _specializationController.text = v!.specialization;
// //                     _levelController.text = v.level;
// //                   });
// //                 },
// //               ),
// //       );
// //       fields.add(
// //         _selectedCourse == null
// //             ? _infoTextField(
// //                 context,
// //                 label: S.of(context).folder_name_label,
// //                 icon: Icons.folder_outlined,
// //                 hint: ' ',
// //                 readOnly: true,
// //               )
// //             : _infoDropdown<FolderModel>(
// //                 context,
// //                 label: S.of(context).folder_name_label,
// //                 icon: Icons.folder_outlined,
// //                 value: _selectedFolder,
// //                 items: _selectedCourse!.folders,
// //                 itemLabel: (e) => e.name,
// //                 onChanged: (v) => setState(() => _selectedFolder = v),
// //               ),
// //       );
// //       fields.add(
// //         _infoTextField(
// //           context,
// //           label: S.of(context).level_label,
// //           icon: Icons.menu_book_outlined,
// //           controller: _levelController,
// //           hint: ' ',
// //           readOnly: true,
// //         ),
// //       );
// //       if (hasSpecialization)
// //         fields.add(
// //           _infoTextField(
// //             context,
// //             label: S.of(context).specialization_label,
// //             icon: Icons.category_outlined,
// //             controller: _specializationController,
// //             hint: ' ',
// //             readOnly: true,
// //           ),
// //         );
// //     }

// //     if (isMobile) {
// //       return Column(
// //         children: List.generate(
// //           fields.length,
// //           (index) => Padding(
// //             padding: EdgeInsets.only(
// //               bottom: index == fields.length - 1 ? 0 : 16,
// //             ),
// //             child: fields[index],
// //           ),
// //         ),
// //       );
// //     } else {
// //       List<Widget> rowChildren = [];
// //       for (int i = 0; i < fields.length; i++) {
// //         rowChildren.add(Expanded(child: fields[i]));
// //         if (i < fields.length - 1) rowChildren.add(const SizedBox(width: 12));
// //       }
// //       return Row(children: rowChildren);
// //     }
// //   }

// //   Widget _infoTextField(
// //     BuildContext context, {
// //     required String label,
// //     required IconData icon,
// //     TextEditingController? controller,
// //     String? hint,
// //     bool readOnly = false,
// //     VoidCallback? onTap,
// //   }) {
// //     return Container(
// //       height: 50,
// //       decoration: BoxDecoration(
// //         color: AppColors.scaffoldBg(context),
// //         borderRadius: BorderRadius.circular(10),
// //         border: Border.all(
// //           color: AppColors.textSecondary(context).withValues(alpha: 0.2),
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           const SizedBox(width: 12),
// //           Icon(icon, color: AppColors.primaryTeal(context), size: 20),
// //           const SizedBox(width: 8),
// //           Text(
// //             label,
// //             style: TextStyle(
// //               color: AppColors.textSecondary(context),
// //               fontSize: 13,
// //               fontWeight: FontWeight.w500,
// //             ),
// //           ),
// //           const SizedBox(width: 8),
// //           Expanded(
// //             child: TextField(
// //               controller: controller,
// //               readOnly: readOnly,
// //               onTap: onTap,
// //               onChanged: (value) => _markAsUnsaved(),
// //               style: const TextStyle(fontSize: 14),
// //               decoration: InputDecoration(
// //                 hintText: hint ?? "",
// //                 hintStyle: TextStyle(
// //                   color: readOnly
// //                       ? AppColors.textPrimary(context)
// //                       : AppColors.textSecondary(context),
// //                   fontSize: 13,
// //                 ),
// //                 border: InputBorder.none,
// //                 isDense: true,
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   horizontal: 8,
// //                   vertical: 10,
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _infoDropdown<T>(
// //     BuildContext context, {
// //     required String label,
// //     required IconData icon,
// //     required T? value,
// //     required List<T> items,
// //     required String Function(T) itemLabel,
// //     required ValueChanged<T?> onChanged,
// //   }) {
// //     return Container(
// //       height: 48,
// //       padding: const EdgeInsets.symmetric(horizontal: 12),
// //       decoration: BoxDecoration(
// //         color: AppColors.scaffoldBg(context),
// //         borderRadius: BorderRadius.circular(10),
// //         border: Border.all(
// //           color: AppColors.textSecondary(context).withValues(alpha: 0.2),
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           Icon(icon, color: AppColors.primaryTeal(context), size: 20),
// //           const SizedBox(width: 8),
// //           Expanded(
// //             child: DropdownButtonHideUnderline(
// //               child: DropdownButton<T>(
// //                 value: value,
// //                 isExpanded: true,
// //                 hint: Text(
// //                   items.isEmpty ? '  ' : label,
// //                   style: TextStyle(
// //                     color: items.isEmpty
// //                         ? Colors.red
// //                         : AppColors.textSecondary(context),
// //                     fontSize: 13,
// //                     fontWeight: FontWeight.w500,
// //                   ),
// //                   overflow: TextOverflow.ellipsis,
// //                 ),
// //                 icon: Icon(
// //                   Icons.keyboard_arrow_down,
// //                   color: AppColors.primaryTeal(context),
// //                   size: 18,
// //                 ),
// //                 style: TextStyle(
// //                   color: AppColors.textPrimary(context),
// //                   fontSize: 13,
// //                 ),
// //                 items: items
// //                     .map(
// //                       (e) => DropdownMenuItem<T>(
// //                         value: e,
// //                         child: Text(
// //                           itemLabel(e),
// //                           overflow: TextOverflow.ellipsis,
// //                         ),
// //                       ),
// //                     )
// //                     .toList(),
// //                 onChanged: items.isEmpty
// //                     ? null
// //                     : (val) {
// //                         _markAsUnsaved();
// //                         onChanged(val);
// //                       },
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _gradeBox(BuildContext context) {
// //     final bool isMobile = MediaQuery.of(context).size.width < 800;
// //     return Column(
// //       children: [
// //         Text(
// //           S.of(context).total_grade,
// //           style: TextStyle(
// //             fontSize: isMobile ? 8 : 11,
// //             color: AppColors.textSecondary(context),
// //           ),
// //         ),
// //         const SizedBox(height: 5),
// //         Container(
// //           width: isMobile ? 40 : 80,
// //           height: isMobile ? 30 : 48,
// //           alignment: Alignment.center,
// //           decoration: BoxDecoration(
// //             color: AppColors.primaryTeal(context).withValues(alpha: 0.1),
// //             borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
// //             border: Border.all(
// //               color: AppColors.primaryTeal(context).withValues(alpha: 0.2),
// //             ),
// //           ),
// //           child: Text(
// //             _getTotalGrade().toStringAsFixed(0),
// //             style: TextStyle(
// //               fontWeight: FontWeight.bold,
// //               fontSize: isMobile ? 16 : 20,
// //               color: AppColors.primaryTeal(context),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildGroupCard(BuildContext context, int gi) {
// //     final group = _groups[gi];
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(20),
// //         border: Border.all(
// //           color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
// //           width: 2,
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withValues(alpha: 0.02),
// //             blurRadius: 10,
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           _buildGroupHeader(context, gi, group),
// //           const Divider(height: 1),
// //           Padding(
// //             padding: const EdgeInsets.all(16),
// //             child: Column(
// //               children: [
// //                 ...List.generate(
// //                   group.sections.length,
// //                   (si) => Padding(
// //                     padding: const EdgeInsets.only(bottom: 16),
// //                     child: _buildSectionCard(context, gi, si),
// //                   ),
// //                 ),
// //                 _buildAddButton(
// //                   context,
// //                   label: S.of(context).add_section_btn,
// //                   onTap: () => setState(() {
// //                     String currentStyle = group.sections.isNotEmpty
// //                         ? group.sections.first.numberingStyle
// //                         : 'letters_ar';
// //                     group.sections.add(
// //                       QuestionSectionModel(numberingStyle: currentStyle),
// //                     );
// //                   }),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildGroupHeader(
// //     BuildContext context,
// //     int gi,
// //     QuestionGroupModel group,
// //   ) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //       decoration: BoxDecoration(
// //         color: AppColors.primaryTeal(context).withValues(alpha: 0.07),
// //         borderRadius: const BorderRadius.only(
// //           topLeft: Radius.circular(18),
// //           topRight: Radius.circular(18),
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: 32,
// //             height: 32,
// //             alignment: Alignment.center,
// //             decoration: BoxDecoration(
// //               color: AppColors.primaryTeal(context),
// //               shape: BoxShape.circle,
// //             ),
// //             child: Text(
// //               _getNumberingString(gi, group.numberingStyle),
// //               style: const TextStyle(
// //                 color: Colors.white,
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 14,
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: TextField(
// //               controller: group.titleController,
// //               onChanged: (value) => _markAsUnsaved(),
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 color: AppColors.textPrimary(context),
// //                 fontSize: 15,
// //               ),
// //               decoration: InputDecoration(
// //                 hintText: S.of(context).main_question_hint,
// //                 hintStyle: TextStyle(
// //                   color: AppColors.textSecondary(context),
// //                   fontSize: 14,
// //                 ),
// //                 border: InputBorder.none,
// //                 isDense: true,
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 8),
// //           _buildNumberingDropdown(
// //             group.numberingStyle,
// //             (val) => setState(() {
// //               for (var g in _groups) {
// //                 g.numberingStyle = val!;
// //               }
// //             }),
// //           ),
// //           if (_groups.length > 1)
// //             IconButton(
// //               icon: const Icon(
// //                 Icons.delete_outline,
// //                 color: Colors.redAccent,
// //                 size: 22,
// //               ),
// //               onPressed: () {
// //                 _markAsUnsaved();
// //                 setState(() => _groups.removeAt(gi));
// //               },
// //             ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildSectionHeader(
// //     BuildContext context,
// //     int gi,
// //     int si,
// //     QuestionSectionModel section,
// //   ) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: const BorderRadius.only(
// //           topLeft: Radius.circular(13),
// //           topRight: Radius.circular(13),
// //         ),
// //         border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
// //       ),
// //       child: Row(
// //         children: [
// //           if (section.numberingStyle != 'none') ...[
// //             Text(
// //               '${_getNumberingString(si, section.numberingStyle)} - ',
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 color: AppColors.primaryTeal(context),
// //                 fontSize: 14,
// //               ),
// //             ),
// //             const SizedBox(width: 4),
// //           ],
// //           Expanded(
// //             child: TextField(
// //               controller: section.titleController,
// //               onChanged: (value) => _markAsUnsaved(),
// //               style: TextStyle(
// //                 fontWeight: FontWeight.w600,
// //                 color: AppColors.textPrimary(context),
// //                 fontSize: 13,
// //               ),
// //               decoration: InputDecoration(
// //                 hintText: S.of(context).section_title_hint,
// //                 hintStyle: TextStyle(
// //                   color: AppColors.textSecondary(context),
// //                   fontSize: 12,
// //                 ),
// //                 border: InputBorder.none,
// //                 isDense: true,
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 8),
// //           _buildNumberingDropdown(
// //             section.numberingStyle,
// //             (val) => setState(() {
// //               for (var s in _groups[gi].sections) {
// //                 s.numberingStyle = val!;
// //               }
// //             }),
// //           ),
// //           const SizedBox(width: 8),
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
// //             decoration: BoxDecoration(
// //               color: AppColors.primaryTeal(context).withValues(alpha: 0.12),
// //               borderRadius: BorderRadius.circular(10),
// //               border: Border.all(
// //                 color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
// //               ),
// //             ),
// //             child: DropdownButtonHideUnderline(
// //               child: DropdownButton<String>(
// //                 value: section.sectionType,
// //                 isDense: true,
// //                 icon: Icon(
// //                   Icons.keyboard_arrow_down,
// //                   color: AppColors.primaryTeal(context),
// //                   size: 16,
// //                 ),
// //                 style: TextStyle(
// //                   color: AppColors.primaryTeal(context),
// //                   fontWeight: FontWeight.bold,
// //                   fontSize: 12,
// //                 ),
// //                 items: _groupTypeItems(context),
// //                 onChanged: (val) {
// //                   if (val != null) {
// //                     _markAsUnsaved();
// //                     setState(() {
// //                       section.sectionType = val;
// //                       for (final b in section.items) b.tfAnswer = null;
// //                     });
// //                   }
// //                 },
// //               ),
// //             ),
// //           ),
// //           if (_groups[gi].sections.length > 1)
// //             InkWell(
// //               onTap: () {
// //                 _markAsUnsaved();
// //                 setState(() => _groups[gi].sections.removeAt(si));
// //               },
// //               child: const Padding(
// //                 padding: EdgeInsetsDirectional.only(start: 8),
// //                 child: Icon(Icons.close, color: Colors.grey, size: 18),
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildSectionCard(BuildContext context, int gi, int si) {
// //     final section = _groups[gi].sections[si];
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: AppColors.scaffoldBg(context),
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(color: Colors.grey.shade300),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           _buildSectionHeader(context, gi, si, section),
// //           Padding(
// //             padding: const EdgeInsets.all(12),
// //             child: Column(
// //               children: [
// //                 ...List.generate(
// //                   section.items.length,
// //                   (bi) => Padding(
// //                     padding: const EdgeInsets.only(bottom: 12),
// //                     child: _buildBranchCard(context, gi, si, bi),
// //                   ),
// //                 ),
// //                 _buildAddButton(
// //                   context,
// //                   label: S.of(context).add_branch_label,
// //                   isLight: true,
// //                   onTap: () => setState(() {
// //                     String currentStyle = section.items.isNotEmpty
// //                         ? section.items.first.numberingStyle
// //                         : 'numbers';
// //                     section.items.add(
// //                       BranchModel(numberingStyle: currentStyle),
// //                     );
// //                   }),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildBranchCard(BuildContext context, int gi, int si, int bi) {
// //     final section = _groups[gi].sections[si];
// //     final branch = section.items[bi];
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: AppColors.scaffoldBg(context),
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(color: Colors.grey.shade200),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Text(
// //                 '${S.of(context).branch_label} ${_getNumberingString(bi, branch.numberingStyle)}',
// //                 style: TextStyle(
// //                   color: AppColors.primaryTeal(context),
// //                   fontWeight: FontWeight.bold,
// //                   fontSize: 13,
// //                 ),
// //               ),
// //               const Spacer(),
// //               _buildNumberingDropdown(
// //                 branch.numberingStyle,
// //                 (val) => setState(() {
// //                   for (var b in _groups[gi].sections[si].items) {
// //                     b.numberingStyle = val!;
// //                   }
// //                 }),
// //               ),
// //               if (section.items.length > 1) ...[
// //                 const SizedBox(width: 8),
// //                 InkWell(
// //                   onTap: () {
// //                     _markAsUnsaved();
// //                     setState(() => section.items.removeAt(bi));
// //                   },
// //                   child: const Icon(Icons.close, size: 18, color: Colors.grey),
// //                 ),
// //               ],
// //             ],
// //           ),
// //           const SizedBox(height: 10),
// //           _questionInput(context, branch),
// //           const SizedBox(height: 14),
// //           _buildAnswerUI(context, gi, si, bi, section.sectionType, branch),
// //           const SizedBox(height: 10),
// //           _buildBranchFooter(context, gi, si, bi, branch),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildAddButton(
// //     BuildContext context, {
// //     required String label,
// //     required VoidCallback onTap,
// //     bool isLight = false,
// //   }) {
// //     return InkWell(
// //       onTap: () {
// //         _markAsUnsaved();
// //         onTap();
// //       },
// //       borderRadius: BorderRadius.circular(10),
// //       child: Container(
// //         width: double.infinity,
// //         padding: const EdgeInsets.symmetric(vertical: 10),
// //         decoration: BoxDecoration(
// //           color: isLight
// //               ? AppColors.primaryTeal(context).withValues(alpha: 0.03)
// //               : Colors.white,
// //           borderRadius: BorderRadius.circular(10),
// //           border: Border.all(
// //             color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
// //           ),
// //         ),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(Icons.add, color: AppColors.primaryTeal(context), size: 18),
// //             const SizedBox(width: 6),
// //             Text(
// //               label,
// //               style: TextStyle(
// //                 color: AppColors.primaryTeal(context),
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 13,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   List<DropdownMenuItem<String>> _groupTypeItems(BuildContext context) => [
// //     _typeItem(context, 'mcq', S.of(context).q_mcq, Icons.list_alt_rounded),
// //     _typeItem(
// //       context,
// //       'true_false',
// //       S.of(context).q_tf,
// //       Icons.check_circle_outline,
// //     ),
// //     _typeItem(context, 'essay', S.of(context).q_essay, Icons.edit_note_rounded),
// //     _typeItem(
// //       context,
// //       'matching',
// //       S.of(context).q_matching,
// //       Icons.compare_arrows_rounded,
// //     ),
// //     _typeItem(
// //       context,
// //       'fill_blank',
// //       S.of(context).q_fill_blank,
// //       Icons.text_fields_rounded,
// //     ),
// //   ];

// //   DropdownMenuItem<String> _typeItem(
// //     BuildContext context,
// //     String value,
// //     String label,
// //     IconData icon,
// //   ) => DropdownMenuItem(
// //     value: value,
// //     child: Row(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         Icon(icon, size: 16, color: AppColors.primaryTeal(context)),
// //         const SizedBox(width: 6),
// //         Text(label, style: const TextStyle(fontSize: 13)),
// //       ],
// //     ),
// //   );

// //   Widget _questionInput(BuildContext context, BranchModel b) => Container(
// //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
// //     decoration: BoxDecoration(
// //       color: AppColors.secondaryTeal(context).withValues(alpha: 0.2),
// //       borderRadius: BorderRadius.circular(15),
// //     ),
// //     child: TextField(
// //       controller: b.questionController,
// //       textAlign: TextAlign.center,
// //       onChanged: (value) => _markAsUnsaved(),
// //       decoration: InputDecoration(
// //         hintText: S.of(context).write_question_hint,
// //         border: InputBorder.none,
// //       ),
// //     ),
// //   );

// //   Widget _buildAnswerUI(
// //     BuildContext context,
// //     int gi,
// //     int si,
// //     int bi,
// //     String sectionType,
// //     BranchModel branch,
// //   ) {
// //     switch (sectionType) {
// //       case 'mcq':
// //         return _buildMCQAnswerUI(context, gi, si, bi, branch);
// //       case 'true_false':
// //         return _buildTFAnswerUI(context, gi, si, bi, branch);
// //       case 'fill_blank':
// //         return _buildFillBlankAnswerUI(context, branch);
// //       case 'matching':
// //         return _buildMatchingAnswerUI(context, gi, si, bi, branch);
// //       case 'essay':
// //         return _buildEssayAnswerUI(context, branch);
// //       default:
// //         return const SizedBox();
// //     }
// //   }

// //   Widget _buildMCQAnswerUI(
// //     BuildContext context,
// //     int gi,
// //     int si,
// //     int bi,
// //     BranchModel branch,
// //   ) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         _answerLabel(
// //           context,
// //           S.of(context).mcq_options_label,
// //           Icons.radio_button_checked,
// //         ),
// //         const SizedBox(height: 8),
// //         ...branch.mcqOptions.asMap().entries.map(
// //           (entry) => Padding(
// //             padding: const EdgeInsets.only(bottom: 8),
// //             child: _buildMCQOption(context, entry.key, entry.value, branch),
// //           ),
// //         ),
// //         TextButton.icon(
// //           onPressed: () {
// //             _markAsUnsaved();
// //             setState(() => branch.mcqOptions.add(McqOptionModel()));
// //           },
// //           icon: Icon(
// //             Icons.add,
// //             color: AppColors.primaryTeal(context),
// //             size: 18,
// //           ),
// //           label: Text(
// //             '+ ${S.of(context).add_option}',
// //             style: TextStyle(
// //               color: AppColors.primaryTeal(context),
// //               fontWeight: FontWeight.bold,
// //               fontSize: 13,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildMCQOption(
// //     BuildContext context,
// //     int oi,
// //     McqOptionModel opt,
// //     BranchModel branch,
// //   ) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //       decoration: BoxDecoration(
// //         color: opt.isCorrect
// //             ? AppColors.primaryTeal(context).withValues(alpha: 0.08)
// //             : Colors.white,
// //         borderRadius: BorderRadius.circular(30),
// //         border: Border.all(
// //           color: opt.isCorrect
// //               ? AppColors.primaryTeal(context)
// //               : Colors.grey.shade300,
// //           width: opt.isCorrect ? 1.5 : 1,
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           GestureDetector(
// //             onTap: () {
// //               _markAsUnsaved();
// //               setState(() {
// //                 for (final o in branch.mcqOptions) {
// //                   o.isCorrect = false;
// //                 }
// //                 opt.isCorrect = true;
// //               });
// //             },
// //             child: Icon(
// //               opt.isCorrect ? Icons.check_circle : Icons.circle_outlined,
// //               color: opt.isCorrect
// //                   ? AppColors.primaryTeal(context)
// //                   : Colors.grey,
// //               size: 22,
// //             ),
// //           ),
// //           const SizedBox(width: 10),
// //           Expanded(
// //             child: TextField(
// //               controller: opt.controller,
// //               onChanged: (value) => _markAsUnsaved(),
// //               decoration: const InputDecoration(
// //                 border: InputBorder.none,
// //                 isDense: true,
// //               ),
// //             ),
// //           ),
// //           if (branch.mcqOptions.length > 2)
// //             IconButton(
// //               icon: const Icon(Icons.close, size: 16, color: Colors.grey),
// //               onPressed: () {
// //                 _markAsUnsaved();
// //                 setState(() => branch.mcqOptions.removeAt(oi));
// //               },
// //             ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTFAnswerUI(
// //     BuildContext context,
// //     int gi,
// //     int si,
// //     int bi,
// //     BranchModel branch,
// //   ) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         _answerLabel(
// //           context,
// //           S.of(context).tf_select_label,
// //           Icons.check_circle_outline,
// //         ),
// //         const SizedBox(height: 10),
// //         Row(
// //           children: [
// //             Expanded(
// //               child: _tfToggleBtn(
// //                 context,
// //                 label: S.of(context).true_word,
// //                 selected: branch.tfAnswer == 'true',
// //                 onTap: () => setState(() => branch.tfAnswer = 'true'),
// //                 color: Colors.green,
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: _tfToggleBtn(
// //                 context,
// //                 label: S.of(context).false_word,
// //                 selected: branch.tfAnswer == 'false',
// //                 onTap: () => setState(() => branch.tfAnswer = 'false'),
// //                 color: Colors.red,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _tfToggleBtn(
// //     BuildContext context, {
// //     required String label,
// //     required bool selected,
// //     required VoidCallback onTap,
// //     required Color color,
// //   }) {
// //     return GestureDetector(
// //       onTap: () {
// //         _markAsUnsaved();
// //         onTap();
// //       },
// //       child: AnimatedContainer(
// //         duration: const Duration(milliseconds: 200),
// //         padding: const EdgeInsets.symmetric(vertical: 14),
// //         decoration: BoxDecoration(
// //           color: selected ? color.withValues(alpha: 0.15) : Colors.white,
// //           borderRadius: BorderRadius.circular(30),
// //           border: Border.all(
// //             color: selected ? color : Colors.grey.shade300,
// //             width: selected ? 2 : 1,
// //           ),
// //         ),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(
// //               selected ? Icons.check_circle : Icons.circle_outlined,
// //               color: selected ? color : Colors.grey,
// //               size: 18,
// //             ),
// //             const SizedBox(width: 8),
// //             Text(
// //               label,
// //               style: TextStyle(
// //                 color: selected ? color : AppColors.textSecondary(context),
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildFillBlankAnswerUI(BuildContext context, BranchModel branch) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         _answerLabel(
// //           context,
// //           S.of(context).fill_blank_hint_label,
// //           Icons.text_fields_rounded,
// //         ),
// //         const SizedBox(height: 8),
// //         _answerTextField(
// //           context,
// //           controller: branch.fillBlankAnswerController,
// //           hint: S.of(context).fill_blank_answer_hint,
// //           icon: Icons.short_text_rounded,
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildMatchingAnswerUI(
// //     BuildContext context,
// //     int gi,
// //     int si,
// //     int bi,
// //     BranchModel branch,
// //   ) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         _answerLabel(
// //           context,
// //           S.of(context).matching_pairs_label,
// //           Icons.compare_arrows_rounded,
// //         ),
// //         const SizedBox(height: 8),
// //         ...branch.matchingPairs.asMap().entries.map(
// //           (entry) => Padding(
// //             padding: const EdgeInsets.only(bottom: 10),
// //             child: _buildMatchingPairRow(
// //               context,
// //               gi,
// //               si,
// //               bi,
// //               entry.key,
// //               entry.value,
// //               branch,
// //             ),
// //           ),
// //         ),
// //         TextButton.icon(
// //           onPressed: () {
// //             _markAsUnsaved();
// //             setState(() => branch.matchingPairs.add(MatchingPairModel()));
// //           },
// //           icon: Icon(
// //             Icons.add,
// //             color: AppColors.primaryTeal(context),
// //             size: 18,
// //           ),
// //           label: Text(
// //             '+ ${S.of(context).add_matching_pair}',
// //             style: TextStyle(
// //               color: AppColors.primaryTeal(context),
// //               fontWeight: FontWeight.bold,
// //               fontSize: 13,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildMatchingPairRow(
// //     BuildContext context,
// //     int gi,
// //     int si,
// //     int bi,
// //     int pi,
// //     MatchingPairModel pair,
// //     BranchModel branch,
// //   ) {
// //     return Row(
// //       children: [
// //         Container(
// //           width: 24,
// //           height: 24,
// //           alignment: Alignment.center,
// //           decoration: BoxDecoration(
// //             color: AppColors.primaryTeal(context).withValues(alpha: 0.15),
// //             shape: BoxShape.circle,
// //           ),
// //           child: Text(
// //             '${pi + 1}',
// //             style: TextStyle(
// //               fontSize: 11,
// //               fontWeight: FontWeight.bold,
// //               color: AppColors.primaryTeal(context),
// //             ),
// //           ),
// //         ),
// //         const SizedBox(width: 8),
// //         Expanded(
// //           child: _answerTextField(
// //             context,
// //             controller: pair.termController,
// //             hint: S.of(context).matching_term_hint,
// //             icon: Icons.looks_one_outlined,
// //           ),
// //         ),
// //         Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 8),
// //           child: Icon(
// //             Icons.arrow_forward,
// //             color: AppColors.primaryTeal(context),
// //             size: 20,
// //           ),
// //         ),
// //         Expanded(
// //           child: _answerTextField(
// //             context,
// //             controller: pair.matchController,
// //             hint: S.of(context).matching_match_hint,
// //             icon: Icons.looks_two_outlined,
// //           ),
// //         ),
// //         if (branch.matchingPairs.length > 1)
// //           IconButton(
// //             icon: const Icon(Icons.close, size: 16, color: Colors.grey),
// //             padding: EdgeInsets.zero,
// //             constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
// //             onPressed: () {
// //               _markAsUnsaved();
// //               setState(() => branch.matchingPairs.removeAt(pi));
// //             },
// //           ),
// //       ],
// //     );
// //   }

// //   Widget _buildEssayAnswerUI(BuildContext context, BranchModel branch) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         _answerLabel(
// //           context,
// //           S.of(context).essay_answer_label,
// //           Icons.edit_note_rounded,
// //         ),
// //         const SizedBox(height: 8),
// //         Container(
// //           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(12),
// //             border: Border.all(color: Colors.grey.shade200),
// //           ),
// //           child: TextField(
// //             controller: branch.essayModelAnswerController,
// //             onChanged: (value) => _markAsUnsaved(),
// //             maxLines: 3,
// //             decoration: InputDecoration(
// //               hintText: S.of(context).essay_model_answer_hint,
// //               hintStyle: TextStyle(
// //                 color: AppColors.textSecondary(context),
// //                 fontSize: 13,
// //               ),
// //               border: InputBorder.none,
// //               isDense: true,
// //             ),
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         _answerTextField(
// //           context,
// //           controller: branch.essayKeywordsController,
// //           hint: S.of(context).essay_keywords_hint,
// //           icon: Icons.label_outline,
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _answerLabel(BuildContext context, String text, IconData icon) => Row(
// //     children: [
// //       Icon(icon, size: 16, color: AppColors.primaryTeal(context)),
// //       const SizedBox(width: 6),
// //       Flexible(
// //         child: Text(
// //           text,
// //           style: TextStyle(
// //             color: AppColors.primaryTeal(context),
// //             fontSize: 12,
// //             fontWeight: FontWeight.w600,
// //           ),
// //         ),
// //       ),
// //     ],
// //   );

// //   Widget _answerTextField(
// //     BuildContext context, {
// //     required TextEditingController controller,
// //     required String hint,
// //     required IconData icon,
// //   }) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(10),
// //         border: Border.all(
// //           color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           Icon(icon, size: 16, color: AppColors.primaryTeal(context)),
// //           const SizedBox(width: 8),
// //           Expanded(
// //             child: TextField(
// //               controller: controller,
// //               style: const TextStyle(fontSize: 13),
// //               onChanged: (value) => _markAsUnsaved(),
// //               decoration: InputDecoration(
// //                 hintText: hint,
// //                 hintStyle: const TextStyle(fontSize: 12),
// //                 border: InputBorder.none,
// //                 isDense: true,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildBranchFooter(
// //     BuildContext context,
// //     int gi,
// //     int si,
// //     int bi,
// //     BranchModel branch,
// //   ) {
// //     return Row(
// //       children: [
// //         IconButton(
// //           icon: const Icon(Icons.copy_all, color: Colors.grey, size: 18),
// //           tooltip: S.of(context).copy_branch_tooltip,
// //           onPressed: () {
// //             _markAsUnsaved();
// //             setState(() {
// //               final copy = BranchModel(
// //                 questionText: branch.questionController.text,
// //                 grade: branch.grade,
// //                 tfAnswer: branch.tfAnswer,
// //                 fillBlankAnswer: branch.fillBlankAnswerController.text,
// //                 essayModelAnswer: branch.essayModelAnswerController.text,
// //                 essayKeywords: branch.essayKeywordsController.text,
// //                 matchingPairs: branch.matchingPairs
// //                     .map(
// //                       (p) => MatchingPairModel(
// //                         term: p.termController.text,
// //                         match: p.matchController.text,
// //                       ),
// //                     )
// //                     .toList(),
// //                 mcqOptions: branch.mcqOptions
// //                     .map(
// //                       (o) => McqOptionModel(
// //                         text: o.controller.text,
// //                         isCorrect: o.isCorrect,
// //                       ),
// //                     )
// //                     .toList(),
// //               );
// //               _groups[gi].sections[si].items.insert(bi + 1, copy);
// //             });
// //           },
// //         ),
// //         const Spacer(),
// //         Text(
// //           '${S.of(context).grade_label} ',
// //           style: TextStyle(
// //             color: AppColors.textSecondary(context),
// //             fontSize: 12,
// //           ),
// //         ),
// //         SizedBox(
// //           width: 40,
// //           child: TextField(
// //             textAlign: TextAlign.center,
// //             keyboardType: TextInputType.number,
// //             style: TextStyle(
// //               color: AppColors.primaryTeal(context),
// //               fontWeight: FontWeight.bold,
// //             ),
// //             decoration: const InputDecoration(
// //               border: InputBorder.none,
// //               isDense: true,
// //             ),
// //             controller:
// //                 TextEditingController(text: branch.grade.toStringAsFixed(0))
// //                   ..selection = TextSelection.collapsed(
// //                     offset: branch.grade.toStringAsFixed(0).length,
// //                   ),
// //             onChanged: (v) {
// //               _markAsUnsaved();
// //               setState(() => branch.grade = double.tryParse(v) ?? 0);
// //             },
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildFooterButtons(BuildContext context) => Row(
// //     children: [
// //       Expanded(
// //         child: ElevatedButton(
// //           onPressed: _isSaving
// //               ? null
// //               : () async {
// //                   bool success = await _saveExam(isDraft: false);
// //                   if (success && mounted) {
// //                     Navigator.pop(context, true);
// //                   }
// //                 },
// //           style: ElevatedButton.styleFrom(
// //             backgroundColor: AppColors.primaryTeal(context),
// //             padding: const EdgeInsets.symmetric(vertical: 18),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(15),
// //             ),
// //           ),
// //           child: _isSaving
// //               ? const SizedBox(
// //                   width: 22,
// //                   height: 22,
// //                   child: CircularProgressIndicator(
// //                     color: Colors.white,
// //                     strokeWidth: 2,
// //                   ),
// //                 )
// //               : Text(
// //                   S.of(context).save_and_approve,
// //                   style: const TextStyle(
// //                     color: Colors.white,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //         ),
// //       ),
// //       const SizedBox(width: 20),
// //       Expanded(
// //         child: OutlinedButton(
// //           onPressed: _isSaving
// //               ? null
// //               : () async {
// //                   bool success = await _saveExam(isDraft: true);
// //                   if (success && mounted) {
// //                     Navigator.pop(context, true);
// //                   }
// //                 },
// //           style: OutlinedButton.styleFrom(
// //             padding: const EdgeInsets.symmetric(vertical: 18),
// //             side: BorderSide(color: AppColors.primaryTeal(context)),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(15),
// //             ),
// //           ),
// //           child: Text(
// //             S.of(context).save_as_draft,
// //             style: TextStyle(color: AppColors.primaryTeal(context)),
// //           ),
// //         ),
// //       ),
// //     ],
// //   );

// //   void _showTimeLimitDialog() {
// //     showGeneralDialog(
// //       context: context,
// //       barrierDismissible: true,
// //       barrierLabel: '',
// //       barrierColor: Colors.black.withValues(alpha: 0.6),
// //       pageBuilder: (ctx, anim1, anim2) => BackdropFilter(
// //         filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
// //         child: Center(
// //           child: Material(
// //             color: Colors.transparent,
// //             child: Container(
// //               padding: const EdgeInsets.all(30),
// //               width: 420,
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(30),
// //               ),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   Align(
// //                     alignment: AlignmentDirectional.topStart,
// //                     child: IconButton(
// //                       icon: const Icon(Icons.close),
// //                       onPressed: () => Navigator.pop(ctx),
// //                     ),
// //                   ),
// //                   Text(
// //                     S.of(context).write_time_limit,
// //                     style: const TextStyle(
// //                       fontSize: 22,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 25),
// //                   SizedBox(
// //                     height: 150,
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         Expanded(
// //                           child: CupertinoPicker(
// //                             scrollController: FixedExtentScrollController(
// //                               initialItem: _selectedHours,
// //                             ),
// //                             itemExtent: 40,
// //                             onSelectedItemChanged: (int value) {
// //                               _selectedHours = value;
// //                             },
// //                             children: List.generate(
// //                               24,
// //                               (index) => Center(
// //                                 child: Text(
// //                                   '$index  ${S.of(context).hour_word}',
// //                                   style: TextStyle(
// //                                     fontSize: 18,
// //                                     color: AppColors.textPrimary(context),
// //                                     fontWeight: FontWeight.w500,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         const Text(
// //                           ':',
// //                           style: TextStyle(
// //                             fontSize: 24,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                         Expanded(
// //                           child: CupertinoPicker(
// //                             scrollController: FixedExtentScrollController(
// //                               initialItem: _selectedMinutes,
// //                             ),
// //                             itemExtent: 40,
// //                             onSelectedItemChanged: (int value) {
// //                               _selectedMinutes = value;
// //                             },
// //                             children: List.generate(
// //                               60,
// //                               (index) => Center(
// //                                 child: Text(
// //                                   '$index  ${S.of(context).minute_word}',
// //                                   style: TextStyle(
// //                                     fontSize: 18,
// //                                     color: AppColors.textPrimary(context),
// //                                     fontWeight: FontWeight.w500,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(height: 35),
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: ElevatedButton(
// //                           onPressed: () {
// //                             setState(() {
// //                               _totalDurationMinutes =
// //                                   (_selectedHours * 60) + _selectedMinutes;
// //                               String formattedTime = '';
// //                               if (_selectedHours > 0)
// //                                 formattedTime +=
// //                                     '$_selectedHours ${S.of(context).hour_word}';
// //                               if (_selectedMinutes > 0 || _selectedHours == 0) {
// //                                 if (formattedTime.isNotEmpty)
// //                                   formattedTime += ' ';
// //                                 formattedTime +=
// //                                     '$_selectedMinutes ${S.of(context).minute_word}';
// //                               }
// //                               _timeLimitController.text = formattedTime;
// //                               _markAsUnsaved();
// //                             });
// //                             Navigator.pop(ctx);
// //                           },
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: AppColors.primaryTeal(context),
// //                             padding: const EdgeInsets.symmetric(vertical: 18),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(15),
// //                             ),
// //                             elevation: 0,
// //                           ),
// //                           child: Text(
// //                             S.of(context).confirm,
// //                             style: const TextStyle(
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(width: 15),
// //                       Expanded(
// //                         child: ElevatedButton(
// //                           onPressed: () => Navigator.pop(ctx),
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: const Color(0xFFB35A5A),
// //                             padding: const EdgeInsets.symmetric(vertical: 18),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(15),
// //                             ),
// //                             elevation: 0,
// //                           ),
// //                           child: Text(
// //                             S.of(context).cancel,
// //                             style: const TextStyle(
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _dialogBtn(
// //     BuildContext ctx,
// //     String label,
// //     Color color,
// //   ) => ElevatedButton(
// //     onPressed: () => Navigator.pop(ctx),
// //     style: ElevatedButton.styleFrom(
// //       backgroundColor: color,
// //       padding: const EdgeInsets.symmetric(vertical: 18),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// //       elevation: 0,
// //     ),
// //     child: Text(
// //       label,
// //       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //     ),
// //   );
// // }

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';

// import '../core/colors.dart';
// import '../generated/l10n.dart';
// import 'teacher_dashboard.dart';
// import 'teacher_matearial.dart' hide HeaderWidget;
// import 'grading.dart' hide HeaderWidget;
// import 'exam_page.dart' hide HeaderWidget;
// import 'review_exam_screen.dart';
// import 'teacer_setting.dart';
// import 'ExamManagementPage.dart';
// // 🌟 تأكدي من مسار ملف البروفايدر حسب مجلداتك
// import '../provider/ExamProvider.dart';

// // ══════════════════════════════════════════════════════════════
// // الشاشة المغلفة (Wrapper) لضمان عمل الـ Provider تلقائياً
// // ══════════════════════════════════════════════════════════════
// class CreateElectronicExamPage extends StatelessWidget {
//   final ExamContext? examContext;
//   final int? examIdToEdit;
//   const CreateElectronicExamPage({
//     super.key,
//     this.examContext,
//     this.examIdToEdit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => ExamProvider(),
//       child: _CreateElectronicExamContent(
//         examContext: examContext,
//         examIdToEdit: examIdToEdit,
//       ),
//     );
//   }
// }

// // ══════════════════════════════════════════════════════════════
// // الواجهة النظيفة (Clean UI)
// // ══════════════════════════════════════════════════════════════
// class _CreateElectronicExamContent extends StatefulWidget {
//   final ExamContext? examContext;
//   final int? examIdToEdit;
//   const _CreateElectronicExamContent({this.examContext, this.examIdToEdit});

//   @override
//   State<_CreateElectronicExamContent> createState() =>
//       _CreateElectronicExamContentState();
// }

// class _CreateElectronicExamContentState
//     extends State<_CreateElectronicExamContent> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final int _selectedIndex = 1;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ExamProvider>().initData(
//         context,
//         widget.examContext,
//         widget.examIdToEdit,
//       );
//     });
//   }

//   Future<void> _handleNavigation(int index) async {
//     if (index == _selectedIndex) return;
//     final provider = context.read<ExamProvider>();

//     if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
//       Navigator.of(context).pop();
//       await Future.delayed(const Duration(milliseconds: 200));
//     }

//     if (!provider.isExamSaved) {
//       final action = await showDialog<String>(
//         context: context,
//         barrierDismissible: false,
//         builder: (ctx) => AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Text(
//             S.of(context).exit_warning_title,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: Text(S.of(context).exit_warning_content),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(ctx).pop('leave'),
//               child: Text(
//                 S.of(context).exit_without_saving,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.of(ctx).pop('save'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryTeal(context),
//               ),
//               child: Text(
//                 S.of(context).save_draft_and_exit,
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       );

//       if (action == null) return;

//       if (action == 'save') {
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           barrierColor: Colors.black.withValues(alpha: 0.1),
//           builder: (ctx) => Center(
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.1),
//                     blurRadius: 10,
//                   ),
//                 ],
//               ),
//               child: const CircularProgressIndicator(),
//             ),
//           ),
//         );

//         bool success = await provider.saveExam(context, isDraft: true);
//         if (mounted) Navigator.of(context).pop();
//         if (!success) return;
//         await Future.delayed(const Duration(seconds: 1));
//       } else if (action != 'leave') {
//         return;
//       }
//     }

//     Widget? target;
//     switch (index) {
//       case 0:
//         target = const DashboardScreen();
//         break;
//       case 1:
//         target = const ExamManagementPage();
//         break;
//       case 2:
//         target = const Material1();
//         break;
//       case 3:
//         target = const GradingPage();
//         break;
//       case 4:
//         target = const ReviewExamPage();
//         break;
//       case 5:
//         target = const SettingsScreen();
//         break;
//     }

//     if (target != null && mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => target!),
//       );
//     }
//   }

//   Future<bool> _onWillPop() async {
//     final provider = context.read<ExamProvider>();
//     if (provider.isExamSaved) return true;

//     final shouldPop = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Text(
//           S.of(context).exit_warning_title,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: Text(S.of(context).exit_warning_content),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(true),
//             child: Text(
//               S.of(context).exit_without_saving,
//               style: const TextStyle(color: Colors.red),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.of(ctx).pop(false);
//               bool success = await provider.saveExam(context, isDraft: true);
//               if (success && mounted) {
//                 Navigator.of(context).pop(true);
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryTeal(context),
//             ),
//             child: Text(
//               S.of(context).save_draft_and_exit,
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//     return shouldPop ?? false;
//   }

//   String _getNumberingString(int index, String style) {
//     if (style == 'none') return '';
//     if (style == 'letters_ar') {
//       const letters = [
//         'أ',
//         'ب',
//         'ج',
//         'د',
//         'هـ',
//         'و',
//         'ز',
//         'ح',
//         'ط',
//         'ي',
//         'ك',
//         'ل',
//         'م',
//         'ن',
//         'س',
//         'ع',
//         'ف',
//         'ص',
//         'ق',
//         'ر',
//         'ش',
//         'ت',
//         'ث',
//         'خ',
//         'ذ',
//         'ض',
//         'ظ',
//         'غ',
//       ];
//       return letters[index % letters.length];
//     }
//     if (style == 'letters_en') {
//       return String.fromCharCode(65 + (index % 26));
//     }
//     if (style == 'roman') {
//       const roman = [
//         'I',
//         'II',
//         'III',
//         'IV',
//         'V',
//         'VI',
//         'VII',
//         'VIII',
//         'IX',
//         'X',
//         'XI',
//         'XII',
//         'XIII',
//         'XIV',
//         'XV',
//         'XVI',
//         'XVII',
//         'XVIII',
//         'XIX',
//         'XX',
//       ];
//       if (index < roman.length) return roman[index];
//       return (index + 1).toString();
//     }
//     return (index + 1).toString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<ExamProvider>();

//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final isMobile = constraints.maxWidth < 1000;
//           return Scaffold(
//             key: _scaffoldKey,
//             backgroundColor: AppColors.secondaryTeal(context),
//             drawer: isMobile
//                 ? Drawer(
//                     width: 260,
//                     child: SafeArea(
//                       child: CustSidebar(
//                         selectedIndex: _selectedIndex,
//                         onItemSelected: _handleNavigation,
//                       ),
//                     ),
//                   )
//                 : null,
//             body: Stack(
//               children: [
//                 Row(
//                   children: [
//                     if (!isMobile)
//                       CustSidebar(
//                         selectedIndex: _selectedIndex,
//                         onItemSelected: _handleNavigation,
//                       ),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           if (isMobile) _buildMobileAppBar(),
//                           Expanded(
//                             child: SingleChildScrollView(
//                               padding: EdgeInsets.all(isMobile ? 16 : 32),
//                               child: Center(
//                                 child: Container(
//                                   constraints: const BoxConstraints(
//                                     maxWidth: 1000,
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       _buildBreadcrumbCard(),
//                                       const SizedBox(height: 24),
//                                       _buildExamInfoCard(context, provider),
//                                       const SizedBox(height: 24),
//                                       ...List.generate(
//                                         provider.groups.length,
//                                         (gi) => Padding(
//                                           padding: const EdgeInsets.only(
//                                             bottom: 24,
//                                           ),
//                                           child: _buildGroupCard(
//                                             context,
//                                             gi,
//                                             provider,
//                                           ),
//                                         ),
//                                       ),
//                                       _buildAddButton(
//                                         context,
//                                         label: S
//                                             .of(context)
//                                             .add_main_question_btn,
//                                         onTap: () => provider.addGroup(),
//                                       ),
//                                       const SizedBox(height: 40),
//                                       _buildFooterButtons(context, provider),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (provider.isSaving)
//                   Positioned.fill(
//                     child: Container(
//                       color: Colors.black.withOpacity(0.3),
//                       child: const Center(child: CircularProgressIndicator()),
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
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
//             const SizedBox(width: 8),
//             Text(
//               S.of(context).create_electronic_exam,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: AppColors.textPrimary(context),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBreadcrumbCard() {
//     bool isRtl = Directionality.of(context) == TextDirection.rtl;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8),
//         ],
//       ),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () async {
//               bool canNavigate = await _onWillPop();
//               if (canNavigate && mounted) Navigator.pop(context);
//             },
//             child: Text(
//               S.of(context).exam_management_title,
//               style: const TextStyle(
//                 color: Colors.grey,
//                 fontSize: 13,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Icon(
//               isRtl ? Icons.chevron_left : Icons.chevron_right,
//               color: Colors.grey,
//               size: 16,
//             ),
//           ),
//           Text(
//             S.of(context).create_electronic_exam,
//             style: TextStyle(
//               color: AppColors.primaryTeal(context),
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildExamInfoCard(BuildContext context, ExamProvider provider) {
//     final bool isMobile = MediaQuery.of(context).size.width < 800;
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.02),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 S.of(context).exam_info,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: AppColors.textPrimary(context),
//                 ),
//               ),
//               if (isMobile) _gradeBox(context, provider),
//             ],
//           ),
//           const SizedBox(height: 15),
//           isMobile
//               ? Column(
//                   children: [
//                     _infoTextField(
//                       context,
//                       provider,
//                       label: S.of(context).exam_title_label,
//                       icon: Icons.description_outlined,
//                       controller: provider.titleController,
//                       hint: " ",
//                     ),
//                     const SizedBox(height: 16),
//                     InkWell(
//                       onTap: () => _showTimeLimitDialog(provider),
//                       borderRadius: BorderRadius.circular(10),
//                       child: AbsorbPointer(
//                         child: _infoTextField(
//                           context,
//                           provider,
//                           label: S.of(context).time_limit_label,
//                           icon: Icons.timer_outlined,
//                           controller: provider.timeLimitController,
//                           hint: ' ',
//                           readOnly: true,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     InkWell(
//                       onTap: () => _selectDate(provider),
//                       borderRadius: BorderRadius.circular(10),
//                       child: AbsorbPointer(
//                         child: _infoTextField(
//                           context,
//                           provider,
//                           label: S.of(context).exam_date_label,
//                           icon: Icons.calendar_month_outlined,
//                           controller: provider.dateController,
//                           hint: ' ',
//                           readOnly: true,
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               : Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: _infoTextField(
//                         context,
//                         provider,
//                         label: S.of(context).exam_title_label,
//                         icon: Icons.description_outlined,
//                         controller: provider.titleController,
//                         hint: " ",
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       flex: 1,
//                       child: InkWell(
//                         onTap: () => _showTimeLimitDialog(provider),
//                         borderRadius: BorderRadius.circular(10),
//                         child: AbsorbPointer(
//                           child: _infoTextField(
//                             context,
//                             provider,
//                             label: S.of(context).time_limit_label,
//                             icon: Icons.timer_outlined,
//                             controller: provider.timeLimitController,
//                             hint: ' ',
//                             readOnly: true,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       flex: 1,
//                       child: InkWell(
//                         onTap: () => _selectDate(provider),
//                         borderRadius: BorderRadius.circular(10),
//                         child: AbsorbPointer(
//                           child: _infoTextField(
//                             context,
//                             provider,
//                             label: S.of(context).exam_date_label,
//                             icon: Icons.calendar_month_outlined,
//                             controller: provider.dateController,
//                             hint: ' ',
//                             readOnly: true,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     if (!isMobile) _gradeBox(context, provider),
//                   ],
//                 ),
//           const SizedBox(height: 16),
//           _buildContextualFields(context, provider),
//         ],
//       ),
//     );
//   }

//   Widget _buildContextualFields(BuildContext context, ExamProvider provider) {
//     final bool isMobile = MediaQuery.of(context).size.width < 800;
//     bool hasSpecialization =
//         provider.specializationController.text.trim().isNotEmpty &&
//         provider.specializationController.text.trim() != 'عام';

//     List<Widget> fields = [];
//     if (provider.isReadOnlyMode) {
//       final ctx = provider.examContext!;
//       fields.add(
//         _infoTextField(
//           context,
//           provider,
//           label: S.of(context).course_name_label,
//           icon: Icons.book_outlined,
//           hint: ctx.courseName ?? '',
//           readOnly: true,
//         ),
//       );
//       fields.add(
//         _infoTextField(
//           context,
//           provider,
//           label: S.of(context).folder_name_label,
//           icon: Icons.folder_outlined,
//           hint: ctx.folderName ?? '',
//           readOnly: true,
//         ),
//       );
//       fields.add(
//         _infoTextField(
//           context,
//           provider,
//           label: S.of(context).level_label,
//           icon: Icons.menu_book_outlined,
//           hint: ctx.levelName ?? '',
//           readOnly: true,
//         ),
//       );
//       if (hasSpecialization) {
//         fields.add(
//           _infoTextField(
//             context,
//             provider,
//             label: S.of(context).specialization_label,
//             icon: Icons.category_outlined,
//             hint: ctx.specialization ?? '',
//             readOnly: true,
//           ),
//         );
//       }
//     } else {
//       fields.add(
//         provider.isLoadingCourses
//             ? const Center(child: CircularProgressIndicator())
//             : _infoDropdown<CourseModel>(
//                 context,
//                 provider,
//                 label: S.of(context).course_name_label,
//                 icon: Icons.book_outlined,
//                 value: provider.selectedCourse,
//                 items: provider.myCourses,
//                 itemLabel: (e) => e.name,
//                 onChanged: (v) => provider.updateCourseSelection(v),
//               ),
//       );
//       fields.add(
//         provider.selectedCourse == null
//             ? _infoTextField(
//                 context,
//                 provider,
//                 label: S.of(context).folder_name_label,
//                 icon: Icons.folder_outlined,
//                 hint: ' ',
//                 readOnly: true,
//               )
//             : _infoDropdown<FolderModel>(
//                 context,
//                 provider,
//                 label: S.of(context).folder_name_label,
//                 icon: Icons.folder_outlined,
//                 value: provider.selectedFolder,
//                 items: provider.selectedCourse!.folders,
//                 itemLabel: (e) => e.name,
//                 onChanged: (v) {
//                   provider.markAsUnsaved();
//                   setState(() => provider.selectedFolder = v);
//                 },
//               ),
//       );
//       fields.add(
//         _infoTextField(
//           context,
//           provider,
//           label: S.of(context).level_label,
//           icon: Icons.menu_book_outlined,
//           controller: provider.levelController,
//           readOnly: true,
//         ),
//       );
//       if (hasSpecialization) {
//         fields.add(
//           _infoTextField(
//             context,
//             provider,
//             label: S.of(context).specialization_label,
//             icon: Icons.category_outlined,
//             controller: provider.specializationController,
//             readOnly: true,
//           ),
//         );
//       }
//     }

//     if (isMobile) {
//       return Column(
//         children: List.generate(
//           fields.length,
//           (i) => Padding(
//             padding: EdgeInsets.only(bottom: i == fields.length - 1 ? 0 : 16),
//             child: fields[i],
//           ),
//         ),
//       );
//     } else {
//       List<Widget> rowChildren = [];
//       for (int i = 0; i < fields.length; i++) {
//         rowChildren.add(Expanded(child: fields[i]));
//         if (i < fields.length - 1) rowChildren.add(const SizedBox(width: 12));
//       }
//       return Row(children: rowChildren);
//     }
//   }

//   Widget _infoTextField(
//     BuildContext context,
//     ExamProvider provider, {
//     required String label,
//     required IconData icon,
//     TextEditingController? controller,
//     String? hint,
//     bool readOnly = false,
//     VoidCallback? onTap,
//   }) {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         color: AppColors.scaffoldBg(context),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: AppColors.textSecondary(context).withValues(alpha: 0.2),
//         ),
//       ),
//       child: Row(
//         children: [
//           const SizedBox(width: 12),
//           Icon(icon, color: AppColors.primaryTeal(context), size: 20),
//           const SizedBox(width: 8),
//           Text(
//             label,
//             style: TextStyle(
//               color: AppColors.textSecondary(context),
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               readOnly: readOnly,
//               onTap: onTap,
//               onChanged: (_) => provider.markAsUnsaved(),
//               style: const TextStyle(fontSize: 14),
//               decoration: InputDecoration(
//                 hintText: hint ?? "",
//                 hintStyle: TextStyle(
//                   color: readOnly
//                       ? AppColors.textPrimary(context)
//                       : AppColors.textSecondary(context),
//                   fontSize: 13,
//                 ),
//                 border: InputBorder.none,
//                 isDense: true,
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 8,
//                   vertical: 10,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _infoDropdown<T>(
//     BuildContext context,
//     ExamProvider provider, {
//     required String label,
//     required IconData icon,
//     required T? value,
//     required List<T> items,
//     required String Function(T) itemLabel,
//     required ValueChanged<T?> onChanged,
//   }) {
//     return Container(
//       height: 48,
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: AppColors.scaffoldBg(context),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: AppColors.textSecondary(context).withValues(alpha: 0.2),
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: AppColors.primaryTeal(context), size: 20),
//           const SizedBox(width: 8),
//           Expanded(
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<T>(
//                 value: value,
//                 isExpanded: true,
//                 hint: Text(
//                   items.isEmpty ? '  ' : label,
//                   style: TextStyle(
//                     color: items.isEmpty
//                         ? Colors.red
//                         : AppColors.textSecondary(context),
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 icon: Icon(
//                   Icons.keyboard_arrow_down,
//                   color: AppColors.primaryTeal(context),
//                   size: 18,
//                 ),
//                 style: TextStyle(
//                   color: AppColors.textPrimary(context),
//                   fontSize: 13,
//                 ),
//                 items: items
//                     .map(
//                       (e) => DropdownMenuItem<T>(
//                         value: e,
//                         child: Text(
//                           itemLabel(e),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     )
//                     .toList(),
//                 onChanged: items.isEmpty ? null : onChanged,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _gradeBox(BuildContext context, ExamProvider provider) {
//     final bool isMobile = MediaQuery.of(context).size.width < 800;
//     return Column(
//       children: [
//         Text(
//           S.of(context).total_grade,
//           style: TextStyle(
//             fontSize: isMobile ? 8 : 11,
//             color: AppColors.textSecondary(context),
//           ),
//         ),
//         const SizedBox(height: 5),
//         Container(
//           width: isMobile ? 40 : 80,
//           height: isMobile ? 30 : 48,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: AppColors.primaryTeal(context).withValues(alpha: 0.1),
//             borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
//             border: Border.all(
//               color: AppColors.primaryTeal(context).withValues(alpha: 0.2),
//             ),
//           ),
//           child: Text(
//             provider.getTotalGrade().toStringAsFixed(0),
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: isMobile ? 16 : 20,
//               color: AppColors.primaryTeal(context),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildGroupCard(BuildContext context, int gi, ExamProvider provider) {
//     final group = provider.groups[gi];
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.02),
//             blurRadius: 10,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildGroupHeader(context, gi, group, provider),
//           const Divider(height: 1),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 ...List.generate(
//                   group.sections.length,
//                   (si) => Padding(
//                     padding: const EdgeInsets.only(bottom: 16),
//                     child: _buildSectionCard(context, gi, si, provider),
//                   ),
//                 ),
//                 _buildAddButton(
//                   context,
//                   label: S.of(context).add_section_btn,
//                   onTap: () {
//                     provider.markAsUnsaved();
//                     String currentStyle = group.sections.isNotEmpty
//                         ? group.sections.first.numberingStyle
//                         : 'letters_ar';
//                     setState(() {
//                       group.sections.add(
//                         QuestionSectionModel(numberingStyle: currentStyle),
//                       );
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGroupHeader(
//     BuildContext context,
//     int gi,
//     QuestionGroupModel group,
//     ExamProvider provider,
//   ) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: AppColors.primaryTeal(context).withValues(alpha: 0.07),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(18),
//           topRight: Radius.circular(18),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 32,
//             height: 32,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: AppColors.primaryTeal(context),
//               shape: BoxShape.circle,
//             ),
//             child: Text(
//               _getNumberingString(gi, group.numberingStyle),
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: TextField(
//               controller: group.titleController,
//               onChanged: (_) => provider.markAsUnsaved(),
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textPrimary(context),
//                 fontSize: 15,
//               ),
//               decoration: InputDecoration(
//                 hintText: S.of(context).main_question_hint,
//                 hintStyle: TextStyle(
//                   color: AppColors.textSecondary(context),
//                   fontSize: 14,
//                 ),
//                 border: InputBorder.none,
//                 isDense: true,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           _buildNumberingDropdown(
//             group.numberingStyle,
//             (val) => setState(() {
//               provider.markAsUnsaved();
//               for (var g in provider.groups) {
//                 g.numberingStyle = val!;
//               }
//             }),
//           ),
//           if (provider.groups.length > 1)
//             IconButton(
//               icon: const Icon(
//                 Icons.delete_outline,
//                 color: Colors.redAccent,
//                 size: 22,
//               ),
//               onPressed: () => provider.removeGroup(gi),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionCard(
//     BuildContext context,
//     int gi,
//     int si,
//     ExamProvider provider,
//   ) {
//     final section = provider.groups[gi].sections[si];
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.scaffoldBg(context),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader(context, gi, si, section, provider),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               children: [
//                 ...List.generate(
//                   section.items.length,
//                   (bi) => Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: _buildBranchCard(context, gi, si, bi, provider),
//                   ),
//                 ),
//                 _buildAddButton(
//                   context,
//                   label: S.of(context).add_branch_label,
//                   isLight: true,
//                   onTap: () {
//                     provider.markAsUnsaved();
//                     String currentStyle = section.items.isNotEmpty
//                         ? section.items.first.numberingStyle
//                         : 'numbers';
//                     setState(() {
//                       section.items.add(
//                         BranchModel(numberingStyle: currentStyle),
//                       );
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionHeader(
//     BuildContext context,
//     int gi,
//     int si,
//     QuestionSectionModel section,
//     ExamProvider provider,
//   ) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(13),
//           topRight: Radius.circular(13),
//         ),
//         border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
//       ),
//       child: Row(
//         children: [
//           if (section.numberingStyle != 'none') ...[
//             Text(
//               '${_getNumberingString(si, section.numberingStyle)} - ',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.primaryTeal(context),
//                 fontSize: 14,
//               ),
//             ),
//             const SizedBox(width: 4),
//           ],
//           Expanded(
//             child: TextField(
//               controller: section.titleController,
//               onChanged: (_) => provider.markAsUnsaved(),
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textPrimary(context),
//                 fontSize: 13,
//               ),
//               decoration: InputDecoration(
//                 hintText: S.of(context).section_title_hint,
//                 hintStyle: TextStyle(
//                   color: AppColors.textSecondary(context),
//                   fontSize: 12,
//                 ),
//                 border: InputBorder.none,
//                 isDense: true,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           _buildNumberingDropdown(
//             section.numberingStyle,
//             (val) => setState(() {
//               provider.markAsUnsaved();
//               for (var s in provider.groups[gi].sections) {
//                 s.numberingStyle = val!;
//               }
//             }),
//           ),
//           const SizedBox(width: 8),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
//             decoration: BoxDecoration(
//               color: AppColors.primaryTeal(context).withValues(alpha: 0.12),
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                 color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
//               ),
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: section.sectionType,
//                 isDense: true,
//                 icon: Icon(
//                   Icons.keyboard_arrow_down,
//                   color: AppColors.primaryTeal(context),
//                   size: 16,
//                 ),
//                 style: TextStyle(
//                   color: AppColors.primaryTeal(context),
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                 ),
//                 items: [
//                   _typeItem(
//                     context,
//                     'mcq',
//                     S.of(context).q_mcq,
//                     Icons.list_alt_rounded,
//                   ),
//                   _typeItem(
//                     context,
//                     'true_false',
//                     S.of(context).q_tf,
//                     Icons.check_circle_outline,
//                   ),
//                   _typeItem(
//                     context,
//                     'essay',
//                     S.of(context).q_essay,
//                     Icons.edit_note_rounded,
//                   ),
//                   _typeItem(
//                     context,
//                     'matching',
//                     S.of(context).q_matching,
//                     Icons.compare_arrows_rounded,
//                   ),
//                   _typeItem(
//                     context,
//                     'fill_blank',
//                     S.of(context).q_fill_blank,
//                     Icons.text_fields_rounded,
//                   ),
//                 ],
//                 onChanged: (val) {
//                   if (val != null) {
//                     provider.markAsUnsaved();
//                     setState(() {
//                       section.sectionType = val;
//                       for (final b in section.items) b.tfAnswer = null;
//                     });
//                   }
//                 },
//               ),
//             ),
//           ),
//           if (provider.groups[gi].sections.length > 1)
//             InkWell(
//               onTap: () {
//                 provider.markAsUnsaved();
//                 setState(() => provider.groups[gi].sections.removeAt(si));
//               },
//               child: const Padding(
//                 padding: EdgeInsetsDirectional.only(start: 8),
//                 child: Icon(Icons.close, color: Colors.grey, size: 18),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   DropdownMenuItem<String> _typeItem(
//     BuildContext context,
//     String value,
//     String label,
//     IconData icon,
//   ) => DropdownMenuItem(
//     value: value,
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 16, color: AppColors.primaryTeal(context)),
//         const SizedBox(width: 6),
//         Text(label, style: const TextStyle(fontSize: 13)),
//       ],
//     ),
//   );

//   Widget _buildNumberingDropdown(
//     String currentValue,
//     ValueChanged<String?> onChanged,
//   ) {
//     return Container(
//       height: 28,
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(
//           color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
//         ),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: currentValue,
//           icon: Icon(
//             Icons.arrow_drop_down,
//             size: 14,
//             color: AppColors.primaryTeal(context),
//           ),
//           style: TextStyle(
//             color: AppColors.primaryTeal(context),
//             fontSize: 12,
//             fontWeight: FontWeight.bold,
//           ),
//           items: [
//             DropdownMenuItem(
//               value: 'numbers',
//               child: Text(S.of(context).num_numbers),
//             ),
//             DropdownMenuItem(
//               value: 'letters_ar',
//               child: Text(S.of(context).num_letters_ar),
//             ),
//             DropdownMenuItem(
//               value: 'letters_en',
//               child: Text(S.of(context).num_letters_en),
//             ),
//             DropdownMenuItem(
//               value: 'roman',
//               child: Text(S.of(context).num_roman),
//             ),
//             DropdownMenuItem(
//               value: 'none',
//               child: Text(S.of(context).num_none),
//             ),
//           ],
//           onChanged: onChanged,
//         ),
//       ),
//     );
//   }

//   Widget _buildBranchCard(
//     BuildContext context,
//     int gi,
//     int si,
//     int bi,
//     ExamProvider provider,
//   ) {
//     final section = provider.groups[gi].sections[si];
//     final branch = section.items[bi];
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.scaffoldBg(context),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(
//                 '${S.of(context).branch_label} ${_getNumberingString(bi, branch.numberingStyle)}',
//                 style: TextStyle(
//                   color: AppColors.primaryTeal(context),
//                   fontWeight: FontWeight.bold,
//                   fontSize: 13,
//                 ),
//               ),
//               const Spacer(),
//               _buildNumberingDropdown(
//                 branch.numberingStyle,
//                 (val) => setState(() {
//                   provider.markAsUnsaved();
//                   for (var b in provider.groups[gi].sections[si].items) {
//                     b.numberingStyle = val!;
//                   }
//                 }),
//               ),
//               if (section.items.length > 1) ...[
//                 const SizedBox(width: 8),
//                 InkWell(
//                   onTap: () {
//                     provider.markAsUnsaved();
//                     setState(() => section.items.removeAt(bi));
//                   },
//                   child: const Icon(Icons.close, size: 18, color: Colors.grey),
//                 ),
//               ],
//             ],
//           ),
//           const SizedBox(height: 10),
//           _questionInput(context, branch, provider),
//           const SizedBox(height: 14),
//           _buildAnswerUI(
//             context,
//             gi,
//             si,
//             bi,
//             section.sectionType,
//             branch,
//             provider,
//           ),
//           const SizedBox(height: 10),
//           _buildBranchFooter(context, gi, si, bi, branch, provider),
//         ],
//       ),
//     );
//   }

//   Widget _questionInput(
//     BuildContext context,
//     BranchModel b,
//     ExamProvider provider,
//   ) => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//     decoration: BoxDecoration(
//       color: AppColors.secondaryTeal(context).withValues(alpha: 0.2),
//       borderRadius: BorderRadius.circular(15),
//     ),
//     child: TextField(
//       controller: b.questionController,
//       textAlign: TextAlign.center,
//       onChanged: (_) => provider.markAsUnsaved(),
//       decoration: InputDecoration(
//         hintText: S.of(context).write_question_hint,
//         border: InputBorder.none,
//       ),
//     ),
//   );

//   Widget _buildAnswerUI(
//     BuildContext context,
//     int gi,
//     int si,
//     int bi,
//     String sectionType,
//     BranchModel branch,
//     ExamProvider provider,
//   ) {
//     switch (sectionType) {
//       case 'mcq':
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _answerLabel(
//               context,
//               S.of(context).mcq_options_label,
//               Icons.radio_button_checked,
//             ),
//             const SizedBox(height: 8),
//             ...branch.mcqOptions.asMap().entries.map(
//               (e) => Padding(
//                 padding: const EdgeInsets.only(bottom: 8),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: e.value.isCorrect
//                         ? AppColors.primaryTeal(context).withValues(alpha: 0.08)
//                         : Colors.white,
//                     borderRadius: BorderRadius.circular(30),
//                     border: Border.all(
//                       color: e.value.isCorrect
//                           ? AppColors.primaryTeal(context)
//                           : Colors.grey.shade300,
//                       width: e.value.isCorrect ? 1.5 : 1,
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           provider.markAsUnsaved();
//                           setState(() {
//                             for (final o in branch.mcqOptions)
//                               o.isCorrect = false;
//                             e.value.isCorrect = true;
//                           });
//                         },
//                         child: Icon(
//                           e.value.isCorrect
//                               ? Icons.check_circle
//                               : Icons.circle_outlined,
//                           color: e.value.isCorrect
//                               ? AppColors.primaryTeal(context)
//                               : Colors.grey,
//                           size: 22,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: TextField(
//                           controller: e.value.controller,
//                           onChanged: (_) => provider.markAsUnsaved(),
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                             isDense: true,
//                           ),
//                         ),
//                       ),
//                       if (branch.mcqOptions.length > 2)
//                         IconButton(
//                           icon: const Icon(
//                             Icons.close,
//                             size: 16,
//                             color: Colors.grey,
//                           ),
//                           onPressed: () {
//                             provider.markAsUnsaved();
//                             setState(() => branch.mcqOptions.removeAt(e.key));
//                           },
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             TextButton.icon(
//               onPressed: () {
//                 provider.markAsUnsaved();
//                 setState(() => branch.mcqOptions.add(McqOptionModel()));
//               },
//               icon: Icon(
//                 Icons.add,
//                 color: AppColors.primaryTeal(context),
//                 size: 18,
//               ),
//               label: Text(
//                 '+ ${S.of(context).add_option}',
//                 style: TextStyle(
//                   color: AppColors.primaryTeal(context),
//                   fontWeight: FontWeight.bold,
//                   fontSize: 13,
//                 ),
//               ),
//             ),
//           ],
//         );

//       case 'true_false':
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _answerLabel(
//               context,
//               S.of(context).tf_select_label,
//               Icons.check_circle_outline,
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 Expanded(
//                   child: _tfToggleBtn(
//                     context,
//                     provider,
//                     label: S.of(context).true_word,
//                     selected: branch.tfAnswer == 'true',
//                     onTap: () => setState(() => branch.tfAnswer = 'true'),
//                     color: Colors.green,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _tfToggleBtn(
//                     context,
//                     provider,
//                     label: S.of(context).false_word,
//                     selected: branch.tfAnswer == 'false',
//                     onTap: () => setState(() => branch.tfAnswer = 'false'),
//                     color: Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );

//       case 'fill_blank':
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _answerLabel(
//               context,
//               S.of(context).fill_blank_hint_label,
//               Icons.text_fields_rounded,
//             ),
//             const SizedBox(height: 8),
//             _answerTextField(
//               context,
//               provider,
//               controller: branch.fillBlankAnswerController,
//               hint: S.of(context).fill_blank_answer_hint,
//               icon: Icons.short_text_rounded,
//             ),
//           ],
//         );

//       case 'matching':
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _answerLabel(
//               context,
//               S.of(context).matching_pairs_label,
//               Icons.compare_arrows_rounded,
//             ),
//             const SizedBox(height: 8),
//             ...branch.matchingPairs.asMap().entries.map(
//               (e) => Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 24,
//                       height: 24,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: AppColors.primaryTeal(
//                           context,
//                         ).withValues(alpha: 0.15),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Text(
//                         '${e.key + 1}',
//                         style: TextStyle(
//                           fontSize: 11,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.primaryTeal(context),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: _answerTextField(
//                         context,
//                         provider,
//                         controller: e.value.termController,
//                         hint: S.of(context).matching_term_hint,
//                         icon: Icons.looks_one_outlined,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8),
//                       child: Icon(
//                         Icons.arrow_forward,
//                         color: AppColors.primaryTeal(context),
//                         size: 20,
//                       ),
//                     ),
//                     Expanded(
//                       child: _answerTextField(
//                         context,
//                         provider,
//                         controller: e.value.matchController,
//                         hint: S.of(context).matching_match_hint,
//                         icon: Icons.looks_two_outlined,
//                       ),
//                     ),
//                     if (branch.matchingPairs.length > 1)
//                       IconButton(
//                         icon: const Icon(
//                           Icons.close,
//                           size: 16,
//                           color: Colors.grey,
//                         ),
//                         padding: EdgeInsets.zero,
//                         constraints: const BoxConstraints(
//                           minWidth: 32,
//                           minHeight: 32,
//                         ),
//                         onPressed: () {
//                           provider.markAsUnsaved();
//                           setState(() => branch.matchingPairs.removeAt(e.key));
//                         },
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//             TextButton.icon(
//               onPressed: () {
//                 provider.markAsUnsaved();
//                 setState(() => branch.matchingPairs.add(MatchingPairModel()));
//               },
//               icon: Icon(
//                 Icons.add,
//                 color: AppColors.primaryTeal(context),
//                 size: 18,
//               ),
//               label: Text(
//                 '+ ${S.of(context).add_matching_pair}',
//                 style: TextStyle(
//                   color: AppColors.primaryTeal(context),
//                   fontWeight: FontWeight.bold,
//                   fontSize: 13,
//                 ),
//               ),
//             ),
//           ],
//         );

//       case 'essay':
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _answerLabel(
//               context,
//               S.of(context).essay_answer_label,
//               Icons.edit_note_rounded,
//             ),
//             const SizedBox(height: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.grey.shade200),
//               ),
//               child: TextField(
//                 controller: branch.essayModelAnswerController,
//                 onChanged: (_) => provider.markAsUnsaved(),
//                 maxLines: 3,
//                 decoration: InputDecoration(
//                   hintText: S.of(context).essay_model_answer_hint,
//                   hintStyle: TextStyle(
//                     color: AppColors.textSecondary(context),
//                     fontSize: 13,
//                   ),
//                   border: InputBorder.none,
//                   isDense: true,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             _answerTextField(
//               context,
//               provider,
//               controller: branch.essayKeywordsController,
//               hint: S.of(context).essay_keywords_hint,
//               icon: Icons.label_outline,
//             ),
//           ],
//         );

//       default:
//         return const SizedBox();
//     }
//   }

//   Widget _tfToggleBtn(
//     BuildContext context,
//     ExamProvider provider, {
//     required String label,
//     required bool selected,
//     required VoidCallback onTap,
//     required Color color,
//   }) {
//     return GestureDetector(
//       onTap: () {
//         provider.markAsUnsaved();
//         onTap();
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(vertical: 14),
//         decoration: BoxDecoration(
//           color: selected ? color.withValues(alpha: 0.15) : Colors.white,
//           borderRadius: BorderRadius.circular(30),
//           border: Border.all(
//             color: selected ? color : Colors.grey.shade300,
//             width: selected ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               selected ? Icons.check_circle : Icons.circle_outlined,
//               color: selected ? color : Colors.grey,
//               size: 18,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 color: selected ? color : AppColors.textSecondary(context),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _answerLabel(BuildContext context, String text, IconData icon) => Row(
//     children: [
//       Icon(icon, size: 16, color: AppColors.primaryTeal(context)),
//       const SizedBox(width: 6),
//       Flexible(
//         child: Text(
//           text,
//           style: TextStyle(
//             color: AppColors.primaryTeal(context),
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     ],
//   );

//   Widget _answerTextField(
//     BuildContext context,
//     ExamProvider provider, {
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: AppColors.primaryTeal(context)),
//           const SizedBox(width: 8),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               style: const TextStyle(fontSize: 13),
//               onChanged: (_) => provider.markAsUnsaved(),
//               decoration: InputDecoration(
//                 hintText: hint,
//                 hintStyle: const TextStyle(fontSize: 12),
//                 border: InputBorder.none,
//                 isDense: true,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBranchFooter(
//     BuildContext context,
//     int gi,
//     int si,
//     int bi,
//     BranchModel branch,
//     ExamProvider provider,
//   ) {
//     return Row(
//       children: [
//         IconButton(
//           icon: const Icon(Icons.copy_all, color: Colors.grey, size: 18),
//           tooltip: S.of(context).copy_branch_tooltip,
//           onPressed: () {
//             provider.markAsUnsaved();
//             setState(() {
//               final copy = BranchModel(
//                 questionText: branch.questionController.text,
//                 grade: branch.grade,
//                 tfAnswer: branch.tfAnswer,
//                 fillBlankAnswer: branch.fillBlankAnswerController.text,
//                 essayModelAnswer: branch.essayModelAnswerController.text,
//                 essayKeywords: branch.essayKeywordsController.text,
//                 matchingPairs: branch.matchingPairs
//                     .map(
//                       (p) => MatchingPairModel(
//                         term: p.termController.text,
//                         match: p.matchController.text,
//                       ),
//                     )
//                     .toList(),
//                 mcqOptions: branch.mcqOptions
//                     .map(
//                       (o) => McqOptionModel(
//                         text: o.controller.text,
//                         isCorrect: o.isCorrect,
//                       ),
//                     )
//                     .toList(),
//               );
//               provider.groups[gi].sections[si].items.insert(bi + 1, copy);
//             });
//           },
//         ),
//         const Spacer(),
//         Text(
//           '${S.of(context).grade_label} ',
//           style: TextStyle(
//             color: AppColors.textSecondary(context),
//             fontSize: 12,
//           ),
//         ),
//         SizedBox(
//           width: 40,
//           child: TextField(
//             textAlign: TextAlign.center,
//             keyboardType: TextInputType.number,
//             style: TextStyle(
//               color: AppColors.primaryTeal(context),
//               fontWeight: FontWeight.bold,
//             ),
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//               isDense: true,
//             ),
//             controller:
//                 TextEditingController(text: branch.grade.toStringAsFixed(0))
//                   ..selection = TextSelection.collapsed(
//                     offset: branch.grade.toStringAsFixed(0).length,
//                   ),
//             onChanged: (v) {
//               provider.markAsUnsaved();
//               setState(() => branch.grade = double.tryParse(v) ?? 0);
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAddButton(
//     BuildContext context, {
//     required String label,
//     required VoidCallback onTap,
//     bool isLight = false,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(10),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         decoration: BoxDecoration(
//           color: isLight
//               ? AppColors.primaryTeal(context).withValues(alpha: 0.03)
//               : Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.add, color: AppColors.primaryTeal(context), size: 18),
//             const SizedBox(width: 6),
//             Text(
//               label,
//               style: TextStyle(
//                 color: AppColors.primaryTeal(context),
//                 fontWeight: FontWeight.bold,
//                 fontSize: 13,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFooterButtons(BuildContext context, ExamProvider provider) =>
//       Row(
//         children: [
//           Expanded(
//             child: ElevatedButton(
//               onPressed: provider.isSaving
//                   ? null
//                   : () async {
//                       bool success = await provider.saveExam(
//                         context,
//                         isDraft: false,
//                       );
//                       if (success && mounted) Navigator.pop(context, true);
//                     },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryTeal(context),
//                 padding: const EdgeInsets.symmetric(vertical: 18),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//               ),
//               child: provider.isSaving
//                   ? const SizedBox(
//                       width: 22,
//                       height: 22,
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                         strokeWidth: 2,
//                       ),
//                     )
//                   : Text(
//                       S.of(context).save_and_approve,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//             ),
//           ),
//           const SizedBox(width: 20),
//           Expanded(
//             child: OutlinedButton(
//               onPressed: provider.isSaving
//                   ? null
//                   : () async {
//                       bool success = await provider.saveExam(
//                         context,
//                         isDraft: true,
//                       );
//                       if (success && mounted) Navigator.pop(context, true);
//                     },
//               style: OutlinedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 18),
//                 side: BorderSide(color: AppColors.primaryTeal(context)),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//               ),
//               child: Text(
//                 S.of(context).save_as_draft,
//                 style: TextStyle(color: AppColors.primaryTeal(context)),
//               ),
//             ),
//           ),
//         ],
//       );

//   Future<void> _selectDate(ExamProvider provider) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2030),
//       builder: (ctx, child) => Theme(
//         data: Theme.of(ctx).copyWith(
//           colorScheme: ColorScheme.light(
//             primary: AppColors.primaryTeal(context),
//           ),
//         ),
//         child: child!,
//       ),
//     );
//     if (picked != null) {
//       provider.dateController.text =
//           '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
//       provider.markAsUnsaved();
//     }
//   }

//   void _showTimeLimitDialog(ExamProvider provider) {
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: '',
//       barrierColor: Colors.black.withValues(alpha: 0.6),
//       pageBuilder: (ctx, anim1, anim2) => BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//         child: Center(
//           child: Material(
//             color: Colors.transparent,
//             child: Container(
//               padding: const EdgeInsets.all(30),
//               width: 420,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Align(
//                     alignment: AlignmentDirectional.topStart,
//                     child: IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () => Navigator.pop(ctx),
//                     ),
//                   ),
//                   Text(
//                     S.of(context).write_time_limit,
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 25),
//                   SizedBox(
//                     height: 150,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: CupertinoPicker(
//                             scrollController: FixedExtentScrollController(
//                               initialItem: provider.selectedHours,
//                             ),
//                             itemExtent: 40,
//                             onSelectedItemChanged: (int value) =>
//                                 provider.selectedHours = value,
//                             children: List.generate(
//                               24,
//                               (index) => Center(
//                                 child: Text(
//                                   '$index  ${S.of(context).hour_word}',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     color: AppColors.textPrimary(context),
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const Text(
//                           ':',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Expanded(
//                           child: CupertinoPicker(
//                             scrollController: FixedExtentScrollController(
//                               initialItem: provider.selectedMinutes,
//                             ),
//                             itemExtent: 40,
//                             onSelectedItemChanged: (int value) =>
//                                 provider.selectedMinutes = value,
//                             children: List.generate(
//                               60,
//                               (index) => Center(
//                                 child: Text(
//                                   '$index  ${S.of(context).minute_word}',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     color: AppColors.textPrimary(context),
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 35),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               provider.totalDurationMinutes =
//                                   (provider.selectedHours * 60) +
//                                   provider.selectedMinutes;
//                               String formattedTime = '';
//                               if (provider.selectedHours > 0)
//                                 formattedTime +=
//                                     '${provider.selectedHours} ${S.of(context).hour_word}';
//                               if (provider.selectedMinutes > 0 ||
//                                   provider.selectedHours == 0) {
//                                 if (formattedTime.isNotEmpty)
//                                   formattedTime += ' ';
//                                 formattedTime +=
//                                     '${provider.selectedMinutes} ${S.of(context).minute_word}';
//                               }
//                               provider.timeLimitController.text = formattedTime;
//                               provider.markAsUnsaved();
//                             });
//                             Navigator.pop(ctx);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.primaryTeal(context),
//                             padding: const EdgeInsets.symmetric(vertical: 18),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             elevation: 0,
//                           ),
//                           child: Text(
//                             S.of(context).confirm,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 15),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () => Navigator.pop(ctx),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFFB35A5A),
//                             padding: const EdgeInsets.symmetric(vertical: 18),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             elevation: 0,
//                           ),
//                           child: Text(
//                             S.of(context).cancel,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '../core/colors.dart';
// import '../generated/l10n.dart';
// import 'teacher_dashboard.dart';
// import 'teacher_matearial.dart' hide HeaderWidget;
// import 'grading.dart' hide HeaderWidget;
// import 'exam_page.dart' hide HeaderWidget;
// import 'review_exam_screen.dart';
// import 'teacer_setting.dart';
// import 'ExamManagementPage.dart';
// import 'package:flutter/cupertino.dart';

// // ══════════════════════════════════════════════════════════════
// // نماذج البيانات (Data Models)
// // ══════════════════════════════════════════════════════════════

// class McqOptionModel {
//   TextEditingController controller;
//   bool isCorrect;
//   McqOptionModel({String text = '', this.isCorrect = false})
//     : controller = TextEditingController(text: text);
// }

// class MatchingPairModel {
//   TextEditingController termController;
//   TextEditingController matchController;
//   MatchingPairModel({String term = '', String match = ''})
//     : termController = TextEditingController(text: term),
//       matchController = TextEditingController(text: match);
// }

// class BranchModel {
//   TextEditingController questionController;
//   double grade;
//   List<McqOptionModel> mcqOptions;
//   String? tfAnswer;
//   TextEditingController fillBlankAnswerController;
//   List<MatchingPairModel> matchingPairs;
//   TextEditingController essayModelAnswerController;
//   TextEditingController essayKeywordsController;
//   String numberingStyle;

//   BranchModel({
//     this.numberingStyle = 'numbers',
//     String questionText = '',
//     this.grade = 5,
//     List<McqOptionModel>? mcqOptions,
//     this.tfAnswer,
//     String fillBlankAnswer = '',
//     List<MatchingPairModel>? matchingPairs,
//     String essayModelAnswer = '',
//     String essayKeywords = '',
//   }) : questionController = TextEditingController(text: questionText),
//        fillBlankAnswerController = TextEditingController(text: fillBlankAnswer),
//        essayModelAnswerController = TextEditingController(
//          text: essayModelAnswer,
//        ),
//        essayKeywordsController = TextEditingController(text: essayKeywords),
//        mcqOptions = mcqOptions ?? [McqOptionModel(), McqOptionModel()],
//        matchingPairs = matchingPairs ?? [MatchingPairModel()];
// }

// class QuestionSectionModel {
//   String sectionType;
//   TextEditingController titleController;
//   List<BranchModel> items;
//   String numberingStyle;

//   QuestionSectionModel({
//     this.numberingStyle = 'letters_ar',
//     this.sectionType = 'mcq',
//     String title = '',
//     List<BranchModel>? items,
//   }) : titleController = TextEditingController(text: title),
//        items = items ?? [BranchModel()];
// }

// class QuestionGroupModel {
//   TextEditingController titleController;
//   List<QuestionSectionModel> sections;
//   String numberingStyle;

//   QuestionGroupModel({
//     this.numberingStyle = 'numbers',
//     String title = '',
//     List<QuestionSectionModel>? sections,
//   }) : titleController = TextEditingController(text: title),
//        sections = sections ?? [QuestionSectionModel()];
// }

// class ExamContext {
//   final int? courseId;
//   final String? courseName;
//   final String? specialization;
//   final String? levelName;
//   final int? folderId;
//   final String? folderName;

//   const ExamContext({
//     this.courseId,
//     this.courseName,
//     this.specialization,
//     this.levelName,
//     this.folderId,
//     this.folderName,
//   });

//   bool get isComplete =>
//       courseId != null &&
//       courseName != null &&
//       folderId != null &&
//       folderName != null;
// }

// class FolderModel {
//   final int id;
//   final String name;
//   FolderModel({required this.id, required this.name});
// }

// class CourseModel {
//   final int id;
//   final String name;
//   final String specialization;
//   final String level;
//   final List<FolderModel> folders;

//   const CourseModel({
//     required this.id,
//     required this.name,
//     required this.specialization,
//     required this.level,
//     required this.folders,
//   });
// }

// // ══════════════════════════════════════════════════════════════
// // الصفحة الرئيسية
// // ══════════════════════════════════════════════════════════════

// class CreateElectronicExamPage extends StatefulWidget {
//   final ExamContext? examContext;
//   final int? examIdToEdit;
//   const CreateElectronicExamPage({
//     super.key,
//     this.examContext,
//     this.examIdToEdit,
//   });

//   @override
//   State<CreateElectronicExamPage> createState() =>
//       _CreateElectronicExamPageState();
// }

// class _CreateElectronicExamPageState extends State<CreateElectronicExamPage> {
//   int? _currentExamId;
//   bool _isExamSaved = true;

//   void _markAsUnsaved() {
//     if (_isExamSaved) {
//       setState(() => _isExamSaved = false);
//     }
//   }

//   final int _selectedIndex = 1;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();
//   final TextEditingController _timeLimitController = TextEditingController();

//   final TextEditingController _specializationController =
//       TextEditingController();
//   final TextEditingController _levelController = TextEditingController();
//   final TextEditingController _folderController = TextEditingController();

//   List<QuestionGroupModel> _groups = [];
//   bool _isSaving = false;

//   bool _isLoadingCourses = true;
//   List<CourseModel> _myCourses = [];
//   CourseModel? _selectedCourse;
//   FolderModel? _selectedFolder;
//   int _selectedHours = 1;
//   int _selectedMinutes = 0;
//   int? _totalDurationMinutes;
//   bool get _isReadOnlyMode =>
//       widget.examContext != null && widget.examContext!.isComplete;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.examIdToEdit != null) {
//       _currentExamId = widget.examIdToEdit;
//     }

//     if (widget.examContext != null && widget.examContext!.isComplete) {
//       _isLoadingCourses = false;
//       _specializationController.text = widget.examContext!.specialization ?? '';
//       _levelController.text = widget.examContext!.levelName ?? '';
//       _folderController.text = widget.examContext!.folderName ?? '';

//       if (_currentExamId != null) {
//         _loadExamDetails(_currentExamId!);
//       }
//     } else {
//       _fetchCoursesFromDatabase().then((_) {
//         if (_currentExamId != null) {
//           _loadExamDetails(_currentExamId!);
//         }
//       });
//     }
//   }

//   Future<void> _loadExamDetails(int examId) async {
//     setState(() => _isSaving = true);
//     try {
//       final response = await http.get(
//         Uri.parse('http://localhost:8000/api/exams/get-full-exam/$examId'),
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(utf8.decode(response.bodyBytes));

//         setState(() {
//           _titleController.text = data['exam_title'] ?? '';
//           _dateController.text = data['exam_date'] ?? '';
//           String? rawTime = data['time_limit']?.toString();

//           if (rawTime != null && rawTime.isNotEmpty && rawTime != '0') {
//             _totalDurationMinutes = int.tryParse(
//               rawTime.replaceAll(RegExp(r'[^0-9]'), ''),
//             );

//             if (_totalDurationMinutes != null) {
//               int h = _totalDurationMinutes! ~/ 60;
//               int m = _totalDurationMinutes! % 60;

//               String formatted = '';
//               if (h > 0) formatted += '$h ${S.of(context).hour_word}';
//               if (m > 0 || h == 0) {
//                 if (formatted.isNotEmpty) formatted += ' ';
//                 formatted += '$m ${S.of(context).minute_word}';
//               }
//               _timeLimitController.text = formatted;
//             }
//           } else {
//             _totalDurationMinutes = null;
//             _timeLimitController.text = '';
//           }

//           if (!_isReadOnlyMode) {
//             int loadedFolderId = data['folder_id'];
//             for (var c in _myCourses) {
//               for (var f in c.folders) {
//                 if (f.id == loadedFolderId) {
//                   _selectedCourse = c;
//                   _selectedFolder = f;
//                   _specializationController.text = c.specialization;
//                   _levelController.text = c.level;
//                   break;
//                 }
//               }
//             }
//           }

//           if (data['question_groups'] != null) {
//             _groups.clear();
//             for (var g in data['question_groups']) {
//               var newGroup = QuestionGroupModel(
//                 title: g['group_title'] ?? '',
//                 numberingStyle: g['group_numbering_style'] ?? 'numbers',
//                 sections: [],
//               );

//               for (var s in g['sections']) {
//                 var newSection = QuestionSectionModel(
//                   title: s['section_title'] ?? '',
//                   sectionType: s['section_type'] ?? 'mcq',
//                   numberingStyle: s['section_numbering_style'] ?? 'letters_ar',
//                   items: [],
//                 );

//                 for (var b in s['items']) {
//                   var newBranch = BranchModel(
//                     questionText: b['question_text'] ?? '',
//                     grade: (b['question_mark'] ?? 0).toDouble(),
//                     numberingStyle: b['question_numbering_style'] ?? 'numbers',
//                   );

//                   if (newSection.sectionType == 'mcq' &&
//                       b['mcq_options'] != null) {
//                     newBranch.mcqOptions.clear();
//                     for (var opt in b['mcq_options']) {
//                       newBranch.mcqOptions.add(
//                         McqOptionModel(
//                           text: opt['option_text'] ?? '',
//                           isCorrect: opt['is_correct'] ?? false,
//                         ),
//                       );
//                     }
//                   } else if (newSection.sectionType == 'true_false' &&
//                       b['true_false_answer'] != null) {
//                     newBranch.tfAnswer =
//                         b['true_false_answer']['correct_answer'];
//                   } else if (newSection.sectionType == 'fill_blank' &&
//                       b['fill_blank_answer'] != null) {
//                     newBranch.fillBlankAnswerController.text =
//                         b['fill_blank_answer']['correct_word'] ?? '';
//                   } else if (newSection.sectionType == 'matching' &&
//                       b['matching_pairs'] != null) {
//                     newBranch.matchingPairs.clear();
//                     for (var pair in b['matching_pairs']) {
//                       newBranch.matchingPairs.add(
//                         MatchingPairModel(
//                           term: pair['term'] ?? '',
//                           match: pair['match'] ?? '',
//                         ),
//                       );
//                     }
//                   } else if (newSection.sectionType == 'essay' &&
//                       b['essay_answer'] != null) {
//                     newBranch.essayModelAnswerController.text =
//                         b['essay_answer']['model_answer'] ?? '';
//                     newBranch.essayKeywordsController.text =
//                         b['essay_answer']['keywords'] ?? '';
//                   }
//                   newSection.items.add(newBranch);
//                 }
//                 newGroup.sections.add(newSection);
//               }
//               _groups.add(newGroup);
//             }
//           }
//           _isExamSaved = true;
//         });
//       }
//     } catch (e) {
//       _showSnackbar('${S.of(context).error_prefix} $e', isError: true);
//     } finally {
//       setState(() => _isSaving = false);
//     }
//   }

//   Future<void> _fetchCoursesFromDatabase() async {
//     try {
//       final response = await http.get(
//         Uri.parse('http://localhost:8000/api/exams/teacher/1/courses-dropdown'),
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);

//         setState(() {
//           _myCourses = data.map((json) {
//             final foldersList = (json['folders'] as List<dynamic>?) ?? [];
//             return CourseModel(
//               id: json['id'] ?? 0,
//               name: json['name'] ?? S.of(context).untitled_exam,
//               specialization: json['specialization'] ?? '',
//               level: json['level'] ?? '',
//               folders: foldersList
//                   .map((f) => FolderModel(id: f['id'], name: f['name']))
//                   .toList(),
//             );
//           }).toList();
//           _isLoadingCourses = false;
//         });

//         if (_myCourses.isEmpty) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             _showNoCourseDialog();
//           });
//         }
//       } else {
//         setState(() => _isLoadingCourses = false);
//         _showSnackbar(S.of(context).connection_error, isError: true);
//       }
//     } catch (e) {
//       setState(() => _isLoadingCourses = false);
//       _showSnackbar('${S.of(context).connection_error} $e', isError: true);
//     }
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (_groups.isEmpty) {
//       _groups = [QuestionGroupModel()];
//     }
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _dateController.dispose();
//     _timeLimitController.dispose();
//     _specializationController.dispose();
//     _levelController.dispose();
//     _folderController.dispose();
//     super.dispose();
//   }

//   double _getTotalGrade() {
//     double total = 0;
//     for (final g in _groups) {
//       for (final s in g.sections) {
//         for (final b in s.items) {
//           total += b.grade;
//         }
//       }
//     }
//     return total;
//   }

//   int get _effectiveFolderId {
//     // 1. في حالة التعديل (القراءة من سياق مسبق)
//     if (_isReadOnlyMode) {
//       return widget.examContext!.folderId ?? 1;
//     }

//     // 2. إذا المعلم اختار المادة والمجلد معاً
//     if (_selectedFolder != null) {
//       return _selectedFolder!.id;
//     }

//     // 3. اللوجيك الجديد: إذا اختار المادة، بس نسى يختار المجلد
//     // ➔ نحفظه في أول مجلد داخل هذي المادة اللي اختارها
//     if (_selectedCourse != null && _selectedCourse!.folders.isNotEmpty) {
//       return _selectedCourse!.folders.first.id;
//     }

//     // 4. اللوجيك الجديد: إذا ما اختار لا مادة ولا مجلد
//     // ➔ نحفظه في أول مجلد تابع لأول مادة موجودة في حسابه
//     if (_myCourses.isNotEmpty && _myCourses.first.folders.isNotEmpty) {
//       return _myCourses.first.folders.first.id;
//     }

//     // خط دفاع أخير عشان ما يضرب الفلاتر
//     return 1;
//   }

//   Future<void> _handleNavigation(int index) async {
//     if (index == _selectedIndex) return;

//     // 🌟 1. إغلاق القائمة الجانبية (Drawer) فوراً لفك أي تجميد في الشاشة
//     if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
//       Navigator.of(context).pop();
//       await Future.delayed(const Duration(milliseconds: 200));
//     }

//     // 🌟 2. إذا كان فيه تعديلات لم تُحفظ
//     if (!_isExamSaved) {
//       final action = await showDialog<String>(
//         context: context,
//         barrierDismissible: false, // نمنع الإغلاق بالضغط خارج النافذة
//         builder: (ctx) => AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Text(
//             S.of(context).exit_warning_title,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: Text(S.of(context).exit_warning_content),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(ctx).pop('leave'),
//               child: Text(
//                 S.of(context).exit_without_saving,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.of(ctx).pop('save'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryTeal(context),
//               ),
//               child: Text(
//                 S.of(context).save_draft_and_exit,
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       );

//       if (action == null) return;

//       if (action == 'save') {
//         // 🌟 3. إظهار دائرة تحميل (Dialog) إجبارية وواضحة للمستخدم
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           barrierColor: Colors.black.withValues(alpha: 0.1), // خلفية شفافة جداً
//           builder: (ctx) => const Center(child: CircularProgressIndicator()),
//         );

//         // حفظ الاختبار في الباك إند
//         bool success = await _saveExam(isDraft: true);

//         // 🌟 4. السطر السحري لحل مشكلة التعليق: إغلاق دائرة التحميل بالقوة
//         if (mounted) Navigator.of(context).pop();

//         if (!success) return; // إذا فشل الحفظ بسبب النت، وقّف الانتقال

//         // إظهار رسالة النجاح والانتظار ثانية واحدة ليقرأها المستخدم براحته قبل لا تطير الشاشة
//         await Future.delayed(const Duration(seconds: 1));
//       } else if (action != 'leave') {
//         return;
//       }
//     }

//     // 🌟 5. الانتقال للصفحة الجديدة بأمان تام ونظافة
//     Widget? target;
//     switch (index) {
//       case 0:
//         target = const DashboardScreen();
//         break;
//       case 1:
//         target = const ExamManagementPage();
//         break;
//       case 2:
//         target = const Material1();
//         break;
//       case 3:
//         target = const GradingPage();
//         break;
//       case 4:
//         target = const ReviewExamPage();
//         break;
//       case 5:
//         target = const SettingsScreen();
//         break;
//     }

//     if (target != null && mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => target!),
//       );
//     }
//   }

//   Future<void> _selectDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2030),
//       builder: (ctx, child) => Theme(
//         data: Theme.of(ctx).copyWith(
//           colorScheme: ColorScheme.light(
//             primary: AppColors.primaryTeal(context),
//           ),
//         ),
//         child: child!,
//       ),
//     );
//     if (picked != null) {
//       setState(
//         () => _dateController.text =
//             '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}',
//       );
//       _markAsUnsaved();
//     }
//   }

//   String _getNumberingString(int index, String style) {
//     if (style == 'none') return '';
//     if (style == 'letters_ar') {
//       const letters = [
//         'أ',
//         'ب',
//         'ج',
//         'د',
//         'هـ',
//         'و',
//         'ز',
//         'ح',
//         'ط',
//         'ي',
//         'ك',
//         'ل',
//         'م',
//         'ن',
//         'س',
//         'ع',
//         'ف',
//         'ص',
//         'ق',
//         'ر',
//         'ش',
//         'ت',
//         'ث',
//         'خ',
//         'ذ',
//         'ض',
//         'ظ',
//         'غ',
//       ];
//       return letters[index % letters.length];
//     }
//     if (style == 'letters_en') {
//       return String.fromCharCode(65 + (index % 26));
//     }
//     if (style == 'roman') {
//       const roman = [
//         'I',
//         'II',
//         'III',
//         'IV',
//         'V',
//         'VI',
//         'VII',
//         'VIII',
//         'IX',
//         'X',
//         'XI',
//         'XII',
//         'XIII',
//         'XIV',
//         'XV',
//         'XVI',
//         'XVII',
//         'XVIII',
//         'XIX',
//         'XX',
//       ];
//       if (index < roman.length) return roman[index];
//       return (index + 1).toString();
//     }
//     return (index + 1).toString();
//   }

//   void _showNoCourseDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: [
//             Icon(
//               Icons.warning_amber_rounded,
//               color: AppColors.primaryTeal(context),
//               size: 28,
//             ),
//             const SizedBox(width: 10),
//             Text(
//               S.of(context).no_course_dialog_title,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textPrimary(context),
//               ),
//             ),
//           ],
//         ),
//         content: Text(
//           S.of(context).no_course_dialog_body,
//           style: TextStyle(
//             color: AppColors.textSecondary(context),
//             height: 1.6,
//           ),
//         ),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(ctx);
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryTeal(context),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: Text(
//               S.of(context).go_back,
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String? _getValidationError() {
//     if (_titleController.text.trim().isEmpty)
//       return S.of(context).err_exam_title;
//     if (_dateController.text.trim().isEmpty) return S.of(context).err_exam_date;
//     if (!_isReadOnlyMode && _selectedCourse == null)
//       return S.of(context).err_exam_course;
//     if (!_isReadOnlyMode && _selectedFolder == null)
//       return S.of(context).err_exam_folder;
//     if (_totalDurationMinutes == null || _totalDurationMinutes == 0)
//       return S.of(context).err_empty_time_limit;

//     bool hasQuestions = false;
//     for (var group in _groups) {
//       for (var section in group.sections) {
//         for (var branch in section.items) {
//           hasQuestions = true;
//           if (branch.questionController.text.trim().isEmpty)
//             return S.of(context).err_empty_question;
//           if (branch.grade <= 0) return S.of(context).err_zero_grade;

//           switch (section.sectionType) {
//             case 'mcq':
//               if (branch.mcqOptions.every((o) => !o.isCorrect))
//                 return S.of(context).err_no_correct_mcq;
//               break;
//             case 'true_false':
//               if (branch.tfAnswer == null)
//                 return S.of(context).err_no_tf_answer;
//               break;
//             case 'fill_blank':
//               if (branch.fillBlankAnswerController.text.trim().isEmpty)
//                 return S.of(context).err_empty_fill_blank;
//               break;
//             case 'matching':
//               if (branch.matchingPairs.any(
//                 (p) =>
//                     p.termController.text.trim().isEmpty ||
//                     p.matchController.text.trim().isEmpty,
//               ))
//                 return S.of(context).err_empty_matching;
//               break;
//             case 'essay':
//               if (branch.essayModelAnswerController.text.trim().isEmpty)
//                 return S.of(context).err_empty_essay;
//               break;
//           }
//         }
//       }
//     }
//     if (!hasQuestions) return S.of(context).err_empty_exam;
//     return null;
//   }

//   Future<bool> _saveExam({bool isDraft = false}) async {
//     if (!isDraft) {
//       String? errorMessage = _getValidationError();
//       if (errorMessage != null) {
//         _showSnackbar(errorMessage, isError: true);
//         return false;
//       }
//     } else {
//       if (_titleController.text.trim().isEmpty) {
//         _titleController.text = S.of(context).untitled_exam;
//       }
//     }

//     setState(() => _isSaving = true);

//     try {
//       final groupsJson = _groups.asMap().entries.map((gEntry) {
//         final gi = gEntry.key;
//         final g = gEntry.value;
//         final sectionsJson = g.sections.asMap().entries.map((sEntry) {
//           final si = sEntry.key;
//           final s = sEntry.value;
//           final branchesJson = s.items.asMap().entries.map((bEntry) {
//             final bi = bEntry.key;
//             final b = bEntry.value;
//             final Map<String, dynamic> branchMap = {
//               'question_text': b.questionController.text.trim(),
//               'question_mark': b.grade,
//               'question_order': bi + 1,
//               'question_numbering_style': b.numberingStyle,
//             };
//             switch (s.sectionType) {
//               case 'mcq':
//                 branchMap['mcq_options'] = b.mcqOptions
//                     .map(
//                       (o) => {
//                         'option_text': o.controller.text.trim(),
//                         'is_correct': o.isCorrect,
//                       },
//                     )
//                     .toList();
//                 break;
//               case 'true_false':
//                 if (b.tfAnswer != null)
//                   branchMap['true_false_answer'] = {
//                     'correct_answer': b.tfAnswer,
//                   };
//                 break;
//               case 'fill_blank':
//                 branchMap['fill_blank_answer'] = {
//                   'correct_word': b.fillBlankAnswerController.text.trim(),
//                 };
//                 break;
//               case 'matching':
//                 branchMap['matching_pairs'] = b.matchingPairs
//                     .map(
//                       (p) => {
//                         'term': p.termController.text.trim(),
//                         'match': p.matchController.text.trim(),
//                       },
//                     )
//                     .toList();
//                 break;
//               case 'essay':
//                 branchMap['essay_answer'] = {
//                   'model_answer': b.essayModelAnswerController.text.trim(),
//                   'keywords': b.essayKeywordsController.text.trim(),
//                 };
//                 break;
//             }
//             return branchMap;
//           }).toList();
//           return {
//             'section_title': s.titleController.text.trim(),
//             'section_type': s.sectionType,
//             'section_order': si + 1,
//             'section_numbering_style': s.numberingStyle,
//             'items': branchesJson,
//           };
//         }).toList();
//         return {
//           'group_title': g.titleController.text.trim(),
//           'group_order': gi + 1,
//           'group_numbering_style': g.numberingStyle,
//           'sections': sectionsJson,
//         };
//       }).toList();

//       final body = jsonEncode({
//         if (_currentExamId != null) 'exam_id': _currentExamId,
//         'exam_title': _titleController.text.trim(),
//         'exam_date': _dateController.text.trim().isNotEmpty
//             ? _dateController.text.trim()
//             : DateTime.now().toIso8601String().substring(0, 10),
//         'time_limit': _totalDurationMinutes?.toString() ?? '',
//         'folder_id': _effectiveFolderId,
//         'question_groups': groupsJson,
//         'status': isDraft ? 'Draft' : 'Published',
//         'exam_type': 'manual',
//       });

//       final response = await http
//           .post(
//             Uri.parse('http://localhost:8000/api/exams/create-full-exam'),
//             headers: {'Content-Type': 'application/json'},
//             body: body,
//           )
//           .timeout(const Duration(seconds: 15));

//       if (mounted)
//         setState(() {
//           _isSaving = false;
//         });

//       if (response.statusCode == 201 || response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         _currentExamId = responseData['exam_id'];
//         if (mounted) setState(() => _isExamSaved = true);

//         _showSnackbar(
//           isDraft
//               ? S.of(context).saved_as_draft_success
//               : S.of(context).saved_and_approved_success,
//         );
//         return true;
//       } else {
//         final err = jsonDecode(response.body);
//         _showSnackbar(
//           '${S.of(context).error_prefix} ${err['detail'] ?? response.body}',
//           isError: true,
//         );
//         return false;
//       }
//     } catch (e) {
//       if (mounted) setState(() => _isSaving = false);
//       _showSnackbar('${S.of(context).connection_error} $e', isError: true);
//       return false;
//     }
//   }

//   void _showSnackbar(String msg, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: isError
//             ? Colors.red.shade700
//             : AppColors.primaryTeal(context),
//       ),
//     );
//   }

//   Widget _buildNumberingDropdown(
//     String currentValue,
//     ValueChanged<String?> onChanged,
//   ) {
//     return Container(
//       height: 28,
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(
//           color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
//         ),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: currentValue,
//           icon: Icon(
//             Icons.arrow_drop_down,
//             size: 14,
//             color: AppColors.primaryTeal(context),
//           ),
//           style: TextStyle(
//             color: AppColors.primaryTeal(context),
//             fontSize: 12,
//             fontWeight: FontWeight.bold,
//           ),
//           items: [
//             DropdownMenuItem(
//               value: 'numbers',
//               child: Text(S.of(context).num_numbers),
//             ),
//             DropdownMenuItem(
//               value: 'letters_ar',
//               child: Text(S.of(context).num_letters_ar),
//             ),
//             DropdownMenuItem(
//               value: 'letters_en',
//               child: Text(S.of(context).num_letters_en),
//             ),
//             DropdownMenuItem(
//               value: 'roman',
//               child: Text(S.of(context).num_roman),
//             ),
//             DropdownMenuItem(
//               value: 'none',
//               child: Text(S.of(context).num_none),
//             ),
//           ],
//           onChanged: (val) {
//             _markAsUnsaved();
//             onChanged(val);
//           },
//         ),
//       ),
//     );
//   }

//   Future<bool> _onWillPop() async {
//     if (_isExamSaved) return true;

//     final shouldPop = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Text(
//           S.of(context).exit_warning_title,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: Text(S.of(context).exit_warning_content),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(true),
//             child: Text(
//               S.of(context).exit_without_saving,
//               style: const TextStyle(color: Colors.red),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.of(ctx).pop(false);
//               bool success = await _saveExam(isDraft: true);
//               if (success && mounted) {
//                 Navigator.of(context).pop(true);
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryTeal(context),
//             ),
//             child: Text(
//               S.of(context).save_draft_and_exit,
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//     return shouldPop ?? false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final isMobile = constraints.maxWidth < 1000;
//           return Scaffold(
//             key: _scaffoldKey,
//             backgroundColor: AppColors.secondaryTeal(context),
//             drawer: isMobile
//                 ? Drawer(
//                     width: 260,
//                     child: SafeArea(
//                       child: CustSidebar(
//                         selectedIndex: _selectedIndex,
//                         onItemSelected: _handleNavigation,
//                       ),
//                     ),
//                   )
//                 : null,
//             body: Stack(
//               children: [
//                 Row(
//                   children: [
//                     if (!isMobile)
//                       CustSidebar(
//                         selectedIndex: _selectedIndex,
//                         onItemSelected: _handleNavigation,
//                       ),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           if (isMobile) _buildMobileAppBar(),
//                           Expanded(
//                             child: SingleChildScrollView(
//                               padding: EdgeInsets.all(isMobile ? 16 : 32),
//                               child: Center(
//                                 child: Container(
//                                   constraints: const BoxConstraints(
//                                     maxWidth: 1000,
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       _buildBreadcrumbCard(),
//                                       const SizedBox(height: 24),
//                                       _buildExamInfoCard(context),
//                                       const SizedBox(height: 24),
//                                       ...List.generate(
//                                         _groups.length,
//                                         (gi) => Padding(
//                                           padding: const EdgeInsets.only(
//                                             bottom: 24,
//                                           ),
//                                           child: _buildGroupCard(context, gi),
//                                         ),
//                                       ),
//                                       _buildAddButton(
//                                         context,
//                                         label: S
//                                             .of(context)
//                                             .add_main_question_btn,
//                                         onTap: () => setState(() {
//                                           String currentStyle =
//                                               _groups.isNotEmpty
//                                               ? _groups.first.numberingStyle
//                                               : 'numbers';
//                                           _groups.add(
//                                             QuestionGroupModel(
//                                               numberingStyle: currentStyle,
//                                             ),
//                                           );
//                                         }),
//                                       ),
//                                       const SizedBox(height: 40),
//                                       _buildFooterButtons(context),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (_isSaving)
//                   Positioned.fill(
//                     child: Container(
//                       color: Colors.black.withOpacity(0.3),
//                       child: const Center(child: CircularProgressIndicator()),
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
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
//             const SizedBox(width: 8),
//             Text(
//               S.of(context).create_electronic_exam,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: AppColors.textPrimary(context),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBreadcrumbCard() {
//     bool isRtl = Directionality.of(context) == TextDirection.rtl;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8),
//         ],
//       ),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () async {
//               bool canNavigate = await _onWillPop();
//               if (canNavigate && mounted) Navigator.pop(context);
//             },
//             child: Text(
//               S.of(context).exam_management_title,
//               style: const TextStyle(
//                 color: Colors.grey,
//                 fontSize: 13,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Icon(
//               isRtl ? Icons.chevron_left : Icons.chevron_right,
//               color: Colors.grey,
//               size: 16,
//             ),
//           ),
//           Text(
//             S.of(context).create_electronic_exam,
//             style: TextStyle(
//               color: AppColors.primaryTeal(context),
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildExamInfoCard(BuildContext context) {
//     final bool isMobile = MediaQuery.of(context).size.width < 800;
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.02),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 S.of(context).exam_info,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: AppColors.textPrimary(context),
//                 ),
//               ),
//               if (isMobile) _gradeBox(context),
//             ],
//           ),
//           const SizedBox(height: 15),
//           isMobile
//               ? Column(
//                   children: [
//                     _infoTextField(
//                       context,
//                       label: S.of(context).exam_title_label,
//                       icon: Icons.description_outlined,
//                       controller: _titleController,
//                       hint: " ",
//                     ),
//                     const SizedBox(height: 16),
//                     InkWell(
//                       onTap: _showTimeLimitDialog,
//                       borderRadius: BorderRadius.circular(10),
//                       child: AbsorbPointer(
//                         child: _infoTextField(
//                           context,
//                           label: S.of(context).time_limit_label,
//                           icon: Icons.timer_outlined,
//                           controller: _timeLimitController,
//                           hint: '',
//                           readOnly: true,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     InkWell(
//                       onTap: _selectDate,
//                       borderRadius: BorderRadius.circular(10),
//                       child: AbsorbPointer(
//                         child: _infoTextField(
//                           context,
//                           label: S.of(context).exam_date_label,
//                           icon: Icons.calendar_month_outlined,
//                           controller: _dateController,
//                           hint: ' ',
//                           readOnly: true,
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               : Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: _infoTextField(
//                         context,
//                         label: S.of(context).exam_title_label,
//                         icon: Icons.description_outlined,
//                         controller: _titleController,
//                         hint: " ",
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       flex: 1,
//                       child: InkWell(
//                         onTap: _showTimeLimitDialog,
//                         borderRadius: BorderRadius.circular(10),
//                         child: AbsorbPointer(
//                           child: _infoTextField(
//                             context,
//                             label: S.of(context).time_limit_label,
//                             icon: Icons.timer_outlined,
//                             controller: _timeLimitController,
//                             hint: ' ',
//                             readOnly: true,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       flex: 1,
//                       child: InkWell(
//                         onTap: _selectDate,
//                         borderRadius: BorderRadius.circular(10),
//                         child: AbsorbPointer(
//                           child: _infoTextField(
//                             context,
//                             label: S.of(context).exam_date_label,
//                             icon: Icons.calendar_month_outlined,
//                             controller: _dateController,
//                             hint: ' ',
//                             readOnly: true,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     if (!isMobile) _gradeBox(context),
//                   ],
//                 ),
//           const SizedBox(height: 16),
//           _buildContextualFields(context),
//         ],
//       ),
//     );
//   }

//   Widget _buildContextualFields(BuildContext context) {
//     final bool isMobile = MediaQuery.of(context).size.width < 800;
//     bool hasSpecialization = false;
//     if (_isReadOnlyMode) {
//       final spec = widget.examContext!.specialization;
//       hasSpecialization =
//           spec != null && spec.trim().isNotEmpty && spec.trim() != 'عام';
//     } else {
//       final spec = _specializationController.text;
//       hasSpecialization = spec.trim().isNotEmpty && spec.trim() != 'عام';
//     }

//     List<Widget> fields = [];
//     if (_isReadOnlyMode) {
//       final ctx = widget.examContext!;
//       fields.add(
//         _infoTextField(
//           context,
//           label: S.of(context).course_name_label,
//           icon: Icons.book_outlined,
//           hint: ctx.courseName ?? '',
//           readOnly: true,
//         ),
//       );
//       fields.add(
//         _infoTextField(
//           context,
//           label: S.of(context).folder_name_label,
//           icon: Icons.folder_outlined,
//           hint: ctx.folderName ?? '',
//           readOnly: true,
//         ),
//       );
//       fields.add(
//         _infoTextField(
//           context,
//           label: S.of(context).level_label,
//           icon: Icons.menu_book_outlined,
//           hint: ctx.levelName ?? '',
//           readOnly: true,
//         ),
//       );
//       if (hasSpecialization)
//         fields.add(
//           _infoTextField(
//             context,
//             label: S.of(context).specialization_label,
//             icon: Icons.category_outlined,
//             hint: ctx.specialization ?? '',
//             readOnly: true,
//           ),
//         );
//     } else {
//       fields.add(
//         _isLoadingCourses
//             ? const Center(child: CircularProgressIndicator())
//             : _infoDropdown<CourseModel>(
//                 context,
//                 label: S.of(context).course_name_label,
//                 icon: Icons.book_outlined,
//                 value: _selectedCourse,
//                 items: _myCourses,
//                 itemLabel: (e) => e.name,
//                 onChanged: (v) {
//                   setState(() {
//                     _selectedCourse = v;
//                     _selectedFolder = null;
//                     _specializationController.text = v!.specialization;
//                     _levelController.text = v.level;
//                   });
//                 },
//               ),
//       );
//       fields.add(
//         _selectedCourse == null
//             ? _infoTextField(
//                 context,
//                 label: S.of(context).folder_name_label,
//                 icon: Icons.folder_outlined,
//                 hint: ' ',
//                 readOnly: true,
//               )
//             : _infoDropdown<FolderModel>(
//                 context,
//                 label: S.of(context).folder_name_label,
//                 icon: Icons.folder_outlined,
//                 value: _selectedFolder,
//                 items: _selectedCourse!.folders,
//                 itemLabel: (e) => e.name,
//                 onChanged: (v) => setState(() => _selectedFolder = v),
//               ),
//       );
//       fields.add(
//         _infoTextField(
//           context,
//           label: S.of(context).level_label,
//           icon: Icons.menu_book_outlined,
//           controller: _levelController,
//           hint: ' ',
//           readOnly: true,
//         ),
//       );
//       if (hasSpecialization)
//         fields.add(
//           _infoTextField(
//             context,
//             label: S.of(context).specialization_label,
//             icon: Icons.category_outlined,
//             controller: _specializationController,
//             hint: ' ',
//             readOnly: true,
//           ),
//         );
//     }

//     if (isMobile) {
//       return Column(
//         children: List.generate(
//           fields.length,
//           (index) => Padding(
//             padding: EdgeInsets.only(
//               bottom: index == fields.length - 1 ? 0 : 16,
//             ),
//             child: fields[index],
//           ),
//         ),
//       );
//     } else {
//       List<Widget> rowChildren = [];
//       for (int i = 0; i < fields.length; i++) {
//         rowChildren.add(Expanded(child: fields[i]));
//         if (i < fields.length - 1) rowChildren.add(const SizedBox(width: 12));
//       }
//       return Row(children: rowChildren);
//     }
//   }

//   Widget _infoTextField(
//     BuildContext context, {
//     required String label,
//     required IconData icon,
//     TextEditingController? controller,
//     String? hint,
//     bool readOnly = false,
//     VoidCallback? onTap,
//   }) {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         color: AppColors.scaffoldBg(context),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: AppColors.textSecondary(context).withValues(alpha: 0.2),
//         ),
//       ),
//       child: Row(
//         children: [
//           const SizedBox(width: 12),
//           Icon(icon, color: AppColors.primaryTeal(context), size: 20),
//           const SizedBox(width: 8),
//           Text(
//             label,
//             style: TextStyle(
//               color: AppColors.textSecondary(context),
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               readOnly: readOnly,
//               onTap: onTap,
//               onChanged: (value) => _markAsUnsaved(),
//               style: const TextStyle(fontSize: 14),
//               decoration: InputDecoration(
//                 hintText: hint ?? "",
//                 hintStyle: TextStyle(
//                   color: readOnly
//                       ? AppColors.textPrimary(context)
//                       : AppColors.textSecondary(context),
//                   fontSize: 13,
//                 ),
//                 border: InputBorder.none,
//                 isDense: true,
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 8,
//                   vertical: 10,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _infoDropdown<T>(
//     BuildContext context, {
//     required String label,
//     required IconData icon,
//     required T? value,
//     required List<T> items,
//     required String Function(T) itemLabel,
//     required ValueChanged<T?> onChanged,
//   }) {
//     return Container(
//       height: 48,
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: AppColors.scaffoldBg(context),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: AppColors.textSecondary(context).withValues(alpha: 0.2),
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: AppColors.primaryTeal(context), size: 20),
//           const SizedBox(width: 8),
//           Expanded(
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<T>(
//                 value: value,
//                 isExpanded: true,
//                 hint: Text(
//                   items.isEmpty ? '  ' : label,
//                   style: TextStyle(
//                     color: items.isEmpty
//                         ? Colors.red
//                         : AppColors.textSecondary(context),
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 icon: Icon(
//                   Icons.keyboard_arrow_down,
//                   color: AppColors.primaryTeal(context),
//                   size: 18,
//                 ),
//                 style: TextStyle(
//                   color: AppColors.textPrimary(context),
//                   fontSize: 13,
//                 ),
//                 items: items
//                     .map(
//                       (e) => DropdownMenuItem<T>(
//                         value: e,
//                         child: Text(
//                           itemLabel(e),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     )
//                     .toList(),
//                 onChanged: items.isEmpty
//                     ? null
//                     : (val) {
//                         _markAsUnsaved();
//                         onChanged(val);
//                       },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _gradeBox(BuildContext context) {
//     final bool isMobile = MediaQuery.of(context).size.width < 800;
//     return Column(
//       children: [
//         Text(
//           S.of(context).total_grade,
//           style: TextStyle(
//             fontSize: isMobile ? 8 : 11,
//             color: AppColors.textSecondary(context),
//           ),
//         ),
//         const SizedBox(height: 5),
//         Container(
//           width: isMobile ? 40 : 80,
//           height: isMobile ? 30 : 48,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: AppColors.primaryTeal(context).withValues(alpha: 0.1),
//             borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
//             border: Border.all(
//               color: AppColors.primaryTeal(context).withValues(alpha: 0.2),
//             ),
//           ),
//           child: Text(
//             _getTotalGrade().toStringAsFixed(0),
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: isMobile ? 16 : 20,
//               color: AppColors.primaryTeal(context),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildGroupCard(BuildContext context, int gi) {
//     final group = _groups[gi];
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.02),
//             blurRadius: 10,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildGroupHeader(context, gi, group),
//           const Divider(height: 1),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 ...List.generate(
//                   group.sections.length,
//                   (si) => Padding(
//                     padding: const EdgeInsets.only(bottom: 16),
//                     child: _buildSectionCard(context, gi, si),
//                   ),
//                 ),
//                 _buildAddButton(
//                   context,
//                   label: S.of(context).add_section_btn,
//                   onTap: () => setState(() {
//                     String currentStyle = group.sections.isNotEmpty
//                         ? group.sections.first.numberingStyle
//                         : 'letters_ar';
//                     group.sections.add(
//                       QuestionSectionModel(numberingStyle: currentStyle),
//                     );
//                   }),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGroupHeader(
//     BuildContext context,
//     int gi,
//     QuestionGroupModel group,
//   ) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: AppColors.primaryTeal(context).withValues(alpha: 0.07),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(18),
//           topRight: Radius.circular(18),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 32,
//             height: 32,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: AppColors.primaryTeal(context),
//               shape: BoxShape.circle,
//             ),
//             child: Text(
//               _getNumberingString(gi, group.numberingStyle),
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: TextField(
//               controller: group.titleController,
//               onChanged: (value) => _markAsUnsaved(),
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textPrimary(context),
//                 fontSize: 15,
//               ),
//               decoration: InputDecoration(
//                 hintText: S.of(context).main_question_hint,
//                 hintStyle: TextStyle(
//                   color: AppColors.textSecondary(context),
//                   fontSize: 14,
//                 ),
//                 border: InputBorder.none,
//                 isDense: true,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           _buildNumberingDropdown(
//             group.numberingStyle,
//             (val) => setState(() {
//               for (var g in _groups) {
//                 g.numberingStyle = val!;
//               }
//             }),
//           ),
//           if (_groups.length > 1)
//             IconButton(
//               icon: const Icon(
//                 Icons.delete_outline,
//                 color: Colors.redAccent,
//                 size: 22,
//               ),
//               onPressed: () {
//                 _markAsUnsaved();
//                 setState(() => _groups.removeAt(gi));
//               },
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionHeader(
//     BuildContext context,
//     int gi,
//     int si,
//     QuestionSectionModel section,
//   ) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(13),
//           topRight: Radius.circular(13),
//         ),
//         border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
//       ),
//       child: Row(
//         children: [
//           if (section.numberingStyle != 'none') ...[
//             Text(
//               '${_getNumberingString(si, section.numberingStyle)} - ',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.primaryTeal(context),
//                 fontSize: 14,
//               ),
//             ),
//             const SizedBox(width: 4),
//           ],
//           Expanded(
//             child: TextField(
//               controller: section.titleController,
//               onChanged: (value) => _markAsUnsaved(),
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textPrimary(context),
//                 fontSize: 13,
//               ),
//               decoration: InputDecoration(
//                 hintText: S.of(context).section_title_hint,
//                 hintStyle: TextStyle(
//                   color: AppColors.textSecondary(context),
//                   fontSize: 12,
//                 ),
//                 border: InputBorder.none,
//                 isDense: true,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           _buildNumberingDropdown(
//             section.numberingStyle,
//             (val) => setState(() {
//               for (var s in _groups[gi].sections) {
//                 s.numberingStyle = val!;
//               }
//             }),
//           ),
//           const SizedBox(width: 8),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
//             decoration: BoxDecoration(
//               color: AppColors.primaryTeal(context).withValues(alpha: 0.12),
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                 color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
//               ),
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: section.sectionType,
//                 isDense: true,
//                 icon: Icon(
//                   Icons.keyboard_arrow_down,
//                   color: AppColors.primaryTeal(context),
//                   size: 16,
//                 ),
//                 style: TextStyle(
//                   color: AppColors.primaryTeal(context),
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                 ),
//                 items: _groupTypeItems(context),
//                 onChanged: (val) {
//                   if (val != null) {
//                     _markAsUnsaved();
//                     setState(() {
//                       section.sectionType = val;
//                       for (final b in section.items) b.tfAnswer = null;
//                     });
//                   }
//                 },
//               ),
//             ),
//           ),
//           if (_groups[gi].sections.length > 1)
//             InkWell(
//               onTap: () {
//                 _markAsUnsaved();
//                 setState(() => _groups[gi].sections.removeAt(si));
//               },
//               child: const Padding(
//                 padding: EdgeInsetsDirectional.only(start: 8),
//                 child: Icon(Icons.close, color: Colors.grey, size: 18),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionCard(BuildContext context, int gi, int si) {
//     final section = _groups[gi].sections[si];
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.scaffoldBg(context),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader(context, gi, si, section),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               children: [
//                 ...List.generate(
//                   section.items.length,
//                   (bi) => Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: _buildBranchCard(context, gi, si, bi),
//                   ),
//                 ),
//                 _buildAddButton(
//                   context,
//                   label: S.of(context).add_branch_label,
//                   isLight: true,
//                   onTap: () => setState(() {
//                     String currentStyle = section.items.isNotEmpty
//                         ? section.items.first.numberingStyle
//                         : 'numbers';
//                     section.items.add(
//                       BranchModel(numberingStyle: currentStyle),
//                     );
//                   }),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBranchCard(BuildContext context, int gi, int si, int bi) {
//     final section = _groups[gi].sections[si];
//     final branch = section.items[bi];
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.scaffoldBg(context),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(
//                 '${S.of(context).branch_label} ${_getNumberingString(bi, branch.numberingStyle)}',
//                 style: TextStyle(
//                   color: AppColors.primaryTeal(context),
//                   fontWeight: FontWeight.bold,
//                   fontSize: 13,
//                 ),
//               ),
//               const Spacer(),
//               _buildNumberingDropdown(
//                 branch.numberingStyle,
//                 (val) => setState(() {
//                   for (var b in _groups[gi].sections[si].items) {
//                     b.numberingStyle = val!;
//                   }
//                 }),
//               ),
//               if (section.items.length > 1) ...[
//                 const SizedBox(width: 8),
//                 InkWell(
//                   onTap: () {
//                     _markAsUnsaved();
//                     setState(() => section.items.removeAt(bi));
//                   },
//                   child: const Icon(Icons.close, size: 18, color: Colors.grey),
//                 ),
//               ],
//             ],
//           ),
//           const SizedBox(height: 10),
//           _questionInput(context, branch),
//           const SizedBox(height: 14),
//           _buildAnswerUI(context, gi, si, bi, section.sectionType, branch),
//           const SizedBox(height: 10),
//           _buildBranchFooter(context, gi, si, bi, branch),
//         ],
//       ),
//     );
//   }

//   Widget _buildAddButton(
//     BuildContext context, {
//     required String label,
//     required VoidCallback onTap,
//     bool isLight = false,
//   }) {
//     return InkWell(
//       onTap: () {
//         _markAsUnsaved();
//         onTap();
//       },
//       borderRadius: BorderRadius.circular(10),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         decoration: BoxDecoration(
//           color: isLight
//               ? AppColors.primaryTeal(context).withValues(alpha: 0.03)
//               : Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.add, color: AppColors.primaryTeal(context), size: 18),
//             const SizedBox(width: 6),
//             Text(
//               label,
//               style: TextStyle(
//                 color: AppColors.primaryTeal(context),
//                 fontWeight: FontWeight.bold,
//                 fontSize: 13,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<DropdownMenuItem<String>> _groupTypeItems(BuildContext context) => [
//     _typeItem(context, 'mcq', S.of(context).q_mcq, Icons.list_alt_rounded),
//     _typeItem(
//       context,
//       'true_false',
//       S.of(context).q_tf,
//       Icons.check_circle_outline,
//     ),
//     _typeItem(context, 'essay', S.of(context).q_essay, Icons.edit_note_rounded),
//     _typeItem(
//       context,
//       'matching',
//       S.of(context).q_matching,
//       Icons.compare_arrows_rounded,
//     ),
//     _typeItem(
//       context,
//       'fill_blank',
//       S.of(context).q_fill_blank,
//       Icons.text_fields_rounded,
//     ),
//   ];

//   DropdownMenuItem<String> _typeItem(
//     BuildContext context,
//     String value,
//     String label,
//     IconData icon,
//   ) => DropdownMenuItem(
//     value: value,
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 16, color: AppColors.primaryTeal(context)),
//         const SizedBox(width: 6),
//         Text(label, style: const TextStyle(fontSize: 13)),
//       ],
//     ),
//   );

//   Widget _questionInput(BuildContext context, BranchModel b) => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//     decoration: BoxDecoration(
//       color: AppColors.secondaryTeal(context).withValues(alpha: 0.2),
//       borderRadius: BorderRadius.circular(15),
//     ),
//     child: TextField(
//       controller: b.questionController,
//       textAlign: TextAlign.center,
//       onChanged: (value) => _markAsUnsaved(),
//       decoration: InputDecoration(
//         hintText: S.of(context).write_question_hint,
//         border: InputBorder.none,
//       ),
//     ),
//   );

//   Widget _buildAnswerUI(
//     BuildContext context,
//     int gi,
//     int si,
//     int bi,
//     String sectionType,
//     BranchModel branch,
//   ) {
//     switch (sectionType) {
//       case 'mcq':
//         return _buildMCQAnswerUI(context, gi, si, bi, branch);
//       case 'true_false':
//         return _buildTFAnswerUI(context, gi, si, bi, branch);
//       case 'fill_blank':
//         return _buildFillBlankAnswerUI(context, branch);
//       case 'matching':
//         return _buildMatchingAnswerUI(context, gi, si, bi, branch);
//       case 'essay':
//         return _buildEssayAnswerUI(context, branch);
//       default:
//         return const SizedBox();
//     }
//   }

//   Widget _buildMCQAnswerUI(
//     BuildContext context,
//     int gi,
//     int si,
//     int bi,
//     BranchModel branch,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _answerLabel(
//           context,
//           S.of(context).mcq_options_label,
//           Icons.radio_button_checked,
//         ),
//         const SizedBox(height: 8),
//         ...branch.mcqOptions.asMap().entries.map(
//           (entry) => Padding(
//             padding: const EdgeInsets.only(bottom: 8),
//             child: _buildMCQOption(context, entry.key, entry.value, branch),
//           ),
//         ),
//         TextButton.icon(
//           onPressed: () {
//             _markAsUnsaved();
//             setState(() => branch.mcqOptions.add(McqOptionModel()));
//           },
//           icon: Icon(
//             Icons.add,
//             color: AppColors.primaryTeal(context),
//             size: 18,
//           ),
//           label: Text(
//             '+ ${S.of(context).add_option}',
//             style: TextStyle(
//               color: AppColors.primaryTeal(context),
//               fontWeight: FontWeight.bold,
//               fontSize: 13,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMCQOption(
//     BuildContext context,
//     int oi,
//     McqOptionModel opt,
//     BranchModel branch,
//   ) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       decoration: BoxDecoration(
//         color: opt.isCorrect
//             ? AppColors.primaryTeal(context).withValues(alpha: 0.08)
//             : Colors.white,
//         borderRadius: BorderRadius.circular(30),
//         border: Border.all(
//           color: opt.isCorrect
//               ? AppColors.primaryTeal(context)
//               : Colors.grey.shade300,
//           width: opt.isCorrect ? 1.5 : 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () {
//               _markAsUnsaved();
//               setState(() {
//                 for (final o in branch.mcqOptions) {
//                   o.isCorrect = false;
//                 }
//                 opt.isCorrect = true;
//               });
//             },
//             child: Icon(
//               opt.isCorrect ? Icons.check_circle : Icons.circle_outlined,
//               color: opt.isCorrect
//                   ? AppColors.primaryTeal(context)
//                   : Colors.grey,
//               size: 22,
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: TextField(
//               controller: opt.controller,
//               onChanged: (value) => _markAsUnsaved(),
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 isDense: true,
//               ),
//             ),
//           ),
//           if (branch.mcqOptions.length > 2)
//             IconButton(
//               icon: const Icon(Icons.close, size: 16, color: Colors.grey),
//               onPressed: () {
//                 _markAsUnsaved();
//                 setState(() => branch.mcqOptions.removeAt(oi));
//               },
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTFAnswerUI(
//     BuildContext context,
//     int gi,
//     int si,
//     int bi,
//     BranchModel branch,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _answerLabel(
//           context,
//           S.of(context).tf_select_label,
//           Icons.check_circle_outline,
//         ),
//         const SizedBox(height: 10),
//         Row(
//           children: [
//             Expanded(
//               child: _tfToggleBtn(
//                 context,
//                 label: S.of(context).true_word,
//                 selected: branch.tfAnswer == 'true',
//                 onTap: () => setState(() => branch.tfAnswer = 'true'),
//                 color: Colors.green,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: _tfToggleBtn(
//                 context,
//                 label: S.of(context).false_word,
//                 selected: branch.tfAnswer == 'false',
//                 onTap: () => setState(() => branch.tfAnswer = 'false'),
//                 color: Colors.red,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _tfToggleBtn(
//     BuildContext context, {
//     required String label,
//     required bool selected,
//     required VoidCallback onTap,
//     required Color color,
//   }) {
//     return GestureDetector(
//       onTap: () {
//         _markAsUnsaved();
//         onTap();
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(vertical: 14),
//         decoration: BoxDecoration(
//           color: selected ? color.withValues(alpha: 0.15) : Colors.white,
//           borderRadius: BorderRadius.circular(30),
//           border: Border.all(
//             color: selected ? color : Colors.grey.shade300,
//             width: selected ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               selected ? Icons.check_circle : Icons.circle_outlined,
//               color: selected ? color : Colors.grey,
//               size: 18,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 color: selected ? color : AppColors.textSecondary(context),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFillBlankAnswerUI(BuildContext context, BranchModel branch) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _answerLabel(
//           context,
//           S.of(context).fill_blank_hint_label,
//           Icons.text_fields_rounded,
//         ),
//         const SizedBox(height: 8),
//         _answerTextField(
//           context,
//           controller: branch.fillBlankAnswerController,
//           hint: S.of(context).fill_blank_answer_hint,
//           icon: Icons.short_text_rounded,
//         ),
//       ],
//     );
//   }

//   Widget _buildMatchingAnswerUI(
//     BuildContext context,
//     int gi,
//     int si,
//     int bi,
//     BranchModel branch,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _answerLabel(
//           context,
//           S.of(context).matching_pairs_label,
//           Icons.compare_arrows_rounded,
//         ),
//         const SizedBox(height: 8),
//         ...branch.matchingPairs.asMap().entries.map(
//           (entry) => Padding(
//             padding: const EdgeInsets.only(bottom: 10),
//             child: _buildMatchingPairRow(
//               context,
//               gi,
//               si,
//               bi,
//               entry.key,
//               entry.value,
//               branch,
//             ),
//           ),
//         ),
//         TextButton.icon(
//           onPressed: () {
//             _markAsUnsaved();
//             setState(() => branch.matchingPairs.add(MatchingPairModel()));
//           },
//           icon: Icon(
//             Icons.add,
//             color: AppColors.primaryTeal(context),
//             size: 18,
//           ),
//           label: Text(
//             '+ ${S.of(context).add_matching_pair}',
//             style: TextStyle(
//               color: AppColors.primaryTeal(context),
//               fontWeight: FontWeight.bold,
//               fontSize: 13,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMatchingPairRow(
//     BuildContext context,
//     int gi,
//     int si,
//     int bi,
//     int pi,
//     MatchingPairModel pair,
//     BranchModel branch,
//   ) {
//     return Row(
//       children: [
//         Container(
//           width: 24,
//           height: 24,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: AppColors.primaryTeal(context).withValues(alpha: 0.15),
//             shape: BoxShape.circle,
//           ),
//           child: Text(
//             '${pi + 1}',
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.bold,
//               color: AppColors.primaryTeal(context),
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: _answerTextField(
//             context,
//             controller: pair.termController,
//             hint: S.of(context).matching_term_hint,
//             icon: Icons.looks_one_outlined,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           child: Icon(
//             Icons.arrow_forward,
//             color: AppColors.primaryTeal(context),
//             size: 20,
//           ),
//         ),
//         Expanded(
//           child: _answerTextField(
//             context,
//             controller: pair.matchController,
//             hint: S.of(context).matching_match_hint,
//             icon: Icons.looks_two_outlined,
//           ),
//         ),
//         if (branch.matchingPairs.length > 1)
//           IconButton(
//             icon: const Icon(Icons.close, size: 16, color: Colors.grey),
//             padding: EdgeInsets.zero,
//             constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
//             onPressed: () {
//               _markAsUnsaved();
//               setState(() => branch.matchingPairs.removeAt(pi));
//             },
//           ),
//       ],
//     );
//   }

//   Widget _buildEssayAnswerUI(BuildContext context, BranchModel branch) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _answerLabel(
//           context,
//           S.of(context).essay_answer_label,
//           Icons.edit_note_rounded,
//         ),
//         const SizedBox(height: 8),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           child: TextField(
//             controller: branch.essayModelAnswerController,
//             onChanged: (value) => _markAsUnsaved(),
//             maxLines: 3,
//             decoration: InputDecoration(
//               hintText: S.of(context).essay_model_answer_hint,
//               hintStyle: TextStyle(
//                 color: AppColors.textSecondary(context),
//                 fontSize: 13,
//               ),
//               border: InputBorder.none,
//               isDense: true,
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         _answerTextField(
//           context,
//           controller: branch.essayKeywordsController,
//           hint: S.of(context).essay_keywords_hint,
//           icon: Icons.label_outline,
//         ),
//       ],
//     );
//   }

//   Widget _answerLabel(BuildContext context, String text, IconData icon) => Row(
//     children: [
//       Icon(icon, size: 16, color: AppColors.primaryTeal(context)),
//       const SizedBox(width: 6),
//       Flexible(
//         child: Text(
//           text,
//           style: TextStyle(
//             color: AppColors.primaryTeal(context),
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     ],
//   );

//   Widget _answerTextField(
//     BuildContext context, {
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: AppColors.primaryTeal(context)),
//           const SizedBox(width: 8),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               style: const TextStyle(fontSize: 13),
//               onChanged: (value) => _markAsUnsaved(),
//               decoration: InputDecoration(
//                 hintText: hint,
//                 hintStyle: const TextStyle(fontSize: 12),
//                 border: InputBorder.none,
//                 isDense: true,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBranchFooter(
//     BuildContext context,
//     int gi,
//     int si,
//     int bi,
//     BranchModel branch,
//   ) {
//     return Row(
//       children: [
//         IconButton(
//           icon: const Icon(Icons.copy_all, color: Colors.grey, size: 18),
//           tooltip: S.of(context).copy_branch_tooltip,
//           onPressed: () {
//             _markAsUnsaved();
//             setState(() {
//               final copy = BranchModel(
//                 questionText: branch.questionController.text,
//                 grade: branch.grade,
//                 tfAnswer: branch.tfAnswer,
//                 fillBlankAnswer: branch.fillBlankAnswerController.text,
//                 essayModelAnswer: branch.essayModelAnswerController.text,
//                 essayKeywords: branch.essayKeywordsController.text,
//                 matchingPairs: branch.matchingPairs
//                     .map(
//                       (p) => MatchingPairModel(
//                         term: p.termController.text,
//                         match: p.matchController.text,
//                       ),
//                     )
//                     .toList(),
//                 mcqOptions: branch.mcqOptions
//                     .map(
//                       (o) => McqOptionModel(
//                         text: o.controller.text,
//                         isCorrect: o.isCorrect,
//                       ),
//                     )
//                     .toList(),
//               );
//               _groups[gi].sections[si].items.insert(bi + 1, copy);
//             });
//           },
//         ),
//         const Spacer(),
//         Text(
//           '${S.of(context).grade_label} ',
//           style: TextStyle(
//             color: AppColors.textSecondary(context),
//             fontSize: 12,
//           ),
//         ),
//         SizedBox(
//           width: 40,
//           child: TextField(
//             textAlign: TextAlign.center,
//             keyboardType: TextInputType.number,
//             style: TextStyle(
//               color: AppColors.primaryTeal(context),
//               fontWeight: FontWeight.bold,
//             ),
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//               isDense: true,
//             ),
//             controller:
//                 TextEditingController(text: branch.grade.toStringAsFixed(0))
//                   ..selection = TextSelection.collapsed(
//                     offset: branch.grade.toStringAsFixed(0).length,
//                   ),
//             onChanged: (v) {
//               _markAsUnsaved();
//               setState(() => branch.grade = double.tryParse(v) ?? 0);
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFooterButtons(BuildContext context) => Row(
//     children: [
//       Expanded(
//         child: ElevatedButton(
//           onPressed: _isSaving
//               ? null
//               : () async {
//                   bool success = await _saveExam(isDraft: false);
//                   if (success && mounted) {
//                     Navigator.pop(context, true);
//                   }
//                 },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primaryTeal(context),
//             padding: const EdgeInsets.symmetric(vertical: 18),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//           ),
//           child: _isSaving
//               ? const SizedBox(
//                   width: 22,
//                   height: 22,
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 2,
//                   ),
//                 )
//               : Text(
//                   S.of(context).save_and_approve,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//         ),
//       ),
//       const SizedBox(width: 20),
//       Expanded(
//         child: OutlinedButton(
//           onPressed: _isSaving
//               ? null
//               : () async {
//                   bool success = await _saveExam(isDraft: true);
//                   if (success && mounted) {
//                     Navigator.pop(context, true);
//                   }
//                 },
//           style: OutlinedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(vertical: 18),
//             side: BorderSide(color: AppColors.primaryTeal(context)),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//           ),
//           child: Text(
//             S.of(context).save_as_draft,
//             style: TextStyle(color: AppColors.primaryTeal(context)),
//           ),
//         ),
//       ),
//     ],
//   );

//   void _showTimeLimitDialog() {
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: '',
//       barrierColor: Colors.black.withValues(alpha: 0.6),
//       pageBuilder: (ctx, anim1, anim2) => BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//         child: Center(
//           child: Material(
//             color: Colors.transparent,
//             child: Container(
//               padding: const EdgeInsets.all(30),
//               width: 420,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Align(
//                     alignment: AlignmentDirectional.topStart,
//                     child: IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () => Navigator.pop(ctx),
//                     ),
//                   ),
//                   Text(
//                     S.of(context).write_time_limit,
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 25),
//                   SizedBox(
//                     height: 150,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: CupertinoPicker(
//                             scrollController: FixedExtentScrollController(
//                               initialItem: _selectedHours,
//                             ),
//                             itemExtent: 40,
//                             onSelectedItemChanged: (int value) {
//                               _selectedHours = value;
//                             },
//                             children: List.generate(
//                               24,
//                               (index) => Center(
//                                 child: Text(
//                                   '$index  ${S.of(context).hour_word}',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     color: AppColors.textPrimary(context),
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const Text(
//                           ':',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Expanded(
//                           child: CupertinoPicker(
//                             scrollController: FixedExtentScrollController(
//                               initialItem: _selectedMinutes,
//                             ),
//                             itemExtent: 40,
//                             onSelectedItemChanged: (int value) {
//                               _selectedMinutes = value;
//                             },
//                             children: List.generate(
//                               60,
//                               (index) => Center(
//                                 child: Text(
//                                   '$index  ${S.of(context).minute_word}',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     color: AppColors.textPrimary(context),
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 35),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               _totalDurationMinutes =
//                                   (_selectedHours * 60) + _selectedMinutes;
//                               String formattedTime = '';
//                               if (_selectedHours > 0)
//                                 formattedTime +=
//                                     '$_selectedHours ${S.of(context).hour_word}';
//                               if (_selectedMinutes > 0 || _selectedHours == 0) {
//                                 if (formattedTime.isNotEmpty)
//                                   formattedTime += ' ';
//                                 formattedTime +=
//                                     '$_selectedMinutes ${S.of(context).minute_word}';
//                               }
//                               _timeLimitController.text = formattedTime;
//                               _markAsUnsaved();
//                             });
//                             Navigator.pop(ctx);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.primaryTeal(context),
//                             padding: const EdgeInsets.symmetric(vertical: 18),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             elevation: 0,
//                           ),
//                           child: Text(
//                             S.of(context).confirm,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 15),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () => Navigator.pop(ctx),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFFB35A5A),
//                             padding: const EdgeInsets.symmetric(vertical: 18),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             elevation: 0,
//                           ),
//                           child: Text(
//                             S.of(context).cancel,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _dialogBtn(
//     BuildContext ctx,
//     String label,
//     Color color,
//   ) => ElevatedButton(
//     onPressed: () => Navigator.pop(ctx),
//     style: ElevatedButton.styleFrom(
//       backgroundColor: color,
//       padding: const EdgeInsets.symmetric(vertical: 18),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 0,
//     ),
//     child: Text(
//       label,
//       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//     ),
//   );
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../core/colors.dart';
import '../generated/l10n.dart';
import 'teacher_dashboard.dart';
import 'teacher_matearial.dart' hide HeaderWidget;
import 'grading.dart' hide HeaderWidget;
import 'exam_page.dart' hide HeaderWidget;
import 'review_exam_screen.dart';
import 'teacer_setting.dart';
import 'ExamManagementPage.dart';
// 🌟 تأكدي من مسار ملف البروفايدر حسب مجلداتك
import '../provider/ExamProvider.dart';

// ══════════════════════════════════════════════════════════════
// الشاشة المغلفة (Wrapper) لضمان عمل الـ Provider تلقائياً
// ══════════════════════════════════════════════════════════════
class CreateElectronicExamPage extends StatelessWidget {
  final ExamContext? examContext;
  final int? examIdToEdit;
  const CreateElectronicExamPage({
    super.key,
    this.examContext,
    this.examIdToEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExamProvider(),
      child: _CreateElectronicExamContent(
        examContext: examContext,
        examIdToEdit: examIdToEdit,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// الواجهة النظيفة (Clean UI)
// ══════════════════════════════════════════════════════════════
class _CreateElectronicExamContent extends StatefulWidget {
  final ExamContext? examContext;
  final int? examIdToEdit;
  const _CreateElectronicExamContent({this.examContext, this.examIdToEdit});

  @override
  State<_CreateElectronicExamContent> createState() =>
      _CreateElectronicExamContentState();
}

class _CreateElectronicExamContentState
    extends State<_CreateElectronicExamContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamProvider>().initData(
        context,
        widget.examContext,
        widget.examIdToEdit,
      );
    });
  }

  Future<void> _handleNavigation(int index) async {
    if (index == _selectedIndex) return;
    final provider = context.read<ExamProvider>();

    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
      await Future.delayed(const Duration(milliseconds: 200));
    }

    if (!provider.isExamSaved) {
      final action = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            S.of(context).exit_warning_title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(S.of(context).exit_warning_content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop('leave'),
              child: Text(
                S.of(context).exit_without_saving,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop('save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal(context),
              ),
              child: Text(
                S.of(context).save_draft_and_exit,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );

      if (action == null) return;

      if (action == 'save') {
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black.withValues(alpha: 0.1),
          builder: (ctx) => Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const CircularProgressIndicator(),
            ),
          ),
        );

        bool success = await provider.saveExam(context, isDraft: true);
        if (mounted) Navigator.of(context).pop();
        if (!success) return;
        await Future.delayed(const Duration(seconds: 1));
      } else if (action != 'leave') {
        return;
      }
    }

    Widget? target;
    switch (index) {
      case 0:
        target = const DashboardScreen();
        break;
      case 1:
        target = const ExamManagementPage();
        break;
      case 2:
        target = const Material1();
        break;
      case 3:
        target = const GradingPage();
        break;
      case 4:
        target = const ReviewExamPage();
        break;
      case 5:
        target = const SettingsScreen();
        break;
    }

    if (target != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => target!),
      );
    }
  }

  Future<bool> _onWillPop() async {
    final provider = context.read<ExamProvider>();
    if (provider.isExamSaved) return true;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          S.of(context).exit_warning_title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(S.of(context).exit_warning_content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              S.of(context).exit_without_saving,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop(false);
              bool success = await provider.saveExam(context, isDraft: true);
              if (success && mounted) {
                Navigator.of(context).pop(true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal(context),
            ),
            child: Text(
              S.of(context).save_draft_and_exit,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    return shouldPop ?? false;
  }

  String _getNumberingString(int index, String style) {
    if (style == 'none') return '';
    if (style == 'letters_ar') {
      const letters = [
        'أ',
        'ب',
        'ج',
        'د',
        'هـ',
        'و',
        'ز',
        'ح',
        'ط',
        'ي',
        'ك',
        'ل',
        'م',
        'ن',
        'س',
        'ع',
        'ف',
        'ص',
        'ق',
        'ر',
        'ش',
        'ت',
        'ث',
        'خ',
        'ذ',
        'ض',
        'ظ',
        'غ',
      ];
      return letters[index % letters.length];
    }
    if (style == 'letters_en') {
      return String.fromCharCode(65 + (index % 26));
    }
    if (style == 'roman') {
      const roman = [
        'I',
        'II',
        'III',
        'IV',
        'V',
        'VI',
        'VII',
        'VIII',
        'IX',
        'X',
        'XI',
        'XII',
        'XIII',
        'XIV',
        'XV',
        'XVI',
        'XVII',
        'XVIII',
        'XIX',
        'XX',
      ];
      if (index < roman.length) return roman[index];
      return (index + 1).toString();
    }
    return (index + 1).toString();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExamProvider>();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 1000;
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: AppColors.secondaryTeal(context),
            drawer: isMobile
                ? Drawer(
                    width: 260,
                    child: SafeArea(
                      child: CustSidebar(
                        selectedIndex: _selectedIndex,
                        onItemSelected: _handleNavigation,
                      ),
                    ),
                  )
                : null,
            body: Stack(
              children: [
                Row(
                  children: [
                    if (!isMobile)
                      CustSidebar(
                        selectedIndex: _selectedIndex,
                        onItemSelected: _handleNavigation,
                      ),
                    Expanded(
                      child: Column(
                        children: [
                          if (isMobile) _buildMobileAppBar(),
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(isMobile ? 16 : 32),
                              child: Center(
                                child: Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 1000,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildBreadcrumbCard(),
                                      const SizedBox(height: 24),
                                      _buildExamInfoCard(context, provider),
                                      const SizedBox(height: 24),
                                      ...List.generate(
                                        provider.groups.length,
                                        (gi) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 24,
                                          ),
                                          child: _buildGroupCard(
                                            context,
                                            gi,
                                            provider,
                                          ),
                                        ),
                                      ),
                                      _buildAddButton(
                                        context,
                                        label: S
                                            .of(context)
                                            .add_main_question_btn,
                                        onTap: () => provider.addGroup(),
                                      ),
                                      const SizedBox(height: 40),
                                      _buildFooterButtons(context, provider),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (provider.isSaving)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileAppBar() {
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
            const SizedBox(width: 8),
            Text(
              S.of(context).create_electronic_exam,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.textPrimary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumbCard() {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              bool canNavigate = await _onWillPop();
              if (canNavigate && mounted) Navigator.pop(context);
            },
            child: Text(
              S.of(context).exam_management_title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              isRtl ? Icons.chevron_left : Icons.chevron_right,
              color: Colors.grey,
              size: 16,
            ),
          ),
          Text(
            S.of(context).create_electronic_exam,
            style: TextStyle(
              color: AppColors.primaryTeal(context),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamInfoCard(BuildContext context, ExamProvider provider) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                S.of(context).exam_info,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textPrimary(context),
                ),
              ),
              if (isMobile) _gradeBox(context, provider),
            ],
          ),
          const SizedBox(height: 15),
          isMobile
              ? Column(
                  children: [
                    _infoTextField(
                      context,
                      provider,
                      label: S.of(context).exam_title_label,
                      icon: Icons.description_outlined,
                      controller: provider.titleController,
                      hint: " ",
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _showTimeLimitDialog(provider),
                      borderRadius: BorderRadius.circular(10),
                      child: AbsorbPointer(
                        child: _infoTextField(
                          context,
                          provider,
                          label: S.of(context).time_limit_label,
                          icon: Icons.timer_outlined,
                          controller: provider.timeLimitController,
                          hint: ' ',
                          readOnly: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _selectDate(provider),
                      borderRadius: BorderRadius.circular(10),
                      child: AbsorbPointer(
                        child: _infoTextField(
                          context,
                          provider,
                          label: S.of(context).exam_date_label,
                          icon: Icons.calendar_month_outlined,
                          controller: provider.dateController,
                          hint: ' ',
                          readOnly: true,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _infoTextField(
                        context,
                        provider,
                        label: S.of(context).exam_title_label,
                        icon: Icons.description_outlined,
                        controller: provider.titleController,
                        hint: " ",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () => _showTimeLimitDialog(provider),
                        borderRadius: BorderRadius.circular(10),
                        child: AbsorbPointer(
                          child: _infoTextField(
                            context,
                            provider,
                            label: S.of(context).time_limit_label,
                            icon: Icons.timer_outlined,
                            controller: provider.timeLimitController,
                            hint: ' ',
                            readOnly: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () => _selectDate(provider),
                        borderRadius: BorderRadius.circular(10),
                        child: AbsorbPointer(
                          child: _infoTextField(
                            context,
                            provider,
                            label: S.of(context).exam_date_label,
                            icon: Icons.calendar_month_outlined,
                            controller: provider.dateController,
                            hint: ' ',
                            readOnly: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (!isMobile) _gradeBox(context, provider),
                  ],
                ),
          const SizedBox(height: 16),
          _buildContextualFields(context, provider),
        ],
      ),
    );
  }

  Widget _buildContextualFields(BuildContext context, ExamProvider provider) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;
    bool hasSpecialization =
        provider.specializationController.text.trim().isNotEmpty &&
        provider.specializationController.text.trim() != 'عام';

    List<Widget> fields = [];
    if (provider.isReadOnlyMode) {
      final ctx = provider.examContext!;
      fields.add(
        _infoTextField(
          context,
          provider,
          label: S.of(context).course_name_label,
          icon: Icons.book_outlined,
          hint: ctx.courseName ?? '',
          readOnly: true,
        ),
      );
      fields.add(
        _infoTextField(
          context,
          provider,
          label: S.of(context).folder_name_label,
          icon: Icons.folder_outlined,
          hint: ctx.folderName ?? '',
          readOnly: true,
        ),
      );
      fields.add(
        _infoTextField(
          context,
          provider,
          label: S.of(context).level_label,
          icon: Icons.menu_book_outlined,
          hint: ctx.levelName ?? '',
          readOnly: true,
        ),
      );
      if (hasSpecialization) {
        fields.add(
          _infoTextField(
            context,
            provider,
            label: S.of(context).specialization_label,
            icon: Icons.category_outlined,
            hint: ctx.specialization ?? '',
            readOnly: true,
          ),
        );
      }
    } else {
      fields.add(
        provider.isLoadingCourses
            ? const Center(child: CircularProgressIndicator())
            : _infoDropdown<CourseModel>(
                context,
                provider,
                label: S.of(context).course_name_label,
                icon: Icons.book_outlined,
                value: provider.selectedCourse,
                items: provider.myCourses,
                itemLabel: (e) => e.name,
                onChanged: (v) => provider.updateCourseSelection(v),
              ),
      );
      fields.add(
        provider.selectedCourse == null
            ? _infoTextField(
                context,
                provider,
                label: S.of(context).folder_name_label,
                icon: Icons.folder_outlined,
                hint: ' ',
                readOnly: true,
              )
            : _infoDropdown<FolderModel>(
                context,
                provider,
                label: S.of(context).folder_name_label,
                icon: Icons.folder_outlined,
                value: provider.selectedFolder,
                items: provider.selectedCourse!.folders,
                itemLabel: (e) => e.name,
                onChanged: (v) {
                  provider.markAsUnsaved();
                  setState(() => provider.selectedFolder = v);
                },
              ),
      );
      fields.add(
        _infoTextField(
          context,
          provider,
          label: S.of(context).level_label,
          icon: Icons.menu_book_outlined,
          controller: provider.levelController,
          readOnly: true,
        ),
      );
      if (hasSpecialization) {
        fields.add(
          _infoTextField(
            context,
            provider,
            label: S.of(context).specialization_label,
            icon: Icons.category_outlined,
            controller: provider.specializationController,
            readOnly: true,
          ),
        );
      }
    }

    if (isMobile) {
      return Column(
        children: List.generate(
          fields.length,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: i == fields.length - 1 ? 0 : 16),
            child: fields[i],
          ),
        ),
      );
    } else {
      List<Widget> rowChildren = [];
      for (int i = 0; i < fields.length; i++) {
        rowChildren.add(Expanded(child: fields[i]));
        if (i < fields.length - 1) rowChildren.add(const SizedBox(width: 12));
      }
      return Row(children: rowChildren);
    }
  }

  Widget _infoTextField(
    BuildContext context,
    ExamProvider provider, {
    required String label,
    required IconData icon,
    TextEditingController? controller,
    String? hint,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.textSecondary(context).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(icon, color: AppColors.primaryTeal(context), size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              onChanged: (_) => provider.markAsUnsaved(),
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: hint ?? "",
                hintStyle: TextStyle(
                  color: readOnly
                      ? AppColors.textPrimary(context)
                      : AppColors.textSecondary(context),
                  fontSize: 13,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoDropdown<T>(
    BuildContext context,
    ExamProvider provider, {
    required String label,
    required IconData icon,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.textSecondary(context).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryTeal(context), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                hint: Text(
                  items.isEmpty ? '  ' : label,
                  style: TextStyle(
                    color: items.isEmpty
                        ? Colors.red
                        : AppColors.textSecondary(context),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primaryTeal(context),
                  size: 18,
                ),
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontSize: 13,
                ),
                items: items
                    .map(
                      (e) => DropdownMenuItem<T>(
                        value: e,
                        child: Text(
                          itemLabel(e),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: items.isEmpty ? null : onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradeBox(BuildContext context, ExamProvider provider) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;
    return Column(
      children: [
        Text(
          S.of(context).total_grade,
          style: TextStyle(
            fontSize: isMobile ? 8 : 11,
            color: AppColors.textSecondary(context),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: isMobile ? 40 : 80,
          height: isMobile ? 30 : 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryTeal(context).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
            border: Border.all(
              color: AppColors.primaryTeal(context).withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            provider.getTotalGrade().toStringAsFixed(0),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 16 : 20,
              color: AppColors.primaryTeal(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupCard(BuildContext context, int gi, ExamProvider provider) {
    final group = provider.groups[gi];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGroupHeader(context, gi, group, provider),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...List.generate(
                  group.sections.length,
                  (si) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildSectionCard(context, gi, si, provider),
                  ),
                ),
                _buildAddButton(
                  context,
                  label: S.of(context).add_section_btn,
                  onTap: () {
                    provider.markAsUnsaved();
                    String currentStyle = group.sections.isNotEmpty
                        ? group.sections.first.numberingStyle
                        : 'letters_ar';
                    setState(() {
                      group.sections.add(
                        QuestionSectionModel(numberingStyle: currentStyle),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupHeader(
    BuildContext context,
    int gi,
    QuestionGroupModel group,
    ExamProvider provider,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal(context).withValues(alpha: 0.07),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryTeal(context),
              shape: BoxShape.circle,
            ),
            child: Text(
              _getNumberingString(gi, group.numberingStyle),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: group.titleController,
              onChanged: (_) => provider.markAsUnsaved(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: S.of(context).main_question_hint,
                hintStyle: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildNumberingDropdown(
            group.numberingStyle,
            (val) => setState(() {
              provider.markAsUnsaved();
              for (var g in provider.groups) {
                g.numberingStyle = val!;
              }
            }),
          ),
          if (provider.groups.length > 1)
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
                size: 22,
              ),
              onPressed: () => provider.removeGroup(gi),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context,
    int gi,
    int si,
    ExamProvider provider,
  ) {
    final section = provider.groups[gi].sections[si];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, gi, si, section, provider),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ...List.generate(
                  section.items.length,
                  (bi) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildBranchCard(context, gi, si, bi, provider),
                  ),
                ),
                _buildAddButton(
                  context,
                  label: S.of(context).add_branch_label,
                  isLight: true,
                  onTap: () {
                    provider.markAsUnsaved();
                    String currentStyle = section.items.isNotEmpty
                        ? section.items.first.numberingStyle
                        : 'numbers';
                    setState(() {
                      section.items.add(
                        BranchModel(numberingStyle: currentStyle),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    int gi,
    int si,
    QuestionSectionModel section,
    ExamProvider provider,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(13),
          topRight: Radius.circular(13),
        ),
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          if (section.numberingStyle != 'none') ...[
            Text(
              '${_getNumberingString(si, section.numberingStyle)} - ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryTeal(context),
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: TextField(
              controller: section.titleController,
              onChanged: (_) => provider.markAsUnsaved(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary(context),
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: S.of(context).section_title_hint,
                hintStyle: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 12,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildNumberingDropdown(
            section.numberingStyle,
            (val) => setState(() {
              provider.markAsUnsaved();
              for (var s in provider.groups[gi].sections) {
                s.numberingStyle = val!;
              }
            }),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primaryTeal(context).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: section.sectionType,
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primaryTeal(context),
                  size: 16,
                ),
                style: TextStyle(
                  color: AppColors.primaryTeal(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                items: [
                  _typeItem(
                    context,
                    'mcq',
                    S.of(context).q_mcq,
                    Icons.list_alt_rounded,
                  ),
                  _typeItem(
                    context,
                    'true_false',
                    S.of(context).q_tf,
                    Icons.check_circle_outline,
                  ),
                  _typeItem(
                    context,
                    'essay',
                    S.of(context).q_essay,
                    Icons.edit_note_rounded,
                  ),
                  _typeItem(
                    context,
                    'matching',
                    S.of(context).q_matching,
                    Icons.compare_arrows_rounded,
                  ),
                  _typeItem(
                    context,
                    'fill_blank',
                    S.of(context).q_fill_blank,
                    Icons.text_fields_rounded,
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    provider.markAsUnsaved();
                    setState(() {
                      section.sectionType = val;
                      for (final b in section.items) b.tfAnswer = null;
                    });
                  }
                },
              ),
            ),
          ),
          if (provider.groups[gi].sections.length > 1)
            InkWell(
              onTap: () {
                provider.markAsUnsaved();
                setState(() => provider.groups[gi].sections.removeAt(si));
              },
              child: const Padding(
                padding: EdgeInsetsDirectional.only(start: 8),
                child: Icon(Icons.close, color: Colors.grey, size: 18),
              ),
            ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> _typeItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) => DropdownMenuItem(
    value: value,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primaryTeal(context)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    ),
  );

  Widget _buildNumberingDropdown(
    String currentValue,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          icon: Icon(
            Icons.arrow_drop_down,
            size: 14,
            color: AppColors.primaryTeal(context),
          ),
          style: TextStyle(
            color: AppColors.primaryTeal(context),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          items: [
            DropdownMenuItem(
              value: 'numbers',
              child: Text(S.of(context).num_numbers),
            ),
            DropdownMenuItem(
              value: 'letters_ar',
              child: Text(S.of(context).num_letters_ar),
            ),
            DropdownMenuItem(
              value: 'letters_en',
              child: Text(S.of(context).num_letters_en),
            ),
            DropdownMenuItem(
              value: 'roman',
              child: Text(S.of(context).num_roman),
            ),
            DropdownMenuItem(
              value: 'none',
              child: Text(S.of(context).num_none),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildBranchCard(
    BuildContext context,
    int gi,
    int si,
    int bi,
    ExamProvider provider,
  ) {
    final section = provider.groups[gi].sections[si];
    final branch = section.items[bi];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${S.of(context).branch_label} ${_getNumberingString(bi, branch.numberingStyle)}',
                style: TextStyle(
                  color: AppColors.primaryTeal(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              _buildNumberingDropdown(
                branch.numberingStyle,
                (val) => setState(() {
                  provider.markAsUnsaved();
                  for (var b in provider.groups[gi].sections[si].items) {
                    b.numberingStyle = val!;
                  }
                }),
              ),
              if (section.items.length > 1) ...[
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    provider.markAsUnsaved();
                    setState(() => section.items.removeAt(bi));
                  },
                  child: const Icon(Icons.close, size: 18, color: Colors.grey),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          _questionInput(context, branch, provider),
          const SizedBox(height: 14),
          _buildAnswerUI(
            context,
            gi,
            si,
            bi,
            section.sectionType,
            branch,
            provider,
          ),
          const SizedBox(height: 10),
          _buildBranchFooter(context, gi, si, bi, branch, provider),
        ],
      ),
    );
  }

  Widget _questionInput(
    BuildContext context,
    BranchModel b,
    ExamProvider provider,
  ) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    decoration: BoxDecoration(
      color: AppColors.secondaryTeal(context).withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(15),
    ),
    child: TextField(
      controller: b.questionController,
      textAlign: TextAlign.center,
      onChanged: (_) => provider.markAsUnsaved(),
      decoration: InputDecoration(
        hintText: S.of(context).write_question_hint,
        border: InputBorder.none,
      ),
    ),
  );

  Widget _buildAnswerUI(
    BuildContext context,
    int gi,
    int si,
    int bi,
    String sectionType,
    BranchModel branch,
    ExamProvider provider,
  ) {
    switch (sectionType) {
      case 'mcq':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _answerLabel(
              context,
              S.of(context).mcq_options_label,
              Icons.radio_button_checked,
            ),
            const SizedBox(height: 8),
            ...branch.mcqOptions.asMap().entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: e.value.isCorrect
                        ? AppColors.primaryTeal(context).withValues(alpha: 0.08)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: e.value.isCorrect
                          ? AppColors.primaryTeal(context)
                          : Colors.grey.shade300,
                      width: e.value.isCorrect ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          provider.markAsUnsaved();
                          setState(() {
                            for (final o in branch.mcqOptions)
                              o.isCorrect = false;
                            e.value.isCorrect = true;
                          });
                        },
                        child: Icon(
                          e.value.isCorrect
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: e.value.isCorrect
                              ? AppColors.primaryTeal(context)
                              : Colors.grey,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: e.value.controller,
                          onChanged: (_) => provider.markAsUnsaved(),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      if (branch.mcqOptions.length > 2)
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            provider.markAsUnsaved();
                            setState(() => branch.mcqOptions.removeAt(e.key));
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                provider.markAsUnsaved();
                setState(() => branch.mcqOptions.add(McqOptionModel()));
              },
              icon: Icon(
                Icons.add,
                color: AppColors.primaryTeal(context),
                size: 18,
              ),
              label: Text(
                '+ ${S.of(context).add_option}',
                style: TextStyle(
                  color: AppColors.primaryTeal(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        );

      case 'true_false':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _answerLabel(
              context,
              S.of(context).tf_select_label,
              Icons.check_circle_outline,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _tfToggleBtn(
                    context,
                    provider,
                    label: S.of(context).true_word,
                    selected: branch.tfAnswer == 'true',
                    onTap: () => setState(() => branch.tfAnswer = 'true'),
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _tfToggleBtn(
                    context,
                    provider,
                    label: S.of(context).false_word,
                    selected: branch.tfAnswer == 'false',
                    onTap: () => setState(() => branch.tfAnswer = 'false'),
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        );

      case 'fill_blank':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _answerLabel(
              context,
              S.of(context).fill_blank_hint_label,
              Icons.text_fields_rounded,
            ),
            const SizedBox(height: 8),
            _answerTextField(
              context,
              provider,
              controller: branch.fillBlankAnswerController,
              hint: S.of(context).fill_blank_answer_hint,
              icon: Icons.short_text_rounded,
            ),
          ],
        );

      case 'matching':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _answerLabel(
              context,
              S.of(context).matching_pairs_label,
              Icons.compare_arrows_rounded,
            ),
            const SizedBox(height: 8),
            ...branch.matchingPairs.asMap().entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal(
                          context,
                        ).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${e.key + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryTeal(context),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _answerTextField(
                        context,
                        provider,
                        controller: e.value.termController,
                        hint: S.of(context).matching_term_hint,
                        icon: Icons.looks_one_outlined,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.arrow_forward,
                        color: AppColors.primaryTeal(context),
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: _answerTextField(
                        context,
                        provider,
                        controller: e.value.matchController,
                        hint: S.of(context).matching_match_hint,
                        icon: Icons.looks_two_outlined,
                      ),
                    ),
                    if (branch.matchingPairs.length > 1)
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.grey,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        onPressed: () {
                          provider.markAsUnsaved();
                          setState(() => branch.matchingPairs.removeAt(e.key));
                        },
                      ),
                  ],
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                provider.markAsUnsaved();
                setState(() => branch.matchingPairs.add(MatchingPairModel()));
              },
              icon: Icon(
                Icons.add,
                color: AppColors.primaryTeal(context),
                size: 18,
              ),
              label: Text(
                '+ ${S.of(context).add_matching_pair}',
                style: TextStyle(
                  color: AppColors.primaryTeal(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        );

      case 'essay':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _answerLabel(
              context,
              S.of(context).essay_answer_label,
              Icons.edit_note_rounded,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                controller: branch.essayModelAnswerController,
                onChanged: (_) => provider.markAsUnsaved(),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: S.of(context).essay_model_answer_hint,
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _answerTextField(
              context,
              provider,
              controller: branch.essayKeywordsController,
              hint: S.of(context).essay_keywords_hint,
              icon: Icons.label_outline,
            ),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  Widget _tfToggleBtn(
    BuildContext context,
    ExamProvider provider, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        provider.markAsUnsaved();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.15) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? color : Colors.grey,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? color : AppColors.textSecondary(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _answerLabel(BuildContext context, String text, IconData icon) => Row(
    children: [
      Icon(icon, size: 16, color: AppColors.primaryTeal(context)),
      const SizedBox(width: 6),
      Flexible(
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.primaryTeal(context),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );

  Widget _answerTextField(
    BuildContext context,
    ExamProvider provider, {
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primaryTeal(context)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 13),
              onChanged: (_) => provider.markAsUnsaved(),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 12),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchFooter(
    BuildContext context,
    int gi,
    int si,
    int bi,
    BranchModel branch,
    ExamProvider provider,
  ) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.copy_all, color: Colors.grey, size: 18),
          tooltip: S.of(context).copy_branch_tooltip,
          onPressed: () {
            provider.markAsUnsaved();
            setState(() {
              final copy = BranchModel(
                questionText: branch.questionController.text,
                grade: branch.grade,
                tfAnswer: branch.tfAnswer,
                fillBlankAnswer: branch.fillBlankAnswerController.text,
                essayModelAnswer: branch.essayModelAnswerController.text,
                essayKeywords: branch.essayKeywordsController.text,
                matchingPairs: branch.matchingPairs
                    .map(
                      (p) => MatchingPairModel(
                        term: p.termController.text,
                        match: p.matchController.text,
                      ),
                    )
                    .toList(),
                mcqOptions: branch.mcqOptions
                    .map(
                      (o) => McqOptionModel(
                        text: o.controller.text,
                        isCorrect: o.isCorrect,
                      ),
                    )
                    .toList(),
              );
              provider.groups[gi].sections[si].items.insert(bi + 1, copy);
            });
          },
        ),
        const Spacer(),
        Text(
          '${S.of(context).grade_label} ',
          style: TextStyle(
            color: AppColors.textSecondary(context),
            fontSize: 12,
          ),
        ),
        SizedBox(
          width: 40,
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: AppColors.primaryTeal(context),
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
            controller:
                TextEditingController(text: branch.grade.toStringAsFixed(0))
                  ..selection = TextSelection.collapsed(
                    offset: branch.grade.toStringAsFixed(0).length,
                  ),
            onChanged: (v) {
              provider.markAsUnsaved();
              setState(() => branch.grade = double.tryParse(v) ?? 0);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
    bool isLight = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isLight
              ? AppColors.primaryTeal(context).withValues(alpha: 0.03)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primaryTeal(context).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.primaryTeal(context), size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: AppColors.primaryTeal(context),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterButtons(BuildContext context, ExamProvider provider) =>
      Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: provider.isSaving
                  ? null
                  : () async {
                      bool success = await provider.saveExam(
                        context,
                        isDraft: false,
                      );
                      if (success && mounted) Navigator.pop(context, true);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal(context),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: provider.isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      S.of(context).save_and_approve,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: OutlinedButton(
              onPressed: provider.isSaving
                  ? null
                  : () async {
                      bool success = await provider.saveExam(
                        context,
                        isDraft: true,
                      );
                      if (success && mounted) Navigator.pop(context, true);
                    },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                side: BorderSide(color: AppColors.primaryTeal(context)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                S.of(context).save_as_draft,
                style: TextStyle(color: AppColors.primaryTeal(context)),
              ),
            ),
          ),
        ],
      );

  Future<void> _selectDate(ExamProvider provider) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryTeal(context),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      provider.dateController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      provider.markAsUnsaved();
    }
  }

  void _showTimeLimitDialog(ExamProvider provider) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      pageBuilder: (ctx, anim1, anim2) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(30),
              width: 420,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ),
                  Text(
                    S.of(context).write_time_limit,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                              initialItem: provider.selectedHours,
                            ),
                            itemExtent: 40,
                            onSelectedItemChanged: (int value) =>
                                provider.selectedHours = value,
                            children: List.generate(
                              24,
                              (index) => Center(
                                child: Text(
                                  '$index  ${S.of(context).hour_word}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.textPrimary(context),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          ':',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                              initialItem: provider.selectedMinutes,
                            ),
                            itemExtent: 40,
                            onSelectedItemChanged: (int value) =>
                                provider.selectedMinutes = value,
                            children: List.generate(
                              60,
                              (index) => Center(
                                child: Text(
                                  '$index  ${S.of(context).minute_word}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.textPrimary(context),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              provider.totalDurationMinutes =
                                  (provider.selectedHours * 60) +
                                  provider.selectedMinutes;
                              String formattedTime = '';
                              if (provider.selectedHours > 0)
                                formattedTime +=
                                    '${provider.selectedHours} ${S.of(context).hour_word}';
                              if (provider.selectedMinutes > 0 ||
                                  provider.selectedHours == 0) {
                                if (formattedTime.isNotEmpty)
                                  formattedTime += ' ';
                                formattedTime +=
                                    '${provider.selectedMinutes} ${S.of(context).minute_word}';
                              }
                              provider.timeLimitController.text = formattedTime;
                              provider.markAsUnsaved();
                            });
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal(context),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            S.of(context).confirm,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB35A5A),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            S.of(context).cancel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
