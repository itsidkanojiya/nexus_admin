import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/repository/auth_repository.dart';

class LoginController extends GetxController {
  var emailText = TextEditingController();
  var passwordText = TextEditingController();
  void login() async {
    var map = {'email': 'test5@gmail.com', 'password': 'test'};
    await AuthRepository().signIn(map);
  }
}
