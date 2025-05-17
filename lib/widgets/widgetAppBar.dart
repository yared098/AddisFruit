// lib/widgets/widgetAppBar.dart
import 'package:addisfruit/viewmodels/CartViewModel.dart';
import 'package:addisfruit/views/CartPage.dart';
import 'package:addisfruit/views/order_history_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showTopContent;

  const CustomAppBar({super.key, required this.showTopContent});

  @override
  Size get preferredSize => Size.fromHeight(showTopContent ? 56.0 : 0);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: showTopContent ? 56.0 : 0,
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "AddisFruit Market",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>  OrderHistoryPage()),
              );
            },
          ),
          Consumer<CartViewModel>(
            builder: (context, cart, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) =>  CartPage()),
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
    );
  }
}