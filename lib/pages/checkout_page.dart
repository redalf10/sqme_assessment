// ignore_for_file: use_build_context_synchronously, unnecessary_to_list_in_spreads

import 'package:assessment/components/shop_button.dart';
import 'package:assessment/services/database_helper.dart';
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

  void _showPaymentDialog(BuildContext context, double totalPrice,
      Map<String, int> productQuantities) {
    final TextEditingController cashController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Payment',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        content: TextField(
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          controller: cashController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: true,
            hintText: 'Enter cash amount',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
        actions: [
          ShopButton(
            onTap: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ShopButton(
            onTap: () async {
              final cash = double.tryParse(cashController.text) ?? 0.0;
              if (cash >= totalPrice) {
                final change = cash - totalPrice;
                await _saveOrder(
                  name,
                  phone,
                  email,
                  address,
                  productQuantities,
                  totalPrice,
                  cash,
                  change,
                );
                Navigator.pop(context);
                _showThankYouDialog(context, change);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: cashController.text.isEmpty
                        ? const Text('Don\'t leave blank')
                        : const Text(
                            'Cash amount must be greater than total amount'),
                  ),
                );
              }
            },
            child: Text(
              'Pay',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveOrder(
    String name,
    String phone,
    String email,
    String address,
    Map<String, int> orderDetails,
    double total,
    double cash,
    double change,
  ) async {
    final timestamp = DateTime.now().toIso8601String();
    await DatabaseHelper().insertOrder(
      name: name,
      phone: phone,
      email: email,
      address: address,
      orderDetails: orderDetails,
      total: total,
      cash: cash,
      change: change,
      timestamp: timestamp,
    );
  }

  void _showThankYouDialog(BuildContext context, double change) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Thank you',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Thank you for your purchase! Your change is ₱${change.toStringAsFixed(2)}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        actions: [
          ShopButton(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/shopPage');
            },
            child: Text(
              'OK',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
        title: Text(
          'Checkout',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Name: $name',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    Text(
                      'Phone: +63$phone',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    Text(
                      'Email: $email',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    Text(
                      'Address: $address',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Order Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
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
                    '$quantity $productName',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  subtitle: Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  trailing: Text(
                    '₱${itemTotalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                );
              }).toList(),
              Center(
                child: Text(
                  'Total: ₱${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ShopButton(
                    onTap: () => _showPaymentDialog(
                        context, totalPrice, productQuantities),
                    child: Text(
                      'BUY NOW',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
