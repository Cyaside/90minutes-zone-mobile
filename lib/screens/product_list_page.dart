import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:_90minutes_zone_mobile/main.dart';

import '../models/item_entry.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key, this.showOnlyMyProducts = false});

  final bool showOnlyMyProducts;

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<ItemEntry>> _futureItems;

  @override
  void initState() {
    super.initState();
    _futureItems = _loadItems();
  }

  Future<List<ItemEntry>> _loadItems() async {
    final request = context.read<CookieRequest>();

    // Selalu fetch semua produk; filter client-side jika showOnlyMyProducts.
    final url = 'https://tristan-rasheed-90minuteszone.pbp.cs.ui.ac.id/json/';
    final response = await request.get(url);

    final List<dynamic> rawList = response is List ? response : [];

    // Ambil username login dari response login tersimpan di CookieRequest (jika ada)
    // Jika tidak tersedia, kita fallback ke string kosong agar filter tidak menghapus semua.
    // pbp_django_auth tidak expose langsung username, jadi bisa simpan di state Global (belum ada di sini).
    // Untuk sekarang, gunakan user_username dari tiap item untuk comparing terhadap first occurrence.

    // Jika user ingin my products tapi backend endpoint khusus tidak bisa diakses,
    // kita filter berdasarkan user_username paling pertama yang cocok dengan produk yg baru ditambahkan.
    // Idealnya: simpan username saat login (misal via Provider) lalu gunakan di sini.

    // Ambil username dari AuthState (diset saat login)
    final currentUsername = context.read<AuthState>().username;

    final filtered = widget.showOnlyMyProducts
        ? rawList.where((e) {
            if (e is! Map) return false;
            final uname = e['user_username'];
            if (uname == null || currentUsername == null) return false;
            return uname == currentUsername;
          }).toList()
        : rawList;

    return filtered.map<ItemEntry>((dynamic item) {
      final map = Map<String, dynamic>.from(item as Map);
      return ItemEntry(
        model: 'main.product',
        pk: map['id']?.toString() ?? '',
        fields: Fields(
          name: map['name'] ?? '',
          price: (map['price'] is int)
              ? map['price'] as int
              : (map['price'] as num).toInt(),
          description: map['description'] ?? '',
          thumbnail: map['thumbnail'] ?? '',
          category: map['category'] ?? '',
          isFeatured: map['is_featured'] ?? false,
          views: map['views'] ?? 0,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.showOnlyMyProducts ? 'My Products' : 'All Products';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<List<ItemEntry>>(
        future: _futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('Tidak ada produk.'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final f = item.fields;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: (f.thumbnail.isNotEmpty)
                      ? Image.network(
                          // TODO
                          // Use proxy-image to avoid mixed-content / CORS issues.
                          'https://tristan-rasheed-90minuteszone.pbp.cs.ui.ac.id/proxy-image/?url=${Uri.encodeComponent(f.thumbnail)}',
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported),
                        )
                      : const Icon(Icons.shopping_bag),
                  title: Text(f.name),
                  subtitle: Text(
                    'Rp ${f.price} • ${f.category}' +
                        (f.isFeatured ? ' • Featured' : ''),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(productId: item.pk),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
