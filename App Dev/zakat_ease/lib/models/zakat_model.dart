import '../utils/constants.dart';

class ZakatModel {
  final Map<String, double> assets;
  final Map<String, double> liabilities;
  double? totalZakat;

  ZakatModel({
    required this.assets,
    required this.liabilities,
    this.totalZakat,
  });

  double calculateTotalAssets() {
    return assets.values.fold(0, (sum, value) => sum + value);
  }

  double calculateTotalLiabilities() {
    return liabilities.values.fold(0, (sum, value) => sum + value);
  }

  double calculateNetWorth() {
    return calculateTotalAssets() - calculateTotalLiabilities();
  }

  bool meetsNisab() {
    // Check if total assets meet either gold or silver nisab
    return calculateNetWorth() >= (AppConstants.goldNisab * 100); // Assuming gold price per gram is 100
  }

  double calculateZakat() {
    if (!meetsNisab()) {
      return 0;
    }

    double netWorth = calculateNetWorth();
    totalZakat = netWorth * AppConstants.zakatRate;
    return totalZakat!;
  }

  Map<String, double> getZakatBreakdown() {
    if (totalZakat == null) {
      calculateZakat();
    }

    Map<String, double> breakdown = {};
    double totalAssets = calculateTotalAssets();
    
    assets.forEach((key, value) {
      if (value > 0) {
        breakdown[key] = (value / totalAssets) * totalZakat!;
      }
    });

    return breakdown;
  }
} 