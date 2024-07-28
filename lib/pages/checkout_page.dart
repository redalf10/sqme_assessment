// ignore_for_file: deprecated_member_use, unnecessary_to_list_in_spreads

import 'package:assessment/components/shop_button.dart';
import 'package:flutter/material.dart';
import 'package:assessment/model/shop_model.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final String address;

  const CheckoutPage({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Shop>().cart;

    Map<String, int> productQuantities = {};
    double totalPrice = 0.0;

    for (var item in cart) {
      if (productQuantities.containsKey(item.name)) {
        productQuantities[item.name] = productQuantities[item.name]! + 1;
      } else {
        productQuantities[item.name] = 1;
      }
      totalPrice += item.price;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Name: $name',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Phone: +63$phone',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Email: $email',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Address: $address',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Order Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...productQuantities.keys.map((productName) {
                final product =
                    cart.firstWhere((item) => item.name == productName);
                final quantity = productQuantities[productName]!;
                final itemTotalPrice = product.price * quantity;

                return ListTile(
                  title: Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'x $quantity',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    '₱${itemTotalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Total: ₱${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ShopButton(
                    onTap: () {},
                    child: const Text(
                      'BUY NOW',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
