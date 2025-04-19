import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../httplocalhost/httpglobal.dart';

import '../model/mainUserModel.dart';

import '../services/connectivity_service.dart';
import '../view/baseScreen.dart';
import '../view/home_screen.dart';

import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var email = ''.obs;
  var password = ''.obs;
  var isPasswordVisible = false.obs;
  var emailError = RxnString();
  var passwordError = RxnString();
  var shakeError = false.obs;
  var isLoading = false.obs;
  MainUser? mainUser;

  void validateEmail(String value) {
    email.value = value;
    if (!GetUtils.isEmail(value)) {
      emailError.value = "Enter a valid email";
      triggerShake();
    } else {
      emailError.value = null;
    }
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordError.value = "Password is required";
      triggerShake();
    } else if (value.length <= 3) {
      passwordError.value = "Password must be at least 4 characters";
      triggerShake();
    } else {
      passwordError.value = null;
    }
  }

  void triggerShake() {
    shakeError.value = true;
    Future.delayed(Duration(milliseconds: 500), () {
      shakeError.value = false;
    });
  }

  // void login() async {
  // if (emailError.value == null && passwordError.value == null && passwordError.value!.isNotEmpty && email.value!.isNotEmpty ) {

  //   try {
  //     await _auth.signInWithEmailAndPassword(
  //       email: emailController.text.trim(),
  //       password: passwordController.text.trim(),
  //     );

  //     Get.offAll(()=>HomePage());
  //      Get.snackbar("Success", "Login successful", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.red);
  //   }

  //   }else{

  //     passwordError.value = "";
  //     emailError.value ="";
  //   }
  // }

  void login() {
    emailController.text = "shubhamtate70@gmail.com"; // Default values for testing
    passwordController.text = "12345";

    validatePassword(passwordController.text.trim());
    validateEmail(emailController.text.trim());

    final isOnline = Get.find<ConnectivityService>().isOnline.value;

    if (!isOnline) {
      Get.snackbar(
        "No Internet",
        "Please check your internet connection",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (emailError.value == null && passwordError.value == null) {
      loginUser(emailController.text.trim(), passwordController.text.trim());
    }
  }

  Future<void> loginUser(String email, String password) async {
    ///textting pur
    // Get.offAll(HomePage());
    try {
      isLoading(true);

      var response = await http.post(
        Uri.parse(
            '$httpHomeAutomation/LoginController/Admin/login'), // Replace with your API endpoint
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      log('${json.decode(response.body)}');
      log('${response.statusCode}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['token'].isNotEmpty) {
          mainUser = MainUser.fromJson(data);
          
          Get.offAll(
              () => HomePage()); // Navigate to HomePage
        } else {
          Get.snackbar("Login Failed", "Invalid email or password",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar("Error", "Server Error: ${response.statusCode}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("message", "Your request still pending",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }
}
