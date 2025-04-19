import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/room_device.dart'; // For RxList

 // For RxList

class Room {
  String name;
  IconData? icon;
  String type;
  int id;
  final RxList<Device> devices;
  final RxString roomStatus; // ✅ Optional, reactive field

  Room({
    required this.name,
    required this.devices,
    required this.icon,
    required this.type,
    required this.id,
    String? roomStatus, // Optional in constructor
  }) : roomStatus = (roomStatus ?? "").obs; // Default to "Inactive"

  Map<String, dynamic> toJson() {
    return {
      "id": id.toString(),
      'name': name,
      'type': type,
      'icon': icon?.codePoint.toString(),
      'roomStatus': roomStatus.value,
      'roomDeviceList': devices.map((device) => device.toJson()).toList(),
    };
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    Map<String, IconData> roomIcons = {
      'Bedroom': Icons.bed,
      'Kitchen': Icons.kitchen,
      'Hall': Icons.meeting_room,
      'Classroom': Icons.school,
      'Lab': Icons.science,
      'Cabin': Icons.work,
    };

    return Room(
      id: json['id'],
      name: json['roomName'] ?? "",
      type: json['type'] ?? "",
      icon: roomIcons[json['iconName']],
      roomStatus: json['roomStatus'], // Will default to 'Inactive' if null
      devices: (json['deviceList'] as List?)
              ?.map((deviceJson) => Device.fromJson(deviceJson))
              .toList()
              .obs ??
          <Device>[].obs,
    );
  }
}
