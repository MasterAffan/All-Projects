import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../theme.dart';
import 'calculate_screen.dart';


class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Zakat'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoCard(
            context,
            'What is Zakat?',
            'Zakat is one of the Five Pillars of Islam. It is an obligatory form of charity that requires Muslims to donate 2.5% of their eligible wealth to those in need.',
          ),
          _buildInfoCard(
            context,
            'Nisab (Minimum Threshold)',
            'The minimum amount of wealth that makes Zakat obligatory:\n• Gold: 87.48 grams (7.5 tolas)\n• Silver: 612.36 grams (52.5 tolas)\n• Cash equivalent to the value of either',
          ),
          _buildInfoCard(
            context,
            'Eligible Assets',
            '• Gold and silver\n• Cash and bank balances\n• Investments and stocks\n• Property (excluding primary residence)\n• Business assets\n• Agricultural produce\n• Livestock',
          ),
          _buildInfoCard(
            context,
            'Who Can Receive Zakat?',
            '1. The poor\n2. The needy\n3. Zakat administrators\n4. New converts to Islam\n5. Slaves to be freed\n6. Debtors\n7. In the cause of Allah\n8. Travelers in need',
          ),
          _buildInfoCard(
            context,
            'Important Notes',
            '• Zakat is calculated on wealth held for one lunar year\n• Primary residence and personal items are exempt\n• Debts can be deducted from total wealth\n• Zakat should be paid promptly when due',
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CalculateScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Start Calculating'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
} 