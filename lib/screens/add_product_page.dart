import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _thumbnailController = TextEditingController();

  final List<String> _categories = [
    'footwear',
    'kit',
    'shorts and pants',
    'jackets and sportswear',
    'tracksuits',
    'others',
  ];

  String? _selectedCategory;
  bool _isFeatured = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name tidak boleh kosong';
    }
    if (value.length > 255) {
      return 'Name maksimal 255 karakter';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price tidak boleh kosong';
    }
    final v = int.tryParse(value);
    if (v == null) {
      return 'Price harus berupa angka bulat (tanpa desimal)';
    }
    if (v < 0) {
      return 'Price tidak boleh negatif';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description tidak boleh kosong';
    }
    if (value.trim().length < 10) {
      return 'Description minimal 10 karakter';
    }
    return null;
  }

  String? _validateThumbnail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(value);
    if (uri == null ||
        !(uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'))) {
      return 'Thumbnail harus berupa URL yang valid (http/https)';
    }
    return null;
  }

  String? _validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) return 'Category harus dipilih';
    return null;
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final product = {
      'name': _nameController.text.trim(),
      'price': int.parse(_priceController.text.trim()),
      'description': _descriptionController.text.trim(),
      'thumbnail': _thumbnailController.text.trim(),
      'category': _selectedCategory ?? '',
      'is_featured': _isFeatured,
    };
    final request = context.read<CookieRequest>();

    try {
      final response = await request.postJson(
        'https://tristan-rasheed-90minuteszone.pbp.cs.ui.ac.id/create-flutter/',
        jsonEncode(product),
      );

      if (!mounted) return;

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil ditambahkan')),
        );
        Navigator.of(context).pop(true);
      } else {
        final message = (response['message'] ?? 'Gagal menambahkan produk')
            .toString();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: _validateName,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: _validatePrice,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 4,
                validator: _validateDescription,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _thumbnailController,
                decoration: const InputDecoration(labelText: 'Thumbnail (URL)'),
                keyboardType: TextInputType.url,
                validator: _validateThumbnail,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Category'),
                initialValue: _selectedCategory,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
                validator: _validateCategory,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Is Featured'),
                value: _isFeatured,
                onChanged: (v) => setState(() => _isFeatured = v),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _onSave, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
