// lib/widgets/balance_card.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_data_provider.dart';
import 'package:intl/intl.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isAccountNumberVisible = false;

  String _formatBalance(double balance) {
    final formatter = NumberFormat('#,##0', 'id_ID');
    return formatter.format(balance);
  }

  String _formatAccountNumber(String accountNumber, {required bool isVisible}) {
    if (accountNumber.length != 16) return accountNumber;

    if (isVisible) {
      return '${accountNumber.substring(0, 4)} ${accountNumber.substring(4, 8)} ${accountNumber.substring(8, 12)} ${accountNumber.substring(12, 16)}';
    } else {
      return '**** **** **** ${accountNumber.substring(12, 16)}';
    }
  }

  void _toggleAccountNumberVisibility() {
    setState(() {
      _isAccountNumberVisible = !_isAccountNumberVisible;
    });
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
                      GestureDetector(
                        onTap: _toggleAccountNumberVisibility,
                        child: Row(
                          children: [
                            Text(
                              _formatAccountNumber(
                                userData?.accountNumber ?? '',
                                isVisible: _isAccountNumberVisible,
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _isAccountNumberVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.white70,
                              size: 20,
                            ),
                          ],
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