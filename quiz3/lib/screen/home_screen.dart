import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void calculateBMI() {
    if (heightController.text.isEmpty || weightController.text.isEmpty) {
      Navigator.pushNamed(context, '/error');
      return;
    }

    double height = double.tryParse(heightController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0;

    if (height <= 0 || weight <= 0) {
      Navigator.pushNamed(context, '/error');
      return;
    }

    double heightMeters = height / 100;
    double bmi = weight / (heightMeters * heightMeters);

    Navigator.pushNamed(
      context,
      '/result',
      arguments: bmi,
    );
  }

  void _onButtonPressed() {
    _animationController.forward().then((_) {
      _animationController.reverse();
      calculateBMI();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal[100]!, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.fitness_center,
                size: 80,
                color: Colors.teal,
              ),
              SizedBox(height: 20),
              Text(
                "Enter your Height & Weight",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal[800]),
              ),
              SizedBox(height: 40),

              // Height Input
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Height (cm)",
                    prefixIcon: Icon(Icons.height, color: Colors.teal),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Weight Input
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Weight (kg)",
                    prefixIcon: Icon(Icons.monitor_weight, color: Colors.teal),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),

              SizedBox(height: 40),

              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: ElevatedButton(
                      onPressed: _onButtonPressed,
                      child: Text("Calculate BMI", style: TextStyle(fontSize: 18)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          heightController.clear();
          weightController.clear();
        },
        backgroundColor: Colors.orangeAccent,
        child: Icon(Icons.clear),
        tooltip: 'Clear Inputs',
      ),
    );
  }
}
