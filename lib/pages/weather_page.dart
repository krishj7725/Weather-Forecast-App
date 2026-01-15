import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  final String cityName;

  const WeatherPage({super.key, required this.cityName});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService();
  Weather? _weather;
  bool _isLoading = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final weather = await _weatherService.getWeather(widget.cityName);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Could not load weather data.";
        _isLoading = false;
      });
    }
  }

  IconData _getIconFromCode(String code) {
    switch (code.substring(0, 2)) {
      case '01': return Icons.wb_sunny_rounded;
      case '02': return Icons.cloud_queue_rounded;
      case '03': case '04': return Icons.cloud_rounded;
      case '09': case '10': return Icons.water_drop_rounded;
      case '11': return Icons.flash_on_rounded;
      case '13': return Icons.ac_unit_rounded;
      case '50': return Icons.blur_on_rounded;
      default: return Icons.wb_sunny_rounded;
    }
  }
  
  List<Color> _getBackgroundColors(String? iconCode) {
    if (iconCode == null || iconCode.endsWith('d')) {
      return [const Color(0xFF6DD5FA), const Color(0xFFFFE2D3)];
    } else {
      return [const Color(0xFF2C3E50), const Color(0xFF4C669F)];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Safely handle missing data during loading
    String currentIconCode = _weather?.hourlyForecasts[0].iconCode ?? "01d";
    bool isNight = currentIconCode.endsWith('n');
    Color textColor = isNight ? Colors.white : const Color(0xFF333333);

    return Scaffold(
      extendBodyBehindAppBar: true, // Allows gradient to go behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _getBackgroundColors(currentIconCode),
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : _errorMessage.isNotEmpty
                  ? Center(child: Text(_errorMessage, style: TextStyle(color: textColor, fontSize: 18)))
                  : Column(
                      children: [
                        // --- TOP SECTION ---
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _weather!.cityName,
                                style: TextStyle(color: textColor, fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                DateFormat('EEEE, MMM d').format(DateTime.now()),
                                style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 16),
                              ),
                              const SizedBox(height: 40),
                              Icon(
                                _getIconFromCode(currentIconCode),
                                size: 100,
                                color: textColor,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '${_weather!.temperature.round()}°',
                                style: TextStyle(color: textColor, fontSize: 90, fontWeight: FontWeight.w200),
                              ),
                              Text(
                                _weather!.mainCondition,
                                style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),

                        // --- BOTTOM SHEET ---
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isNight ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.8),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Hourly Forecast", style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 15),
                              
                              SizedBox(
                                height: 110,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _weather!.hourlyForecasts.length,
                                  itemBuilder: (context, index) {
                                    final forecast = _weather!.hourlyForecasts[index];
                                    return Container(
                                      width: 70,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: isNight ? Colors.white.withOpacity(0.05) : Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(forecast.time, style: TextStyle(color: textColor, fontSize: 12)),
                                          const SizedBox(height: 8),
                                          Icon(_getIconFromCode(forecast.iconCode), color: textColor, size: 24),
                                          const SizedBox(height: 8),
                                          Text('${forecast.temperature.round()}°', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 20),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildDetailItem(Icons.water_drop_outlined, "${_weather!.humidity.round()}%", "Humidity", textColor),
                                  _buildDetailItem(Icons.air, "${_weather!.windSpeed} km/h", "Wind", textColor),
                                  _buildDetailItem(Icons.speed, "${_weather!.pressure.round()} hPa", "Pressure", textColor),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color.withOpacity(0.7)),
        const SizedBox(height: 5),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 12)),
      ],
    );
  }
}