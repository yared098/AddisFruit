import 'package:addisfruit/viewmodels/CartViewModel.dart';
import 'package:addisfruit/views/CartPage.dart';
import 'package:addisfruit/views/order_history_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrackMapPage extends StatelessWidget {
  const TrackMapPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: const Center(
        child: Text(
          'Map will be here',
          style: TextStyle(fontSize: 24, color: Colors.grey),
        ),
      ),
    );
  }
}
