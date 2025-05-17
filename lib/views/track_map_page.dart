import 'package:addisfruit/viewmodels/CartViewModel.dart';
import 'package:addisfruit/views/CartPage.dart';
import 'package:addisfruit/views/order_history_page.dart';
import 'package:addisfruit/widgets/widgetAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrackMapPage extends StatelessWidget {
  const TrackMapPage({super.key});

  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
       
     body: const Center(
        child: Text(
          'Map will be here',
          style: TextStyle(fontSize: 24, color: Colors.grey),
        ),
      ),
    );
  }
}
