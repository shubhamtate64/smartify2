import 'dart:async';

import 'package:Smartify/controller/WeatherController.dart';
import 'package:Smartify/firebase_options.dart';
import 'package:Smartify/view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/login_screen_controller.dart';
import '../controller/registration_controller.dart';
import '../view/login_screen.dart';

import 'controller/home_screen_room_controller.dart';

import 'services/connectivity_service.dart' show ConnectivityService;


// For icons

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // If using `flutterfire configure`
  );

  await Get.putAsync(() => ConnectivityService().init());
    // Register all controllers
  
  Get.put(LoginController());  
  Get.put(HomeController()); 
  Get.put(RegistrationController());
  // Get.put(WeatherController());

  
  runApp(ScreenUtilInit(
      designSize: const Size(375, 812), builder: (_, child) => MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[300], // Global background color
        // textTheme: GoogleFonts.aDLaMDisplayTextTheme( // Applying your custom font globally
        //   TextTheme(
        //     bodyLarge: TextStyle(
        //       color: const Color.fromARGB(255, 0, 0, 0),
        //       fontSize: screenWidth * 0.06, // Responsive font size
        //       fontWeight: FontWeight.bold,
        //     ),
        //     bodyMedium: TextStyle(
        //       color: const Color.fromARGB(255, 0, 0, 0),
        //       fontSize: screenWidth * 0.06, // Responsive font size
        //       fontWeight: FontWeight.bold,
        //     ),
        //     displayLarge: TextStyle(
        //       fontSize: screenWidth * 0.07,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.black,
        //     ),
        //     displayMedium: TextStyle(
        //       fontSize: screenWidth * 0.06,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[300], // Global AppBar color
          titleTextStyle: GoogleFonts.aDLaMDisplay(
            color: Colors.black,
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: SplashScreen(), // Your initial screen
    );
  }
}
