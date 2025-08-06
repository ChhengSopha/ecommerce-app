import 'package:device_preview/device_preview.dart';
import 'package:ecommerce_app/features/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  // Define app colors
  static const Color _seedColor = Colors.deepPurple;
  static const String _appTitle = 'E-Commerce App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      debugShowCheckedModeBanner: false,

      // Device Preview integration
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      // Theme configuration
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,

      // Routing
      home: const AuthScreen(),

      // Error handling
      // Removed unsupported onError parameter
    );
  }

  // Helper method to build consistent themes
  ThemeData _buildTheme(Brightness brightness) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: brightness,
      ),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
