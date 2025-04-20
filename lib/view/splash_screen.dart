import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../view/login_screen.dart';





class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _lampPosition;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _lampPosition = Tween<double>(begin: -100, end: -0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });

    Future.delayed(Duration(seconds: 3),
    () => Get.offAll(()=>LoginScreen()),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Match background color of the logo
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // House Icon
            Positioned(
              bottom: 50,
              child: Image.asset("assets/home_icon.png", width: 350),
            ),

            // Lamp Animation with Light Spread
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Positioned(
                  top: _lampPosition.value,
                  child: Column(
                    children: [
                      // Lamp Icon
                      Image.asset("assets/lamp_icon.png", width: 700),
                      SizedBox(height: 5), // Reduce spacing
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}