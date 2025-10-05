import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_data.dart';
import '../providers/user_data_provider.dart';
import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Map<String, Map<String, String>> _registeredUsers = {};

  bool _isLoginForm = true;
  int _loginAttempts = 0;

  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nikController = TextEditingController();
  final _pinController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRegisteredUsers();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nikController.dispose();
    _pinController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('registered_users');
    if (usersJson != null) {
      setState(() {
        final Map<String, dynamic> decodedMap = json.decode(usersJson);
        _registeredUsers = decodedMap.map(
          (key, value) => MapEntry(key, Map<String, String>.from(value)),
        );
      });
    }
  }

  Future<void> _saveRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = json.encode(_registeredUsers);
    await prefs.setString('registered_users', usersJson);
  }

  String _generateAccountNumber() {
    final random = Random();
    const fixedPrefix = '77777';
    String randomNumber = '';
    // Membuat 9 digit angka acak
    for (int i = 0; i < 9; i++) {
      randomNumber += random.nextInt(10).toString();
    }
    return fixedPrefix + randomNumber;
  }

  void _handleRegister() {
    if (_registerFormKey.currentState!.validate()) {
      final accountNumber = _generateAccountNumber();
      setState(() {
        _registeredUsers[_emailController.text] = {
          'name': _nameController.text,
          'password': _passwordController.text,
          'pin': _pinController.text,
          'nik': _nikController.text,
          'balance': '0', // Saldo awal
          'accountNumber': accountNumber, // Nomor rekening baru
        };
      });

      _saveRegisteredUsers();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran berhasil! Silakan login.'),
          backgroundColor: Colors.green,
        ),
      );
      _toggleForm();
    }
  }

  void _handleLogin() {
    if (_loginFormKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      if (_registeredUsers.containsKey(email) &&
          _registeredUsers[email]!['password'] == password) {
        _loginAttempts = 0;
        final userData = _registeredUsers[email]!;
        final currentUser = UserData(
          name: userData['name'] ?? 'Pengguna',
          email: email,
          cardNumber: '**** **** **** 1234',
          balance: double.parse(userData['balance'] ?? '0'),
          phoneNumber: '+62 812 3456 7890',
          address: 'Jakarta, Indonesia',
          accountNumber: userData['accountNumber'] ?? '',
        );

        Provider.of<UserDataProvider>(context, listen: false).loginUser(currentUser);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Login Berhasil!'), backgroundColor: Colors.green),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        setState(() {
          _loginAttempts++;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email atau password salah. Percobaan ke-$_loginAttempts.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _toggleForm() {
    setState(() {
      _isLoginForm = !_isLoginForm;
      _emailController.clear();
      _passwordController.clear();
      _nikController.clear();
      _pinController.clear();
      _nameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: _isLoginForm ? _buildLoginForm() : _buildRegisterForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        key: const ValueKey('login'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Selamat Datang', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(hintText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value!.isEmpty ? 'Email tidak boleh kosong' : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(hintText: 'Password'),
            obscureText: true,
            validator: (value) => value!.isEmpty ? 'Password tidak boleh kosong' : null,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleLogin,
            child: const Text('LOGIN'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _toggleForm,
            child: const Text('Belum punya akun? Daftar di sini'),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        key: const ValueKey('register'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Buat Akun Baru', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Nama Lengkap'),
            keyboardType: TextInputType.name,
            validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(hintText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value!.isEmpty ? 'Email tidak boleh kosong' : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(hintText: 'Password'),
            obscureText: true,
            validator: (value) => value!.isEmpty ? 'Password tidak boleh kosong' : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nikController,
            decoration: const InputDecoration(hintText: 'NIK'),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
            validator: (value) => value!.length < 16 ? 'NIK harus 16 digit' : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _pinController,
            decoration: const InputDecoration(hintText: 'Buat 6-digit PIN'),
            obscureText: true,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            validator: (value) => value!.length < 6 ? 'PIN harus 6 digit' : null,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleRegister,
            child: const Text('DAFTAR'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _toggleForm,
            child: const Text('Sudah punya akun? Login'),
          ),
        ],
      ),
    );
  }
}
