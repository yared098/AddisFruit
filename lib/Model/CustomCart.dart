class CustomCart {
  final int id;
  final String? name;
  final int quantity;
  final double kilo;

  CustomCart({
    required this.id,
    this.name,
    required this.quantity,
    required this.kilo,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name ?? '',
      'quantity': quantity,
      'kilo': kilo,
    };
  }

  factory CustomCart.fromJson(Map<String, dynamic> json) {
    return CustomCart(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      kilo: (json['kilo'] is int) ? (json['kilo'] as int).toDouble() : json['kilo'],
    );
  }
}
