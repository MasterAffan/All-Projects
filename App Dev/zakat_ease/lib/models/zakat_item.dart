class ZakatItem {
  final String name;
  final String category;
  final String type;
  final double? amount;
  final String? karat;
  final double? grams;

  ZakatItem({
    required this.name,
    required this.category,
    required this.type,
    this.amount,
    this.karat,
    this.grams,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'type': type,
      'amount': amount,
      'karat': karat,
      'grams': grams,
    };
  }

  factory ZakatItem.fromJson(Map<String, dynamic> json) {
    return ZakatItem(
      name: json['name'] as String,
      category: json['category'] as String,
      type: json['type'] as String,
      amount: json['amount'] as double?,
      karat: json['karat'] as String?,
      grams: json['grams'] as double?,
    );
  }
} 