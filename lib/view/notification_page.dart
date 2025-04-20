import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart'; // ✅ Added

import '../controller/notification_page_controller.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});

  final List<Color> colorsList = [
    const Color(0xFFFAE8E8),
    const Color(0xFFE8EDFA),
    const Color(0xFFFAF9E8),
    const Color(0xFFFAE8FA),
  ];

  String datetime(String dateString) {
    try {
      DateTime dt = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(dt.toLocal());
    } catch (e) {
      log("Error parsing date: $e");
      return "Invalid date";
    }
  }

  String datetime2(String? dateStr) {
    try {
      if (dateStr == null || dateStr.isEmpty) return 'Invalid Date';
      final parsedDate = DateTime.tryParse(dateStr);
      if (parsedDate == null) return 'Invalid Date';
      return DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    NotificationPageController controller = Get.find<NotificationPageController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double baseFont = screenWidth > 600 ? 20 : 16;
        double padding = screenWidth * 0.05;

        return Scaffold(
          backgroundColor:  Colors.grey[300],
          appBar: AppBar(
            title: Text(
              "Notifications",
              style: GoogleFonts.aDLaMDisplayTextTheme().titleLarge?.copyWith( // Use headline6 or another appropriate style
                fontWeight: FontWeight.w700,
                fontSize: baseFont + 2,
                color: Colors.black, // ✅ Set text color to black
              ),
            ),
          ),
          body: Obx(() {
            if (controller.list.isEmpty) {
              return Center(
                child: Text(
                  "No notifications available.",
                  style: GoogleFonts.aDLaMDisplayTextTheme().bodyLarge?.copyWith( // Use bodyText1 or another appropriate style
                    fontSize: baseFont,
                    fontWeight: FontWeight.w500,
                    color: Colors.black, // ✅ Set text color to black
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: controller.list.length,
              itemBuilder: (context, index) {
                return getSingleContainer(
                  controller.list[index].title,
                  controller.list[index].description,
                  controller.list[index].date,
                  index + 1,
                  padding,
                  baseFont,
                );
              },
            );
          }),
        );
      },
    );
  }

  Widget getSingleContainer(
    String title,
    String description,
    String date,
    int index,
    double padding,
    double fontSize,
  ) {
    return GestureDetector(
      onTap: () {
        Get.defaultDialog(
          title: title,
          backgroundColor: colorsList[index % 4],
          titleStyle: GoogleFonts.aDLaMDisplayTextTheme().titleLarge?.copyWith( // Use headline6 or another appropriate style
            fontWeight: FontWeight.bold,
            fontSize: fontSize + 2,
            color: Colors.black, // ✅ Set text color to black
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  description,
                  style: GoogleFonts.aDLaMDisplayTextTheme().bodyLarge?.copyWith( // Use bodyText1 or another appropriate style
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.black, // ✅ Set text color to black
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    datetime(date),
                    style: GoogleFonts.aDLaMDisplayTextTheme().bodyLarge?.copyWith( // Use bodyText1 or another appropriate style
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black, // ✅ Set text color to black
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: padding, vertical: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white, // ✅ White color for the container
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ),
        constraints: const BoxConstraints(minHeight: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 4,
              children: [
                Text(
                  title,
                  style: GoogleFonts.aDLaMDisplayTextTheme().titleLarge?.copyWith( // Use headline6 or another appropriate style
                    fontSize: fontSize + 2,
                    fontWeight: FontWeight.w800,
                    color: Colors.black, // ✅ Set text color to black
                  ),
                ),
                Text(
                  "${datetime2(date)} ${datetime(date)}",
                  style: GoogleFonts.aDLaMDisplayTextTheme().bodyLarge?.copyWith( // Use bodyText1 or another appropriate style
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    color: Colors.black, // ✅ Set text color to black
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: GoogleFonts.aDLaMDisplayTextTheme().bodyLarge?.copyWith( // Use bodyText1 or another appropriate style
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: Colors.black, // ✅ Set text color to black
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
