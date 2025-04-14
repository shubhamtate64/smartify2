import 'package:flutter/material.dart';
import 'package:get/get.dart';  // For RxBool



class Device {
  int id;
  String roomId;
  String iconName;
  String deviceName;
  String relayPin;
  String activeFlag;
  String type;
  IconData? icon;
  RxString status; // Reactive status
  RxBool switchStatus; // Reactive switch state
  RxList<String> action; // Reactive action list

  Device({
    required this.id,
    required this.roomId,
    required this.iconName,
    required this.deviceName,
    required this.relayPin,
    required this.activeFlag,
    required this.type,
    required this.icon,
    required String status,
    required bool switchStatus,
    required List<String> action,
  })  : status = status.obs, // Convert to observable
        switchStatus = switchStatus.obs, // Convert to observable
        action = action.obs; // Convert to observable list

  // Factory method to create Device from JSON
  factory Device.fromJson(Map<String, dynamic> json) {
    // Mapping of icon names to actual Flutter icons
    var deviceRoomIcons = {
      'Light': Icons.lightbulb,
      'Fan': Icons.air,
      'AC': Icons.ac_unit,
      'TV': Icons.tv,
      'PC': Icons.computer,
      'Projector': Icons.video_settings,
    };

    return Device(
      id: json['id'] ?? 0,  
      roomId: json['roomId']?.toString() ?? "", 
      iconName: json['iconName'] ?? "", 
      deviceName: json['deviceName'] ?? "", 
      relayPin: json['relayPin'] ?? "", 
      activeFlag: json['activeFlag'] ?? "N", 
      type: json['type'] ?? "",  
      icon: deviceRoomIcons[json['iconName']], // Map icon name to IconData
      status: json['status'] ?? "OFF", 
      switchStatus: json['switchStatus'] ?? false,  
      action: (json['action'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  // Convert Device object to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "roomId": roomId,
      "iconName": iconName,
      "deviceName": deviceName,
      "relayPin": relayPin,
      "activeFlag": activeFlag,
      "type": type,
      "status": status.value, // Use .value for RxString
      "switchStatus": switchStatus.value, // Use .value for RxBool
      "action": action.toList(), // Convert RxList to normal List
    };
  }
}
