import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/zakat_provider.dart';
import '../utils/constants.dart';
import '../theme.dart';
import 'category_items_screen.dart';

class CalculateScreen extends StatelessWidget {
  const CalculateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculate Zakat'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ZakatProvider>(
        builder: (context, provider, child) {
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
                      '₹${(provider.getTotalZakat() * 0.025).toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: AppConstants.categories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryCard(context, AppConstants.categories[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String category) {
    final icon = _getCategoryIcon(category);
    final color = _getCategoryColor(category);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryItemsScreen(category: category),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                category,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Gold & Silver':
        return Icons.currency_exchange;
      case 'Cash & Bank':
        return Icons.account_balance_wallet;
      case 'Business Assets':
        return Icons.business;
      case 'Investments':
        return Icons.trending_up;
      case 'Property':
        return Icons.home;
      case 'Other Assets':
        return Icons.category;
      default:
        return Icons.attach_money;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Gold & Silver':
        return Colors.amber;
      case 'Cash & Bank':
        return Colors.green;
      case 'Business Assets':
        return Colors.blue;
      case 'Investments':
        return Colors.purple;
      case 'Property':
        return Colors.orange;
      case 'Other Assets':
        return Colors.grey;
      default:
        return AppTheme.primaryColor;
    }
  }
} 