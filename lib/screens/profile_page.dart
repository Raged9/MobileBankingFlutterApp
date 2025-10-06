import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/user_data_provider.dart';
import 'settings_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context).userData;

    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: const Color.fromARGB(255, 34, 85, 155),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: Color.fromARGB(255, 34, 85, 155),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userData?.name ?? 'Guest',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.yellow, size: 20),
                        SizedBox(width: 4),
                        Text(
                          "0 Points",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildCard(
              title: "Savings Account",
              accountName: "Tahapan Halo - IDR",
              accountNo: userData?.accountNumber ?? 'N/A',
              balance: currencyFormatter.format(userData?.balance ?? 0),
            ),
            _buildCard(
              title: "Investment",
              accountName: "Reksa Dana - IDR",
              accountNo: "INV-445-221",
              balance: "0",
            ),
            _buildCard(
              title: "Credit Card",
              accountName: "Visa Platinum",
              accountNo: "**** **** 1234",
              balance: "0",
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String accountName,
    required String accountNo,
    required String balance,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(accountName, style: const TextStyle(fontSize: 16)),
            Text(
              "Account No: $accountNo",
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 24),
            const Text(
              "Active Balance",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              balance,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 34, 85, 155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

