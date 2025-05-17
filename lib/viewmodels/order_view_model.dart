// order_view_model.dart
import 'package:addisfruit/Model/order_model.dart';
import 'package:flutter/material.dart';


class OrderViewModel extends ChangeNotifier {
  final List<Order> _orders = [
    Order(
      customerName: "John Doe",
      address: "Bole, Addis Ababa",
      items: ["Apple", "Banana"],
      totalPrice: 150,
      deliveryFee: 20,
      status: "On the way",
      estimatedArrival: "2 hrs",
    ),
    Order(
      customerName: "Jane Smith",
      address: "Kazanchis",
      items: ["Mango", "Grapes"],
      totalPrice: 180,
      deliveryFee: 25,
      status: "Preparing",
      estimatedArrival: "3 hrs",
    ),
  ];

  List<Order> get orders => _orders;
}