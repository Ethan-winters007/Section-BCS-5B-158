import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/product_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fav = Provider.of<FavoritesProvider>(context);
    final products = Provider.of<ProductProvider>(context);
    final items = products.foods.where((f) => fav.contains(f.id ?? -1)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: items.isEmpty ? const Center(child: Text('No favorites yet')) : ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, idx) {
          final f = items[idx];
          return ListTile(
            leading: Image.asset(f.image, width: 56, height: 56),
            title: Text(f.name),
            subtitle: Text('\$${f.price.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
