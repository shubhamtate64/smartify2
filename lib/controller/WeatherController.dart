import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../model/weather_model.dart';
import 'dart:convert';

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
    bool hasPermission = await _checkPermission();

    if (!hasPermission) {
      isLoading.value = false;
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final lat = position.latitude;
    final lon = position.longitude;

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


Future<bool> _checkPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    openAppSettings();
    Get.snackbar("Permission Denied", "Please enable location permission in settings.");
    return false;
  }

  if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
    permissionGranted.value = true;
    return true;
  }

  permissionGranted.value = false;
  Get.snackbar("Permission Denied", "Location permission is required.");
  return false;
}


 void retry() async {
  // Check location permission again
  bool granted = await _checkPermission();
  permissionGranted.value = granted;

  if (granted) {
    // If permission is granted, fetch the weather again
    fetchWeather();
  }
}

}
