

import 'package:flutter/material.dart';

class WeatherInfo extends StatelessWidget {
  final String label;
  final String value;

  const WeatherInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(color: Colors.white60, fontSize: 12)),
        SizedBox(height: 2),
        Text(value,
            style: TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }
}


