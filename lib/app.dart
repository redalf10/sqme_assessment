import 'package:assessment/pages/history_page.dart';
import 'package:assessment/pages/quantity_page.dart';
import 'package:assessment/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/order_page.dart';
import 'pages/settings_page.dart';
import 'pages/shop_page.dart';
import 'pages/welcome_page.dart';

class MyAssessment extends StatelessWidget {
  const MyAssessment({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).themeData,
        home: const WelcomePage(),
        routes: {
          '/settingsPage': (context) => const SettingsPage(),
          '/historyPage': (context) => const HistoryPage(),
          '/quantityPage': (context) => const QuantityPage(),
          '/orderPage': (context) => const OrderPage(),
          '/shopPage': (context) => const ShopPage(),
          '/welcomePage': (context) => const WelcomePage(),
        });
  }
}
