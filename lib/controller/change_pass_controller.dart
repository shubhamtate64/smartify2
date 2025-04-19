import 'dart:developer';

import 'package:Smartify/httplocalhost/httpglobal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../view/login_screen.dart';

class ChangePasswordController extends GetxController {
  var isLoading = false.obs;
  var emailError = ''.obs;
  var oldPasswordError = ''.obs;
  var newPasswordError = ''.obs;
  var shakeTrigger = false.obs;

  void triggerShake() {
    shakeTrigger.value = true;
    Future.delayed(Duration(milliseconds: 500), () {
      shakeTrigger.value = false;
    });
  }

  Future<bool> verifyEmail(String email) async {
    try {
      isLoading(true);
      var response = await http.post(
        Uri.parse('https://your-api.com/check-email'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      var data = json.decode(response.body);
      return data['exists'] == true; // Return true if email exists
    } catch (e) {
      Get.snackbar("Error", "Network error: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<bool> verifyOldPassword(String email, String oldPassword) async {
    try {
      isLoading(true);
      var response = await http.post(
        Uri.parse('https://your-api.com/verify-old-password'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "oldPassword": oldPassword}),
      );

      var data = json.decode(response.body);
      return data['valid'] == true; // Return true if old password is correct
    } catch (e) {
      Get.snackbar("Error", "Network error: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<void> updatePassword(String email, String newPassword,String oldPassword) async {
    try {
      isLoading(true);
      var response = await http.post(
        Uri.parse('$httpHomeAutomation/EndUserController/ResetPassword'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "newPassword": newPassword,
          "oldPassword":oldPassword,

        }),
      );

      Map<String,dynamic> data = json.decode(response.body);
      String val = data["message"];

      if(val ==  "Password reset successfuly.!"){
          Get.snackbar("message", "Password reset successfuly.!",
            backgroundColor: Colors.green, colorText: Colors.white);
        Future.delayed(Duration(seconds: 1), () {
          // Navigate to the Login page after the snackbar is displayed
          Get.off(() => LoginScreen()); // Replace with your actual LoginPage class
        });

      }else{
        log(val);
         Get.snackbar("Invalid", "Email or Password !",
            backgroundColor: const Color.fromARGB(255, 255, 0, 0), colorText: Colors.white);
      }

      // Navigate back to login screen

      // if (data['success'] == true) {
      //   Get.snackbar("Success", "Password updated successfully!",
      //       backgroundColor: Colors.green, colorText: Colors.white);
      //   Get.offAll(()=>LoginScreen()); // Navigate back to login screen
      // } else {
      //   Get.snackbar("Error", "Failed to update password",
      //       backgroundColor: Colors.red, colorText: Colors.white);
      // }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }
}
