import 'package:ecommerce_app/models/mock_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredProducts =
        MockData.products.where((product) {
          final name = product['name'].toString().toLowerCase();
          final brand = product['brand'].toString().toLowerCase();
          final query = _searchQuery.toLowerCase();
          return name.contains(query) || brand.contains(query);
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showProductForm(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Image.network(
                      product['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product['name']),
                    subtitle: Text(
                      '${product['brand']} - \$${product['price']}',
                    ),
                    trailing: Text('Stock: ${product['stock']}'),
                    onTap: () => _showProductForm(context, product: product),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showProductForm(BuildContext context, {Map<String, dynamic>? product}) {
    final isEditing = product != null;
    final nameController = TextEditingController(
      text: isEditing ? product['name'] : '',
    );
    final brandController = TextEditingController(
      text: isEditing ? product['brand'] : '',
    );
    final priceController = TextEditingController(
      text: isEditing ? product['price'].toString() : '',
    );
    final stockController = TextEditingController(
      text: isEditing ? product['stock'].toString() : '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEditing ? 'Edit Product' : 'Add Product',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: brandController,
                    decoration: const InputDecoration(labelText: 'Brand'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      prefixText: '\$',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: stockController,
                    decoration: const InputDecoration(
                      labelText: 'Stock Quantity',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isEditing)
                        TextButton(
                          onPressed: () {
                            // Delete product
                            Navigator.pop(context);
                          },
                          child: const Text('Delete'),
                        ),
                      FilledButton(
                        onPressed: () {
                          // Save product
                          Navigator.pop(context);
                        },
                        child: Text(isEditing ? 'Update' : 'Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
