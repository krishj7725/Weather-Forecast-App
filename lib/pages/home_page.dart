import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/city_data.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import 'weather_pager.dart'; // Import the new pager

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // We start with an empty list, then load from storage
  List<String> myCities = []; 
  final _weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  // --- SAVE & LOAD FUNCTIONS ---
  Future<void> _loadCities() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Try to load saved cities, or default to ["New York", "London"] if empty
      myCities = prefs.getStringList('my_cities') ?? ["New York", "London"];
    });
  }

  Future<void> _saveCities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('my_cities', myCities);
  }

  void _addCity(String cityName) {
    if (!myCities.contains(cityName)) {
      setState(() {
        myCities.add(cityName);
      });
      _saveCities(); // Save immediately after adding
    }
  }

  void _removeCity(int index) {
    setState(() {
      myCities.removeAt(index);
    });
    _saveCities(); // Save immediately after removing
  }

  // Navigate to the SWIPEABLE pager instead of a single page
  void _openDetail(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeatherPager(
          cities: myCities,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("My Cities", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            // --- SEARCH BAR ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') return const Iterable<String>.empty();
                  return CityData.getSuggestions(textEditingValue.text);
                },
                onSelected: (String selection) => _addCity(selection),
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Search & add city...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 20),

            // --- CITY LIST ---
            Expanded(
              child: ListView.builder(
                itemCount: myCities.length,
                itemBuilder: (context, index) {
                  final city = myCities[index];
                  return Dismissible(
                    key: Key(city),
                    onDismissed: (direction) => _removeCity(index),
                    background: Container(
                      color: Colors.redAccent, 
                      alignment: Alignment.centerRight, 
                      padding: const EdgeInsets.only(right: 20), 
                      margin: const EdgeInsets.only(bottom: 15),
                      child: const Icon(Icons.delete, color: Colors.white)
                    ),
                    child: GestureDetector(
                      // Pass the index so we know which page to start on
                      onTap: () => _openDetail(index),
                      child: FutureBuilder<Weather>(
                        future: _weatherService.getWeather(city),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return _buildCityCard(snapshot.data!);
                          } else if (snapshot.hasError) {
                            return _buildErrorCard(city);
                          }
                          return _buildLoadingCard(city);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widgets (Same as before)
  Widget _buildCityCard(Weather weather) {
    bool isNight = weather.hourlyForecasts[0].iconCode.endsWith('n');
    return Container(
      height: 110,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isNight 
            ? [const Color(0xFF2C3E50), const Color(0xFF4C669F)] 
            : [const Color(0xFF6DD5FA), const Color(0xFF2980B9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(weather.cityName, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              Text(weather.mainCondition, style: const TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
          Text("${weather.temperature.round()}°", style: const TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(String city) {
    return Container(
      height: 110,
      margin: const EdgeInsets.only(bottom: 15),  
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(25)),
      child: Center(child: Text(city, style: const TextStyle(color: Colors.grey, fontSize: 20))),
    );
  }

  Widget _buildErrorCard(String city) {
    return Container(
      height: 110,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.red[900]?.withOpacity(0.5), borderRadius: BorderRadius.circular(25)),
      child: Center(child: Text("$city (Not Found)", style: const TextStyle(color: Colors.white))),
    );
  }
}