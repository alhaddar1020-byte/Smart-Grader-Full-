# Endpoint Returns

### academic.py
- **get_all_departments**: db.query(Department).all()
- **get_all_levels**: db.query(Level).all()
- **get_courses_by_level**: db.query(Course).filter(Course.level_id == level_id).all()
- **get_dashboard_filters**: {'years': [y[0] for y in years_raw], 'semesters': [{'id': s.semester_id, 'name': s.semester_name, 'year': s.academic_year, 'is_current': s.is_current} for s in semesters_raw]}

### add_users.py
- **add_user_manually**: {'message': message}
- **upload_users_excel**: {'message': message}
- **get_import_history**: get_import_history_from_db(db)
- **delete_history**: {'message': 'KEY_DELETED_SUCCESSFULLY'}

### admin.py
- **get_dashboard_statistics**: crud_dashboard.get_admin_dashboard_data(db)

### admin_dashboard.py
- **get_dashboard_stats**: get_admin_dashboard_data(db=db, semester_id=semester_id)
- **get_dashboard_filters**: {'years': [str(y[0]) for y in years_raw if y[0]], 'semesters': [{'id': str(s.semester_id), 'name': str(s.semester_name), 'year': str(s.academic_year)} for s in semesters_raw]}

### ai_exam.py
- **get_folder_info**: FolderContextResponse(**ctx)
- **generate_exam**: ExamGenerationResponse(success=True, message='تم توليد الاختبار بنجاح', exam_title=exam_title or f"اختبار {ctx['course_name']}", total_questions=len(questions), total_grade=total_grade, ai_accuracy=98.5, questions=questions, keywords=ai_data.get('keywords', []))
- **save_exam**: SaveExamResponse(success=True, message=result['message'], exam_id=result['exam_id'])

### auth.py
- **login**: {'status': 'success', 'user_id': user_id, 'role_id': int(role_data['role_id']), 'access_token': access_token, 'token_type': 'bearer'}
- **send_new_user_otp**: {'status': 'success', 'message': 'تم إرسال الرمز بنجاح'}
- **send_forgot_password_otp**: {'status': 'success', 'message': 'تم إرسال رمز الاستعادة بنجاح'}
- **verify_otp**: {'status': 'success', 'message': 'الرمز صحيح'}
- **verify_and_set_password**: {'status': 'success', 'message': 'تم تفعيل حسابك بنجاح!', 'user_id': user_id, 'role_id': role_id}

### backup.py
- **get_page_data**: BackupPageResponse(system_stats=SystemStats(**data['system_stats']), backups=[BackupItem(**b) for b in data['backups']], recent_logs=[RecentLog(**log) for log in data['recent_logs']], last_backup_date=data['last_backup_date'])
- **create_backup**: BackupCreateResponse(success=True, message=result['message'], backup=BackupItem(backup_id=backup_data['backup_id'], backup_date=backup_data['backup_date'], file_size=backup_data['file_size'], status=backup_data['status'], backup_type=backup_data['backup_type']))
- **download_backup**: FileResponse(path=result['path'], filename=result['filename'], media_type='application/octet-stream', headers={'Content-Disposition': f"attachment; filename={result['filename']}", 'Access-Control-Expose-Headers': 'Content-Disposition'})
- **restore_backup**: {'success': True, 'message': result['message']}
- **delete_backup**: BackupDeleteResponse(success=True, message=result['message'])

### exam.py
- **create_new_exam**: {'message': 'تم إنشاء الاختبار بنجاح', 'exam_id': exam_id}
- **get_exams_list**: exams_list
- **delete_exam**: {'message': 'تم حذف الاختبار بكامل محتوياته بنجاح'}

### exams.py
- **create_new_exam**: {'message': 'تم إنشاء الاختبار بنجاح', 'exam_id': exam_id}

### exams_router.py
- **get_all_semesters**: exams_crud.get_all_semesters(db)
- **create_new_semester**: exams_crud.create_semester(db=db, semester_data=semester_data)
- **toggle_semester_status**: {'message': 'تم تحديث الترم الحالي بنجاح'}
- **delete_semester_endpoint**: {'message': 'تم الحذف بنجاح'}
- **edit_semester**: updated_semester
- **get_dashboard_filters**: {'years': [str(y[0]) for y in years_raw if y[0]], 'semesters': [{'id': s.semester_id, 'name': s.semester_name, 'year': str(s.academic_year), 'is_current': s.is_current} for s in semesters_raw]}
- **get_courses_for_teacher**: exams_crud.get_teacher_courses(db=db, teacher_id=teacher_id, semester_id=semester_id)
- **assign_course_to_teacher**: exams_crud.assign_teacher_to_course(db=db, tc_data=tc_data)
- **get_folders_for_course**: exams_crud.get_folders_by_tc(db=db, tc_id=tc_id)
- **create_new_folder**: exams_crud.create_folder(db=db, folder_data=folder_data)
- **get_exams_in_folder**: exams_crud.get_exams_by_folder(db=db, folder_id=folder_id)
- **create_new_exam**: exams_crud.create_exam(db=db, exam_data=exam_data)

### exam_creation.py
- **get_teacher_courses_dropdown**: list(courses_dict.values())
- **create_full_exam**: {'message': 'تم إنشاء الاختبار بنجاح', 'exam_id': new_exam.exam_id, 'groups': groups_created, 'sections': sections_created, 'questions': questions_created}
- **get_exam_question_groups**: groups
- **delete_question_group**: None
- **get_full_exam**: {'exam_id': exam.exam_id, 'exam_title': exam.exam_title, 'exam_date': str(exam.exam_date) if exam.exam_date else '', 'time_limit': exam.allowed_time, 'folder_id': exam.folder_id, 'status': exam.status, 'exam_type': exam.exam_type, 'question_groups': groups_data}
- **delete_entire_exam**: {'message': 'تم حذف الاختبار بنجاح'}

### grading.py
- **upload_and_start_grading**: {'message': 'تم رفع الملفات بنجاح وبدأ محرك الذكاء الاصطناعي في تحديد الأسماء والتصحيح حياً 🚀'}
- **get_exam_results**: results
- **update_teacher_mark**: {'status': 'success', 'message': 'تم اعتماد درجة المعلم، إعادة احتساب المجموع، وإلغاء حالة النشر بنجاح! 🎯', 'new_total_score': calculated_total}
- **publish_result**: {'error': 'الورقة غير موجودة'} | {'message': 'تم نشر النتيجة للطالب بنجاح!'}
- **verify_data**: {'message': 'سجل غير موجود'} | {'sc_id': record.sc_id, 'strengths': record.subject_strengths, 'weaknesses': record.subject_weaknesses}
- **get_exams_for_review**: [] | [{'exam_id': e.exam_id, 'exam_name': e.exam_title} for e in exams]
- **get_teacher_courses**: results | []
- **publish_all_results**: {'message': 'تم نشر جميع النتائج بنجاح'} | {'message': 'لا توجد أوراق للنشر'}

### quiz_details.py
- **save_quiz**: {'success': True, 'message': 'تم حفظ الاختبار بنجاح', 'exam_id': exam_id}

### reports.py
- **get_reports**: get_reports_data(db, active_term=active_term)
- **export_pdf**: ParagraphStyle(name, fontName=font, fontSize=size, alignment=align, leading=size * 1.6, **kwargs) | Response(content=buffer.read(), media_type='application/pdf', headers={'Content-Disposition': 'attachment; filename=SmartGrader_Report.pdf', 'Access-Control-Expose-Headers': 'Content-Disposition'}) | TableStyle([('BACKGROUND', (0, 0), (-1, 0), TEAL), ('TEXTCOLOR', (0, 0), (-1, 0), WHITE), ('FONTNAME', (0, 0), (-1, -1), F), ('FONTNAME', (0, 0), (-1, 0), FB), ('FONTSIZE', (0, 0), (-1, -1), 11), ('ALIGN', (0, 0), (-1, -1), 'CENTER'), ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'), ('GRID', (0, 0), (-1, -1), 0.4, colors.HexColor('#CCCCCC')), ('ROWBACKGROUNDS', (0, 1), (-1, -1), row_colors), ('TOPPADDING', (0, 0), (-1, -1), 9), ('BOTTOMPADDING', (0, 0), (-1, -1), 9), ('LEFTPADDING', (0, 0), (-1, -1), 10), ('RIGHTPADDING', (0, 0), (-1, -1), 10)]) | en_text if lang == 'en' else ar_text

### settings_router.py
- **get_profile**: profile_data
- **update_profile**: {'message': 'PROFILE_UPDATED_SUCCESSFULLY'}
- **send_email_otp**: {'message': 'OTP_SENT_SUCCESSFULLY'}
- **verify_email_otp**: {'message': 'EMAIL_UPDATED_SUCCESSFULLY'}
- **change_password**: {'message': 'PASSWORD_CHANGED_SUCCESSFULLY'}
- **forgot_password_send_otp**: {'message': 'OTP_SENT_SUCCESSFULLY'}
- **forgot_password_verify_otp**: {'message': 'OTP_IS_VALID'}
- **forgot_password_reset**: {'message': 'PASSWORD_UPDATED_SUCCESSFULLY'}
- **update_preferences**: {'message': 'PREFERENCES_UPDATED'}

### system_log.py
- **fetch_logs_summary**: LogsSummary(total_actions=data['total_actions'], login_records=data['login_records'], today_count=data['today_count'])
- **fetch_logs**: LogsResponse(total_count=result['total_count'], logs=result['logs'])
- **export_logs**: Response(content=csv_bytes, media_type='text/csv; charset=utf-8-sig', headers={'Content-Disposition': f'attachment; filename={filename}', 'Access-Control-Expose-Headers': 'Content-Disposition'})

### teacher_dashboard.py
- **get_dashboard_data**: stats

### teacher_matearial.py
- **get_levels**: db.query(Level).all()
- **get_teacher_materials**: {'courses': courses, 'total_students': stats['total_students'], 'total_corrected_papers': stats['corrected_papers'], 'total_exams': stats['created_exams'], 'total_drafts': stats['drafts']}
- **get_details**: data
- **add_course_endpoint**: create_new_course_with_flexible_dept(db, teacher_id, data)
- **add_folder**: create_new_folder(db, name, course_id, teacher_id)
- **delete_folder**: {'message': 'تم حذف المجلد بنجاح'}
- **delete_exam**: {'message': 'تم حذف الاختبار بكامل محتوياته بنجاح'}
- **update_exam**: {'message': 'تم التعديل بنجاح'}

### users.py
- **create_user**: {'message': 'تم تسجيل الحساب بنجاح!', 'user_id': new_user.user_id}

### users_management.py
- **get_users_list**: get_all_users_from_db(db, active_only=active_only)
- **update_user**: {'message': 'update_success'}
- **delete_user**: {'message': 'delete_success'}

### users_router.py
- **register_user**: {'message': 'تم تسجيل الحساب بنجاح!', 'user_id': new_user.user_id}
- **get_profile**: {'full_name': admin.full_name, 'email': admin.email, 'phone_number': admin.phone_number, 'department_name': 'الإدارة العليا'}
- **update_profile**: {'message': 'تم تحديث البيانات بنجاح'}

### views.py
- **get_teacher_subjects**: [dict(row._mapping) for row in result]
- **get_student_results**: [dict(row._mapping) for row in result]
- **get_student_dashboard**: get_student_dashboard_data(db=db, student_id=student_id)
- **get_student_subjects**: get_student_subjects_data(db=db, student_id=student_id)
- **get_subject_details**: get_subject_details_data(db=db, student_id=student_id, course_name=course_name)
- **get_exam_details**: get_exam_details_data(db=db, student_id=student_id, exam_title=exam_title)