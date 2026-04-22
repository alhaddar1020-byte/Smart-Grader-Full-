import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/colors.dart'; // تأكدي من المسار
import 'package:screenshot/screenshot.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:grade/generated/l10n.dart'; // استدعاء القاموس

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // المتحكم لتصوير المخطط الدائري
  final ScreenshotController _chartScreenshotController = ScreenshotController();

  // ===========================================================================
  // دالة التصدير الاحترافية (Native PDF Generation)
  // ===========================================================================
  Future<void> _exportToPDF() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).generating_pdf), backgroundColor: AppColors.primaryTeal(context)),
      );

      final Uint8List? chartImageBytes = await _chartScreenshotController.capture(delay: const Duration(milliseconds: 50));
      
      final arabicFont = await PdfGoogleFonts.cairoRegular();
      final arabicFontBold = await PdfGoogleFonts.cairoBold();

      final pdf = pw.Document();
      
      // معرفة اتجاه اللغة الحالي عشان نقلب الـ PDF بناءً عليه
      final bool isRtl = Directionality.of(context) == TextDirection.rtl;

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          // تحديد اتجاه النص بذكاء بناءً على لغة الجهاز
          textDirection: isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
          theme: pw.ThemeData.withFont(
            base: arabicFont,
            bold: arabicFontBold,
          ),
          build: (pw.Context contextPdf) {
            return [
              pw.Center(
                child: pw.Text(S.of(context).pdf_report_title, style: pw.TextStyle(fontSize: 24, font: arabicFontBold)),
              ),
              pw.SizedBox(height: 20),

              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(color: PdfColors.grey100, borderRadius: pw.BorderRadius.circular(10)),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Text(S.of(context).pdf_total_students, style: const pw.TextStyle(fontSize: 16)),
                    pw.Text(S.of(context).pdf_general_average, style: const pw.TextStyle(fontSize: 16)),
                    pw.Text(S.of(context).pdf_active_teachers, style: const pw.TextStyle(fontSize: 16)),
                  ]
                )
              ),
              pw.SizedBox(height: 30),

              if (chartImageBytes != null) ...[
                pw.Text(S.of(context).pdf_overall_performance, style: pw.TextStyle(fontSize: 18, font: arabicFontBold)),
                pw.SizedBox(height: 10),
                pw.Center(child: pw.Image(pw.MemoryImage(chartImageBytes), height: 200)),
                pw.SizedBox(height: 30),
              ],

              pw.Text(S.of(context).pdf_system_usage, style: pw.TextStyle(fontSize: 18, font: arabicFontBold)),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                context: contextPdf,
                cellAlignment: pw.Alignment.center,
                headerDecoration: const pw.BoxDecoration(color: PdfColors.teal300),
                headerStyle: pw.TextStyle(color: PdfColors.white, font: arabicFontBold),
                data: <List<String>>[
                  [S.of(context).rank, S.of(context).teacher_name, S.of(context).tasks_count],
                  ['1', S.of(context).teacher_1, '150 ${S.of(context).task_word}'],
                  ['2', S.of(context).teacher_2, '120 ${S.of(context).task_word}'],
                  ['3', S.of(context).teacher_3, '95 ${S.of(context).task_word}'],
                  ['4', S.of(context).teacher_4, '60 ${S.of(context).task_word}'],
                  ['5', S.of(context).teacher_5, '40 ${S.of(context).task_word}'],
                ],
              ),
              pw.SizedBox(height: 30),

              pw.Text(S.of(context).pdf_subjects_performance, style: pw.TextStyle(fontSize: 18, font: arabicFontBold)),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                context: contextPdf,
                cellAlignment: pw.Alignment.center,
                headerDecoration: const pw.BoxDecoration(color: PdfColors.teal300),
                headerStyle: pw.TextStyle(color: PdfColors.white, font: arabicFontBold),
                data: <List<String>>[
                  [S.of(context).subject, S.of(context).success_rate_label, S.of(context).fail_rate_label],
                  [S.of(context).subject_math, '70%', '30%'],
                  [S.of(context).subject_quran, '30%', '70%'],
                  [S.of(context).subject_arabic, '85%', '15%'],
                  [S.of(context).subject_english, '60%', '40%'],
                  [S.of(context).subject_science, '90%', '10%'],
                  [S.of(context).subject_history, '95%', '5%'],
                  [S.of(context).subject_geography, '80%', '20%'],
                ],
              ),
            ];
          },
        ),
      );

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'SmartGrader_Reports.pdf',
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).export_error), backgroundColor: Colors.red),
      );
    }
  }

  // ===========================================================================
  // واجهة التطبيق
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 600;

    // إزالة Directionality ليتوافق التطبيق مع اللغة
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopHeader(context, isMobile),
            const SizedBox(height: 32),

            isMobile
                ? Column(
                    children: [
                      _buildHorizontalCardsGroup(context),
                      const SizedBox(height: 24),
                      _buildOverallPerformance(context),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildOverallPerformance(context)),
                      const SizedBox(width: 24),
                      Expanded(flex: 1, child: _buildVerticalCardsGroup(context)),
                    ],
                  ),
                  
            const SizedBox(height: 32),

            isMobile
                ? Column(
                    children: [
                      _buildSubjectsPerformance(context),
                      const SizedBox(height: 24),
                      _buildSystemUsage(context),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 1, child: _buildSystemUsage(context)),
                      const SizedBox(width: 24),
                      Expanded(flex: 2, child: _buildSubjectsPerformance(context)),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // المكونات (Widgets)
  // ===========================================================================
  Widget _buildTopHeader(BuildContext context, bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.textWhite(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: isMobile 
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).reports_statistics, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
                    const SizedBox(height: 12),
                    _buildExportButton(context),
                  ],
                )
              : Row(
                  children: [
                    Text(S.of(context).reports_statistics, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
                    const SizedBox(width: 24),
                    _buildExportButton(context),
                  ],
                ),
          ),
          
          Row(
            children: [
              _buildTopIcon(context: context, icon: Icons.notifications_none_rounded, onTap: () {}),
              const SizedBox(width: 12),
              _buildTopIcon(context: context, icon: Icons.person_outline_rounded, onTap: () {}),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildExportButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _exportToPDF, 
      icon: const Icon(Icons.picture_as_pdf, color: Colors.white, size: 20),
      label: Text(S.of(context).export_pdf_button, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryTeal(context),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildTopIcon({required BuildContext context, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.scaffoldBg(context), shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.primaryTeal(context), size: 24),
      ),
    );
  }

  Widget _buildHorizontalCardsGroup(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 260, child: _buildVerticalCard(context: context, title: S.of(context).total_students, value: '2,540', icon: Icons.group, iconColor: AppColors.primaryTeal(context))),
          const SizedBox(width: 16),
          SizedBox(width: 260, child: _buildVerticalCard(context: context, title: S.of(context).general_average, value: '85%', icon: Icons.bar_chart, iconColor: AppColors.accentYellow(context))),
          const SizedBox(width: 16),
          SizedBox(width: 260, child: _buildVerticalCard(context: context, title: S.of(context).active_teachers, value: '45', icon: Icons.person_pin, iconColor: AppColors.primaryTeal(context))),
        ],
      ),
    );
  }

  Widget _buildVerticalCardsGroup(BuildContext context) {
    return Column(
      children: [
        _buildVerticalCard(context: context, title: S.of(context).total_students, value: '2,540', icon: Icons.group, iconColor: AppColors.primaryTeal(context)),
        const SizedBox(height: 16),
        _buildVerticalCard(context: context, title: S.of(context).general_average, value: '85%', icon: Icons.bar_chart, iconColor: AppColors.accentYellow(context)),
        const SizedBox(height: 16),
        _buildVerticalCard(context: context, title: S.of(context).active_teachers, value: '45', icon: Icons.person_pin, iconColor: AppColors.primaryTeal(context)),
      ],
    );
  }

  Widget _buildVerticalCard({required BuildContext context, required String title, required String value, required IconData icon, required Color iconColor}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(fit: BoxFit.scaleDown, child: Text(title, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 13, fontWeight: FontWeight.w600))),
                const SizedBox(height: 4),
                FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallPerformance(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      height: isMobile ? 400 : 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).overall_performance_title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
          const SizedBox(height: 32),
          Expanded(
            child: Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              children: [
                Expanded(
                  child: Screenshot(
                    controller: _chartScreenshotController,
                    child: Container(
                      color: AppColors.textWhite(context), 
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2, centerSpaceRadius: isMobile ? 40 : 60,
                          sections: [
                            PieChartSectionData(color: AppColors.primaryTeal(context), value: 75, title: '75%', radius: 30, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            PieChartSectionData(color: AppColors.accentYellow(context), value: 25, title: '25%', radius: 30, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (isMobile) const SizedBox(height: 24),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(context, S.of(context).pass_status, AppColors.primaryTeal(context)),
                    const SizedBox(height: 16),
                    _buildLegendItem(context, S.of(context).fail_status, AppColors.accentYellow(context)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String title, Color color) {
    return Row(
      children: [
        Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary(context))),
      ],
    );
  }

  Widget _buildSystemUsage(BuildContext context) {
    return Container(
      height: 420,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).system_usage_title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                _buildTeacherUsageRow(context, 1, S.of(context).teacher_1, 0.9, 150),
                _buildTeacherUsageRow(context, 2, S.of(context).teacher_2, 0.75, 120),
                _buildTeacherUsageRow(context, 3, S.of(context).teacher_3, 0.6, 95),
                _buildTeacherUsageRow(context, 4, S.of(context).teacher_4, 0.45, 60),
                _buildTeacherUsageRow(context, 5, S.of(context).teacher_5, 0.3, 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherUsageRow(BuildContext context, int rank, String name, double progress, int tasks) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$rank', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary(context))),
                Icon(Icons.keyboard_arrow_up, color: AppColors.primaryTeal(context), size: 18),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary(context), fontSize: 13)),
                const SizedBox(height: 8),
                // تم استخدام Directionality لقراءة الاتجاه لضمان أن الشريط يمتلئ من الجهة الصحيحة
                Directionality(
                  textDirection: Directionality.of(context),
                  child: LinearProgressIndicator(value: progress, backgroundColor: AppColors.secondaryTeal(context), color: AppColors.primaryTeal(context), minHeight: 8, borderRadius: BorderRadius.circular(4)),
                ),
                const SizedBox(height: 4),
                Text('$tasks ${S.of(context).task_word}', style: TextStyle(color: AppColors.textSecondary(context), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsPerformance(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      height: 420,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.textWhite(context), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).pdf_subjects_performance, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
                    const SizedBox(height: 16),
                    Row(children: [_buildLegendItem(context, S.of(context).pass_status, AppColors.primaryTeal(context)), const SizedBox(width: 16), _buildLegendItem(context, S.of(context).fail_status, AppColors.accentYellow(context))])
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.of(context).pdf_subjects_performance, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))),
                    Row(children: [_buildLegendItem(context, S.of(context).pass_status, AppColors.primaryTeal(context)), const SizedBox(width: 16), _buildLegendItem(context, S.of(context).fail_status, AppColors.accentYellow(context))])
                  ],
                ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: [
                _buildSubjectBarItem(context, S.of(context).subject_math, 70, 30),
                _buildSubjectBarItem(context, S.of(context).subject_quran, 30, 70),
                _buildSubjectBarItem(context, S.of(context).subject_arabic, 85, 15),
                _buildSubjectBarItem(context, S.of(context).subject_english, 60, 40),
                _buildSubjectBarItem(context, S.of(context).subject_science, 90, 10),
                _buildSubjectBarItem(context, S.of(context).subject_history, 95, 5),
                _buildSubjectBarItem(context, S.of(context).subject_geography, 80, 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectBarItem(BuildContext context, String subjectName, int successRate, int failRate) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(subjectName, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary(context), fontSize: 13))),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 12, clipBehavior: Clip.antiAlias, decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
              child: Row(
                children: [
                  Expanded(flex: successRate, child: Container(color: AppColors.primaryTeal(context))),
                  Expanded(flex: failRate, child: Container(color: AppColors.accentYellow(context))),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(width: 40, child: Text('$successRate%', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary(context))))
        ],
      ),
    );
  }
}