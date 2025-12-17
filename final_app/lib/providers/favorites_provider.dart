import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<int> _ids = {};

  Set<int> get ids => _ids;

  FavoritesProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('favorites') ?? [];
    _ids.clear();
    _ids.addAll(list.map(int.parse));
    notifyListeners();
  }

  Future<void> toggle(int id) async {
    if (_ids.contains(id)) {
      _ids.remove(id);
    } else {
      _ids.add(id);
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', _ids.map((i) => i.toString()).toList());
    notifyListeners();
  }

  bool contains(int id) => _ids.contains(id);
}
