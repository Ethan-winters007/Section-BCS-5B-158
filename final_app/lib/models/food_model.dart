class Food {
  final int? id;
  final String name;
  final String category;
  final String image;
  final double price;
  final String description;
  final double rating;

  Food({
    this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.price,
    this.description = '',
    this.rating = 0.0,
  });

  factory Food.fromMap(Map<String, dynamic> map) => Food(
        id: map['id'] as int?,
        name: map['name'] as String,
        category: (map['category'] ?? '') as String,
        image: map['image'] as String,
        price: (map['price'] as num).toDouble(),
        description: (map['description'] ?? '') as String,
        rating: (map['rating'] ?? 0.0) is int
            ? (map['rating'] as int).toDouble()
            : (map['rating'] ?? 0.0) as double,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'image': image,
        'price': price,
        'description': description,
        'rating': rating,
      };
}
