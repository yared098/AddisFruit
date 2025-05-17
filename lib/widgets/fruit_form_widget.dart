import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/fruit_view_model.dart';

class FruitFormWidget extends StatelessWidget {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FruitViewModel>(context);
    final fruit = viewModel.selectedFruit;

    // Set current values (consider managing with StatefulWidget for dynamic form)
    quantityController.text = viewModel.quantity;
    amountController.text = viewModel.amount;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: Colors.green.shade100, width: 1.5),
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
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 14),

              // Fruit image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child:
                      fruit?.image != null && fruit!.image.isNotEmpty
                          ? Image.network(
                            fruit.image,
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    imagePlaceholder(context),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return SizedBox(
                                height: 100,
                                width: 140,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                          )
                          : imagePlaceholder(context),
                ),
              ),
              const SizedBox(height: 18),

              // Quantity input
              buildTextField(
                controller: quantityController,
                label: "Quantity",
                onChanged: viewModel.setQuantity,
                context: context,
              ),
              const SizedBox(height: 12),

              // Amount input
              buildTextField(
                controller: amountController,
                label: "Amount",
                onChanged: viewModel.setAmount,
                context: context,
              ),
              const SizedBox(height: 20),

              // Button Row
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
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
                        fruit == null ? "Add" : "Add toCart",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  if (fruit != null) ...[
                    const SizedBox(width: 10),
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
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green.shade700, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green.shade600, width: 1.8),
        ),
        filled: true,
        fillColor: Colors.green.shade50.withOpacity(0.2),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
      ),
    );
  }

  Widget imagePlaceholder(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
      ),
    );
  }
}
