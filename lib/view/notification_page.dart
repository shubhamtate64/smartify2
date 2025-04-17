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
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "Notifications",
              style: GoogleFonts.poppins( // ✅ Updated
                fontWeight: FontWeight.w700,
                fontSize: baseFont + 2,
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
                  padding,
                  baseFont,
                );
              },
            ),
          ),
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
          titleStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: fontSize + 2,
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  description,
                  style: GoogleFonts.poppins( // ✅ Updated
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    datetime(date),
                    style: GoogleFonts.poppins( // ✅ Updated
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
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
          color: colorsList[index % 4],
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
                  style: GoogleFonts.poppins( // ✅ Updated
                    fontSize: fontSize + 2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  "${datetime2(date)} ${datetime(date)}",
                  style: GoogleFonts.poppins( // ✅ Updated
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: GoogleFonts.poppins( // ✅ Updated
                fontSize: fontSize,
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
