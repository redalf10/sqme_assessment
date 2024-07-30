import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 25),
                const Icon(
                  Icons.shop_2,
                  size: 50,
                ),
                const SizedBox(height: 10),
                Text('Assessment by Alfred Anero',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary)),
                const SizedBox(height: 25),
                MyListTile(
                  title: 'Home',
                  icon: Icons.home,
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/shopPage');
                  },
                ),
                MyListTile(
                  title: 'SKU',
                  icon: Icons.production_quantity_limits,
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/quantityPage');
                  },
                ),
                MyListTile(
                  title: 'Order',
                  icon: Icons.shop_2,
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/orderPage');
                  },
                ),
                MyListTile(
                  title: 'History',
                  icon: Icons.history,
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/historyPage');
                  },
                ),
                MyListTile(
                  title: 'Settings',
                  icon: Icons.settings,
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/settingsPage');
                  },
                ),
              ],
            ),
            MyListTile(
              title: 'Logout',
              icon: Icons.logout,
              onTap: () => Navigator.pushNamed(context, '/welcomePage'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function()? onTap;
  const MyListTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
      title: Text(title,
          style:
              TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
    );
  }
}
