import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _subscription;
  RxBool isOnline = true.obs;

  // Track previous state to avoid repeating snackbars
  bool _previousStatus = true;
  Timer? _debounceTimer;

  Future<ConnectivityService> init() async {
    try {
      // Initial connectivity check
      final result = await _connectivity.checkConnectivity();
      _updateStatus(result);
    } catch (e) {
      _updateStatus(ConnectivityResult.none);
    }

    // Listen for connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);

    return this;
  }

  // Handle connectivity change with throttling to avoid multiple snackbars
  void _handleConnectivityChange(ConnectivityResult result) {
    // If there is an active timer, cancel it
    _debounceTimer?.cancel();

    // Set a new debounce timer for 500ms to avoid rapid changes
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _updateStatus(result);
    });
  }

  void _updateStatus(ConnectivityResult result) {
    final currentStatus = result != ConnectivityResult.none;

    // Only show snackbar if the status has changed
    if (currentStatus != _previousStatus) {
      _showSnackBar(
        currentStatus ? "Connected to internet" : "No internet connection",
        currentStatus,
      );
      _previousStatus = currentStatus;
    }

    // Update the online status observable
    isOnline.value = currentStatus;
  }

  void _showSnackBar(String message, bool isConnected) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure the snackbar isn't already open
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          "Connection Status",
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: isConnected ? Colors.green : Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(12),
        );
      }
    });
  }

  @override
  void onClose() {
    // Cancel subscription and debounce timer when the service is closed
    _subscription.cancel();
    _debounceTimer?.cancel();
    super.onClose();
  }
}
