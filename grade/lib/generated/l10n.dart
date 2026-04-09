// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Dashboard`
  String get dashboard_title {
    return Intl.message(
      'Dashboard',
      name: 'dashboard_title',
      desc: '',
      args: [],
    );
  }

  /// `Students`
  String get students {
    return Intl.message('Students', name: 'students', desc: '', args: []);
  }

  /// `Corrected Papers`
  String get corrected_papers {
    return Intl.message(
      'Corrected Papers',
      name: 'corrected_papers',
      desc: '',
      args: [],
    );
  }

  /// `Created Exams`
  String get created_exams {
    return Intl.message(
      'Created Exams',
      name: 'created_exams',
      desc: '',
      args: [],
    );
  }

  /// `Drafts`
  String get drafts {
    return Intl.message('Drafts', name: 'drafts', desc: '', args: []);
  }

  /// `Intelligent\nGrading System`
  String get intelligent_grading_system {
    return Intl.message(
      'Intelligent\nGrading System',
      name: 'intelligent_grading_system',
      desc: '',
      args: [],
    );
  }

  /// `Exam Management`
  String get exam_management {
    return Intl.message(
      'Exam Management',
      name: 'exam_management',
      desc: '',
      args: [],
    );
  }

  /// `Materials`
  String get materials {
    return Intl.message('Materials', name: 'materials', desc: '', args: []);
  }

  /// `Correction`
  String get correction {
    return Intl.message('Correction', name: 'correction', desc: '', args: []);
  }

  /// `Review`
  String get review {
    return Intl.message('Review', name: 'review', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Welcome Eng. Khadija!`
  String get welcome_engineer {
    return Intl.message(
      'Welcome Eng. Khadija!',
      name: 'welcome_engineer',
      desc: '',
      args: [],
    );
  }

  /// `Check your statistics`
  String get check_your_stats {
    return Intl.message(
      'Check your statistics',
      name: 'check_your_stats',
      desc: '',
      args: [],
    );
  }

  /// `December`
  String get december {
    return Intl.message('December', name: 'december', desc: '', args: []);
  }

  /// `November`
  String get november {
    return Intl.message('November', name: 'november', desc: '', args: []);
  }

  /// `October`
  String get october {
    return Intl.message('October', name: 'october', desc: '', args: []);
  }

  /// `September`
  String get september {
    return Intl.message('September', name: 'september', desc: '', args: []);
  }

  /// `August`
  String get august {
    return Intl.message('August', name: 'august', desc: '', args: []);
  }

  /// `July`
  String get july {
    return Intl.message('July', name: 'july', desc: '', args: []);
  }

  /// `June`
  String get june {
    return Intl.message('June', name: 'june', desc: '', args: []);
  }

  /// `May`
  String get may {
    return Intl.message('May', name: 'may', desc: '', args: []);
  }

  /// `April`
  String get april {
    return Intl.message('April', name: 'april', desc: '', args: []);
  }

  /// `March`
  String get march {
    return Intl.message('March', name: 'march', desc: '', args: []);
  }

  /// `February`
  String get february {
    return Intl.message('February', name: 'february', desc: '', args: []);
  }

  /// `January`
  String get january {
    return Intl.message('January', name: 'january', desc: '', args: []);
  }

  /// `Monthly Average Student Grades`
  String get students_average_grades_monthly {
    return Intl.message(
      'Monthly Average Student Grades',
      name: 'students_average_grades_monthly',
      desc: '',
      args: [],
    );
  }

  /// `Top 3 Months`
  String get top_3_months {
    return Intl.message(
      'Top 3 Months',
      name: 'top_3_months',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendar {
    return Intl.message('Calendar', name: 'calendar', desc: '', args: []);
  }

  /// `February 2026`
  String get february_2026 {
    return Intl.message(
      'February 2026',
      name: 'february_2026',
      desc: '',
      args: [],
    );
  }

  /// `Sun`
  String get sunday {
    return Intl.message('Sun', name: 'sunday', desc: '', args: []);
  }

  /// `Mon`
  String get monday {
    return Intl.message('Mon', name: 'monday', desc: '', args: []);
  }

  /// `Tue`
  String get tuesday {
    return Intl.message('Tue', name: 'tuesday', desc: '', args: []);
  }

  /// `Wed`
  String get wednesday {
    return Intl.message('Wed', name: 'wednesday', desc: '', args: []);
  }

  /// `Thu`
  String get thursday {
    return Intl.message('Thu', name: 'thursday', desc: '', args: []);
  }

  /// `Fri`
  String get friday {
    return Intl.message('Fri', name: 'friday', desc: '', args: []);
  }

  /// `Sat`
  String get saturday {
    return Intl.message('Sat', name: 'saturday', desc: '', args: []);
  }

  /// `Student Results Status`
  String get students_results_status {
    return Intl.message(
      'Student Results Status',
      name: 'students_results_status',
      desc: '',
      args: [],
    );
  }

  /// `Pass`
  String get pass {
    return Intl.message('Pass', name: 'pass', desc: '', args: []);
  }

  /// `Fail`
  String get fail {
    return Intl.message('Fail', name: 'fail', desc: '', args: []);
  }

  /// `Papers Review Rate`
  String get papers_review_completion_rate {
    return Intl.message(
      'Papers Review Rate',
      name: 'papers_review_completion_rate',
      desc: '',
      args: [],
    );
  }

  /// `Results Publishing Rate`
  String get results_publishing_completion_rate {
    return Intl.message(
      'Results Publishing Rate',
      name: 'results_publishing_completion_rate',
      desc: '',
      args: [],
    );
  }

  /// `Corrected Papers Review Completion Rate`
  String get papers_review_completion_rate_mobile {
    return Intl.message(
      'Corrected Papers Review Completion Rate',
      name: 'papers_review_completion_rate_mobile',
      desc: '',
      args: [],
    );
  }

  /// `Results Publishing Completion Rate`
  String get results_publishing_completion_rate_mobile {
    return Intl.message(
      'Results Publishing Completion Rate',
      name: 'results_publishing_completion_rate_mobile',
      desc: '',
      args: [],
    );
  }

  /// `Manage all your materials and exams`
  String get manage_your_materials_and_exams {
    return Intl.message(
      'Manage all your materials and exams',
      name: 'manage_your_materials_and_exams',
      desc: '',
      args: [],
    );
  }

  /// `Exams`
  String get exams {
    return Intl.message('Exams', name: 'exams', desc: '', args: []);
  }

  /// `Number of Students`
  String get number_of_students {
    return Intl.message(
      'Number of Students',
      name: 'number_of_students',
      desc: '',
      args: [],
    );
  }

  /// `Add Subject`
  String get add_subject {
    return Intl.message('Add Subject', name: 'add_subject', desc: '', args: []);
  }

  /// `Add New Subject`
  String get add_new_subject {
    return Intl.message(
      'Add New Subject',
      name: 'add_new_subject',
      desc: '',
      args: [],
    );
  }

  /// `Subject Name`
  String get subject_name {
    return Intl.message(
      'Subject Name',
      name: 'subject_name',
      desc: '',
      args: [],
    );
  }

  /// `Department`
  String get department {
    return Intl.message('Department', name: 'department', desc: '', args: []);
  }

  /// `Study Level`
  String get study_level {
    return Intl.message('Study Level', name: 'study_level', desc: '', args: []);
  }

  /// `General`
  String get general {
    return Intl.message('General', name: 'general', desc: '', args: []);
  }

  /// `General Department`
  String get general_department {
    return Intl.message(
      'General Department',
      name: 'general_department',
      desc: '',
      args: [],
    );
  }

  /// `Discrete - Level 1`
  String get subject_discrete {
    return Intl.message(
      'Discrete - Level 1',
      name: 'subject_discrete',
      desc: '',
      args: [],
    );
  }

  /// `Computer Science`
  String get dept_cs {
    return Intl.message(
      'Computer Science',
      name: 'dept_cs',
      desc: '',
      args: [],
    );
  }

  /// `Practical Physics - Level 1`
  String get subject_physics {
    return Intl.message(
      'Practical Physics - Level 1',
      name: 'subject_physics',
      desc: '',
      args: [],
    );
  }

  /// `Information Technology`
  String get dept_it {
    return Intl.message(
      'Information Technology',
      name: 'dept_it',
      desc: '',
      args: [],
    );
  }

  /// `Calculus - Level 1`
  String get subject_calculus {
    return Intl.message(
      'Calculus - Level 1',
      name: 'subject_calculus',
      desc: '',
      args: [],
    );
  }

  /// `Integration - Level 1`
  String get subject_integration {
    return Intl.message(
      'Integration - Level 1',
      name: 'subject_integration',
      desc: '',
      args: [],
    );
  }

  /// `Subject Details`
  String get subject_details {
    return Intl.message(
      'Subject Details',
      name: 'subject_details',
      desc: '',
      args: [],
    );
  }

  /// `First Month`
  String get first_month {
    return Intl.message('First Month', name: 'first_month', desc: '', args: []);
  }

  /// `Second Month`
  String get second_month {
    return Intl.message(
      'Second Month',
      name: 'second_month',
      desc: '',
      args: [],
    );
  }

  /// `Final Exams`
  String get final_exams {
    return Intl.message('Final Exams', name: 'final_exams', desc: '', args: []);
  }

  /// `Calculus Exam - Form A`
  String get exam_calculus_a {
    return Intl.message(
      'Calculus Exam - Form A',
      name: 'exam_calculus_a',
      desc: '',
      args: [],
    );
  }

  /// `Calculus Exam - Form B`
  String get exam_calculus_b {
    return Intl.message(
      'Calculus Exam - Form B',
      name: 'exam_calculus_b',
      desc: '',
      args: [],
    );
  }

  /// `Calculus Exam - Form C`
  String get exam_calculus_c {
    return Intl.message(
      'Calculus Exam - Form C',
      name: 'exam_calculus_c',
      desc: '',
      args: [],
    );
  }

  /// `Integration Exam - Form A`
  String get exam_integration_a {
    return Intl.message(
      'Integration Exam - Form A',
      name: 'exam_integration_a',
      desc: '',
      args: [],
    );
  }

  /// `Integration Exam - Form B`
  String get exam_integration_b {
    return Intl.message(
      'Integration Exam - Form B',
      name: 'exam_integration_b',
      desc: '',
      args: [],
    );
  }

  /// `Final - Math 1`
  String get final_math_1 {
    return Intl.message(
      'Final - Math 1',
      name: 'final_math_1',
      desc: '',
      args: [],
    );
  }

  /// `Final - Math 2`
  String get final_math_2 {
    return Intl.message(
      'Final - Math 2',
      name: 'final_math_2',
      desc: '',
      args: [],
    );
  }

  /// `Final - Math 3`
  String get final_math_3 {
    return Intl.message(
      'Final - Math 3',
      name: 'final_math_3',
      desc: '',
      args: [],
    );
  }

  /// `Final - Physics A`
  String get final_physics_a {
    return Intl.message(
      'Final - Physics A',
      name: 'final_physics_a',
      desc: '',
      args: [],
    );
  }

  /// `Final - Physics B`
  String get final_physics_b {
    return Intl.message(
      'Final - Physics B',
      name: 'final_physics_b',
      desc: '',
      args: [],
    );
  }

  /// `Final - Physics C`
  String get final_physics_c {
    return Intl.message(
      'Final - Physics C',
      name: 'final_physics_c',
      desc: '',
      args: [],
    );
  }

  /// `Final - Chemistry A`
  String get final_chemistry_a {
    return Intl.message(
      'Final - Chemistry A',
      name: 'final_chemistry_a',
      desc: '',
      args: [],
    );
  }

  /// `Final - Chemistry B`
  String get final_chemistry_b {
    return Intl.message(
      'Final - Chemistry B',
      name: 'final_chemistry_b',
      desc: '',
      args: [],
    );
  }

  /// `Final - Chemistry C`
  String get final_chemistry_c {
    return Intl.message(
      'Final - Chemistry C',
      name: 'final_chemistry_c',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get status_completed {
    return Intl.message(
      'Completed',
      name: 'status_completed',
      desc: '',
      args: [],
    );
  }

  /// `Draft`
  String get status_draft {
    return Intl.message('Draft', name: 'status_draft', desc: '', args: []);
  }

  /// `Feb 12, 2026`
  String get date_feb_12 {
    return Intl.message(
      'Feb 12, 2026',
      name: 'date_feb_12',
      desc: '',
      args: [],
    );
  }

  /// `Feb 25, 2026`
  String get date_feb_25 {
    return Intl.message(
      'Feb 25, 2026',
      name: 'date_feb_25',
      desc: '',
      args: [],
    );
  }

  /// `Mar 12, 2026`
  String get date_mar_12 {
    return Intl.message(
      'Mar 12, 2026',
      name: 'date_mar_12',
      desc: '',
      args: [],
    );
  }

  /// `Apr 01, 2026`
  String get date_apr_01 {
    return Intl.message(
      'Apr 01, 2026',
      name: 'date_apr_01',
      desc: '',
      args: [],
    );
  }

  /// `Apr 10, 2026`
  String get date_apr_10 {
    return Intl.message(
      'Apr 10, 2026',
      name: 'date_apr_10',
      desc: '',
      args: [],
    );
  }

  /// `Jun 15, 2026`
  String get date_jun_15 {
    return Intl.message(
      'Jun 15, 2026',
      name: 'date_jun_15',
      desc: '',
      args: [],
    );
  }

  /// `Jun 16, 2026`
  String get date_jun_16 {
    return Intl.message(
      'Jun 16, 2026',
      name: 'date_jun_16',
      desc: '',
      args: [],
    );
  }

  /// `Jun 17, 2026`
  String get date_jun_17 {
    return Intl.message(
      'Jun 17, 2026',
      name: 'date_jun_17',
      desc: '',
      args: [],
    );
  }

  /// `Jun 18, 2026`
  String get date_jun_18 {
    return Intl.message(
      'Jun 18, 2026',
      name: 'date_jun_18',
      desc: '',
      args: [],
    );
  }

  /// `Jun 19, 2026`
  String get date_jun_19 {
    return Intl.message(
      'Jun 19, 2026',
      name: 'date_jun_19',
      desc: '',
      args: [],
    );
  }

  /// `Jun 20, 2026`
  String get date_jun_20 {
    return Intl.message(
      'Jun 20, 2026',
      name: 'date_jun_20',
      desc: '',
      args: [],
    );
  }

  /// `Jun 21, 2026`
  String get date_jun_21 {
    return Intl.message(
      'Jun 21, 2026',
      name: 'date_jun_21',
      desc: '',
      args: [],
    );
  }

  /// `Jun 22, 2026`
  String get date_jun_22 {
    return Intl.message(
      'Jun 22, 2026',
      name: 'date_jun_22',
      desc: '',
      args: [],
    );
  }

  /// `Jun 23, 2026`
  String get date_jun_23 {
    return Intl.message(
      'Jun 23, 2026',
      name: 'date_jun_23',
      desc: '',
      args: [],
    );
  }

  /// `Add New Folder`
  String get add_new_folder {
    return Intl.message(
      'Add New Folder',
      name: 'add_new_folder',
      desc: '',
      args: [],
    );
  }

  /// `New Folder Name`
  String get new_folder_name {
    return Intl.message(
      'New Folder Name',
      name: 'new_folder_name',
      desc: '',
      args: [],
    );
  }

  /// `New Folder`
  String get new_folder {
    return Intl.message('New Folder', name: 'new_folder', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `2 days ago`
  String get two_days_ago {
    return Intl.message('2 days ago', name: 'two_days_ago', desc: '', args: []);
  }

  /// `1 week ago`
  String get a_week_ago {
    return Intl.message('1 week ago', name: 'a_week_ago', desc: '', args: []);
  }

  /// `1 month ago`
  String get a_month_ago {
    return Intl.message('1 month ago', name: 'a_month_ago', desc: '', args: []);
  }

  /// `Just Now`
  String get just_now {
    return Intl.message('Just Now', name: 'just_now', desc: '', args: []);
  }

  /// `Files`
  String get files {
    return Intl.message('Files', name: 'files', desc: '', args: []);
  }

  /// `Calculus`
  String get calculus {
    return Intl.message('Calculus', name: 'calculus', desc: '', args: []);
  }

  /// `Exams List for`
  String get exams_list {
    return Intl.message(
      'Exams List for',
      name: 'exams_list',
      desc: '',
      args: [],
    );
  }

  /// `Create Exam`
  String get create_exam {
    return Intl.message('Create Exam', name: 'create_exam', desc: '', args: []);
  }

  /// `Exam Name`
  String get exam_name {
    return Intl.message('Exam Name', name: 'exam_name', desc: '', args: []);
  }

  /// `Exam Date`
  String get exam_date {
    return Intl.message('Exam Date', name: 'exam_date', desc: '', args: []);
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Actions`
  String get actions {
    return Intl.message('Actions', name: 'actions', desc: '', args: []);
  }

  /// `Edit Exam Data`
  String get edit_exam_data {
    return Intl.message(
      'Edit Exam Data',
      name: 'edit_exam_data',
      desc: '',
      args: [],
    );
  }

  /// `Student`
  String get student {
    return Intl.message('Student', name: 'student', desc: '', args: []);
  }

  /// `Choose Exam Type`
  String get choose_exam_type {
    return Intl.message(
      'Choose Exam Type',
      name: 'choose_exam_type',
      desc: '',
      args: [],
    );
  }

  /// `Create Manual Exam`
  String get create_manual_exam {
    return Intl.message(
      'Create Manual Exam',
      name: 'create_manual_exam',
      desc: '',
      args: [],
    );
  }

  /// `Create AI Exam`
  String get create_ai_exam {
    return Intl.message(
      'Create AI Exam',
      name: 'create_ai_exam',
      desc: '',
      args: [],
    );
  }

  /// `Advanced Programming`
  String get advanced_programming {
    return Intl.message(
      'Advanced Programming',
      name: 'advanced_programming',
      desc: '',
      args: [],
    );
  }

  /// `Midterm Exam`
  String get midterm_exam {
    return Intl.message(
      'Midterm Exam',
      name: 'midterm_exam',
      desc: '',
      args: [],
    );
  }

  /// `Auto Grading`
  String get auto_grading {
    return Intl.message(
      'Auto Grading',
      name: 'auto_grading',
      desc: '',
      args: [],
    );
  }

  /// `Click to select files from your device`
  String get click_to_select_files {
    return Intl.message(
      'Click to select files from your device',
      name: 'click_to_select_files',
      desc: '',
      args: [],
    );
  }

  /// `Choose Files`
  String get choose_files {
    return Intl.message(
      'Choose Files',
      name: 'choose_files',
      desc: '',
      args: [],
    );
  }

  /// `Processing data...`
  String get processing_data {
    return Intl.message(
      'Processing data...',
      name: 'processing_data',
      desc: '',
      args: [],
    );
  }

  /// `Ready to start grading now`
  String get ready_to_start_grading {
    return Intl.message(
      'Ready to start grading now',
      name: 'ready_to_start_grading',
      desc: '',
      args: [],
    );
  }

  /// `No papers attached`
  String get no_papers_attached {
    return Intl.message(
      'No papers attached',
      name: 'no_papers_attached',
      desc: '',
      args: [],
    );
  }

  /// `valid answer sheets`
  String get valid_answer_sheets {
    return Intl.message(
      'valid answer sheets',
      name: 'valid_answer_sheets',
      desc: '',
      args: [],
    );
  }

  /// `Start Auto Grading`
  String get start_auto_grading {
    return Intl.message(
      'Start Auto Grading',
      name: 'start_auto_grading',
      desc: '',
      args: [],
    );
  }

  /// `Auto Grading in Progress...`
  String get auto_grading_in_progress {
    return Intl.message(
      'Auto Grading in Progress...',
      name: 'auto_grading_in_progress',
      desc: '',
      args: [],
    );
  }

  /// `Please do not close this page during the automated grading process.`
  String get do_not_close_page_during_grading {
    return Intl.message(
      'Please do not close this page during the automated grading process.',
      name: 'do_not_close_page_during_grading',
      desc: '',
      args: [],
    );
  }

  /// `Overall Progress`
  String get overall_progress {
    return Intl.message(
      'Overall Progress',
      name: 'overall_progress',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `In Progress`
  String get in_progress {
    return Intl.message('In Progress', name: 'in_progress', desc: '', args: []);
  }

  /// `Waiting`
  String get waiting {
    return Intl.message('Waiting', name: 'waiting', desc: '', args: []);
  }

  /// `Remaining`
  String get remaining {
    return Intl.message('Remaining', name: 'remaining', desc: '', args: []);
  }

  /// `Automated Grading Completed!`
  String get auto_grading_completed {
    return Intl.message(
      'Automated Grading Completed!',
      name: 'auto_grading_completed',
      desc: '',
      args: [],
    );
  }

  /// `View Graded Papers`
  String get view_graded_papers {
    return Intl.message(
      'View Graded Papers',
      name: 'view_graded_papers',
      desc: '',
      args: [],
    );
  }

  /// `Exam Information`
  String get exam_information {
    return Intl.message(
      'Exam Information',
      name: 'exam_information',
      desc: '',
      args: [],
    );
  }

  /// `Course Subject`
  String get course_subject {
    return Intl.message(
      'Course Subject',
      name: 'course_subject',
      desc: '',
      args: [],
    );
  }

  /// `Total Grade`
  String get total_grade {
    return Intl.message('Total Grade', name: 'total_grade', desc: '', args: []);
  }

  /// `Uploaded Files`
  String get uploaded_files {
    return Intl.message(
      'Uploaded Files',
      name: 'uploaded_files',
      desc: '',
      args: [],
    );
  }

  /// `Delete All`
  String get delete_all {
    return Intl.message('Delete All', name: 'delete_all', desc: '', args: []);
  }

  /// `Upload Answer Sheets`
  String get upload_answer_sheets {
    return Intl.message(
      'Upload Answer Sheets',
      name: 'upload_answer_sheets',
      desc: '',
      args: [],
    );
  }

  /// `Upload PDF answer sheets to begin automated grading`
  String get upload_answer_sheets_desc {
    return Intl.message(
      'Upload PDF answer sheets to begin automated grading',
      name: 'upload_answer_sheets_desc',
      desc: '',
      args: [],
    );
  }

  /// `Number of Questions`
  String get number_of_questions {
    return Intl.message(
      'Number of Questions',
      name: 'number_of_questions',
      desc: '',
      args: [],
    );
  }

  /// `Exam Formatting`
  String get exam_formatting {
    return Intl.message(
      'Exam Formatting',
      name: 'exam_formatting',
      desc: '',
      args: [],
    );
  }

  /// `Next Page`
  String get next_page {
    return Intl.message('Next Page', name: 'next_page', desc: '', args: []);
  }

  /// `Logo`
  String get logo {
    return Intl.message('Logo', name: 'logo', desc: '', args: []);
  }

  /// `Hadhramout University`
  String get university_name {
    return Intl.message(
      'Hadhramout University',
      name: 'university_name',
      desc: '',
      args: [],
    );
  }

  /// `Faculty of Computers and Information Technology`
  String get college_name {
    return Intl.message(
      'Faculty of Computers and Information Technology',
      name: 'college_name',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Exam`
  String get monthly_exam {
    return Intl.message(
      'Monthly Exam',
      name: 'monthly_exam',
      desc: '',
      args: [],
    );
  }

  /// `Academic Year: 2024/2025`
  String get academic_year_value {
    return Intl.message(
      'Academic Year: 2024/2025',
      name: 'academic_year_value',
      desc: '',
      args: [],
    );
  }

  /// `Exam Date: 5/11/2025`
  String get exam_date_value {
    return Intl.message(
      'Exam Date: 5/11/2025',
      name: 'exam_date_value',
      desc: '',
      args: [],
    );
  }

  /// `Examiner: Mohammed Ali Matar`
  String get examiner_value {
    return Intl.message(
      'Examiner: Mohammed Ali Matar',
      name: 'examiner_value',
      desc: '',
      args: [],
    );
  }

  /// `Allowed Time: One Hour`
  String get allowed_time_value {
    return Intl.message(
      'Allowed Time: One Hour',
      name: 'allowed_time_value',
      desc: '',
      args: [],
    );
  }

  /// `Semester: 1 (Monthly)`
  String get semester_value {
    return Intl.message(
      'Semester: 1 (Monthly)',
      name: 'semester_value',
      desc: '',
      args: [],
    );
  }

  /// `Level: 4`
  String get level_value {
    return Intl.message('Level: 4', name: 'level_value', desc: '', args: []);
  }

  /// `Department: Information Technology`
  String get department_value {
    return Intl.message(
      'Department: Information Technology',
      name: 'department_value',
      desc: '',
      args: [],
    );
  }

  /// `Subject: Mobile App Development`
  String get subject_value {
    return Intl.message(
      'Subject: Mobile App Development',
      name: 'subject_value',
      desc: '',
      args: [],
    );
  }

  /// `Student Name:`
  String get student_name_label {
    return Intl.message(
      'Student Name:',
      name: 'student_name_label',
      desc: '',
      args: [],
    );
  }

  /// `Q`
  String get question_label {
    return Intl.message('Q', name: 'question_label', desc: '', args: []);
  }

  /// `Answer all the following questions`
  String get answer_all_questions {
    return Intl.message(
      'Answer all the following questions',
      name: 'answer_all_questions',
      desc: '',
      args: [],
    );
  }

  /// `Mark`
  String get grade_label {
    return Intl.message('Mark', name: 'grade_label', desc: '', args: []);
  }

  /// `Exam Preview`
  String get exam_preview {
    return Intl.message(
      'Exam Preview',
      name: 'exam_preview',
      desc: '',
      args: [],
    );
  }

  /// `--- Good Luck ---`
  String get good_luck {
    return Intl.message(
      '--- Good Luck ---',
      name: 'good_luck',
      desc: '',
      args: [],
    );
  }

  /// `Download PDF`
  String get download_pdf {
    return Intl.message(
      'Download PDF',
      name: 'download_pdf',
      desc: '',
      args: [],
    );
  }

  /// `Previous Page`
  String get previous_page {
    return Intl.message(
      'Previous Page',
      name: 'previous_page',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
