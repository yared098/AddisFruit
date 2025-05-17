class CartItem {
  final String name;
  final String image;
  int quantity;
  int kilo;

  CartItem({
    required this.name,
    required this.image,
    this.quantity = 1,
    required this.kilo,
  });
factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      image: json['image'],
      name: json['name'],
      quantity: json['quantity'],
      kilo: json['kilo'],
    );
  }

  
}


