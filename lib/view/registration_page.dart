import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/registration_controller.dart';
import '../view/login_screen.dart';

class RegistrationScreen extends StatelessWidget {
  final RegistrationController registrationController =
      Get.find<RegistrationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            registrationController.clearTextControllers();
            Get.offAll(() => LoginScreen());
          },
          child: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Obx(
        () =>
            registrationController.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 250, 245, 246),
                                border: Border.all(),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.w),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5.h),
                                      Center(
                                        child: Text(
                                          "Register".toUpperCase(),
                                          style: GoogleFonts.aDLaMDisplay(
                                            fontSize: 50,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.h),

                                      // First Name & Last Name
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Obx(
                                              () => TextField(
                                                controller:
                                                    registrationController
                                                        .firstNameController,
                                                onChanged: (val) {
                                                  registrationController
                                                      .firstName
                                                      .value = val.trim();
                                                  registrationController
                                                      .validateFirstName(
                                                        val,
                                                      ); // Validate immediately
                                                },
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                                decoration: InputDecoration(
                                                  labelText: "First Name",
                                                  labelStyle: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          registrationController
                                                                  .firstNameError
                                                                  .value
                                                                  .isEmpty
                                                              ? Colors.black
                                                              : Colors
                                                                  .red, // Change border color on error
                                                    ),
                                                  ),
                                                  errorText:
                                                      registrationController
                                                              .firstNameError
                                                              .value
                                                              .isEmpty
                                                          ? null
                                                          : registrationController
                                                              .firstNameError
                                                              .value,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Expanded(
                                            child: Obx(
                                              () => TextField(
                                                controller:
                                                    registrationController
                                                        .lastNameController,
                                                onChanged: (val) {
                                                  registrationController
                                                      .lastName
                                                      .value = val.trim();
                                                  registrationController
                                                      .validateLastName(
                                                        val,
                                                      ); // Validate immediately
                                                },
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                                decoration: InputDecoration(
                                                  labelText: "Last Name",
                                                  labelStyle: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          registrationController
                                                                  .lastNameError
                                                                  .value
                                                                  .isEmpty
                                                              ? Colors.black
                                                              : Colors
                                                                  .red, // Change border color on error
                                                    ),
                                                  ),
                                                  errorText:
                                                      registrationController
                                                              .lastNameError
                                                              .value
                                                              .isEmpty
                                                          ? null
                                                          : registrationController
                                                              .lastNameError
                                                              .value,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 10),
                                      // Email
                                      Obx(
                                        () => TextField(
                                          controller:
                                              registrationController
                                                  .emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          onChanged: (val) {
                                            registrationController.email.value =
                                                val.trim();
                                            registrationController
                                                .validateEmail(
                                                  val,
                                                ); // Validate immediately
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Enter Email",
                                            labelStyle: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    registrationController
                                                            .emailError
                                                            .value
                                                            .isEmpty
                                                        ? Colors.black
                                                        : Colors
                                                            .red, // Change border color on error
                                              ),
                                            ),
                                            errorText:
                                                registrationController
                                                        .emailError
                                                        .value
                                                        .isEmpty
                                                    ? null
                                                    : registrationController
                                                        .emailError
                                                        .value,
                                          ),
                                        ),
                                      ),
                                      // const SizedBox(height: 12),
                                      // ElevatedButton(
                                      //   onPressed: registrationController.sendOTP,
                                      //   child: const Text("Get OTP",
                                      //   style: TextStyle(color: Colors.black,),),
                                      // ),
                                      const SizedBox(height: 10),
                                      // Obx(() => Column(
                                      //       children: [
                                      //         TextField(
                                      //           controller:
                                      //               registrationController.otpController,
                                      //           onChanged: (val) {
                                      //             registrationController.otp.value =
                                      //                 val.trim();
                                      //             registrationController.validateOTP(
                                      //                 val); // Validate immediately
                                      //           },
                                      //           keyboardType: TextInputType.number,
                                      //           maxLength: 6,
                                      //           style:
                                      //               const TextStyle(color: Colors.black),
                                      //           decoration: InputDecoration(
                                      //             labelText: "Enter OTP",
                                      //             labelStyle: const TextStyle(
                                      //                 color: Colors.black),
                                      //             border: const OutlineInputBorder(),
                                      //             errorText: registrationController
                                      //                     .otpError.value.isEmpty
                                      //                 ? null
                                      //                 : registrationController
                                      //                     .otpError.value,
                                      //             prefixIcon: Icon(Icons.lock,
                                      //                 color: Colors.black),
                                      //           ),
                                      //         ),
                                      //         const SizedBox(height: 0),
                                      //         ElevatedButton(
                                      //           onPressed: registrationController
                                      //               .verifyOTP, // Call verifyOTP
                                      //           child: Text("Verify OTP",
                                      //           style: TextStyle(color: Colors.black,),),
                                      //         ),
                                      //       ],
                                      //     )),

                                      // SizedBox(height: 10.h),

                                      // Password & Confirm Password fields
                                      Obx(
                                        () => TextField(
                                          controller:
                                              registrationController
                                                  .passwordController,
                                          obscureText:
                                              !registrationController
                                                  .isPasswordVisible
                                                  .value,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          onChanged: (val) {
                                            registrationController
                                                .password
                                                .value = val.trim();
                                            registrationController
                                                .validatePassword(val);
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Enter Password",
                                            labelStyle: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    registrationController
                                                            .passwordError
                                                            .value
                                                            .isEmpty
                                                        ? Colors.black
                                                        : Colors.red,
                                              ),
                                            ),
                                            errorText:
                                                registrationController
                                                        .passwordError
                                                        .value
                                                        .isEmpty
                                                    ? null
                                                    : registrationController
                                                        .passwordError
                                                        .value,
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                registrationController
                                                        .isPasswordVisible
                                                        .value
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                registrationController
                                                    .isPasswordVisible
                                                    .toggle();
                                              },
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 15),
                                      Obx(
                                        () => TextField(
                                          controller:
                                              registrationController
                                                  .confirmPasswordController,
                                          obscureText:
                                              !registrationController
                                                  .isConfirmPasswordVisible
                                                  .value,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          onChanged: (val) {
                                            registrationController
                                                .confirmPassword
                                                .value = val.trim();
                                            registrationController
                                                .validateConfirmPassword(val);
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Confirm Password",
                                            labelStyle: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    registrationController
                                                            .confirmPasswordError
                                                            .value
                                                            .isEmpty
                                                        ? Colors.black
                                                        : Colors.red,
                                              ),
                                            ),
                                            errorText:
                                                registrationController
                                                        .confirmPasswordError
                                                        .value
                                                        .isEmpty
                                                    ? null
                                                    : registrationController
                                                        .confirmPasswordError
                                                        .value,
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                registrationController
                                                        .isConfirmPasswordVisible
                                                        .value
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                registrationController
                                                    .isConfirmPasswordVisible
                                                    .toggle();
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      // Mobile Number field
                                      Obx(
                                        () => TextField(
                                          controller:
                                              registrationController
                                                  .mobileNoController,
                                          keyboardType: TextInputType.phone,
                                          onChanged: (val) {
                                            registrationController
                                                .mobileNo
                                                .value = val.trim();
                                            registrationController
                                                .validateMobileNo(
                                                  val,
                                                ); // Validate immediately
                                          },
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: "Mobile Number",
                                            labelStyle: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    registrationController
                                                            .mobileNoError
                                                            .value
                                                            .isEmpty
                                                        ? Colors.black
                                                        : Colors
                                                            .red, // Change border color on error
                                              ),
                                            ),
                                            errorText:
                                                registrationController
                                                        .mobileNoError
                                                        .value
                                                        .isEmpty
                                                    ? null
                                                    : registrationController
                                                        .mobileNoError
                                                        .value,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 15.h),

                                      // Gender Dropdown
                                      Obx(
                                        () => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  dropdownColor: Colors.white,
                                                  value:
                                                      registrationController
                                                                  .selectedGender
                                                                  .value ==
                                                              "Select Gender"
                                                          ? null
                                                          : registrationController
                                                              .selectedGender
                                                              .value,
                                                  hint: Text(
                                                    "Select Gender",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.black,
                                                  ),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                  ),
                                                  items:
                                                      [
                                                            "Male",
                                                            "Female",
                                                            "Other",
                                                          ]
                                                          .map(
                                                            (
                                                              gender,
                                                            ) => DropdownMenuItem(
                                                              value: gender,
                                                              child: Text(
                                                                gender,
                                                                style: TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                          .toList(),
                                                  onChanged: (value) {
                                                    registrationController
                                                        .selectedGender
                                                        .value = value!;
                                                    registrationController
                                                        .isSelected
                                                        .value = true;
                                                    registrationController
                                                        .validateGender(
                                                          value,
                                                        ); // Validate immediately
                                                  },
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),

                                      Obx(() {
                                        return Text(
                                          registrationController
                                                  .genderError
                                                  .value
                                                  .isEmpty
                                              ? ''
                                              : registrationController
                                                  .genderError
                                                  .value,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        );
                                      }),

                                      SizedBox(height: 15.h),

                                      Obx(
                                        () => TextField(
                                          controller:
                                              registrationController
                                                  .passcodeController,
                                          keyboardType: TextInputType.phone,
                                          onChanged: (val) {
                                            registrationController
                                                .passcode
                                                .value = val.trim();
                                            registrationController
                                                .validepasscode(val);
                                            // Validate immediately
                                          },
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: "Passcode Number",
                                            labelStyle: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    registrationController
                                                            .passcodeError
                                                            .value
                                                            .isEmpty
                                                        ? Colors.black
                                                        : Colors
                                                            .red, // Change border color on error
                                              ),
                                            ),
                                            errorText:
                                                registrationController
                                                        .passcodeError
                                                        .value
                                                        .isEmpty
                                                    ? null
                                                    : registrationController
                                                        .passcodeError
                                                        .value,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 20.h),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              width: 250,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () async {
                                  bool success =
                                      await registrationController.register();

                                  if (success) {
                                     Future.delayed(Duration(seconds: 1), () {
                                      // Get.off(() => LoginScreen());
       // go back to Login screen
      });
                                   
                                  } else {
                                    // Handle failure (show error messages, etc.)
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "SignIn",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
