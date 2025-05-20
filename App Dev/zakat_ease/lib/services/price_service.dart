import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import '../utils/constants.dart';

class PriceService {
  static Future<Map<String, dynamic>> fetchPrices() async {
    return {
      'silver': await fetchSilverPrice(),
      'gold': await fetchGoldPrices(),
    };
  }

  static Future<String?> fetchSilverPrice() async {
    try {
      final url = Uri.parse('website link');
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        },
      );

      if (response.statusCode == 200) {
        var document = parser.parse(response.body);
        var silverPriceElement = document.querySelector('.white-space-nowrap');
        return silverPriceElement?.text.trim() ?? 'Silver Price Not Found';
      } else {
        return 'Failed to fetch Silver Price';
      }
    } catch (e) {
      return 'Error fetching Silver Price';
    }
  }

  static Future<Map<String, String>> fetchGoldPrices() async {
    try {
      final url = Uri.parse('website link');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var document = parser.parse(response.body);
        var priceContainers = document.querySelectorAll('.absolute-center.bodyLargeHeavy');

        if (priceContainers.length >= 2) {
          String price24K = priceContainers[0].querySelectorAll('span.bodyLarge').map((e) => e.text.trim()).join();
          String price22K = priceContainers[1].querySelectorAll('span.bodyLarge').map((e) => e.text.trim()).join();

          return {
            '24K': price24K,
            '22K': price22K,
          };
        } else {
          return {'error': 'Gold Prices Not Found'};
        }
      } else {
        return {'error': 'Failed to fetch Gold Prices'};
      }
    } catch (e) {
      return {'error': 'Error fetching Gold Prices'};
    }
  }
} 