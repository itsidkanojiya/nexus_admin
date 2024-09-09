import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/module/auth/login_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  var controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset("assets/logo.png", height: 300),
          Form(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 400.0),
            child: Column(
              children: [
                TextFormField(
                  controller: controller.emailText,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller.passwordText,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    controller.login();
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
