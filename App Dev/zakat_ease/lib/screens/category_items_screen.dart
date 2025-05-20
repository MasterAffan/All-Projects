import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/zakat_item.dart';
import '../providers/zakat_provider.dart';
import '../utils/constants.dart';
import '../theme.dart';
import 'add_zakat_item_screen.dart';

class CategoryItemsScreen extends StatelessWidget {
  final String category;

  const CategoryItemsScreen({
    super.key,
    required this.category,
  });

  void _showRefreshDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Prices'),
        content: const Text(
          'This will update the current gold and silver prices to the latest market rates. '
          'The Zakat amount for your existing items will be recalculated based on these new prices. '
          'Do you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<ZakatProvider>().fetchPrices();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: category == 'Gold & Silver'
            ? [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => _showRefreshDialog(context),
                  tooltip: 'Update Prices',
                ),
              ]
            : null,
      ),
      body: Consumer<ZakatProvider>(
        builder: (context, provider, child) {
          final items = provider.items[category] ?? [];
          final total = provider.getCategoryTotal(category);

          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Zakat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${(total * 0.025).toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (category == 'Gold & Silver' && provider.prices.isNotEmpty) ...[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.amber[700]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Current prices: 24K Gold - ₹${provider.getGoldPrice('24K')}/g, '
                              '22K Gold - ₹${provider.getGoldPrice('22K')}/g, '
                              'Silver - ₹${provider.getSilverPrice()}/g',
                              style: TextStyle(
                                color: Colors.amber[900],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.wifi_tethering_error, color: Colors.amber[700], size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Make sure you have internet access to fetch the latest gold and silver prices',
                              style: TextStyle(
                                color: Colors.amber[900],
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${(item.amount ?? 0.0).toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            if (item.type != null && item.grams != null)
                              Text(
                                '${item.type} - ${item.grams}g',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              'Zakat: ₹${((item.amount ?? 0.0) * 0.025).toStringAsFixed(2)}',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Item'),
                                content: const Text('Are you sure you want to delete this item?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      provider.deleteItem(category, index);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<ZakatItem>(
            context,
            MaterialPageRoute(
              builder: (context) => AddZakatItemScreen(category: category),
            ),
          );

          if (result != null && context.mounted) {
            context.read<ZakatProvider>().addItem(result);
          }
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
} 