import 'package:addisfruit/viewmodels/CartViewModel.dart';
import 'package:addisfruit/views/CartPage.dart';
import 'package:addisfruit/views/order_history_page.dart';
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

  @override
  void dispose() {
    _productController.dispose();
    _quantityController.dispose();
    _kiloController.dispose();
    super.dispose();
  }

  void _addOrder(BuildContext context) {
    final product = _productController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final kilo = double.tryParse(_kiloController.text.trim()) ?? 0;

    if (product.isEmpty || quantity <= 0 || kilo <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid values')),
      );
      return;
    }

    // Add to cart logic
    // Provider.of<CartViewModel>(context, listen: false).addItem(product, quantity, kilo);

    _productController.clear();
    _quantityController.clear();
    _kiloController.clear();

    setState(() {
      _showForm = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartViewModel>(context);
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
         title:  Text("AddisFruit Market",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        actions: [
          // Add to AppBar in GridWithFormPage
          IconButton(
            icon: Icon(Icons.history,color: Colors.white,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OrderHistoryPage()),
              );
            },
          ),
          Consumer<CartViewModel>(
            builder: (context, cart, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart,color: Colors.white,),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CartPage()),
                      );
                    },
                  ),

                  if (cart.items.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cart.items.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
     
      body: Stack(
        children: [
          Row(
            children: [
              // Left: Order List
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child:
                      cart.items.isEmpty
                          ? const Center(
                            child: Text(
                              'No orders yet',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                          : ListView.builder(
                            itemCount: cart.items.length,
                            itemBuilder: (context, index) {
                              final item = cart.items[index];
                              return Card(
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.green.shade100,
                                    child: Text(
                                      item.name?[0].toUpperCase() ?? '?',
                                    ),
                                  ),
                                  title: Text(item.name ?? 'Unknown'),
                                  subtitle: Text(
                                    'Qty: ${item.quantity}, Kilo: ${item.quantity ?? item.quantity}',
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ),
              // Right: Static Form (only for wide screen)
              if (isWide) Expanded(flex: 2, child: _buildFormCard(context)),
            ],
          ),

          // Sliding form (only for small screens)
          if (!isWide)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              right: _showForm ? 0 : -MediaQuery.of(context).size.width,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Material(
                elevation: 20,
                child: Container(
                  color: Colors.white,
                  child: _buildFormCard(context, isOverlay: true),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton:
          !isWide
              ? FloatingActionButton(
                onPressed: () {
                  setState(() => _showForm = !_showForm);
                },
                backgroundColor: Colors.green,
                child: Icon(_showForm ? Icons.close : Icons.add,color: Colors.white,),
              )
              : null,
    );
  }

  Widget _buildFormCard(BuildContext context, {bool isOverlay = false}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Custom Order',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _productController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _kiloController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Kilo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Order'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
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
                  child: const Text('Cancel'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
