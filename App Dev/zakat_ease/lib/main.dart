import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/zakat_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ZakatProvider(),
      child: const ZakatEaseApp(),
    ),
  );
}
