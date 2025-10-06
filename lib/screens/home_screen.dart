// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../widgets/balance_card.dart';
import '../widgets/header.dart';
import '../widgets/quick_actions.dart';
import '../widgets/promo.dart';
import '../screens/profile_page.dart';
import 'info_screens.dart';
import 'transaction_screen.dart';
import 'qris_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        // Anda sudah di halaman Home
        break;
      case 1: // Item "News"
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InfoScreen()),
        );
        break;
      case 2: // Item "QRIS"
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const   QrisScreen()),
        );
        break;
      case 3: // Item "Profile"
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
      case 4: // Item "History"
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TransactionScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 85, 155),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Header(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: const [
                    BalanceCard(),
                    SizedBox(height: 16.0),
                    QuickActions(),
                    SizedBox(height: 18.0),
                    PromoSlider(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined), label: 'News'),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner), label: 'QRIS'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 34, 85, 155),
        unselectedItemColor: Colors.grey.shade600,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey.shade200,
        elevation: 5.0,
      ),
    );
  }
}