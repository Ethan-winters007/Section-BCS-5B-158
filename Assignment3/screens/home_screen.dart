
import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import 'next_day_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _currentWeather;
  List<dynamic>? _hourlyForecast;
  bool _isLoading = false;
  String _currentTime = '';
  String _currentDate = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
    _fetchWeather('London'); // Default city
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      _currentDate = '${now.day}/${now.month}/${now.year}';
    });
  }

  Future<void> _fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weatherData = await _weatherService.getCurrentWeather(city);
      final forecastData = await _weatherService.getWeatherForecast(city);
      setState(() {
        _currentWeather = weatherData;
        _hourlyForecast = forecastData['list'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load weather data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Weather',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 28,
            fontWeight: FontWeight.w300,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.orange[600]),
            onPressed: () {
              if (_currentWeather != null) {
                _fetchWeather(_currentWeather!['name']);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const SizedBox(height: 20),
            // Time and Date Display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange[200]!, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentTime,
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _currentDate,
                        style: TextStyle(
                          color: Colors.orange[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.access_time,
                    color: Colors.orange[600],
                    size: 32,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for a city',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send, color: Colors.orange[600]),
                    onPressed: () {
                      if (_searchController.text.isNotEmpty) {
                        _fetchWeather(_searchController.text);
                        _searchController.clear();
                      }
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _fetchWeather(value);
                    _searchController.clear();
                  }
                },
              ),
            ),
            const SizedBox(height: 40),
            // Current Weather Card
            if (_isLoading)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                ),
              )
            else if (_currentWeather != null)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _getWeatherGradient(_currentWeather!['weather'][0]['main']),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 25,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentWeather!['name'],
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _currentWeather!['weather'][0]['description'].toString().toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Hero(
                          tag: 'weather-icon',
                          child: Image.network(
                            'https://openweathermap.org/img/wn/${_currentWeather!['weather'][0]['icon']}@4x.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${_currentWeather!['main']['temp'].round()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 64,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        const Text(
                          '°C',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 20,
                            ),
                            Text(
                              '${_currentWeather!['main']['temp_max'].round()}°',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            const Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 20,
                            ),
                            Text(
                              '${_currentWeather!['main']['temp_min'].round()}°',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Additional weather details
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildWeatherDetail(
                                Icons.opacity,
                                '${_currentWeather!['main']['humidity']}%',
                                'Humidity',
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              _buildWeatherDetail(
                                Icons.thermostat,
                                '${_currentWeather!['main']['feels_like'].round()}°',
                                'Feels like',
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              _buildWeatherDetail(
                                Icons.air,
                                '${_currentWeather!['wind']['speed']} m/s',
                                'Wind',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildWeatherDetail(
                                Icons.compress,
                                '${_currentWeather!['main']['pressure']} hPa',
                                'Pressure',
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              _buildWeatherDetail(
                                Icons.visibility,
                                '${(_currentWeather!['visibility'] / 1000).round()} km',
                                'Visibility',
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              _buildWeatherDetail(
                                Icons.wb_sunny,
                                '${_currentWeather!['main']['temp_max'].round()}°',
                                'Max Temp',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 40),
            // 24-Hour Forecast
            if (_hourlyForecast != null && _hourlyForecast!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '24-Hour Forecast',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 8, // Show 24 hours (8 * 3-hour intervals)
                      itemBuilder: (context, index) {
                        final forecast = _hourlyForecast![index];
                        final dateTime = DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
                        final hour = dateTime.hour;
                        final temp = forecast['main']['temp'].round();
                        final icon = forecast['weather'][0]['icon'];

                        return Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${hour == 0 ? '12' : hour > 12 ? '${hour - 12}' : hour.toString()}${hour >= 12 ? 'PM' : 'AM'}',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Image.network(
                                'https://openweathermap.org/img/wn/$icon.png',
                                width: 32,
                                height: 32,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$temp°',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${forecast['main']['humidity']}%',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '${forecast['wind']['speed']} m/s',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 40),
            // Next Day Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, NextDayScreen.routeName, arguments: _currentWeather);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'View Tomorrow\'s Weather',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  List<Color> _getWeatherGradient(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return [const Color(0xFF74B9FF), const Color(0xFF0984E3)];
      case 'clouds':
        return [const Color(0xFFA29BFE), const Color(0xFF6C5CE7)];
      case 'rain':
        return [const Color(0xFF636E72), const Color(0xFF2D3436)];
      case 'snow':
        return [const Color(0xFF74C69D), const Color(0xFF26A69A)];
      case 'thunderstorm':
        return [const Color(0xFF34495E), const Color(0xFF2C3E50)];
      default:
        return [const Color(0xFF667EEA), const Color(0xFF764BA2)];
    }
  }

  Widget _buildWeatherDetail(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
