import 'package:Smartify/controller/home_screen_room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/connectivity_service.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  const BaseScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final connectivityService = Get.find<ConnectivityService>();
    final homeController = Get.find<HomeController>();

    return Obx(() {
      final isOffline = !connectivityService.isOnline.value;

      // Check if rooms list is not empty and get statusRoom
      final hasRooms = homeController.rooms.isNotEmpty;
      final isRoomOffline = hasRooms
          ? homeController.rooms[0].roomStatus.value.toLowerCase() ==  "offline"//"offline"
          : false;

      final shouldShowOverlay = isOffline || isRoomOffline;

      // Choose icon based on condition
      IconData overlayIcon;
      if (isOffline && isRoomOffline) {
        overlayIcon = Icons.error_outline;
      } else if (isOffline) {
        overlayIcon = Icons.signal_wifi_connected_no_internet_4;
      } else {
        overlayIcon = Icons.power_off;
      }

      // Choose message
      String overlayMessage;
      if (isOffline && isRoomOffline) {
        overlayMessage = "Internet & Device both are offline";
      } else if (isOffline) {
        overlayMessage = "No internet connection";
      } else {
        overlayMessage = "Device is offline";
      }

      return Stack(
        children: [
          child,

          if (shouldShowOverlay)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(overlayIcon, size: 50, color: Colors.white),
                      const SizedBox(height: 10),
                      Text(
                        overlayMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
