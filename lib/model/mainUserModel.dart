import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainUser {
  var passcode = "".obs;
  var password = "".obs; // Added password field
  var firstName = "".obs;
  var lastName = "".obs;
  var name = "".obs;
  var address = "".obs;
  var email = "".obs;
  var gender = "".obs;
  var mobileNo = "".obs;
  var userType = "".obs;
  var token = "".obs;
  var id = "".obs;
  var role = "".obs;
  var devices = "".obs;
  var activeFlag = "".obs;
  var parentId = "".obs;
  var requestStatus = "".obs;
  var imgpath = "".obs;

  MainUser({
    required String passcode,
    required String password,  // Added password field
    required String firstName,
    required String lastName,
    required String name,
    required String address,
    required String email,
    required String gender,
    required String mobileNo,
    required String userType,
    required String token,
    required String id,
    required String role,
    required String devices,
    required String activeFlag,
    required String parentId,
    required String requestStatus,
    required String imgpath,
  }) {
    this.passcode.value = passcode;
    this.password.value = password;  // Initialize password field
    this.firstName.value = firstName;
    this.lastName.value = lastName;
    this.name.value = name;
    this.address.value = address;
    this.email.value = email;
    this.gender.value = gender;
    this.mobileNo.value = mobileNo;
    this.userType.value = userType;
    this.token.value = token;
    this.id.value = id;
    this.role.value = role;
    this.devices.value = devices;
    this.activeFlag.value = activeFlag;
    this.parentId.value = parentId;
    this.requestStatus.value = requestStatus;
    this.imgpath.value = imgpath;
  }

  factory MainUser.fromJson(Map<String, dynamic> data) {
    return MainUser(
      passcode: data["passcode"].toString(),
      password: data["password"] ?? "",  // Add password field here
      firstName: data["firstName"] ?? "",
      lastName: data["lastName"] ?? "",
      name: data["name"] ?? "",
      address: data["address"] ?? "",
      email: data["email"] ?? "",
      gender: data["gender"] ?? "Other",
      mobileNo: data["contact"] ?? "",
      userType: data["userType"] ?? "User",
      token: data["token"] ?? "",
      id: data["id"].toString(),
      role: data["role"] ?? "",
      devices: data["devices"] ?? "0",
      activeFlag: data["activeFlag"] ?? "N",
      parentId: data["parentId"].toString(),
      requestStatus: data["requestStatus"] ?? "",
      imgpath: data["imgpath"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "passcode": passcode.value,
      "password": password.value,  // Include password in toJson
      "firstName": firstName.value,
      "lastName": lastName.value,
      "name": name.value,
      "address": address.value,
      "email": email.value,
      "gender": gender.value,
      "mobileNo": mobileNo.value,
      "userType": userType.value,
      "token": token.value,
      "id": id.value,
      "role": role.value,
      "devices": devices.value,
      "activeFlag": activeFlag.value,
      "parentId": parentId.value,
      "requestStatus": requestStatus.value,
      "imgpath": imgpath.value,
    };
  }

  // Method to update profile and make API call
  Future<void> updateProfile() async {
    // Validate the fields
    if (_validateFields()) {
      try {
        final response = await http.put(
          Uri.parse('https://yourapi.com/updateProfile'), // Replace with your API endpoint
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token.value}', // If required, add authentication token
          },
          body: json.encode(toJson()),
        );

        if (response.statusCode == 200) {
          // If the update is successful, show success and update local user data
          Get.snackbar('Success', 'Profile updated successfully');
          // Update local data (e.g., use GetX to update main user data if necessary)
        } else {
          Get.snackbar('Error', 'Failed to update profile');
        }
      } catch (e) {
        Get.snackbar('Error', 'An error occurred while updating the profile');
      }
    }
  }

  // Validation method for the fields
  bool _validateFields() {
    // Validate first name
    if (firstName.value.isEmpty) {
      Get.snackbar('Error', 'First name is required');
      return false;
    }
    // Validate last name
    if (lastName.value.isEmpty) {
      Get.snackbar('Error', 'Last name is required');
      return false;
    }
    // Validate email
    if (email.value.isEmpty || !GetUtils.isEmail(email.value)) {
      Get.snackbar('Error', 'Please enter a valid email');
      return false;
    }
    // Validate mobile number
    if (mobileNo.value.isEmpty || mobileNo.value.length != 10) {
      Get.snackbar('Error', 'Please enter a valid mobile number');
      return false;
    }
    // Validate passcode
    if (passcode.value.isEmpty) {
      Get.snackbar('Error', 'Passcode is required');
      return false;
    }
    // Validate password
    if (password.value.isEmpty) {
      Get.snackbar('Error', 'Password is required');
      return false;
    }
    return true;
  }
}
