import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/connectivity_service.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  const BaseScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final connectivityService = Get.find<ConnectivityService>();

    return Obx(() {
      final isOffline = !connectivityService.isOnline.value;

      return Stack(
        children: [
          child,

          // 🔴 Offline Overlay
          if (isOffline)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.wifi_off, size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        "No internet connection ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 6),
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
