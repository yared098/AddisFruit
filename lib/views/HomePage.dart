import 'package:addisfruit/Model/fruit_model.dart';
import 'package:addisfruit/viewmodels/theme_provider.dart';
import 'package:addisfruit/views/PersonalPage.dart';
import 'package:addisfruit/views/grid_with_form_page.dart';
import 'package:addisfruit/views/my_orders_page.dart';
import 'package:addisfruit/views/track_map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart'; // <-- import provider
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    GridWithFormPage(),
    const MyOrdersPage(),
    const TrackMapPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.local_florist_outlined),
      activeIcon: Icon(Icons.local_florist),
      label: 'Fruits',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.receipt_long_outlined),
      activeIcon: Icon(Icons.receipt_long),
      label: 'My Orders',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.map_outlined),
      activeIcon: Icon(Icons.map),
      label: 'Track Map',
    ),
  ];
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  bool showTopContent = true;

  List<Fruit> allFruits = Fruit.allFruits;
  bool isUserRegistered = false;
  List<Fruit> filteredFruits = [];
  final List<String> sliderImages = [
    Fruit.allFruits[0].image,
    Fruit.allFruits[2].image,
    Fruit.allFruits[3].image,
    Fruit.allFruits[4].image,
  ];

  @override
  void initState() {
    super.initState();
    _checkUserRegistrationStatus();

    filteredFruits = allFruits;
    _searchController.addListener(_onSearchChanged);

    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        setState(() {
          showTopContent = false;
        });
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() => showTopContent = false);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() => showTopContent = true);
      }
    });
  }

  Future<void> _checkUserRegistrationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool registered = prefs.getBool('isUserRegistered') ?? false;

    setState(() {
      isUserRegistered = registered;
    });

    if (!isUserRegistered) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNotRegisteredBottomSheet(context);
      });
    }
  }

  void _showNotRegisteredBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'You are not registered to Addis Fruit',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ListTile(
                    leading: Icon(Icons.shopping_cart, color: Colors.green),
                    title: Text('Create and manage your orders'),
                  ),
                  ListTile(
                    leading: Icon(Icons.track_changes, color: Colors.green),
                    title: Text('Track your order in real-time'),
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications_active, color: Colors.green),
                    title: Text('Get updates on offers and delivery'),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PersonalPage()),
                  );
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Register Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Maybe later',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredFruits =
          allFruits.where((fruit) => fruit.name.toLowerCase().contains(query)).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final bool isDark = themeProvider.isDarkMode;

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black54 : Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: _bottomNavItems.map((item) {
            return BottomNavigationBarItem(
              icon: item.icon,
              activeIcon: Icon(
                (item.activeIcon as Icon).icon,
                color: isDark ? Colors.lightGreenAccent : Colors.green,
              ),
              label: item.label,
            );
          }).toList(),
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          selectedItemColor: isDark ? Colors.lightGreenAccent : Colors.green,
          unselectedItemColor: isDark ? Colors.white60 : Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      ),
    );
  }
}
