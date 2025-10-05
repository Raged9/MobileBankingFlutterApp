import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian Profile Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white, // background icon
                    child: Icon(
                      Icons.person, // icon user polos
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Lionel Justin",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(Icons.star, color: Colors.yellow, size: 20),
                            SizedBox(width: 4),
                            Text(
                              "1,250 Points",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.settings, color: Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Savings Card
            _buildCard(
              title: "Savings Account",
              accountName: "Tahapan Xpresi - IDR",
              accountNo: "485-048-2255",
              balance: "Rp 12.500.000",
            ),

            // Investment Card
            _buildCard(
              title: "Investment",
              accountName: "Reksa Dana - IDR",
              accountNo: "INV-445-221",
              balance: "Rp 5.000.000",
            ),

            // Credit Card
            _buildCard(
              title: "Credit Card",
              accountName: "Visa Platinum",
              accountNo: "**** **** 1234",
              balance: "Rp 3.200.000",
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
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(accountName, style: const TextStyle(fontSize: 16)),
            Text("Account No: $accountNo",
                style: const TextStyle(color: Colors.grey)),
            const Divider(height: 24),
            const Text("Active Balance",
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text(balance,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                )),
          ],
        ),
      ),
    );
  }
}
