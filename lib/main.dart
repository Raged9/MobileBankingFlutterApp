import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_data_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login.dart';
import 'screens/pin_screen.dart'; // Pastikan ini mengarah ke file yang benar (pin_screen.dart)

void main() {
  runApp(
    // 1. Provider ditempatkan di level tertinggi, di atas semua widget UI.
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
    // 2. MaterialApp adalah root dari UI, memastikan semua halaman
    //    mendapatkan konteks yang benar.
    return const MaterialApp(
      title: 'Mobile Banking App',
      debugShowCheckedModeBanner: false,
      // 3. Kita menggunakan widget 'AuthGate' untuk memisahkan logika
      //    autentikasi dari setup aplikasi utama.
      home: AuthGate(),
    );
  }
}

// 4. Widget baru ini khusus menangani logika pengecekan status login.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // 5. Consumer ditempatkan di sini, di dalam MaterialApp, sehingga memiliki
    //    akses ke Provider dan konteks navigasi yang valid.
    return Consumer<UserDataProvider>(
      builder: (context, userDataProvider, child) {
        // Tampilkan layar loading saat status login sedang diperiksa
        if (userDataProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Jika sudah login, tampilkan halaman verifikasi PIN
        if (userDataProvider.isLoggedIn && userDataProvider.userData != null) {
          // Ganti PinScreen menjadi PinVerificationScreen jika Anda sudah mengubah namanya
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
          // Jika belum, tampilkan halaman Login
          return const LoginPage();
        }
      },
    );
  }
}