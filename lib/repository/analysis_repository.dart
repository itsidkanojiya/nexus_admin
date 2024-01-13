import 'dart:convert';
import 'dart:io';

import 'package:fintech_dashboard_clone/models/question_analysis_model.dart';
import 'package:fintech_dashboard_clone/models/student_analysis_model.dart';
import 'package:fintech_dashboard_clone/models/teacher_analysis_model.dart';
import 'package:fintech_dashboard_clone/module/auth/auth_service.dart';
import 'package:fintech_dashboard_clone/repository/base.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AnalysisRepository {
  Future<TeacherAnalysisModel?> getTeacherAnalysis() async {
    try {
      final response = await http.get(Uri.parse('${Base.api}/teacher-analysis'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UFT-8',
            HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
          });

      final body = jsonDecode(response.body);
      debugPrint('getTeacherAnalysis body: $body');
      if (response.statusCode == 200) {
        return TeacherAnalysisModel.fromJson(body);
      }
    } catch (e) {
      debugPrint('Error While getTeacherAnalysis() ${e.toString()}');
      return Future.error(e);
    }
    return null;
  }

  Future<StudentAnalysisModel?> getStudentAnalysis() async {
    try {
      final response = await http.get(Uri.parse('${Base.api}/student-analysis'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UFT-8',
            HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
          });

      final body = jsonDecode(response.body);
      debugPrint('getStudentAnalysis body: $body');
      if (response.statusCode == 200) {
        return StudentAnalysisModel.fromJson(body);
      }
    } catch (e) {
      debugPrint('Error While getStudentAnalysis() ${e.toString()}');
      return Future.error(e);
    }
    return null;
  }

  Future<QuestionAnalysisModel?> getQuestionAnalysis() async {
    try {
      final response = await http.get(
          Uri.parse('${Base.api}/question-analysis'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UFT-8',
            HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
          });

      final body = jsonDecode(response.body);
      debugPrint('getQuestionAnalysis body: $body');
      if (response.statusCode == 200) {
        return QuestionAnalysisModel.fromJson(body);
      }
    } catch (e) {
      debugPrint('Error While getQuestionAnalysis() ${e.toString()}');
      return Future.error(e);
    }
    return null;
  }
}
