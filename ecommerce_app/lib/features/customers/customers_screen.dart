import 'package:ecommerce_app/models/mock_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredCustomers =
        MockData.customers.where((customer) {
          final name = customer['name'].toString().toLowerCase();
          final email = customer['email'].toString().toLowerCase();
          final query = _searchQuery.toLowerCase();
          return name.contains(query) || email.contains(query);
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCustomerForm(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search customers...',
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
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = filteredCustomers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(customer['name']),
                    subtitle: Text(customer['email']),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showCustomerDetails(context, customer),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomerForm(
    BuildContext context, {
    Map<String, dynamic>? customer,
  }) {
    final isEditing = customer != null;
    final nameController = TextEditingController(
      text: isEditing ? customer['name'] : '',
    );
    final emailController = TextEditingController(
      text: isEditing ? customer['email'] : '',
    );
    final phoneController = TextEditingController(
      text: isEditing ? customer['phone'] : '',
    );
    final addressController = TextEditingController(
      text: isEditing ? customer['address'] : '',
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
                    isEditing ? 'Edit Customer' : 'Add Customer',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isEditing)
                        TextButton(
                          onPressed: () {
                            // Delete customer
                            Navigator.pop(context);
                          },
                          child: const Text('Delete'),
                        ),
                      FilledButton(
                        onPressed: () {
                          // Save customer
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

  void _showCustomerDetails(
    BuildContext context,
    Map<String, dynamic> customer,
  ) {
    final customerSales =
        MockData.salesData
            .where((sale) => sale['customerId'] == customer['id'])
            .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(title: Text(customer['name'])),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Contact Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow(Icons.email, customer['email']),
                            const SizedBox(height: 8),
                            _buildDetailRow(Icons.phone, customer['phone']),
                            const SizedBox(height: 8),
                            _buildDetailRow(
                              Icons.location_on,
                              customer['address'],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Purchase History (${customerSales.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (customerSales.isEmpty) const Text('No purchases yet'),
                    ...customerSales.map((sale) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text('Sale #${sale['id']}'),
                          subtitle: Text(
                            '\$${sale['amount'].toStringAsFixed(2)}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _showSaleDetails(context, sale),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }

  void _showSaleDetails(BuildContext context, Map<String, dynamic> sale) {
    // Reuse the sale details dialog from SalesScreen
    Navigator.pop(context); // First pop the customer details
    showDialog(
      context: context,
      builder: (context) {
        // This would be the same dialog implementation as in SalesScreen
        return AlertDialog(
          title: const Text('Sale Details'),
          content: const Text('Sale details would be shown here'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
