import 'dart:convert';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../model/weather_model.dart';
import 'package:permission_handler/permission_handler.dart';

class WeatherController extends GetxController {
  var weatherData = Rxn<WeatherModel>();
  var isLoading = false.obs;
  var permissionGranted = false.obs;

  final apiKey = '97643c37bd124d559bd152004251204';

  @override
  void onInit() {
    super.onInit();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    isLoading.value = true;

    try {
      await _checkPermission();

      if (!permissionGranted.value) return;

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double lat = position.latitude;
      double lon = position.longitude;

      final url =
          'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$lat,$lon';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        weatherData.value = WeatherModel.fromJson(jsonData);
      } else {
        Get.snackbar("Error", "Failed to fetch weather data");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _checkPermission() async {
    var status = await Permission.location.request();
    permissionGranted.value = status.isGranted;

    if (!status.isGranted) {
      Get.snackbar("Permission Denied", "Location permission is required.");
    }
  }

  void retry() {
    fetchWeather();
  }
}
