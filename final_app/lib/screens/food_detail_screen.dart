import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_model.dart';
import '../models/cart_item_model.dart';
import '../providers/cart_provider.dart';
import '../utils/format.dart';
import '../providers/product_provider.dart';
import '../providers/favorites_provider.dart';
import 'cart_screen.dart';

class FoodDetailScreen extends StatefulWidget {
  final Food food;
  const FoodDetailScreen({super.key, required this.food});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int qty = 1;
  bool _adding = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final productProv = Provider.of<ProductProvider>(context, listen: false);
    final flavours = productProv.foodsByCategory(widget.food.category)
        .where((f) => f.id != widget.food.id)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.food.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(aspectRatio: 16 / 9, child: Image.asset(widget.food.image, fit: BoxFit.cover)),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(widget.food.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(formatCurrency(widget.food.price)),
                  const SizedBox(height: 12),
                  if (widget.food.description.isNotEmpty) ...[
                    Text(widget.food.description),
                    const SizedBox(height: 12),
                  ],
                  if (flavours.isNotEmpty) ...[
                    const Text('Other flavours', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, i) {
                          final ff = flavours[i];
                          return GestureDetector(
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FoodDetailScreen(food: ff))),
                            child: SizedBox(
                              width: 140,
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                color: Theme.of(context).cardColor.withOpacity(0.6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(child: Padding(padding: const EdgeInsets.all(6), child: Image.asset(ff.image, fit: BoxFit.contain))),
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(ff.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                          Text(formatCurrency(ff.price), style: const TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemCount: flavours.length,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => setState(() => qty = qty > 1 ? qty - 1 : 1),
                        icon: const Icon(Icons.remove),
                      ),
                      Text(qty.toString()),
                      IconButton(
                        onPressed: () => setState(() => qty++),
                        icon: const Icon(Icons.add),
                      ),
                      const Spacer(),
                      Consumer<FavoritesProvider>(
                        builder: (context, favorites, child) {
                          final isFavorite = favorites.contains(widget.food.id ?? 0);
                          return IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                            ),
                            onPressed: () {
                              favorites.toggle(widget.food.id ?? 0);
                            },
                          );
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_adding) return;
                          setState(() => _adding = true);
                          final messenger = ScaffoldMessenger.of(context);
                          final navigator = Navigator.of(context);
                          await cart.addItem(
                            CartItem(
                              foodId: widget.food.id ?? 0,
                              name: widget.food.name,
                              image: widget.food.image,
                              price: widget.food.price,
                              quantity: qty,
                            ),
                          );
                          setState(() => _adding = false);
                          messenger.showSnackBar(const SnackBar(content: Text('Added to cart')));
                          navigator.push(MaterialPageRoute(builder: (_) => const CartScreen()));
                        },
                        child: _adding ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Add to Cart'),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
