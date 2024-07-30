// ignore_for_file: prefer_final_fields, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:assessment/components/shop_button.dart';
import 'package:assessment/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:assessment/model/product_model.dart';

class Shop extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Product> _shop = [];
  List<Product> _cart = [];

  Shop() {
    _loadProducts();
  }

  List<Product> get shop => _shop;
  List<Product> get cart => _cart;

  Future<void> _loadProducts() async {
    _shop = await _databaseHelper.getProducts();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await _databaseHelper.insertProduct(product);
    await _loadProducts();
  }

  Future<void> removeProduct(BuildContext context, Product product) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Product'),
        content: const Text('Are you sure you want to remove this product?'),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          MaterialButton(
            onPressed: () async {
              Navigator.pop(context);
              await _databaseHelper.deleteProduct(product.id!);
              await _loadProducts();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('${product.name} deleted to product list')),
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<void> updateProduct(BuildContext context, Product product) async {
    final _formKey = GlobalKey<FormState>();
    String name = product.name;
    String description = product.description;
    double price = product.price;
    int qty = product.qty;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: name,
                  maxLength: 30,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: Theme.of(context).colorScheme.secondary,
                    filled: true,
                    hintText: 'Product Name',
                  ),
                  onChanged: (value) => name = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                TextFormField(
                  initialValue: description,
                  maxLength: 55,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: Theme.of(context).colorScheme.secondary,
                    filled: true,
                    hintText: 'Description',
                  ),
                  onChanged: (value) => description = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                TextFormField(
                  initialValue: price.toString(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: Theme.of(context).colorScheme.secondary,
                    filled: true,
                    hintText: 'Price (₱)',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => price = double.tryParse(value) ?? 0.0,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                TextFormField(
                  initialValue: qty.toString(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: Theme.of(context).colorScheme.secondary,
                    filled: true,
                    hintText: 'Quantity',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => qty = int.tryParse(value) ?? 0,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Please enter a valid quantity';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ShopButton(
              onTap: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ShopButton(
              onTap: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _updateProduct(
                    Product(
                      id: product.id,
                      name: name,
                      description: description,
                      price: price,
                      qty: qty,
                    ),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('${product.name} updated successfully')),
                  );
                }
              },
              child: const Text(
                'Update',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateProduct(Product product) async {
    await _databaseHelper.updateProduct(product);
    await _loadProducts();
  }

  Future<void> updateProductQuantity(int index, int newQty) async {
    Product updatedProduct = Product(
      id: _shop[index].id,
      name: _shop[index].name,
      price: _shop[index].price,
      description: _shop[index].description,
      qty: newQty,
    );
    await _databaseHelper.updateProduct(updatedProduct);
    await _loadProducts();
  }

  void addToCart(Product item) {
    if (item.qty > 0) {
      updateProductQuantity(_shop.indexOf(item), item.qty - 1);
      _cart.add(item);
      notifyListeners();
    }
  }

  void removeFromCart(Product item) {
    _cart.remove(item);
    notifyListeners();
  }
}
