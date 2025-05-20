class AppConstants {
  // Nisab values (in grams)
  static const double goldNisab = 87.48; // 7.5 tolas
  static const double silverNisab = 612.36; // 52.5 tolas

  // Zakat rate (2.5%)
  static const double zakatRate = 0.025;

  // Categories
  static const List<String> categories = [
    'Gold & Silver',
    'Cash & Bank',
    'Business Assets',
    'Investments',
    'Property',
    'Other Assets',
  ];

  // Asset Types
  static const List<String> assetTypes = [
    'Cash',
    'Savings',
    'Investment',
    'Property',
    'Business',
    'Other',
  ];

  // Gold/Silver Types
  static const List<String> preciousMetalTypes = [
    'Gold',
    'Silver',
  ];

  // Gold Karats
  static const List<String> goldKarats = [
    '24K',
    '22K',
  ];

  // Gold Price Cities
  static const List<String> goldPriceCities = [
    'Standard Rate',
    'Mumbai',
    'Delhi',
    'Chennai',
    'Kolkata',
    'Bangalore',
    'Hyderabad',
    'Ahmedabad',
    'Jaipur',
    'Kochi',
    'Pune',
    'Akola',
  ];

  // App text
  static const String appName = 'Zakat Ease';
  static const String calculateZakat = 'Calculate Zakat';
  static const String learnAboutZakat = 'Learn About Zakat';
  static const String recalculate = 'Recalculate';
  static const String learnMore = 'Learn More';
  static const String addNew = 'Add New';
  static const String total = 'Total';
  static const String selectType = 'Select Type';
  static const String enterName = 'Enter Name';
  static const String enterAmount = 'Enter Amount';
  static const String enterGrams = 'Enter Grams';
  static const String selectKarat = 'Select Karat';
  static const String totalZakat = 'Total Zakat';
  static const String selectCity = 'Select City';

  // Validation messages
  static const String requiredField = 'This field is required';
  static const String invalidAmount = 'Please enter a valid amount';
  static const String amountTooLarge = 'Amount is too large';

  // Current Prices (in INR per gram)
  static const double goldPrice24K = 6000.0;  // Example price for 24K gold
  static const double goldPrice22K = 5500.0;  // Example price for 22K gold
  static const double silverPrice = 75.0;     // Example price for silver
} 