import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants.dart';
import '../theme.dart';
import 'calculate_screen.dart';
import 'info_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Function to launch the URL
  void _launchURL() async {
    const url = 'https://m-a-affan.web.app/';
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // Ensures it opens in the browser
    )) {
      throw Exception('Could not launch $url');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),
              // App Logo and Name
              const Icon(
                Icons.mosque,
                size: 100,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Calculate your Zakat with ease',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              // Main Buttons
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
                child: Text(
                  AppConstants.calculateZakat,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InfoScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  side: const BorderSide(color: AppTheme.primaryColor),
                ),
                child: Text(
                  AppConstants.learnAboutZakat,
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              const Spacer(),
              // Meet the Developer Link at the Bottom
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: _launchURL,
                  child: Text(
                    'Meet the Developer',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.primaryColor,
                      decoration: TextDecoration.none, // No underline
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
