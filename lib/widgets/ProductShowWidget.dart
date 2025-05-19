import 'dart:ui';
import 'package:addisfruit/Model/fruit_model.dart';
import 'package:addisfruit/viewmodels/CartViewModel.dart';
import 'package:addisfruit/viewmodels/fruit_view_model.dart';
import 'package:addisfruit/viewmodels/theme_provider.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),  // reduced padding
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWideScreen ? 8 : 3,
        crossAxisSpacing: 6, // slightly increased spacing for clarity
        mainAxisSpacing: 6,
        childAspectRatio: 0.75, // a bit taller for better image focus
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
              color: isDark ? const Color.fromARGB(255, 128, 138, 135) : const Color.fromARGB(255, 226, 223, 223),
              borderRadius: BorderRadius.circular(8), // smaller radius for sharper edges
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black87 : const Color.fromARGB(255, 235, 227, 227),
                  blurRadius: 4, // softer shadow
                  offset: const Offset(1, 2),
                ),
              ],
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                splashColor: Colors.green.withOpacity(0.15),
                highlightColor: Colors.green.withOpacity(0.08),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
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
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6), // smaller padding
                      decoration: BoxDecoration(
                        color: isDark ? Colors.green.shade900 : Colors.green.shade50,
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                      ),
                      child: Text(
                        fruit.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12, // smaller font size
                          color: isDark ? Colors.green.shade300 : Colors.green.shade700,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
