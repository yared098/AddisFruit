import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/order_view_model.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderViewModel>(context).orders;

    final filteredOrders = orders.where((order) {
      final query = _searchQuery.toLowerCase();
      return order.customerName.toLowerCase().contains(query) ||
          order.items.join(", ").toLowerCase().contains(query) ||
          order.status.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Order History", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search orders...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredOrders.isEmpty
                ? const Center(
                    child: Text("😕 No orders found", style: TextStyle(fontSize: 16)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.green.shade100,
                                    child: const Icon(Icons.receipt_long, color: Colors.green),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      order.customerName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ),
                                  Chip(
                                    label: Text(
                                      order.status,
                                      style: TextStyle(
                                          color: order.status.toLowerCase().contains("pending")
                                              ? Colors.orange
                                              : Colors.green.shade800),
                                    ),
                                    backgroundColor: order.status.toLowerCase().contains("pending")
                                        ? Colors.orange.shade50
                                        : Colors.green.shade50,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text("📍 Address: ${order.address}", style: const TextStyle(fontSize: 13)),
                              const SizedBox(height: 4),
                              Text("🛒 Items: ${order.items.join(", ")}", style: const TextStyle(fontSize: 13)),
                              const Divider(height: 20),
                              Row(
                                children: [
                                  Icon(Icons.attach_money, size: 18, color: Colors.green.shade700),
                                  const SizedBox(width: 4),
                                  Text("Total: ${order.totalPrice} Birr",
                                      style: const TextStyle(fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 16),
                                  Icon(Icons.delivery_dining, size: 18, color: Colors.brown.shade700),
                                  const SizedBox(width: 4),
                                  Text("Delivery: ${order.deliveryFee} Birr"),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.timer, size: 18, color: Colors.blueGrey),
                                  const SizedBox(width: 4),
                                  Text("ETA: ${order.estimatedArrival}"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
