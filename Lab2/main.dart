import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = "";
  String result = "0";

  void buttonPressed(String value) {
    setState(() {
      if (value == "C") {
        input = "";
        result = "0";
      } else if (value == "=") {
        try {
          result = calculate(input);
        } catch (e) {
          result = "Error";
        }
      } else {
        input += value;
      }
    });
  }

  String calculate(String exp) {
    try {
      exp = exp.replaceAll("×", "*");
      exp = exp.replaceAll("÷", "/");
      final double eval = _evaluate(exp);
      return eval.toString();
    } catch (e) {
      return "Error";
    }
  }

  double _evaluate(String expression) {
    // Simple evaluator for + - * /
    List<String> tokens =
        expression.split(RegExp(r'([+\-*/])')).map((e) => e.trim()).toList();
    double result = double.parse(tokens[0]);

    for (int i = 1; i < tokens.length; i += 2) {
      String op = tokens[i];
      double num = double.parse(tokens[i + 1]);
      if (op == "+") result += num;
      if (op == "-") result -= num;
      if (op == "*") result *= num;
      if (op == "/") result /= num;
    }
    return result;
  }

  Widget buildButton(String text, {Color? color}) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(22),
          backgroundColor: color ?? Colors.blueGrey,
        ),
        onPressed: () => buttonPressed(text),
        child: Text(
          text,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Text(
                input,
                style: const TextStyle(color: Colors.white, fontSize: 32),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.bottomRight,
            child: Text(
              result,
              style: const TextStyle(
                  color: Colors.green,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(color: Colors.white),
          Column(
            children: [
              Row(
                children: [
                  buildButton("7"),
                  buildButton("8"),
                  buildButton("9"),
                  buildButton("÷", color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton("4"),
                  buildButton("5"),
                  buildButton("6"),
                  buildButton("×", color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton("1"),
                  buildButton("2"),
                  buildButton("3"),
                  buildButton("-", color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton("0"),
                  buildButton("C", color: Colors.red),
                  buildButton("=", color: Colors.green),
                  buildButton("+", color: Colors.orange),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
