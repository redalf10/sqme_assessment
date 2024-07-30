class Product {
  final int? id;
  final String name;
  final double price;
  final String description;
  int qty; // Make this non-final to allow updates

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.qty,
  });

  void updateQuantity(int newQty) {
    qty = newQty;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'qty': qty,
    };
  }

  Product copyWith({
    int? id,
    String? name,
    double? price,
    String? description,
    int? qty,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      qty: qty ?? this.qty,
    );
  }
}
