class CartItem {
  final int? id;
  final int foodId;
  final String name;
  final String image;
  final double price;
  int quantity;

  CartItem({
    this.id,
    required this.foodId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) => CartItem(
    id: map['id'] as int?,
    foodId: map['foodId'] as int,
    name: map['name'] as String,
    image: map['image'] as String,
    price: (map['price'] as num).toDouble(),
    quantity: map['quantity'] as int,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'foodId': foodId,
    'name': name,
    'image': image,
    'price': price,
    'quantity': quantity,
  };
}
