import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../models/category_model.dart';

class ProductProvider extends ChangeNotifier {
  final List<Category> _categories = [
    Category(id: 'deals', name: 'Deals', image: 'assets/images/deals_icon.png'),
    Category(id: 'pizza', name: 'Pizza', image: 'assets/images/pizza.png'),
    Category(id: 'burger', name: 'Burger', image: 'assets/images/burger.png'),
    Category(id: 'fries', name: 'Fries', image: 'assets/images/fries.png'),
    Category(id: 'drink', name: 'Drinks', image: 'assets/images/drinks.png'),
    Category(
      id: 'biryani',
      name: 'Biryani',
      image: 'assets/images/biryani.png',
    ),
    Category(id: 'karahi', name: 'Karahi', image: 'assets/images/karahi.png'),
    Category(id: 'dessert', name: 'Dessert', image: 'assets/images/cake.png'),
    Category(id: 'salad', name: 'Salad', image: 'assets/images/salad.png'),
    Category(
      id: 'sandwich',
      name: 'Sandwich',
      image: 'assets/images/sandwich.png',
    ),
    Category(
      id: 'noodles',
      name: 'Noodles',
      image: 'assets/images/noodles.png',
    ),
    Category(id: 'tacos', name: 'Tacos', image: 'assets/images/tacos.png'),
  ];

  List<Category> get categories => List.unmodifiable(_categories);

  final List<Food> _foods = [
    Food(
      id: 1,
      name: 'Margherita',
      category: 'pizza',
      image: 'assets/images/pizza.png',
      price: 6.5,
      description: 'Classic cheese and tomato pizza with fresh basil.',
      rating: 4.5,
    ),
    Food(
      id: 2,
      name: 'Pepperoni',
      category: 'pizza',
      image: 'assets/images/pizza.png',
      price: 7.5,
      description: 'Loaded with spicy pepperoni and melted cheese.',
      rating: 4.7,
    ),
    // Additional pizza flavors
    Food(id: 100, name: 'Hawaiian', category: 'pizza', image: 'assets/images/pizza.png', price: 8.0, description: 'Ham and pineapple.', rating: 4.1),
    Food(id: 101, name: 'BBQ Chicken', category: 'pizza', image: 'assets/images/pizza.png', price: 8.5, description: 'Smoky BBQ chicken.', rating: 4.4),
    Food(id: 102, name: 'Veggie', category: 'pizza', image: 'assets/images/pizza.png', price: 7.0, description: 'Loaded with seasonal veggies.', rating: 4.0),
    Food(id: 103, name: 'Four Cheese', category: 'pizza', image: 'assets/images/pizza.png', price: 9.0, description: 'Mozzarella, cheddar, parmesan, gouda.', rating: 4.6),
    Food(id: 104, name: 'Meat Lovers', category: 'pizza', image: 'assets/images/pizza.png', price: 9.5, description: 'Pepperoni, ham, sausage, bacon.', rating: 4.5),
    Food(id: 105, name: 'Supreme', category: 'pizza', image: 'assets/images/pizza.png', price: 9.0, description: 'Veggies + meats.', rating: 4.3),
    Food(id: 106, name: 'Mexican', category: 'pizza', image: 'assets/images/pizza.png', price: 8.5, description: 'Spicy toppings and jalapenos.', rating: 4.2),
    Food(id: 107, name: 'Seafood', category: 'pizza', image: 'assets/images/pizza.png', price: 10.0, description: 'Prawns and calamari.', rating: 4.1),
    Food(
      id: 3,
      name: 'Classic Burger',
      category: 'burger',
      image: 'assets/images/burger.png',
      price: 5.0,
      description: 'Juicy beef patty with lettuce, tomato and our special sauce.',
      rating: 4.2,
    ),
    // Add many burgers (10 total)
    Food(id: 110, name: 'BBQ Burger', category: 'burger', image: 'assets/images/burger.png', price: 6.0, description: 'Smoky BBQ sauce with melted cheese.', rating: 4.3),
    Food(id: 111, name: 'Cheese Burst', category: 'burger', image: 'assets/images/burger.png', price: 6.5, description: 'Extra cheesy patty.', rating: 4.4),
    Food(id: 112, name: 'Mushroom Swiss', category: 'burger', image: 'assets/images/burger.png', price: 6.8, description: 'Sautéed mushrooms and Swiss cheese.', rating: 4.2),
    Food(id: 113, name: 'Spicy Jalapeno', category: 'burger', image: 'assets/images/burger.png', price: 6.2, description: 'Kick of heat with jalapenos.', rating: 4.1),
    Food(id: 114, name: 'Veggie Deluxe', category: 'burger', image: 'assets/images/burger.png', price: 5.5, description: 'Grilled veggie patty.', rating: 4.0),
    Food(id: 115, name: 'Double Patty', category: 'burger', image: 'assets/images/burger.png', price: 7.5, description: 'Two beef patties.', rating: 4.6),
    Food(id: 116, name: 'Chicken Burger', category: 'burger', image: 'assets/images/burger.png', price: 6.0, description: 'Grilled chicken patty.', rating: 4.2),
    Food(id: 117, name: 'Teriyaki Burger', category: 'burger', image: 'assets/images/burger.png', price: 6.8, description: 'Sweet teriyaki glaze.', rating: 4.1),
    Food(id: 118, name: 'Classic Bacon', category: 'burger', image: 'assets/images/burger.png', price: 7.0, description: 'Applewood smoked bacon.', rating: 4.5),
    Food(id: 119, name: 'Black Pepper', category: 'burger', image: 'assets/images/burger.png', price: 6.3, description: 'Fresh cracked pepper seasoning.', rating: 4.0),
    Food(id: 4, name: 'Fries', category: 'fries', image: 'assets/images/fries.png', price: 2.5, description: 'Crispy golden fries with seasoning.', rating: 4.0),
    Food(id: 13, name: 'Cheese Fries', category: 'fries', image: 'assets/images/fries.png', price: 3.5, description: 'Fries smothered in cheese sauce.', rating: 4.1),
    // More fries flavors
    Food(id: 120, name: 'Garlic Fries', category: 'fries', image: 'assets/images/fries.png', price: 3.0, description: 'Garlic butter tossed fries.', rating: 4.2),
    Food(id: 121, name: 'Truffle Fries', category: 'fries', image: 'assets/images/fries.png', price: 4.0, description: 'Truffle oil and parmesan.', rating: 4.5),
    Food(id: 122, name: 'Loaded Fries', category: 'fries', image: 'assets/images/fries.png', price: 4.5, description: 'Topped with cheese, bacon and sour cream.', rating: 4.6),
    Food(id: 123, name: 'Chili Cheese Fries', category: 'fries', image: 'assets/images/fries.png', price: 4.2, description: 'Spicy chili topped fries.', rating: 4.3),
    Food(id: 124, name: 'Herb Fries', category: 'fries', image: 'assets/images/fries.png', price: 3.0, description: 'Herbed seasoning.', rating: 4.0),
    Food(id: 125, name: 'Sweet Potato Fries', category: 'fries', image: 'assets/images/fries.png', price: 3.8, description: 'Baked sweet potato fries.', rating: 4.2),
    Food(
      id: 5,
      name: 'Coke',
      category: 'drink',
      image: 'assets/images/drinks.png',
      price: 1.5,
      description: 'Chilled fizzy drink.',
      rating: 3.8,
    ),
    Food(
      id: 14,
      name: 'Pepsi',
      category: 'drink',
      image: 'assets/images/drinks.png',
      price: 1.5,
      description: 'Chilled fizzy drink.',
      rating: 3.7,
    ),
    // More drinks
    Food(
      id: 130,
      name: 'Sprite',
      category: 'drink',
      image: 'assets/images/drinks.png',
      price: 1.5,
      description: 'Lemon-lime refresher.',
      rating: 3.9,
    ),
    Food(
      id: 131,
      name: 'Fanta',
      category: 'drink',
      image: 'assets/images/drinks.png',
      price: 1.5,
      description: 'Fruit-flavored fizzy drink.',
      rating: 3.6,
    ),
    Food(
      id: 132,
      name: 'Iced Tea',
      category: 'drink',
      image: 'assets/images/drinks.png',
      price: 2.0,
      description: 'Chilled brewed tea.',
      rating: 4.0,
    ),
    Food(
      id: 6,
      name: 'Chicken Biryani',
      category: 'biryani',
      image: 'assets/images/biryani.png',
      price: 8.0,
      description: 'Aromatic basmati rice with tender chicken and spices.',
      rating: 4.6,
    ),
    Food(id: 180, name: 'Mutton Biryani', category: 'biryani', image: 'assets/images/biryani.png', price: 10.0, description: 'Slow-cooked mutton in aromatic rice.', rating: 4.7),
    Food(id: 181, name: 'Vegetable Biryani', category: 'biryani', image: 'assets/images/biryani.png', price: 7.0, description: 'Fragrant rice with mixed vegetables.', rating: 4.0),
    Food(id: 182, name: 'Prawn Biryani', category: 'biryani', image: 'assets/images/biryani.png', price: 11.0, description: 'Seafood braised biryani.', rating: 4.3),
    Food(id: 183, name: 'Egg Biryani', category: 'biryani', image: 'assets/images/biryani.png', price: 6.5, description: 'Simple egg biryani with spices.', rating: 4.0),
    Food(
      id: 7,
      name: 'Mutton Karahi',
      category: 'karahi',
      image: 'assets/images/karahi.png',
      price: 12.0,
      description: 'Spicy and rich mutton curry cooked with tomatoes and spices.',
      rating: 4.8,
    ),
    Food(id: 190, name: 'Chicken Karahi', category: 'karahi', image: 'assets/images/karahi.png', price: 9.0, description: 'Classic chicken karahi with fresh spices.', rating: 4.5),
    Food(id: 191, name: 'Vegetable Karahi', category: 'karahi', image: 'assets/images/karahi.png', price: 7.5, description: 'Sizzling mixed vegetables with karahi masala.', rating: 4.0),
    Food(
      id: 8,
      name: 'Chocolate Cake',
      category: 'dessert',
      image: 'assets/images/cake.png',
      price: 4.0,
      description: 'Decadent chocolate layers with rich frosting.',
      rating: 4.4,
    ),
    Food(
      id: 9,
      name: 'Ice Cream',
      category: 'dessert',
      image: 'assets/images/icecream.png',
      price: 3.0,
    ),
    // More desserts
    Food(id: 140, name: 'Vanilla Parfait', category: 'dessert', image: 'assets/images/cake.png', price: 3.5, description: 'Creamy vanilla parfait with berries.', rating: 4.2),
    Food(id: 141, name: 'Brownie', category: 'dessert', image: 'assets/images/cake.png', price: 3.8, description: 'Fudgy chocolate brownie.', rating: 4.3),
    Food(id: 142, name: 'Cheesecake', category: 'dessert', image: 'assets/images/cake.png', price: 4.5, description: 'Classic creamy cheesecake.', rating: 4.4),
    Food(id: 143, name: 'Fruit Tart', category: 'dessert', image: 'assets/images/cake.png', price: 3.9, description: 'Seasonal fruit tart.', rating: 4.1),
    Food(id: 144, name: 'Tiramisu', category: 'dessert', image: 'assets/images/cake.png', price: 4.8, description: 'Espresso soaked delight.', rating: 4.5),
    Food(
      id: 10,
      name: 'Fresh Salad',
      category: 'salad',
      image: 'assets/images/salad.png',
      price: 4.5,
    ),
    Food(id: 200, name: 'Caesar Salad', category: 'salad', image: 'assets/images/salad.png', price: 5.0, description: 'Romaine, parmesan and Caesar dressing.', rating: 4.2),
    Food(id: 201, name: 'Greek Salad', category: 'salad', image: 'assets/images/salad.png', price: 5.5, description: 'Cucumber, olives, feta and tomatoes.', rating: 4.3),
    Food(id: 202, name: 'Fruit Salad', category: 'salad', image: 'assets/images/salad.png', price: 4.0, description: 'Fresh seasonal fruits.', rating: 4.1),
    Food(
      id: 11,
      name: 'Club Sandwich',
      category: 'sandwich',
      image: 'assets/images/sandwich.png',
      price: 5.5,
    ),
    // More sandwiches
    Food(id: 150, name: 'Veg Club', category: 'sandwich', image: 'assets/images/sandwich.png', price: 5.0, description: 'Grilled veggie sandwich with lettuce and tomato.', rating: 4.0),
    Food(id: 151, name: 'Chicken Club', category: 'sandwich', image: 'assets/images/sandwich.png', price: 6.0, description: 'Grilled chicken, bacon and cheese.', rating: 4.3),
    Food(id: 152, name: 'Tuna Sandwich', category: 'sandwich', image: 'assets/images/sandwich.png', price: 5.5, description: 'Flaked tuna, mayo and lettuce.', rating: 4.1),
    Food(id: 153, name: 'Grilled Cheese', category: 'sandwich', image: 'assets/images/sandwich.png', price: 4.5, description: 'Melted cheese between buttery toast.', rating: 4.2),
    // Deals
    Food(
      id: 21,
      name: 'Deal 1',
      category: 'deals',
      image: 'assets/images/deal_1.png',
      price: 700.0,
      description: 'Combo deal 1',
    ),
    Food(
      id: 22,
      name: 'Deal 2',
      category: 'deals',
      image: 'assets/images/deal_2.png',
      price: 1400.0,
      description: 'Combo deal 2',
    ),
    Food(
      id: 23,
      name: 'Deal 3',
      category: 'deals',
      image: 'assets/images/deal_3.png',
      price: 400.0,
      description: 'Combo deal 3',
    ),
    Food(
      id: 24,
      name: 'Deal 4',
      category: 'deals',
      image: 'assets/images/deal_4.png',
      price: 500.0,
      description: 'Combo deal 4',
    ),
    Food(
      id: 25,
      name: 'Deal 6',
      category: 'deals',
      image: 'assets/images/deal_6.png',
      price: 700.0,
      description: 'Combo deal 6',
    ),
    Food(
      id: 26,
      name: 'Deal 8',
      category: 'deals',
      image: 'assets/images/deal_8.png',
      price: 700.0,
      description: 'Combo deal 8',
    ),
    // Noodles
    Food(
      id: 12,
      name: 'Chicken Noodles',
      category: 'noodles',
      image: 'assets/images/noodles.png',
      price: 6.0,
      description: 'Stir fried noodles with chicken and veggies.',
      rating: 4.3,
    ),
    Food(
      id: 13,
      name: 'Veg Noodles',
      category: 'noodles',
      image: 'assets/images/noodles.png',
      price: 5.0,
      description: 'Mixed vegetables and savory sauce.',
      rating: 4.0,
    ),
    // More noodles
    Food(id: 160, name: 'Schezwan Noodles', category: 'noodles', image: 'assets/images/noodles.png', price: 6.5, description: 'Spicy Schezwan tossed noodles.', rating: 4.1),
    Food(id: 161, name: 'Garlic Noodles', category: 'noodles', image: 'assets/images/noodles.png', price: 6.0, description: 'Garlic butter flavored noodles.', rating: 4.0),
    Food(id: 162, name: 'Chow Mein', category: 'noodles', image: 'assets/images/noodles.png', price: 6.2, description: 'Crispy tossed chow mein with veggies.', rating: 4.2),
    // Tacos
    Food(
      id: 14,
      name: 'Beef Tacos',
      category: 'tacos',
      image: 'assets/images/tacos.png',
      price: 4.5,
      description: 'Spiced beef with fresh salsa.',
      rating: 4.1,
    ),
    Food(
      id: 15,
      name: 'Chicken Tacos',
      category: 'tacos',
      image: 'assets/images/tacos.png',
      price: 4.0,
      description: 'Grilled chicken with pico de gallo.',
      rating: 4.2,
    ),
    // More tacos
    Food(id: 170, name: 'Fish Tacos', category: 'tacos', image: 'assets/images/tacos.png', price: 5.0, description: 'Crispy fish with slaw and lime.', rating: 4.3),
    Food(id: 171, name: 'Veg Tacos', category: 'tacos', image: 'assets/images/tacos.png', price: 4.0, description: 'Seasonal veggies with chipotle sauce.', rating: 4.0),
    Food(id: 172, name: 'Shrimp Tacos', category: 'tacos', image: 'assets/images/tacos.png', price: 5.5, description: 'Spiced shrimp with crema.', rating: 4.4),
  ];

  List<Food> get foods => List.unmodifiable(_foods);

  List<Food> foodsByCategory(String categoryId) {
    if (categoryId == 'all') return foods;
    return _foods.where((f) => f.category == categoryId).toList();
  }

  List<Food> search(String query) {
    return _foods
        .where((f) => f.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
