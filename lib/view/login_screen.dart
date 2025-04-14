
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../view/change_pass_screen.dart';
import '../view/registration_page.dart';

import '../controller/login_screen_controller.dart';
import '../controller/registration_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
 
  final LoginController controller = Get.find<LoginController>();
  final RegistrationController authregistrationControllercontroller = Get.find<RegistrationController>();
  
      
 
  
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: 
      Obx(

        ()=> Center(
          child:(!controller.isLoading.value) ? Padding(
            padding: EdgeInsets.all(20.w),
            child: SingleChildScrollView(
              child:
               Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Text(
                    "SMART HOME",
                    style: GoogleFonts.aDLaMDisplay(fontSize: 50),
                  ),
                  
                  Image.asset("assets/man1.png",height: 175, width: 300,fit: BoxFit.cover),
                    
                  SizedBox(height: 30.h), // Spacing between image and text
                    
                  
                    
                  
                    
                  Obx(() {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      transform: controller.shakeError.value
                          ? Matrix4.translationValues(10, 0, 0)
                          : Matrix4.translationValues(0, 0, 0),
                      child: TextField(
                        controller: controller.emailController,
                        onChanged: controller.validateEmail,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.black),
                          errorText: controller.emailError.value,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email, color: Colors.black),
                        ),
                      ),
                    );
                  }),
                    
                  SizedBox(height: 15.h),
                    
                  Obx(() {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      transform: controller.shakeError.value
                          ? Matrix4.translationValues(10, 0, 0)
                          : Matrix4.translationValues(0, 0, 0),
                      child: TextField(
                        controller: controller.passwordController,
                        onChanged: controller.validatePassword,
                        obscureText: !controller.isPasswordVisible.value,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.black),
                          errorText: controller.passwordError.value,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock, color: Colors.black),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              controller.isPasswordVisible.toggle();
                            },
                          ),
                        ),
                      ),
                    );
                  }),
                    
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(ChangePasswordScreen());
                      },
                      child: const Text(
                        "Change Password",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 18.sp)),
                    ),
                  ),
                  const SizedBox(height: 20),
                    
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("You have an already account?", style: TextStyle(color: Colors.black, fontSize: 14)),
                      const SizedBox(width: 3),
                      GestureDetector(
                        onTap: () =>  Get.offAll(()=>RegistrationScreen()),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ) : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
