import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

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

    final String url;
    if (widget.showOnlyMyProducts) {
      url =
          'https://tristan-rasheed-90minuteszone.pbp.cs.ui.ac.id/json/user-products/';
    } else {
      url = 'https://tristan-rasheed-90minuteszone.pbp.cs.ui.ac.id/json/';
    }

    final response = await request.get(url);

    // show_json returns a list of dicts already (not Django-serialized JSON).
    final List<dynamic> dataList = response is List ? response : [];

    return dataList.map<ItemEntry>((dynamic item) {
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
