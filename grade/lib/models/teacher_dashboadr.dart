import 'dart:convert';

// 1. كلاس الإحصائيات العلوية (هذا هو الكلاس الذي كان ينقصك)
class TeacherDashboard {
  final int totalStudents;
  final int correctedPapers;
  final int createdExams;
  final int drafts;

  TeacherDashboard({
    required this.totalStudents,
    required this.correctedPapers,
    required this.createdExams,
    required this.drafts,
  });
}

// 2. مودل المادة الواحدة
class CourseMaterial {
  final int id;
  final String name;
  final String dept;
  final String level;
  final int folders;
  final int exams;

  CourseMaterial({
    required this.id,
    required this.name,
    required this.dept,
    required this.level,
    required this.folders,
    required this.exams,
  });

  factory CourseMaterial.fromJson(Map<String, dynamic> json) {
    return CourseMaterial(
      id: json['course_id'] ?? 0,
      name: json['course_name'] ?? "",
      dept: json['department_name'] ?? "",
      level: json['level_name'] ?? "",
      folders: json['total_folders'] ?? 0,
      exams: json['total_exams'] ?? 0,
    );
  }
}

// 3. مودل البيانات الكاملة للصفحة (Wrapper)
class TeacherMaterialsWrapper {
  final List<CourseMaterial> courses;
  final int totalStudents;
  final int totalCorrectedPapers;
  final int totalExams;
  final int totalDrafts;

  TeacherMaterialsWrapper({
    required this.courses,
    required this.totalStudents,
    required this.totalCorrectedPapers,
    required this.totalExams,
    required this.totalDrafts,
  });

  factory TeacherMaterialsWrapper.fromJson(Map<String, dynamic> json) {
    return TeacherMaterialsWrapper(
      courses:
          (json['courses'] as List?)
              ?.map((i) => CourseMaterial.fromJson(i))
              .toList() ??
          [],
      totalStudents: json['total_students'] ?? 0,
      totalCorrectedPapers: json['total_corrected_papers'] ?? 0,
      totalExams: json['total_exams'] ?? 0,
      totalDrafts: json['total_drafts'] ?? 0,
    );
  }
}
