import 'dart:ui';
import 'package:addisfruit/Model/fruit_model.dart';
import 'package:addisfruit/viewmodels/CartViewModel.dart';
import 'package:addisfruit/viewmodels/fruit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductShowWidget extends StatelessWidget {
  final List<Fruit> filteredFruits;
  final bool isWideScreen;
  final FruitViewModel viewModel;

  const ProductShowWidget({
    super.key,
    required this.filteredFruits,
    required this.isWideScreen,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWideScreen ? 8 : 3,
        crossAxisSpacing: 4, // Reduced from 8
mainAxisSpacing: 4,  // Reduced from 8
        childAspectRatio: 0.8,
      ),
      itemCount: filteredFruits.length,
      itemBuilder: (context, index) {
        final fruit = filteredFruits[index];

        return GestureDetector(
          onTap: () => viewModel.selectFruit(fruit),
          onDoubleTap: () {
            Provider.of<CartViewModel>(
              context,
              listen: false,
            ).addItem(fruit.name, fruit.image);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(2, 2),
                ),
              ],
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                splashColor: Colors.green.withOpacity(0.1),
                highlightColor: Colors.green.withOpacity(0.05),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          fruit.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Icon(Icons.broken_image, color: Colors.red)),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                      ),
                      child: Text(
                        fruit.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
