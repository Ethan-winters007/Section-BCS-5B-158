import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../utils/format.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    await cart.loadFromDb();
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : cart.items.isEmpty
              ? const Center(child: Text('Cart is empty'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (_, idx) {
                          final item = cart.items[idx];
                          return ListTile(
                            leading: Image.asset(item.image, width: 56, height: 56),
                            title: Text(item.name),
                            subtitle: Text(formatCurrency(item.price)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => cart.changeQuantity(
                                    item.id!,
                                    item.quantity - 1 > 0 ? item.quantity - 1 : 1,
                                  ),
                                  icon: const Icon(Icons.remove),
                                ),
                                Text(item.quantity.toString()),
                                IconButton(
                                  onPressed: () => cart.changeQuantity(
                                    item.id!,
                                    item.quantity + 1,
                                  ),
                                  icon: const Icon(Icons.add),
                                ),
                                IconButton(
                                  onPressed: () => cart.removeItem(item.id!),
                                  icon: const Icon(Icons.delete, color: Color(0xFF0A7E8B)),

                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Total: ${formatCurrency(cart.total)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              final items = cart.items.map((i) => i.toMap()).toList();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CheckoutScreen(
                                    total: cart.total,
                                    items: items,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Checkout'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
