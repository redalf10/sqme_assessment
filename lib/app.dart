import 'package:assessment/pages/quantity_page.dart';
import 'package:assessment/theme/light_mode.dart';
import 'package:flutter/material.dart';

import 'pages/order_page.dart';
import 'pages/shop_page.dart';
import 'pages/welcome_page.dart';

class MyAssessment extends StatelessWidget {
  const MyAssessment({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: const WelcomePage(),
        routes: {
          // '/historyPage': (context) => const HistoryPage(),
          '/quantityPage': (context) => const QuantityPage(),
          '/orderPage': (context) => const OrderPage(),
          '/shopPage': (context) => const ShopPage(),
          '/welcomePage': (context) => const WelcomePage(),
        });
  }
}
