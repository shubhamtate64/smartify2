import 'dart:developer';

import 'package:Smartify/httplocalhost/httpglobal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_screen_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileController extends GetxController {
  // Get the current logged-in user
  final user = Get.find<LoginController>().mainUser!; // Assuming LoginController contains MainUser

  // Controllers for the fields
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var PassCodeController = TextEditingController();

  // Observable error fields
  var firstNameError = "".obs;
  var lastNameError = "".obs;
  var emailError = "".obs;
  var passwordError = "".obs;
  var confirmPasswordError = "".obs;
  var genderError = ''.obs;

  var firstName = "".obs;
  var lastName = "".obs;
  var email = "".obs;
  var password = "".obs;
  var confirmPassword = "".obs;
  var passCode = "".obs;
  var gender = 'Select Gender'.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers with current user data
    firstNameController.text = user.firstName.value;
    lastNameController.text = user.lastName.value;
    emailController.text = user.email.value;
    gender.value = user.gender.value;
    PassCodeController.text = user.passcode.value;
  }

  // Method to validate the fields and update the profile
  Future<void> updateProfile() async {
    // Trigger validation when the save button is pressed
    if (_validateProfile()) {
      try {
        // Update the user object with the new data
        user.firstName.value = firstNameController.text;
        user.lastName.value = lastNameController.text;
        user.email.value = emailController.text;
        user.password.value = passwordController.text;

        // Call the API to update the profile
        bool isUpdated = await _updateUserProfile();
        if (isUpdated) {
          // Show success snackbar and update MainUser
          Get.snackbar(
            'Success',
            'Profile updated successfully!',
            backgroundColor: Colors.green, // Green background for success
            colorText: Colors.white, // White text
            snackPosition: SnackPosition.BOTTOM, // Position at the bottom
          );
          // Optionally update main user fields after successful update
          user.firstName.value = firstNameController.text;
          user.lastName.value = lastNameController.text;
          // user.email.value = emailController.text;
          user.gender.value = gender.value; // Update password if needed
        } else {
          Get.snackbar(
            'Error',
            'Failed to update profile',
            backgroundColor: Colors.red, // Red background for error
            colorText: Colors.white, // White text
            snackPosition: SnackPosition.BOTTOM, // Position at the bottom
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'An error occurred while updating the profile',
          backgroundColor: Colors.red, // Red background for error
          colorText: Colors.white, // White text
          snackPosition: SnackPosition.BOTTOM, // Position at the bottom
        );
      }
    } else {
      // If validation fails, show an error snackbar
      Get.snackbar(
        'Error',
        'Please fix the errors',
        backgroundColor: Colors.red, // Red background for error
        colorText: Colors.white, // White text
        snackPosition: SnackPosition.BOTTOM, // Position at the bottom
      );
    }
  }

  // Validation method for the profile
  bool _validateProfile() {
    bool isValid = true;

    // Validate first name
    if (firstNameController.text.isEmpty) {
      firstNameError.value = 'First name is required';
      isValid = false;
    } else {
      firstNameError.value = '';
    }

    // Validate last name
    if (lastNameController.text.isEmpty) {
      lastNameError.value = 'Last name is required';
      isValid = false;
    } else {
      lastNameError.value = '';
    }

    // Validate email
    if (emailController.text.isEmpty || !GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    } else {
      emailError.value = '';
    }

    // Validate gender
    if (gender.value == 'Select Gender') {
      genderError.value = 'Gender is required';
      isValid = false;
    } else {
      genderError.value = '';
    }

    return isValid;
  }

  // Method to update the profile via API
  Future<bool> _updateUserProfile() async {
    RxInt rxInt = 0.obs;

    // Safe conversion with tryParse
    int? parsedInt = int.tryParse(user.id.value);
    if (parsedInt != null) {
      rxInt.value = parsedInt; // Assign parsed value
    } else {
      print('Invalid integer format');
    }

    try {
      final response = await http.post(
        Uri.parse(
          '$httpHomeAutomation/EndUserController/CreateEndUser', // Replace with your API endpoint
        ),
        headers: {
          'Content-Type': 'application/json',
          // If required, add authentication token
        },
        body: jsonEncode({
          "id": rxInt.value, // You can replace this with dynamic data
          "name": user.name.value, // Replace with actual user data
          "contact": user.mobileNo.value,
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "gender": gender.value, // Using gender selected from the controller
          "activeFlag": "Y",
        }),
      );
      log(response.statusCode.toString());
      if (response.statusCode == 208) {
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to update profile. Try again.',
          backgroundColor: Colors.red, // Red background for error
          colorText: Colors.white, // White text
          snackPosition: SnackPosition.BOTTOM, // Position at the bottom
        );
        return false;
      }
    } catch (e) {
      // Handle error if any
      Get.snackbar(
        'Error',
        'An error occurred while updating the profile',
        backgroundColor: Colors.red, // Red background for error
        colorText: Colors.white, // White text
        snackPosition: SnackPosition.BOTTOM, // Position at the bottom
      );
      return false;
    }
  }

  // Method to clear the form fields
  void clearUserFormFields() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    gender.value = '';
  }
}
