import 'package:ecommerce_app/features/customers/customers_screen.dart';
import 'package:ecommerce_app/features/dashboard/dashboard_screen.dart';
import 'package:ecommerce_app/features/products/products_screen.dart';
import 'package:ecommerce_app/features/reports/reports_screen.dart';
import 'package:ecommerce_app/features/sales/sales_screen.dart';
import 'package:ecommerce_app/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Row(
        children: [
          // Sidebar for larger screens
          if (isLargeScreen)
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected:
                  (index) =>
                      ref.read(navigationIndexProvider.notifier).state = index,
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2),
                  label: Text('Products'),
                ),
                // Add other destinations similarly
              ],
            ),
          // Main content area
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: const [
                DashboardScreen(),
                ProductsScreen(),
                SalesScreen(),
                CustomersScreen(),
                ReportsScreen(),
                SettingsScreen(),
              ],
            ),
          ),
        ],
      ),
      // Bottom nav bar for mobile
      bottomNavigationBar:
          isLargeScreen
              ? null
              : NavigationBar(
                selectedIndex: currentIndex,
                onDestinationSelected:
                    (index) =>
                        ref.read(navigationIndexProvider.notifier).state =
                            index,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.dashboard_outlined),
                    selectedIcon: Icon(Icons.dashboard),
                    label: 'Dashboard',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.inventory_2_outlined),
                    selectedIcon: Icon(Icons.inventory_2),
                    label: 'Products',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.point_of_sale_outlined),
                    selectedIcon: Icon(Icons.point_of_sale),
                    label: 'Sales',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.people_outline),
                    selectedIcon: Icon(Icons.people),
                    label: 'Customers',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.analytics_outlined),
                    selectedIcon: Icon(Icons.analytics),
                    label: 'Reports',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
              ),
    );
  }
}
