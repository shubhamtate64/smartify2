import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;





import 'package:Smartify/services/connectivity_service.dart';
import 'package:get/get.dart';
import '../controller/login_screen_controller.dart';

import '../httplocalhost/httpglobal.dart';
import '../model/room_device.dart';
import '../model/room_model.dart';

// class HomeScreenRoomController extends GetxController{

//   final List home_screen_rooms = [].obs;

// }

import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../services/home_rooms_apiservice.dart';
import 'package:http/http.dart' as http;



class HomeController extends GetxController {

  
  var rooms = <Room>[].obs;
  var users = <UserModel>[].obs;
  var selectedRoomType = 'Select Room type'.obs; // Default selected type
  TextEditingController roomController = TextEditingController();
  final TextEditingController deviceController = TextEditingController();
  var userName = ''.obs;
  RxString roomName = ''.obs; // Reactive variable for room name
  RxString roomNameError = ''.obs;
  RxString roomTypeError = "".obs;
  RxString deviceName = ''.obs; // Reactive variable for room name
  RxString deviceNameError = ''.obs; 
  var selectedDeviceType = 'Light'.obs; 
  var isLoading = false.obs;   
  var previousDeviceIds =''.obs; 
   Timer? timer;  // Loading state// Reactive variable for room name error
  LoginController loginController = Get.find<LoginController>();

  var isSwitchOnOFF = false.obs;
   var fanTempSpeed = ''.obs;

// In your controller
var tempSwitchStatus = RxMap<int, bool>(); // device.id -> ON/OFF

  // Define room types and their corresponding icons
  Map<String, IconData> roomIcons = {
    'Bedroom': Icons.bed,
    'Kitchen': Icons.kitchen,
    'Hall': Icons.meeting_room,
    'Classroom': Icons.school,
    'Lab': Icons.science,
    'Cabin': Icons.work,
  };

  // Default selected device type (this will be updated based on user's choice)
  

  // Room device icons
  var deviceRoomIcons = {
    'Light': Icons.lightbulb,
    'Fan': Icons.air,
    'AC': Icons.ac_unit,
    'TV': Icons.tv,
    'PC': Icons.computer,
    'Projector': Icons.video_settings,
  };


  final HomeRoomsApiservice apiService = Get.put(HomeRoomsApiservice());

  
   
// @override
//   void onInit() {
//     super.onInit();
//     getAllRoomsData();
    
//     // // Call the function every second
//     // timer = Timer.periodic(Duration(seconds: 1), (timer) {
//     //    GetDeviceLiveStatus(); // Call the API every second
//     // });
//   }

//   @override
//   void onClose() {
   
//     // Cancel the timer when the page is closed
//     timer?.cancel();
//      super.onClose();

//   }

  Future<void> getAllRoomsData() async {

    final isOnline = Get.find<ConnectivityService>().isOnline.value;

  if (!isOnline) {
    Get.snackbar(
      "No Internet",
      "Please check your internet connection",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    return ;
  }

    log("getAllRooms");
  try {
     isLoading(true);      // Loading state
     final response = await http.get(
    Uri.parse('$httpHomeAutomation/MstRoomController/getAll'),
    headers: {
      "Authorization": "Bearer ${loginController.mainUser!.token}",
      "Content-Type": "application/json",
    },
  );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      // 🛑 Check if jsonResponse is null or empty
      if (jsonResponse.isEmpty) {
        // Get.snackbar("Error", "Empty response from server");
        return;
      }

      // ✅ Correct way to parse JSON to RxList
      rooms.value = jsonResponse.map((room) {
        try {
          return Room.fromJson(room);
        } catch (e) {
          print("Error parsing room: $e");
          return null; // Handle unexpected room structure
        }
      }).whereType<Room>().toList();
    } else {
      Get.snackbar("Error", "Failed to load rooms: ${response.statusCode}");
    }
  } catch (e) {
    Get.snackbar("Error", "Exception: $e");
 }finally{
    isLoading(false);
  }
}


 Future<void> getAllUserData() async {
  try {
    isLoading(true);      // Loading state
    final response = await http.get(
      Uri.parse('$httpHomeAutomation/EndUserController/getAll?userType=ALL'),
      headers: {
        "Authorization": "Bearer ${loginController.mainUser!.token}",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      log(jsonResponse.toString());

      if (jsonResponse.isEmpty) {
        // Get.snackbar("Error", "Empty response from server");
        return;
      }

      // ✅ Correct JSON parsing to UserModel list
      users.value = jsonResponse.map((user) {
        try {
          return UserModel.fromJson(user); // Fix: Correct factory method
        } catch (e) {
          print("Error parsing user: $e");
          return null; // Return null for bad data
        }
      }).where((user) => user != null).cast<UserModel>().toList(); // Filter nulls

    } else {
      Get.snackbar("Error", "Failed to load users: ${response.statusCode}");
    }
  } catch (e) {
    Get.snackbar("Error", "Exception: $e");
  }finally{
    isLoading(false);
  }
}
Future<void> GetDeviceLiveStatus() async {
  try {
    isLoading(true); // Loading state
    final response = await http.get(
      Uri.parse('$httpHomeAutomation/MstRoomController/getAllStatus'),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      log("$jsonResponse");

      if (jsonResponse.isEmpty) {
        Get.snackbar("Error", "Empty response from server");
        return;
      }

      // ✅ Match device status with rooms based on room ID
      for (var roomStatus in jsonResponse) {
        try {
          int roomId = roomStatus['id']; // Get the roomId
          
          Room? room = rooms.firstWhere((room) => room.id == roomId,);
          room.roomStatus.value = roomStatus["status"];
          log(room.roomStatus.value);

          // Loop through the room's deviceList and update the device status
          for (var deviceStatus in roomStatus['deviceStatusList']) {
            Device? device = room.devices.firstWhere(
                (device) => device.id == deviceStatus['id'],
                );

            // Update device status
            device.status.value = deviceStatus['status'];
            

            log("${device.status.value}");
            update();
            refresh();
                      }
                } catch (e) {
          print("Error processing device status for room: $e");
        }
      }
    } else {
      Get.snackbar("Error", "Failed to load device status: ${response.statusCode}");
    }
  } catch (e) {
    // Get.snackbar("Error", "Exception: $e");
  } finally {
    isLoading(false);
  }
}


  Future<void> updateDeviceStatusUser(String updatedDeviceIds,String userId) async {
    final url = Uri.parse('$httpHomeAutomation/EndUserController/CreateEndUser'); // API URL
    
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": userId, // User ID (not device ID)
        "devices": updatedDeviceIds, // Updated list of authorized devices
        "activeFlag": "Y",
      }),
    );

    if (response.statusCode == 200) {
      log("Device list updated successfully: $updatedDeviceIds");
     
        previousDeviceIds.value = updatedDeviceIds; // Update stored device list
    
    } else {
      log("Failed to update device list. Status Code: ${response.statusCode}");
      log("$userId,$updatedDeviceIds");
    }
    
  }

// Function to accept user (API: CreateEndUser)
Future<void> acceptUser(String userId) async {
  isLoading.value = true;
  try {
    final response = await http.post(
      Uri.parse('$httpHomeAutomation/EndUserController/CreateEndUser'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'id': userId.toString(),
        "requestStatus": 'A',
        "activeFlag": "Y" // Accept status
      }),
    );
    if (response.statusCode == 208) {
      // Handle response if necessary
      print("User accepted");
      await getAllUserData(); // Reload user data after accepting
      // Show green Snackbar for successful user acceptance
      Get.snackbar(
        'Success',
        'User accepted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to accept user',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      log(response.body); // Optionally log the error details
    }
  } catch (e) {
    print(e);
    Get.snackbar(
      'Error',
      'Failed to accept user. Please try again.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  } finally {
    isLoading.value = false;
  }
}

// Function to delete user (API: CreateEndUser)
Future<void> deleteUser(String userId) async {
  isLoading.value = true;
  try {
    final response = await http.post(
      Uri.parse('$httpHomeAutomation/EndUserController/CreateEndUser'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'id': userId.toString(),
        "requestStatus": "D",
        "activeFlag": "N", // Delete status
      }),
    );
    if (response.statusCode == 208) {
      // Handle response if necessary
      print("User deleted");
      await getAllUserData(); // Reload user data after deleting
      // Show green Snackbar for successful user deletion
      Get.snackbar(
        'Success',
        'User deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } else {
      log(response.statusCode.toString());
      log(response.body);
      Get.snackbar(
        'Error',
        'Failed to delete user',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  } catch (e) {
    print(e);
    Get.snackbar(
      'Error',
      'Failed to delete user. Please try again.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  } finally {
    isLoading.value = false;
  }
}



  /// Function to move user to pending (API: CreateEnd)
Future<void> pendingUser(String userId) async {
  isLoading.value = true;
  try {
    final response = await http.post(
      Uri.parse('$httpHomeAutomation/EndUserController/CreateEndUser'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'id': userId.toString(),
        "requestStatus": 'P',  // Pending status
        "activeFlag": "Y"      // Ensure user is active
      }),
    );
    if (response.statusCode == 208) {
      // If successful, show success Snackbar
      print("User set to pending");
      await getAllUserData();  // Reload user data after setting to pending
      Get.snackbar(
        'Success',
        'User moved to Pending',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } else {
      // Handle error response and show error Snackbar
      throw Exception('Failed to set user to pending');
    }
  } catch (e) {
    print(e);
    Get.snackbar(
      'Error',
      'Failed to move user to pending. Please try again.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  } finally {
    isLoading.value = false;
  }
}


  
// Function to restore a user (API: Restore)
Future<void> restoreUser(String userId) async {
  isLoading.value = true;
  try {
    final response = await http.post(
      Uri.parse('$httpHomeAutomation/EndUserController/CreateEndUser'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'id': userId,
        "requestStatus": 'P',  // Pending status
        "activeFlag": "Y"      // Restore to active state
      }),
    );
    if (response.statusCode == 208) {
      // If successful, show success Snackbar
      print("User restored");
      await getAllUserData();  // Reload user data after restoring
      Get.snackbar(
        'Success',
        'User restored successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } else {
      // Handle error response and show error Snackbar
      throw Exception('Failed to restore user');
    }
  } catch (e) {
    print(e);
    Get.snackbar(
      'Error',
      'Failed to restore user. Please try again.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  } finally {
    isLoading.value = false;
  }
}






  

  // Method to add a room
  Future<void> addRoom(String roomName, String roomType) async {
  // Validate room name
  if (roomName.trim().isEmpty && roomType.trim().isEmpty) {
    roomNameError.value = 'Room name cannot be empty';
    roomTypeError.value = 'roomType cannot be empty';
  } else {
    roomNameError.value = '';
    roomTypeError.value ="";


    var random = Random();
  int min = 100;
  int max = 500;
  
  int randomNumber = min + random.nextInt(max - min);

    // Create room
    
    
    final newRoom = Room(
      id:randomNumber,
      name: roomName,
      type: roomType,
      icon: roomIcons[roomType]!,
      devices: RxList.empty(growable: true),
    );

    // Add to local list
    //  bool  val = await sendRoomToServer(newRoom, roomType);
      bool  val = true;
     
     if(val) {
       rooms.add(newRoom);
     }

    // 🔁 Send this single room to the server
    
  }
}
Future<bool> sendRoomToServer(Room room, String roomType) async {
  try {
    final response = await http.post(
      Uri.parse('$httpHomeAutomation/MstRoomController/save'),
      headers: {
        // "Authorization": "Bearer ${loginController.mainUser!.token}",
        "Content-Type": "application/json",
      }, // Your API
     
      body: jsonEncode({
        // "id": room.id,
        "roomName": room.name,
        // "type": room.type,
        "iconName": roomType,
        // "devices": [],
        "activeFlag":"Y" // Optional: send devices if needed
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar("Room Added", "Successfully",
        backgroundColor: Colors.green, colorText: Colors.white);
        return true;
    } else {
      log(response.statusCode.toString());
      Get.snackbar("Error", "Failed to send room: ${response.statusCode}",
        backgroundColor: Colors.red, colorText: Colors.white);
        return false;
    }
  } catch (e) {
    Get.snackbar("Error", "Something went wrong: $e",
      backgroundColor: Colors.red, colorText: Colors.white);
      return false;
  }
}



  Future<void> addDevice(String deviceName, String deviceType, Room room) async {
  if (deviceName.trim().isEmpty) {
    deviceNameError.value = 'Device name cannot be empty';
    return;
  } else {
    deviceNameError.value = '';
  }

  final newDevice = Device(
  id: DateTime.now().millisecondsSinceEpoch, // int
  roomId: room.id.toString(),
  iconName: deviceType,
  deviceName: deviceName.trim(),
  relayPin: "", // If you're not using a relayPin, leave it empty or default
  activeFlag: "Y",
  type: deviceType,
  icon: deviceRoomIcons[deviceType],
  status: "OFF",
  switchStatus: false,
  action: <String>[].obs,
);


  // final bool isSuccess = await sendDeviceToServer(newDevice);
  final bool isSuccess = true;

  if (isSuccess) {
    room.devices.add(newDevice);
    deviceController.clear();

    Get.snackbar(
      "Success",
      "Device added successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
  // } else {
  //   Get.snackbar(
  //     "Error",
  //     "Failed to add device",
  //     backgroundColor: Colors.red,
  //     colorText: Colors.white,
  //   );
  // }
}

Future<bool> sendDeviceToServer(Device device) async {
  try {
    final response = await http.post(
      Uri.parse('$httpHomeAutomation/MstDeviceController/save'),
      headers: {
        "Content-Type": "application/json",
        // "Authorization": "Bearer ${loginController.mainUser?.token}", // Optional
      },
      body: jsonEncode({
        // "id": device.id.toString(), // Send temp local ID or keep it null if auto-generated
        "roomId": device.roomId,
        "iconName": device.type,
        "relayPin": "", // Optional field
        "deviceName": device.deviceName,
        "activeFlag": "Y",
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      log("❌ Add Device Failed: ${response.statusCode} - ${response.body}");
      return false;
    }
  } catch (e) {
    log("❌ Add Device Exception: $e");
    return false;
  }
}



  // // Toggle the switch for a device (turn it on/off)
  // void toggleDeviceState(Device device, bool value) {
  //   // Update the device's switch status
  //   device.switchStatus.value = value;
  //   log("on=off");
  //   // This will trigger a UI update in the RoomView widget.
  //   update();  // Update UI
  // }



 // Logout function
  void logout() async {
    try {
     
      Get.snackbar("Success", "Login successful", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
      Get.offAllNamed('/login');  // Navigate to login screen
    } catch (e) {
      Get.snackbar("Error", "Logout failed: ${e.toString()}",backgroundColor: Colors.red);
    }
  }



void toggleDeviceState(Device device) async {
  // Get current state from temp or fallback to actual status
  final currentStatus = tempSwitchStatus[device.id] ?? (device.status.value == "ON");

  // Determine action based on current status
  String actionCommand = currentStatus ? device.action[1] : device.action[0];

  bool success = await updateDeviceStatus(device.id, actionCommand);

  if (success) {
    // Toggle status
    final newStatus = !currentStatus;

    // Update temporary override
    tempSwitchStatus[device.id] = newStatus;

    // Update actual device (optional if using only temp in UI)
    device.status.value = newStatus ? "ON" : "OFF";

    update(); // Notify listeners
  } else {
    Get.snackbar(
      "Error",
      "Failed to update device",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}


Future<bool> updateDeviceStatus(int deviceId, String actionCommand) async {

  try {
    final response = await http.post(
      Uri.parse('$httpHomeAutomation/MstDeviceController/updateHardware'),
      body: jsonEncode({
         "id": deviceId,
        "action": actionCommand,
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      log("$actionCommand");
      log("${response.body}");
      return true; // API call successful
    } else {
      return false; // API call failed
    }
  } catch (e) {
    print("Error updating device status: $e");
    return false;
  }
}
void updateFanState(Device device, String newState) async {
  // log("Updating fan state for device: ${device.deviceName}");
  // log("Old Status: ${device.status.value}");
  // log("New Status: $newState");

  bool success = await updateDeviceStatus(device.id, newState);

  if (success) {
    
    device.status.value = newState;
        fanTempSpeed.value = newState;
    
    // log("Status after update: ${device.status.value}");

    // Optional if using Obx: update(); refresh(); not needed usually
  } else {
    Get.snackbar(
      "Error", 
      "Failed to update fan state",
      backgroundColor: Colors.red, 
      colorText: Colors.white
    );
  }
}



// void toggleSwitch(Device device,bool value){

//     if(device.status.value.contains("on")){
//        isOnOFF.value =  value;
//     }else{
//       isOnOFF.value = value;
//     }

//     update();
//     refresh();

//   }


}
