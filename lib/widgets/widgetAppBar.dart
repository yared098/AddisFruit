import 'package:addisfruit/viewmodels/CartViewModel.dart';
import 'package:addisfruit/viewmodels/theme_provider.dart';
import 'package:addisfruit/views/CartPage.dart';
import 'package:addisfruit/views/PersonalPage.dart';
import 'package:addisfruit/views/order_history_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final bool isUserRegistered;

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Material(
      elevation: 2,
      shadowColor: isDark ? Colors.black54 : Colors.black12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  colors: [Colors.grey[900]!, Colors.grey[800]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [Colors.green.shade800, Colors.green.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(10),
                    child: TextField(
                      controller: searchController,
                      focusNode: searchFocusNode,
                      cursorColor: isDark ? Colors.green.shade300 : Colors.green.shade700,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search fruits...',
                        hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
                        prefixIcon: Icon(Icons.search, size: 20, color: isDark ? Colors.white54 : Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: isDark ? Colors.grey[800] : Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              if (isUserRegistered) ...[
                IconButton(
                  tooltip: 'Order History',
                  icon: Icon(Icons.history, color: isDark ? Colors.white70 : Colors.white70),
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
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: isDark ? Colors.white70 : Colors.white70,
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
                      backgroundColor: isDark ? Colors.grey[700] : Colors.white,
                      child: Icon(
                        Icons.person,
                        color: isDark ? Colors.green.shade300 : Colors.green.shade700,
                      ),
                    ),
                  ),
                ),

              // 🌙 Light/Dark Mode Toggle Icon
              IconButton(
                tooltip: isDark ? 'Light Mode' : 'Dark Mode',
                icon: Icon(
                  isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
                  color: Colors.white,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
