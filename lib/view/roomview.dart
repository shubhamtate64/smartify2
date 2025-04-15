import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/login_screen_controller.dart';
import '../view/baseScreen.dart';
import '../controller/home_screen_room_controller.dart';
import '../model/room_device.dart';
import '../model/room_model.dart';

class RoomView extends StatelessWidget {
  final Room room;
  final HomeController controller = Get.put(HomeController());
  final LoginController loginController = Get.find<LoginController>();

  RoomView({required this.room});

  void toggleDeviceState(String deviceId, String newState) {
    // You can handle validation, backend updates etc. here
    controller.updateDeviceStatus(deviceId as int, newState);
  }

  Widget _buildToggleButton(Device device, String state) {
    final HomeController controller = Get.find<HomeController>();

    return ElevatedButton(
      onPressed: () {
        if (device.status.value != state) {
          controller.toggleDeviceState(device);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: device.status.value == state ? Colors.blue : null,
      ),
      child: Text(
        device.status.value == state
            ? '${state.capitalize!} (Current)'
            : state.capitalize!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Set a fixed height for all containers
    double containerHeight = screenWidth > 800
        ? 250
        : screenWidth > 500
            ? 230
            : 210;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          room.name,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey[300],
      ),
      body: BaseScreen(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => CustomScrollView(
              slivers: [
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth > 800
                          ? 4
                          : screenWidth > 500
                              ? 3
                              : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        Device device = room.devices[index];

                        // Check if the device is a fan
                        if ( device.iconName.toLowerCase() ==  "fan") {  //device.deviceName.toLowerCase() == "fan" &&
                          return GestureDetector(
                            onTap: () {
                              Get.dialog(
                                AlertDialog(
                                  title: Text('${device.deviceName} Speed'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween, // space between buttons
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildToggleButton(device, 'low'),
                                          _buildToggleButton(device, 'medium'),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildToggleButton(device, 'high'),
                                          _buildToggleButton(device, 'off'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: containerHeight,
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    device.icon ?? Icons.device_unknown,
                                    size: 50,
                                    color: Colors.blueAccent,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    device.deviceName,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "Tap to control",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // For non-fan devices, show the normal switch
                          return SizedBox(
                            height:
                                containerHeight, // Fixed height for other device containers
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Ensure minimum space
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        device.icon ?? Icons.device_unknown,
                                        size: screenWidth * 0.15,
                                        color: Colors.black,
                                      ),
                                      Spacer(),
                                      Obx(
                                        () => Switch(
                                          value: device.status.value == "ON",
                                          onChanged: (value) {
                                            controller.toggleDeviceState(
                                                device); // Call function to update API
                                          },
                                          activeColor: Colors.green,
                                          inactiveTrackColor: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    device.deviceName,
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                      childCount: room.devices.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: loginController.mainUser!.role.value == '1' ||
              loginController.mainUser!.role.value == '2'
          ? Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: FloatingActionButton(
                onPressed: () {
                  Get.bottomSheet(
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Add Device',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: controller.deviceController,
                              decoration: InputDecoration(
                                hintText: 'Enter Device name...',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.grey[200],
                                errorText:
                                    controller.deviceNameError.value.isEmpty
                                        ? null
                                        : controller.deviceNameError.value,
                              ),
                              onChanged: (val) {
                                controller.deviceName.value = val;
                                if (val.isNotEmpty) {
                                  controller.deviceNameError.value = '';
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Get.bottomSheet(
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ...controller.deviceRoomIcons.entries
                                            .map(
                                              (entry) => ListTile(
                                                leading: Icon(entry.value,
                                                    color: Colors.blueAccent),
                                                title: Text(entry.key),
                                                onTap: () {
                                                  controller.selectedDeviceType
                                                      .value = entry.key;
                                                  Get.back();
                                                },
                                              ),
                                            )
                                            .toList(),
                                      ],
                                    ),
                                  ),
                                  isScrollControlled: true,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Obx(
                                      ()=> Icon(
                                        controller.deviceRoomIcons[controller
                                                .selectedDeviceType.value] ??
                                            Icons.device_unknown,
                                        color: Colors.blueAccent,
                                        size: 30,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Obx(() {
                                      return Text(
                                        controller.selectedDeviceType.value,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      );
                                    }),
                                    Spacer(),
                                    Icon(Icons.arrow_drop_down,
                                        color: Colors.black),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                controller.addDevice(
                                  controller.deviceController.text,
                                  controller.selectedDeviceType.value,
                                  room,
                                );
                                controller.deviceController.clear();
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(
                                "Create",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    isScrollControlled: true,
                  );
                },
                child: Icon(Icons.add, color: Colors.white),
                backgroundColor: Colors.black,
              ),
            )
          : null,
    );
  }
}
