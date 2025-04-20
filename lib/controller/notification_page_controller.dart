import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import '../controller/login_screen_controller.dart';
import '../httplocalhost/httpglobal.dart';
import 'package:http/http.dart' as http;


class NotificationPageController extends GetxController {
  RxList<Notification> list = <Notification>[].obs;
  LoginController loginController = Get.find<LoginController>();

  void getNotifications() async {
    try {
      Uri url = Uri.parse('$httpHomeAutomation/');


      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${loginController.mainUser!.token}'},
      );

      if (response.statusCode == 200) {
        final templist = jsonDecode(response.body);

        for (int i = 0; i < templist.length; i++) {
          list.add(
            Notification(
              title: templist[i]['title'].toString(),
              description: templist[i]['description'].toString(),
              date: templist[i]['date'].toString(),
            ),
          );
        }

        update(list);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

class Notification {
  String title;
  String description;
  String date;

  Notification(
      {required this.title, required this.description, required this.date});
}
