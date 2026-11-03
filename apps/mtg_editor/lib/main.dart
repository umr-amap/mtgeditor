import 'package:flutter/material.dart';

import 'database/app_database.dart';
import 'screens/organics_screen.dart';

void main() {
  runApp(MyApp(database: AppDatabase()));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.database, super.key});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MTG Editor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: OrganicsScreen(database: database),
    );
  }
}
