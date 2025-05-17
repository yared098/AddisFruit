import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/order_view_model.dart';


class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  TextEditingController _searchController = TextEditingController();
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
        title: const Text("Order History"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search by name, item or status...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
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
                ? Center(child: Text("No orders found."))
                : ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 3,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.shade100,
                            child: Icon(Icons.receipt_long, color: Colors.green),
                          ),
                          title: Text(order.customerName, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text("Address: ${order.address}", style: TextStyle(fontSize: 13)),
                              Text("Items: ${order.items.join(", ")}", style: TextStyle(fontSize: 13)),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.monetization_on, size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text("Total: ${order.totalPrice} Birr"),
                                  SizedBox(width: 16),
                                  Text("Delivery: ${order.deliveryFee} Birr"),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.timer, size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text("ETA: ${order.estimatedArrival}"),
                                  SizedBox(width: 16),
                                  Chip(
                                    label: Text(order.status),
                                    backgroundColor: order.status.toLowerCase().contains("pending")
                                        ? Colors.orange.shade100
                                        : Colors.green.shade100,
                                  ),
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
