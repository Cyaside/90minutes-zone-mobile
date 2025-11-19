import 'package:_90minutes_zone_mobile/screens/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:_90minutes_zone_mobile/screens/add_product_page.dart';
import 'package:_90minutes_zone_mobile/models/item_homepage.dart';

class ItemCard extends StatelessWidget {
  // Menampilkan kartu dengan ikon dan nama.

  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      // Menentukan warna latar belakang berdasarkan properti item.color,
      // fallback ke warna sekunder tema jika tidak diberikan.
      color: item.color ?? Theme.of(context).colorScheme.secondary,
      // Membuat sudut kartu melengkung.
      borderRadius: BorderRadius.circular(12),

      child: InkWell(
        // Aksi ketika kartu ditekan.
        onTap: () {
          final nameLower = item.name.toLowerCase();
          if (nameLower == 'create products') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddProductPage()),
            );
          } else if (item.name == 'All Products') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductListPage()),
            );
          } else if (item.name == 'My Products') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProductListPage(showOnlyMyProducts: true),
              ),
            );
          } else {
            // Existing behavior for other items
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Kamu telah menekan tombol ${item.name}!"),
                ),
              );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
