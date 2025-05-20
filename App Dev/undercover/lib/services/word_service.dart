import 'dart:math';
import '../models/word_pair.dart';

class WordService {
  final Random _random = Random();
  final Set<String> _recentlyUsedPairs = {};
  static const int _maxRecentPairs = 10; // Avoid repeating last 10 pairs

  // Word pairs organized in categories
  static final List<List<WordPair>> _categorizedWordPairs = [
    // Category 1: Objects and Items
    [
      WordPair(civilianWord: "Knife", imposterWord: "Sword"),
      WordPair(civilianWord: "Laptop", imposterWord: "Tablet"),
      WordPair(civilianWord: "Chair", imposterWord: "Sofa"),
      WordPair(civilianWord: "Pen", imposterWord: "Pencil"),
      WordPair(civilianWord: "Clock", imposterWord: "Watch"),
      WordPair(civilianWord: "Cup", imposterWord: "Mug"),
      WordPair(civilianWord: "Phone", imposterWord: "Radio"),
      WordPair(civilianWord: "Pillow", imposterWord: "Cushion"),
      WordPair(civilianWord: "Camera", imposterWord: "Binoculars"),
      WordPair(civilianWord: "Backpack", imposterWord: "Suitcase"),
    ],
    
    // Category 2: Nature and Environment
    [
      WordPair(civilianWord: "Mountain", imposterWord: "Hill"),
      WordPair(civilianWord: "Rain", imposterWord: "Snow"),
      WordPair(civilianWord: "Ocean", imposterWord: "Lake"),
      WordPair(civilianWord: "Planet", imposterWord: "Star"),
      WordPair(civilianWord: "Forest", imposterWord: "Jungle"),
      WordPair(civilianWord: "River", imposterWord: "Stream"),
      WordPair(civilianWord: "Desert", imposterWord: "Beach"),
      WordPair(civilianWord: "Volcano", imposterWord: "Mountain"),
      WordPair(civilianWord: "Cave", imposterWord: "Tunnel"),
      WordPair(civilianWord: "Island", imposterWord: "Peninsula"),
    ],
    
    // Category 3: Food and Drinks
    [
      WordPair(civilianWord: "Apple", imposterWord: "Orange"),
      WordPair(civilianWord: "Bread", imposterWord: "Cake"),
      WordPair(civilianWord: "Pizza", imposterWord: "Burger"),
      WordPair(civilianWord: "Coffee", imposterWord: "Tea"),
      WordPair(civilianWord: "Pasta", imposterWord: "Noodles"),
      WordPair(civilianWord: "Soup", imposterWord: "Stew"),
      WordPair(civilianWord: "Cookie", imposterWord: "Biscuit"),
      WordPair(civilianWord: "Rice", imposterWord: "Quinoa"),
      WordPair(civilianWord: "Juice", imposterWord: "Smoothie"),
      WordPair(civilianWord: "Salad", imposterWord: "Coleslaw"),
    ],
    
    // Category 4: Places and Locations
    [
      WordPair(civilianWord: "Library", imposterWord: "Bookstore"),
      WordPair(civilianWord: "Castle", imposterWord: "Palace"),
      WordPair(civilianWord: "Hospital", imposterWord: "Clinic"),
      WordPair(civilianWord: "School", imposterWord: "College"),
      WordPair(civilianWord: "Mall", imposterWord: "Market"),
      WordPair(civilianWord: "Airport", imposterWord: "Station"),
      WordPair(civilianWord: "Museum", imposterWord: "Gallery"),
      WordPair(civilianWord: "Restaurant", imposterWord: "Cafe"),
      WordPair(civilianWord: "Theater", imposterWord: "Cinema"),
      WordPair(civilianWord: "Park", imposterWord: "Garden"),
    ],
    
    // Category 5: Sports and Activities
    [
      WordPair(civilianWord: "Football", imposterWord: "Basketball"),
      WordPair(civilianWord: "Swimming", imposterWord: "Diving"),
      WordPair(civilianWord: "Tennis", imposterWord: "Badminton"),
      WordPair(civilianWord: "Running", imposterWord: "Jogging"),
      WordPair(civilianWord: "Boxing", imposterWord: "Wrestling"),
      WordPair(civilianWord: "Skiing", imposterWord: "Snowboarding"),
      WordPair(civilianWord: "Dancing", imposterWord: "Skating"),
      WordPair(civilianWord: "Cycling", imposterWord: "Skating"),
      WordPair(civilianWord: "Golf", imposterWord: "Cricket"),
      WordPair(civilianWord: "Volleyball", imposterWord: "Baseball"),
    ],
  ];

  WordPair getRandomWordPair() {
    // First randomization: Select a random category
    final categoryIndex = _random.nextInt(_categorizedWordPairs.length);
    final category = _categorizedWordPairs[categoryIndex];
    
    // Second randomization: Select a random pair from the category
    List<WordPair> availablePairs = category.where((pair) {
      final pairKey = '${pair.civilianWord}-${pair.imposterWord}';
      return !_recentlyUsedPairs.contains(pairKey);
    }).toList();
    
    // If all pairs in this category were recently used, use any pair
    if (availablePairs.isEmpty) {
      availablePairs = category;
    }
    
    // Get a random pair and add it to recently used
    final selectedPair = availablePairs[_random.nextInt(availablePairs.length)];
    final pairKey = '${selectedPair.civilianWord}-${selectedPair.imposterWord}';
    
    // Add to recently used and remove oldest if needed
    _recentlyUsedPairs.add(pairKey);
    if (_recentlyUsedPairs.length > _maxRecentPairs) {
      _recentlyUsedPairs.remove(_recentlyUsedPairs.first);
    }
    
    return selectedPair;
  }
} 