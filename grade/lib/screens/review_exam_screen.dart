import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/colors.dart';
import '../generated/l10n.dart';
import 'teacher_dashboard.dart';
import 'teacher_matearial.dart' hide HeaderWidget;
import 'grading.dart' hide HeaderWidget;
import 'ExamManagementPage.dart';
import 'teacer_setting.dart';

class StudentResultData {
  final int sheetId;
  final int studentId;
  final String studentName;
  final String status;
  bool isPublished;
  double totalScore;
  final List<QuestionResultData> questions;

  StudentResultData({
    required this.sheetId,
    required this.studentId,
    required this.studentName,
    required this.status,
    required this.isPublished,
    required this.totalScore,
    required this.questions,
  });

  factory StudentResultData.fromJson(Map<String, dynamic> json) {
    var qList = json['questions'] as List? ?? [];
    List<QuestionResultData> parsedQuestions =
        qList.map((q) => QuestionResultData.fromJson(q)).toList();

    return StudentResultData(
      sheetId: json['sheet_id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      studentName: json['student_name'] ?? "طالب غير معروف",
      status: json['status'] ?? "Pending",
      // isPublished: json['is_published'] ?? false,
      isPublished: json['is_published'] ?? false,
      totalScore: (json['total_score'] as num? ?? 0).toDouble(),
      questions: parsedQuestions,
    );
  }
}

class QuestionResultData {
  final int questionId;
  final int questionOrder;
  final String questionText;
  final double maxMark;
  final String extractedText;
  final String modelAnswer;
  final double aiMark;
  double? teacherMark;
  double finalMark;
  final String aiFeedback;
  final double confidence;

  QuestionResultData({
    required this.questionId,
    required this.questionOrder,
    required this.questionText,
    required this.maxMark,
    required this.extractedText,
    required this.modelAnswer,
    required this.aiMark,
    this.teacherMark,
    required this.finalMark,
    required this.aiFeedback,
    required this.confidence,
  });

  factory QuestionResultData.fromJson(Map<String, dynamic> json) {
    return QuestionResultData(
      questionId: json['question_id'] ?? 0,
      questionOrder: json['question_order'] ?? 0,
      questionText: json['question_text'] ?? "",
      maxMark: (json['max_mark'] as num? ?? 0).toDouble(),
      extractedText: json['extracted_text'] ?? "",
      modelAnswer: json['model_answer'] ?? "لا توجد إجابة نموذجية مسجلة في النظام", // 🎯 استقبال الحقل
      aiMark: (json['ai_mark'] as num? ?? 0).toDouble(),
      teacherMark: json['teacher_mark'] != null ? (json['teacher_mark'] as num).toDouble() : null,
      finalMark: (json['final_mark'] as num? ?? 0).toDouble(),
      aiFeedback: json['ai_feedback'] ?? "",
      confidence: (json['confidence'] as num? ?? 1.0).toDouble(),
    );
  }
}

class ReviewExamPage extends StatefulWidget {
  final int examId;

  const ReviewExamPage({super.key, this.examId = 3});

  @override
  State<ReviewExamPage> createState() => _ReviewExamPageState();
}

class _ReviewExamPageState extends State<ReviewExamPage> {
  final int _selectedIndex = 4;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  List<StudentResultData> studentsList = [];
  bool isLoading = true;
  String errorMessage = "";
  
  StudentResultData? selectedStudent; 
  bool isEditing = false;
  bool isSaving = false;


  int? selectedCourseId;
  int? selectedExamId;
  List<Map<String, dynamic>> myCourses = [];
  List<Map<String, dynamic>> courseExams = [];

  // خريطة لتخزين الـ Controllers الخاصة بحقول تعديل درجات الأسئلة بشكل مستقر
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _fetchMyCourses(); // استدعاء المواد عند فتح الصفحة
  }

  @override
  void dispose() {
    // تنظيف الذاكرة التخزينية للـ كونتولرز لمنع الـ Memory Leak
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  
  Future<void> _fetchMyCourses() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8000/grading/teacher-courses/1'));
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          myCourses = List<Map<String, dynamic>>.from(json.decode(response.body));
          isLoading = false; // 🎯 هنا يجب إيقاف التحميل
        });
      }
    } catch (e) { 
      debugPrint("خطأ المواد: $e");
      if (!mounted) return;
      setState(() => isLoading = false); // إيقاف التحميل حتى في حالة الخطأ
    }
  }
  Future<void> _fetchCourseExams(int courseId) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8000/grading/course-exams/1/$courseId'));
      if (response.statusCode == 200) {
        setState(() => courseExams = List<Map<String, dynamic>>.from(json.decode(response.body)));
      }
    } catch (e) { debugPrint("خطأ الاختبارات: $e"); }
  }

Widget _buildFilterHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "اختر المادة", border: OutlineInputBorder()),
              value: selectedCourseId,
              items: myCourses.map((c) => DropdownMenuItem(value: c['course_id'] as int, child: Text(c['course_name']))).toList(),
              onChanged: (val) {
                setState(() { selectedCourseId = val; selectedExamId = null; courseExams = []; studentsList = []; });
                if (val != null) _fetchCourseExams(val);
              },
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "اختر الاختبار", border: OutlineInputBorder()),
              value: selectedExamId,
              items: courseExams.map((e) => DropdownMenuItem(value: e['exam_id'] as int, child: Text(e['exam_name']))).toList(),
              onChanged: (val) {
                setState(() => selectedExamId = val);
                if (val != null) _fetchGradingResults(val);
              },
            ),
          ),
        ],
      ),
    );
  }


Future<void> _fetchGradingResults(int examId) async { // أضفنا int examId هنا
  try {
    setState(() => isLoading = true);
    
    // استبدلنا widget.examId بالمتغير الجديد examId
    final response = await http.get(Uri.parse('http://localhost:8000/grading/exam-results/$examId'));
    
    if (response.statusCode == 200) {
      List<dynamic> decodedData = json.decode(response.body);
      
      // تحويل البيانات إلى قائمة طلاب
      List<StudentResultData> list = decodedData.map((s) => StudentResultData.fromJson(s)).toList();
      
      // 🎯 الترتيب الأبجدي
      list.sort((a, b) => a.studentName.compareTo(b.studentName));
      
      if (!mounted) return;
      setState(() {
        studentsList = list;
        isLoading = false;
        errorMessage = ""; // تنظيف أي رسالة خطأ سابقة
      });
    } else {
      throw Exception("فشل جلب البيانات من السيرفر (كود: ${response.statusCode})");
    }
  } catch (e) {
    if (!mounted) return;
    setState(() {
      errorMessage = e.toString();
      isLoading = false;
    });
  }
}


Future<void> _publishStudentResult(int sheetId) async {
  try {
    final response = await http.put(Uri.parse('http://localhost:8000/grading/publish-result/$sheetId'));
    
    if (response.statusCode == 200) {
      if (!mounted) return;

      // 1. إظهار رسالة النجاح
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("📢 تم نشر النتيجة للطالب بنجاح!"), 
          backgroundColor: Colors.green
        ),
      );

      // 2. تحديث البيانات من السيرفر (وهذا سيحدث الزر تلقائياً)
      // بمجرد انتهاء هذه الدالة، سيتم تحديث `studentsList` و `selectedStudent` 
      // بالقيم الجديدة القادمة من السيرفر، وسيعيد فلاتر بناء الصفحة
      await _fetchGradingResults(selectedExamId!);
      
      // 3. تحديث الطالب المختار حالياً بعد إعادة الجلب لضمان التطابق
      setState(() {
        if (studentsList.any((s) => s.sheetId == sheetId)) {
          selectedStudent = studentsList.firstWhere((s) => s.sheetId == sheetId);
        }
      });
      
    } else 
    {
      // التعامل مع أخطاء السيرفر (في حال لم يكن الكود 200)
      throw Exception("فشل النشر: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("خطأ في النشر: $e");
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("❌ حدث خطأ أثناء النشر، حاول لاحقاً."), backgroundColor: Colors.red),
    );
  }
}
  void _recalculateTotalScore(StudentResultData student) {
    double newTotal = 0;
    for (var q in student.questions) {
      newTotal += q.finalMark;
    }
    setState(() {
      student.totalScore = newTotal;
    });
  }

  Future<void> _updateTeacherMark(int questionId, int sheetId, double newMark) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8000/grading/update-mark/$questionId?sheet_id=$sheetId&new_mark=$newMark'),
      );
      
      if (response.statusCode == 200) {
        debugPrint("✅ تم الحفظ بنجاح في السيرفر للسؤال: $questionId");
      } else {
        throw Exception("فشل التحديث في السيرفر");
      }
    } catch (e) {
      debugPrint("❌ خطأ التحديث: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.secondaryTeal(context),
      body: Row(
        children: [
          CustSidebar(selectedIndex: _selectedIndex, onItemSelected: _handleNavigation),
          Expanded(
            child: Column(
              children: [
                // _buildMainHeader("كشف نتائج تصحيح الاختبارات", "اختاري المادة والاختبار لعرض النتائج وتعديل الدرجات"),
                // _buildFilterHeader(), // البوكس الخاص بالفلترة
                if (selectedStudent == null) ...[
                _buildMainHeader("كشف نتائج تصحيح الاختبارات", "اختاري المادة والاختبار لعرض النتائج"),
                _buildFilterHeader(), 
              ],
                Expanded(
                  child: isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : (selectedExamId == null)
                      ? const Center(child: Text(
                        "يرجى تحديد المادة والاختبار من القائمة أعلاه لبدء عملية المراجعة",
                        style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                      ),)
                      : (selectedStudent == null ? _buildMasterStudentsList(false) : _buildDetailedStudentReview(false)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterStudentsList(bool isMobile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildMainHeader("كشف نتائج تصحيح الاختبار", "مراقبة الأوراق المرفوعة، وحالة المعالجة الحية، ورصد التعديلات اليدوية"),
          // const SizedBox(height: 1),
          // ElevatedButton.icon(
          //     onPressed: studentsList.any((s) => !s.isPublished) ? _publishAllResults : null,
          //     style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.all(20)),
          //     icon: const Icon(Icons.send_to_mobile, color: Colors.white),
          //     label: const Text("نشر الكل", style: TextStyle(color: Colors.white)),
          //   ),
    //       Padding(
    //   padding: const EdgeInsets.only(top: 10, right: 24), // موازنة الزر مع الهيدر
    //   child: ElevatedButton.icon(
    //     onPressed: studentsList.any((s) => !s.isPublished) ? _publishAllResults : null,
    //     style: ElevatedButton.styleFrom(
    //     backgroundColor: Colors.teal, 
    //       foregroundColor: Colors.white,
    //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // 🔘 نفس تقويس البوكس
    //       elevation: 2,
    //     ),
    //     icon: const Icon(Icons.send_rounded),
    //     label: const Text("نشر الكل", style: TextStyle(fontWeight: FontWeight.bold)),
    //   ),
    // ),
    // هذا الجزء يوضع في المكان الذي تريدين ظهور الزر فيه
Row(
  mainAxisAlignment: MainAxisAlignment.end, // 🎯 هذا الخيار يدفع الزر لأقصى اليسار
  children: [
    Padding(
      padding: const EdgeInsets.only( right: 24, left: 24, bottom: 20),
      child: ElevatedButton.icon(
        onPressed: studentsList.any((s) => !s.isPublished) ? _publishAllResults : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal, 
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
          elevation: 2,
        ),
        icon: const Icon(Icons.send_rounded),
        label: const Text("نشر الكل", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    ),
  ],
),
          studentsList.isEmpty
              ? const Center(child: Padding(padding: EdgeInsets.all(32.0), child: Text("لا توجد أوراق طلاب مصححة حالياً لهذا الاختبار.")))
              : Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: studentsList.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      var student = studentsList[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.secondaryTeal(context).withValues(alpha: 0.5),
                          child: Icon(Icons.person, color: AppColors.primaryTeal(context)),
                        ),
                        title: Text(student.studentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), overflow: TextOverflow.ellipsis),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: 
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text("الدرجة: ${student.totalScore}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: student.status == "Graded" ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  student.status == "Graded" ? "مكتمل" : "قيد المعالجة 🔄",
                                  style: TextStyle(color: student.status == "Graded" ? Colors.green : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (student.isPublished == true)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      "تم النشر 📢",
                                      style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                                          ],
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            // 1. تنظيف الكنترولرز السابقة بشكل آمن (Memory Management)
                            for (var controller in _controllers.values) {
                              controller.dispose();
                            }
                            _controllers.clear();

                            // 2. تهيئة الكنترولرز الجديدة للأسئلة
                            for (var q in student.questions) {
                              _controllers[q.questionId] = TextEditingController(text: '${q.finalMark}');
                            }

                            // 3. تحديث الحالة لعرض صفحة الطالب
                            setState(() {
                              selectedStudent = student; 
                              isEditing = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal(context),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          child: const Text("مراجعة", style: TextStyle(fontSize: 11, color: Colors.white)),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildDetailedStudentReview(bool isMobile) {
    var student = selectedStudent!;
    student.questions.sort((a, b) => a.questionOrder.compareTo(b.questionOrder));
    double totalMaxMark = student.questions.fold(0, (sum, q) => sum + q.maxMark);

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: () => setState(() => selectedStudent = null),
                icon: const Icon(Icons.arrow_back),
                label: const Text("العودة لكشف الطلاب", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildStudentHeaderCard(student, totalMaxMark),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 12.0 : 24.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: student.questions.length,
                    itemBuilder: (context, index) {
                      var q = student.questions[index];
                      // return _buildDetailedQuestionCard(q, index, isMobile);
                      return _buildDetailedQuestionCard(q, index, isMobile, key: ValueKey(q.questionId));
                    },
                  ),
                ),
                _buildBottomFooter(student),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentHeaderCard(StudentResultData student, double maxMark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 12,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(student.studentName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text("تقييم النصوص المستخرجة يدوياً بمرونة وأمان كامل", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isEditing ? const Color(0xFFFFF9E6) : const Color(0xFFF4F9F8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isEditing ? Colors.orange.withValues(alpha: 0.5) : AppColors.primaryTeal(context).withValues(alpha: 0.3)),
            ),
            child: Text(
              '${student.totalScore} / $maxMark',
              style: TextStyle(fontSize: 20, color: AppColors.primaryTeal(context), fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedQuestionCard(QuestionResultData q, int index, bool isMobile,{Key? key}) {
    Color statusColor = q.confidence >= 0.85 ? Colors.teal : (q.confidence >= 0.7 ? Colors.orange : Colors.red);
    String statusText = q.confidence >= 0.85 ? "ثقة قوية" : (q.confidence >= 0.7 ? "مراجعة متوسطة" : "خط غير واضح");

    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('سؤال ${index + 1}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              Text(statusText, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
            ],
          ),
          const SizedBox(height: 6),
          Text(q.questionText, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.blueGrey.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(6)),
            child: Text("📝 المستخرج: \"${q.extractedText}\"", style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.blueGrey, fontSize: 13)),
          ),
          const SizedBox(height: 8),
          Text("🤖 مبررات الـ AI: ${q.aiFeedback}", style: const TextStyle(fontSize: 11, color: Colors.black87)),
          const SizedBox(height: 12),
          
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 10,
            children: [
              InkWell(
                // السطر المعدل والمثالي الآن 🎯
                onTap: () => _showModelAnswerBottomSheet(index, q.modelAnswer),
                child: const Text("الإجابة النموذجية", style: TextStyle(color: Colors.teal, fontSize: 12, decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                children: [
                  const Text("الدرجة:", style: TextStyle(fontSize: 12)),
                  if (isEditing)
                    SizedBox(
                      width: 55, height: 32,
                      child: TextField(
                        key: ValueKey('textfield_${q.questionId}'),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(contentPadding: EdgeInsets.zero, border: OutlineInputBorder(borderRadius: BorderRadius.circular(6))),
                        // controller: _controllers[q.questionId], // 🎯 تم ربطه بالـ Controller المستقر لتثبيت الكيبورد والمؤشر
                        controller: _controllers[q.questionId] ??= TextEditingController(text: '${q.finalMark}'),
                        onChanged: (val) {
                          double? entered = double.tryParse(val);
                          if (entered != null) {
                            setState(() {
                              q.finalMark = entered > q.maxMark ? q.maxMark : entered;
                              q.teacherMark = q.finalMark;
                            });
                            _recalculateTotalScore(selectedStudent!);
                          }
                        },
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(border: Border.all(color: statusColor, width: 1.0), borderRadius: BorderRadius.circular(4)),
                      child: Text('${q.finalMark}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
                    ),
                  Text(' من ${q.maxMark}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> _publishAllResults() async {
  try {
    final response = await http.put(Uri.parse('http://localhost:8000/grading/publish-all-results/$selectedExamId'));
    
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("📢 تم نشر جميع النتائج بنجاح!"), backgroundColor: Colors.green));
      await _fetchGradingResults(selectedExamId!); // تحديث القائمة
    } else {
      throw Exception("فشل النشر الجماعي");
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("❌ حدث خطأ أثناء النشر الجماعي."), backgroundColor: Colors.red));
  }
}
  Widget _buildBottomFooter(StudentResultData student) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.1)))),
      child: SafeArea(
        child: Wrap(
          spacing: 12, runSpacing: 12, alignment: WrapAlignment.center,
          children: [
            
            // 1. أضيفي متغير في أعلى الـ State للتأكد من حالة الحفظ (تحت bool isEditing = false;)

            // 2. حدثي كود زر الحفظ داخل _buildBottomFooter ليكون هكذا:
          ElevatedButton(
           
            onPressed: isSaving 
              ? null 
              : () async {
                  setState(() => isSaving = true); // تفعيل حالة الحفظ وتعطيل الأزرار فوراً
                  
                  try {
                    // تجميع وحفظ كافة التعديلات في السيرفر دفعة واحدة
                    for (var q in student.questions) {
                      if (q.teacherMark != null) {
                        await _updateTeacherMark(q.questionId, student.sheetId, q.finalMark);
                      }
                    }
                    
                    if (!mounted) return;
                    
                    // سحب البيانات المحدثة من السيرفر
                    await _fetchGradingResults(selectedExamId!);
                    
                    // تحديث بيانات الطالب المختار حالياً
                    setState(() {
                      selectedStudent = studentsList.firstWhere((s) => s.sheetId == student.sheetId);
                    });

                    // رسالة نجاح الحفظ
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("💾 تم حفظ كافة التعديلات اليدوية بنجاح!"), 
                        backgroundColor: Colors.teal
                      ),
                    );
                    
                  } catch(e) {
                    debugPrint("خطأ أثناء الحفظ: $e");
                    
                    // 🎯 إضافة رسالة الخطأ هنا
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("❌ فشل الحفظ، تأكد من اتصالك بالإنترنت وحاول مرة أخرى."), 
                        backgroundColor: Colors.redAccent,
                        duration: Duration(seconds: 4),
                      ),
                    );
                  } finally {
                    if (mounted) setState(() => isSaving = false); // إعادة فتح الأزرار
                  }
                },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal(context), 
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
            ),
            child: isSaving 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text("حفظ واعتماد كشف درجات الطالب", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
            OutlinedButton(
              onPressed: () => setState(() => isEditing = !isEditing),
              style: OutlinedButton.styleFrom(side: BorderSide(color: isEditing ? Colors.redAccent : AppColors.primaryTeal(context)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
              child: Text(isEditing ? "إلغاء التعديل" : "تعديل الدرجات يدويًا", style: TextStyle(color: isEditing ? Colors.redAccent : AppColors.primaryTeal(context), fontWeight: FontWeight.bold, fontSize: 13)),
            ),
            
            student.isPublished // هنا نعتمد على الحقل الجديد
            ? ElevatedButton.icon(
                onPressed: null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text("تم النشر"),
              )
            
            :ElevatedButton.icon(
            onPressed: (student.isPublished == true || student.status != "Graded")
                ? null  // إذا كانت منشورة (true) أو غير مكتملة، عطل الزر
                : () => _publishStudentResult(student.sheetId),
            style: ElevatedButton.styleFrom(
              backgroundColor: student.isPublished == true ? Colors.green : AppColors.primaryTeal(context),
            ),
            icon: Icon(
              student.isPublished == true ? Icons.check_circle : Icons.send, 
              color: Colors.white
            ),
            label: Text(
              student.isPublished == true ? "تم النشر" : "نشر النتيجة للطالب",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          ],
        ),
      ),
    );
  }

  void _showModelAnswerBottomSheet(int index, String modelAnswer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('نموذget إجابة سؤال ${index + 1}:', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.primaryTeal(context).withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.primaryTeal(context))),
              child: Text(modelAnswer, style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.primaryTeal(context), fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal(context)), child: const Text("إغلاق", style: TextStyle(color: Colors.white)))),
          ],
        ),
      ),
    );
  }

  // Widget _buildMainHeader(String title, String subtitle) {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
  //         const SizedBox(height: 4),
  //         Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
  //       ],
  //     ),
  //   );
  // }
// هذا هو الكود الموحد للهيدر والفلاتر بنفس المقاييس
Widget _buildMainHeader(String title, String subtitle) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10), // نفس الهوامش
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16), // نفس التقويس
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    ),
  );
}
  Widget _buildMobileAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.menu, color: AppColors.primaryTeal(context)), onPressed: () => _scaffoldKey.currentState?.openDrawer()),
            const Spacer(),
            const Text("منصة التدقيق ورصد الدرجات", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    if (index == _selectedIndex) return;
    Widget? page;
    if (index == 0) page = const DashboardScreen();
    if (index == 1) page = const ExamManagementPage();
    if (index == 2) page = const Material1();
    if (index == 3) page = const GradingPage();
    if (index == 5) page = const SettingsScreen();

    if (page != null) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page!));
  }
}