import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'list_page.dart';

const String kUsername = 'zizi'; 
const String kPassword = '165'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userC = TextEditingController();
  final _passC = TextEditingController();

  @override
  void dispose() {
    _userC.dispose();
    _passC.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
  }

  Future<void> _login() async {
    final u = _userC.text.trim();
    final p = _passC.text.trim();
    if (u.isEmpty || p.isEmpty) {
      _showError('Username dan password tidak boleh kosong');
      return;
    }
    if (u != kUsername || p != kPassword) {
      _showError('Username atau password salah');
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    if (!mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const ListPage()));
  }

  OutlineInputBorder get _border => OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: Colors.grey.shade500),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selamat Datang di Resep Masakan',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _userC,
                decoration: InputDecoration(
                  labelText: 'Username',
                  enabledBorder: _border,
                  focusedBorder: _border.copyWith(
                    borderSide:
                        const BorderSide(color: Color(0xFF05C15A), width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passC,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  enabledBorder: _border,
                  focusedBorder: _border.copyWith(
                    borderSide:
                        const BorderSide(color: Color(0xFF05C15A), width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 14),
              FilledButton.tonal(
                onPressed: _login,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFEAF2E6),
                  foregroundColor: const Color(0xFF00776F),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}