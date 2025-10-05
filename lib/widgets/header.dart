import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_data_provider.dart';
import '../screens/settings_screen.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context).userData;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/Logo.png',
                    height: 50,
                  ),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Hello',
                          style: TextStyle(color: Color.fromARGB(255, 0, 191, 255)),
                        ),
                        TextSpan(
                          text: 'Bank',
                          style: TextStyle(color: Color.fromARGB(255, 5, 34, 54)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Mr/Mrs. ${userData?.name ?? ''}',
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ],
          ),
          IconButton(
              icon: const Icon(Icons.settings, color: Colors.white, size: 24),
              onPressed: () => _navigateToSettings(context),
              style: IconButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 21, 68, 133),
                padding: const EdgeInsets.all(8.0),
                shape: const CircleBorder(),
              )),
        ],
      ),
    );
  }
}