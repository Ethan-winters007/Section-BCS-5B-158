class GameResult {
  int? id;
  int guess;
  String status;
  String timestamp;

  GameResult({
    this.id,
    required this.guess,
    required this.status,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'guess': guess,
      'status': status,
      'timestamp': timestamp,
    };
  }

  factory GameResult.fromMap(Map<String, dynamic> map) {
    return GameResult(
      id: map['id'],
      guess: map['guess'],
      status: map['status'],
      timestamp: map['timestamp'],
    );
  }
}
