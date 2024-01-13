import 'dart:convert';
import 'dart:io';

import 'package:fintech_dashboard_clone/models/solution_model.dart';
import 'package:fintech_dashboard_clone/module/auth/auth_service.dart';
import 'package:fintech_dashboard_clone/repository/base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SolutionRepository {
  Future<SolutionModel?> getSolutions() async {
    try {
      final response = await http
          .get(Uri.parse('${Base.api}/solutions'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UFT-8',
      });

      final body = jsonDecode(response.body);
      debugPrint('getSolutions body: $body');
      if (response.statusCode == 200) {
        return SolutionModel.fromJson(body);
      }
    } catch (e) {
      debugPrint('Error While getSolutions() ${e.toString()}');
      return Future.error(e);
    }
    return null;
  }

  Future<bool> addSolution(
      Map<String, dynamic> map, String coverImage, String pdf) async {
    try {
      var headers = {
        'Content-Type': 'application/json; charset=UFT-8',
        HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
      };
      var request =
          http.MultipartRequest('POST', Uri.parse('${Base.api}/add-solution'));

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
      debugPrint('addSolution body: $body');
      if (response.statusCode == 201) {
        Get.rawSnackbar(
            message: 'Solution Added Sucessfully!',
            backgroundColor: Colors.green);
        return true;
      }
    } catch (e) {
      Get.rawSnackbar(message: 'Solution Added failed!');
      debugPrint('Error While addSolutions() ${e.toString()}');
      return false;
    }
    Get.rawSnackbar(
        message: 'Solution Added failed!', backgroundColor: Colors.redAccent);
    return false;
  }

  Future<bool> deleteSolution(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${Base.api}/delete-solution?id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
        },
      );

      final body = jsonDecode(response.body);
      debugPrint('deleteSolution body: $body');
      if (response.statusCode == 200) {
        Get.rawSnackbar(
            message: 'Deleted Sucessfully!', backgroundColor: Colors.green);
        return true;
      }
    } catch (e) {
      debugPrint('Error While deleteSolution() ${e.toString()}');
      return Future.error(e);
    }
    Get.rawSnackbar(
        message: 'Something went wrong!', backgroundColor: Colors.redAccent);
    return false;
  }
}
