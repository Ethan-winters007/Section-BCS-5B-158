import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../db/database_helper.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  CartProvider() {
    loadFromDb();
  }

  List<CartItem> get items => List.unmodifiable(_items);

  double get total =>
      _items.fold(0, (prev, item) => prev + item.price * item.quantity);

  Future<void> loadFromDb() async {
    final maps = await DatabaseHelper.instance.getCartItems();
    _items.clear();
    for (final m in maps) {
      _items.add(CartItem.fromMap(m));
    }
    notifyListeners();
  }

  Future<void> addItem(CartItem item) async {
    final existing = _items.indexWhere((e) => e.foodId == item.foodId);
    if (existing >= 0) {
      _items[existing].quantity += item.quantity;
      await DatabaseHelper.instance.updateCartItem(
        _items[existing].id!,
        _items[existing].toMap(),
      );
    } else {
      final id = await DatabaseHelper.instance.insertCartItem(item.toMap());
      _items.add(
        CartItem(
          id: id,
          foodId: item.foodId,
          name: item.name,
          image: item.image,
          price: item.price,
          quantity: item.quantity,
        ),
      );
    }
    notifyListeners();
  }

  Future<void> removeItem(int id) async {
    await DatabaseHelper.instance.deleteCartItem(id);
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  Future<void> changeQuantity(int id, int quantity) async {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx >= 0) {
      _items[idx].quantity = quantity;
      await DatabaseHelper.instance.updateCartItem(id, _items[idx].toMap());
      notifyListeners();
    }
  }

  Future<void> clear() async {
    await DatabaseHelper.instance.clearCart();
    _items.clear();
    notifyListeners();
  }
}
