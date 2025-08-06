class MockData {
  static final List<Map<String, dynamic>> products = [
    {
      'id': '1',
      'name': 'Smartphone X',
      'brand': 'TechCorp',
      'price': 699.99,
      'stock': 25,
      'image': 'https://via.placeholder.com/150',
      'category': 'Electronics',
    },
    {
      'id': '2',
      'name': 'Wireless Headphones',
      'brand': 'SoundMax',
      'price': 149.99,
      'stock': 42,
      'image': 'https://via.placeholder.com/150',
      'category': 'Audio',
    },
    // Add more products...
  ];

  static final List<Map<String, dynamic>> customers = [
    {
      'id': '1',
      'name': 'John Doe',
      'email': 'john@example.com',
      'phone': '555-123-4567',
      'address': '123 Main St, Anytown',
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'email': 'jane@example.com',
      'phone': '555-987-6543',
      'address': '456 Oak Ave, Somewhere',
    },
    // Add more customers...
  ];

  static final List<Map<String, dynamic>> salesData = [
    {
      'id': '1',
      'customerId': '1',
      'date': DateTime(2023, 6, 15),
      'items': [
        {'productId': '1', 'quantity': 1, 'price': 699.99},
      ],
      'amount': 699.99,
    },
    {
      'id': '2',
      'customerId': '2',
      'date': DateTime(2023, 6, 16),
      'items': [
        {'productId': '2', 'quantity': 2, 'price': 149.99},
      ],
      'amount': 299.98,
    },
    // Add more sales...
  ];
}
