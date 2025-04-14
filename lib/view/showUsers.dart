


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/api_service.dart';

class ShowUsers extends StatelessWidget {
  final ApiService apiService = Get.put(ApiService());

  @override
  Widget build(BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text("Users",style: GoogleFonts.aDLaMDisplay(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: screenWidth *
                                      0.06, // Responsive font size
                                  fontWeight: FontWeight.bold,
                                ),),
      backgroundColor: Colors.grey[300],
      ),
      body: Obx(() {
        if (apiService.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: apiService.users.length,
          itemBuilder: (context, index) {
            var user = apiService.users[index];
            return Card(
              child: ExpansionTile(
                title: Text("${user.firstName} ${user.lastName}"),
                subtitle: Text("Email: ${user.email}"),
                // children: user.rooms.map((room) {
                //   return ListTile(
                //     title: Text(room.name),
                //     subtitle: Text("Devices: ${room.roomDeviceList.length}"),
                //   );
                // }).toList(),
              ),
            );
          },
        );
      }),
      
    );
  }
}
