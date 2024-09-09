import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lexus_admin/models/mcq_modal.dart';
import 'package:lexus_admin/models/question_model.dart';
import 'package:lexus_admin/module/auth/auth_service.dart';
import 'package:lexus_admin/repository/base.dart';

class QuestionRepository {
  Future<McqModel?> getMcq() async {
    try {
      final response = await http
          .get(Uri.parse('${Base.api}/mcq'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UFT-8',
      });

      final body = jsonDecode(response.body);
      debugPrint('getMcq body: $body');
      if (response.statusCode == 200) {
        return McqModel.fromJson(body);
      }
    } catch (e) {
      debugPrint('Error While getMcq() ${e.toString()}');
      return Future.error(e);
    }
    return null;
  }

  Future<QuestionModel?> getBlank() async {
    try {
      final response = await http
          .get(Uri.parse('${Base.api}/blank'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UFT-8',
      });

      final body = jsonDecode(response.body);
      debugPrint('getBlank body: $body');
      if (response.statusCode == 200) {
        return QuestionModel.fromJson(body);
      }
    } catch (e) {
      debugPrint('Error While getBlank() ${e.toString()}');
      return Future.error(e);
    }
    return null;
  }

  Future<QuestionModel?> getTrueFalse() async {
    try {
      final response = await http
          .get(Uri.parse('${Base.api}/true-false'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UFT-8',
      });

      final body = jsonDecode(response.body);
      debugPrint('getTrueFalse body: $body');
      if (response.statusCode == 200) {
        return QuestionModel.fromJson(body);
      }
    } catch (e) {
      debugPrint('Error While getTrueFalse() ${e.toString()}');
      return Future.error(e);
    }
    return null;
  }

  Future<QuestionModel?> getShort() async {
    try {
      final response = await http
          .get(Uri.parse('${Base.api}/short'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UFT-8',
      });

      final body = jsonDecode(response.body);
      debugPrint('getShort body: $body');
      if (response.statusCode == 200) {
        return QuestionModel.fromJson(body);
      }
    } catch (e) {
      debugPrint('Error While getShort() ${e.toString()}');
      return Future.error(e);
    }
    return null;
  }

  Future<QuestionModel?> getLong() async {
    try {
      final response = await http
          .get(Uri.parse('${Base.api}/long'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UFT-8',
      });

      final body = jsonDecode(response.body);
      debugPrint('getLong body: $body');
      if (response.statusCode == 200) {
        return QuestionModel.fromJson(body);
      }
    } catch (e) {
      debugPrint('Error While getLong() ${e.toString()}');
      return Future.error(e);
    }
    return null;
  }

  Future<QuestionModel?> getOneTwo() async {
    try {
      final response = await http
          .get(Uri.parse('${Base.api}/onetwo'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UFT-8',
      });

      final body = jsonDecode(response.body);
      debugPrint('getOneTwo body: $body');
      if (response.statusCode == 200) {
        return QuestionModel.fromJson(body);
      }
    } catch (e) {
      debugPrint('Error While getOneTwo() ${e.toString()}');
      return Future.error(e);
    }
    return null;
  }

  Future<bool> addMcq(Map<String, dynamic> map) async {
    try {
      final response = await http.post(
        Uri.parse('${Base.api}/add-mcq'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
        body: jsonEncode(map),
      );

      final body = jsonDecode(response.body);
      debugPrint('addQuestion body: $body');
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While addQuestion() ${e.toString()}');
      return false;
    }
    Get.rawSnackbar(
        message: 'Question Added failed!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> editMcq(Map<String, dynamic> map) async {
    try {
      final response = await http.post(
        Uri.parse('${Base.api}/edit-mcq'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
        body: jsonEncode(map),
      );

      final body = jsonDecode(response.body);
      debugPrint('editQuestion body: $body');
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While editQuestion() ${e.toString()}');
      return false;
    }
    Get.rawSnackbar(
        message: 'Question edited failed!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> addTrueFalse(Map<String, dynamic> map) async {
    try {
      final response = await http.post(
        Uri.parse('${Base.api}/add-truefalse'),
        headers: <String, String>{
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}",
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(map),
      );

      final body = jsonDecode(response.body);
      debugPrint('addQuestion body: $body');
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While addQuestion() ${e.toString()}');
      return false;
    }
    Get.rawSnackbar(
        message: 'Question Added failed!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> editTrueFalse(Map<String, dynamic> map) async {
    try {
      final response = await http.post(
        Uri.parse('${Base.api}/edit-truefalse'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
        body: jsonEncode(map),
      );

      final body = jsonDecode(response.body);
      debugPrint('editQuestion body: $body');
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While editQuestion() ${e.toString()}');
      return false;
    }
    Get.rawSnackbar(
        message: 'Question edited failed!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> addBlank(Map<String, dynamic> map) async {
    try {
      final response = await http.post(
        Uri.parse('${Base.api}/add-blank'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
        body: jsonEncode(map),
      );

      final body = jsonDecode(response.body);
      debugPrint('addQuestion body: $body');
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While addQuestion() ${e.toString()}');
      return false;
    }
    Get.rawSnackbar(
        message: 'Question Added failed!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> editBlank(Map<String, dynamic> map) async {
    try {
      final response = await http.post(
        Uri.parse('${Base.api}/edit-blank'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
        body: jsonEncode(map),
      );

      final body = jsonDecode(response.body);
      debugPrint('editQuestion body: $body');
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While editQuestion() ${e.toString()}');
      return false;
    }
    Get.rawSnackbar(
        message: 'Question edited failed!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> addShort(Map<String, dynamic> map) async {
    try {
      final response = await http.post(
        Uri.parse('${Base.api}/add-short'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
        body: jsonEncode(map),
      );

      final body = jsonDecode(response.body);
      debugPrint('addQuestion body: $body');
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While addQuestion() ${e.toString()}');
      return false;
    }
    Get.rawSnackbar(
        message: 'Question Added failed!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> editShort(Map<String, dynamic> map) async {
    try {
      final response = await http.post(
        Uri.parse('${Base.api}/edit-short'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
        body: jsonEncode(map),
      );

      final body = jsonDecode(response.body);
      debugPrint('editQuestion body: $body');
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While editQuestion() ${e.toString()}');
      return false;
    }
    Get.rawSnackbar(
        message: 'Question edited failed!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> addLong(Map<String, dynamic> map) async {
    try {
      final response = await http.post(
        Uri.parse('${Base.api}/add-long'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
        body: jsonEncode(map),
      );

      final body = jsonDecode(response.body);
      debugPrint('addQuestion body: $body');
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While addQuestion() ${e.toString()}');
      return false;
    }
    Get.rawSnackbar(
        message: 'Question Added failed!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> editLong(Map<String, dynamic> map) async {
    try {
      final response = await http.post(
        Uri.parse('${Base.api}/edit-long'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
        body: jsonEncode(map),
      );

      final body = jsonDecode(response.body);
      debugPrint('editQuestion body: $body');
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While editQuestion() ${e.toString()}');
      return false;
    }
    Get.rawSnackbar(
        message: 'Question edited failed!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> addOneTwo(Map<String, dynamic> map) async {
    try {
      final response = await http.post(
        Uri.parse('${Base.api}/add-onetwo'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
        body: jsonEncode(map),
      );

      final body = jsonDecode(response.body);
      debugPrint('addQuestion body: $body');
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While addQuestion() ${e.toString()}');
      return false;
    }
    Get.rawSnackbar(
        message: 'Question Added failed!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> editOneTwo(Map<String, dynamic> map) async {
    try {
      final response = await http.post(
        Uri.parse('${Base.api}/edit-onetwo'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
        body: jsonEncode(map),
      );

      final body = jsonDecode(response.body);
      debugPrint('editQuestion body: $body');
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While editQuestion() ${e.toString()}');
      return false;
    }
    Get.rawSnackbar(
        message: 'Question edited failed!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> deleteMcq(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${Base.api}/delete-mcq?id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
      );

      final body = jsonDecode(response.body);
      debugPrint('deleteQuestion body: $body');
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While deleteQuestion() ${e.toString()}');
      return Future.error(e);
    }
    Get.rawSnackbar(
        message: 'Something went wrong!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> deleteTrueFalse(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${Base.api}/delete-truefalse?id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
      );

      final body = jsonDecode(response.body);
      debugPrint('deleteQuestion body: $body');
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While deleteQuestion() ${e.toString()}');
      return Future.error(e);
    }
    Get.rawSnackbar(
        message: 'Something went wrong!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> deleteBlank(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${Base.api}/delete-blank?id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
      );

      final body = jsonDecode(response.body);
      debugPrint('deleteQuestion body: $body');
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While deleteQuestion() ${e.toString()}');
      return Future.error(e);
    }
    Get.rawSnackbar(
        message: 'Something went wrong!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> deleteShort(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${Base.api}/delete-short?id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
      );

      final body = jsonDecode(response.body);
      debugPrint('deleteQuestion body: $body');
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While deleteQuestion() ${e.toString()}');
      return Future.error(e);
    }
    Get.rawSnackbar(
        message: 'Something went wrong!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> deleteLong(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${Base.api}/delete-long?id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
      );

      final body = jsonDecode(response.body);
      debugPrint('deleteQuestion body: $body');
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While deleteQuestion() ${e.toString()}');
      return Future.error(e);
    }
    Get.rawSnackbar(
        message: 'Something went wrong!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> deleteOneTwo(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${Base.api}/delete-onetwo?id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
      );

      final body = jsonDecode(response.body);
      debugPrint('deleteQuestion body: $body');
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint('Error While deleteQuestion() ${e.toString()}');
      return Future.error(e);
    }
    Get.rawSnackbar(
        message: 'Something went wrong!', backgroundColor: Colors.redAccent);
    return false;
  }
}
