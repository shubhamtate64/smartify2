// fan_control_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_screen_room_controller.dart';
import '../model/room_device.dart';

class FanControlPage extends StatelessWidget {
  final Device device;
  final HomeController controller = Get.find();

  FanControlPage({required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fan Control"),
        backgroundColor: Colors.grey[300],
      ),
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                device.icon ?? Icons.device_unknown,
                size: 80,
                color: Colors.blueAccent,
              ),
              SizedBox(height: 16),
              Text(
                device.deviceName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['low', 'medium', 'fast'].map((speed) {
                  return ElevatedButton(
                    onPressed: () {
                      controller.updateDeviceStatus(device.id, speed);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: Text(speed.capitalizeFirst!),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
