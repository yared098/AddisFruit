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

    // Set current text values (avoid setting every build, consider using stateful approach if needed)
    quantityController.text = viewModel.quantity;
    amountController.text = viewModel.amount;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          top: 24,
          left: 20,
          right: 20,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: Colors.green.shade200, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                fruit != null ? fruit.name : "New Fruit",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.green.shade800,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 20),

              // Fruit image with rounded corners & shadow
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: fruit?.image != null && fruit!.image.isNotEmpty
                      ? Image.network(
                          fruit.image,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.grey.shade200,
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              color: Colors.grey.shade300,
                              child: const Center(child: Icon(Icons.broken_image, size: 60, color: Colors.grey)),
                            );
                          },
                        )
                      : Container(
                          height: 180,
                          width: double.infinity,
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Quantity input
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Quantity",
                  labelStyle: TextStyle(color: Colors.green.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.green.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.green.shade600, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onChanged: viewModel.setQuantity,
              ),
              const SizedBox(height: 18),

              // Amount input
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Amount",
                  labelStyle: TextStyle(color: Colors.green.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.green.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.green.shade600, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onChanged: viewModel.setAmount,
              ),
              const SizedBox(height: 28),

              // Buttons row
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 5,
                      ),
                      onPressed: () {
                        viewModel.saveFruit(
                          fruit?.name ?? "New Fruit",
                          fruit?.image ?? "",
                          fruit?.icon ?? "",
                        );
                      },
                      child: Text(
                        fruit == null ? "Add Fruit" : "Update Fruit",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (fruit != null) ...[
                    const SizedBox(width: 14),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade700,
                          side: BorderSide(color: Colors.red.shade700, width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () => viewModel.deleteFruit(fruit),
                        child: const Text(
                          "Delete",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
}
