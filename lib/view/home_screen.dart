import 'dart:async';

import 'package:Smartify/view/DummyWeatherContainer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:animate_do/animate_do.dart';
import '../controller/WeatherController.dart';
import '../controller/home_screen_room_controller.dart';
import '../controller/login_screen_controller.dart';
import '../controller/notification_page_controller.dart';
import '../services/connectivity_service.dart';
import '../view/notification_page.dart';
import '../view/roomview.dart';
import '../view/weather_screen.dart';
import '../view/widgets/my_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with WidgetsBindingObserver, RouteAware {
  final HomeController controller = Get.find<HomeController>();
  final LoginController loginController = Get.put(LoginController());
  final notificationPageController = Get.put(NotificationPageController());
  final ConnectivityService connectivityService =
      Get.find<ConnectivityService>();
  var weatherController;

  final notificationCount = 5.obs;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    weatherController = Get.put(WeatherController());

    // WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllRoomsData();
      // controller.GetDeviceLiveStatus();
    });

    if (loginController.mainUser!.role.value == '1' ||
        loginController.mainUser!.role.value == '2') {
      notificationPageController.getNotifications();
      notificationCount.value = notificationPageController.list.length;
    }

    // ever(connectivityService.isOnline, (bool online) {
    //   if (online) {
    //     _startAutoRefresh();
    //   } else {
    //     _stopAutoRefresh();
    //   }
    // });

    // if (connectivityService.isOnline.value) {
    //   _startAutoRefresh();
    // }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   routeObserver.subscribe(
  //       this, ModalRoute.of(context)!); // Subscribe to route changes
  // }

  // @override
  // void dispose() {
  //   _stopAutoRefresh();
  //   routeObserver.unsubscribe(this); // Unsubscribe
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // // Called when this route becomes visible again
  // @override
  // void didPopNext() {
  //   super.didPopNext();
  //   if (connectivityService.isOnline.value) {
  //     _startAutoRefresh();
  //     debugPrint("Returned to HomePage → timer started");
  //   }
  // }

  // // Called when navigating away from this page
  // @override
  // void didPushNext() {
  //   _stopAutoRefresh();
  //   debugPrint("Navigated away from HomePage → timer stopped");
  // }

  // void _startAutoRefresh() {
  //   _stopAutoRefresh(); // ensure only one timer runs
  //   print("⏱️ Starting timer");
  //   _timer = Timer.periodic(Duration(seconds: 2), (timer) {
  //     if (mounted && connectivityService.isOnline.value) {
  //       controller.GetDeviceLiveStatus();
  //       print("Fetching live status...");
  //     }
  //   });
  // }

  // void _stopAutoRefresh() {
  //   if (_timer != null) {
  //     print("🛑 Stopping timer");
  //     _timer?.cancel();
  //     _timer = null;
  //   }
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.paused) {
  //     _stopAutoRefresh();
  //   } else if (state == AppLifecycleState.resumed) {
  //     if (connectivityService.isOnline.value) {
  //       _startAutoRefresh();
  //     }
  //   }
  // }

  Future<bool> _onWillPop() async {
    bool exit = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[300],
        title: const Text("Exit App"),
        content: const Text("Do you want to exit the app?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );
    return exit;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double iconSize = MediaQuery.of(context).size.width * 0.07;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: MyDrawer(),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Obx(() => CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.grey[300],
                  floating: false,
                  pinned: true,
                  snap: false,
                  expandedHeight: MediaQuery.of(context).size.height * 0.15,
                  actions: [
                    Obx(() {
                      if (loginController.mainUser!.role.value == '1' ||
                          loginController.mainUser!.role.value == '2') {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: GestureDetector(
                            onTap: () => Get.to(() => NotificationPage()),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(Icons.notifications, size: iconSize),
                                if (notificationCount.value > 0)
                                  Positioned(
                                    right: -2,
                                    top: -2,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: BoxConstraints(
                                          minWidth: 20, minHeight: 20),
                                      child: Text(
                                        notificationCount.value > 99
                                            ? '99+'
                                            : '${notificationCount.value}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: iconSize * 0.3,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
                  ],
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      double opacity =
                          (constraints.biggest.height - kToolbarHeight) /
                              (MediaQuery.of(context).size.height * 0.18 -
                                  kToolbarHeight);
                      return Stack(
                        children: [
                          FlexibleSpaceBar(
                            titlePadding: EdgeInsets.only(left: 50, bottom: 16),
                            title: Opacity(
                              opacity: 1 - opacity.clamp(0.0, 1.0),
                              child: Text(
                                "${loginController.mainUser!.firstName.trim()},",
                                style: GoogleFonts.poppins(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: screenWidth *
                                      0.05, // Responsive font size
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            background: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, bottom: 16),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "Welcome,\n${loginController.mainUser!.firstName}  👋",
                                  style: GoogleFonts.aDLaMDisplay(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: screenWidth *
                                        0.06, // Responsive font size
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
SliverToBoxAdapter(
  child: Obx(() {
    if (!weatherController.permissionGranted.value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, color: Colors.red, size: 60),
            SizedBox(height: 16),
            Text(
              "Location is turned off",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Please enable location to view weather info.",
              style: TextStyle(color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Geolocator.openLocationSettings(); // opens device location settings
              },
              icon: Icon(Icons.settings),
              label: Text("Enable Location"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            TextButton(
              onPressed: weatherController.retry,
              child: Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (weatherController.isLoading.value) {

      return DummyWeatherContainer();
      // return SizedBox(
      //   height: 180,
      //   child: Center(
      //     child: CircularProgressIndicator(
      //       valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      //     ),
      //   ),
      // );
    }

    final data = weatherController.weatherData.value;
    if (data == null) return SizedBox();

    double screenWidth = MediaQuery.of(context).size.width;

    return FadeInUp(
      duration: Duration(seconds: 1),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          height: 180,
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top row - Condition & Temperature
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.cloud,
                        color: data.condition.contains("Rain")
                            ? Colors.blue
                            : Colors.white,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        data.condition,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    data.temperature,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WeatherInfo(label: 'Sensible', value: data.sensible),
                  WeatherInfo(label: 'Precip.', value: data.precipitation),
                  WeatherInfo(label: 'Humidity', value: data.humidity),
                  WeatherInfo(label: 'Wind', value: data.wind),
                ],
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  data.city,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: screenWidth * 0.035,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }),
),



SliverPadding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  sliver: controller.rooms.isEmpty
      ? SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No rooms available',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        )
      : SliverGrid(
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
              return GestureDetector(
                onTap: () {
                  Get.to(() => RoomView(room: controller.rooms[index]));
                },
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        controller.rooms[index].icon,
                        size: screenWidth * 0.15,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        controller.rooms[index].name,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        softWrap: true,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Devices ${controller.rooms[index].devices.length}",
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
            childCount: controller.rooms.length,
          ),
        ),
),

              ],
            )),
      ),
      floatingActionButton: loginController.mainUser!.role.value == '1' ||
              loginController.mainUser!.role.value == '2'
          ? FloatingActionButton(
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
                          Text('Add Room',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          TextField(
                            controller: controller.roomController,
                            decoration: InputDecoration(
                              hintText: 'Enter room name...',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey[200],
                              errorText: controller.roomNameError.value.isEmpty
                                  ? null
                                  : controller
                                      .roomNameError.value, // Show error
                            ),
                            onChanged: (val) {
                              controller.roomName.value = val;
                              // Clear error when user starts typing
                              if (val.isNotEmpty) {
                                controller.roomNameError.value = '';
                              }
                            },
                          ),
                          SizedBox(height: 10),
                          // Dropdown for selecting room type
                          // Room Type Dropdown
                          GestureDetector(
                            onTap: () {
                              // Show bottom sheet to select room type
                              Get.bottomSheet(
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Iterate over the room icons and room types
                                      ...controller.roomIcons.entries
                                          .map(
                                            (entry) => ListTile(
                                              leading: Icon(
                                                entry.value,
                                                color: Colors.blueAccent,
                                              ),
                                              title: Text(entry.key),
                                              onTap: () {
                                                // Update selected room type reactively
                                                controller.selectedRoomType
                                                    .value = entry.key;
                                                Get.back(); // Close bottom sheet
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
                                  // Show selected room icon based on the selected room type
                                  Obx(
                                    () => Icon(
                                      controller.roomIcons[
                                          controller.selectedRoomType.value],
                                      color: Colors.blueAccent,
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Obx(() {
                                    return Text(
                                      controller.selectedRoomType
                                          .value, // Reactive text
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    );
                                  }),

                                  Spacer(),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          if(controller.roomTypeError.isEmpty)
                                  Obx(()=> Text(controller.roomTypeError.value)),


                          SizedBox(height: 10),

                          ElevatedButton(
                            onPressed: () {
                              // Add room with selected type and name
                              controller.addRoom(
                                controller.roomController.text,
                                controller.selectedRoomType
                                    .value, // Use selected room type
                              );
                              controller.selectedRoomType.value =
                                  'Select Room type';
                              controller.roomController.clear();
                              Get.back(); // Close the bottom sheet
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Create",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  isScrollControlled: true,
                );
              },
              backgroundColor: Colors.black,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
