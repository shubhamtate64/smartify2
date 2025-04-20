import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Smartify/controller/home_screen_room_controller.dart';
import 'package:Smartify/model/room_device.dart';

class FanSpeedControl extends StatelessWidget {
  final Device device;

  const FanSpeedControl({required this.device, Key? key}) : super(key: key);

  @override
Widget build(BuildContext context) {
  final HomeController controller = Get.find<HomeController>();
  final List<String> fanSpeeds = device.action;

  return Obx(() {
    final currentSpeed = controller.fanTempSpeed.value.isNotEmpty
        ? controller.fanTempSpeed.value
        : device.status.value;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: fanSpeeds.map((speed) {
        final bool isSelected = currentSpeed == speed;

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isSelected ? Colors.blueAccent : Colors.grey[300],
            foregroundColor: isSelected ? Colors.white : Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            if (!isSelected) {
              controller.updateFanState(device, speed);
            }
          },
          child: Text(
            isSelected
                ? '${speed.split('_').last.capitalize!} (Current)'
                : speed.split('_').last.capitalize!,
            style: const TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
    );
  });
}

}
