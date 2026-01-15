import 'package:flutter/material.dart';
import 'weather_page.dart';

class WeatherPager extends StatelessWidget {
  final List<String> cities;
  final int initialIndex;

  const WeatherPager({
    super.key,
    required this.cities,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // PageView lets you swipe left/right between full screens
      body: PageView.builder(
        // Start at the city the user tapped on
        controller: PageController(initialPage: initialIndex),
        itemCount: cities.length,
        itemBuilder: (context, index) {
          // Build the weather page for the specific city at this index
          return WeatherPage(cityName: cities[index]);
        },
      ),
    );
  }
}