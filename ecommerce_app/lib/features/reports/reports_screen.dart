import 'package:ecommerce_app/models/mock_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Calculate weekly sales data
    final weeklySales = List.generate(7, (index) {
      final day = DateTime.now().subtract(Duration(days: 6 - index));
      final daySales =
          MockData.salesData.where((sale) {
            final saleDate = sale['date'] as DateTime;
            return saleDate.year == day.year &&
                saleDate.month == day.month &&
                saleDate.day == day.day;
          }).toList();
      return daySales.fold<double>(0, (sum, sale) => sum + sale['amount']);
    });

    // Calculate top selling products
    final productSales = <String, double>{};
    for (final sale in MockData.salesData) {
      for (final item in sale['items'] as List) {
        final productId = item['productId'];
        final amount = item['quantity'] * item['price'];
        productSales[productId] = (productSales[productId] ?? 0) + amount;
      }
    }

    final topProducts =
        productSales.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Sales',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups:
                      weeklySales.asMap().entries.map((entry) {
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value,
                              color: Colors.deepPurple,
                              width: 16,
                            ),
                          ],
                        );
                      }).toList(),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final day = DateTime.now().subtract(
                            Duration(days: 6 - value.toInt()),
                          );
                          return Text(DateFormat('E').format(day));
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text('\$${value.toInt()}');
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Monthly Revenue',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(12, (index) {
                        final month = DateTime(DateTime.now().year, index + 1);
                        final monthSales =
                            MockData.salesData.where((sale) {
                              final saleDate = sale['date'] as DateTime;
                              return saleDate.year == month.year &&
                                  saleDate.month == month.month;
                            }).toList();
                        final total = monthSales.fold<double>(
                          0,
                          (sum, sale) => sum + sale['amount'],
                        );
                        return FlSpot(index.toDouble(), total);
                      }),
                      isCurved: true,
                      color: Colors.orange,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            DateFormat('MMM').format(
                              DateTime(DateTime.now().year, value.toInt() + 1),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text('\$${value.toInt()}K');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Top Selling Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...topProducts.take(5).map((entry) {
              final product = MockData.products.firstWhere(
                (p) => p['id'] == entry.key,
                orElse: () => {'name': 'Unknown Product'},
              );
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple.withOpacity(0.1),
                    child: Text(
                      '\$${entry.value.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  title: Text(product['name']),
                  subtitle: LinearProgressIndicator(
                    value: entry.value / topProducts.first.value,
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
