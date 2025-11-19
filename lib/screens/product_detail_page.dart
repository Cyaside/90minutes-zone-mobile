import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/item_entry.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.productId});

  final String productId;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<ItemEntry> _futureItem;

  @override
  void initState() {
    super.initState();
    _futureItem = _loadDetail();
  }

  Future<ItemEntry> _loadDetail() async {
    final request = context.read<CookieRequest>();
    final url =
        'https://tristan-rasheed-90minuteszone.pbp.cs.ui.ac.id/json/${widget.productId}/';

    final response = await request.get(url);

    // Endpoint show_json_by_id already returns a dict in the same shape
    // we used for the list, so adapt it.
    final map = Map<String, dynamic>.from(response as Map);

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: FutureBuilder<ItemEntry>(
        future: _futureItem,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final item = snapshot.data!;
          final f = item.fields;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (f.thumbnail.isNotEmpty)
                  Center(
                    child: Image.network(
                      //TODO tristan-rasheed-90minuteszone.pbp.cs.ui.ac.id
                      'https://tristan-rasheed-90minuteszone.pbp.cs.ui.ac.id/proxy-image/?url=${Uri.encodeComponent(f.thumbnail)}',
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported, size: 80),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  f.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Harga: Rp ${f.price}'),
                Text('Kategori: ${f.category}'),
                Text('Featured: ${f.isFeatured ? "Ya" : "Tidak"}'),
                Text('Views: ${f.views}'),
                const SizedBox(height: 16),
                const Text(
                  'Deskripsi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(f.description),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Kembali ke daftar'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
