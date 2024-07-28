import 'package:assessment/components/drawer.dart';
import 'package:assessment/components/shop_button.dart';
import 'package:assessment/model/shop_model.dart';
import 'package:assessment/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class QuantityPage extends StatelessWidget {
  const QuantityPage({super.key});

  void increaseQuantity(BuildContext context, Product product) {
    final shop = context.read<Shop>();
    int index = shop.shop.indexOf(product);
    if (index != -1) {
      shop.updateProductQuantity(index, product.qty + 1);
    }
  }

  void decreaseQuantity(BuildContext context, Product product) {
    final shop = context.read<Shop>();
    int index = shop.shop.indexOf(product);
    if (index != -1 && product.qty > 0) {
      shop.updateProductQuantity(index, product.qty - 1);
    }
  }

  void addProduct(BuildContext context) {
    final shop = context.read<Shop>();
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String description = '';
        double price = 0.0;
        int qty = 0;

        return AlertDialog(
          title: const Text('Add Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  hintText: 'Product Name',
                ),
                onChanged: (value) => name = value,
              ),
              const SizedBox(height: 5),
              TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  hintText: 'Description',
                ),
                onChanged: (value) => description = value,
              ),
              const SizedBox(height: 5),
              TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  hintText: 'Price (₱)',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => price = double.tryParse(value) ?? 0.0,
              ),
              const SizedBox(height: 5),
              TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  hintText: 'Quantity',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => qty = int.tryParse(value) ?? 0,
              ),
            ],
          ),
          actions: [
            ShopButton(
              onTap: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ShopButton(
              onTap: () {
                if (name.isNotEmpty &&
                    description.isNotEmpty &&
                    price > 0 &&
                    qty > 0) {
                  shop.addProduct(Product(
                      name: name,
                      description: description,
                      price: price,
                      qty: qty));
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<Shop>().shop;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Quantity'),
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Text(
                      'You don\'t have products to display',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(25),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Column(
                        children: [
                          Slidable(
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  spacing: 1,
                                  onPressed: (context) {
                                    context
                                        .read<Shop>()
                                        .removeProduct(context, product);
                                  },
                                  icon: Icons.delete,
                                ),
                              ],
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              padding: const EdgeInsets.all(10),
                              color: Theme.of(context).colorScheme.secondary,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(product.name),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => decreaseQuantity(
                                              context, product),
                                          icon: const Icon(Icons.remove_circle),
                                        ),
                                        Text(product.qty.toString()),
                                        IconButton(
                                          onPressed: () => increaseQuantity(
                                              context, product),
                                          icon: const Icon(Icons.add_circle),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: ShopButton(
              onTap: () => addProduct(context),
              child: const Text('ADD PRODUCT',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
