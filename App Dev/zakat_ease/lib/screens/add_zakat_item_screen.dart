import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/zakat_item.dart';
import '../providers/zakat_provider.dart';
import '../utils/constants.dart';
import '../theme.dart';

class AddZakatItemScreen extends StatefulWidget {
  final String category;

  const AddZakatItemScreen({
    super.key,
    required this.category,
  });

  @override
  State<AddZakatItemScreen> createState() => _AddZakatItemScreenState();
}

class _AddZakatItemScreenState extends State<AddZakatItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _gramsController = TextEditingController();
  String? _selectedType;
  String? _selectedKarat;

  @override
  void initState() {
    super.initState();
    // Fetch prices when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ZakatProvider>().fetchPrices();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _gramsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPreciousMetal = widget.category == 'Gold & Silver';

    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${widget.category} Item'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ZakatProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (isPreciousMetal) ...[
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Gold', child: Text('Gold')),
                        DropdownMenuItem(value: 'Silver', child: Text('Silver')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
                          _selectedKarat = null;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_selectedType == 'Gold')
                      DropdownButtonFormField<String>(
                        value: _selectedKarat,
                        decoration: const InputDecoration(
                          labelText: 'Karat',
                          border: OutlineInputBorder(),
                        ),
                        items: AppConstants.goldKarats
                            .map((karat) => DropdownMenuItem(
                                  value: karat,
                                  child: Text(karat),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedKarat = value;
                          });
                        },
                        validator: (value) {
                          if (_selectedType == 'Gold' && value == null) {
                            return 'Please select a karat';
                          }
                          return null;
                        },
                      ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _gramsController,
                      decoration: const InputDecoration(
                        labelText: 'Grams',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the weight in grams';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_selectedType != null) ...[
                      Text(
                        'Current Price: ₹${_selectedType == 'Gold' 
                            ? provider.getGoldPrice(_selectedKarat ?? '24K')
                            : provider.getSilverPrice()} per gram',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    if (widget.category == 'Gold & Silver' && _selectedType != null && _gramsController.text.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber[200]!),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Amount:'),
                                Text(
                                  '₹${_calculatePreciousMetalAmount(provider).toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Zakat Amount (2.5%):'),
                                Text(
                                  '₹${(_calculatePreciousMetalAmount(provider) * 0.025).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ] else
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount (₹)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: AppTheme.backgroundColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Add Item',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<ZakatProvider>();
      final item = ZakatItem(
        name: _nameController.text,
        category: widget.category,
        type: widget.category == 'Gold & Silver' 
            ? (_selectedType == 'Gold' ? '${_selectedKarat} Gold' : 'Silver')
            : widget.category,
        amount: widget.category == 'Gold & Silver'
            ? _calculatePreciousMetalAmount(provider)
            : double.parse(_amountController.text),
        karat: _selectedKarat,
        grams: widget.category == 'Gold & Silver'
            ? double.parse(_gramsController.text)
            : null,
      );

      Navigator.pop(context, item);
    }
  }

  double _calculatePreciousMetalAmount(ZakatProvider provider) {
    final grams = double.parse(_gramsController.text);
    final isGold = _selectedType == 'Gold';
    final pricePerGram = isGold
        ? provider.getGoldPrice(_selectedKarat ?? '24K')  // Price is already per gram from provider
        : provider.getSilverPrice();

    return grams * pricePerGram;
  }
} 