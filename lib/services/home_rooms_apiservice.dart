import 'dart:convert';
import '../model/room_model.dart';
import 'package:http/http.dart' as http;

class HomeRoomsApiservice {
  final String baseUrl = "https://your-api-endpoint.com"; // Replace with your API URL

  // Send rooms list to the backend
  Future<Map<String, dynamic>> postRoomsList(List<Room> rooms, String userToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/rooms/bulk'), // Adjust the endpoint as needed
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken', // Include the token in the header
        },
        body: jsonEncode({
          'rooms': rooms.map((room) => room.toJson()).toList(), // Convert rooms list to JSON
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Rooms added successfully'};
      } else {
        return {'success': false, 'message': 'Failed to add rooms: ${response.body}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
