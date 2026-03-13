import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/colors.dart'; // هنا جلبنا ملف الألوان من core/colors.dart

void main() {
  runApp(const IntelligentGradingApp());
}

class IntelligentGradingApp extends StatelessWidget {
  const IntelligentGradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Cairo'),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: DashboardScreen(),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryTeal,
      body: Row(
        children: [
          const SidebarWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderWidget(),
                  const SizedBox(height: 24),
                  const TopStatsGrid(),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Expanded(flex: 3, child: MonthlyAverageChart()),
                      SizedBox(width: 20),
                      Expanded(flex: 1, child: CalendarWidget()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const BottomStatsRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- القائمة الجانبية ---
class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: AppColors.primaryTeal,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const CircleAvatar(
            backgroundColor: Colors.white24,
            radius: 40,
            child: Icon(Icons.grading, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 10),
          const Text(
            "Intelligent Grading System",
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          _sidebarItem(Icons.dashboard, "لوحة التحكم", active: true),
          _sidebarItem(Icons.assignment, "إدارة الامتحانات"),
          _sidebarItem(Icons.book, "المواد"),
          _sidebarItem(Icons.check_circle_outline, "تصحيح"),
          _sidebarItem(Icons.rate_review, "مراجعة"),
          _sidebarItem(Icons.settings, "إعدادات"),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String title, {bool active = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        color: active ? AppColors.primaryTeal.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

// --- الهيدر ---
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          
          /// النصوص
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "مرحباً م.خديجة!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "تحقق من إحصائياتك",
                style: TextStyle(
                  color: AppColors.textseccondary,
                ),
              ),
            ],
          ),

          /// الأيقونات
          Row(
            children: [
              _iconButton(Icons.notifications_none),
              const SizedBox(width: 10),
              _iconButton(Icons.person_outline),
            ],
          )
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.secondaryTeal,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primaryTeal),
    );
  }
}

// --- البطاقات العلوية ---
class TopStatsGrid extends StatelessWidget {
  const TopStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statCard("الطلاب", "340", AppColors.accentYellow, Icons.people),
        _statCard("الأوراق المصححة", "780", AppColors.primaryTeal, Icons.description),
        _statCard("الاختبارات المنشئة", "13", AppColors.primaryTeal, Icons.create),
        _statCard("المسودات", "5", AppColors.primaryTeal, Icons.edit_note),
      ],
    );
  }

  Widget _statCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
            Icon(icon, color: Colors.white54, size: 40),
          ],
        ),
      ),
    );
  }
}

// --- الرسم البياني ---

// class MonthlyAverageChart extends StatelessWidget {
//   const MonthlyAverageChart({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // البيانات التقريبية بناءً على تصميم فيقما
//     final List<Map<String, dynamic>> chartData = [
//       {"label": "ديسمبر", "value": 0.45, "special": false},
//       {"label": "نوفمبر", "value": 0.53, "special": false},
//       {"label": "أكتوبر", "value": 0.45, "special": false},
//       {"label": "سبتمبر", "value": 0.72, "special": true}, 
//       {"label": "أغسطس", "value": 0.82, "special": true}, 
//       {"label": "يوليو", "value": 0.95, "special": true}, 
//       {"label": "يونيو", "value": 0.55, "special": false},
//       {"label": "مايو", "value": 0.28, "special": false},
//       {"label": "أبريل", "value": 0.20, "special": false},
//       {"label": "مارس", "value": 0.35, "special": false},
//       {"label": "فبراير", "value": 0.45, "special": false},
//       {"label": "يناير", "value": 0.65, "special": false},
//     ];

//     return Container(
//       height: 300, 
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.05),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//           // رأس الرسم البياني مع تبديل الجهات
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
              
//               const Text(
//                 "متوسط درجات الطلاب شهرياً",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//               ),
//               Row(
//                 children: [
//                   Container(
//                     width: 8,
//                     height: 8,
//                     decoration: const BoxDecoration(color: Color(0xFFF5A623), shape: BoxShape.circle),
//                   ),
//                   const SizedBox(width: 5),
//                   const Text("أفضل 3 أشهر", style: TextStyle(fontSize: 11, color: Color(0xFFF5A623)),
//               )],
//               ),
//             ],
//           ),
//           const SizedBox(height: 30),
//           Expanded(
//             child: Row(
//               children: [
//                 // الأعمدة البيانية (تأخذ المساحة الأكبر لمنع الـ Overflow)
//                 Expanded(
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       return Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: chartData.map((data) {
//                           return _bar(
//                             constraints.maxHeight * (data['value'] as double),
//                             data['label'],
//                             isSpecial: data['special'],
//                           );
//                         }).toList(),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 // تم نقل النسب المئوية إلى الجهة اليمنى
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: ["100%", "80%", "60%", "40%", "20%", "0%"]
//                       .map((label) => Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)))
//                       .toList(),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _bar(double height, String label, {bool isSpecial = false}) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Container(
//           width: 18, 
//           height: height.clamp(0, double.infinity),
//           decoration: BoxDecoration(
//             color: isSpecial ? const Color(0xFFF5A623) : const Color(0xFF5AB2B0),
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
//           ),
//         ),
//         const SizedBox(height: 8),
//         // استخدام التسمية المختصرة أو FittedBox لمنع الخطأ في يونيو
//         SizedBox(
//           width: 25,
//           child: Center(
//             child: FittedBox(
//               fit: BoxFit.scaleDown,
//               child: Text(
//                 label,
//                 style: const TextStyle(fontSize: 8, color: Colors.grey),
//               ),
            
//           ),
//         ),
//         )
//       ],
//     );
//   }
// }
class MonthlyAverageChart extends StatelessWidget {
  const MonthlyAverageChart({super.key});

  @override
  Widget build(BuildContext context) {
    // البيانات التقريبية بناءً على تصميم فيقما
    final List<Map<String, dynamic>> chartData = [
      {"label": "ديسمبر", "value": 0.45, "special": false},
      {"label": "نوفمبر", "value": 0.53, "special": false},
      {"label": "أكتوبر", "value": 0.45, "special": false},
      {"label": "سبتمبر", "value": 0.72, "special": true}, 
      {"label": "أغسطس", "value": 0.82, "special": true}, 
      {"label": "يوليو", "value": 0.95, "special": true}, 
      {"label": "يونيو", "value": 0.55, "special": false},
      {"label": "مايو", "value": 0.28, "special": false},
      {"label": "أبريل", "value": 0.20, "special": false},
      {"label": "مارس", "value": 0.35, "special": false},
      {"label": "فبراير", "value": 0.45, "special": false},
      {"label": "يناير", "value": 0.65, "special": false},
    ];

    return Container(
      height: 300, // تم التعديل ليتناسب مع طول التقويم
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "متوسط درجات الطلاب شهرياً",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Color(0xFFF5A623), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 5),
                  const Text("أفضل 3 أشهر", style: TextStyle(fontSize: 11, color: Color(0xFFF5A623))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: chartData.map((data) {
                          // إرسال أقصى ارتفاع متاح للويدجت الفرعية
                          return _bar(
                            constraints.maxHeight,
                            data['value'] as double,
                            data['label'],
                            isSpecial: data['special'],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ["100%", "80%", "60%", "40%", "20%", "0%"]
                      .map((label) => Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)))
                      .toList(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // تم تعديل المدخلات لتشمل maxHeight الخاص بـ LayoutBuilder
  Widget _bar(double maxHeight, double value, String label, {bool isSpecial = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min, // يمنع تمدد العمود عمودياً بشكل زائد
      children: [
        Container(
          width: 18, 
          // طرح مساحة ثابتة (30 بكسل) للنص والمسافات لمنع الـ Overflow من الأسفل
          height: (maxHeight - 30) * value, 
          decoration: BoxDecoration(
            color: isSpecial ? const Color(0xFFF5A623) : const Color(0xFF5AB2B0),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 25,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(fontSize: 8, color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
// // --- التقويم ---
// class CalendarWidget extends StatelessWidget {
//   const CalendarWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(25),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
//       child: Column(
//         children: [
//           const Text("التقويم", style: TextStyle(fontWeight: FontWeight.bold)),
//           const Divider(),
//           const Text("فبراير 2026", style: TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 0),
//                     // const SizedBox(height: 30),

//           GridView.builder(
//             shrinkWrap: true,
//             itemCount: 28,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
//             itemBuilder: (context, index) {
//               final isToday = index + 1 == 3;
//               return Container(
//                 margin: const EdgeInsets.all(2),
//                 decoration: BoxDecoration(
//                   color: isToday ? AppColors.primaryTeal : Colors.transparent,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(child: Text("${index + 1}", style: TextStyle(fontSize: 12, color: isToday ? Colors.white : Colors.black))),
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة الأيام لتطابق تصميم فيقما (الأيام الرمادية من الشهر السابق + أيام الشهر الحالي)
    final List<String> days = [
      "27", "28", "29", "30", "31", "1", "2",
      "3", "4", "5", "6", "7", "8", "9",
      "10", "11", "12", "13", "14", "15", "16",
      "17", "18", "19", "20", "21", "22", "23",
      "24", "25", "26", "27", "28", "29", "30"
    ];

    // أيام الأسبوع كما في الصورة
    final List<String> weekDays = ["ح", "ن", "ث", "ر", "خ", "ج", "س"];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          // العنوان "التقويم"
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              "التقويم",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF2D3142),
              ),
            ),
          ),
          const SizedBox(height: 15),
          
          // زر اختيار الشهر (فبراير 2026)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
                SizedBox(width: 5),
                Text(
                  "فبراير 2026",
                  style: TextStyle(fontSize: 13, color: Color(0xFF2D3142)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // عرض أيام الأسبوع (ح، ن، ث...)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDays
                .map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          
          // شبكة توزيع الأيام
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              final day = days[index];
              
              // تمييز اليوم الحالي (3 فبراير) بناءً على موقعه في المصفوفة
              bool isToday = day == "3" && index == 7; 
              
              // تمييز الأيام الرمادية (قبل بداية الشهر وبعد نهايته)
              bool isGrey = index < 5 || index > 32;

              return Container(
                decoration: BoxDecoration(
                  color: isToday ? const Color(0xFF5AB2B0) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday 
                          ? Colors.white 
                          : (isGrey ? Colors.grey.withValues(alpha: 0.3) : Colors.black),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

// --- الصف السفلي ---
// class BottomStatsRow extends StatelessWidget {
//   const BottomStatsRow({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         // كارت نسبة اكتمال مراجعة الأوراق (اللون التيلي)
//         _gaugeCard("نسبة اكتمال مراجعة الأوراق المصححة", 0.8, const Color(0xFF5AB2B0), "80%"),
//         // كارت نسبة اكتمال نشر النتائج (اللون الأصفر)
//         _gaugeCard("نسبة اكتمال نشر النتائج", 0.6, const Color(0xFFF5A623), "60%"),
//         // كارت حالة نتائج الطلاب (الدائرة)
//         _statusCircleCard(),
//       ],
//     );
//   }

//   Widget _gaugeCard(String title, double percent, Color color, String text) {
//     return Expanded(
//       child: Container(
//         height: 200, // ضبط الارتفاع ليتناسب مع الصورة
//         margin: const EdgeInsets.symmetric(horizontal: 8),
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(25),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 5),
//             )
//           ],
//         ),
//         child: Column(
//           children: [
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
//             ),
//             const Spacer(),
//             // رسم العداد النصف دائري
//             CustomPaint(
//               size: const Size(140, 70),
//               painter: GaugePainter(percent: percent, color: color),
//               child: SizedBox(
//                 width: 140,
//                 height: 70,
//                 child: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 20),
//                     child: Text(
//                       text,
//                       style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const Spacer(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _statusCircleCard() {
//     return Expanded(
//       child: Container(
//         height: 200,
//         margin: const EdgeInsets.symmetric(horizontal: 8),
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white, 
//           borderRadius: BorderRadius.circular(25),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 5),
//             )
//           ],
//         ),
//         child: Column(
//           children: [
//             const Text(
//               "حالة نتائج الطلاب", 
//               style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
//             ),
//             const Spacer(),
//             // الدائرة اللونية (تيلي وأصفر)
//             SizedBox(
//               width: 90,
//               height: 90,
//               child: Stack(
//                 children: [
//                   Positioned.fill(
//                     child: CircularProgressIndicator(
//                       value: 0.7, // نسبة النجاح
//                       strokeWidth: 12,
//                       color: const Color(0xFF5AB2B0),
//                       backgroundColor: const Color(0xFFF5A623),
//                       strokeCap: StrokeCap.round,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             // مفتاح الألوان (نجاح / فشل)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _dot(const Color(0xFF5AB2B0), "نجاح"),
//                 const SizedBox(width: 20),
//                 _dot(const Color(0xFFF5A623), "فشل"),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _dot(Color c, String t) {
//     return Row(
//       children: [
//         Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
//         const SizedBox(width: 6),
//         Text(t, style: const TextStyle(fontSize: 11, color: Colors.grey)),
//       ],
//     );
//   }
// }

// // الرسام الخاص بالعداد المقوس (Gauge) ليطابق شكل الصورة تماماً
// class GaugePainter extends CustomPainter {
//   final double percent;
//   final Color color;
//   GaugePainter({required this.percent, required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final rect = Rect.fromLTRB(0, 0, size.width, size.height * 2);
//     const startAngle = math.pi * 1.1; // بداية القوس من اليسار قليلاً للأسفل
//     const sweepAngle = math.pi * 0.8; // طول القوس الإجمالي (أقل من نصف دائرة كاملة)

//     Paint bgPaint = Paint()
//       ..color = const Color(0xFFF4F6F6)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 15
//       ..strokeCap = StrokeCap.round;

//     Paint activePaint = Paint()
//       ..color = color
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 15
//       ..strokeCap = StrokeCap.round;

//     // رسم الخلفية الرمادية للقوس
//     canvas.drawArc(rect, startAngle, sweepAngle, false, bgPaint);
//     // رسم الجزء النشط الملون بناءً على النسبة
//     canvas.drawArc(rect, startAngle, sweepAngle * percent, false, activePaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }


// الكلاس الرئيسي لتوزيع الكروت الثلاثة
class BottomStatsRow extends StatelessWidget {
  const BottomStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         // كارت حالة نتائج الطلاب (الدائرة)
        _statusCircleCard(),
        // كارت نسبة اكتمال مراجعة الأوراق (اللون التيلي)
        _gaugeCard("نسبة اكتمال مراجعة الأوراق المصححة", 0.8, const Color(0xFF5AB2B0), "80%"),
        // كارت نسبة اكتمال نشر النتائج (اللون الأصفر)
        _gaugeCard("نسبة اكتمال نشر النتائج", 0.6, const Color(0xFFF5A623), "60%"),
       
      ],
    );
  }

  Widget _gaugeCard(String title, double percent, Color color, String text) {
    return Expanded(
      child: Container(
        height: 190, // ضبط الارتفاع ليتناسب مع الصورة
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
            ),
            const Spacer(),
            // رسم القوس المقوس (Gauge) المفتوح
            CustomPaint(
              size: const Size(130, 65),
              painter: OpenArcPainter(percent: percent, color: color),
              child: SizedBox(
                width: 130,
                height: 65,
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _statusCircleCard() {
    return Expanded(
      child: Container(
        height: 190,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          children: [
            const Text(
              "حالة نتائج الطلاب", 
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
            ),
            const Spacer(),
            // الدائرة اللونية (تيلي وأصفر)
            SizedBox(
              width: 85,
              height: 85,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CircularProgressIndicator(
                      value: 0.7, // نسبة النجاح
                      strokeWidth: 10,
                      color: const Color(0xFF5AB2B0),
                      backgroundColor: const Color(0xFFF5A623),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // مفتاح الألوان (نجاح / فشل)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(const Color(0xFF5AB2B0), "نجاح"),
                const SizedBox(width: 18),
                _dot(const Color(0xFFF5A623), "فشل"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _dot(Color c, String t) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(t, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

// الرسام الخاص برسم الأقواس المفتوحة والسميكة لتطابق الصورة تماماً
class OpenArcPainter extends CustomPainter {
  final double percent;
  final Color color;
  OpenArcPainter({required this.percent, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    const double strokeWidth = 16;
    
    // زوايا البداية والنهاية لخلق شكل الأنبوب المفتوح
    const startAngle = math.pi * 1.15; // بداية القوس من اليسار مائلاً للأسفل
    const sweepAngle = math.pi * 0.7; // طول القوس الإجمالي (أقل من نصف دائرة)

    Paint bgPaint = Paint()
      ..color = const Color(0xFFF4F6F6) // خلفية رمادية فاتحة جداً للقوس
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round; // حواف دائرية ناعمة

    Paint activePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // رسم الخلفية الرمادية أولاً
    canvas.drawArc(rect, startAngle, sweepAngle, false, bgPaint);
    // رسم الجزء النشط الملون فوقه بناءً على النسبة
    canvas.drawArc(rect, startAngle, sweepAngle * percent, false, activePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}






