import 'package:flutter/material.dart';
import '../widgets/balance_card.dart';
import '../widgets/header.dart';
import '../widgets/quick_actions.dart';
import 'placeholder_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _navigateToNewPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PlaceholderPage()),
    );
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      _navigateToNewPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 34, 85, 155),
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
                    QuickActions(),
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
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'News'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'QRIS'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 34, 85, 155),
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
