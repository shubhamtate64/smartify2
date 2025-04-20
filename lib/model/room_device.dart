import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Device {
  int id;
  String roomId;
  String iconName;
  String relayPin;
  String type;
  IconData? icon;

  RxString deviceName;
  RxString activeFlag;
  RxString status;
  RxBool switchStatus;
  RxList<String> action;

  Device({
    required this.id,
    required this.roomId,
    required this.iconName,
    required String deviceName,
    required this.relayPin,
    required String activeFlag,
    required this.type,
    required this.icon,
    required String status,
    required bool switchStatus,
    required List<String> action,
  })  : deviceName = deviceName.obs,
        activeFlag = activeFlag.obs,
        status = status.obs,
        switchStatus = switchStatus.obs,
        action = action.obs;

  factory Device.fromJson(Map<String, dynamic> json) {
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
      icon: deviceRoomIcons[json['iconName']] ?? Icons.device_unknown,
      status: json['status'] ?? "OFF",
      switchStatus: json['switchStatus'] ?? false,
      action: (json['action'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "roomId": roomId,
      "iconName": iconName,
      "deviceName": deviceName.value,
      "relayPin": relayPin,
      "activeFlag": activeFlag.value,
      "type": type,
      "status": status.value,
      "switchStatus": switchStatus.value,
      "action": action.toList(),
    };
  }
}
