import 'package:Smartify/view/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class DummyWeatherContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Dummy weather data
    final dummyData = {
      "condition": "Cloudy",
      "temperature": "26°C",
      "sensible": "27°C",
      "precipitation": "0 mm",
      "humidity": "65%",
      "wind": "10 km/h",
      "city": "Pune"
    };

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
                        color: dummyData["condition"]!.contains("Rain")
                            ? Colors.blue
                            : Colors.white,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        dummyData["condition"]!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    dummyData["temperature"]!,
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
                  WeatherInfo(label: 'Sensible', value: dummyData["sensible"]!),
                  WeatherInfo(label: 'Precip.', value: dummyData["precipitation"]!),
                  WeatherInfo(label: 'Humidity', value: dummyData["humidity"]!),
                  WeatherInfo(label: 'Wind', value: dummyData["wind"]!),
                ],
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  dummyData["city"]!,
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
  }
}
