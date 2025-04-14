import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../controller/notification_page_controller.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationPageController controller =
        Get.find<NotificationPageController>();

    // controller.getNotifications();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.list.length,
          itemBuilder: (context, index) {
            return getSingleContainer(
              controller.list[index].title,
              controller.list[index].description,
              controller.list[index].date,
              index + 1,
            );
          },
        ),
      ),
    );
  }

  final List<Color> colorsList = [
    Color(int.parse("0xFFFAE8E8")),
    Color(int.parse("0xFFE8EDFA")),
    Color(int.parse("0xFFFAF9E8")),
    Color(int.parse("0xFFFAE8FA")),
  ];

  String datetime(String dateString) {
    DateTime dt = DateTime.parse(dateString);

    return DateFormat('dd/MM/yyyy').format(dt.add(const Duration(days: 1)));
  }

  String datetime2(String date) {
    DateTime dt = DateTime.parse(date);
    DateTime result = dt.add(const Duration(days: 1));

    return DateFormat('hh:mm a').format(result);
  }

  Widget getSingleContainer(
      String title, String description, String date, int index) {
    return GestureDetector(
      onTap: () {
        Get.defaultDialog(
            title: title,
            backgroundColor: colorsList[index % 4],
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      datetime(date),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: colorsList[index % 4],
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ),
        height: 100,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  datetime2(date) + " " + datetime(date),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
