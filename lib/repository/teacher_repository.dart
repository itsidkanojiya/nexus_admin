import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lexus_admin/models/user_model.dart';
import 'package:lexus_admin/module/auth/auth_service.dart';
import 'package:lexus_admin/repository/base.dart';

class TeacherRepository {
  Future<UsersModel?> getActivateTeacher() async {
    try {
      final response = await http.get(Uri.parse('${Base.api}/activate-teacher'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UFT-8',
            HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
          });

      final body = jsonDecode(response.body);
      debugPrint('getActivateTeacher body: $body');
      if (response.statusCode == 200) {
        return UsersModel.fromJson(body);
      }
    } catch (e) {
      debugPrint('Error While getActivateTeacher() ${e.toString()}');
      return Future.error(e);
    }
    return null;
  }

  Future<UsersModel?> getPendingTeacher() async {
    try {
      final response = await http.get(Uri.parse('${Base.api}/pending-teacher'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UFT-8',
            HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
          });

      final body = jsonDecode(response.body);
      debugPrint('getPendingTeacher body: $body');
      if (response.statusCode == 200) {
        return UsersModel.fromJson(body);
      }
    } catch (e) {
      debugPrint('Error While getPendingTeacher() ${e.toString()}');
      return Future.error(e);
    }
    return null;
  }

  Future<bool> addTeacher(Map<String, dynamic> map) async {
    try {
      final response = await http.post(
        Uri.parse('${Base.api}/teacher-register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(map),
      );

      final body = jsonDecode(response.body);
      debugPrint('addTeacher body: $body');
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While addTeacher() ${e.toString()}');
      return false;
    }

    return false;
  }

  Future<bool> makActive(int id) async {
    try {
      final response = await http.put(
        Uri.parse('${Base.api}/make-activate?id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
      );

      final body = jsonDecode(response.body);
      debugPrint('makActive body: $body');
      if (response.statusCode == 200) {
        Get.rawSnackbar(
            message: 'Activated Sucessfully!', backgroundColor: Colors.green);
        return true;
      }
    } catch (e) {
      debugPrint('Error While makActive() ${e.toString()}');
      return Future.error(e);
    }
    Get.rawSnackbar(
        message: 'Something went wrong!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> makDeactive(int id) async {
    try {
      final response = await http.put(
        Uri.parse('${Base.api}/make-deactivate?id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
      );

      final body = jsonDecode(response.body);
      debugPrint('makDeactive body: $body');
      if (response.statusCode == 200) {
        Get.rawSnackbar(
            message: 'Deactivated Sucessfully!', backgroundColor: Colors.green);
        return true;
      }
    } catch (e) {
      debugPrint('Error While makDeactive() ${e.toString()}');
      return Future.error(e);
    }
    Get.rawSnackbar(
        message: 'Something went wrong!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> deleteTeacher(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${Base.api}/delete-teacher?id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
      );

      final body = jsonDecode(response.body);
      debugPrint('deleteTeacher body: $body');
      if (response.statusCode == 200) {
        Get.rawSnackbar(
            message: 'Deleted Sucessfully!', backgroundColor: Colors.green);
        return true;
      }
    } catch (e) {
      debugPrint('Error While deleteTeacher() ${e.toString()}');
      return Future.error(e);
    }
    Get.rawSnackbar(
        message: 'Something went wrong!', backgroundColor: Colors.redAccent);
    return false;
  }
}
