import 'package:addisfruit/viewmodels/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/fruit_view_model.dart';


class FruitFormWidget extends StatelessWidget {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FruitViewModel>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fruit = viewModel.selectedFruit;

    // Set current values (consider StatefulWidget if dynamic)
    quantityController.text = viewModel.quantity;
    amountController.text = viewModel.amount;

    final isDark = themeProvider.isDarkMode;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;
    final shadowColor = isDark ? Colors.black54 : Colors.green.withOpacity(0.1);
    final textColor = isDark ? Colors.greenAccent.shade400 : Colors.green.shade800;

    return SafeArea(
      child: SingleChildScrollView(
        // Removed padding here for tighter layout
        child: Container(
          // Reduced padding to 12
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: shadowColor!,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: textColor.withOpacity(0.3), width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                fruit != null ? fruit.name : "New Fruit",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12), // Reduced spacing

              // Fruit image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: fruit?.image != null && fruit!.image.isNotEmpty
                      ? Image.network(
                          fruit.image,
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              imagePlaceholder(context, isDark),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              height: 100,
                              width: 140,
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                        )
                      : imagePlaceholder(context, isDark),
                ),
              ),
              const SizedBox(height: 14), // Reduced spacing

              // Quantity input
              buildTextField(
                controller: quantityController,
                label: "Quantity",
                onChanged: viewModel.setQuantity,
                context: context,
                isDark: isDark,
                textColor: textColor,
              ),
              const SizedBox(height: 10), // Reduced spacing

              // Amount input
              buildTextField(
                controller: amountController,
                label: "Amount",
                onChanged: viewModel.setAmount,
                context: context,
                isDark: isDark,
                textColor: textColor,
              ),
              const SizedBox(height: 16), // Reduced spacing

              // Button Row
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.greenAccent.shade400 : Colors.green.shade600,
                        foregroundColor: isDark ? Colors.black87 : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        viewModel.saveFruit(
                          fruit?.name ?? "New Fruit",
                          fruit?.image ?? "",
                          fruit?.icon ?? "",
                        );
                      },
                      child: Text(
                        fruit == null ? "Add" : "Add to Cart",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  if (fruit != null) ...[
                    const SizedBox(width: 8), // Reduced spacing
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade700,
                          side: BorderSide(color: Colors.red.shade700),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => viewModel.deleteFruit(fruit),
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required void Function(String) onChanged,
    required BuildContext context,
    required bool isDark,
    required Color textColor,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      style: TextStyle(fontSize: 14, color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor, width: 1.8),
        ),
        filled: true,
        fillColor: isDark ? Colors.grey.shade800 : Colors.green.shade50.withOpacity(0.2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
    );
  }

  Widget imagePlaceholder(BuildContext context, bool isDark) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          size: 40,
          color: isDark ? Colors.grey.shade400 : Colors.grey,
        ),
      ),
    );
  }
}
