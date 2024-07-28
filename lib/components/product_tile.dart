// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:assessment/model/shop_model.dart';
import 'package:flutter/material.dart';

import 'package:assessment/model/product_model.dart';
import 'package:provider/provider.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile({
    super.key,
    required this.product,
  });

  void addToCart(BuildContext context, Product product) {
    if (product.qty == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This item is out of stock')),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text('Add this item to your cart?'),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<Shop>().addToCart(product);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 350,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    product.description,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('(${product.qty.toString()} items left)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₱${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => addToCart(context, product),
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.secondary,
              ),
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        )
      ],
    );
  }
}
