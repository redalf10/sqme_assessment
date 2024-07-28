import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/drawer.dart';
import '../components/product_tile.dart';
import '../model/shop_model.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = context.watch<Shop>().shop;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Home',
        ),
      ),
      drawer: const MyDrawer(),
      body: products.isEmpty
          ? Center(
              child: Text(
                'You don\'t have products to display',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              padding: const EdgeInsets.all(25),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductTile(
                  product: product,
                );
              },
            ),
    );
  }
}
