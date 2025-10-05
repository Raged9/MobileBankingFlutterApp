import 'package:flutter/material.dart';

class PinVerificationScreen extends StatefulWidget {
  // Alih-alih menerima PIN, kita menerima fungsi untuk verifikasi.
  // Ini lebih aman karena PIN asli tidak pernah diekspos ke UI.
  final Future<bool> Function(String) onPinVerified;
  final VoidCallback onVerificationSuccess;

  const PinVerificationScreen({
    super.key,
    required this.onPinVerified,
    required this.onVerificationSuccess,
  });

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  String _pin = '';
  int _attempts = 0;
  bool _isVerifying = false;

  void _onKeyPress(String value) async {
    if (_pin.length < 6) {
      setState(() {
        _pin += value;
      });
    }
    if (_pin.length == 6) {
      setState(() {
        _isVerifying = true;
      });

      // Panggil fungsi verifikasi dari provider
      final isCorrect = await widget.onPinVerified(_pin);

      if (!mounted) return;

      if (isCorrect) {
        widget.onVerificationSuccess();
      } else {
        setState(() {
          _attempts++;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PIN salah. Sisa percobaan: ${3 - _attempts}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _pin = ''; // Reset PIN
        });

        if (_attempts >= 3) {
          // Aksi jika sudah 3x salah, misal: logout atau kunci sementara
          Navigator.of(context).pop(false); // Keluar dari layar PIN
        }
      }
      setState(() {
        _isVerifying = false;
      });
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi PIN'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text('Masukkan PIN Transaksi Anda',
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            _isVerifying
                ? const CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                          color: index < _pin.length
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                        ),
                      );
                    }),
                  ),
            const Spacer(),
            Expanded(
              flex: 2,
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  if (index == 9) {
                    return const SizedBox
                        .shrink(); // Empty space for aesthetics
                  }
                  if (index == 11) {
                    return IconButton(
                      icon: const Icon(Icons.backspace_outlined, size: 30),
                      onPressed: _onDelete,
                    );
                  }
                  final number = index == 10 ? 0 : index + 1;
                  return TextButton(
                    style: TextButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                    child: Text(
                      '$number',
                      style: const TextStyle(
                          fontSize: 28, color: Colors.black87),
                    ),
                    onPressed: () => _onKeyPress('$number'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}