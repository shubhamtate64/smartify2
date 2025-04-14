import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ProfileController.dart';

class ProfileView extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.grey[300],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Avatar based on gender
              Obx(() {
                return CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                    profileController.gender.value.toLowerCase() == "male"
                        ? 'assets/MaleAvtar.png'
                        : 'assets/FemaleAvtar.png',
                  ),
                );
              }),
              SizedBox(height: 20),

              // First Name
              Obx(() {
                return TextField(
                  controller: profileController.firstNameController,
                  onChanged: (value) {
                    profileController.firstName.value = value;
                  },
                  decoration: InputDecoration(
                    labelText: "First Name",
                    errorText: profileController.firstNameError.value.isEmpty
                        ? null
                        : profileController.firstNameError.value,
                    border: OutlineInputBorder(),
                  ),
                );
              }),
              SizedBox(height: 10),

              // Last Name
              Obx(() {
                return TextField(
                  controller: profileController.lastNameController,
                  onChanged: (value) {
                    profileController.lastName.value = value;
                  },
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    errorText: profileController.lastNameError.value.isEmpty
                        ? null
                        : profileController.lastNameError.value,
                    border: OutlineInputBorder(),
                  ),
                );
              }),
              SizedBox(height: 10),

              // Email
              Obx(() {
                return TextField(
                  controller: profileController.emailController,
                  onChanged: (value) {
                    profileController.email.value = value;
                  },
                  decoration: InputDecoration(
                    labelText: "Email",
                    errorText: profileController.emailError.value.isEmpty
                        ? null
                        : profileController.emailError.value,
                    border: OutlineInputBorder(),
                  ),
                );
              }),
              SizedBox(height: 10),

              // Gender Dropdown
              Obx(() {
                return DropdownButton<String>(
                  value: profileController.gender.value == "Select Gender"
                      ? null
                      : profileController.gender.value,
                  hint: Text("Select Gender"),
                  items: ["Male", "Female"]
                      .map((gender) => DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    profileController.gender.value = newValue!;
                  },
                );
              }),
              Obx(() {
                return Text(
                  profileController.genderError.value.isEmpty
                      ? ''
                      : profileController.genderError.value,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                );
              }),
              SizedBox(height: 10),

              // Password
              Obx(() {
                return TextField(
                  controller: profileController.passwordController,
                  obscureText: true,
                  onChanged: (value) {
                    profileController.password.value = value;
                  },
                  decoration: InputDecoration(
                    labelText: "Password",
                    errorText: profileController.passwordError.value.isEmpty
                        ? null
                        : profileController.passwordError.value,
                    border: OutlineInputBorder(),
                  ),
                );
              }),
              SizedBox(height: 10),

              // Confirm Password
              Obx(() {
                return TextField(
                  controller: profileController.confirmPasswordController,
                  obscureText: true,
                  onChanged: (value) {
                    profileController.confirmPassword.value = value;
                  },
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    errorText: profileController.confirmPasswordError.value.isEmpty
                        ? null
                        : profileController.confirmPasswordError.value,
                    border: OutlineInputBorder(),
                  ),
                );
              }),
              SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: profileController.updateProfile,
                child: Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
