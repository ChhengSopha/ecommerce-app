import 'package:flutter/material.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key, required int initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Navigation')),
      body: const Center(child: Text('Main Navigation Page')),
    );
  }
}
