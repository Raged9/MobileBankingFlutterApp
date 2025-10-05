import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_data_provider.dart';
import 'package:intl/intl.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  String _formatBalance(double balance) {
    final formatter = NumberFormat('#,##0', 'id_ID');
    return formatter.format(balance);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, userDataProvider, child) {
        final userData = userDataProvider.userData;
        return Stack(
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              right: 24,
              child: Image.asset(
                'assets/images/cashless.png',
                height: 60,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Your Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${_formatBalance(userData?.balance ?? 0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userData?.cardNumber ?? '**** **** **** ****',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 2,
                        ),
                      ),
                      Image.asset(
                        'assets/images/visa.png',
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}