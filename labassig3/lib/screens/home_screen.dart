import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Enter your Height & Weight",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),

            // Height Input
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Height (cm)",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // Weight Input
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Weight (kg)",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: calculateBMI,
              child: Text("Calculate BMI"),
            ),
          ],
        ),
      ),
    );
  }
}
