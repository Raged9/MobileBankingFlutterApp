import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // Import untuk Timer

import 'common/theme.dart';
import 'providers/user_data_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login.dart';
import 'screens/pin_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserDataProvider()..checkLoginStatus(),
      child: const MobileBankingApp(),
    ),
  );
}

class MobileBankingApp extends StatelessWidget {
  const MobileBankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Banking App',
      theme: appTheme, // Menggunakan tema kustom
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Menampilkan SplashScreen pertama kali
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToAuthGate();
  }

  _navigateToAuthGate() async {
    await Future.delayed(const Duration(seconds: 3)); // Durasi splash screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthGate()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor, // Warna latar belakang sesuai tema
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Logo.png', // Pastikan path ini benar
              height: 150,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, userDataProvider, child) {
        if (userDataProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (userDataProvider.isLoggedIn && userDataProvider.userData != null) {
          return PinVerificationScreen(
            onPinVerified: (pin) {
              return userDataProvider.verifyPin(pin);
            },
            onVerificationSuccess: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}