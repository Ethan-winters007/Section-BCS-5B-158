class Order {
  final int? id;
  final double total;
  final String date;

  Order({this.id, required this.total, required this.date});

  factory Order.fromMap(Map<String, dynamic> map) => Order(
    id: map['id'] as int?,
    total: (map['total'] as num).toDouble(),
    date: map['date'] as String,
  );

  Map<String, dynamic> toMap() => {'id': id, 'total': total, 'date': date};
}
