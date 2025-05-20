import 'package:flutter/material.dart';
import '../models/zakat_model.dart';
import '../utils/constants.dart';
import '../theme.dart';
import 'calculate_screen.dart';

class ResultScreen extends StatelessWidget {
  final ZakatModel zakatModel;

  const ResultScreen({
    super.key,
    required this.zakatModel,
  });

  @override
  Widget build(BuildContext context) {
    final totalAssets = zakatModel.calculateTotalAssets();
    final totalLiabilities = zakatModel.calculateTotalLiabilities();
    final netWorth = zakatModel.calculateNetWorth();
    final zakatAmount = zakatModel.calculateZakat();
    final breakdown = zakatModel.getZakatBreakdown();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zakat Calculation Result'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryRow('Total Assets', totalAssets),
                    _buildSummaryRow('Total Liabilities', totalLiabilities),
                    const Divider(),
                    _buildSummaryRow('Net Worth', netWorth, isTotal: true),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Zakat Amount', zakatAmount, isZakat: true),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Breakdown Section
            Text(
              'Breakdown by Asset',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...breakdown.entries.map((entry) => _buildBreakdownCard(
              context,
              entry.key,
              entry.value,
              zakatAmount,
            )),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CalculateScreen(),
                        ),
                      );
                    },
                    child: Text(AppConstants.recalculate),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Navigate to info screen
                    },
                    child: Text(AppConstants.learnMore),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false, bool isZakat = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isZakat ? AppTheme.secondaryColor : null,
              fontWeight: isZakat ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard(BuildContext context, String asset, double amount, double totalZakat) {
    final percentage = (amount / totalZakat * 100).toStringAsFixed(1);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  asset,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppTheme.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: amount / totalZakat,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
            const SizedBox(height: 4),
            Text(
              '$percentage% of total Zakat',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 