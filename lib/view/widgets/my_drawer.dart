import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_screen_room_controller.dart';
import '../../view/profileView.dart';
import '../../view/users.dart';
import '../../controller/login_screen_controller.dart';

class MyDrawer extends StatelessWidget {
  final LoginController loginController =
      Get.put(LoginController());
      HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[400],
      child: Column(
        children: [
          // Dynamic User Header
          Obx(() => UserAccountsDrawerHeader(
                accountName: Text(
                  "${loginController.mainUser?.firstName} ${loginController.mainUser?.lastName}" ?? 'Guest',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                accountEmail: Text(
                  loginController.mainUser!.email.isEmpty ? "No Email" : loginController.mainUser!.email.toString(),
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: _getUserAvatar(loginController.mainUser!.gender.toString()),
                ),
                decoration: BoxDecoration(color: Colors.black),
              )),

          // Profile button
          _buildDrawerItem(
            icon: Icons.person,
            text: "Profile",
            onTap: () => Get.to(() => ProfileView()),
          ),

          // Show "Add User" only if admin
          Obx(() =>loginController.mainUser!.role.value == '1' ||loginController.mainUser!.role.value == '2'
              ? _buildDrawerItem(
                  icon: Icons.person_add,
                  text: "Users",
                  onTap: () => Get.to(() => UserListScreen()),
                )
              : SizedBox()),

          // Show "Show Users" only if admin
          // Obx(() => loginController.mainUser!.role.value == '1'||loginController.mainUser!.role.value == '2'
          //     ? _buildDrawerItem(
          //         icon: Icons.people,
          //         text: "Rooms",
          //         onTap: () => Get.to(() => ShowUsers()),
          //       )
          //     : SizedBox()),

          Spacer(),
          Divider(),

          // Logout Button
          _buildDrawerItem(
            icon: Icons.exit_to_app,
            text: "Logout",
            onTap: () {
              // homeController.logout();
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
    );
  }

  // Method to get user avatar based on gender
  Widget _getUserAvatar(String gender) {
    if (gender.toLowerCase() == "male") {
      return ClipOval(child: Image.asset('assets/MaleAvtar.png', width: 60, height: 60, fit: BoxFit.cover));
    } else if (gender.toLowerCase() == "female") {
      return ClipOval(child: Image.asset('assets/FemaleAvtar.png', width: 60, height: 60, fit: BoxFit.cover));
    } else {
      return Icon(Icons.person, color: Colors.black, size: 40);
    }
  }

  // Drawer Item Widget
  Widget _buildDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(text, style: TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
