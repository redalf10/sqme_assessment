// ignore_for_file: prefer_final_fields

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
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
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
