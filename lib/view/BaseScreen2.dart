import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/connectivity_service.dart';

class BaseScreen2 extends StatelessWidget {
  final Widget child;
  const BaseScreen2({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final connectivityService = Get.find<ConnectivityService>();

    return Obx(() {
      final isOffline = !connectivityService.isOnline.value;

      return Stack(
        children: [
          child,

          if (isOffline)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.signal_wifi_connected_no_internet_4,
                          size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        "No internet connection",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
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
