import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  Future<void> loadOrders() async {
    final maps = await DatabaseHelper.instance.getOrders();
    _orders = maps.map((m) => Order.fromMap(m)).toList();
    notifyListeners();
  }

  Future<void> clearOrders() async {
    await DatabaseHelper.instance.clearOrders();
    await loadOrders();
  }

  Future<void> placeOrder(
    double total,
    List<Map<String, dynamic>> items,
  ) async {
    final id = await DatabaseHelper.instance.insertOrder({
      'total': total,
      'date': DateTime.now().toIso8601String(),
    });
    for (final item in items) {
      final itemMap = {
        'orderId': id,
        'foodId': item['foodId'],
        'name': item['name'],
        'price': item['price'],
        'quantity': item['quantity'],
      };
      await DatabaseHelper.instance.insertOrderItem(itemMap);
    }
    await loadOrders();
  }
}
