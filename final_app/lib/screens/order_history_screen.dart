import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../db/database_helper.dart';
import '../utils/format.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item_model.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final orderProv = Provider.of<OrderProvider>(context, listen: false);
    await orderProv.loadOrders();
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _reorder(int orderId) async {
    final items = await DatabaseHelper.instance.getOrderItems(orderId);
    final cart = Provider.of<CartProvider>(context, listen: false);
    for (final i in items) {
      await cart.addItem(CartItem(
        foodId: i['foodId'],
        name: i['name'],
        image: i['image'] ?? 'assets/images/pizza.png',
        price: (i['price'] as num).toDouble(),
        quantity: i['quantity'] as int,
      ));
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order added to cart')));
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Go to Cart from FAB')))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProv = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Clear orders?'),
                  content: const Text('This will remove all past orders.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Clear')),
                  ],
                ),
              );
              if (confirmed == true) {
                await Provider.of<OrderProvider>(context, listen: false).clearOrders();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<OrderProvider>(context, listen: false).loadOrders(),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : orderProv.orders.isEmpty
                ? const Center(child: Text('No orders yet'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: orderProv.orders.length,
                    itemBuilder: (_, idx) {
                      final o = orderProv.orders[idx];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text('Order #${o.id} - ${formatCurrency(o.total)}'),
                          subtitle: Text(o.date),
                          trailing: IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () => _reorder(o.id!),
                          ),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => FutureBuilder(
                                future: DatabaseHelper.instance.getOrderItems(o.id!),
                                builder: (context, snap) {
                                  if (snap.connectionState != ConnectionState.done) {
                                    return const SizedBox(
                                      height: 200,
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  }
                                  final items = snap.data as List<Map<String, dynamic>>;
                                  return SizedBox(
                                    height: 300,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ListView(
                                            children: items
                                                .map(
                                                  (i) => ListTile(
                                                    leading: i['image'] != null ? Image.asset(i['image'], width: 40, height: 40) : null,
                                                    title: Text(i['name']),
                                                    trailing: Text('x${i['quantity']}'),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () => _reorder(o.id!),
                                            child: const Text('Reorder'),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
