import 'package:addisfruit/Model/CustomCart.dart';
import 'package:addisfruit/viewmodels/CustomCart.dart';
import 'package:addisfruit/viewmodels/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage>
    with SingleTickerProviderStateMixin {
  final _productController = TextEditingController();
  final _quantityController = TextEditingController();
  final _kiloController = TextEditingController();

  bool _showForm = false;
  Set<int> _selectedIndexes = {};

  @override
  void dispose() {
    _productController.dispose();
    _quantityController.dispose();
    _kiloController.dispose();
    super.dispose();
  }

  void _addOrder(BuildContext context) {
    final provider = Provider.of<CustomCartProvider>(context, listen: false);

    final product = _productController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final kilo = double.tryParse(_kiloController.text.trim()) ?? 0;

    if (product.isEmpty || quantity <= 0 || kilo <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid values')),
      );
      return;
    }

    final newId = provider.list.isNotEmpty
        ? provider.list.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1
        : 1;

    final cart = CustomCart(
      id: newId,
      name: product,
      quantity: quantity,
      kilo: kilo,
    );

    provider.addCustomCart(cart);

    _productController.clear();
    _quantityController.clear();
    _kiloController.clear();

    setState(() => _showForm = false);
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CustomCartProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;

    final cardColor = isDark ? Colors.grey[900] : Colors.white;
    final shadowColor = isDark ? Colors.black54 : Colors.grey.withOpacity(0.2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: isDark ? Colors.teal.shade700 : Colors.green,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: cart.list.isEmpty
                ? Center(
                    child: Text(
                      'No orders yet',
                      style: TextStyle(
                        fontSize: 20,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: cart.list.length,
                    itemBuilder: (context, index) {
                      final item = cart.list[index];
                      final isSelected = _selectedIndexes.contains(index);

                      return Card(
                        color: cardColor,
                        shadowColor: shadowColor,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedIndexes.remove(index);
                              } else {
                                _selectedIndexes.add(index);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: isDark
                                      ? Colors.teal.shade700
                                      : Colors.green.shade100,
                                  child: Text(
                                    item.name?[0].toUpperCase() ?? '?',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name ?? 'Unknown',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Quantity: ${item.quantity}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isDark
                                              ? Colors.white70
                                              : Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        'Kilo: ${item.kilo.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isDark
                                              ? Colors.white70
                                              : Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Checkbox(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  activeColor:
                                      isDark ? Colors.tealAccent : Colors.green,
                                  value: isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        _selectedIndexes.add(index);
                                      } else {
                                        _selectedIndexes.remove(index);
                                      }
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Colors.red.shade400),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Item'),
                                        content: const Text(
                                            'Are you sure you want to delete this item?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Provider.of<CustomCartProvider>(
                                                      context,
                                                      listen: false)
                                                  .deleteCustomCart(item.id);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Delete',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          /// Sliding Form
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            right: _showForm ? 0 : -screenWidth,
            top: 0,
            bottom: 0,
            width: screenWidth > 600 ? 500 : screenWidth * 0.9,
            child: _buildFormCard(context, isOverlay: true),
          ),
        ],
      ),
      floatingActionButton: _showForm
          ? null
          : FloatingActionButton(
              onPressed: () => setState(() => _showForm = true),
              backgroundColor: isDark ? Colors.teal : Colors.green,
              child: const Icon(Icons.add, color: Colors.white),
            ),
      bottomNavigationBar: _selectedIndexes.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(12),
              child: OutlinedButton.icon(
                onPressed: () {
                  final selectedItems =
                      _selectedIndexes.map((index) => cart.list[index]).toList();

                  // TODO: Place order logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('${selectedItems.length} items placed!')),
                  );

                  setState(() => _selectedIndexes.clear());
                },
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text('Place Order Now'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isDark ? Colors.tealAccent.shade700 : Colors.green,
                    width: 2,
                  ),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildFormCard(BuildContext context, {bool isOverlay = false}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final primaryColor = isDark ? Colors.grey[900] : Colors.white;
    final buttonColor = isDark ? Colors.tealAccent.shade700 : Colors.green;

    return Material(
      elevation: 10,
      color: primaryColor,
      borderRadius: isOverlay
          ? const BorderRadius.only(
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            )
          : BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Text(
              'Add Custom Order',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(_productController, 'Product Name'),
            const SizedBox(height: 12),
            _buildTextField(_quantityController, 'Quantity', isNumber: true),
            const SizedBox(height: 12),
            _buildTextField(_kiloController, 'Kilo', isDecimal: true),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Order'),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _addOrder(context),
            ),
            if (isOverlay)
              TextButton(
                onPressed: () => setState(() => _showForm = false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: isDark ? Colors.tealAccent : Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
    bool isDecimal = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isDecimal
          ? const TextInputType.numberWithOptions(decimal: true)
          : (isNumber ? TextInputType.number : TextInputType.text),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
