import 'package:grade/core/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizDetailsProvider extends ChangeNotifier {
  bool isEditingMode = false;
  bool isSaving = false;

  // البيانات الأساسية للاختبار
  int? folderId;
  String? examTitle;
  String? examDate;

  // إحصائيات الذكاء الاصطناعي
  int totalQuestions = 0;
  double totalGrade = 0.0;
  double aiAccuracy = 98.5;
  List<String> aiKeywords = [];
  
  // قائمة الأسئلة الفعلية
  List<Map<String, dynamic>> questions = [];

  // ==========================================
  // 1. تهيئة البيانات عند فتح الصفحة
  // ==========================================
  void initData(Map<String, dynamic>? data, int? fId, String? title, String? date) {
    folderId = fId;
    examTitle = title;
    examDate = date;

    if (data != null) {
      totalQuestions = data['total_questions'] ?? 0;
      totalGrade = (data['total_grade'] ?? 0).toDouble();
      aiAccuracy = (data['ai_accuracy'] ?? 98.5).toDouble();

      if (data['keywords'] != null) {
        aiKeywords = List<String>.from(data['keywords']);
      }

      if (data['questions'] != null) {
        // تحويل الأسئلة إلى قائمة قابلة للتعديل
        questions = List<Map<String, dynamic>>.from(data['questions']);
      }
    }
  }

  // ==========================================
  // 2. تفعيل / إيقاف وضع التعديل
  // ==========================================
  void toggleEditingMode() {
    isEditingMode = !isEditingMode;
    notifyListeners();
  }

  // ==========================================
  // 3. تحديث نصوص الأسئلة والإجابات
  // ==========================================
  void updateQuestionText(int index, String newText) {
    questions[index]['question_text'] = newText;
  }

  void updateModelAnswer(int index, String newAnswer) {
    questions[index]['model_answer'] = newAnswer;
  }

  // ==========================================
  // 4. حفظ الاختبار النهائي في الداتابيس
  // ==========================================
  Future<void> saveExamToDatabase(BuildContext context) async {
    isSaving = true;
    notifyListeners();

    try {
      final url = Uri.parse('${AppConfig.baseUrl}/teacher/quiz/save');
      // final url = Uri.parse('${AppConfig.baseUrl}/teacher/ai-exam/save');
      
      // تجهيز البيانات كما يطلبها الباك إند (SaveExamRequest)
      final payload = {
        "exam_title": examTitle ?? "اختبار بدون عنوان",
        "exam_date": examDate,
        "folder_id": folderId ?? 0,
        "total_marks": totalGrade,
        "passing_mark": totalGrade * 0.5, // درجة النجاح الافتراضية
        "allowed_time": "ساعة واحدة",
        "questions": questions
      };

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        isSaving = false;
        notifyListeners();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حفظ الاختبار واعتماده بنجاح! ✅'), backgroundColor: Colors.green),
          );
          // هنا يمكنك إضافة كود العودة لصفحة إدارة الاختبارات
          // Navigator.pop(context); 
        }
      } else {
        final err = json.decode(utf8.decode(response.bodyBytes));
        isSaving = false;
        notifyListeners();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err['detail'] ?? 'فشل الحفظ'), backgroundColor: Colors.redAccent),
          );
        }
      }
    } catch (e) {
      isSaving = false;
      notifyListeners();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في الاتصال: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }
}