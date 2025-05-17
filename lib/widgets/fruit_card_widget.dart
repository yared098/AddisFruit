import 'package:flutter/material.dart';
import '../Model/fruit_model.dart';

class FruitCardWidget extends StatelessWidget {
  final Fruit fruit;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  const FruitCardWidget({
    Key? key,
    required this.fruit,
    required this.onTap,
    required this.onDoubleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Single tap to select
      onDoubleTap: onDoubleTap, // Double tap to add to cart
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              fruit.image,
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Icon(Icons.check_circle, color: Colors.green.shade700, size: 28),
          ),
        ],
      ),
    );
  }
}
