import 'package:ecommerce_app/models/mock_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Records'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _createNewSale),
        ],
      ),
      body: ListView.builder(
        itemCount: MockData.salesData.length,
        itemBuilder: (context, index) {
          final sale = MockData.salesData[index];
          final customer = MockData.customers.firstWhere(
            (c) => c['id'] == sale['customerId'],
            orElse: () => {'name': 'Unknown Customer'},
          );
          final date = DateFormat.yMMMd().format(sale['date'] as DateTime);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(customer['name']),
              subtitle: Text(date),
              trailing: Text(
                '\$${sale['amount'].toStringAsFixed(2)}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              onTap: () => _showSaleDetails(context, sale),
            ),
          );
        },
      ),
    );
  }

  void _createNewSale() {
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
                  const Text(
                    'Create New Sale',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField(
                    items:
                        MockData.customers.map((customer) {
                          return DropdownMenuItem(
                            value: customer['id'],
                            child: Text(customer['name']),
                          );
                        }).toList(),
                    onChanged: (value) {},
                    decoration: const InputDecoration(labelText: 'Customer'),
                  ),
                  const SizedBox(height: 16),
                  const Text('Select Products', style: TextStyle(fontSize: 16)),
                  ...MockData.products.map((product) {
                    return CheckboxListTile(
                      title: Text(product['name']),
                      subtitle: Text('\$${product['price']}'),
                      value: false,
                      onChanged: (value) {},
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \$0.00',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Complete Sale'),
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

  void _showSaleDetails(BuildContext context, Map<String, dynamic> sale) {
    final customer = MockData.customers.firstWhere(
      (c) => c['id'] == sale['customerId'],
      orElse: () => {'name': 'Unknown Customer'},
    );
    final date = DateFormat.yMMMd().add_jm().format(sale['date'] as DateTime);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sale Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Customer: ${customer['name']}'),
                Text('Date: $date'),
                const SizedBox(height: 16),
                const Text(
                  'Items:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...(sale['items'] as List).map((item) {
                  final product = MockData.products.firstWhere(
                    (p) => p['id'] == item['productId'],
                    orElse: () => {'name': 'Unknown Product'},
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(child: Text(product['name'])),
                        Text('${item['quantity']} x \$${item['price']}'),
                      ],
                    ),
                  );
                }).toList(),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal:'),
                    Text('\$${sale['amount'].toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tax (10%):'),
                    Text('\$${(sale['amount'] * 0.1).toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${(sale['amount'] * 1.1).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
