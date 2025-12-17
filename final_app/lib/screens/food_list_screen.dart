import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/favorites_provider.dart';
import '../utils/format.dart';
import 'food_detail_screen.dart';

class FoodListScreen extends StatelessWidget {
  final String? categoryId;
  final String? query;

  const FoodListScreen({super.key, this.categoryId, this.query});

  @override
  Widget build(BuildContext context) {
    final productProv = Provider.of<ProductProvider>(context);
    final List foods = (query != null && query!.isNotEmpty)
        ? productProv.search(query!)
        : (categoryId != null
              ? productProv.foodsByCategory(categoryId!)
              : productProv.foods);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Foods')),
      body: SafeArea(
        child: Builder(builder: (context) {
          final bottom = MediaQuery.of(context).viewInsets.bottom;
            return GridView.builder(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 12 + bottom),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 240,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: foods.length,
        itemBuilder: (_, idx) {
          final f = foods[idx];
          return Consumer<FavoritesProvider>(
            builder: (context, favorites, child) {
              final isFavorite = favorites.contains(f.id ?? 0);
              return InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => FoodDetailScreen(food: f)),
                ),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AspectRatio(
                            aspectRatio: 3 / 2,
                            child: Image.asset(f.image, fit: BoxFit.cover),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  f.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(formatCurrency(f.price)),
                              ],
                            ),
                          )
                        ],
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.white,
                          ),
                          onPressed: () {
                            favorites.toggle(f.id ?? 0);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
          );
        }),
      ),
    );
  }
}
