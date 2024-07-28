import 'package:flutter/material.dart';

class ShopButton extends StatelessWidget {
  final Function()? onTap;
  final Widget child;
  const ShopButton({super.key, this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
    );
  }
}
