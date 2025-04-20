import 'package:Smartify/view/baseScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



import '../controller/change_pass_controller.dart'; // For shake animation

class ChangePasswordScreen extends StatelessWidget {
  final ChangePasswordController changePasswordController =
      Get.put(ChangePasswordController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  var isPasswordVisible = false.obs; // Toggle Password Visibility
  final RxString emailError = ''.obs;
  final RxString oldPasswordError = ''.obs;
  final RxString newPasswordError = ''.obs;

  void validateAndSubmit() async {
    String email = emailController.text.trim();
    String oldPassword = oldPasswordController.text.trim();
    String newPassword = newPasswordController.text.trim();

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      emailError.value = "Enter a valid email";
      changePasswordController.triggerShake();
      return;
    }

    // Check if email exists
    bool emailExists = await changePasswordController.verifyEmail(email);
    if (!emailExists) {
      emailError.value = "Email not found!";
      changePasswordController.triggerShake();
      return;
    } else {
      emailError.value = "";
    }

    if (oldPassword.isEmpty) {
      oldPasswordError.value = "Enter old password";
      changePasswordController.triggerShake();
      return;
    }

    // Verify old password
    bool isOldPasswordValid =
        await changePasswordController.verifyOldPassword(email, oldPassword);
    if (!isOldPasswordValid) {
      oldPasswordError.value = "Incorrect old password";
      changePasswordController.triggerShake();
      return;
    } else {
      oldPasswordError.value = "";
    }

    if (newPassword.length < 6) {
      newPasswordError.value = "Password must be at least 6 characters";
      changePasswordController.triggerShake();
    } else if (!RegExp(r'(?=.*[A-Z])(?=.*[a-z])(?=.*\d)')
        .hasMatch(newPassword)) {
      newPasswordError.value = "Use upper, lower & a number";
      changePasswordController.triggerShake();
    } else if (newPassword == oldPassword) {
      newPasswordError.value =
          "New password cannot be the same as old password";
      changePasswordController.triggerShake();
    } else {
      newPasswordError.value = "";
      changePasswordController.updatePassword(email, newPassword,oldPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text("Change Password"),backgroundColor: Colors.grey[300],),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Obx(() => buildEmailField()),
            SizedBox(height: 10),
            Obx(() => buildOldPasswordField()),
            SizedBox(height: 10),
            Obx(() => buildNewPasswordField()),
            SizedBox(height: 20),
            Obx(() => changePasswordController.isLoading.value
                ? CircularProgressIndicator()
                :Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // validateAndSubmit();
                        changePasswordController.updatePassword(emailController.text, newPasswordController.text,oldPasswordController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child:
                          Text("Update Password", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildEmailField() {
    return TextField(
      controller: emailController,
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
        errorText: emailError.value.isNotEmpty ? emailError.value : null,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildOldPasswordField() {
    return TextField(
      controller: oldPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Old Password",
        labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
        errorText:
            oldPasswordError.value.isNotEmpty ? oldPasswordError.value : null,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildNewPasswordField() {
    return TextField(
      controller: newPasswordController,
      obscureText: !isPasswordVisible.value, // Toggle Password Visibility
      decoration: InputDecoration(
        labelText: "New Password",
        labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
        errorText:
            newPasswordError.value.isNotEmpty ? newPasswordError.value : null,
        border: OutlineInputBorder(),
        suffixIcon: Obx(
          () => IconButton(
            icon: Icon(isPasswordVisible.value
                ? Icons.visibility
                : Icons.visibility_off),
            onPressed: () {
              isPasswordVisible.value = !isPasswordVisible.value;
            },
          ),
        ),
      ),
    );
  }
}
