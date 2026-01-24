class CartItem {
  final String id;
  final String name;
  final double price;
  final int qty;
  final String image;
  final String weight;
  final String? netWeight;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.qty,
    required this.image,
    required this.weight,
    this.netWeight,
  });

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    int? qty,
    String? image,
    String? weight,
    String? netWeight,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      qty: qty ?? this.qty,
      image: image ?? this.image,
      weight: weight ?? this.weight,
      netWeight: netWeight ?? this.netWeight,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'qty': qty,
      'image': image,
      'weight': weight,
      'netWeight': netWeight,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      qty: map['qty']?.toInt() ?? 0,
      image: map['image'] ?? '',
      weight: map['weight'] ?? '',
      netWeight: map['netWeight'],
    );
  }
}
