import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/game_result.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guess History"),
      ),
      body: FutureBuilder<List<GameResult>>(
        future: DBHelper.instance.fetchResults(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final results = snapshot.data!;

          if (results.isEmpty) {
            return Center(child: Text("No history found"));
          }

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final item = results[index];

              return ListTile(
                leading: Icon(Icons.check_circle),
                title: Text("Guess: ${item.guess}"),
                subtitle: Text("Status: ${item.status}\n${item.timestamp}"),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}
