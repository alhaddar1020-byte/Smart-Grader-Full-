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

  /// `Smart Corrector System`
  String get appName {
    return Intl.message(
      'Smart Corrector System',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Intelligent\nGrading System`
  String get app_name {
    return Intl.message(
      'Intelligent\nGrading System',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Smart Corrector System`
  String get app_title {
    return Intl.message(
      'Smart Corrector System',
      name: 'app_title',
      desc: '',
      args: [],
    );
  }

  /// `Intelligent Grading System`
  String get systemName {
    return Intl.message(
      'Intelligent Grading System',
      name: 'systemName',
      desc: '',
      args: [],
    );
  }

  /// `Smart `
  String get systemTitlePrefix {
    return Intl.message(
      'Smart ',
      name: 'systemTitlePrefix',
      desc: '',
      args: [],
    );
  }

  /// `Corrector`
  String get systemTitleSuffix {
    return Intl.message(
      'Corrector',
      name: 'systemTitleSuffix',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message('Dashboard', name: 'dashboard', desc: '', args: []);
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

  /// `Dashboard`
  String get dashboardTitle {
    return Intl.message(
      'Dashboard',
      name: 'dashboardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Have a successful school day`
  String get dashboard_subtitle {
    return Intl.message(
      'Have a successful school day',
      name: 'dashboard_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Students`
  String get students {
    return Intl.message('Students', name: 'students', desc: '', args: []);
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

  /// `Total Students`
  String get total_students {
    return Intl.message(
      'Total Students',
      name: 'total_students',
      desc: '',
      args: [],
    );
  }

  /// `Student`
  String get student {
    return Intl.message('Student', name: 'student', desc: '', args: []);
  }

  /// `Students`
  String get students_category {
    return Intl.message(
      'Students',
      name: 'students_category',
      desc: '',
      args: [],
    );
  }

  /// `Teachers`
  String get teachers_category {
    return Intl.message(
      'Teachers',
      name: 'teachers_category',
      desc: '',
      args: [],
    );
  }

  /// `Admins`
  String get admins_category {
    return Intl.message('Admins', name: 'admins_category', desc: '', args: []);
  }

  /// `Total Students`
  String get stat_students {
    return Intl.message(
      'Total Students',
      name: 'stat_students',
      desc: '',
      args: [],
    );
  }

  /// `Total Teachers`
  String get stat_teachers {
    return Intl.message(
      'Total Teachers',
      name: 'stat_teachers',
      desc: '',
      args: [],
    );
  }

  /// `Total Exams Conducted`
  String get stat_exams {
    return Intl.message(
      'Total Exams Conducted',
      name: 'stat_exams',
      desc: '',
      args: [],
    );
  }

  /// `Active Users`
  String get stat_active_users {
    return Intl.message(
      'Active Users',
      name: 'stat_active_users',
      desc: '',
      args: [],
    );
  }

  /// `↑ +12% from last month`
  String get stat_students_desc {
    return Intl.message(
      '↑ +12% from last month',
      name: 'stat_students_desc',
      desc: '',
      args: [],
    );
  }

  /// `↑ +5% from last month`
  String get stat_teachers_desc {
    return Intl.message(
      '↑ +5% from last month',
      name: 'stat_teachers_desc',
      desc: '',
      args: [],
    );
  }

  /// `↑ +18% from last month`
  String get stat_exams_desc {
    return Intl.message(
      '↑ +18% from last month',
      name: 'stat_exams_desc',
      desc: '',
      args: [],
    );
  }

  /// `↑ +8% from last month`
  String get stat_active_users_desc {
    return Intl.message(
      '↑ +8% from last month',
      name: 'stat_active_users_desc',
      desc: '',
      args: [],
    );
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

  /// `Exams Management`
  String get exams_management {
    return Intl.message(
      'Exams Management',
      name: 'exams_management',
      desc: '',
      args: [],
    );
  }

  /// `Exam Management`
  String get exam_management_title {
    return Intl.message(
      'Exam Management',
      name: 'exam_management_title',
      desc: '',
      args: [],
    );
  }

  /// `Materials`
  String get materials {
    return Intl.message('Materials', name: 'materials', desc: '', args: []);
  }

  /// `Subjects`
  String get subjects {
    return Intl.message('Subjects', name: 'subjects', desc: '', args: []);
  }

  /// `Correction`
  String get correction {
    return Intl.message('Correction', name: 'correction', desc: '', args: []);
  }

  /// `Grading`
  String get grading {
    return Intl.message('Grading', name: 'grading', desc: '', args: []);
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

  /// `Welcome, Ms. Manar!`
  String get welcome_user {
    return Intl.message(
      'Welcome, Ms. Manar!',
      name: 'welcome_user',
      desc: '',
      args: [],
    );
  }

  /// `Welcome, Ms. Manar!`
  String get welcome_teacher {
    return Intl.message(
      'Welcome, Ms. Manar!',
      name: 'welcome_teacher',
      desc: '',
      args: [],
    );
  }

  /// `Welcome {name}!`
  String welcomeMessage(Object name) {
    return Intl.message(
      'Welcome $name!',
      name: 'welcomeMessage',
      desc: '',
      args: [name],
    );
  }

  /// `Welcome {name}!`
  String welcome(Object name) {
    return Intl.message(
      'Welcome $name!',
      name: 'welcome',
      desc: '',
      args: [name],
    );
  }

  /// `We wish you a successful school day`
  String get goodDay {
    return Intl.message(
      'We wish you a successful school day',
      name: 'goodDay',
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

  /// `Organize your academic exams and turn them into valuable results with high accuracy.`
  String get manage_your_materials_and_exams {
    return Intl.message(
      'Organize your academic exams and turn them into valuable results with high accuracy.',
      name: 'manage_your_materials_and_exams',
      desc: '',
      args: [],
    );
  }

  /// `Exams`
  String get exams {
    return Intl.message('Exams', name: 'exams', desc: '', args: []);
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

  /// `Question`
  String get question_label {
    return Intl.message('Question', name: 'question_label', desc: '', args: []);
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

  /// `Grade`
  String get grade_label {
    return Intl.message('Grade', name: 'grade_label', desc: '', args: []);
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

  /// `Explore your subjects and track your progress`
  String get subExplore {
    return Intl.message(
      'Explore your subjects and track your progress',
      name: 'subExplore',
      desc: '',
      args: [],
    );
  }

  /// `Customize account and app settings`
  String get subSettings {
    return Intl.message(
      'Customize account and app settings',
      name: 'subSettings',
      desc: '',
      args: [],
    );
  }

  /// `Exam details and final review`
  String get subExam {
    return Intl.message(
      'Exam details and final review',
      name: 'subExam',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get sidebarHome {
    return Intl.message('Dashboard', name: 'sidebarHome', desc: '', args: []);
  }

  /// `Subjects`
  String get sidebarMaterials {
    return Intl.message(
      'Subjects',
      name: 'sidebarMaterials',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get sidebarSettings {
    return Intl.message(
      'Settings',
      name: 'sidebarSettings',
      desc: '',
      args: [],
    );
  }

  /// `Subjects`
  String get statMaterials {
    return Intl.message('Subjects', name: 'statMaterials', desc: '', args: []);
  }

  /// `Average`
  String get statAverage {
    return Intl.message('Average', name: 'statAverage', desc: '', args: []);
  }

  /// `Highest Score`
  String get statHighScore {
    return Intl.message(
      'Highest Score',
      name: 'statHighScore',
      desc: '',
      args: [],
    );
  }

  /// `Recent Results`
  String get recentResults {
    return Intl.message(
      'Recent Results',
      name: 'recentResults',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get viewAll {
    return Intl.message('View All', name: 'viewAll', desc: '', args: []);
  }

  /// `View All Subjects`
  String get viewAllMaterials {
    return Intl.message(
      'View All Subjects',
      name: 'viewAllMaterials',
      desc: '',
      args: [],
    );
  }

  /// `Performance Summary`
  String get performanceSummary {
    return Intl.message(
      'Performance Summary',
      name: 'performanceSummary',
      desc: '',
      args: [],
    );
  }

  /// `Graded Materials`
  String get gradedMaterials {
    return Intl.message(
      'Graded Materials',
      name: 'gradedMaterials',
      desc: '',
      args: [],
    );
  }

  /// `Success Rate`
  String get successRate {
    return Intl.message(
      'Success Rate',
      name: 'successRate',
      desc: '',
      args: [],
    );
  }

  /// `Top Student`
  String get distinguishedStudent {
    return Intl.message(
      'Top Student',
      name: 'distinguishedStudent',
      desc: '',
      args: [],
    );
  }

  /// `You maintained an average of %{badge}`
  String badgeMaintain(Object badge) {
    return Intl.message(
      'You maintained an average of %$badge',
      name: 'badgeMaintain',
      desc: '',
      args: [badge],
    );
  }

  /// `Page Not Found`
  String get pageNotFound {
    return Intl.message(
      'Page Not Found',
      name: 'pageNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Highest Score`
  String get statsHighestScore {
    return Intl.message(
      'Highest Score',
      name: 'statsHighestScore',
      desc: '',
      args: [],
    );
  }

  /// `GPA`
  String get statsGPA {
    return Intl.message('GPA', name: 'statsGPA', desc: '', args: []);
  }

  /// `First Term`
  String get termFirst {
    return Intl.message('First Term', name: 'termFirst', desc: '', args: []);
  }

  /// `Second Term`
  String get termSecond {
    return Intl.message('Second Term', name: 'termSecond', desc: '', args: []);
  }

  /// `Last Exam`
  String get lastExam {
    return Intl.message('Last Exam', name: 'lastExam', desc: '', args: []);
  }

  /// `Total marks`
  String get gradeLabel {
    return Intl.message('Total marks', name: 'gradeLabel', desc: '', args: []);
  }

  /// `Exams`
  String get examsLabel {
    return Intl.message('Exams', name: 'examsLabel', desc: '', args: []);
  }

  /// `Academic Subjects`
  String get subjectsTitle {
    return Intl.message(
      'Academic Subjects',
      name: 'subjectsTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have answered`
  String get questionsMasteredTitle {
    return Intl.message(
      'You have answered',
      name: 'questionsMasteredTitle',
      desc: '',
      args: [],
    );
  }

  /// `{count} correct and complete answers`
  String correctAnswersCount(Object count) {
    return Intl.message(
      '$count correct and complete answers',
      name: 'correctAnswersCount',
      desc: '',
      args: [count],
    );
  }

  /// `Throughout the academic year`
  String get throughoutYourJourney {
    return Intl.message(
      'Throughout the academic year',
      name: 'throughoutYourJourney',
      desc: '',
      args: [],
    );
  }

  /// `Passed Exams`
  String get passing {
    return Intl.message('Passed Exams', name: 'passing', desc: '', args: []);
  }

  /// `No exam paper images uploaded yet`
  String get noPaperImagesUploaded {
    return Intl.message(
      'No exam paper images uploaded yet',
      name: 'noPaperImagesUploaded',
      desc: '',
      args: [],
    );
  }

  /// `Swipe left and right to see the remaining pages ({count} pages)`
  String swipeToSeeMorePages(Object count) {
    return Intl.message(
      'Swipe left and right to see the remaining pages ($count pages)',
      name: 'swipeToSeeMorePages',
      desc: '',
      args: [count],
    );
  }

  /// `Min result`
  String get statMinGrade {
    return Intl.message('Min result', name: 'statMinGrade', desc: '', args: []);
  }

  /// `Max result`
  String get statMaxGrade {
    return Intl.message('Max result', name: 'statMaxGrade', desc: '', args: []);
  }

  /// `Date`
  String get examDate {
    return Intl.message('Date', name: 'examDate', desc: '', args: []);
  }

  /// `Questions`
  String get examQuestions {
    return Intl.message('Questions', name: 'examQuestions', desc: '', args: []);
  }

  /// `Answers`
  String get examAnswers {
    return Intl.message('Answers', name: 'examAnswers', desc: '', args: []);
  }

  /// `Rating`
  String get examRating {
    return Intl.message('Rating', name: 'examRating', desc: '', args: []);
  }

  /// `View Details`
  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `of`
  String get gradeOf {
    return Intl.message('of', name: 'gradeOf', desc: '', args: []);
  }

  /// `Strengths`
  String get strengths {
    return Intl.message('Strengths', name: 'strengths', desc: '', args: []);
  }

  /// `Improvements`
  String get improvements {
    return Intl.message(
      'Improvements',
      name: 'improvements',
      desc: '',
      args: [],
    );
  }

  /// `Materials`
  String get backToMaterials {
    return Intl.message(
      'Materials',
      name: 'backToMaterials',
      desc: '',
      args: [],
    );
  }

  /// `Materials`
  String get examMaterials {
    return Intl.message('Materials', name: 'examMaterials', desc: '', args: []);
  }

  /// `Details`
  String get examDetails {
    return Intl.message('Details', name: 'examDetails', desc: '', args: []);
  }

  /// `Total`
  String get examTotalQuestions {
    return Intl.message(
      'Total',
      name: 'examTotalQuestions',
      desc: '',
      args: [],
    );
  }

  /// `Wrong`
  String get examWrongAnswers {
    return Intl.message('Wrong', name: 'examWrongAnswers', desc: '', args: []);
  }

  /// `Partial`
  String get examPartialAnswers {
    return Intl.message(
      'Partial',
      name: 'examPartialAnswers',
      desc: '',
      args: [],
    );
  }

  /// `Correct`
  String get examCorrectAnswers {
    return Intl.message(
      'Correct',
      name: 'examCorrectAnswers',
      desc: '',
      args: [],
    );
  }

  /// `Result`
  String get examResultTitle {
    return Intl.message('Result', name: 'examResultTitle', desc: '', args: []);
  }

  /// `Out of {total}`
  String examOutOf(Object total) {
    return Intl.message(
      'Out of $total',
      name: 'examOutOf',
      desc: '',
      args: [total],
    );
  }

  /// `Download`
  String get examDownload {
    return Intl.message('Download', name: 'examDownload', desc: '', args: []);
  }

  /// `Detailed Correction`
  String get examDetailedCorrection {
    return Intl.message(
      'Detailed Correction',
      name: 'examDetailedCorrection',
      desc: '',
      args: [],
    );
  }

  /// `Answer Paper`
  String get examAnswerPaper {
    return Intl.message(
      'Answer Paper',
      name: 'examAnswerPaper',
      desc: '',
      args: [],
    );
  }

  /// `Question {id}`
  String examQuestionNumber(Object id) {
    return Intl.message(
      'Question $id',
      name: 'examQuestionNumber',
      desc: '',
      args: [id],
    );
  }

  /// `Model Answer`
  String get examModelAnswer {
    return Intl.message(
      'Model Answer',
      name: 'examModelAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Your Answer`
  String get examYourAnswer {
    return Intl.message(
      'Your Answer',
      name: 'examYourAnswer',
      desc: '',
      args: [],
    );
  }

  /// `AI Evaluation`
  String get examAiEvaluation {
    return Intl.message(
      'AI Evaluation',
      name: 'examAiEvaluation',
      desc: '',
      args: [],
    );
  }

  /// `Original Answer Paper (Image Preview)`
  String get examOriginalPaperView {
    return Intl.message(
      'Original Answer Paper (Image Preview)',
      name: 'examOriginalPaperView',
      desc: '',
      args: [],
    );
  }

  /// `Detailed Exam Report`
  String get reportTitle {
    return Intl.message(
      'Detailed Exam Report',
      name: 'reportTitle',
      desc: '',
      args: [],
    );
  }

  /// `Student Name:`
  String get studentName {
    return Intl.message(
      'Student Name:',
      name: 'studentName',
      desc: '',
      args: [],
    );
  }

  /// `Level:`
  String get level {
    return Intl.message('Level:', name: 'level', desc: '', args: []);
  }

  /// `Exam:`
  String get exam {
    return Intl.message('Exam:', name: 'exam', desc: '', args: []);
  }

  /// `Date:`
  String get date {
    return Intl.message('Date:', name: 'date', desc: '', args: []);
  }

  /// `Answers & Evaluation Details:`
  String get details {
    return Intl.message(
      'Answers & Evaluation Details:',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Total Score:`
  String get totalScore {
    return Intl.message('Total Score:', name: 'totalScore', desc: '', args: []);
  }

  /// `No.`
  String get colNo {
    return Intl.message('No.', name: 'colNo', desc: '', args: []);
  }

  /// `Question`
  String get colQuestion {
    return Intl.message('Question', name: 'colQuestion', desc: '', args: []);
  }

  /// `Student Answer`
  String get colStudentAns {
    return Intl.message(
      'Student Answer',
      name: 'colStudentAns',
      desc: '',
      args: [],
    );
  }

  /// `Model Answer`
  String get colModelAns {
    return Intl.message(
      'Model Answer',
      name: 'colModelAns',
      desc: '',
      args: [],
    );
  }

  /// `Score`
  String get colScore {
    return Intl.message('Score', name: 'colScore', desc: '', args: []);
  }

  /// `Preview Exam Report`
  String get previewReportTitle {
    return Intl.message(
      'Preview Exam Report',
      name: 'previewReportTitle',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsTitle {
    return Intl.message('Settings', name: 'settingsTitle', desc: '', args: []);
  }

  /// `Profile Information`
  String get settingsProfileData {
    return Intl.message(
      'Profile Information',
      name: 'settingsProfileData',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get settingsFullName {
    return Intl.message(
      'Full Name',
      name: 'settingsFullName',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get settingsPhone {
    return Intl.message(
      'Phone Number',
      name: 'settingsPhone',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get settingsEmail {
    return Intl.message(
      'Email Address',
      name: 'settingsEmail',
      desc: '',
      args: [],
    );
  }

  /// `Education Level`
  String get settingsLevel {
    return Intl.message(
      'Education Level',
      name: 'settingsLevel',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get settingsEditProfile {
    return Intl.message(
      'Edit Profile',
      name: 'settingsEditProfile',
      desc: '',
      args: [],
    );
  }

  /// `Security & Authentication`
  String get settingsSecurityTitle {
    return Intl.message(
      'Security & Authentication',
      name: 'settingsSecurityTitle',
      desc: '',
      args: [],
    );
  }

  /// `Password Management`
  String get settingsManagePassword {
    return Intl.message(
      'Password Management',
      name: 'settingsManagePassword',
      desc: '',
      args: [],
    );
  }

  /// `Last changed: {date}`
  String settingsLastChange(Object date) {
    return Intl.message(
      'Last changed: $date',
      name: 'settingsLastChange',
      desc: '',
      args: [date],
    );
  }

  /// `Change Password`
  String get settingsChangePassword {
    return Intl.message(
      'Change Password',
      name: 'settingsChangePassword',
      desc: '',
      args: [],
    );
  }

  /// `Display Preferences`
  String get settingsDisplayPrefs {
    return Intl.message(
      'Display Preferences',
      name: 'settingsDisplayPrefs',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get settingsDarkMode {
    return Intl.message(
      'Dark Mode',
      name: 'settingsDarkMode',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get settingsLanguage {
    return Intl.message(
      'Language',
      name: 'settingsLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Danger Zone`
  String get settingsDangerZone {
    return Intl.message(
      'Danger Zone',
      name: 'settingsDangerZone',
      desc: '',
      args: [],
    );
  }

  /// `Your account will only be deactivated; your data will not be deleted..`
  String get settingsDangerDesc {
    return Intl.message(
      'Your account will only be deactivated; your data will not be deleted..',
      name: 'settingsDangerDesc',
      desc: '',
      args: [],
    );
  }

  /// `Deactivate Account`
  String get settingsDeactivate {
    return Intl.message(
      'Deactivate Account',
      name: 'settingsDeactivate',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get settingsCurrentPassword {
    return Intl.message(
      'Current Password',
      name: 'settingsCurrentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get settingsNewPassword {
    return Intl.message(
      'New Password',
      name: 'settingsNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get settingsConfirmPassword {
    return Intl.message(
      'Confirm New Password',
      name: 'settingsConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password Strength: {strength}`
  String settingsStrength(Object strength) {
    return Intl.message(
      'Password Strength: $strength',
      name: 'settingsStrength',
      desc: '',
      args: [strength],
    );
  }

  /// `Save`
  String get settingsSave {
    return Intl.message('Save', name: 'settingsSave', desc: '', args: []);
  }

  /// `Cancel`
  String get settingsCancel {
    return Intl.message('Cancel', name: 'settingsCancel', desc: '', args: []);
  }

  /// `Update`
  String get settingsUpdate {
    return Intl.message('Update', name: 'settingsUpdate', desc: '', args: []);
  }

  /// `Success`
  String get settingsSuccess {
    return Intl.message('Success', name: 'settingsSuccess', desc: '', args: []);
  }

  /// `Passwords do not match`
  String get settingsMatchError {
    return Intl.message(
      'Passwords do not match',
      name: 'settingsMatchError',
      desc: '',
      args: [],
    );
  }

  /// `Password Strength: {strength}`
  String settingsStrengthLabel(Object strength) {
    return Intl.message(
      'Password Strength: $strength',
      name: 'settingsStrengthLabel',
      desc: '',
      args: [strength],
    );
  }

  /// `Weak`
  String get settingsStrengthWeak {
    return Intl.message(
      'Weak',
      name: 'settingsStrengthWeak',
      desc: '',
      args: [],
    );
  }

  /// `Medium`
  String get settingsStrengthMedium {
    return Intl.message(
      'Medium',
      name: 'settingsStrengthMedium',
      desc: '',
      args: [],
    );
  }

  /// `Strong`
  String get settingsStrengthStrong {
    return Intl.message(
      'Strong',
      name: 'settingsStrengthStrong',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get logoutConfirmationDesc {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'logoutConfirmationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Logout`
  String get confirmLogout {
    return Intl.message(
      'Confirm Logout',
      name: 'confirmLogout',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get logoutCancel {
    return Intl.message('Cancel', name: 'logoutCancel', desc: '', args: []);
  }

  /// `Edit Full Name`
  String get settingsEditFullName {
    return Intl.message(
      'Edit Full Name',
      name: 'settingsEditFullName',
      desc: '',
      args: [],
    );
  }

  /// `New Name`
  String get settingsNewName {
    return Intl.message(
      'New Name',
      name: 'settingsNewName',
      desc: '',
      args: [],
    );
  }

  /// `Identity Verification`
  String get settingsIdentityVerification {
    return Intl.message(
      'Identity Verification',
      name: 'settingsIdentityVerification',
      desc: '',
      args: [],
    );
  }

  /// `Change Email Address`
  String get settingsChangeEmail {
    return Intl.message(
      'Change Email Address',
      name: 'settingsChangeEmail',
      desc: '',
      args: [],
    );
  }

  /// `A verification code will be sent to your current email`
  String get settingsOtpSentToCurrentEmail {
    return Intl.message(
      'A verification code will be sent to your current email',
      name: 'settingsOtpSentToCurrentEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter the verification code sent to your current email`
  String get settingsEnterOtpSent {
    return Intl.message(
      'Enter the verification code sent to your current email',
      name: 'settingsEnterOtpSent',
      desc: '',
      args: [],
    );
  }

  /// `New Email Address`
  String get settingsNewEmail {
    return Intl.message(
      'New Email Address',
      name: 'settingsNewEmail',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get settingsOtpCode {
    return Intl.message(
      'Verification Code',
      name: 'settingsOtpCode',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get settingsConfirm {
    return Intl.message('Confirm', name: 'settingsConfirm', desc: '', args: []);
  }

  /// `Send Code`
  String get settingsSendCode {
    return Intl.message(
      'Send Code',
      name: 'settingsSendCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email address`
  String get settingsEnterValidEmail {
    return Intl.message(
      'Enter a valid email address',
      name: 'settingsEnterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Verification code sent successfully`
  String get settingsOtpSentSuccess {
    return Intl.message(
      'Verification code sent successfully',
      name: 'settingsOtpSentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Enter a 6-digit code`
  String get settingsEnter6DigitOtp {
    return Intl.message(
      'Enter a 6-digit code',
      name: 'settingsEnter6DigitOtp',
      desc: '',
      args: [],
    );
  }

  /// `Email updated successfully`
  String get settingsEmailUpdated {
    return Intl.message(
      'Email updated successfully',
      name: 'settingsEmailUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect verification code`
  String get settingsOtpIncorrect {
    return Intl.message(
      'Incorrect verification code',
      name: 'settingsOtpIncorrect',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get settingsForgotPassword {
    return Intl.message(
      'Forgot your password?',
      name: 'settingsForgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all fields`
  String get settingsFillAllFields {
    return Intl.message(
      'Please fill in all fields',
      name: 'settingsFillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `New passwords do not match`
  String get settingsPasswordNotMatch {
    return Intl.message(
      'New passwords do not match',
      name: 'settingsPasswordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Current password is incorrect`
  String get settingsIncorrectCurrentPassword {
    return Intl.message(
      'Current password is incorrect',
      name: 'settingsIncorrectCurrentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password updated successfully`
  String get settingsPasswordUpdated {
    return Intl.message(
      'Password updated successfully',
      name: 'settingsPasswordUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get settingsError {
    return Intl.message('Error', name: 'settingsError', desc: '', args: []);
  }

  /// `Warning`
  String get settingsWarning {
    return Intl.message('Warning', name: 'settingsWarning', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `تغيير للغة العربية`
  String get change_lang {
    return Intl.message(
      'تغيير للغة العربية',
      name: 'change_lang',
      desc: '',
      args: [],
    );
  }

  /// `About System`
  String get about_system {
    return Intl.message(
      'About System',
      name: 'about_system',
      desc: '',
      args: [],
    );
  }

  /// `An advanced AI-powered solution for grading exams and assignments with high accuracy and speed.`
  String get description {
    return Intl.message(
      'An advanced AI-powered solution for grading exams and assignments with high accuracy and speed.',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Grading Accuracy`
  String get accuracy {
    return Intl.message(
      'Grading Accuracy',
      name: 'accuracy',
      desc: '',
      args: [],
    );
  }

  /// `Time Saving`
  String get time_saving {
    return Intl.message('Time Saving', name: 'time_saving', desc: '', args: []);
  }

  /// `© 2026 Smart Corrector System. All rights reserved.`
  String get copyright {
    return Intl.message(
      '© 2026 Smart Corrector System. All rights reserved.',
      name: 'copyright',
      desc: '',
      args: [],
    );
  }

  /// `Create New Exam`
  String get create_new_exam {
    return Intl.message(
      'Create New Exam',
      name: 'create_new_exam',
      desc: '',
      args: [],
    );
  }

  /// `Create an exam using AI`
  String get create_exam_subtitle {
    return Intl.message(
      'Create an exam using AI',
      name: 'create_exam_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Explore your subjects and track progress`
  String get subjects_subtitle {
    return Intl.message(
      'Explore your subjects and track progress',
      name: 'subjects_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Grading uploaded student papers`
  String get grading_subtitle {
    return Intl.message(
      'Grading uploaded student papers',
      name: 'grading_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Exam details and final review`
  String get review_subtitle {
    return Intl.message(
      'Exam details and final review',
      name: 'review_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Customize account settings`
  String get settings_subtitle {
    return Intl.message(
      'Customize account settings',
      name: 'settings_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the Intelligent Grading System`
  String get default_subtitle {
    return Intl.message(
      'Welcome to the Intelligent Grading System',
      name: 'default_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `of`
  String get of_total {
    return Intl.message('of', name: 'of_total', desc: '', args: []);
  }

  /// `Page not found`
  String get page_not_found {
    return Intl.message(
      'Page not found',
      name: 'page_not_found',
      desc: '',
      args: [],
    );
  }

  /// `AI Generation Results`
  String get ai_generation_results {
    return Intl.message(
      'AI Generation Results',
      name: 'ai_generation_results',
      desc: '',
      args: [],
    );
  }

  /// `Exam Details`
  String get exam_details {
    return Intl.message(
      'Exam Details',
      name: 'exam_details',
      desc: '',
      args: [],
    );
  }

  /// `Total Questions`
  String get total_questions {
    return Intl.message(
      'Total Questions',
      name: 'total_questions',
      desc: '',
      args: [],
    );
  }

  /// `AI Accuracy`
  String get ai_accuracy {
    return Intl.message('AI Accuracy', name: 'ai_accuracy', desc: '', args: []);
  }

  /// `Keywords`
  String get keywords {
    return Intl.message('Keywords', name: 'keywords', desc: '', args: []);
  }

  /// `Approve Exam`
  String get approve_exam {
    return Intl.message(
      'Approve Exam',
      name: 'approve_exam',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit_exam {
    return Intl.message('Edit', name: 'edit_exam', desc: '', args: []);
  }

  /// `Cancel Edit`
  String get cancel_edit {
    return Intl.message('Cancel Edit', name: 'cancel_edit', desc: '', args: []);
  }

  /// `Model Answer`
  String get model_answer {
    return Intl.message(
      'Model Answer',
      name: 'model_answer',
      desc: '',
      args: [],
    );
  }

  /// `AI Update`
  String get ai_update {
    return Intl.message('AI Update', name: 'ai_update', desc: '', args: []);
  }

  /// `Space allocated for the student's essay answer`
  String get essay_placeholder {
    return Intl.message(
      'Space allocated for the student\'s essay answer',
      name: 'essay_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `True`
  String get true_word {
    return Intl.message('True', name: 'true_word', desc: '', args: []);
  }

  /// `False`
  String get false_word {
    return Intl.message('False', name: 'false_word', desc: '', args: []);
  }

  /// `An error occurred while opening files`
  String get error_opening_file {
    return Intl.message(
      'An error occurred while opening files',
      name: 'error_opening_file',
      desc: '',
      args: [],
    );
  }

  /// `Add New User`
  String get add_new_user {
    return Intl.message(
      'Add New User',
      name: 'add_new_user',
      desc: '',
      args: [],
    );
  }

  /// `Bulk Upload (Excel)`
  String get bulk_upload_excel {
    return Intl.message(
      'Bulk Upload (Excel)',
      name: 'bulk_upload_excel',
      desc: '',
      args: [],
    );
  }

  /// `Manual Entry`
  String get manual_entry {
    return Intl.message(
      'Manual Entry',
      name: 'manual_entry',
      desc: '',
      args: [],
    );
  }

  /// `File ready to upload:`
  String get ready_to_upload_file {
    return Intl.message(
      'File ready to upload:',
      name: 'ready_to_upload_file',
      desc: '',
      args: [],
    );
  }

  /// `Drag and drop Excel file here`
  String get drag_drop_excel {
    return Intl.message(
      'Drag and drop Excel file here',
      name: 'drag_drop_excel',
      desc: '',
      args: [],
    );
  }

  /// `Change File`
  String get change_file {
    return Intl.message('Change File', name: 'change_file', desc: '', args: []);
  }

  /// `Browse Files`
  String get browse_files {
    return Intl.message(
      'Browse Files',
      name: 'browse_files',
      desc: '',
      args: [],
    );
  }

  /// `Supported formats: .xlsx, .xls, .csv (Max 5MB)`
  String get supported_file_formats {
    return Intl.message(
      'Supported formats: .xlsx, .xls, .csv (Max 5MB)',
      name: 'supported_file_formats',
      desc: '',
      args: [],
    );
  }

  /// `Please select a file first before uploading!`
  String get please_select_file_first {
    return Intl.message(
      'Please select a file first before uploading!',
      name: 'please_select_file_first',
      desc: '',
      args: [],
    );
  }

  /// `Save & Upload File`
  String get save_and_upload_file {
    return Intl.message(
      'Save & Upload File',
      name: 'save_and_upload_file',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get first_name {
    return Intl.message('First Name', name: 'first_name', desc: '', args: []);
  }

  /// `Last Name`
  String get last_name {
    return Intl.message('Last Name', name: 'last_name', desc: '', args: []);
  }

  /// `ID Number`
  String get id_number {
    return Intl.message('ID Number', name: 'id_number', desc: '', args: []);
  }

  /// `Email Address`
  String get email_address {
    return Intl.message(
      'Email Address',
      name: 'email_address',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get field_required {
    return Intl.message(
      'This field is required',
      name: 'field_required',
      desc: '',
      args: [],
    );
  }

  /// `Please ensure all required fields are filled!`
  String get fill_all_required_fields {
    return Intl.message(
      'Please ensure all required fields are filled!',
      name: 'fill_all_required_fields',
      desc: '',
      args: [],
    );
  }

  /// `Save & Add`
  String get save_and_add {
    return Intl.message('Save & Add', name: 'save_and_add', desc: '', args: []);
  }

  /// `Confirm File Upload`
  String get confirm_file_upload {
    return Intl.message(
      'Confirm File Upload',
      name: 'confirm_file_upload',
      desc: '',
      args: [],
    );
  }

  /// `Select User Category`
  String get select_user_category {
    return Intl.message(
      'Select User Category',
      name: 'select_user_category',
      desc: '',
      args: [],
    );
  }

  /// `The file data will be saved as:`
  String get file_will_be_saved_as {
    return Intl.message(
      'The file data will be saved as:',
      name: 'file_will_be_saved_as',
      desc: '',
      args: [],
    );
  }

  /// `Please select the category to be added to the system:`
  String get please_select_category_to_add {
    return Intl.message(
      'Please select the category to be added to the system:',
      name: 'please_select_category_to_add',
      desc: '',
      args: [],
    );
  }

  /// `Operation successful for category:`
  String get operation_successful_for_category {
    return Intl.message(
      'Operation successful for category:',
      name: 'operation_successful_for_category',
      desc: '',
      args: [],
    );
  }

  /// `Confirm & Save`
  String get confirm_and_save {
    return Intl.message(
      'Confirm & Save',
      name: 'confirm_and_save',
      desc: '',
      args: [],
    );
  }

  /// `Upload Instructions`
  String get upload_instructions {
    return Intl.message(
      'Upload Instructions',
      name: 'upload_instructions',
      desc: '',
      args: [],
    );
  }

  /// `Ensure you use the approved Excel template.`
  String get instruction_1 {
    return Intl.message(
      'Ensure you use the approved Excel template.',
      name: 'instruction_1',
      desc: '',
      args: [],
    );
  }

  /// `Do not modify column headers in the template.`
  String get instruction_2 {
    return Intl.message(
      'Do not modify column headers in the template.',
      name: 'instruction_2',
      desc: '',
      args: [],
    );
  }

  /// `Verify ID numbers are correct (10 digits).`
  String get instruction_3 {
    return Intl.message(
      'Verify ID numbers are correct (10 digits).',
      name: 'instruction_3',
      desc: '',
      args: [],
    );
  }

  /// `Maximum file size is 5MB.`
  String get instruction_4 {
    return Intl.message(
      'Maximum file size is 5MB.',
      name: 'instruction_4',
      desc: '',
      args: [],
    );
  }

  /// `You can review errors in the import history.`
  String get instruction_5 {
    return Intl.message(
      'You can review errors in the import history.',
      name: 'instruction_5',
      desc: '',
      args: [],
    );
  }

  /// `Import History`
  String get import_history {
    return Intl.message(
      'Import History',
      name: 'import_history',
      desc: '',
      args: [],
    );
  }

  /// `File Name`
  String get file_name {
    return Intl.message('File Name', name: 'file_name', desc: '', args: []);
  }

  /// `Upload Date`
  String get upload_date {
    return Intl.message('Upload Date', name: 'upload_date', desc: '', args: []);
  }

  /// `Count`
  String get count {
    return Intl.message('Count', name: 'count', desc: '', args: []);
  }

  /// `Failed`
  String get failed {
    return Intl.message('Failed', name: 'failed', desc: '', args: []);
  }

  /// `Viewing file:`
  String get viewing_file {
    return Intl.message(
      'Viewing file:',
      name: 'viewing_file',
      desc: '',
      args: [],
    );
  }

  /// `Downloading file:`
  String get downloading_file {
    return Intl.message(
      'Downloading file:',
      name: 'downloading_file',
      desc: '',
      args: [],
    );
  }

  /// `File deleted successfully!`
  String get file_deleted_successfully {
    return Intl.message(
      'File deleted successfully!',
      name: 'file_deleted_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Upload Name`
  String get upload_name {
    return Intl.message('Upload Name', name: 'upload_name', desc: '', args: []);
  }

  /// `Settings (Under Development 🚧)`
  String get settings_under_development {
    return Intl.message(
      'Settings (Under Development 🚧)',
      name: 'settings_under_development',
      desc: '',
      args: [],
    );
  }

  /// `Users Management`
  String get users_management {
    return Intl.message(
      'Users Management',
      name: 'users_management',
      desc: '',
      args: [],
    );
  }

  /// `Reports & Statistics`
  String get reports_statistics {
    return Intl.message(
      'Reports & Statistics',
      name: 'reports_statistics',
      desc: '',
      args: [],
    );
  }

  /// `System Logs`
  String get system_logs {
    return Intl.message('System Logs', name: 'system_logs', desc: '', args: []);
  }

  /// `Backup`
  String get backup {
    return Intl.message('Backup', name: 'backup', desc: '', args: []);
  }

  /// `Failed Login Attempt`
  String get alert_login_failed {
    return Intl.message(
      'Failed Login Attempt',
      name: 'alert_login_failed',
      desc: '',
      args: [],
    );
  }

  /// `3 failed attempts detected from IP: 192.168.1.105`
  String get alert_login_failed_desc {
    return Intl.message(
      '3 failed attempts detected from IP: 192.168.1.105',
      name: 'alert_login_failed_desc',
      desc: '',
      args: [],
    );
  }

  /// `5 mins ago`
  String get alert_time_5m {
    return Intl.message(
      '5 mins ago',
      name: 'alert_time_5m',
      desc: '',
      args: [],
    );
  }

  /// `Low Storage Space`
  String get alert_storage_low {
    return Intl.message(
      'Low Storage Space',
      name: 'alert_storage_low',
      desc: '',
      args: [],
    );
  }

  /// `78% of available space used`
  String get alert_storage_low_desc {
    return Intl.message(
      '78% of available space used',
      name: 'alert_storage_low_desc',
      desc: '',
      args: [],
    );
  }

  /// `15 mins ago`
  String get alert_time_15m {
    return Intl.message(
      '15 mins ago',
      name: 'alert_time_15m',
      desc: '',
      args: [],
    );
  }

  /// `Successful Backup`
  String get alert_backup_success {
    return Intl.message(
      'Successful Backup',
      name: 'alert_backup_success',
      desc: '',
      args: [],
    );
  }

  /// `Full system backup created`
  String get alert_backup_success_desc {
    return Intl.message(
      'Full system backup created',
      name: 'alert_backup_success_desc',
      desc: '',
      args: [],
    );
  }

  /// `1 hour ago`
  String get alert_time_1h {
    return Intl.message(
      '1 hour ago',
      name: 'alert_time_1h',
      desc: '',
      args: [],
    );
  }

  /// `System Usage Rate`
  String get system_usage_rate {
    return Intl.message(
      'System Usage Rate',
      name: 'system_usage_rate',
      desc: '',
      args: [],
    );
  }

  /// `Weekly usage percentage over the last 3 months`
  String get weekly_usage_desc {
    return Intl.message(
      'Weekly usage percentage over the last 3 months',
      name: 'weekly_usage_desc',
      desc: '',
      args: [],
    );
  }

  /// `Month 1`
  String get month_1 {
    return Intl.message('Month 1', name: 'month_1', desc: '', args: []);
  }

  /// `Month 2`
  String get month_2 {
    return Intl.message('Month 2', name: 'month_2', desc: '', args: []);
  }

  /// `Month 3`
  String get month_3 {
    return Intl.message('Month 3', name: 'month_3', desc: '', args: []);
  }

  /// `Current`
  String get current_month {
    return Intl.message('Current', name: 'current_month', desc: '', args: []);
  }

  /// `Number of Exams`
  String get number_of_exams {
    return Intl.message(
      'Number of Exams',
      name: 'number_of_exams',
      desc: '',
      args: [],
    );
  }

  /// `Success Rate`
  String get success_rate {
    return Intl.message(
      'Success Rate',
      name: 'success_rate',
      desc: '',
      args: [],
    );
  }

  /// `Average Scores`
  String get average_scores {
    return Intl.message(
      'Average Scores',
      name: 'average_scores',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Alerts Log`
  String get alerts_log {
    return Intl.message('Alerts Log', name: 'alerts_log', desc: '', args: []);
  }

  /// `View All`
  String get view_all {
    return Intl.message('View All', name: 'view_all', desc: '', args: []);
  }

  /// `All Alerts`
  String get all_alerts {
    return Intl.message('All Alerts', name: 'all_alerts', desc: '', args: []);
  }

  /// `System Management / Backup`
  String get admin_backup_title {
    return Intl.message(
      'System Management / Backup',
      name: 'admin_backup_title',
      desc: '',
      args: [],
    );
  }

  /// `Backup Management`
  String get backup_management {
    return Intl.message(
      'Backup Management',
      name: 'backup_management',
      desc: '',
      args: [],
    );
  }

  /// `Save and restore system data to ensure no loss of grades and records`
  String get backup_management_desc {
    return Intl.message(
      'Save and restore system data to ensure no loss of grades and records',
      name: 'backup_management_desc',
      desc: '',
      args: [],
    );
  }

  /// `Last backup created`
  String get last_backup_created {
    return Intl.message(
      'Last backup created',
      name: 'last_backup_created',
      desc: '',
      args: [],
    );
  }

  /// `Creating a new backup...`
  String get creating_new_backup_snackbar {
    return Intl.message(
      'Creating a new backup...',
      name: 'creating_new_backup_snackbar',
      desc: '',
      args: [],
    );
  }

  /// `Backup Now`
  String get backup_now_button {
    return Intl.message(
      'Backup Now',
      name: 'backup_now_button',
      desc: '',
      args: [],
    );
  }

  /// `Backups History`
  String get backups_history_title {
    return Intl.message(
      'Backups History',
      name: 'backups_history_title',
      desc: '',
      args: [],
    );
  }

  /// `Date & Time`
  String get date_and_time {
    return Intl.message(
      'Date & Time',
      name: 'date_and_time',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get size {
    return Intl.message('Size', name: 'size', desc: '', args: []);
  }

  /// `Started downloading backup:`
  String get downloading_backup_snackbar {
    return Intl.message(
      'Started downloading backup:',
      name: 'downloading_backup_snackbar',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download_button {
    return Intl.message(
      'Download',
      name: 'download_button',
      desc: '',
      args: [],
    );
  }

  /// `Restoring system to this backup...`
  String get restoring_system_snackbar {
    return Intl.message(
      'Restoring system to this backup...',
      name: 'restoring_system_snackbar',
      desc: '',
      args: [],
    );
  }

  /// `Restore`
  String get restore_button {
    return Intl.message('Restore', name: 'restore_button', desc: '', args: []);
  }

  /// `Recent System Logs`
  String get recent_system_logs_title {
    return Intl.message(
      'Recent System Logs',
      name: 'recent_system_logs_title',
      desc: '',
      args: [],
    );
  }

  /// `Event`
  String get event {
    return Intl.message('Event', name: 'event', desc: '', args: []);
  }

  /// `Type`
  String get type {
    return Intl.message('Type', name: 'type', desc: '', args: []);
  }

  /// `Time`
  String get time {
    return Intl.message('Time', name: 'time', desc: '', args: []);
  }

  /// `Success`
  String get success {
    return Intl.message('Success', name: 'success', desc: '', args: []);
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Info`
  String get info {
    return Intl.message('Info', name: 'info', desc: '', args: []);
  }

  /// `Uptime`
  String get uptime {
    return Intl.message('Uptime', name: 'uptime', desc: '', args: []);
  }

  /// `Database Size`
  String get db_size {
    return Intl.message('Database Size', name: 'db_size', desc: '', args: []);
  }

  /// `Total Backups`
  String get total_backups {
    return Intl.message(
      'Total Backups',
      name: 'total_backups',
      desc: '',
      args: [],
    );
  }

  /// `System Status`
  String get system_status {
    return Intl.message(
      'System Status',
      name: 'system_status',
      desc: '',
      args: [],
    );
  }

  /// `Stable & Excellent`
  String get system_stable {
    return Intl.message(
      'Stable & Excellent',
      name: 'system_stable',
      desc: '',
      args: [],
    );
  }

  /// `Generating PDF file...`
  String get generating_pdf {
    return Intl.message(
      'Generating PDF file...',
      name: 'generating_pdf',
      desc: '',
      args: [],
    );
  }

  /// `Smart Grader System Report`
  String get pdf_report_title {
    return Intl.message(
      'Smart Grader System Report',
      name: 'pdf_report_title',
      desc: '',
      args: [],
    );
  }

  /// `Total Students: 2,540`
  String get pdf_total_students {
    return Intl.message(
      'Total Students: 2,540',
      name: 'pdf_total_students',
      desc: '',
      args: [],
    );
  }

  /// `General Average: 85%`
  String get pdf_general_average {
    return Intl.message(
      'General Average: 85%',
      name: 'pdf_general_average',
      desc: '',
      args: [],
    );
  }

  /// `Active Teachers: 45`
  String get pdf_active_teachers {
    return Intl.message(
      'Active Teachers: 45',
      name: 'pdf_active_teachers',
      desc: '',
      args: [],
    );
  }

  /// `Overall Performance:`
  String get pdf_overall_performance {
    return Intl.message(
      'Overall Performance:',
      name: 'pdf_overall_performance',
      desc: '',
      args: [],
    );
  }

  /// `System Usage:`
  String get pdf_system_usage {
    return Intl.message(
      'System Usage:',
      name: 'pdf_system_usage',
      desc: '',
      args: [],
    );
  }

  /// `Rank`
  String get rank {
    return Intl.message('Rank', name: 'rank', desc: '', args: []);
  }

  /// `Teacher Name`
  String get teacher_name {
    return Intl.message(
      'Teacher Name',
      name: 'teacher_name',
      desc: '',
      args: [],
    );
  }

  /// `Tasks Count`
  String get tasks_count {
    return Intl.message('Tasks Count', name: 'tasks_count', desc: '', args: []);
  }

  /// `task`
  String get task_word {
    return Intl.message('task', name: 'task_word', desc: '', args: []);
  }

  /// `Subjects Performance Reports:`
  String get pdf_subjects_performance {
    return Intl.message(
      'Subjects Performance Reports:',
      name: 'pdf_subjects_performance',
      desc: '',
      args: [],
    );
  }

  /// `Subject`
  String get subject {
    return Intl.message('Subject', name: 'subject', desc: '', args: []);
  }

  /// `Success Rate`
  String get success_rate_label {
    return Intl.message(
      'Success Rate',
      name: 'success_rate_label',
      desc: '',
      args: [],
    );
  }

  /// `Fail Rate`
  String get fail_rate_label {
    return Intl.message(
      'Fail Rate',
      name: 'fail_rate_label',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred during export`
  String get export_error {
    return Intl.message(
      'An error occurred during export',
      name: 'export_error',
      desc: '',
      args: [],
    );
  }

  /// `Export to PDF`
  String get export_pdf_button {
    return Intl.message(
      'Export to PDF',
      name: 'export_pdf_button',
      desc: '',
      args: [],
    );
  }

  /// `General Average`
  String get general_average {
    return Intl.message(
      'General Average',
      name: 'general_average',
      desc: '',
      args: [],
    );
  }

  /// `Active Teachers`
  String get active_teachers {
    return Intl.message(
      'Active Teachers',
      name: 'active_teachers',
      desc: '',
      args: [],
    );
  }

  /// `Overall Performance (All graded papers)`
  String get overall_performance_title {
    return Intl.message(
      'Overall Performance (All graded papers)',
      name: 'overall_performance_title',
      desc: '',
      args: [],
    );
  }

  /// `Pass`
  String get pass_status {
    return Intl.message('Pass', name: 'pass_status', desc: '', args: []);
  }

  /// `Fail`
  String get fail_status {
    return Intl.message('Fail', name: 'fail_status', desc: '', args: []);
  }

  /// `System Usage & Digital Transformation`
  String get system_usage_title {
    return Intl.message(
      'System Usage & Digital Transformation',
      name: 'system_usage_title',
      desc: '',
      args: [],
    );
  }

  /// `Mathematics`
  String get subject_math {
    return Intl.message(
      'Mathematics',
      name: 'subject_math',
      desc: '',
      args: [],
    );
  }

  /// `Holy Quran`
  String get subject_quran {
    return Intl.message(
      'Holy Quran',
      name: 'subject_quran',
      desc: '',
      args: [],
    );
  }

  /// `Arabic Language`
  String get subject_arabic {
    return Intl.message(
      'Arabic Language',
      name: 'subject_arabic',
      desc: '',
      args: [],
    );
  }

  /// `English Language`
  String get subject_english {
    return Intl.message(
      'English Language',
      name: 'subject_english',
      desc: '',
      args: [],
    );
  }

  /// `Science`
  String get subject_science {
    return Intl.message('Science', name: 'subject_science', desc: '', args: []);
  }

  /// `History`
  String get subject_history {
    return Intl.message('History', name: 'subject_history', desc: '', args: []);
  }

  /// `Geography`
  String get subject_geography {
    return Intl.message(
      'Geography',
      name: 'subject_geography',
      desc: '',
      args: [],
    );
  }

  /// `Mr. Ahmed Ali`
  String get teacher_1 {
    return Intl.message('Mr. Ahmed Ali', name: 'teacher_1', desc: '', args: []);
  }

  /// `Ms. Mona Khalid`
  String get teacher_2 {
    return Intl.message(
      'Ms. Mona Khalid',
      name: 'teacher_2',
      desc: '',
      args: [],
    );
  }

  /// `Mr. Saad Al-Otaibi`
  String get teacher_3 {
    return Intl.message(
      'Mr. Saad Al-Otaibi',
      name: 'teacher_3',
      desc: '',
      args: [],
    );
  }

  /// `Ms. Noura Fahad`
  String get teacher_4 {
    return Intl.message(
      'Ms. Noura Fahad',
      name: 'teacher_4',
      desc: '',
      args: [],
    );
  }

  /// `Mr. Mohammed Saleh`
  String get teacher_5 {
    return Intl.message(
      'Mr. Mohammed Saleh',
      name: 'teacher_5',
      desc: '',
      args: [],
    );
  }

  /// `System Management / System Logs`
  String get admin_system_logs_title {
    return Intl.message(
      'System Management / System Logs',
      name: 'admin_system_logs_title',
      desc: '',
      args: [],
    );
  }

  /// `System Logs`
  String get system_logs_title {
    return Intl.message(
      'System Logs',
      name: 'system_logs_title',
      desc: '',
      args: [],
    );
  }

  /// `View and track all activities and actions in the system`
  String get system_logs_desc {
    return Intl.message(
      'View and track all activities and actions in the system',
      name: 'system_logs_desc',
      desc: '',
      args: [],
    );
  }

  /// `Total Actions`
  String get total_actions {
    return Intl.message(
      'Total Actions',
      name: 'total_actions',
      desc: '',
      args: [],
    );
  }

  /// `Login Records`
  String get login_records {
    return Intl.message(
      'Login Records',
      name: 'login_records',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `Search for a user...`
  String get search_user_hint {
    return Intl.message(
      'Search for a user...',
      name: 'search_user_hint',
      desc: '',
      args: [],
    );
  }

  /// `All Roles`
  String get all_roles {
    return Intl.message('All Roles', name: 'all_roles', desc: '', args: []);
  }

  /// `Teacher`
  String get role_teacher {
    return Intl.message('Teacher', name: 'role_teacher', desc: '', args: []);
  }

  /// `Student`
  String get role_student {
    return Intl.message('Student', name: 'role_student', desc: '', args: []);
  }

  /// `Admin`
  String get role_admin {
    return Intl.message('Admin', name: 'role_admin', desc: '', args: []);
  }

  /// `Date Range`
  String get date_range {
    return Intl.message('Date Range', name: 'date_range', desc: '', args: []);
  }

  /// `Export Log`
  String get export_log_button {
    return Intl.message(
      'Export Log',
      name: 'export_log_button',
      desc: '',
      args: [],
    );
  }

  /// `Action Logs`
  String get action_logs_title {
    return Intl.message(
      'Action Logs',
      name: 'action_logs_title',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username_col {
    return Intl.message('Username', name: 'username_col', desc: '', args: []);
  }

  /// `Role`
  String get role_col {
    return Intl.message('Role', name: 'role_col', desc: '', args: []);
  }

  /// `Action`
  String get action_col {
    return Intl.message('Action', name: 'action_col', desc: '', args: []);
  }

  /// `Date & Time`
  String get datetime_col {
    return Intl.message(
      'Date & Time',
      name: 'datetime_col',
      desc: '',
      args: [],
    );
  }

  /// `IP Address`
  String get ip_col {
    return Intl.message('IP Address', name: 'ip_col', desc: '', args: []);
  }

  /// `No matching logs found.`
  String get no_matching_logs {
    return Intl.message(
      'No matching logs found.',
      name: 'no_matching_logs',
      desc: '',
      args: [],
    );
  }

  /// `Log downloaded successfully!`
  String get log_download_success {
    return Intl.message(
      'Log downloaded successfully!',
      name: 'log_download_success',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred: `
  String get error_occurred {
    return Intl.message(
      'An error occurred: ',
      name: 'error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `Total Users`
  String get total_users {
    return Intl.message('Total Users', name: 'total_users', desc: '', args: []);
  }

  /// `Active Users`
  String get active_users_card {
    return Intl.message(
      'Active Users',
      name: 'active_users_card',
      desc: '',
      args: [],
    );
  }

  /// `Users List`
  String get users_list {
    return Intl.message('Users List', name: 'users_list', desc: '', args: []);
  }

  /// `Search...`
  String get search_hint {
    return Intl.message('Search...', name: 'search_hint', desc: '', args: []);
  }

  /// `Filter:`
  String get filter_prefix {
    return Intl.message('Filter:', name: 'filter_prefix', desc: '', args: []);
  }

  /// `Add User`
  String get add_user_btn {
    return Intl.message('Add User', name: 'add_user_btn', desc: '', args: []);
  }

  /// `Full Name`
  String get full_name {
    return Intl.message('Full Name', name: 'full_name', desc: '', args: []);
  }

  /// `Role`
  String get role {
    return Intl.message('Role', name: 'role', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Active`
  String get status_active {
    return Intl.message('Active', name: 'status_active', desc: '', args: []);
  }

  /// `Inactive`
  String get status_inactive {
    return Intl.message(
      'Inactive',
      name: 'status_inactive',
      desc: '',
      args: [],
    );
  }

  /// `No users match your search`
  String get no_users_found {
    return Intl.message(
      'No users match your search',
      name: 'no_users_found',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Deletion`
  String get delete_confirmation {
    return Intl.message(
      'Confirm Deletion',
      name: 'delete_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to permanently delete this user? This action cannot be undone.`
  String get delete_user_warning {
    return Intl.message(
      'Are you sure you want to permanently delete this user? This action cannot be undone.',
      name: 'delete_user_warning',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Delete`
  String get yes_delete {
    return Intl.message('Yes, Delete', name: 'yes_delete', desc: '', args: []);
  }

  /// `Deleted successfully`
  String get delete_success {
    return Intl.message(
      'Deleted successfully',
      name: 'delete_success',
      desc: '',
      args: [],
    );
  }

  /// `Edit User Details`
  String get edit_user {
    return Intl.message(
      'Edit User Details',
      name: 'edit_user',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get save_changes {
    return Intl.message(
      'Save Changes',
      name: 'save_changes',
      desc: '',
      args: [],
    );
  }

  /// `Data updated and saved successfully!`
  String get edit_success {
    return Intl.message(
      'Data updated and saved successfully!',
      name: 'edit_success',
      desc: '',
      args: [],
    );
  }

  /// `Total Teachers`
  String get total_teachers {
    return Intl.message(
      'Total Teachers',
      name: 'total_teachers',
      desc: '',
      args: [],
    );
  }

  /// `Exam Information`
  String get exam_info_title {
    return Intl.message(
      'Exam Information',
      name: 'exam_info_title',
      desc: '',
      args: [],
    );
  }

  /// `Exam Name`
  String get exam_title_label {
    return Intl.message(
      'Exam Name',
      name: 'exam_title_label',
      desc: '',
      args: [],
    );
  }

  /// `Search for a specific exam...`
  String get exam_title_hint {
    return Intl.message(
      'Search for a specific exam...',
      name: 'exam_title_hint',
      desc: '',
      args: [],
    );
  }

  /// `Exam Date`
  String get exam_date_label {
    return Intl.message(
      'Exam Date',
      name: 'exam_date_label',
      desc: '',
      args: [],
    );
  }

  /// `Select Date`
  String get exam_date_hint {
    return Intl.message(
      'Select Date',
      name: 'exam_date_hint',
      desc: '',
      args: [],
    );
  }

  /// `Total Grade`
  String get total_grade_label {
    return Intl.message(
      'Total Grade',
      name: 'total_grade_label',
      desc: '',
      args: [],
    );
  }

  /// `Specialization / Department`
  String get specialization_label {
    return Intl.message(
      'Specialization / Department',
      name: 'specialization_label',
      desc: '',
      args: [],
    );
  }

  /// `Grade Level`
  String get level_label {
    return Intl.message('Grade Level', name: 'level_label', desc: '', args: []);
  }

  /// `Students Count`
  String get students_count_label {
    return Intl.message(
      'Students Count',
      name: 'students_count_label',
      desc: '',
      args: [],
    );
  }

  /// `Select...`
  String get select_hint {
    return Intl.message('Select...', name: 'select_hint', desc: '', args: []);
  }

  /// `Questions Distribution`
  String get questions_distribution {
    return Intl.message(
      'Questions Distribution',
      name: 'questions_distribution',
      desc: '',
      args: [],
    );
  }

  /// `Sum: `
  String get sum_label {
    return Intl.message('Sum: ', name: 'sum_label', desc: '', args: []);
  }

  /// `⚠️ You have unassigned questions.`
  String get unassigned_questions_warning {
    return Intl.message(
      '⚠️ You have unassigned questions.',
      name: 'unassigned_questions_warning',
      desc: '',
      args: [],
    );
  }

  /// `Multiple Choice`
  String get q_mcq {
    return Intl.message('Multiple Choice', name: 'q_mcq', desc: '', args: []);
  }

  /// `True/False`
  String get q_tf {
    return Intl.message('True/False', name: 'q_tf', desc: '', args: []);
  }

  /// `Essay Question`
  String get q_essay {
    return Intl.message('Essay Question', name: 'q_essay', desc: '', args: []);
  }

  /// `Matching`
  String get q_match {
    return Intl.message('Matching', name: 'q_match', desc: '', args: []);
  }

  /// `Fill in Blanks`
  String get q_fill {
    return Intl.message('Fill in Blanks', name: 'q_fill', desc: '', args: []);
  }

  /// `Questions`
  String get questions_word {
    return Intl.message(
      'Questions',
      name: 'questions_word',
      desc: '',
      args: [],
    );
  }

  /// `Difficulty Settings`
  String get difficulty_settings {
    return Intl.message(
      'Difficulty Settings',
      name: 'difficulty_settings',
      desc: '',
      args: [],
    );
  }

  /// `Easy`
  String get diff_easy {
    return Intl.message('Easy', name: 'diff_easy', desc: '', args: []);
  }

  /// `Medium`
  String get diff_medium {
    return Intl.message('Medium', name: 'diff_medium', desc: '', args: []);
  }

  /// `Hard`
  String get diff_hard {
    return Intl.message('Hard', name: 'diff_hard', desc: '', args: []);
  }

  /// `Click here to upload curriculum or notes`
  String get upload_files_prompt {
    return Intl.message(
      'Click here to upload curriculum or notes',
      name: 'upload_files_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get files_selected_1 {
    return Intl.message(
      'Selected',
      name: 'files_selected_1',
      desc: '',
      args: [],
    );
  }

  /// `files, click to upload more`
  String get files_selected_2 {
    return Intl.message(
      'files, click to upload more',
      name: 'files_selected_2',
      desc: '',
      args: [],
    );
  }

  /// `Save as Draft`
  String get save_draft {
    return Intl.message(
      'Save as Draft',
      name: 'save_draft',
      desc: '',
      args: [],
    );
  }

  /// `Create AI Exam`
  String get generate_ai_exam {
    return Intl.message(
      'Create AI Exam',
      name: 'generate_ai_exam',
      desc: '',
      args: [],
    );
  }

  /// `Analyzing files and generating exam\nwith AI...`
  String get analyzing_files {
    return Intl.message(
      'Analyzing files and generating exam\nwith AI...',
      name: 'analyzing_files',
      desc: '',
      args: [],
    );
  }

  /// `⚠️ Please make sure to distribute all questions`
  String get distribution_error {
    return Intl.message(
      '⚠️ Please make sure to distribute all questions',
      name: 'distribution_error',
      desc: '',
      args: [],
    );
  }

  /// `Error opening files`
  String get file_open_error {
    return Intl.message(
      'Error opening files',
      name: 'file_open_error',
      desc: '',
      args: [],
    );
  }

  /// `Mathematics`
  String get spec_math {
    return Intl.message('Mathematics', name: 'spec_math', desc: '', args: []);
  }

  /// `Physics`
  String get spec_physics {
    return Intl.message('Physics', name: 'spec_physics', desc: '', args: []);
  }

  /// `Chemistry`
  String get spec_chemistry {
    return Intl.message(
      'Chemistry',
      name: 'spec_chemistry',
      desc: '',
      args: [],
    );
  }

  /// `Biology`
  String get spec_biology {
    return Intl.message('Biology', name: 'spec_biology', desc: '', args: []);
  }

  /// `Arabic Language`
  String get spec_arabic {
    return Intl.message(
      'Arabic Language',
      name: 'spec_arabic',
      desc: '',
      args: [],
    );
  }

  /// `1st Secondary`
  String get lvl_1 {
    return Intl.message('1st Secondary', name: 'lvl_1', desc: '', args: []);
  }

  /// `2nd Secondary`
  String get lvl_2 {
    return Intl.message('2nd Secondary', name: 'lvl_2', desc: '', args: []);
  }

  /// `3rd Secondary`
  String get lvl_3 {
    return Intl.message('3rd Secondary', name: 'lvl_3', desc: '', args: []);
  }

  /// `Grades & Results Management`
  String get grades_management {
    return Intl.message(
      'Grades & Results Management',
      name: 'grades_management',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get teacher_dashboard {
    return Intl.message(
      'Dashboard',
      name: 'teacher_dashboard',
      desc: '',
      args: [],
    );
  }

  /// `(Under Development)`
  String get under_development {
    return Intl.message(
      '(Under Development)',
      name: 'under_development',
      desc: '',
      args: [],
    );
  }

  /// `✨ Updating via AI...`
  String get updating_ai_snackbar {
    return Intl.message(
      '✨ Updating via AI...',
      name: 'updating_ai_snackbar',
      desc: '',
      args: [],
    );
  }

  /// `Perfect match with model answer`
  String get perfect_match {
    return Intl.message(
      'Perfect match with model answer',
      name: 'perfect_match',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect`
  String get incorrect_answer {
    return Intl.message(
      'Incorrect',
      name: 'incorrect_answer',
      desc: '',
      args: [],
    );
  }

  /// `Incomplete answer... please review.`
  String get incomplete_answer {
    return Intl.message(
      'Incomplete answer... please review.',
      name: 'incomplete_answer',
      desc: '',
      args: [],
    );
  }

  /// `Model Answer for`
  String get model_answer_for {
    return Intl.message(
      'Model Answer for',
      name: 'model_answer_for',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close_btn {
    return Intl.message('Close', name: 'close_btn', desc: '', args: []);
  }

  /// `Show Model Answer`
  String get show_model_answer {
    return Intl.message(
      'Show Model Answer',
      name: 'show_model_answer',
      desc: '',
      args: [],
    );
  }

  /// `Earned Grade:`
  String get earned_grade {
    return Intl.message(
      'Earned Grade:',
      name: 'earned_grade',
      desc: '',
      args: [],
    );
  }

  /// `out of`
  String get out_of {
    return Intl.message('out of', name: 'out_of', desc: '', args: []);
  }

  /// `Student Answer: `
  String get student_answer {
    return Intl.message(
      'Student Answer: ',
      name: 'student_answer',
      desc: '',
      args: [],
    );
  }

  /// `Save & Approve Result`
  String get save_approve_result {
    return Intl.message(
      'Save & Approve Result',
      name: 'save_approve_result',
      desc: '',
      args: [],
    );
  }

  /// `Finish Editing`
  String get finish_editing {
    return Intl.message(
      'Finish Editing',
      name: 'finish_editing',
      desc: '',
      args: [],
    );
  }

  /// `Edit Grades`
  String get edit_grades {
    return Intl.message('Edit Grades', name: 'edit_grades', desc: '', args: []);
  }

  /// `ما هي لغة Dart؟`
  String get question_example_1 {
    return Intl.message(
      'ما هي لغة Dart؟',
      name: 'question_example_1',
      desc: '',
      args: [],
    );
  }

  /// `لغة برمجة لبناء تطبيقات الموبايل.`
  String get student_answer_example_1 {
    return Intl.message(
      'لغة برمجة لبناء تطبيقات الموبايل.',
      name: 'student_answer_example_1',
      desc: '',
      args: [],
    );
  }

  /// `لغة برمجة مطورة من جوجل وتستخدم مع Flutter.`
  String get model_answer_example_1 {
    return Intl.message(
      'لغة برمجة مطورة من جوجل وتستخدم مع Flutter.',
      name: 'model_answer_example_1',
      desc: '',
      args: [],
    );
  }

  /// `هل Flutter يدعم الويب؟`
  String get question_example_2 {
    return Intl.message(
      'هل Flutter يدعم الويب؟',
      name: 'question_example_2',
      desc: '',
      args: [],
    );
  }

  /// `Create Electronic Exam`
  String get create_electronic_exam {
    return Intl.message(
      'Create Electronic Exam',
      name: 'create_electronic_exam',
      desc: '',
      args: [],
    );
  }

  /// `Add questions and set grades manually`
  String get add_questions_manually {
    return Intl.message(
      'Add questions and set grades manually',
      name: 'add_questions_manually',
      desc: '',
      args: [],
    );
  }

  /// `Exam Information`
  String get exam_info {
    return Intl.message(
      'Exam Information',
      name: 'exam_info',
      desc: '',
      args: [],
    );
  }

  /// `First Question`
  String get question_first {
    return Intl.message(
      'First Question',
      name: 'question_first',
      desc: '',
      args: [],
    );
  }

  /// `Second Question`
  String get question_second {
    return Intl.message(
      'Second Question',
      name: 'question_second',
      desc: '',
      args: [],
    );
  }

  /// `Third Question`
  String get question_third {
    return Intl.message(
      'Third Question',
      name: 'question_third',
      desc: '',
      args: [],
    );
  }

  /// `Write question text here...`
  String get write_question_hint {
    return Intl.message(
      'Write question text here...',
      name: 'write_question_hint',
      desc: '',
      args: [],
    );
  }

  /// `Add Option`
  String get add_option {
    return Intl.message('Add Option', name: 'add_option', desc: '', args: []);
  }

  /// `New Option`
  String get new_option {
    return Intl.message('New Option', name: 'new_option', desc: '', args: []);
  }

  /// `Essay answer area`
  String get essay_answer_area {
    return Intl.message(
      'Essay answer area',
      name: 'essay_answer_area',
      desc: '',
      args: [],
    );
  }

  /// `Add New Question`
  String get add_new_question {
    return Intl.message(
      'Add New Question',
      name: 'add_new_question',
      desc: '',
      args: [],
    );
  }

  /// `Save and Approve`
  String get save_and_approve {
    return Intl.message(
      'Save and Approve',
      name: 'save_and_approve',
      desc: '',
      args: [],
    );
  }

  /// `Drafts`
  String get save_as_draft {
    return Intl.message('Drafts', name: 'save_as_draft', desc: '', args: []);
  }

  /// `Enter Time Limit`
  String get write_time_limit {
    return Intl.message(
      'Enter Time Limit',
      name: 'write_time_limit',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Status`
  String get status_label {
    return Intl.message('Status', name: 'status_label', desc: '', args: []);
  }

  /// `Manual`
  String get manual_tab {
    return Intl.message('Manual', name: 'manual_tab', desc: '', args: []);
  }

  /// `AI Exams`
  String get ai_tab {
    return Intl.message('AI Exams', name: 'ai_tab', desc: '', args: []);
  }

  /// `Drafts`
  String get drafts_tab {
    return Intl.message('Drafts', name: 'drafts_tab', desc: '', args: []);
  }

  /// `Enter specialization`
  String get specialization_hint {
    return Intl.message(
      'Enter specialization',
      name: 'specialization_hint',
      desc: '',
      args: [],
    );
  }

  /// `Enter level`
  String get level_hint {
    return Intl.message('Enter level', name: 'level_hint', desc: '', args: []);
  }

  /// `Profile Settings`
  String get profile_settings_title {
    return Intl.message(
      'Profile Settings',
      name: 'profile_settings_title',
      desc: '',
      args: [],
    );
  }

  /// `Update your personal information and account settings`
  String get profile_settings_subtitle {
    return Intl.message(
      'Update your personal information and account settings',
      name: 'profile_settings_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Dr. Mohammed`
  String get doctor_name {
    return Intl.message(
      'Dr. Mohammed',
      name: 'doctor_name',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get full_name_label {
    return Intl.message(
      'Full Name',
      name: 'full_name_label',
      desc: '',
      args: [],
    );
  }

  /// `Khadija Mansour`
  String get full_name_hint {
    return Intl.message(
      'Khadija Mansour',
      name: 'full_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get email_label {
    return Intl.message(
      'Email Address',
      name: 'email_label',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phone_label {
    return Intl.message(
      'Phone Number',
      name: 'phone_label',
      desc: '',
      args: [],
    );
  }

  /// `Level 3`
  String get level_example {
    return Intl.message('Level 3', name: 'level_example', desc: '', args: []);
  }

  /// `Biography`
  String get bio_label {
    return Intl.message('Biography', name: 'bio_label', desc: '', args: []);
  }

  /// `Write a short bio about yourself...`
  String get bio_hint {
    return Intl.message(
      'Write a short bio about yourself...',
      name: 'bio_hint',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get save_changes_button {
    return Intl.message(
      'Save Changes',
      name: 'save_changes_button',
      desc: '',
      args: [],
    );
  }

  /// `An advanced AI-powered solution for grading exams and assignments with high accuracy and speed.\nSave time and effort with an intelligent evaluation system that ensures fairness every time.`
  String get heroSubtitle {
    return Intl.message(
      'An advanced AI-powered solution for grading exams and assignments with high accuracy and speed.\nSave time and effort with an intelligent evaluation system that ensures fairness every time.',
      name: 'heroSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Grading Accuracy`
  String get accuracyLabel {
    return Intl.message(
      'Grading Accuracy',
      name: 'accuracyLabel',
      desc: '',
      args: [],
    );
  }

  /// `Time Saving`
  String get timeSavingLabel {
    return Intl.message(
      'Time Saving',
      name: 'timeSavingLabel',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginButton {
    return Intl.message('Login', name: 'loginButton', desc: '', args: []);
  }

  /// `About System`
  String get aboutSystem {
    return Intl.message(
      'About System',
      name: 'aboutSystem',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get languageLabel {
    return Intl.message('Language', name: 'languageLabel', desc: '', args: []);
  }

  /// `System Features`
  String get about_title {
    return Intl.message(
      'System Features',
      name: 'about_title',
      desc: '',
      args: [],
    );
  }

  /// `High Accuracy`
  String get feat_accuracy_title {
    return Intl.message(
      'High Accuracy',
      name: 'feat_accuracy_title',
      desc: '',
      args: [],
    );
  }

  /// `99.9% accurate grading`
  String get feat_accuracy_desc {
    return Intl.message(
      '99.9% accurate grading',
      name: 'feat_accuracy_desc',
      desc: '',
      args: [],
    );
  }

  /// `Turbo Speed`
  String get feat_speed_title {
    return Intl.message(
      'Turbo Speed',
      name: 'feat_speed_title',
      desc: '',
      args: [],
    );
  }

  /// `Save 75% of your time`
  String get feat_speed_desc {
    return Intl.message(
      'Save 75% of your time',
      name: 'feat_speed_desc',
      desc: '',
      args: [],
    );
  }

  /// `Full Reports`
  String get feat_reports_title {
    return Intl.message(
      'Full Reports',
      name: 'feat_reports_title',
      desc: '',
      args: [],
    );
  }

  /// `Detailed student analytics`
  String get feat_reports_desc {
    return Intl.message(
      'Detailed student analytics',
      name: 'feat_reports_desc',
      desc: '',
      args: [],
    );
  }

  /// `Easy Collaboration`
  String get feat_collab_title {
    return Intl.message(
      'Easy Collaboration',
      name: 'feat_collab_title',
      desc: '',
      args: [],
    );
  }

  /// `Share results seamlessly`
  String get feat_collab_desc {
    return Intl.message(
      'Share results seamlessly',
      name: 'feat_collab_desc',
      desc: '',
      args: [],
    );
  }

  /// `Guaranteed Fairness`
  String get feat_fairness_title {
    return Intl.message(
      'Guaranteed Fairness',
      name: 'feat_fairness_title',
      desc: '',
      args: [],
    );
  }

  /// `Unified grading standards`
  String get feat_fairness_desc {
    return Intl.message(
      'Unified grading standards',
      name: 'feat_fairness_desc',
      desc: '',
      args: [],
    );
  }

  /// `Seamless Integration`
  String get feat_integrations_title {
    return Intl.message(
      'Seamless Integration',
      name: 'feat_integrations_title',
      desc: '',
      args: [],
    );
  }

  /// `Works with management systems`
  String get feat_integrations_desc {
    return Intl.message(
      'Works with management systems',
      name: 'feat_integrations_desc',
      desc: '',
      args: [],
    );
  }

  /// `Login to your account`
  String get login_title {
    return Intl.message(
      'Login to your account',
      name: 'login_title',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to continue using the system`
  String get login_subtitle {
    return Intl.message(
      'Sign in to continue using the system',
      name: 'login_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password_label {
    return Intl.message('Password', name: 'password_label', desc: '', args: []);
  }

  /// `Invalid email address`
  String get email_error {
    return Intl.message(
      'Invalid email address',
      name: 'email_error',
      desc: '',
      args: [],
    );
  }

  /// `Password is too short`
  String get password_error {
    return Intl.message(
      'Password is too short',
      name: 'password_error',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgot_password {
    return Intl.message(
      'Forgot Password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get login_button {
    return Intl.message('Sign In', name: 'login_button', desc: '', args: []);
  }

  /// `Logging in...`
  String get logging_in {
    return Intl.message(
      'Logging in...',
      name: 'logging_in',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get forgot_pw_title {
    return Intl.message(
      'Reset Password',
      name: 'forgot_pw_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter your registered email and we will send you a link to set a new password.`
  String get forgot_pw_subtitle {
    return Intl.message(
      'Enter your registered email and we will send you a link to set a new password.',
      name: 'forgot_pw_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Send Link`
  String get send_link_button {
    return Intl.message(
      'Send Link',
      name: 'send_link_button',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get email_validation_error {
    return Intl.message(
      'Please enter a valid email address',
      name: 'email_validation_error',
      desc: '',
      args: [],
    );
  }

  /// `Reset link has been sent to your email`
  String get link_sent_success {
    return Intl.message(
      'Reset link has been sent to your email',
      name: 'link_sent_success',
      desc: '',
      args: [],
    );
  }

  /// `All (Default)`
  String get filter_all_default {
    return Intl.message(
      'All (Default)',
      name: 'filter_all_default',
      desc: '',
      args: [],
    );
  }

  /// `First Semester`
  String get semester_one {
    return Intl.message(
      'First Semester',
      name: 'semester_one',
      desc: '',
      args: [],
    );
  }

  /// `Second Semester`
  String get semester_two {
    return Intl.message(
      'Second Semester',
      name: 'semester_two',
      desc: '',
      args: [],
    );
  }

  /// `Summer Semester`
  String get semester_summer {
    return Intl.message(
      'Summer Semester',
      name: 'semester_summer',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch data: `
  String get error_fetch_data {
    return Intl.message(
      'Failed to fetch data: ',
      name: 'error_fetch_data',
      desc: '',
      args: [],
    );
  }

  /// `Server connection error: `
  String get error_server_connection {
    return Intl.message(
      'Server connection error: ',
      name: 'error_server_connection',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Total registered in system`
  String get total_registered_system {
    return Intl.message(
      'Total registered in system',
      name: 'total_registered_system',
      desc: '',
      args: [],
    );
  }

  /// `Recently active users`
  String get active_users_recently {
    return Intl.message(
      'Recently active users',
      name: 'active_users_recently',
      desc: '',
      args: [],
    );
  }

  /// `Settings (Admin Panel)`
  String get admin_settings_title {
    return Intl.message(
      'Settings (Admin Panel)',
      name: 'admin_settings_title',
      desc: '',
      args: [],
    );
  }

  /// `Customize Academic and Account Settings`
  String get admin_settings_subtitle {
    return Intl.message(
      'Customize Academic and Account Settings',
      name: 'admin_settings_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Account Settings`
  String get account_settings_tab {
    return Intl.message(
      'Account Settings',
      name: 'account_settings_tab',
      desc: '',
      args: [],
    );
  }

  /// `Academic Settings`
  String get academic_settings_tab {
    return Intl.message(
      'Academic Settings',
      name: 'academic_settings_tab',
      desc: '',
      args: [],
    );
  }

  /// `Academic Semesters & Years`
  String get academic_semesters_title {
    return Intl.message(
      'Academic Semesters & Years',
      name: 'academic_semesters_title',
      desc: '',
      args: [],
    );
  }

  /// `Add New Semester`
  String get add_new_semester {
    return Intl.message(
      'Add New Semester',
      name: 'add_new_semester',
      desc: '',
      args: [],
    );
  }

  /// `No academic semesters added yet.`
  String get no_semesters_added {
    return Intl.message(
      'No academic semesters added yet.',
      name: 'no_semesters_added',
      desc: '',
      args: [],
    );
  }

  /// `Semester Name`
  String get semester_name {
    return Intl.message(
      'Semester Name',
      name: 'semester_name',
      desc: '',
      args: [],
    );
  }

  /// `Academic Year`
  String get academic_year {
    return Intl.message(
      'Academic Year',
      name: 'academic_year',
      desc: '',
      args: [],
    );
  }

  /// `Start Date`
  String get start_date {
    return Intl.message('Start Date', name: 'start_date', desc: '', args: []);
  }

  /// `End Date`
  String get end_date {
    return Intl.message('End Date', name: 'end_date', desc: '', args: []);
  }

  /// `Current Semester (Active)`
  String get current_semester_active {
    return Intl.message(
      'Current Semester (Active)',
      name: 'current_semester_active',
      desc: '',
      args: [],
    );
  }

  /// `Add New Academic Semester`
  String get add_new_semester_dialog_title {
    return Intl.message(
      'Add New Academic Semester',
      name: 'add_new_semester_dialog_title',
      desc: '',
      args: [],
    );
  }

  /// `Semester Name (e.g., First Semester)`
  String get semester_name_hint {
    return Intl.message(
      'Semester Name (e.g., First Semester)',
      name: 'semester_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `Academic Year (e.g., 2025/2026)`
  String get academic_year_hint {
    return Intl.message(
      'Academic Year (e.g., 2025/2026)',
      name: 'academic_year_hint',
      desc: '',
      args: [],
    );
  }

  /// `Choose Date`
  String get choose_date {
    return Intl.message('Choose Date', name: 'choose_date', desc: '', args: []);
  }

  /// `Save Semester`
  String get save_semester {
    return Intl.message(
      'Save Semester',
      name: 'save_semester',
      desc: '',
      args: [],
    );
  }

  /// `Not specified`
  String get not_specified {
    return Intl.message(
      'Not specified',
      name: 'not_specified',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change_btn {
    return Intl.message('Change', name: 'change_btn', desc: '', args: []);
  }

  /// `Weak`
  String get password_weak {
    return Intl.message('Weak', name: 'password_weak', desc: '', args: []);
  }

  /// `Medium`
  String get password_medium {
    return Intl.message('Medium', name: 'password_medium', desc: '', args: []);
  }

  /// `Strong`
  String get password_strong {
    return Intl.message('Strong', name: 'password_strong', desc: '', args: []);
  }

  /// `Password Strength: `
  String get password_strength_label {
    return Intl.message(
      'Password Strength: ',
      name: 'password_strength_label',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phone_number {
    return Intl.message(
      'Phone Number',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  /// `(Optional)`
  String get optional_field {
    return Intl.message(
      '(Optional)',
      name: 'optional_field',
      desc: '',
      args: [],
    );
  }

  /// `Error: Academic ID is required for students!`
  String get id_required_for_students {
    return Intl.message(
      'Error: Academic ID is required for students!',
      name: 'id_required_for_students',
      desc: '',
      args: [],
    );
  }

  /// `Matching`
  String get q_matching {
    return Intl.message('Matching', name: 'q_matching', desc: '', args: []);
  }

  /// `Fill in the Blank`
  String get q_fill_blank {
    return Intl.message(
      'Fill in the Blank',
      name: 'q_fill_blank',
      desc: '',
      args: [],
    );
  }

  /// `Course`
  String get course_name_label {
    return Intl.message(
      'Course',
      name: 'course_name_label',
      desc: '',
      args: [],
    );
  }

  /// `Folder`
  String get folder_name_label {
    return Intl.message(
      'Folder',
      name: 'folder_name_label',
      desc: '',
      args: [],
    );
  }

  /// `Notice`
  String get no_course_dialog_title {
    return Intl.message(
      'Notice',
      name: 'no_course_dialog_title',
      desc: '',
      args: [],
    );
  }

  /// `You must create a course and folder first`
  String get no_course_dialog_body {
    return Intl.message(
      'You must create a course and folder first',
      name: 'no_course_dialog_body',
      desc: '',
      args: [],
    );
  }

  /// `Go Back`
  String get go_back {
    return Intl.message('Go Back', name: 'go_back', desc: '', args: []);
  }

  /// `Question title / Instructions (optional)`
  String get group_title_hint {
    return Intl.message(
      'Question title / Instructions (optional)',
      name: 'group_title_hint',
      desc: '',
      args: [],
    );
  }

  /// `Branch`
  String get branch_label {
    return Intl.message('Branch', name: 'branch_label', desc: '', args: []);
  }

  /// `Delete this group`
  String get delete_group_tooltip {
    return Intl.message(
      'Delete this group',
      name: 'delete_group_tooltip',
      desc: '',
      args: [],
    );
  }

  /// `Copy this branch`
  String get copy_branch_tooltip {
    return Intl.message(
      'Copy this branch',
      name: 'copy_branch_tooltip',
      desc: '',
      args: [],
    );
  }

  /// `+ Add Branch`
  String get add_branch_label {
    return Intl.message(
      '+ Add Branch',
      name: 'add_branch_label',
      desc: '',
      args: [],
    );
  }

  /// `Enter matching pairs`
  String get matching_pairs_label {
    return Intl.message(
      'Enter matching pairs',
      name: 'matching_pairs_label',
      desc: '',
      args: [],
    );
  }

  /// `First term`
  String get matching_term_hint {
    return Intl.message(
      'First term',
      name: 'matching_term_hint',
      desc: '',
      args: [],
    );
  }

  /// `Matching answer`
  String get matching_match_hint {
    return Intl.message(
      'Matching answer',
      name: 'matching_match_hint',
      desc: '',
      args: [],
    );
  }

  /// `Add new pair`
  String get add_matching_pair {
    return Intl.message(
      'Add new pair',
      name: 'add_matching_pair',
      desc: '',
      args: [],
    );
  }

  /// `Options (select correct answer)`
  String get mcq_options_label {
    return Intl.message(
      'Options (select correct answer)',
      name: 'mcq_options_label',
      desc: '',
      args: [],
    );
  }

  /// `Select correct answer`
  String get tf_select_label {
    return Intl.message(
      'Select correct answer',
      name: 'tf_select_label',
      desc: '',
      args: [],
    );
  }

  /// `Use (___) in question then write answer`
  String get fill_blank_hint_label {
    return Intl.message(
      'Use (___) in question then write answer',
      name: 'fill_blank_hint_label',
      desc: '',
      args: [],
    );
  }

  /// `Correct word or phrase...`
  String get fill_blank_answer_hint {
    return Intl.message(
      'Correct word or phrase...',
      name: 'fill_blank_answer_hint',
      desc: '',
      args: [],
    );
  }

  /// `Model answer & keywords`
  String get essay_answer_label {
    return Intl.message(
      'Model answer & keywords',
      name: 'essay_answer_label',
      desc: '',
      args: [],
    );
  }

  /// `Write model answer here...`
  String get essay_model_answer_hint {
    return Intl.message(
      'Write model answer here...',
      name: 'essay_model_answer_hint',
      desc: '',
      args: [],
    );
  }

  /// `Keywords separated by comma (optional)...`
  String get essay_keywords_hint {
    return Intl.message(
      'Keywords separated by comma (optional)...',
      name: 'essay_keywords_hint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter exam title`
  String get exam_title_required {
    return Intl.message(
      'Please enter exam title',
      name: 'exam_title_required',
      desc: '',
      args: [],
    );
  }

  /// `Please select a folder`
  String get folder_required {
    return Intl.message(
      'Please select a folder',
      name: 'folder_required',
      desc: '',
      args: [],
    );
  }

  /// `Saved as draft successfully`
  String get saved_as_draft_success {
    return Intl.message(
      'Saved as draft successfully',
      name: 'saved_as_draft_success',
      desc: '',
      args: [],
    );
  }

  /// `Saved and approved successfully`
  String get saved_and_approved_success {
    return Intl.message(
      'Saved and approved successfully',
      name: 'saved_and_approved_success',
      desc: '',
      args: [],
    );
  }

  /// `Error:`
  String get error_prefix {
    return Intl.message('Error:', name: 'error_prefix', desc: '', args: []);
  }

  /// `Connection error:`
  String get connection_error {
    return Intl.message(
      'Connection error:',
      name: 'connection_error',
      desc: '',
      args: [],
    );
  }

  /// `Exit Warning`
  String get exit_warning_title {
    return Intl.message(
      'Exit Warning',
      name: 'exit_warning_title',
      desc: '',
      args: [],
    );
  }

  /// `You have unsaved data. Do you want to save the exam as a draft before exiting?`
  String get exit_warning_content {
    return Intl.message(
      'You have unsaved data. Do you want to save the exam as a draft before exiting?',
      name: 'exit_warning_content',
      desc: '',
      args: [],
    );
  }

  /// `Exit without saving`
  String get exit_without_saving {
    return Intl.message(
      'Exit without saving',
      name: 'exit_without_saving',
      desc: '',
      args: [],
    );
  }

  /// `Save as draft and exit`
  String get save_draft_and_exit {
    return Intl.message(
      'Save as draft and exit',
      name: 'save_draft_and_exit',
      desc: '',
      args: [],
    );
  }

  /// `Main Question (e.g., Question One)`
  String get main_question_hint {
    return Intl.message(
      'Main Question (e.g., Question One)',
      name: 'main_question_hint',
      desc: '',
      args: [],
    );
  }

  /// `Section Title (e.g., Part A - Choose the answer)`
  String get section_title_hint {
    return Intl.message(
      'Section Title (e.g., Part A - Choose the answer)',
      name: 'section_title_hint',
      desc: '',
      args: [],
    );
  }

  /// `Add Section`
  String get add_section_btn {
    return Intl.message(
      'Add Section',
      name: 'add_section_btn',
      desc: '',
      args: [],
    );
  }

  /// `Add Main Question`
  String get add_main_question_btn {
    return Intl.message(
      'Add Main Question',
      name: 'add_main_question_btn',
      desc: '',
      args: [],
    );
  }

  /// `1, 2, 3`
  String get num_numbers {
    return Intl.message('1, 2, 3', name: 'num_numbers', desc: '', args: []);
  }

  /// `أ, ب, ج`
  String get num_letters_ar {
    return Intl.message('أ, ب, ج', name: 'num_letters_ar', desc: '', args: []);
  }

  /// `A, B, C`
  String get num_letters_en {
    return Intl.message('A, B, C', name: 'num_letters_en', desc: '', args: []);
  }

  /// `I, II, III`
  String get num_roman {
    return Intl.message('I, II, III', name: 'num_roman', desc: '', args: []);
  }

  /// `بدون ترقيم`
  String get num_none {
    return Intl.message('بدون ترقيم', name: 'num_none', desc: '', args: []);
  }

  /// `A test title is required`
  String get err_title_required {
    return Intl.message(
      'A test title is required',
      name: 'err_title_required',
      desc: '',
      args: [],
    );
  }

  /// `An empty test cannot be submitted. Please add questions`
  String get err_no_questions {
    return Intl.message(
      'An empty test cannot be submitted. Please add questions',
      name: 'err_no_questions',
      desc: '',
      args: [],
    );
  }

  /// `Some questions do not have a correct answer selected. Please specify the correct answers`
  String get err_no_correct_answer {
    return Intl.message(
      'Some questions do not have a correct answer selected. Please specify the correct answers',
      name: 'err_no_correct_answer',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all required fields`
  String get err_missing_data {
    return Intl.message(
      'Please fill in all required fields',
      name: 'err_missing_data',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred. Please try again later`
  String get err_general {
    return Intl.message(
      'An error occurred. Please try again later',
      name: 'err_general',
      desc: '',
      args: [],
    );
  }

  /// `Exam title is required`
  String get err_exam_title {
    return Intl.message(
      'Exam title is required',
      name: 'err_exam_title',
      desc: '',
      args: [],
    );
  }

  /// `Exam date is required`
  String get err_exam_date {
    return Intl.message(
      'Exam date is required',
      name: 'err_exam_date',
      desc: '',
      args: [],
    );
  }

  /// `Course and folder must be selected`
  String get err_exam_course {
    return Intl.message(
      'Course and folder must be selected',
      name: 'err_exam_course',
      desc: '',
      args: [],
    );
  }

  /// `Cannot publish an empty exam, add at least one question`
  String get err_empty_exam {
    return Intl.message(
      'Cannot publish an empty exam, add at least one question',
      name: 'err_empty_exam',
      desc: '',
      args: [],
    );
  }

  /// `There is a question without text, please write it or delete it`
  String get err_empty_question {
    return Intl.message(
      'There is a question without text, please write it or delete it',
      name: 'err_empty_question',
      desc: '',
      args: [],
    );
  }

  /// `Each question must have a grade greater than zero`
  String get err_zero_grade {
    return Intl.message(
      'Each question must have a grade greater than zero',
      name: 'err_zero_grade',
      desc: '',
      args: [],
    );
  }

  /// `There is a multiple-choice question without a correct answer`
  String get err_no_correct_mcq {
    return Intl.message(
      'There is a multiple-choice question without a correct answer',
      name: 'err_no_correct_mcq',
      desc: '',
      args: [],
    );
  }

  /// `There is a True/False question without a selected answer`
  String get err_no_tf_answer {
    return Intl.message(
      'There is a True/False question without a selected answer',
      name: 'err_no_tf_answer',
      desc: '',
      args: [],
    );
  }

  /// `Correct word is required for fill-in-the-blank questions`
  String get err_empty_fill_blank {
    return Intl.message(
      'Correct word is required for fill-in-the-blank questions',
      name: 'err_empty_fill_blank',
      desc: '',
      args: [],
    );
  }

  /// `All matching pairs must be completed`
  String get err_empty_matching {
    return Intl.message(
      'All matching pairs must be completed',
      name: 'err_empty_matching',
      desc: '',
      args: [],
    );
  }

  /// `Model answer is required for essay questions`
  String get err_empty_essay {
    return Intl.message(
      'Model answer is required for essay questions',
      name: 'err_empty_essay',
      desc: '',
      args: [],
    );
  }

  /// ` untitled_exam`
  String get untitled_exam {
    return Intl.message(
      ' untitled_exam',
      name: 'untitled_exam',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get update_pw_title {
    return Intl.message(
      'New Password',
      name: 'update_pw_title',
      desc: '',
      args: [],
    );
  }

  /// `Please enter and confirm your new password to secure your account`
  String get update_pw_subtitle {
    return Intl.message(
      'Please enter and confirm your new password to secure your account',
      name: 'update_pw_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get new_password_label {
    return Intl.message(
      'New Password',
      name: 'new_password_label',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirm_password_label {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password_label',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get password_length_error {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'password_length_error',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwords_dont_match_error {
    return Intl.message(
      'Passwords do not match',
      name: 'passwords_dont_match_error',
      desc: '',
      args: [],
    );
  }

  /// `Success Operation!`
  String get success_operation {
    return Intl.message(
      'Success Operation!',
      name: 'success_operation',
      desc: '',
      args: [],
    );
  }

  /// `Your password has been updated successfully. You can now proceed to login.`
  String get password_updated_success_msg {
    return Intl.message(
      'Your password has been updated successfully. You can now proceed to login.',
      name: 'password_updated_success_msg',
      desc: '',
      args: [],
    );
  }

  /// `Save Password`
  String get save_password_button {
    return Intl.message(
      'Save Password',
      name: 'save_password_button',
      desc: '',
      args: [],
    );
  }

  /// `Go to Login`
  String get go_to_login_button {
    return Intl.message(
      'Go to Login',
      name: 'go_to_login_button',
      desc: '',
      args: [],
    );
  }

  /// `Save & Update`
  String get update_button {
    return Intl.message(
      'Save & Update',
      name: 'update_button',
      desc: '',
      args: [],
    );
  }

  /// `No exams found`
  String get no_data_found {
    return Intl.message(
      'No exams found',
      name: 'no_data_found',
      desc: '',
      args: [],
    );
  }

  /// `New User`
  String get register_title {
    return Intl.message('New User', name: 'register_title', desc: '', args: []);
  }

  /// `Enter your email to create an account and receive a verification code`
  String get register_subtitle {
    return Intl.message(
      'Enter your email to create an account and receive a verification code',
      name: 'register_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get email_hint {
    return Intl.message(
      'Enter your email',
      name: 'email_hint',
      desc: '',
      args: [],
    );
  }

  /// `Send Code`
  String get send_code_btn {
    return Intl.message('Send Code', name: 'send_code_btn', desc: '', args: []);
  }

  /// `Please enter your email first`
  String get email_empty_error {
    return Intl.message(
      'Please enter your email first',
      name: 'email_empty_error',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get email_invalid_error {
    return Intl.message(
      'Please enter a valid email address',
      name: 'email_invalid_error',
      desc: '',
      args: [],
    );
  }

  /// `This email is already registered, please log in instead of creating a new user`
  String get email_exists_error {
    return Intl.message(
      'This email is already registered, please log in instead of creating a new user',
      name: 'email_exists_error',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get otp_title {
    return Intl.message(
      'Verification Code',
      name: 'otp_title',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the 6-digit code sent to your email address`
  String get otp_subtitle {
    return Intl.message(
      'Please enter the 6-digit code sent to your email address',
      name: 'otp_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Code`
  String get confirm_code_btn {
    return Intl.message(
      'Confirm Code',
      name: 'confirm_code_btn',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the complete verification code (6 digits)`
  String get otp_incomplete_error {
    return Intl.message(
      'Please enter the complete verification code (6 digits)',
      name: 'otp_incomplete_error',
      desc: '',
      args: [],
    );
  }

  /// `Code verified successfully`
  String get otp_success {
    return Intl.message(
      'Code verified successfully',
      name: 'otp_success',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while connecting to the server`
  String get server_connection_error {
    return Intl.message(
      'An error occurred while connecting to the server',
      name: 'server_connection_error',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get new_password_title {
    return Intl.message(
      'New Password',
      name: 'new_password_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password to save it and fully activate your account`
  String get new_password_subtitle {
    return Intl.message(
      'Enter your password to save it and fully activate your account',
      name: 'new_password_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter new password`
  String get new_password_hint {
    return Intl.message(
      'Enter new password',
      name: 'new_password_hint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm and Save Account`
  String get save_account_btn {
    return Intl.message(
      'Confirm and Save Account',
      name: 'save_account_btn',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the new password`
  String get password_empty_error {
    return Intl.message(
      'Please enter the new password',
      name: 'password_empty_error',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, no specific role was found for this account`
  String get role_not_found_error {
    return Intl.message(
      'Sorry, no specific role was found for this account',
      name: 'role_not_found_error',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, this user's role is unknown in the system`
  String get unknown_role_error {
    return Intl.message(
      'Sorry, this user\'s role is unknown in the system',
      name: 'unknown_role_error',
      desc: '',
      args: [],
    );
  }

  /// `Welcome, `
  String get admin_welcome {
    return Intl.message('Welcome, ', name: 'admin_welcome', desc: '', args: []);
  }

  /// `System Usage Rate`
  String get system_usage {
    return Intl.message(
      'System Usage Rate',
      name: 'system_usage',
      desc: '',
      args: [],
    );
  }

  /// `Weekly usage percentage over the last three months`
  String get system_usage_desc {
    return Intl.message(
      'Weekly usage percentage over the last three months',
      name: 'system_usage_desc',
      desc: '',
      args: [],
    );
  }

  /// `Current`
  String get month_current {
    return Intl.message('Current', name: 'month_current', desc: '', args: []);
  }

  /// `Exams Count`
  String get stat_exams_count {
    return Intl.message(
      'Exams Count',
      name: 'stat_exams_count',
      desc: '',
      args: [],
    );
  }

  /// `Success Rate`
  String get stat_success_rate {
    return Intl.message(
      'Success Rate',
      name: 'stat_success_rate',
      desc: '',
      args: [],
    );
  }

  /// `Average Score`
  String get stat_avg_score {
    return Intl.message(
      'Average Score',
      name: 'stat_avg_score',
      desc: '',
      args: [],
    );
  }

  /// `System Admin`
  String get default_admin {
    return Intl.message(
      'System Admin',
      name: 'default_admin',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load filters`
  String get error_filters {
    return Intl.message(
      'Failed to load filters',
      name: 'error_filters',
      desc: '',
      args: [],
    );
  }

  /// `Connection error`
  String get error_connection {
    return Intl.message(
      'Connection error',
      name: 'error_connection',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed_status {
    return Intl.message(
      'Completed',
      name: 'completed_status',
      desc: '',
      args: [],
    );
  }

  /// `Draft`
  String get draft_status {
    return Intl.message('Draft', name: 'draft_status', desc: '', args: []);
  }

  /// `Exams`
  String get statExams {
    return Intl.message('Exams', name: 'statExams', desc: '', args: []);
  }

  /// `Refresh Data`
  String get refresh_data {
    return Intl.message(
      'Refresh Data',
      name: 'refresh_data',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all_text {
    return Intl.message('All', name: 'all_text', desc: '', args: []);
  }

  /// `Total System (All)`
  String get total_system_all {
    return Intl.message(
      'Total System (All)',
      name: 'total_system_all',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch system filters from the server`
  String get error_fetch_filters {
    return Intl.message(
      'Failed to fetch system filters from the server',
      name: 'error_fetch_filters',
      desc: '',
      args: [],
    );
  }

  /// `Backend connection error: {error}`
  String error_backend_connection(Object error) {
    return Intl.message(
      'Backend connection error: $error',
      name: 'error_backend_connection',
      desc: '',
      args: [error],
    );
  }

  /// `All semesters of {year}`
  String all_semesters_of_year(Object year) {
    return Intl.message(
      'All semesters of $year',
      name: 'all_semesters_of_year',
      desc: '',
      args: [year],
    );
  }

  /// `Failed to fetch real statistics from the server`
  String get error_fetch_real_stats {
    return Intl.message(
      'Failed to fetch real statistics from the server',
      name: 'error_fetch_real_stats',
      desc: '',
      args: [],
    );
  }

  /// `Error loading statistical data: {error}`
  String error_loading_stats(Object error) {
    return Intl.message(
      'Error loading statistical data: $error',
      name: 'error_loading_stats',
      desc: '',
      args: [error],
    );
  }

  /// `System Admin`
  String get system_admin {
    return Intl.message(
      'System Admin',
      name: 'system_admin',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry_button {
    return Intl.message('Retry', name: 'retry_button', desc: '', args: []);
  }

  /// `Welcome, {adminName}`
  String welcome_admin(Object adminName) {
    return Intl.message(
      'Welcome, $adminName',
      name: 'welcome_admin',
      desc: '',
      args: [adminName],
    );
  }

  /// `Refresh filters and data`
  String get refresh_filters_data {
    return Intl.message(
      'Refresh filters and data',
      name: 'refresh_filters_data',
      desc: '',
      args: [],
    );
  }

  /// `Weekly usage percentage over the last three months`
  String get weekly_usage_percentage {
    return Intl.message(
      'Weekly usage percentage over the last three months',
      name: 'weekly_usage_percentage',
      desc: '',
      args: [],
    );
  }

  /// `Exams Count`
  String get exams_count {
    return Intl.message('Exams Count', name: 'exams_count', desc: '', args: []);
  }

  /// `Average Score`
  String get average_score {
    return Intl.message(
      'Average Score',
      name: 'average_score',
      desc: '',
      args: [],
    );
  }

  /// `Administrative Alerts`
  String get administrative_alerts {
    return Intl.message(
      'Administrative Alerts',
      name: 'administrative_alerts',
      desc: '',
      args: [],
    );
  }

  /// `No live alerts currently`
  String get no_live_alerts {
    return Intl.message(
      'No live alerts currently',
      name: 'no_live_alerts',
      desc: '',
      args: [],
    );
  }

  /// `Delete failed!`
  String get delete_failure {
    return Intl.message(
      'Delete failed!',
      name: 'delete_failure',
      desc: '',
      args: [],
    );
  }

  /// `Update failed!`
  String get edit_failure {
    return Intl.message(
      'Update failed!',
      name: 'edit_failure',
      desc: '',
      args: [],
    );
  }

  /// `No Name`
  String get no_name {
    return Intl.message('No Name', name: 'no_name', desc: '', args: []);
  }

  /// `Failed to fetch data from server`
  String get error_server_failed {
    return Intl.message(
      'Failed to fetch data from server',
      name: 'error_server_failed',
      desc: '',
      args: [],
    );
  }

  /// `Network connection error`
  String get error_network_connection {
    return Intl.message(
      'Network connection error',
      name: 'error_network_connection',
      desc: '',
      args: [],
    );
  }

  /// `registered`
  String get registered {
    return Intl.message('registered', name: 'registered', desc: '', args: []);
  }

  /// `graded`
  String get graded {
    return Intl.message('graded', name: 'graded', desc: '', args: []);
  }

  /// `Active now`
  String get active_now {
    return Intl.message('Active now', name: 'active_now', desc: '', args: []);
  }

  /// `New Login`
  String get alert_new_login {
    return Intl.message(
      'New Login',
      name: 'alert_new_login',
      desc: '',
      args: [],
    );
  }

  /// `Data Import`
  String get alert_data_import {
    return Intl.message(
      'Data Import',
      name: 'alert_data_import',
      desc: '',
      args: [],
    );
  }

  /// `Completed on`
  String get completed_on {
    return Intl.message(
      'Completed on',
      name: 'completed_on',
      desc: '',
      args: [],
    );
  }

  /// `System login at`
  String get system_login_at {
    return Intl.message(
      'System login at',
      name: 'system_login_at',
      desc: '',
      args: [],
    );
  }

  /// `records`
  String get records {
    return Intl.message('records', name: 'records', desc: '', args: []);
  }

  /// `Recently`
  String get recently {
    return Intl.message('Recently', name: 'recently', desc: '', args: []);
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message('Yesterday', name: 'yesterday', desc: '', args: []);
  }

  /// `active semester only`
  String get active_semester_only {
    return Intl.message(
      'active semester only',
      name: 'active_semester_only',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email format`
  String get err_invalid_email_format {
    return Intl.message(
      'Invalid email format',
      name: 'err_invalid_email_format',
      desc: '',
      args: [],
    );
  }

  /// `No file selected`
  String get error_no_file_selected {
    return Intl.message(
      'No file selected',
      name: 'error_no_file_selected',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is too short`
  String get error_phone_too_short {
    return Intl.message(
      'Phone number is too short',
      name: 'error_phone_too_short',
      desc: '',
      args: [],
    );
  }

  /// `Check the columns in the Excel file`
  String get error_check_excel_columns {
    return Intl.message(
      'Check the columns in the Excel file',
      name: 'error_check_excel_columns',
      desc: '',
      args: [],
    );
  }

  /// `No operations recorded`
  String get error_no_recorded_operations {
    return Intl.message(
      'No operations recorded',
      name: 'error_no_recorded_operations',
      desc: '',
      args: [],
    );
  }

  /// `Successfully added {count} users`
  String success_users_added(Object count) {
    return Intl.message(
      'Successfully added $count users',
      name: 'success_users_added',
      desc: '',
      args: [count],
    );
  }

  /// `User added successfully`
  String get success_user_added {
    return Intl.message(
      'User added successfully',
      name: 'success_user_added',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic_lang {
    return Intl.message('Arabic', name: 'arabic_lang', desc: '', args: []);
  }

  /// `AM`
  String get am_time {
    return Intl.message('AM', name: 'am_time', desc: '', args: []);
  }

  /// `PM`
  String get pm_time {
    return Intl.message('PM', name: 'pm_time', desc: '', args: []);
  }

  /// `Loading version: {backupDate}`
  String loading_backup_version(Object backupDate) {
    return Intl.message(
      'Loading version: $backupDate',
      name: 'loading_backup_version',
      desc: '',
      args: [backupDate],
    );
  }

  /// `Delete failed`
  String get error_delete_failed {
    return Intl.message(
      'Delete failed',
      name: 'error_delete_failed',
      desc: '',
      args: [],
    );
  }

  /// `Backup creation failed`
  String get error_backup_creation_failed {
    return Intl.message(
      'Backup creation failed',
      name: 'error_backup_creation_failed',
      desc: '',
      args: [],
    );
  }

  /// `Full`
  String get full_backup {
    return Intl.message('Full', name: 'full_backup', desc: '', args: []);
  }

  /// `System restored from backup`
  String get success_system_restored {
    return Intl.message(
      'System restored from backup',
      name: 'success_system_restored',
      desc: '',
      args: [],
    );
  }

  /// `Error: {e}`
  String error_with_msg(Object e) {
    return Intl.message(
      'Error: $e',
      name: 'error_with_msg',
      desc: '',
      args: [e],
    );
  }

  /// `Loading error: {e}`
  String error_loading_with_msg(Object e) {
    return Intl.message(
      'Loading error: $e',
      name: 'error_loading_with_msg',
      desc: '',
      args: [e],
    );
  }

  /// `Not available`
  String get not_available {
    return Intl.message(
      'Not available',
      name: 'not_available',
      desc: '',
      args: [],
    );
  }

  /// `Restore failed`
  String get error_restore_failed {
    return Intl.message(
      'Restore failed',
      name: 'error_restore_failed',
      desc: '',
      args: [],
    );
  }

  /// `Restored successfully!`
  String get success_restored_successfully {
    return Intl.message(
      'Restored successfully!',
      name: 'success_restored_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Downloaded successfully!`
  String get success_downloaded {
    return Intl.message(
      'Downloaded successfully!',
      name: 'success_downloaded',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch data: {statusCode}`
  String error_fetch_data_with_code(Object statusCode) {
    return Intl.message(
      'Failed to fetch data: $statusCode',
      name: 'error_fetch_data_with_code',
      desc: '',
      args: [statusCode],
    );
  }

  /// `Download failed`
  String get error_download_failed {
    return Intl.message(
      'Download failed',
      name: 'error_download_failed',
      desc: '',
      args: [],
    );
  }

  /// `No records found`
  String get error_no_records {
    return Intl.message(
      'No records found',
      name: 'error_no_records',
      desc: '',
      args: [],
    );
  }

  /// `Copying...`
  String get loading_copying {
    return Intl.message(
      'Copying...',
      name: 'loading_copying',
      desc: '',
      args: [],
    );
  }

  /// `No backups found`
  String get error_no_backups {
    return Intl.message(
      'No backups found',
      name: 'error_no_backups',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch data`
  String get error_fetch_data_simple {
    return Intl.message(
      'Failed to fetch data',
      name: 'error_fetch_data_simple',
      desc: '',
      args: [],
    );
  }

  /// `Error occurred: {e}`
  String error_occurred_with_msg(Object e) {
    return Intl.message(
      'Error occurred: $e',
      name: 'error_occurred_with_msg',
      desc: '',
      args: [e],
    );
  }

  /// `Export failed: {statusCode}`
  String error_export_failed_with_code(Object statusCode) {
    return Intl.message(
      'Export failed: $statusCode',
      name: 'error_export_failed_with_code',
      desc: '',
      args: [statusCode],
    );
  }

  /// `Connection error: {e}`
  String connection_error_with_msg(Object e) {
    return Intl.message(
      'Connection error: $e',
      name: 'connection_error_with_msg',
      desc: '',
      args: [e],
    );
  }

  /// `Report downloaded successfully!`
  String get success_report_downloaded {
    return Intl.message(
      'Report downloaded successfully!',
      name: 'success_report_downloaded',
      desc: '',
      args: [],
    );
  }

  /// `Exporting...`
  String get loading_exporting {
    return Intl.message(
      'Exporting...',
      name: 'loading_exporting',
      desc: '',
      args: [],
    );
  }

  /// `No data found`
  String get error_no_data {
    return Intl.message(
      'No data found',
      name: 'error_no_data',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown_user {
    return Intl.message('Unknown', name: 'unknown_user', desc: '', args: []);
  }

  /// `Error fetching stats: {e}`
  String error_fetch_stats_with_msg(Object e) {
    return Intl.message(
      'Error fetching stats: $e',
      name: 'error_fetch_stats_with_msg',
      desc: '',
      args: [e],
    );
  }

  /// `Show active term data only`
  String get active_term_filter {
    return Intl.message(
      'Show active term data only',
      name: 'active_term_filter',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email or password`
  String get error_invalid_credentials {
    return Intl.message(
      'Invalid email or password',
      name: 'error_invalid_credentials',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient permissions for this account`
  String get error_no_role {
    return Intl.message(
      'Insufficient permissions for this account',
      name: 'error_no_role',
      desc: '',
      args: [],
    );
  }

  /// `This email is not registered in the system`
  String get error_email_not_found {
    return Intl.message(
      'This email is not registered in the system',
      name: 'error_email_not_found',
      desc: '',
      args: [],
    );
  }

  /// `This email is already registered, please login`
  String get error_email_already_registered {
    return Intl.message(
      'This email is already registered, please login',
      name: 'error_email_already_registered',
      desc: '',
      args: [],
    );
  }

  /// `Account not activated yet. Please set password`
  String get error_account_not_activated {
    return Intl.message(
      'Account not activated yet. Please set password',
      name: 'error_account_not_activated',
      desc: '',
      args: [],
    );
  }

  /// `Invalid or already used OTP code`
  String get error_invalid_otp {
    return Intl.message(
      'Invalid or already used OTP code',
      name: 'error_invalid_otp',
      desc: '',
      args: [],
    );
  }

  /// `OTP code has expired`
  String get error_expired_otp {
    return Intl.message(
      'OTP code has expired',
      name: 'error_expired_otp',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update password`
  String get error_update_password_failed {
    return Intl.message(
      'Failed to update password',
      name: 'error_update_password_failed',
      desc: '',
      args: [],
    );
  }

  /// `Connection error, please try again later`
  String get error_connection_failed {
    return Intl.message(
      'Connection error, please try again later',
      name: 'error_connection_failed',
      desc: '',
      args: [],
    );
  }

  /// `OTP is required and must be 6 digits`
  String get otp_validation_error {
    return Intl.message(
      'OTP is required and must be 6 digits',
      name: 'otp_validation_error',
      desc: '',
      args: [],
    );
  }

  /// `Verify Code`
  String get verify_otp_button {
    return Intl.message(
      'Verify Code',
      name: 'verify_otp_button',
      desc: '',
      args: [],
    );
  }

  /// `New User`
  String get registerButton {
    return Intl.message('New User', name: 'registerButton', desc: '', args: []);
  }

  /// `Theme / المظهر`
  String get theme_label {
    return Intl.message(
      'Theme / المظهر',
      name: 'theme_label',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get theme_light {
    return Intl.message('Light', name: 'theme_light', desc: '', args: []);
  }

  /// `Dark`
  String get theme_dark {
    return Intl.message('Dark', name: 'theme_dark', desc: '', args: []);
  }

  /// `Language / اللغة`
  String get language_label {
    return Intl.message(
      'Language / اللغة',
      name: 'language_label',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get lang_ar {
    return Intl.message('Arabic', name: 'lang_ar', desc: '', args: []);
  }

  /// `English`
  String get lang_en {
    return Intl.message('English', name: 'lang_en', desc: '', args: []);
  }

  /// `please Choose Folder`
  String get err_exam_folder {
    return Intl.message(
      'please Choose Folder',
      name: 'err_exam_folder',
      desc: '',
      args: [],
    );
  }

  /// `  please Enter time`
  String get err_empty_time_limit {
    return Intl.message(
      '  please Enter time',
      name: 'err_empty_time_limit',
      desc: '',
      args: [],
    );
  }

  /// ` time_limit`
  String get time_limit_label {
    return Intl.message(
      ' time_limit',
      name: 'time_limit_label',
      desc: '',
      args: [],
    );
  }

  /// `Hour`
  String get hour_word {
    return Intl.message('Hour', name: 'hour_word', desc: '', args: []);
  }

  /// `Minute`
  String get minute_word {
    return Intl.message('Minute', name: 'minute_word', desc: '', args: []);
  }

  /// `Success`
  String get success_title {
    return Intl.message('Success', name: 'success_title', desc: '', args: []);
  }

  /// `Alert`
  String get alert_title {
    return Intl.message('Alert', name: 'alert_title', desc: '', args: []);
  }

  /// `Cannot connect to server, check your internet`
  String get network_error {
    return Intl.message(
      'Cannot connect to server, check your internet',
      name: 'network_error',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send code`
  String get failed_to_send_code {
    return Intl.message(
      'Failed to send code',
      name: 'failed_to_send_code',
      desc: '',
      args: [],
    );
  }

  /// `Invalid OTP`
  String get invalid_otp {
    return Intl.message('Invalid OTP', name: 'invalid_otp', desc: '', args: []);
  }

  /// `Failed to send OTP`
  String get failed_to_send_otp {
    return Intl.message(
      'Failed to send OTP',
      name: 'failed_to_send_otp',
      desc: '',
      args: [],
    );
  }

  /// `Invalid or expired OTP`
  String get invalid_or_expired_otp {
    return Intl.message(
      'Invalid or expired OTP',
      name: 'invalid_or_expired_otp',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully`
  String get password_changed_success {
    return Intl.message(
      'Password changed successfully',
      name: 'password_changed_success',
      desc: '',
      args: [],
    );
  }

  /// `Error updating password`
  String get error_updating_password {
    return Intl.message(
      'Error updating password',
      name: 'error_updating_password',
      desc: '',
      args: [],
    );
  }

  /// `Name updated successfully`
  String get name_updated_success {
    return Intl.message(
      'Name updated successfully',
      name: 'name_updated_success',
      desc: '',
      args: [],
    );
  }

  /// `Update failed`
  String get update_failed {
    return Intl.message(
      'Update failed',
      name: 'update_failed',
      desc: '',
      args: [],
    );
  }

  /// `No server connection`
  String get no_server_connection {
    return Intl.message(
      'No server connection',
      name: 'no_server_connection',
      desc: '',
      args: [],
    );
  }

  /// `Password updated successfully`
  String get password_updated_success {
    return Intl.message(
      'Password updated successfully',
      name: 'password_updated_success',
      desc: '',
      args: [],
    );
  }

  /// `Update error`
  String get update_error {
    return Intl.message(
      'Update error',
      name: 'update_error',
      desc: '',
      args: [],
    );
  }

  /// `No connection`
  String get no_connection {
    return Intl.message(
      'No connection',
      name: 'no_connection',
      desc: '',
      args: [],
    );
  }

  /// `Weak`
  String get weak_password {
    return Intl.message('Weak', name: 'weak_password', desc: '', args: []);
  }

  /// `Medium`
  String get medium_password {
    return Intl.message('Medium', name: 'medium_password', desc: '', args: []);
  }

  /// `Strong`
  String get strong_password {
    return Intl.message('Strong', name: 'strong_password', desc: '', args: []);
  }

  /// `erorr please try again`
  String get alert_eroor {
    return Intl.message(
      'erorr please try again',
      name: 'alert_eroor',
      desc: '',
      args: [],
    );
  }

  /// `Grade`
  String get Grade1 {
    return Intl.message('Grade', name: 'Grade1', desc: '', args: []);
  }

  /// `Exam Type`
  String get exam_type_label {
    return Intl.message(
      'Exam Type',
      name: 'exam_type_label',
      desc: '',
      args: [],
    );
  }

  /// `Manual`
  String get exam_type_manual {
    return Intl.message('Manual', name: 'exam_type_manual', desc: '', args: []);
  }

  /// `AI`
  String get exam_type_ai {
    return Intl.message('AI', name: 'exam_type_ai', desc: '', args: []);
  }

  /// `Edit Warning`
  String get edit_warning_title {
    return Intl.message(
      'Edit Warning',
      name: 'edit_warning_title',
      desc: '',
      args: [],
    );
  }

  /// `This exam is complete. Please note that editing questions or model answers now may affect the accuracy of student results if their answer sheets have already been uploaded. Are you sure you want to continue?`
  String get edit_warning_content {
    return Intl.message(
      'This exam is complete. Please note that editing questions or model answers now may affect the accuracy of student results if their answer sheets have already been uploaded. Are you sure you want to continue?',
      name: 'edit_warning_content',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get edit_warning_cancel {
    return Intl.message(
      'Cancel',
      name: 'edit_warning_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Continue Editing`
  String get edit_warning_continue {
    return Intl.message(
      'Continue Editing',
      name: 'edit_warning_continue',
      desc: '',
      args: [],
    );
  }

  /// `Leave empty if no specialization exists`
  String get dept_hint_optional {
    return Intl.message(
      'Leave empty if no specialization exists',
      name: 'dept_hint_optional',
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
