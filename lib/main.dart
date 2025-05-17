import 'dart:async';

import 'package:addisfruit/Model/fruit_model.dart';
import 'package:addisfruit/viewmodels/CartViewModel.dart';
import 'package:addisfruit/viewmodels/order_view_model.dart';
import 'package:addisfruit/viewmodels/theme_provider.dart';
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
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(
        hasSeenSplash: hasSeenSplash,
        hasSeenIntroduction: hasSeenIntroduction,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool hasSeenSplash;
  final bool hasSeenIntroduction;

  const MyApp({
    super.key,
    required this.hasSeenSplash,
    required this.hasSeenIntroduction,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AddisFruit',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
      ),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: hasSeenSplash
          ? (hasSeenIntroduction ? const HomePage() : const IntroductionPage())
          : const SplashScreen(),
    );
  }
}
