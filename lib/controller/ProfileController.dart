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
  var gender = 'Select Gender'.obs;
  @override
  void onInit() {
    super.onInit();
    // Initialize controllers with current user data
    firstNameController.text = user.firstName.value;
    lastNameController.text = user.lastName.value;
    emailController.text = user.email.value;
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
          Get.snackbar('Success', 'Profile updated successfully!');
          // Update main user fields after successful update
          user.firstName.value = firstNameController.text;
          user.lastName.value = lastNameController.text;
          user.email.value = emailController.text;
          user.password.value = passwordController.text;  // Update password if needed
        } else {
          Get.snackbar('Error', 'Failed to update profile');
        }
      } catch (e) {
        Get.snackbar('Error', 'An error occurred while updating the profile');
      }
    } else {
      // If validation fails, show an error snackbar
      Get.snackbar('Error', 'Please fix the errors');
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
    // Validate password
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else {
      passwordError.value = '';
    }
    // Validate confirm password
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Confirm password is required';
      isValid = false;
    } else if (passwordController.text != confirmPasswordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
      isValid = false;
    } else {
      confirmPasswordError.value = '';
    }

     // Validate Gender
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
    try {
      final response = await http.put(
        Uri.parse('https://yourapi.com/updateProfile'), // Replace with your API endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${user.token.value}', // If required, add authentication token
        },
        body: json.encode({
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'gender': user.gender.value,
          'mobileNo': user.mobileNo.value,
        }),
      );

      if (response.statusCode == 200) {
        // If the update is successful, show success and update local user data
        return true;
      } else {
        // Show error snackbar if the update fails
        Get.snackbar('Error', 'Failed to update profile. Try again.');
        return false;
      }
    } catch (e) {
      // Handle error if any
      Get.snackbar('Error', 'An error occurred while updating the profile');
      return false;
    }
  }
}
