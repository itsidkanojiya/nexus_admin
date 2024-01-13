import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lexus_admin/models/user_model.dart';
import 'package:lexus_admin/module/auth/auth_service.dart';
import 'package:lexus_admin/repository/base.dart';

class StudentRepository {
  Future<UsersModel?> getStudents() async {
    try {
      final response = await http
          .get(Uri.parse('${Base.api}/students'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UFT-8',
        HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
      });

      final body = jsonDecode(response.body);
      debugPrint('getStudents body: $body');
      if (response.statusCode == 200) {
        return UsersModel.fromJson(body);
      }
    } catch (e) {
      debugPrint('Error While getStudents() ${e.toString()}');
      return Future.error(e);
    }
    return null;
  }

  Future<bool> addStudent(Map<String, dynamic> map) async {
    try {
      final response = await http.post(
        Uri.parse('${Base.api}/student-register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(map),
      );

      final body = jsonDecode(response.body);
      debugPrint('addStudent body: $body');
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While addStudent() ${e.toString()}');
      return false;
    }
    Get.rawSnackbar(
        message: 'Student Added failed!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> deleteStudent(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${Base.api}/delete-student?id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
      );

      final body = jsonDecode(response.body);
      debugPrint('deleteStudent body: $body');
      if (response.statusCode == 200) {
        Get.rawSnackbar(
            message: 'Deleted Sucessfully!', backgroundColor: Colors.green);
        return true;
      }
    } catch (e) {
      debugPrint('Error While deleteStudent() ${e.toString()}');
      return Future.error(e);
    }
    Get.rawSnackbar(
        message: 'Something went wrong!', backgroundColor: Colors.redAccent);
    return false;
  }
}
