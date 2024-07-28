import 'package:flutter/material.dart';

import '../components/shop_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shop_2_outlined,
              size: 75,
            ),
            Text(
              'Assessment',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 30,
              ),
            ),
            Text(
              'by Alfred Anero',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 25),
            ShopButton(
              onTap: () => Navigator.pushNamed(context, '/shopPage'),
              child: const Icon(
                Icons.arrow_forward,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
