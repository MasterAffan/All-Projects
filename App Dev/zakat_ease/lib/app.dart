import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/home_screen.dart';

class ZakatEaseApp extends StatelessWidget {
  const ZakatEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zakat Ease',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
