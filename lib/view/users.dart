import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../model/room_device.dart';
import '../model/user_model.dart';
import '../view/home_screen.dart';
import '../controller/home_screen_room_controller.dart';
import '../model/room_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen>
    with RouteAware, SingleTickerProviderStateMixin {
  final HomeController homeController = Get.find<HomeController>();
  late TabController _tabController;

  // @override
  // void initState() {
  //   super.initState();
  //   homeController.getAllUserData(); // Fetch user data when screen loads
  //   _tabController = TabController(
  //       length: 4, vsync: this); // Four tabs: All, Pending, Accepted, Deleted
  // }

  @override
  void initState() {
    super.initState();
    homeController.getAllUserData(); // load initially
    _tabController = TabController(
        length: 4, vsync: this); // Four tabs: All, Pending, Accepted, Deleted
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // 👇 This is the magic:
  @override
  void didPopNext() {
    // Called when coming back from UserDetailScreen
    homeController.getAllUserData();
    debugPrint("🔁 Returned to UserScreen — Rooms reloaded");
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 600 ? 18 : 14;

    return Scaffold(
      appBar: AppBar(
        title: Text("User List"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                "All Users",
                style: TextStyle(fontSize: fontSize), // Adjust font size
              ),
            ),
            Tab(
              child: Text(
                "Pending",
                style: TextStyle(fontSize: fontSize), // Adjust font size
              ),
            ),
            Tab(
              child: Text(
                "Accepted",
                style: TextStyle(fontSize: fontSize), // Adjust font size
              ),
            ),
            Tab(
              child: Text(
                "Deleted",
                style: TextStyle(fontSize: fontSize), // Adjust font size
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return Center(
              child:
                  CircularProgressIndicator()); // Show loader while fetching data
        }

        return TabBarView(
          controller: _tabController,
          children: [
            // Tab for All users
            _buildUserList('All'),

            // Tab for Pending users
            _buildUserList('P'),

            // Tab for Accepted users
            _buildUserList('A'),

            // Tab for Deleted users
            _buildUserList('D'),
          ],
        );
      }),
    );
  }

  // Helper function to build a list of users based on requestStatus or show all users
  Widget _buildUserList(String status) {
    List<UserModel> filteredUsers = (status == 'All')
        ? homeController.users
        : homeController.users.where((user) {
            return user.requestStatus.value == status ||
                user.activeFlag.value == "N";
          }).toList();

    if (filteredUsers.isEmpty) {
      return Center(
          child: Text("No users with status ${_getStatusText(status)}"));
    }

    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return GestureDetector(
            onTap: () {
              if(user.requestStatus.value.toUpperCase() == "A"){
                Get.to(() => UserDetailScreen(user: user));
              }
            },
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // Background black
                // border: Border.all(color: Colors.black, width: 00.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = MediaQuery.of(context).size.width;
                  double baseFontSize = screenWidth * 0.04;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name.value,
                        style: GoogleFonts.aDLaMDisplay(
                          color: Colors.black,
                          fontSize: baseFontSize + 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        user.mobileNo.value,
                        style: GoogleFonts.aDLaMDisplay(
                          color: Colors.black,
                          fontSize: baseFontSize,
                        ),
                      ),
                      Text(
                        user.email.value,
                        style: GoogleFonts.aDLaMDisplay(
                          color: Colors.black,
                          fontSize: baseFontSize,
                        ),
                      ),
                      Text(
                        "Role: ${user.role}",
                        style: GoogleFonts.aDLaMDisplay(
                          color: Colors.black,
                          fontSize: baseFontSize - 1,
                        ),
                      ),
                      Text(
                        "Status: ${_getStatusText(user.requestStatus.value)}",
                        style: GoogleFonts.aDLaMDisplay(
                          color: Colors.orangeAccent,
                          fontSize: baseFontSize - 1,
                        ),
                      ),

                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (user.requestStatus == 'A') ...[
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteUser(user),
                            ),
                            IconButton(
                              icon: Icon(Icons.restore, color: Colors.green),
                              onPressed: () => _restoreUser(user),
                            ),
                          ],
                          if (user.requestStatus == 'P') ...[
                            IconButton(
                              icon: Icon(Icons.check, color: Colors.green),
                              onPressed: () => _acceptUser(user),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteUser(user),
                            ),
                          ],
                          if (user.requestStatus == 'D') ...[
                            IconButton(
                              icon: Icon(Icons.restore, color: Colors.green),
                              onPressed: () => _restoreUser(user),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_forever,
                                  color: Colors.grey),
                              onPressed: () => _permanentlyDeleteUser(user),
                            ),
                          ],
                        ],
                      ),
                    ],
                  );
                },
              ),
            ));
      },
    );
  }

  // Helper function to map request status to a readable string
  String _getStatusText(String status) {
    switch (status) {
      case 'A':
        return 'Accepted';
      case 'P':
        return 'Pending';
      case 'D':
        return 'Deleted';
      default:
        return 'Unknown';
    }
  }

  // Accept user function (change status to 'A')
  void _acceptUser(UserModel user) {
    // Call the function to update the user status to 'A' (Accepted)
    homeController.acceptUser(user.id.value);
  }

  // Delete user function (change status to 'D')
  void _deleteUser(UserModel user) {
    // Call the function to update the user status to 'D' (Deleted)
    homeController.deleteUser(user.id.value); // Delete user when pres
  }

  // Restore user function (change status to 'P' or 'A' if required)
  void _restoreUser(UserModel user) {
    // Call the function to update the user status to 'P' (Pending) or 'A' (Accepted)
    homeController.restoreUser(user.id.value); // Restore user when pressed
  }

  // Permanently delete user function
  void _permanentlyDeleteUser(UserModel user) {
    // Call the function to permanently delete the user
  }
}

class UserDetailScreen extends StatefulWidget {
  final UserModel user;
  const UserDetailScreen({required this.user, Key? key}) : super(key: key);

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name.value),
        // leading: InkWell(
        //     onTap: () async {

        //       await homeController.getAllRoomsData();
        //       Get.back();
        //     },
        //     child: Icon(Icons.arrow_back_rounded)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Info Container
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.user.name.value,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                  SizedBox(height: 5),
                  Text(widget.user.mobileNo.value,
                      style: TextStyle(fontSize: 16, color: Colors.pink)),
                  Text(widget.user.email.value,
                      style: TextStyle(fontSize: 16, color: Colors.pink)),
                ],
              ),
            ),

            // Rooms List
            Obx(() {
              // if (homeController.isLoading.value) {
              //   return Center(child: CircularProgressIndicator());
              // }
              if (homeController.rooms.isEmpty) {
                return Center(child: Text("No Rooms Found"));
              }

              return Column(
                children: homeController.rooms.map((room) {
                  return RoomWidget(
                    room: room,
                    user: widget.user,
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class RoomWidget extends StatelessWidget {
  final Room room;
  final UserModel user;
  RoomWidget({required this.room, required this.user, Key? key})
      : super(key: key);

  void _showEditDialog(BuildContext context) {
    TextEditingController roomController =
        TextEditingController(text: room.name);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: roomController,
                decoration: InputDecoration(labelText: "Room Name"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // TODO: Call API to update room name
                  Navigator.pop(context);
                },
                child: Text("Save"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.yellow, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room Name & Edit Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(room.name,
                  style: TextStyle(fontSize: 18, color: Colors.green)),
              // IconButton(
              //   icon: Icon(Icons.edit),
              //   onPressed: () => _showEditDialog(context),
              // ),
            ],
          ),

          // Device List
          ...room.devices
              .map((device) => DeviceSwitch(
                  device: device, userId: user.id.value, user: user))
              .toList(),
        ],
      ),
    );
  }
}

class DeviceSwitch extends StatefulWidget {
  final Device device;
  final String userId;
  final UserModel user; // User ID

  DeviceSwitch(
      {required this.device,
      required this.userId,
      required this.user,
      Key? key})
      : super(key: key);

  @override
  _DeviceSwitchState createState() => _DeviceSwitchState();
}

class _DeviceSwitchState extends State<DeviceSwitch> {
  bool isDeviceOn = false;

  HomeController homeController =
      Get.find<HomeController>(); // Store previous authorized devices

  @override
  void initState() {
    super.initState();

    // Store the previous authorized devices (comma-separated string)
    homeController.previousDeviceIds.value = widget.user.devices.value;

    // Check if the device ID exists in the user's authorized devices list
    List<String> authorizedDevices =
        homeController.previousDeviceIds.value.split(',');
    if (authorizedDevices.contains(widget.device.id.toString())) {
      setState(() {
        isDeviceOn = true; // Turn switch ON if the device is authorized
      });
    }
  }

  void toggleDevice(bool newState) async {
    setState(() {
      isDeviceOn = newState; // Update UI immediately
    });

    String updatedDeviceIds = homeController.previousDeviceIds.value;
    List<String> deviceList =
        updatedDeviceIds.isNotEmpty ? updatedDeviceIds.split(',') : [];

    if (newState) {
      // If turning ON, add the device ID (if not already present)
      if (!deviceList.contains(widget.device.id.toString())) {
        deviceList.add(widget.device.id.toString());
      }
    } else {
      // If turning OFF, remove the device ID from the list
      deviceList.remove(widget.device.id.toString());
    }

    // Join updated list into a comma-separated string
    updatedDeviceIds = deviceList.join(',');

    // Update observable value in HomeController
    homeController.previousDeviceIds.value = updatedDeviceIds;

    // Call API to update user's authorized devices
    await homeController.updateDeviceStatusUser(
        updatedDeviceIds, widget.userId);
    // await  homeController.getAllUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(widget.device.deviceName,
          style: TextStyle(fontSize: 16, color: Colors.purple)),
      value: isDeviceOn,
      onChanged: toggleDevice,
    );
  }
}
