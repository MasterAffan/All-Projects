import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/zakat_item.dart';
import '../services/price_service.dart';

class ZakatProvider with ChangeNotifier {
  final Map<String, List<ZakatItem>> _items = {};
  Map<String, dynamic> _prices = {};
  bool _isLoading = false;
  static const String _storageKey = 'zakat_items';

  Map<String, List<ZakatItem>> get items => _items;
  Map<String, dynamic> get prices => _prices;
  bool get isLoading => _isLoading;

  ZakatProvider() {
    loadItems();
  }

  Future<void> loadItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? itemsJson = prefs.getString(_storageKey);
      
      if (itemsJson != null) {
        final Map<String, dynamic> decoded = json.decode(itemsJson);
        _items.clear();
        
        decoded.forEach((category, itemsList) {
          _items[category] = (itemsList as List)
              .map((item) => ZakatItem.fromJson(item))
              .toList();
        });
        
        notifyListeners();
      }
    } catch (e) {
      print('Error loading items: $e');
    }
  }

  Future<void> _saveItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> encoded = {};
      
      _items.forEach((category, items) {
        encoded[category] = items.map((item) => item.toJson()).toList();
      });
      
      await prefs.setString(_storageKey, json.encode(encoded));
    } catch (e) {
      print('Error saving items: $e');
    }
  }

  Future<void> fetchPrices() async {
    _isLoading = true;
    notifyListeners();

    try {
      final newPrices = await PriceService.fetchPrices();
      
      // Only update prices if we got valid data
      if (newPrices['gold'] != null && newPrices['silver'] != null) {
        _prices = newPrices;
        await _updatePreciousMetalAmounts();
      }
    } catch (e) {
      print('Error fetching prices: $e');
      // Don't update prices if there's an error, keep the last fetched prices
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _updatePreciousMetalAmounts() async {
    if (!_items.containsKey('Gold & Silver')) return;

    final updatedItems = _items['Gold & Silver']!.map((item) {
      if (item.type.contains('Gold') && item.grams != null) {
        final pricePerGram = getGoldPrice(item.karat ?? '24K');
        return ZakatItem(
          name: item.name,
          category: item.category,
          type: item.type,
          amount: item.grams! * pricePerGram,
          karat: item.karat,
          grams: item.grams,
        );
      } else if (item.type == 'Silver' && item.grams != null) {
        final pricePerGram = getSilverPrice();
        return ZakatItem(
          name: item.name,
          category: item.category,
          type: item.type,
          amount: item.grams! * pricePerGram,
          karat: item.karat,
          grams: item.grams,
        );
      }
      return item;
    }).toList();

    _items['Gold & Silver'] = updatedItems;
    await _saveItems();
  }

  void addItem(ZakatItem item) {
    if (!_items.containsKey(item.category)) {
      _items[item.category] = [];
    }
    _items[item.category]!.add(item);
    _saveItems();
    notifyListeners();
  }

  void deleteItem(String category, int index) {
    if (_items.containsKey(category) && index < _items[category]!.length) {
      _items[category]!.removeAt(index);
      _saveItems();
      notifyListeners();
    }
  }

  double getTotalZakat() {
    double total = 0.0;
    _items.forEach((category, items) {
      total += items.fold<double>(0.0, (sum, item) => sum + (item.amount ?? 0.0));
    });
    return total;
  }

  double getCategoryTotal(String category) {
    final items = _items[category];
    if (items == null) return 0.0;
    return items.fold<double>(0.0, (sum, item) => sum + (item.amount ?? 0.0));
  }

  double getGoldPrice(String karat) {
    if (_prices['gold'] != null) {
      final goldPrices = _prices['gold'] as Map<String, String>;
      final priceStr = goldPrices[karat]?.replaceAll(RegExp(r'[^0-9.]'), '');
      return (double.tryParse(priceStr ?? '') ?? 0.0) / 10;
    }
    return 0.0;
  }

  double getSilverPrice() {
    if (_prices['silver'] != null) {
      final priceStr = _prices['silver'].toString().replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(priceStr) ?? 0.0;
    }
    return 0.0;
  }
} 