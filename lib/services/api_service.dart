import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/user_model.dart';


class ApiService extends GetxController {
  var users = <UserModel>[].obs;
  var isLoading = false.obs;

  // Fetch Users with Rooms from API
  Future<void> fetchUsersWithRooms() async {
    isLoading.value = true;
    try {
      var response = await http.get(Uri.parse('https://api.example.com/users'));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        // users.value = data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        Get.snackbar("Error", "Failed to load users");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong!");
    }
    isLoading.value = false;
  }
}
