import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/category_model.dart';
import 'food_detail_screen.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item_model.dart';
import 'cart_screen.dart';
import '../providers/favorites_provider.dart';
import '../utils/format.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;
  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  // Dessert tab state to switch between Cake and Ice Cream
  String _dessertTab = 'cake';
  // Hover tracking for deal tiles
  int _hoverDealId = -1;
  // Search functionality
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _ctrl.forward();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _animated(Widget child, int index) {
    final start = (index * 0.08).clamp(0.0, 1.0);
    final end = (start + 0.4).clamp(0.0, 1.0);
    final anim = CurvedAnimation(parent: _ctrl, curve: Interval(start, end, curve: Curves.easeOut));
    return FadeTransition(opacity: anim, child: SlideTransition(position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(anim), child: child));
  }

  Widget _favoriteButton(int id) {
    return Consumer<FavoritesProvider>(
      builder: (context, favorites, _) => IconButton(
        icon: Icon(favorites.contains(id) ? Icons.favorite : Icons.favorite_border, color: favorites.contains(id) ? Colors.red : null),
        onPressed: () => favorites.toggle(id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context);
    final items = products.foodsByCategory(widget.category.id);
    final isDeals = widget.category.id == 'deals';
    final isPizza = widget.category.id == 'pizza';
    final isBurger = widget.category.id == 'burger';
    final isFries = widget.category.id == 'fries';
    final isDrinks = widget.category.id == 'drink';
    final isDessert = widget.category.id == 'dessert';
    final isSandwich = widget.category.id == 'sandwich';
    final isTacos = widget.category.id == 'tacos';
    final isNoodles = widget.category.id == 'noodles';
    final isBiryani = widget.category.id == 'biryani';
    final isKarahi = widget.category.id == 'karahi';
    final isSalad = widget.category.id == 'salad';

    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.45,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(widget.category.image, fit: BoxFit.contain, alignment: Alignment.center),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SafeArea(
              child: isDeals
                  ? _buildDeals(items)
                  : isPizza
                      ? _buildPizza(items)
                      : isBurger
                          ? _buildBurger(items)
                          : isFries
                              ? _buildFries(items)
                              : isDrinks
                                  ? _buildDrinks(items)
                                  : isDessert
                                      ? _buildDessert(items)
                                      : isSandwich
                                              ? _buildSandwich(items)
                                              : isTacos
                                                  ? _buildTacos(items)
                                                  : isNoodles
                                                      ? _buildNoodles(items)
                                                      : isBiryani
                                                          ? _buildBiryani(items)
                                                          : isKarahi
                                                              ? _buildKarahi(items)
                                                              : isSalad
                                                                  ? _buildSalad(items)
                                                                  : _buildGrid(items),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPizza(List items) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset('assets/images/pizza_menu_background.png', fit: BoxFit.cover)),
        Center(
          child: FractionallySizedBox(
            widthFactor: 0.9,
            heightFactor: 0.75,
            child: Card(
              color: Theme.of(context).cardColor.withOpacity(0.85),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (_, idx) {
                  final f = items[idx];
                  return ListTile(
                    title: Center(child: Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                    trailing: _favoriteButton(f.id),
                    onTap: () => _showPizzaSizeModal(f),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showPizzaSizeModal(dynamic f) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        String size = 'Small';
        int qty = 1;
        double priceForSize(String s) {
          if (s == 'Small') return 500.0;
          if (s == 'Medium') return 1000.0;
          return 1500.0; // Large
        }
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(f.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ChoiceChip(label: const Text('Small'), selected: size == 'Small', onSelected: (_) => setState(() => size = 'Small')),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Medium'), selected: size == 'Medium', onSelected: (_) => setState(() => size = 'Medium')),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Large'), selected: size == 'Large', onSelected: (_) => setState(() => size = 'Large')),
                ]),
                const SizedBox(height: 8),
                Text('Price: ${formatCurrency(priceForSize(size) * qty)}'),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(onPressed: () => setState(() => qty = qty > 1 ? qty - 1 : 1), icon: const Icon(Icons.remove)),
                  Text(qty.toString()),
                  IconButton(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add)),
                ]),
                ElevatedButton(
                  onPressed: () async {
                    final cart = Provider.of<CartProvider>(context, listen: false);
                    await cart.addItem(CartItem(foodId: f.id, name: '${f.name} ($size)', image: f.image, price: priceForSize(size), quantity: qty));
                    if (mounted) ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('${f.name} added to cart'), duration: const Duration(milliseconds: 600)));
                    await Future.delayed(const Duration(milliseconds: 600));
                    if (mounted) Navigator.of(this.context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
                  },
                  child: const Text('Add to Cart'),
                )
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildBurger(List items) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset('assets/images/burger_menu_background.png', fit: BoxFit.cover)),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Card(
              color: Theme.of(context).cardColor.withOpacity(0.85),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (_, idx) {
                  final f = items[idx];
                  final price = 200 + (idx * 50); // incremental pricing as requested
                  return ListTile(
                    title: Center(child: Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                    subtitle: Center(child: Text(formatCurrency(price.toDouble()))),
                    trailing: _favoriteButton(f.id),
                    onTap: () => _showBurgerModal(f, price.toDouble()),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showBurgerModal(dynamic f, double price) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        int qty = 1;
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(f.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Price: ${formatCurrency(price * qty)}'),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(onPressed: () => setState(() => qty = qty > 1 ? qty - 1 : 1), icon: const Icon(Icons.remove)),
                  Text(qty.toString()),
                  IconButton(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add)),
                ]),
                ElevatedButton(
                  onPressed: () async {
                    final cart = Provider.of<CartProvider>(context, listen: false);
                    await cart.addItem(CartItem(foodId: f.id, name: f.name, image: f.image, price: price, quantity: qty));
                    if (mounted) ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('${f.name} added to cart'), duration: const Duration(milliseconds: 600)));
                    await Future.delayed(const Duration(milliseconds: 600));
                    if (mounted) Navigator.of(this.context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
                  },
                  child: const Text('Add to Cart'),
                )
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildFries(List items) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset('assets/images/fries_menu_background.png', fit: BoxFit.cover)),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Card(
              color: Theme.of(context).cardColor.withOpacity(0.85),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (_, idx) {
                  final f = items[idx];
                  return _animated(
                    ListTile(
                      title: Center(child: Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                      trailing: _favoriteButton(f.id),
                      onTap: () => _showFriesModal(f),
                    ),
                    idx,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showFriesModal(dynamic f) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        String size = 'Small';
        int qty = 1;
        double priceForSize(String s) {
          if (s == 'Small') return 150.0;
          if (s == 'Medium') return 250.0;
          return 350.0;
        }
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(f.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ChoiceChip(label: const Text('Small'), selected: size == 'Small', onSelected: (_) => setState(() => size = 'Small')),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Medium'), selected: size == 'Medium', onSelected: (_) => setState(() => size = 'Medium')),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Large'), selected: size == 'Large', onSelected: (_) => setState(() => size = 'Large')),
                ]),
                const SizedBox(height: 8),
                Text('Price: ${formatCurrency(priceForSize(size) * qty)}'),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(onPressed: () => setState(() => qty = qty > 1 ? qty - 1 : 1), icon: const Icon(Icons.remove)),
                  Text(qty.toString()),
                  IconButton(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add)),
                ]),
                ElevatedButton(
                  onPressed: () async {
                    final cart = Provider.of<CartProvider>(context, listen: false);
                    await cart.addItem(CartItem(foodId: f.id, name: '${f.name} ($size)', image: f.image, price: priceForSize(size), quantity: qty));
                    if (mounted) ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('${f.name} added to cart'), duration: const Duration(milliseconds: 600)));
                    await Future.delayed(const Duration(milliseconds: 600));
                    if (mounted) Navigator.of(this.context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
                  },
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildDrinks(List items) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset('assets/images/drinks_menu_background.png', fit: BoxFit.cover)),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Card(
              color: Theme.of(context).cardColor.withOpacity(0.85),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (_, idx) {
                  final f = items[idx];
                  return _animated(
                    ListTile(
                      title: Center(child: Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                      trailing: _favoriteButton(f.id),
                      onTap: () => _showDrinksModal(f),
                    ),
                    idx,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDrinksModal(dynamic f) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        String size = 'Small';
        int qty = 1;
        double priceForSize(String s) {
          if (s == 'Small') return 80.0;
          if (s == 'Medium') return 120.0;
          return 180.0;
        }
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(f.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ChoiceChip(label: const Text('Small'), selected: size == 'Small', onSelected: (_) => setState(() => size = 'Small')),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Medium'), selected: size == 'Medium', onSelected: (_) => setState(() => size = 'Medium')),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Large'), selected: size == 'Large', onSelected: (_) => setState(() => size = 'Large')),
                ]),
                const SizedBox(height: 8),
                Text('Price: ${formatCurrency(priceForSize(size) * qty)}'),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(onPressed: () => setState(() => qty = qty > 1 ? qty - 1 : 1), icon: const Icon(Icons.remove)),
                  Text(qty.toString()),
                  IconButton(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add)),
                ]),
                ElevatedButton(
                  onPressed: () async {
                    final cart = Provider.of<CartProvider>(context, listen: false);
                    await cart.addItem(CartItem(foodId: f.id, name: '${f.name} ($size)', image: f.image, price: priceForSize(size), quantity: qty));
                    if (mounted) ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('${f.name} added to cart'), duration: const Duration(milliseconds: 600)));
                    await Future.delayed(const Duration(milliseconds: 600));
                    if (mounted) Navigator.of(this.context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
                  },
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildDessert(List items) {
    final cakes = items.where((f) => (f.image as String).contains('cake')).toList();
    final ice = items.where((f) => (f.image as String).contains('icecream')).toList();

    return Stack(
      children: [
        Positioned.fill(child: Image.asset(_dessertTab == 'cake' ? 'assets/images/cake_menu_background.png' : 'assets/images/icecream_menu_background.png', fit: BoxFit.cover)),
        Column(
          children: [
            const SizedBox(height: 12),
            Center(
              child: Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(label: const Text('Cake'), selected: _dessertTab == 'cake', onSelected: (_) => setState(() => _dessertTab = 'cake')),
                  ChoiceChip(label: const Text('Ice Cream'), selected: _dessertTab == 'icecream', onSelected: (_) => setState(() => _dessertTab = 'icecream')),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  heightFactor: 0.75,
                  child: Card(
                    color: Theme.of(context).cardColor.withOpacity(0.85),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _dessertTab == 'cake' ? cakes.length : ice.length,
                      itemBuilder: (_, idx) {
                        final f = _dessertTab == 'cake' ? cakes[idx] : ice[idx];
                        return _animated(
                          ListTile(
                            title: Center(child: Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                            trailing: _favoriteButton(f.id),
                            onTap: () => _dessertTab == 'cake' ? _showCakeModal(f) : _showIceCreamModal(f),
                          ),
                          idx,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }



  void _showCakeModal(dynamic f) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        String size = 'Slice';
        int qty = 1;
        double priceForSize(String s) {
          if (s == 'Slice') return 200.0;
          return 1200.0; // Whole
        }
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(f.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ChoiceChip(label: const Text('Slice'), selected: size == 'Slice', onSelected: (_) => setState(() => size = 'Slice')),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Whole'), selected: size == 'Whole', onSelected: (_) => setState(() => size = 'Whole')),
                ]),
                const SizedBox(height: 8),
                Text('Price: ${formatCurrency(priceForSize(size) * qty)}'),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(onPressed: () => setState(() => qty = qty > 1 ? qty - 1 : 1), icon: const Icon(Icons.remove)),
                  Text(qty.toString()),
                  IconButton(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add)),
                ]),
                ElevatedButton(
                  onPressed: () async {
                    final cart = Provider.of<CartProvider>(context, listen: false);
                    await cart.addItem(CartItem(foodId: f.id, name: '${f.name} ($size)', image: f.image, price: priceForSize(size), quantity: qty));
                    if (mounted) ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('${f.name} added to cart'), duration: const Duration(milliseconds: 600)));
                    await Future.delayed(const Duration(milliseconds: 600));
                    if (mounted) Navigator.of(this.context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
                  },
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          );
        });
      },
    );
  }



  void _showIceCreamModal(dynamic f) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        String size = 'Single';
        int qty = 1;
        double priceForSize(String s) {
          if (s == 'Single') return 100.0;
          if (s == 'Double') return 180.0;
          return 350.0;
        }
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(f.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ChoiceChip(label: const Text('Single'), selected: size == 'Single', onSelected: (_) => setState(() => size = 'Single')),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Double'), selected: size == 'Double', onSelected: (_) => setState(() => size = 'Double')),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Family'), selected: size == 'Family', onSelected: (_) => setState(() => size = 'Family')),
                ]),
                const SizedBox(height: 8),
                Text('Price: ${formatCurrency(priceForSize(size) * qty)}'),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(onPressed: () => setState(() => qty = qty > 1 ? qty - 1 : 1), icon: const Icon(Icons.remove)),
                  Text(qty.toString()),
                  IconButton(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add)),
                ]),
                ElevatedButton(
                  onPressed: () async {
                    final cart = Provider.of<CartProvider>(context, listen: false);
                    await cart.addItem(CartItem(foodId: f.id, name: '${f.name} ($size)', image: f.image, price: priceForSize(size), quantity: qty));
                    if (mounted) ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('${f.name} added to cart'), duration: const Duration(milliseconds: 600)));
                    await Future.delayed(const Duration(milliseconds: 600));
                    if (mounted) Navigator.of(this.context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
                  },
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildSandwich(List items) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset('assets/images/sandwich_menu_background.png', fit: BoxFit.cover)),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Card(
              color: Theme.of(context).cardColor.withOpacity(0.85),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (_, idx) {
                  final f = items[idx];
                  final price = 150 + (idx * 40);
                  return _animated(
                    ListTile(
                      title: Center(child: Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                      subtitle: Center(child: Text(formatCurrency(price.toDouble()))),
                      trailing: _favoriteButton(f.id),
                      onTap: () => _showSimpleModal(f, price.toDouble()),
                    ),
                    idx,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTacos(List items) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset('assets/images/tacos_menu_background.png', fit: BoxFit.cover)),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Card(
              color: Theme.of(context).cardColor.withOpacity(0.85),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (_, idx) {
                  final f = items[idx];
                  final price = 120 + (idx * 20);
                  return _animated(
                    ListTile(
                      title: Center(child: Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                      subtitle: Center(child: Text(formatCurrency(price.toDouble()))),
                      trailing: _favoriteButton(f.id),
                      onTap: () => _showSimpleModal(f, price.toDouble()),
                    ),
                    idx,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoodles(List items) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset('assets/images/noodles_menu_background.png', fit: BoxFit.cover)),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Card(
              color: Theme.of(context).cardColor.withOpacity(0.85),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (_, idx) {
                  final f = items[idx];
                  return _animated(
                    ListTile(
                      title: Center(child: Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                      trailing: _favoriteButton(f.id),
                      onTap: () => _showNoodlesModal(f),
                    ),
                    idx,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showNoodlesModal(dynamic f) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        String size = 'Small';
        int qty = 1;
        double priceForSize(String s) {
          if (s == 'Small') return 200.0;
          return 350.0; // Large
        }
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(f.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ChoiceChip(label: const Text('Small'), selected: size == 'Small', onSelected: (_) => setState(() => size = 'Small')),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Large'), selected: size == 'Large', onSelected: (_) => setState(() => size = 'Large')),
                ]),
                const SizedBox(height: 8),
                Text('Price: ${formatCurrency(priceForSize(size) * qty)}'),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(onPressed: () => setState(() => qty = qty > 1 ? qty - 1 : 1), icon: const Icon(Icons.remove)),
                  Text(qty.toString()),
                  IconButton(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add)),
                ]),
                ElevatedButton(
                  onPressed: () async {
                    final cart = Provider.of<CartProvider>(context, listen: false);
                    await cart.addItem(CartItem(foodId: f.id, name: '${f.name} ($size)', image: f.image, price: priceForSize(size), quantity: qty));
                    if (mounted) ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('${f.name} added to cart'), duration: const Duration(milliseconds: 600)));
                    await Future.delayed(const Duration(milliseconds: 600));
                    if (mounted) Navigator.of(this.context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
                  },
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildBiryani(List items) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset('assets/images/biryani_menu_background.png', fit: BoxFit.cover)),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Card(
              color: Theme.of(context).cardColor.withOpacity(0.85),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (_, idx) {
                  final f = items[idx];
                  return _animated(
                    ListTile(
                      title: Center(child: Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                      trailing: _favoriteButton(f.id),
                      onTap: () => _showBiryaniModal(f),
                    ),
                    idx,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showBiryaniModal(dynamic f) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        String size = 'Regular';
        int qty = 1;
        double priceForSize(String s) {
          if (s == 'Regular') return 350.0;
          return 800.0; // Family
        }
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(f.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ChoiceChip(label: const Text('Regular'), selected: size == 'Regular', onSelected: (_) => setState(() => size = 'Regular')),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Family'), selected: size == 'Family', onSelected: (_) => setState(() => size = 'Family')),
                ]),
                const SizedBox(height: 8),
                Text('Price: ${formatCurrency(priceForSize(size) * qty)}'),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(onPressed: () => setState(() => qty = qty > 1 ? qty - 1 : 1), icon: const Icon(Icons.remove)),
                  Text(qty.toString()),
                  IconButton(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add)),
                ]),
                ElevatedButton(
                  onPressed: () async {
                    final cart = Provider.of<CartProvider>(context, listen: false);
                    await cart.addItem(CartItem(foodId: f.id, name: '${f.name} ($size)', image: f.image, price: priceForSize(size), quantity: qty));
                    if (mounted) ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('${f.name} added to cart'), duration: const Duration(milliseconds: 600)));
                    await Future.delayed(const Duration(milliseconds: 600));
                    if (mounted) Navigator.of(this.context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
                  },
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildKarahi(List items) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset('assets/images/karahi_menu_background.png', fit: BoxFit.cover)),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Card(
              color: Theme.of(context).cardColor.withOpacity(0.85),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (_, idx) {
                  final f = items[idx];
                  return _animated(
                    ListTile(
                      title: Center(child: Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                      trailing: _favoriteButton(f.id),
                      onTap: () => _showKarahiModal(f),
                    ),
                    idx,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showKarahiModal(dynamic f) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        String size = 'Half';
        int qty = 1;
        double priceForSize(String s) {
          if (s == 'Half') return 600.0;
          return 1100.0; // Full
        }
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(f.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ChoiceChip(label: const Text('Half'), selected: size == 'Half', onSelected: (_) => setState(() => size = 'Half')),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Full'), selected: size == 'Full', onSelected: (_) => setState(() => size = 'Full')),
                ]),
                const SizedBox(height: 8),
                Text('Price: ${formatCurrency(priceForSize(size) * qty)}'),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(onPressed: () => setState(() => qty = qty > 1 ? qty - 1 : 1), icon: const Icon(Icons.remove)),
                  Text(qty.toString()),
                  IconButton(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add)),
                ]),
                ElevatedButton(
                  onPressed: () async {
                    final cart = Provider.of<CartProvider>(context, listen: false);
                    await cart.addItem(CartItem(foodId: f.id, name: '${f.name} ($size)', image: f.image, price: priceForSize(size), quantity: qty));
                    if (mounted) ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('${f.name} added to cart'), duration: const Duration(milliseconds: 600)));
                    await Future.delayed(const Duration(milliseconds: 600));
                    if (mounted) Navigator.of(this.context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
                  },
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildSalad(List items) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset('assets/images/salad_menu_background.png', fit: BoxFit.cover)),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Card(
              color: Theme.of(context).cardColor.withOpacity(0.85),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (_, idx) {
                  final f = items[idx];
                  return _animated(
                    ListTile(
                      title: Center(child: Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                      trailing: _favoriteButton(f.id),
                      onTap: () => _showSaladModal(f),
                    ),
                    idx,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSaladModal(dynamic f) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        String size = 'Small';
        int qty = 1;
        double priceForSize(String s) {
          if (s == 'Small') return 120.0;
          if (s == 'Regular') return 200.0;
          return 320.0;
        }
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(f.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ChoiceChip(label: const Text('Small'), selected: size == 'Small', onSelected: (_) => setState(() => size = 'Small')),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Regular'), selected: size == 'Regular', onSelected: (_) => setState(() => size = 'Regular')),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Large'), selected: size == 'Large', onSelected: (_) => setState(() => size = 'Large')),
                ]),
                const SizedBox(height: 8),
                Text('Price: ${formatCurrency(priceForSize(size) * qty)}'),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(onPressed: () => setState(() => qty = qty > 1 ? qty - 1 : 1), icon: const Icon(Icons.remove)),
                  Text(qty.toString()),
                  IconButton(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add)),
                ]),
                ElevatedButton(
                  onPressed: () async {
                    final cart = Provider.of<CartProvider>(context, listen: false);
                    await cart.addItem(CartItem(foodId: f.id, name: '${f.name} ($size)', image: f.image, price: priceForSize(size), quantity: qty));
                    if (mounted) ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('${f.name} added to cart'), duration: const Duration(milliseconds: 600)));
                    await Future.delayed(const Duration(milliseconds: 600));
                    if (mounted) Navigator.of(this.context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
                  },
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  // Simple modal used for sandwich/tacos and similar single-price items
  void _showSimpleModal(dynamic f, double price) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        int qty = 1;
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(f.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Price: ${formatCurrency(price * qty)}'),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(onPressed: () => setState(() => qty = qty > 1 ? qty - 1 : 1), icon: const Icon(Icons.remove)),
                  Text(qty.toString()),
                  IconButton(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add)),
                ]),
                ElevatedButton(
                  onPressed: () async {
                    final cart = Provider.of<CartProvider>(context, listen: false);
                    await cart.addItem(CartItem(foodId: f.id, name: f.name, image: f.image, price: price, quantity: qty));
                    if (mounted) ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('${f.name} added to cart'), duration: const Duration(milliseconds: 600)));
                    await Future.delayed(const Duration(milliseconds: 600));
                    if (mounted) Navigator.of(this.context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
                  },
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildGrid(List items) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(12, 12, 12, 12 + bottom),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 240,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (_, idx) {
        final f = items[idx];
        return GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FoodDetailScreen(food: f))),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(aspectRatio: 4 / 3, child: Padding(padding: const EdgeInsets.all(6), child: Image.asset(f.image, fit: BoxFit.contain))),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text(formatCurrency(f.price)),
                          ],
                        ),
                      ),
                      _favoriteButton(f.id),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDeals(List items) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final f = items[index];
        return _animated(_dealTile(f), index);
      },
    );
  }

  Widget _dealTile(dynamic f, {bool full = false, double? widthFactor}) {
    if (f == null) return const SizedBox.shrink();
    final id = (f.id ?? -1) as int;
    final isHovered = _hoverDealId == id;

    final content = MouseRegion(
      onEnter: (_) => setState(() => _hoverDealId = id),
      onExit: (_) => setState(() => _hoverDealId = -1),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 160),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: isHovered ? [BoxShadow(color: const Color(0xFF082A2E).withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 6))] : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Container(color: const Color(0xFF082A2E).withOpacity(0.85), padding: const EdgeInsets.all(6), child: Image.asset(f.image, fit: BoxFit.contain, width: full ? double.infinity : null)),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _favoriteButton(id),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.transparent, const Color(0xFF082A2E).withOpacity(0.55)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            formatCurrency((f.price ?? 0).toDouble()),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                            minimumSize: MaterialStateProperty.all(const Size(64, 36)),
                          ),
                          onPressed: () => _showDealModal(f),
                          child: const Text('Add'),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (full) return SizedBox(height: MediaQuery.of(context).size.width * 0.45, child: content);
    if (widthFactor != null) return SizedBox(width: MediaQuery.of(context).size.width * widthFactor, child: content);
    return SizedBox(height: MediaQuery.of(context).size.width * 0.28, child: content);
  }

  void _showDealModal(dynamic f) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        int qty = 1;
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(f.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Image.asset(f.image, height: 120, fit: BoxFit.contain),
                const SizedBox(height: 8),
                Text(formatCurrency(f.price), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(onPressed: () => setState(() => qty = qty > 1 ? qty - 1 : 1), icon: const Icon(Icons.remove)),
                  Text(qty.toString()),
                  IconButton(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add)),
                ]),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final cart = Provider.of<CartProvider>(context, listen: false);
                    await cart.addItem(CartItem(foodId: f.id, name: f.name, image: f.image, price: f.price.toDouble(), quantity: qty));
                    if (mounted) ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('${f.name} added to cart'), duration: const Duration(milliseconds: 600)));
                    await Future.delayed(const Duration(milliseconds: 600));
                    if (mounted) Navigator.of(this.context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
                  },
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
