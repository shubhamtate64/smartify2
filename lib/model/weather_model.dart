class WeatherModel {
  final String condition;
  final String temperature;
  final String sensible;
  final String precipitation;
  final String humidity;
  final String wind;
  final String city;

  WeatherModel({
    required this.condition,
    required this.temperature,
    required this.sensible,
    required this.precipitation,
    required this.humidity,
    required this.wind,
    required this.city,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      condition: json["current"]["condition"]["text"],
      temperature: "${json["current"]["temp_c"].round()}°C",
      sensible: "${json["current"]["feelslike_c"].round()}°C",
      precipitation: "${json["current"]["precip_mm"]} mm",
      humidity: "${json["current"]["humidity"]}%",
      wind: "${json["current"]["wind_kph"]} km/h",
      city: json["location"]["name"],
    );
  }
}
