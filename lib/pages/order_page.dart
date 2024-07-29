import 'package:assessment/components/personal_info_form.dart';
import 'package:assessment/components/shop_button.dart';
import 'package:assessment/model/product_model.dart';
import 'package:assessment/model/shop_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'checkout_page.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  void addPayment(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          const AlertDialog(content: Text('Add payment to your backend')),
    );
  }

  void removeItemFromCart(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Remove this item from your cart?'),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<Shop>().removeFromCart(product);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showPersonalInfoForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PersonalInfoForm(
        onSubmit: (name, phone, email, address) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutPage(
                name: name,
                phone: phone,
                email: email,
                address: address,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Shop>().cart;

    // Create a map to hold the quantity of each product
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Order',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.isEmpty
                ? Center(
                    child: Text(
                      'You don\'t have order items..',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: productQuantities.keys.length,
                    itemBuilder: (context, index) {
                      final productName =
                          productQuantities.keys.elementAt(index);
                      final product =
                          cart.firstWhere((item) => item.name == productName);
                      final quantity = productQuantities[productName]!;
                      final itemTotalPrice = product.price * quantity;

                      return ListTile(
                        title: Text(
                          '$quantity $productName',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Price: ₱${itemTotalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () => removeItemFromCart(context, product),
                          icon: Icon(
                            Icons.remove_circle,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Total: ₱${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: ShopButton(
                    onTap: () => cart.isEmpty
                        ? ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Add order item first')),
                          )
                        : _showPersonalInfoForm(context),
                    child: Text(
                      'CHECK OUT',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
