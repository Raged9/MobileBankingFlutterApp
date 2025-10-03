// HISTORY TRANSACTION / FILTER TRANSACTION
import 'package:flutter/material.dart';
import 'common/theme.dart';
import 'screens/transaction_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Banking',
      theme: appTheme,
      home: const TransactionScreen(),
    );
  }
}

// INFO / BERITA
//import 'package:flutter/material.dart';
//import 'common/theme.dart';
//import 'screens/info_screens.dart';

//void main() {
//  runApp(const MyApp());
//}

//class MyApp extends StatelessWidget {
//  const MyApp({super.key});

//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      title: 'Mobile Banking',
//      theme: appTheme,
//      home: const InfoScreen(),
//    );
//  }
//}