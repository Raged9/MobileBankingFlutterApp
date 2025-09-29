// File: lib/main.dart

import 'package:flutter/material.dart';
import '/common/theme.dart'; // Impor file theme.dart Anda
import 'screens/PindahDanaScreen.dart'; // Impor screen pindah dana
import 'screens/AddBalanceScreen.dart'; // Impor screen add balance

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Financial App',
      // Menerapkan tema yang sudah Anda definisikan ke seluruh aplikasi
      theme: appTheme,
      home: const HomeScreen(), // Halaman utama baru
    );
  }
}

// Halaman utama dengan dua tombol navigasi
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'App Demo',
          style: TextStyle(color: Colors.white), // Sesuaikan warna jika perlu
        ),
        backgroundColor: Colors.indigo, // Mengambil warna dari theme
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tombol untuk ke halaman Pindah Dana
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PindahDanaScreen(),
                    ),
                  );
                },
                child: const Text('Pindah Dana'),
              ),
              const SizedBox(height: 20),
              // Tombol untuk ke halaman Add Balance (Top Up)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddBalanceScreen(),
                    ),
                  );
                },
                child: const Text('Add Balance / Top Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}