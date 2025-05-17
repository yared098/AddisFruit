import 'dart:async';

import 'package:addisfruit/Model/fruit_model.dart';
import 'package:addisfruit/viewmodels/CartViewModel.dart';
import 'package:addisfruit/viewmodels/order_view_model.dart';
import 'package:addisfruit/views/HomePage.dart';
import 'package:addisfruit/views/IntroductionPage.dart';
import 'package:addisfruit/views/SplashScreen.dart';
import 'package:addisfruit/views/my_orders_page.dart';
import 'package:addisfruit/views/track_map_page.dart';
import 'package:addisfruit/widgets/widgetAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'viewmodels/fruit_view_model.dart';
import 'views/grid_with_form_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasSeenSplash = prefs.getBool('hasSeenSplash') ?? false;
  bool hasSeenIntroduction = prefs.getBool('hasSeenIntroduction') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FruitViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AddisFruit',
        theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: const Color(0xFFF9F9F9),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
          ),
          textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
        ),
        home: hasSeenSplash
            ? (hasSeenIntroduction ? const HomePage() : const IntroductionPage())
            : const SplashScreen(),
      ),
    ),
  );
}

