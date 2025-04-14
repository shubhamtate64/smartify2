import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/room_device.dart';
import '../controller/home_screen_room_controller.dart';

class CustomRadioTile extends StatelessWidget {
  final String title;
  final String value;
  final String groupValue;
  final Function(String) onChanged;
  final Color selectedColor;

  CustomRadioTile({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(value);  // When tapped, update the state
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: groupValue == value ? selectedColor.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // Radio Button
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: groupValue == value ? selectedColor : Colors.grey, 
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 10,
                backgroundColor: groupValue == value ? selectedColor : Colors.transparent,
              ),
            ),
            SizedBox(width: 10),
            // Text
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class FanControlScreen extends StatelessWidget {
  final Device device;
  final HomeController controller = Get.find<HomeController>();

  FanControlScreen({required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${device.deviceName} Control")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(device.icon ?? Icons.device_unknown, size: 100, color: Colors.blueAccent),
            SizedBox(height: 20),
            Text(
              "Select Fan Speed",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Fan Speed Options (Using Custom Radio Tile)
            Obx(
              () => Column(
                children: device.action.map((action) {
                  return CustomRadioTile(
                    title: action.toUpperCase().replaceRange(0,5,""),
                    value: action,
                    groupValue: device.status.value,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        controller.updateDeviceStatus(device.id, newValue); // Update the fan speed
                      }
                    },
                    selectedColor: Colors.blueAccent, // Set selected color here
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
