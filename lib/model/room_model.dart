import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/room_device.dart'; // For RxList

class Room {
  String name;
  IconData? icon;
  String type;
  int id;
  final RxList<Device> devices;

 


  Room({
    required this.name,
    required this.devices,
    required this.icon,
    required this.type,
    required this.id
  });

  // Convert the Room model to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id.toString(),
      'name': name,
      'type': type,
      'icon': icon?.codePoint.toString(), // Convert IconData to String (codePoint)
      'roomDeviceList': devices.map((device) => device.toJson()).toList(),
    };
  }

  // Optionally, you can create a factory method if needed for easy instantiation from JSON
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
    id: json['id'] ,  // Convert safely
    name: json['roomName'] ?? "", // Default to empty string if null
    type: json['type'] ?? "", // Ensure type isn't null
    icon: roomIcons[json['iconName']], // Default icon
    devices: (json['deviceList'] as List?)
        ?.map((deviceJson) => Device.fromJson(deviceJson))
        .toList()
        .obs ?? <Device>[].obs, // Ensure RxList is not null
  );
}

}