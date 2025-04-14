import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controller/login_screen_controller.dart';
import '../httplocalhost/httpglobal.dart';
import '../services/connectivity_service.dart';

import '../model/registration_model.dart';
import 'package:http/http.dart' as http;

class RegistrationController extends GetxController {

    LoginController loginController = Get.find<LoginController>();

  // TextControllers to handle text inputs
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passcodeController= TextEditingController();

  // Reactive variables for form inputs
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString email = ''.obs;
  RxString password = ''.obs;
  RxString confirmPassword = ''.obs;
  RxString mobileNo = ''.obs;
  RxString otp = ''.obs;

  // Reactive variables for error messages
  RxString firstNameError = ''.obs;
  RxString lastNameError = ''.obs;
  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;
  RxString confirmPasswordError = ''.obs;
  RxString mobileNoError = ''.obs;
  RxString genderError = ''.obs;
  RxString otpError = ''.obs;
  var profilePicUrl= ''.obs; 
  RxString passcodeError = ''.obs;

  // Reactive variable for gender and user type selection
  RxString selectedGender = "Select Gender".obs;
  RxBool isSelected = false.obs;
  RxString passcode = "".obs;
  RxBool isAdmin = true.obs;
  RxBool isOTPSent = false.obs;

  var isPasswordVisible = false.obs;
var isConfirmPasswordVisible = false.obs;



  // Validation methods
  void validateFirstName(String value) {
    if (value.isEmpty) {
      firstNameError.value = "First name is required";
    } else {
      firstNameError.value = "";
    }
  }

  void validateLastName(String value) {
    if (value.isEmpty) {
      lastNameError.value = "Last name is required";
    } else {
      lastNameError.value = "";
    }
  }

  void validateEmail(String value) {
    // Simple email validation
    if (value.isEmpty) {
      emailError.value = "Email is required";
    } else if (!GetUtils.isEmail(value)) {
      emailError.value = "Enter a valid email";
    } else {
      emailError.value = "";
    }
  }
   void validateOTP(String value) {
    if (value.isEmpty) {
      otpError.value = "OTP is required";
    } else {
      otpError.value = "";
    }
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordError.value = "Password is required";
    } else if (value.length <= 3) {
      passwordError.value = "Password must be at least 4 characters";
    } else {
      passwordError.value = "";
    }
  }

  void validateConfirmPassword(String value) {
    if (value.isEmpty) {
      confirmPasswordError.value = "Confirm password is required";
    } else if (value != password.value) {
      confirmPasswordError.value = "Passwords do not match";
    } else {
      confirmPasswordError.value = "";
    }
  }

  void validateMobileNo(String value) {
    if (value.isEmpty) {
      mobileNoError.value = "Mobile number is required";
    } else if (value.length != 10) {
      mobileNoError.value = "Enter a valid 10-digit mobile number";
    } else {
      mobileNoError.value = "";
    }
  }

  void validepasscode(String value) {
    if (value.isEmpty) {
      passcodeError.value = "PassCode number is required";
    } else if (value.length != 10) {
      passcodeError.value = "Enter a valid 10-digit PassCode number";
    } else {
      passcodeError.value = "";
    }
  }

  void validateGender(String value) {
    if (value == "Select Gender") {
      genderError.value = "Please select a gender";
    } else {
      genderError.value = "";
    }
  }

  // Validate all fields at once
  void validateAllFields() {
    // Trigger validation for all fields
    validateFirstName(firstName.value);
    validateLastName(lastName.value);
    validateEmail(email.value);
    validatePassword(password.value);
    validateConfirmPassword(confirmPassword.value);
    validateMobileNo(mobileNo.value);
    validateGender(selectedGender.value);
    validepasscode(passcode.value);
    validateOTP(otp.value);
  }

void sendOTP() async {
  validateEmail(email.value); // First validate email

  if (emailError.value.isNotEmpty) {
    Get.snackbar(
      "Error",
      "Please correct the errors before requesting OTP",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  // isLoading.value = true;

  try {
    final response = await http.post(
      Uri.parse('https://yourapi.com/sendOTP'), // 🔁 Replace with your actual endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email.value,
        // Optionally send mobile if your API requires it
        // "mobile": mobileNo.value,
      }),
    );

    if (response.statusCode == 200) {
      isOTPSent.value = true;

      Get.snackbar(
        "OTP Sent",
        "OTP has been successfully sent to your email/mobile",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Failed",
        "Unable to send OTP. Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      "Error",
      "An error occurred while sending OTP.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    // isLoading.value = false;
  }
}


  // Method to verify OTP
  
void verifyOTP() async {
  validateOTP(otp.value); // First validate the entered OTP

  if (otpError.value.isNotEmpty) {
    Get.snackbar(
      "Error",
      "Please enter the OTP",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  // isLoading.value = true;

  try {
    final response = await http.post(
      Uri.parse('https://yourapi.com/verifyOTP'), // 🔁 Replace with your actual endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email.value,     // Pass email or mobile based on your API
        "otp": otp.value.trim(),  // OTP entered by the user
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar(
        "Success",
        "OTP Verified Successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // ✅ Optional: Set verification flag or navigate to next screen
      // isOTPVerified.value = true;

    } else {
      Get.snackbar(
        "Invalid OTP",
        "OTP verification failed. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      "Error",
      "Something went wrong. Please try again later.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    // isLoading.value = false;
  }
}


 

  

  // Register method (modified to handle HTTP POST)
  Future<void> register() async {

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
    // Validate all fields before proceeding with registration
    validateAllFields();

    // If there are no validation errors, proceed with registration
    if (firstNameError.value.isEmpty &&
        lastNameError.value.isEmpty &&
        emailError.value.isEmpty &&
        passwordError.value.isEmpty &&
        confirmPasswordError.value.isEmpty &&
        mobileNoError.value.isEmpty &&
        genderError.value.isEmpty) {
      
      // Create a RegistrationModel instance
      RegistrationModel registrationData = RegistrationModel(
        firstName: firstName.value,
        lastName: lastName.value,
        email: email.value,
        password: password.value,
        mobileNo: mobileNo.value,
        gender: selectedGender.value, 
        
        passcode: passcodeController.text.trim(),
      );

      // Perform the HTTP POST request
      try {
        var response = await http.post(
         Uri.parse('$httpHomeAutomation/EndUserController/CreateEndUser'),  // Replace with your actual URL
          headers: {"Content-Type": "application/json"},
          body: json.encode(registrationData.toJson()),
        );

        if (response.statusCode == 200) {
          // Handle success
          Get.snackbar("Registration", "Registration successful", snackPosition: SnackPosition.BOTTOM);
        } else {
          // Handle error
          Get.snackbar("Error", "Registration failed: ${response.body}", snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        // Handle error
        Get.snackbar("Error", "An error occurred: $e", snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar("Error", "Please correct the errors in the form", snackPosition: SnackPosition.BOTTOM);
    }
  }


  //   // Method to validate the form
  // bool validateForm() {
  //   if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
  //     firstNameError.value = 'First Name cannot be empty';
  //     lastNameError.value = 'Last Name cannot be empty';
  //     return false;
  //   }
  //   if (emailController.text.isEmpty || !GetUtils.isEmail(emailController.text)) {
  //     emailError.value = 'Invalid email address';
  //     return false;
  //   }
  //   if (passwordController.text.isEmpty || passwordController.text.length < 6) {
  //     passwordError.value = 'Password must be at least 6 characters';
  //     return false;
  //   }
  //   if (passwordController.text != confirmPasswordController.text) {
  //     confirmPasswordError.value = 'Passwords do not match';
  //     return false;
  //   }
  //   return true;
  // }

  // // Method to update the profile information
  // Future<void> updateProfile() async {
  //   // First, validate the form fields
  //   if (!validateForm()) {
  //     Get.snackbar('Error', 'Please fill all required fields correctly.');
  //     return;
  //   }

  //   // Prepare the data to send to the server
  //   final userData = {
  //     'first_name': firstNameController.text,
  //     'last_name': lastNameController.text,
  //     'email': emailController.text,
  //     'password': passwordController.text, // Optional (if user wants to change it)
  //     'mobile_no': mobileNoController.text,
  //     'passcode': passcodeController.text,
  //     'gender': selectedGender.value,
  //   };

  //   try {
  //     // Make the API call to update the profile data
  //     final response = await http.put(
  //       Uri.parse('https://yourapi.com/updateProfile'),  // Replace with your API endpoint
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer your_token',  // If needed
  //       },
  //       body: json.encode(userData),
  //     );

  //     if (response.statusCode == 200) {
  //       // If the API is successful, update the user data
  //       loginController.mainUser!.firstName.value = firstNameController.text;
  //       loginController.mainUser!.lastName.value = lastNameController.text;
  //       loginController.mainUser!.email.value = emailController.text;
  //       loginController.mainUser!.mobileNo.value = mobileNoController.text;
  //       loginController.mainUser!.passcode.value = passcodeController.text;
  //       loginController.mainUser!.gender.value = selectedGender.value;

  //       // Show success message
  //       Get.snackbar('Success', 'Profile updated successfully.');
  //     } else {
  //       // If the API returns an error, show the error message
  //       Get.snackbar('Error', 'Failed to update profile.');
  //     }
  //   } catch (e) {
  //     // If there is an error in the API request
  //     Get.snackbar('Error', 'An error occurred while updating profile.');
  //   }
  // }

  // Dispose method (same as before, no change)
  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    mobileNoController.dispose();
    otpController.dispose();
    super.onClose();
  }

  void clearFields() {
  firstName.value = '';
  lastName.value = '';
  email.value = '';
  password.value = '';
  confirmPassword.value = '';
  mobileNo.value = '';
  otp.value = '';
}

void clearTextControllers() {
  firstNameController.clear();
  lastNameController.clear();
  emailController.clear();
  passwordController.clear();
  confirmPasswordController.clear();
  mobileNoController.clear();
  otpController.clear();
}


}