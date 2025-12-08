import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/game_result.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with TickerProviderStateMixin {
  late AnimationController _resultController;
  late Animation<double> _resultScaleAnimation;
  late Animation<double> _resultOpacityAnimation;
  late AnimationController _buttonController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Result reveal animation
    _resultController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _resultScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _resultController,
        curve: Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    _resultOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _resultController,
        curve: Interval(0.2, 1.0, curve: Curves.easeIn),
      ),
    );

    _resultController.forward();

    // Button animation
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _resultController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _playAgain() async {
    await _buttonController.forward();
    await _buttonController.reverse();

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)!.settings.arguments as Map;
    int guess = args["guess"];
    String status = args["status"];

    DateTime now = DateTime.now();

    DBHelper.instance.insertResult(
      GameResult(
        guess: guess,
        status: status,
        timestamp: now.toString(),
      ),
    );

    Color resultColor;
    IconData resultIcon;

    switch (status) {
      case "Correct":
        resultColor = Colors.green;
        resultIcon = Icons.check_circle;
        break;
      case "Too High":
        resultColor = Colors.orange;
        resultIcon = Icons.arrow_upward;
        break;
      case "Too Low":
        resultColor = Colors.blue;
        resultIcon = Icons.arrow_downward;
        break;
      default:
        resultColor = Theme.of(context).primaryColor;
        resultIcon = Icons.help;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: AnimatedBuilder(
              animation: Listenable.merge([_resultScaleAnimation, _resultOpacityAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _resultScaleAnimation.value,
                  child: Opacity(
                    opacity: _resultOpacityAnimation.value,
                    child: Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: resultColor.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            resultIcon,
                            size: 80,
                            color: resultColor,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Your Guess",
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            "$guess",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: resultColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: resultColor, width: 2),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: resultColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          AnimatedBuilder(
                            animation: _buttonScaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _buttonScaleAnimation.value,
                                child: ElevatedButton.icon(
                                  onPressed: _playAgain,
                                  icon: Icon(Icons.refresh),
                                  label: Text("Play Again", style: TextStyle(fontSize: 18)),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
