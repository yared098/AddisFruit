import 'package:addisfruit/viewmodels/CartViewModel.dart';
import 'package:addisfruit/views/CartPage.dart';
import 'package:addisfruit/views/PersonalPage.dart';
import 'package:addisfruit/views/order_history_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final bool isUserRegistered; // New flag to indicate if user info exists

  const CustomAppBar({
    Key? key,
    required this.searchController,
    required this.searchFocusNode,
    required this.isUserRegistered,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      shadowColor: Colors.black12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade800, Colors.green.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Search bar replaces title
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(10),
                    child: TextField(
                      controller: searchController,
                      focusNode: searchFocusNode,
                      cursorColor: Colors.green.shade700,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search fruits...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Show icons or profile circle based on user registration status
              if (isUserRegistered) ...[
                IconButton(
                  tooltip: 'Order History',
                  icon: const Icon(Icons.history, color: Colors.white70),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderHistoryPage(),
                      ),
                    );
                  },
                ),
                Consumer<CartViewModel>(
                  builder: (context, cart, child) {
                    return Stack(
                      children: [
                        IconButton(
                          tooltip: 'Shopping Cart',
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CartPage(),
                              ),
                            );
                          },
                        ),
                        if (cart.items.isNotEmpty)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${cart.items.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(width: 4),
              ] else
                // If user not registered, show circular person icon
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PersonalPage()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
