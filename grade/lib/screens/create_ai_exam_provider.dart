import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_config.dart';
import 'create_electronic_exam.dart' show ExamContext, CourseModel, FolderModel;
import '../generated/l10n.dart';
import '../provider/ExamProvider.dart';

class CreateAIExamProvider extends ChangeNotifier {
  bool isLoadingContext = true;
  ExamContext? folderContext;

  List<CourseModel> myCourses = [];
  CourseModel? selectedCourse;
  FolderModel? selectedFolder;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController gradeController = TextEditingController(
    text: '100',
  );
  final TextEditingController studentsController = TextEditingController(
    text: '0',
  );

  int totalQuestions = 25;
  double mcqCount = 10;
  double tfCount = 5;
  double essayCount = 5;
  double matchCount = 5;
  double fillCount = 0;

  String selectedDifficultyKey = 'MEDIUM';
  List<PlatformFile> uploadedFiles = [];
  bool isLoading = false;

  void initWithContext(ExamContext? context) {
    if (context != null && context.isComplete) {
      folderContext = context;
      isLoadingContext = false;
      notifyListeners();
    } else {
      _fetchCoursesFromDatabase();
    }
  }

  Future<void> _fetchCoursesFromDatabase() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/exams/teacher/1/courses-dropdown'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        myCourses = data.map((json) {
          final foldersList = (json['folders'] as List<dynamic>?) ?? [];
          return CourseModel(
            id: json['id'] ?? 0,
            name: json['name'] ?? 'بدون اسم',
            specialization: json['specialization'] ?? '',
            level: json['level'] ?? '',
            folders: foldersList
                .map((f) => FolderModel(id: f['id'], name: f['name']))
                .toList(),
          );
        }).toList();
      }
    } catch (e) {
      debugPrint("Error fetching courses: $e");
    } finally {
      isLoadingContext = false;
      notifyListeners();
    }
  }

  void selectCourse(CourseModel course) {
    selectedCourse = course;
    selectedFolder = null;
    notifyListeners();
  }

  void selectFolder(FolderModel folder) {
    selectedFolder = folder;
    notifyListeners();
  }

  double get currentSum =>
      mcqCount + tfCount + essayCount + matchCount + fillCount;
  bool get isDistributionValid => currentSum.toInt() == totalQuestions;

  void decrementTotal() {
    if (totalQuestions > 1) {
      totalQuestions--;
      _adjustSlidersToTotal();
      notifyListeners();
    }
  }

  void incrementTotal() {
    totalQuestions++;
    notifyListeners();
  }

  void setDate(String date) {
    dateController.text = date;
    notifyListeners();
  }

  void updateSliderValue(double val, int type) {
    double oldVal = 0;
    switch (type) {
      case 1:
        oldVal = mcqCount;
        break;
      case 2:
        oldVal = tfCount;
        break;
      case 3:
        oldVal = essayCount;
        break;
      case 4:
        oldVal = matchCount;
        break;
      case 5:
        oldVal = fillCount;
        break;
    }

    double diff = val - oldVal;
    if (diff > 0 && currentSum + diff > totalQuestions) {
      val = oldVal + (totalQuestions - currentSum);
    }

    switch (type) {
      case 1:
        mcqCount = val;
        break;
      case 2:
        tfCount = val;
        break;
      case 3:
        essayCount = val;
        break;
      case 4:
        matchCount = val;
        break;
      case 5:
        fillCount = val;
        break;
    }
    notifyListeners();
  }

  void updateDifficulty(String key) {
    selectedDifficultyKey = key;
    notifyListeners();
  }

  Future<void> pickFiles(BuildContext context, String errorStr) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
        withData: kIsWeb,
      );
      if (result != null) {
        uploadedFiles.addAll(result.files);
        notifyListeners();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorStr), backgroundColor: Colors.red),
      );
    }
  }

  void removeFile(int index) {
    uploadedFiles.removeAt(index);
    notifyListeners();
  }

  void _adjustSlidersToTotal() {
    if (currentSum > totalQuestions) {
      mcqCount = 0;
      tfCount = 0;
      essayCount = 0;
      matchCount = 0;
      fillCount = 0;
    }
  }

  int get _effectiveFolderId {
    if (folderContext != null && folderContext!.isComplete)
      return folderContext!.folderId ?? 1;
    if (selectedFolder != null) return selectedFolder!.id;
    return 1;
  }

  Future<void> generateExamWithAI(
    BuildContext context,
    String distErr,
    String titleErr,
  ) async {
    if (!isDistributionValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(distErr), backgroundColor: Colors.redAccent),
      );
      return;
    }

    if (folderContext == null && selectedFolder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار المادة والمجلد أولاً'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final uri = Uri.parse('${AppConfig.baseUrl}/teacher/ai-exam/generate');
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['folder_id'] = _effectiveFolderId.toString();
      request.fields['exam_title'] = titleController.text;
      request.fields['exam_date'] = dateController.text;
      request.fields['total_grade'] = gradeController.text.isNotEmpty
          ? gradeController.text
          : '100';
      request.fields['students_count'] = studentsController.text.isNotEmpty
          ? studentsController.text
          : '0';
      request.fields['total_questions'] = totalQuestions.toString();
      request.fields['mcq_count'] = mcqCount.toInt().toString();
      request.fields['tf_count'] = tfCount.toInt().toString();
      request.fields['essay_count'] = essayCount.toInt().toString();
      request.fields['match_count'] = matchCount.toInt().toString();
      request.fields['fill_count'] = fillCount.toInt().toString();
      request.fields['difficulty'] = selectedDifficultyKey;

      for (var file in uploadedFiles) {
        if (kIsWeb) {
          if (file.bytes != null) {
            request.files.add(
              http.MultipartFile.fromBytes(
                'files',
                file.bytes!,
                filename: file.name,
              ),
            );
          }
        } else {
          if (file.path != null) {
            request.files.add(
              await http.MultipartFile.fromPath('files', file.path!),
            );
          }
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['success'] == true) {
          _saveGeneratedExam(context, data);
        } else {
          _showError(context, data['message'] ?? 'حدث خطأ غير معروف');
        }
      } else {
        try {
          final data = jsonDecode(utf8.decode(response.bodyBytes));
          _showError(
            context,
            data['detail'] ??
                data['message'] ??
                'حدث خطأ أثناء الاتصال بالخادم',
          );
        } catch (_) {
          _showError(context, 'حدث خطأ أثناء الاتصال بالخادم');
        }
      }
    } catch (e) {
      _showError(context, e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveGeneratedExam(
    BuildContext context,
    Map<String, dynamic> aiResponse,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final saveUri = Uri.parse('${AppConfig.baseUrl}/teacher/ai-exam/save');
      final body = {
        'folder_id': _effectiveFolderId,
        'exam_title': titleController.text.isNotEmpty
            ? titleController.text
            : aiResponse['exam_title'],
        'exam_date': dateController.text,
        'questions': aiResponse['questions'],
        'allowed_time': '60 min',
      };

      final response = await http.post(
        saveUri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم إنشاء وحفظ الاختبار بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
          // TODO: Navigate to review screen or management screen.
        } else {
          _showError(context, data['message'] ?? 'فشل حفظ الاختبار');
        }
      } else {
        _showError(context, 'خطأ أثناء الحفظ');
      }
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }
}
