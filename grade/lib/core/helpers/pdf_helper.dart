// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'dart:typed_data';
// import 'package:flutter/services.dart' show rootBundle;

// class PdfHelper {
//   // اللون الأساسي ثابت (التركواز)
//   static const PdfColor primaryTeal = PdfColor.fromInt(0xFF4FB7B5);

//   static Future<Uint8List> generateExamReport({
//     required Map<String, dynamic> studentData,
//     required String examTitle,
//     required bool isArabic,
//     required bool isDarkMode, // 🔴 استقبال حالة الدارك مود
//     required String logoPath,
//     required Map<String, String> labels, // 🔴 استقبال نصوص الترجمة
//     required List<dynamic> questions, // 🔴 استقبال الأسئلة من الداتا بيس
//     required String finalScore, // 🔴 استقبال الدرجة النهائية
//   }) async {
//     final pdf = pw.Document();

//     final arabicFont = await PdfGoogleFonts.cairoRegular();
//     final arabicFontBold = await PdfGoogleFonts.cairoBold();

//     // 🔴 ألوان ديناميكية بناءً على حالة الدارك مود
//     final PdfColor bgColor = isDarkMode
//         ? const PdfColor.fromInt(0xFFF3F4F6)
//         : const PdfColor.fromInt(0xFFF3F4F6);
//     final PdfColor txtColor = isDarkMode
//         ? PdfColor.fromInt(0xFF000000)
//         : const PdfColor.fromInt(0xFF000000);
//     final PdfColor txtSecColor = isDarkMode
//         ? const PdfColor.fromInt(0xFF8F959E)
//         : const PdfColor.fromInt(0xFF8F959E);

//     pw.MemoryImage? logoImage;
//     try {
//       final ByteData imageBytes = await rootBundle.load(logoPath);
//       logoImage = pw.MemoryImage(imageBytes.buffer.asUint8List());
//     } catch (e) {
//       print("لم يتم العثور على الشعار");
//     }

//     final textDir = isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr;

//     // 🔴 تجهيز بيانات الجدول ديناميكياً (نقوم بتحويل قائمة الأسئلة لصفوف الجدول)
//     final List<List<String>> tableData = [
//       // صف العناوين (يقرأ من ملف الترجمة)
//       [
//         labels['colNo']!,
//         labels['colQuestion']!,
//         labels['colStudentAns']!,
//         labels['colModelAns']!,
//         labels['colScore']!,
//       ],
//     ];

//     // إضافة أسئلة الداتا بيس للجدول (استخدام المسميات الصحيحة من البايثون)
//     for (var q in questions) {
//       tableData.add([
//         q['id']?.toString() ?? '-', // في البايثون اسمه id
//         q['text']?.toString() ?? '-', // في البايثون اسمه text
//         q['studentAnswer']?.toString() ?? '-', // في البايثون اسمه studentAnswer
//         q['modelAnswer']?.toString() ?? '-', // في البايثون اسمه modelAnswer
//         '${q['score'] ?? 0} / ${q['total'] ?? 0}', // في البايثون score و total
//       ]);
//     }

//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(32),
//         textDirection: textDir,
//         build: (pw.Context context) {
//           return [
//             // 1. الترويسة
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: pw.CrossAxisAlignment.center,
//               children: [
//                 if (logoImage != null)
//                   pw.Image(logoImage, width: 60, height: 60)
//                 else
//                   pw.SizedBox(width: 60, height: 60),

//                 pw.Expanded(
//                   child: pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.center,
//                     children: [
//                       pw.Text(
//                         labels['titleSystem']!,
//                         style: pw.TextStyle(
//                           font: arabicFontBold,
//                           fontSize: 20,
//                           color: primaryTeal,
//                         ),
//                         textAlign: pw.TextAlign.center,
//                       ),
//                       pw.SizedBox(height: 5),
//                       pw.Text(
//                         labels['titleReport']!,
//                         style: pw.TextStyle(
//                           font: arabicFont,
//                           fontSize: 14,
//                           color: txtSecColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 pw.SizedBox(width: 60),
//               ],
//             ),
//             pw.SizedBox(height: 10),
//             pw.Divider(thickness: 2, color: primaryTeal),
//             pw.SizedBox(height: 15),

//             // 2. بيانات الطالب
//             pw.Container(
//               padding: const pw.EdgeInsets.all(12),
//               decoration: pw.BoxDecoration(
//                 color: bgColor,
//                 borderRadius: pw.BorderRadius.circular(8),
//               ),
//               child: pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       pw.Text(
//                         '${labels['lblStudent']} ${studentData["name"] ?? "-"}',
//                         style: pw.TextStyle(
//                           font: arabicFontBold,
//                           fontSize: 12,
//                           color: txtColor,
//                         ),
//                       ),
//                       pw.Text(
//                         '${labels['lblLevel']} ${studentData["level"] ?? "-"}',
//                         style: pw.TextStyle(
//                           font: arabicFont,
//                           fontSize: 11,
//                           color: txtSecColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                   pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       pw.Text(
//                         '${labels['lblExam']} $examTitle',
//                         style: pw.TextStyle(
//                           font: arabicFontBold,
//                           fontSize: 12,
//                           color: txtColor,
//                         ),
//                       ),
//                       pw.Text(
//                         '${labels['lblDate']} ${DateTime.now().toString().substring(0, 10)}',
//                         style: pw.TextStyle(
//                           font: arabicFont,
//                           fontSize: 11,
//                           color: txtSecColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             pw.SizedBox(height: 25),

//             // 3. 🔴 الدرجة النهائية وعنوان الجدول
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text(
//                   labels['lblDetails']!,
//                   style: pw.TextStyle(
//                     font: arabicFontBold,
//                     fontSize: 14,
//                     color: primaryTeal,
//                   ),
//                 ),
//                 // عرض الدرجة النهائية بشكل بارز
//                 pw.Container(
//                   padding: const pw.EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   decoration: pw.BoxDecoration(
//                     color: primaryTeal,
//                     borderRadius: pw.BorderRadius.circular(6),
//                   ),
//                   child: pw.Text(
//                     '${labels['lblTotalScore']} $finalScore',
//                     style: pw.TextStyle(
//                       font: arabicFontBold,
//                       fontSize: 12,
//                       color: PdfColors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             pw.SizedBox(height: 10),

//             // 4. الجدول التفصيلي الديناميكي
//             pw.TableHelper.fromTextArray(
//               context: context,
//               cellStyle: pw.TextStyle(
//                 font: arabicFont,
//                 fontSize: 10,
//                 color: txtColor,
//               ),
//               headerStyle: pw.TextStyle(
//                 font: arabicFontBold,
//                 fontSize: 11,
//                 color: PdfColors.white,
//               ),
//               headerDecoration: const pw.BoxDecoration(color: primaryTeal),
//               cellAlignment: isArabic
//                   ? pw.Alignment.centerRight
//                   : pw.Alignment.centerLeft,
//               columnWidths: {
//                 0: const pw.FlexColumnWidth(1),
//                 1: const pw.FlexColumnWidth(3),
//                 2: const pw.FlexColumnWidth(3),
//                 3: const pw.FlexColumnWidth(3),
//                 4: const pw.FlexColumnWidth(1.2),
//               },
//               data: tableData, // البيانات تأتي من المصفوفة الديناميكية الآن
//             ),
//           ];
//         },
//       ),
//     );

//     return pdf.save();
//   }
// }
