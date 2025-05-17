import 'dart:ui';
import 'package:addisfruit/Model/fruit_model.dart';
import 'package:addisfruit/viewmodels/CartViewModel.dart';
import 'package:addisfruit/viewmodels/fruit_view_model.dart';
import 'package:addisfruit/viewmodels/theme_provider.dart'; // Add this import
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    final isDark = themeProvider.isDarkMode;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWideScreen ? 8 : 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
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
              color: isDark ? Colors.grey[850] : Colors.white, // Background color adapts
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black54 : Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(2, 2),
                ),
              ],
              border: Border.all(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
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
                        color: isDark ? Colors.green.shade900 : Colors.green.shade50, // Adapted container bg
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                      ),
                      child: Text(
                        fruit.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: isDark ? Colors.green.shade300 : Colors.green, // Adapted text color
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
