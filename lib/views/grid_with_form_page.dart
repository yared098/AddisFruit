import 'dart:async';
import 'dart:ui';

import 'package:addisfruit/Model/fruit_model.dart';
import 'package:addisfruit/viewmodels/CartViewModel.dart';
import 'package:addisfruit/views/CartPage.dart';
import 'package:addisfruit/views/order_history_page.dart';
import 'package:addisfruit/widgets/HeaderAnimationWidget.dart';
import 'package:addisfruit/widgets/ProductShowWidget.dart';
import 'package:addisfruit/widgets/widgetAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../viewmodels/fruit_view_model.dart';
import '../widgets/fruit_form_widget.dart';

class GridWithFormPage extends StatefulWidget {
  @override
  _GridWithFormPageState createState() => _GridWithFormPageState();
}

class _GridWithFormPageState extends State<GridWithFormPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();

  List<Fruit> allFruits = Fruit.allFruits;
  List<Fruit> filteredFruits = [];
  final List<String> sliderImages = [
    Fruit.allFruits[0].image,
    Fruit.allFruits[2].image,
    Fruit.allFruits[3].image,
    Fruit.allFruits[4].image,
  ];
  final List<String> toptext = [
    "Welcome to Addis Fruit Market – Order Now!",
    "Enjoy Big Discounts Today at Addis Fruit!",
    "Order Fresh Fruits Now from Addis Fruit Market!",
    "We Deliver to Addis Ababa, Bahir Dar, Mekelle, and Adama!",
    "Experience the Taste of Freshness – Order Today from Addis Fruit!",
  ];

  int _currentIndex = 0;
  bool _isUserRegistered = false; // Track user registration status

  late PageController _pageController;

  bool showTopContent = true;

  @override
  void initState() {
    super.initState();

    _checkUserRegistration();
    _pageController = PageController(initialPage: 0);

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

    Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_currentIndex < sliderImages.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  Future<void> _checkUserRegistration() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve a boolean value from SharedPreferences
    bool userRegistered = prefs.getBool('isRegistered') ?? false;

    setState(() {
      _isUserRegistered = userRegistered;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredFruits =
          allFruits
              .where((fruit) => fruit.name.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FruitViewModel>(context);
    bool isWideScreen = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: CustomAppBar(
        searchController: _searchController,
        searchFocusNode: _searchFocusNode,
        isUserRegistered: true,
      ),
      body:
          isWideScreen
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          if (showTopContent) ...[
                            HeaderAnimationWidget(
                              sliderImages: sliderImages,
                              topText: toptext,
                            ),
                          ],
                          ProductShowWidget(
                            filteredFruits: filteredFruits,
                            isWideScreen: isWideScreen,
                            viewModel: viewModel,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (viewModel.showForm)
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.grey.shade50,
                        child: FruitFormWidget(),
                      ),
                    ),
                ],
              )
              : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    if (showTopContent) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          height: 100,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: sliderImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        sliderImages[index],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        color: Colors.black.withOpacity(0.3),
                                        child: Text(
                                          "🔥 ${toptext[index]} 🛒",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],

                    ProductShowWidget(
                      filteredFruits: filteredFruits,
                      isWideScreen: isWideScreen,
                      viewModel: viewModel,
                    ),

                    if (viewModel.showForm)
                      SizedBox(height: 400, child: FruitFormWidget()),
                  ],
                ),
              ),
      bottomSheet:
          !isWideScreen && viewModel.showForm
              ? SizedBox(height: 400, child: FruitFormWidget())
              : null,
    );
  }
}
