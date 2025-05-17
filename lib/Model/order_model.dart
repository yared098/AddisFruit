// order_model.dart
class Order {
  final String customerName;
  final String address;
  final List<String> items;
  final double totalPrice;
  final double deliveryFee;
  final String status;
  final String estimatedArrival;

  Order({
    required this.customerName,
    required this.address,
    required this.items,
    required this.totalPrice,
    required this.deliveryFee,
    required this.status,
    required this.estimatedArrival,
  });
}