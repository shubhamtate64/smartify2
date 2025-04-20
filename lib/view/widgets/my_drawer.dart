import 'package:Smartify/view/BaseScreen2.dart';
import 'package:Smartify/view/baseScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/home_screen_room_controller.dart';
import '../../view/profileView.dart';
import '../../view/users.dart';
import '../../controller/login_screen_controller.dart';

class MyDrawer extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Dynamic User Header
          Obx(() {
            final user = loginController.mainUser;
            final name =
                "${user?.firstName.value ?? 'Guest'} ${user?.lastName.value ?? ''}"
                    .trim();
            final email = user?.email.value ?? "No Email";
            final gender = user?.gender.value ?? "other";

            return UserAccountsDrawerHeader(
              accountName: Text(
                name,
                style: GoogleFonts.aDLaMDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                email.isEmpty ? "No Email" : email,
                style: GoogleFonts.aDLaMDisplay(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: _getUserAvatar(gender),
              ),
              decoration: BoxDecoration(color: Colors.black),
            );
          }),

          _buildDrawerItem(
            icon: Icons.person,
            text: "Profile",
            onTap: () {
              Get.back();
              Get.to(() => BaseScreen2(child: ProfileView()));
            },
          ),

          // Show Users option only for admin roles
          Obx(() {
            final role = loginController.mainUser?.role.value ?? '';
            return (role == '1' || role == '2')
                ? _buildDrawerItem(
                  icon: Icons.person_add,
                  text: "Users",
                  onTap: () {
                    Get.back();
                    Get.to(() => BaseScreen2(child: UserListScreen()));
                  },
                )
                : SizedBox();
          }),

          Spacer(),
          Divider(),

          // _buildDrawerItem(
          //   icon: Icons.exit_to_app,
          //   text: "Logout",
          //   onTap: () {
          //     Get.offAllNamed('/login');
          //   },
          // ),
        ],
      ),
    );
  }

  // User avatar based on gender
  Widget _getUserAvatar(String gender) {
    if (gender.toLowerCase() == "male") {
      return ClipOval(
        child: Image.asset(
          'assets/MaleAvtar.png',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      );
    } else if (gender.toLowerCase() == "female") {
      return ClipOval(
        child: Image.asset(
          'assets/FemaleAvtar.png',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Icon(Icons.person, color: Colors.black, size: 40);
    }
  }

  // Drawer item builder with custom font
  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        text,
        style: GoogleFonts.aDLaMDisplay(fontSize: 16, color: Colors.black),
      ),
      onTap: onTap,
    );
  }
}
