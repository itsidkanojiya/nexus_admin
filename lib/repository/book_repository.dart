import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lexus_admin/models/board_model.dart';
import 'package:lexus_admin/models/book_model.dart';
import 'package:lexus_admin/models/change_subject_model.dart';
import 'package:lexus_admin/models/subject_model.dart';
import 'package:lexus_admin/module/auth/auth_service.dart';
import 'package:lexus_admin/repository/base.dart';

class BookRepository {
  Future<BookModel?> getBooks() async {
    try {
      final response = await http
          .get(Uri.parse('${Base.api}/books'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UFT-8',
      });

      final body = jsonDecode(response.body);
      debugPrint('getBooks body: $body');
      if (response.statusCode == 200) {
        return BookModel.fromJson(body);
      }
    } catch (e) {
      debugPrint('Error While getBooks() ${e.toString()}');
      return Future.error(e);
    }
    return null;
  }

  Future<bool> addBook(
      Map<String, dynamic> map, String coverImage, String pdf) async {
    try {
      var headers = {
        'Content-Type': 'application/json; charset=UFT-8',
        HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
      };
      var request =
          http.MultipartRequest('POST', Uri.parse('${Base.api}/add-book'));

      request.files
          .add(await http.MultipartFile.fromPath('cover_link', coverImage));
      request.files.add(await http.MultipartFile.fromPath('pdf_link', pdf));
      request.headers.addAll(headers);

      var stringMap = map.map((key, value) => MapEntry(key, value.toString()));

      // Add other form data to fields
      stringMap.forEach((key, value) {
        request.fields[key] = value;
      });

      http.StreamedResponse response = await request.send();
      var res = await response.stream.bytesToString();
      final body = jsonDecode(res);
      debugPrint('addBook body: $body');
      if (response.statusCode == 201) {
        Get.rawSnackbar(
            message: 'Book Added Sucessfully!', backgroundColor: Colors.green);
        return true;
      }
    } catch (e) {
      Get.rawSnackbar(message: 'Book Added failed!');
      debugPrint('Error While addBooks() ${e.toString()}');
      return false;
    }
    Get.rawSnackbar(
        message: 'Book Added failed!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> addSubject(Map<String, dynamic> map) async {
    try {
      final response = await http.post(
        Uri.parse('${Base.api}/add-subject'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(map),
      );

      final body = jsonDecode(response.body);
      debugPrint('addSubject body: $body');
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While addSubject() ${e.toString()}');
      return false;
    }
    Get.rawSnackbar(
        message: 'Student Added failed!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> deleteBook(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${Base.api}/delete-book?id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
      );

      final body = jsonDecode(response.body);
      debugPrint('deleteBook body: $body');
      if (response.statusCode == 200) {
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

  Future<BoardModel?> getBoard() async {
    try {
      final response = await http
          .get(Uri.parse('${Base.api}/board'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UFT-8',
      });

      final body = jsonDecode(response.body);
      debugPrint('getBoard body: $body');
      if (response.statusCode == 200) {
        return BoardModel.fromJson(body);
      }
    } catch (e) {
      debugPrint('Error While getBoard() ${e.toString()}');
      return Future.error(e);
    }
    return null;
  }

  Future<SubjectModel?> getSubject() async {
    try {
      final response = await http
          .get(Uri.parse('${Base.api}/subject'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UFT-8',
      });

      final body = jsonDecode(response.body);
      debugPrint('getSubject body: $body');
      if (response.statusCode == 200) {
        return SubjectModel.fromJson(body);
      }
    } catch (e) {
      debugPrint('Error While getSubject() ${e.toString()}');
      return Future.error(e);
    }
    return null;
  }

  Future<List<ChangeSubjectModel>> getChangeSubjectRequest() async {
    try {
      final response = await http.get(
        Uri.parse('${Base.api}/users-with-request'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        debugPrint('getChnageSubject body: $body');

        return body.map((json) => ChangeSubjectModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load subject change requests");
      }
    } catch (e) {
      debugPrint('Error While getChangeSubjectRequest() ${e.toString()}');
      return Future.error(e);
    }
  }

  Future<bool> approveRequest(int id) async {
    try {
      final response = await http.post(
          Uri.parse('${Base.api}/approve-subject-change'),
          headers: <String, String>{
            HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
          },
          body: {
            "user_id": id.toString(),
          });

      final body = jsonDecode(response.body);
      debugPrint('approveRequest body: $body');

      if (response.statusCode == 200) {
        Get.rawSnackbar(
            message: 'Changed Subject Sucessfully!',
            backgroundColor: Colors.greenAccent);
        return true;
      }
    } catch (e) {
      debugPrint('Error While approveRequest() ${e.toString()}');
      return Future.error(e);
    }
    Get.rawSnackbar(
        message: 'Something went wrong!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> rejectRequest(int id) async {
    try {
      final response = await http.post(
          Uri.parse('${Base.api}/reject-subject-change'),
          headers: <String, String>{
            HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
          },
          body: {
            "user_id": id.toString(),
          });

      final body = jsonDecode(response.body);
      debugPrint('rejectRequest body: $body');
      if (response.statusCode == 200) {
        Get.rawSnackbar(
            message: 'Reject Subject Request Sucessfully!',
            backgroundColor: Colors.redAccent);
        return true;
      }
    } catch (e) {
      debugPrint('Error While rejectRequest() ${e.toString()}');
      return Future.error(e);
    }
    Get.rawSnackbar(
        message: 'Something went wrong!', backgroundColor: Colors.redAccent);
    return false;
  }
}
