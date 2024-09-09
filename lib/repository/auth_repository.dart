import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lexus_admin/module/auth/auth_service.dart';
import 'package:lexus_admin/module/auth/login_view.dart';
import 'package:lexus_admin/module/navigation/navigation_view.dart';
import 'package:lexus_admin/repository/base.dart';

class AuthRepository {
  Future<String> signIn(Map<String, dynamic> map) async {
    try {
      final response = await http.post(
        Uri.parse('${Base.api}/login'),
        body: map,
      );
      final body = jsonDecode(response.body);
      debugPrint('signIn body: $body');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var map = {'jwt': body['token']};
        Get.rawSnackbar(
          backgroundColor: Colors.green,
          message: 'Login Successfully!', // Add a message here
        );
        await AuthService.storage.write('token', map);
        print(AuthService.token);
        Get.to(const NavigationView());
        return 'sucsess';
      } else {
        Get.to(LoginView());
        Get.rawSnackbar(
          backgroundColor: Colors.red,
          message: 'Login Failed!', // Add a message here
        );

        return body['message'].toString();
      }
    } catch (e) {
      Get.to(LoginView());
      debugPrint('Error While sigIn() ${e.toString()}');
      return Future.error(e);
    }
  }

  Future<void> verifyToken() async {
    print(AuthService.token);
    try {
      final response = await http.post(Uri.parse('${Base.api}/verify-token'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UFT-8',
            HttpHeaders.authorizationHeader: "Bearer ${AuthService.token}"
          });

      print(AuthService.token);
      final body = jsonDecode(response.body);
      debugPrint('verifyToken body: $body');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.to(const NavigationView());
      } else {
        Get.to(LoginView());
      }
    } catch (e) {
      Get.to(LoginView());
      debugPrint('Error While verifyToken() ${e.toString()}');
      return Future.error(e);
    }
  }
}
