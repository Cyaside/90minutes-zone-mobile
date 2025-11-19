import 'package:_90minutes_zone_mobile/screens/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:_90minutes_zone_mobile/screens/add_product_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:_90minutes_zone_mobile/main.dart';
import 'package:_90minutes_zone_mobile/screens/login.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              '90minutesZone',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Halaman Utama'),
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('All Product'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProductListPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2),
            title: const Text('My Product'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const ProductListPage(showOnlyMyProducts: true),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_box),
            title: const Text('Tambah Produk'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddProductPage()),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout'),
            textColor: Colors.redAccent,
            iconColor: Colors.redAccent,
            onTap: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              final request = context.read<CookieRequest>();
              final auth = context.read<AuthState>();

              navigator.pop();

              final confirm = await showDialog<bool>(
                context: navigator.context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Konfirmasi Logout'),
                  content: const Text('Apakah kamu yakin ingin logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              if (confirm != true) return;
              try {
                await request.logout(
                  'https://tristan-rasheed-90minuteszone.pbp.cs.ui.ac.id/auth/logout/',
                );

                // Clear local auth state
                auth.clear();

                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );

                messenger
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Logout berhasil.')),
                  );
              } catch (e) {
                messenger
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text('Gagal logout: $e')));
              }
            },
          ),
        ],
      ),
    );
  }
}
