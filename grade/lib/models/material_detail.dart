// class ExamDetail {
//   final int id;
//   final String title;
//   final String date;
//   final String status;
//   final int studentCount;
//   final String examType;

//   ExamDetail({
//     required this.id,
//     required this.title,
//     required this.date,
//     required this.status,
//     required this.studentCount,
//     this.examType = 'manual',
//   });

//   factory ExamDetail.fromJson(Map<String, dynamic> json) {
//     return ExamDetail(
//       id: json['exam_id'],
//       title: json['title'],
//       date: json['date'],
//       status: json['status'],
//       studentCount: json['student_count'],
//       examType: json['exam_type'] ?? 'manual',
//     );
//   }
// }

// class FolderDetail {
//   final int id;
//   final String name;
//   final List<ExamDetail> exams;

//   FolderDetail({required this.id, required this.name, required this.exams});

//   factory FolderDetail.fromJson(Map<String, dynamic> json) {
//     return FolderDetail(
//       id: json['folder_id'],
//       name: json['folder_name'],
//       exams: (json['exams'] as List)
//           .map((e) => ExamDetail.fromJson(e))
//           .toList(),
//     );
//   }
// }

class ExamDetail {
  final int id;
  final String title;
  final String date;
  final String status;
  final int studentCount;
  final String examType;

  ExamDetail({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.studentCount,
    this.examType = 'manual',
  });

  factory ExamDetail.fromJson(Map<String, dynamic> json) {
    return ExamDetail(
      id: json['exam_id'],
      title: json['title'],
      date: json['date'],
      status: json['status'],
      studentCount: json['student_count'],
      examType: json['exam_type'] ?? 'manual',
    );
  }
}

class FolderDetail {
  final int id;
  final String name;
  final List<ExamDetail> exams;

  FolderDetail({required this.id, required this.name, required this.exams});

  factory FolderDetail.fromJson(Map<String, dynamic> json) {
    return FolderDetail(
      id: json['folder_id'],
      name: json['folder_name'],
      exams: (json['exams'] as List)
          .map((e) => ExamDetail.fromJson(e))
          .toList(),
    );
  }
}
