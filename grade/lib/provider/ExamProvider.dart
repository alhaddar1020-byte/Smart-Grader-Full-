// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../generated/l10n.dart';

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
// // مزود الحالة (Provider)
// // ══════════════════════════════════════════════════════════════

// class ExamProvider extends ChangeNotifier {
//   int? currentExamId;
//   bool isExamSaved = true;
//   bool isSaving = false;
//   bool isLoadingCourses = true;
//   bool isReadOnlyMode = false;
//   ExamContext? examContext;

//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController timeLimitController = TextEditingController();
//   final TextEditingController specializationController =
//       TextEditingController();
//   final TextEditingController levelController = TextEditingController();
//   final TextEditingController folderController = TextEditingController();

//   List<QuestionGroupModel> groups = [QuestionGroupModel()];
//   List<CourseModel> myCourses = [];
//   CourseModel? selectedCourse;
//   FolderModel? selectedFolder;

//   int selectedHours = 1;
//   int selectedMinutes = 0;
//   int? totalDurationMinutes;

//   void markAsUnsaved() {
//     if (isExamSaved) {
//       isExamSaved = false;
//       notifyListeners();
//     }
//   }

//   Future<void> initData(
//     BuildContext context,
//     ExamContext? ctx,
//     int? examId,
//   ) async {
//     examContext = ctx;
//     currentExamId = examId;
//     isReadOnlyMode = ctx != null && ctx.isComplete;

//     if (isReadOnlyMode) {
//       isLoadingCourses = false;
//       specializationController.text = ctx!.specialization ?? '';
//       levelController.text = ctx.levelName ?? '';
//       folderController.text = ctx.folderName ?? '';

//       if (currentExamId != null) {
//         await loadExamDetails(context, currentExamId!);
//       } else {
//         notifyListeners();
//       }
//     } else {
//       await fetchCoursesFromDatabase(context);
//       if (currentExamId != null) {
//         await loadExamDetails(context, currentExamId!);
//       }
//     }
//   }

//   Future<void> fetchCoursesFromDatabase(BuildContext context) async {
//     try {
//       final response = await http.get(
//         Uri.parse('http://localhost:8000/api/exams/teacher/1/courses-dropdown'),
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         myCourses = data.map((json) {
//           final foldersList = (json['folders'] as List<dynamic>?) ?? [];
//           return CourseModel(
//             id: json['id'] ?? 0,
//             name: json['name'] ?? S.of(context).untitled_exam,
//             specialization: json['specialization'] ?? '',
//             level: json['level'] ?? '',
//             folders: foldersList
//                 .map((f) => FolderModel(id: f['id'], name: f['name']))
//                 .toList(),
//           );
//         }).toList();
//         isLoadingCourses = false;
//         notifyListeners();
//       } else {
//         isLoadingCourses = false;
//         notifyListeners();
//       }
//     } catch (e) {
//       isLoadingCourses = false;
//       notifyListeners();
//     }
//   }

//   Future<void> loadExamDetails(BuildContext context, int examId) async {
//     isSaving = true;
//     notifyListeners();
//     try {
//       final response = await http.get(
//         Uri.parse('http://localhost:8000/api/exams/get-full-exam/$examId'),
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(utf8.decode(response.bodyBytes));
//         titleController.text = data['exam_title'] ?? '';
//         dateController.text = data['exam_date'] ?? '';
//         String? rawTime = data['time_limit']?.toString();

//         if (rawTime != null && rawTime.isNotEmpty && rawTime != '0') {
//           totalDurationMinutes = int.tryParse(
//             rawTime.replaceAll(RegExp(r'[^0-9]'), ''),
//           );
//           if (totalDurationMinutes != null) {
//             int h = totalDurationMinutes! ~/ 60;
//             int m = totalDurationMinutes! % 60;
//             String formatted = '';
//             if (h > 0) formatted += '$h ${S.of(context).hour_word}';
//             if (m > 0 || h == 0) {
//               if (formatted.isNotEmpty) formatted += ' ';
//               formatted += '$m ${S.of(context).minute_word}';
//             }
//             timeLimitController.text = formatted;
//           }
//         }

//         if (!isReadOnlyMode) {
//           int loadedFolderId = data['folder_id'];
//           for (var c in myCourses) {
//             for (var f in c.folders) {
//               if (f.id == loadedFolderId) {
//                 selectedCourse = c;
//                 selectedFolder = f;
//                 specializationController.text = c.specialization;
//                 levelController.text = c.level;
//                 break;
//               }
//             }
//           }
//         }

//         if (data['question_groups'] != null) {
//           groups.clear();
//           for (var g in data['question_groups']) {
//             var newGroup = QuestionGroupModel(
//               title: g['group_title'] ?? '',
//               numberingStyle: g['group_numbering_style'] ?? 'numbers',
//               sections: [],
//             );
//             for (var s in g['sections']) {
//               var newSection = QuestionSectionModel(
//                 title: s['section_title'] ?? '',
//                 sectionType: s['section_type'] ?? 'mcq',
//                 numberingStyle: s['section_numbering_style'] ?? 'letters_ar',
//                 items: [],
//               );
//               for (var b in s['items']) {
//                 var newBranch = BranchModel(
//                   questionText: b['question_text'] ?? '',
//                   grade: (b['question_mark'] ?? 0).toDouble(),
//                   numberingStyle: b['question_numbering_style'] ?? 'numbers',
//                 );

//                 if (newSection.sectionType == 'mcq' &&
//                     b['mcq_options'] != null) {
//                   newBranch.mcqOptions.clear();
//                   for (var opt in b['mcq_options']) {
//                     newBranch.mcqOptions.add(
//                       McqOptionModel(
//                         text: opt['option_text'] ?? '',
//                         isCorrect: opt['is_correct'] ?? false,
//                       ),
//                     );
//                   }
//                 } else if (newSection.sectionType == 'true_false' &&
//                     b['true_false_answer'] != null) {
//                   newBranch.tfAnswer = b['true_false_answer']['correct_answer'];
//                 } else if (newSection.sectionType == 'fill_blank' &&
//                     b['fill_blank_answer'] != null) {
//                   newBranch.fillBlankAnswerController.text =
//                       b['fill_blank_answer']['correct_word'] ?? '';
//                 } else if (newSection.sectionType == 'matching' &&
//                     b['matching_pairs'] != null) {
//                   newBranch.matchingPairs.clear();
//                   for (var pair in b['matching_pairs']) {
//                     newBranch.matchingPairs.add(
//                       MatchingPairModel(
//                         term: pair['term'] ?? '',
//                         match: pair['match'] ?? '',
//                       ),
//                     );
//                   }
//                 } else if (newSection.sectionType == 'essay' &&
//                     b['essay_answer'] != null) {
//                   newBranch.essayModelAnswerController.text =
//                       b['essay_answer']['model_answer'] ?? '';
//                   newBranch.essayKeywordsController.text =
//                       b['essay_answer']['keywords'] ?? '';
//                 }
//                 newSection.items.add(newBranch);
//               }
//               newGroup.sections.add(newSection);
//             }
//             groups.add(newGroup);
//           }
//         }
//         isExamSaved = true;
//       }
//     } finally {
//       isSaving = false;
//       notifyListeners();
//     }
//   }

//   double getTotalGrade() {
//     double total = 0;
//     for (final g in groups) {
//       for (final s in g.sections) {
//         for (final b in s.items) {
//           total += b.grade;
//         }
//       }
//     }
//     return total;
//   }

//   int get effectiveFolderId {
//     if (isReadOnlyMode) return examContext!.folderId ?? 1;
//     if (selectedFolder != null) return selectedFolder!.id;
//     if (selectedCourse != null && selectedCourse!.folders.isNotEmpty)
//       return selectedCourse!.folders.first.id;
//     if (myCourses.isNotEmpty && myCourses.first.folders.isNotEmpty)
//       return myCourses.first.folders.first.id;
//     return 1;
//   }

//   String? getValidationError(BuildContext context) {
//     if (titleController.text.trim().isEmpty)
//       return S.of(context).err_exam_title;
//     if (dateController.text.trim().isEmpty) return S.of(context).err_exam_date;
//     if (!isReadOnlyMode && selectedCourse == null)
//       return S.of(context).err_exam_course;
//     if (!isReadOnlyMode && selectedFolder == null)
//       return S.of(context).err_exam_folder;
//     if (totalDurationMinutes == null || totalDurationMinutes == 0)
//       return S.of(context).err_empty_time_limit;

//     bool hasQuestions = false;
//     for (var group in groups) {
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

//   Future<bool> saveExam(BuildContext context, {bool isDraft = false}) async {
//     if (!isDraft) {
//       String? errorMessage = getValidationError(context);
//       if (errorMessage != null) {
//         _showSnackbar(context, errorMessage, isError: true);
//         return false;
//       }
//     } else {
//       if (titleController.text.trim().isEmpty) {
//         titleController.text = S.of(context).untitled_exam;
//       }
//     }

//     isSaving = true;
//     notifyListeners();

//     try {
//       final groupsJson = groups.asMap().entries.map((gEntry) {
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
//         if (currentExamId != null) 'exam_id': currentExamId,
//         'exam_title': titleController.text.trim(),
//         'exam_date': dateController.text.trim().isNotEmpty
//             ? dateController.text.trim()
//             : DateTime.now().toIso8601String().substring(0, 10),
//         'time_limit': totalDurationMinutes?.toString() ?? '',
//         'folder_id': effectiveFolderId,
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

//       isSaving = false;
//       notifyListeners();

//       if (response.statusCode == 201 || response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         currentExamId = responseData['exam_id'];
//         isExamSaved = true;
//         notifyListeners();
//         return true;
//       } else {
//         final err = jsonDecode(response.body);
//         _showSnackbar(
//           context,
//           '${S.of(context).error_prefix} ${err['detail'] ?? response.body}',
//           isError: true,
//         );
//         return false;
//       }
//     } catch (e) {
//       isSaving = false;
//       notifyListeners();
//       _showSnackbar(
//         context,
//         '${S.of(context).connection_error} $e',
//         isError: true,
//       );
//       return false;
//     }
//   }

//   void _showSnackbar(BuildContext context, String msg, {bool isError = false}) {
//     if (!context.mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: isError
//             ? Colors.red.shade700
//             : const Color(0xFF00796B),
//       ),
//     );
//   }

//   // دوال الإضافة والحذف للـ UI
//   void addGroup() {
//     String currentStyle = groups.isNotEmpty
//         ? groups.first.numberingStyle
//         : 'numbers';
//     groups.add(QuestionGroupModel(numberingStyle: currentStyle));
//     markAsUnsaved();
//   }

//   void removeGroup(int gi) {
//     groups.removeAt(gi);
//     markAsUnsaved();
//   }

//   void updateCourseSelection(CourseModel? course) {
//     selectedCourse = course;
//     selectedFolder = null;
//     specializationController.text = course?.specialization ?? '';
//     levelController.text = course?.level ?? '';
//     markAsUnsaved();
//   }
// }

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../generated/l10n.dart';
import 'package:grade/core/app_config.dart';

// ══════════════════════════════════════════════════════════════
// نماذج البيانات (Data Models)
// ══════════════════════════════════════════════════════════════

class McqOptionModel {
  TextEditingController controller;
  bool isCorrect;
  McqOptionModel({String text = '', this.isCorrect = false})
    : controller = TextEditingController(text: text);
}

class MatchingPairModel {
  TextEditingController termController;
  TextEditingController matchController;
  MatchingPairModel({String term = '', String match = ''})
    : termController = TextEditingController(text: term),
      matchController = TextEditingController(text: match);
}

class BranchModel {
  TextEditingController questionController;
  double grade;
  List<McqOptionModel> mcqOptions;
  String? tfAnswer;
  TextEditingController fillBlankAnswerController;
  List<MatchingPairModel> matchingPairs;
  TextEditingController essayModelAnswerController;
  TextEditingController essayKeywordsController;
  String numberingStyle;

  BranchModel({
    this.numberingStyle = 'numbers',
    String questionText = '',
    this.grade = 5,
    List<McqOptionModel>? mcqOptions,
    this.tfAnswer,
    String fillBlankAnswer = '',
    List<MatchingPairModel>? matchingPairs,
    String essayModelAnswer = '',
    String essayKeywords = '',
  }) : questionController = TextEditingController(text: questionText),
       fillBlankAnswerController = TextEditingController(text: fillBlankAnswer),
       essayModelAnswerController = TextEditingController(
         text: essayModelAnswer,
       ),
       essayKeywordsController = TextEditingController(text: essayKeywords),
       mcqOptions = mcqOptions ?? [McqOptionModel(), McqOptionModel()],
       matchingPairs = matchingPairs ?? [MatchingPairModel()];
}

class QuestionSectionModel {
  String sectionType;
  TextEditingController titleController;
  List<BranchModel> items;
  String numberingStyle;

  QuestionSectionModel({
    this.numberingStyle = 'letters_ar',
    this.sectionType = 'mcq',
    String title = '',
    List<BranchModel>? items,
  }) : titleController = TextEditingController(text: title),
       items = items ?? [BranchModel()];
}

class QuestionGroupModel {
  TextEditingController titleController;
  List<QuestionSectionModel> sections;
  String numberingStyle;

  QuestionGroupModel({
    this.numberingStyle = 'numbers',
    String title = '',
    List<QuestionSectionModel>? sections,
  }) : titleController = TextEditingController(text: title),
       sections = sections ?? [QuestionSectionModel()];
}

class ExamContext {
  final int? courseId;
  final String? courseName;
  final String? specialization;
  final String? levelName;
  final int? folderId;
  final String? folderName;

  const ExamContext({
    this.courseId,
    this.courseName,
    this.specialization,
    this.levelName,
    this.folderId,
    this.folderName,
  });

  bool get isComplete =>
      courseId != null &&
      courseName != null &&
      folderId != null &&
      folderName != null;
}

class FolderModel {
  final int id;
  final String name;
  FolderModel({required this.id, required this.name});
}

class CourseModel {
  final int id;
  final String name;
  final String specialization;
  final String level;
  final List<FolderModel> folders;

  const CourseModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.level,
    required this.folders,
  });
}

// ══════════════════════════════════════════════════════════════
// مزود الحالة (Provider)
// ══════════════════════════════════════════════════════════════

class ExamProvider extends ChangeNotifier {
  int? currentExamId;
  bool isExamSaved = true;
  bool isSaving = false;
  bool isLoadingCourses = true;
  bool isReadOnlyMode = false;
  ExamContext? examContext;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeLimitController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController folderController = TextEditingController();

  List<QuestionGroupModel> groups = [QuestionGroupModel()];
  List<CourseModel> myCourses = [];
  CourseModel? selectedCourse;
  FolderModel? selectedFolder;

  int selectedHours = 1;
  int selectedMinutes = 0;
  int? totalDurationMinutes;

  void markAsUnsaved() {
    if (isExamSaved) {
      isExamSaved = false;
      notifyListeners();
    }
  }

  Future<void> initData(
    BuildContext context,
    ExamContext? ctx,
    int? examId,
  ) async {
    examContext = ctx;
    currentExamId = examId;
    isReadOnlyMode = ctx != null && ctx.isComplete;

    if (isReadOnlyMode) {
      isLoadingCourses = false;
      specializationController.text = ctx!.specialization ?? '';
      levelController.text = ctx.levelName ?? '';
      folderController.text = ctx.folderName ?? '';

      if (currentExamId != null) {
        await loadExamDetails(context, currentExamId!);
      } else {
        notifyListeners();
      }
    } else {
      await fetchCoursesFromDatabase(context);
      if (currentExamId != null) {
        await loadExamDetails(context, currentExamId!);
      }
    }
  }

  Future<void> fetchCoursesFromDatabase(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/exams/teacher/1/courses-dropdown'),
      );

      final String url = '${AppConfig.baseUrl}؟';

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        myCourses = data.map((json) {
          final foldersList = (json['folders'] as List<dynamic>?) ?? [];
          return CourseModel(
            id: json['id'] ?? 0,
            name: json['name'] ?? S.of(context).untitled_exam,
            specialization: json['specialization'] ?? '',
            level: json['level'] ?? '',
            folders: foldersList
                .map((f) => FolderModel(id: f['id'], name: f['name']))
                .toList(),
          );
        }).toList();
        isLoadingCourses = false;
        notifyListeners();
      } else {
        isLoadingCourses = false;
        notifyListeners();
      }
    } catch (e) {
      isLoadingCourses = false;
      notifyListeners();
    }
  }

  Future<void> loadExamDetails(BuildContext context, int examId) async {
    isSaving = true;
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/exams/get-full-exam/$examId'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        titleController.text = data['exam_title'] ?? '';
        dateController.text = data['exam_date'] ?? '';
        String? rawTime = data['time_limit']?.toString();

        if (rawTime != null && rawTime.isNotEmpty && rawTime != '0') {
          totalDurationMinutes = int.tryParse(
            rawTime.replaceAll(RegExp(r'[^0-9]'), ''),
          );
          if (totalDurationMinutes != null) {
            int h = totalDurationMinutes! ~/ 60;
            int m = totalDurationMinutes! % 60;
            String formatted = '';
            if (h > 0) formatted += '$h ${S.of(context).hour_word}';
            if (m > 0 || h == 0) {
              if (formatted.isNotEmpty) formatted += ' ';
              formatted += '$m ${S.of(context).minute_word}';
            }
            timeLimitController.text = formatted;
          }
        }

        if (!isReadOnlyMode) {
          int loadedFolderId = data['folder_id'];
          for (var c in myCourses) {
            for (var f in c.folders) {
              if (f.id == loadedFolderId) {
                selectedCourse = c;
                selectedFolder = f;
                specializationController.text = c.specialization;
                levelController.text = c.level;
                break;
              }
            }
          }
        }

        if (data['question_groups'] != null) {
          groups.clear();
          for (var g in data['question_groups']) {
            var newGroup = QuestionGroupModel(
              title: g['group_title'] ?? '',
              numberingStyle: g['group_numbering_style'] ?? 'numbers',
              sections: [],
            );
            for (var s in g['sections']) {
              var newSection = QuestionSectionModel(
                title: s['section_title'] ?? '',
                sectionType: s['section_type'] ?? 'mcq',
                numberingStyle: s['section_numbering_style'] ?? 'letters_ar',
                items: [],
              );
              for (var b in s['items']) {
                var newBranch = BranchModel(
                  questionText: b['question_text'] ?? '',
                  grade: (b['question_mark'] ?? 0).toDouble(),
                  numberingStyle: b['question_numbering_style'] ?? 'numbers',
                );

                if (newSection.sectionType == 'mcq' &&
                    b['mcq_options'] != null) {
                  newBranch.mcqOptions.clear();
                  for (var opt in b['mcq_options']) {
                    newBranch.mcqOptions.add(
                      McqOptionModel(
                        text: opt['option_text'] ?? '',
                        isCorrect: opt['is_correct'] ?? false,
                      ),
                    );
                  }
                } else if (newSection.sectionType == 'true_false' &&
                    b['true_false_answer'] != null) {
                  newBranch.tfAnswer = b['true_false_answer']['correct_answer'];
                } else if (newSection.sectionType == 'fill_blank' &&
                    b['fill_blank_answer'] != null) {
                  newBranch.fillBlankAnswerController.text =
                      b['fill_blank_answer']['correct_word'] ?? '';
                } else if (newSection.sectionType == 'matching' &&
                    b['matching_pairs'] != null) {
                  newBranch.matchingPairs.clear();
                  for (var pair in b['matching_pairs']) {
                    newBranch.matchingPairs.add(
                      MatchingPairModel(
                        term: pair['term'] ?? '',
                        match: pair['match'] ?? '',
                      ),
                    );
                  }
                } else if (newSection.sectionType == 'essay' &&
                    b['essay_answer'] != null) {
                  newBranch.essayModelAnswerController.text =
                      b['essay_answer']['model_answer'] ?? '';
                  newBranch.essayKeywordsController.text =
                      b['essay_answer']['keywords'] ?? '';
                }
                newSection.items.add(newBranch);
              }
              newGroup.sections.add(newSection);
            }
            groups.add(newGroup);
          }
        }
        isExamSaved = true;
      }
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  double getTotalGrade() {
    double total = 0;
    for (final g in groups) {
      for (final s in g.sections) {
        for (final b in s.items) {
          total += b.grade;
        }
      }
    }
    return total;
  }

  int get effectiveFolderId {
    if (isReadOnlyMode) return examContext!.folderId ?? 1;
    if (selectedFolder != null) return selectedFolder!.id;
    if (selectedCourse != null && selectedCourse!.folders.isNotEmpty)
      return selectedCourse!.folders.first.id;
    if (myCourses.isNotEmpty && myCourses.first.folders.isNotEmpty)
      return myCourses.first.folders.first.id;
    return 1;
  }

  String? getValidationError(BuildContext context) {
    if (titleController.text.trim().isEmpty)
      return S.of(context).err_exam_title;
    if (dateController.text.trim().isEmpty) return S.of(context).err_exam_date;
    if (!isReadOnlyMode && selectedCourse == null)
      return S.of(context).err_exam_course;
    if (!isReadOnlyMode && selectedFolder == null)
      return S.of(context).err_exam_folder;
    if (totalDurationMinutes == null || totalDurationMinutes == 0)
      return S.of(context).err_empty_time_limit;

    bool hasQuestions = false;
    for (var group in groups) {
      for (var section in group.sections) {
        for (var branch in section.items) {
          hasQuestions = true;
          if (branch.questionController.text.trim().isEmpty)
            return S.of(context).err_empty_question;
          if (branch.grade <= 0) return S.of(context).err_zero_grade;

          switch (section.sectionType) {
            case 'mcq':
              if (branch.mcqOptions.every((o) => !o.isCorrect))
                return S.of(context).err_no_correct_mcq;
              break;
            case 'true_false':
              if (branch.tfAnswer == null)
                return S.of(context).err_no_tf_answer;
              break;
            case 'fill_blank':
              if (branch.fillBlankAnswerController.text.trim().isEmpty)
                return S.of(context).err_empty_fill_blank;
              break;
            case 'matching':
              if (branch.matchingPairs.any(
                (p) =>
                    p.termController.text.trim().isEmpty ||
                    p.matchController.text.trim().isEmpty,
              ))
                return S.of(context).err_empty_matching;
              break;
            case 'essay':
              if (branch.essayModelAnswerController.text.trim().isEmpty)
                return S.of(context).err_empty_essay;
              break;
          }
        }
      }
    }
    if (!hasQuestions) return S.of(context).err_empty_exam;
    return null;
  }

  Future<bool> saveExam(BuildContext context, {bool isDraft = false}) async {
    if (!isDraft) {
      String? errorMessage = getValidationError(context);
      if (errorMessage != null) {
        _showSnackbar(context, errorMessage, isError: true);
        return false;
      }
    } else {
      if (titleController.text.trim().isEmpty) {
        titleController.text = S.of(context).untitled_exam;
      }
    }

    isSaving = true;
    notifyListeners();

    try {
      final groupsJson = groups.asMap().entries.map((gEntry) {
        final gi = gEntry.key;
        final g = gEntry.value;
        final sectionsJson = g.sections.asMap().entries.map((sEntry) {
          final si = sEntry.key;
          final s = sEntry.value;
          final branchesJson = s.items.asMap().entries.map((bEntry) {
            final bi = bEntry.key;
            final b = bEntry.value;
            final Map<String, dynamic> branchMap = {
              'question_text': b.questionController.text.trim(),
              'question_mark': b.grade,
              'question_order': bi + 1,
              'question_numbering_style': b.numberingStyle,
            };
            switch (s.sectionType) {
              case 'mcq':
                branchMap['mcq_options'] = b.mcqOptions
                    .map(
                      (o) => {
                        'option_text': o.controller.text.trim(),
                        'is_correct': o.isCorrect,
                      },
                    )
                    .toList();
                break;
              case 'true_false':
                if (b.tfAnswer != null)
                  branchMap['true_false_answer'] = {
                    'correct_answer': b.tfAnswer,
                  };
                break;
              case 'fill_blank':
                branchMap['fill_blank_answer'] = {
                  'correct_word': b.fillBlankAnswerController.text.trim(),
                };
                break;
              case 'matching':
                branchMap['matching_pairs'] = b.matchingPairs
                    .map(
                      (p) => {
                        'term': p.termController.text.trim(),
                        'match': p.matchController.text.trim(),
                      },
                    )
                    .toList();
                break;
              case 'essay':
                branchMap['essay_answer'] = {
                  'model_answer': b.essayModelAnswerController.text.trim(),
                  'keywords': b.essayKeywordsController.text.trim(),
                };
                break;
            }
            return branchMap;
          }).toList();
          return {
            'section_title': s.titleController.text.trim(),
            'section_type': s.sectionType,
            'section_order': si + 1,
            'section_numbering_style': s.numberingStyle,
            'items': branchesJson,
          };
        }).toList();
        return {
          'group_title': g.titleController.text.trim(),
          'group_order': gi + 1,
          'group_numbering_style': g.numberingStyle,
          'sections': sectionsJson,
        };
      }).toList();

      final body = jsonEncode({
        if (currentExamId != null) 'exam_id': currentExamId,
        'exam_title': titleController.text.trim(),
        'exam_date': dateController.text.trim().isNotEmpty
            ? dateController.text.trim()
            : DateTime.now().toIso8601String().substring(0, 10),
        'time_limit': totalDurationMinutes?.toString() ?? '',
        'folder_id': effectiveFolderId,
        'question_groups': groupsJson,
        'status': isDraft ? 'Draft' : 'Published',
        'exam_type': 'manual',
      });

      final response = await http
          .post(
            Uri.parse('http://localhost:8000/api/exams/create-full-exam'),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 15));

      isSaving = false;
      notifyListeners();

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        currentExamId = responseData['exam_id'];
        isExamSaved = true;
        notifyListeners();
        return true;
      } else {
        final err = jsonDecode(response.body);
        _showSnackbar(
          context,
          '${S.of(context).error_prefix} ${err['detail'] ?? response.body}',
          isError: true,
        );
        return false;
      }
    } catch (e) {
      isSaving = false;
      notifyListeners();
      _showSnackbar(
        context,
        '${S.of(context).connection_error} $e',
        isError: true,
      );
      return false;
    }
  }

  void _showSnackbar(BuildContext context, String msg, {bool isError = false}) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError
            ? Colors.red.shade700
            : const Color(0xFF00796B),
      ),
    );
  }

  // دوال الإضافة والحذف للـ UI
  void addGroup() {
    String currentStyle = groups.isNotEmpty
        ? groups.first.numberingStyle
        : 'numbers';
    groups.add(QuestionGroupModel(numberingStyle: currentStyle));
    markAsUnsaved();
  }

  void removeGroup(int gi) {
    groups.removeAt(gi);
    markAsUnsaved();
  }

  void updateCourseSelection(CourseModel? course) {
    selectedCourse = course;
    selectedFolder = null;
    specializationController.text = course?.specialization ?? '';
    levelController.text = course?.level ?? '';
    markAsUnsaved();
  }
}
