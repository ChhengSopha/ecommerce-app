import 'package:device_preview/device_preview.dart';
import 'package:ecommerce_app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Enable device preview only in debug mode
  final enableDevicePreview = kDebugMode;

  runApp(
    DevicePreview(
      enabled: enableDevicePreview,
      builder: (context) => const ProviderScope(child: ECommerceApp()),
      tools: const [...DevicePreview.defaultTools],
    ),
  );
}
