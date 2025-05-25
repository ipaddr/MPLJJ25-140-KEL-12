import 'package:flutter/material.dart';

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({Key? key}) : super(key: key);

  @override
  _UserRegisterPageState createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nikController.dispose();
    _teleponController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _registerUser() {
    String nik = _nikController.text;
    String telepon = _teleponController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    print('User registration attempt with NIK: $nik, Telepon: $telepon, Email: $email, Password: $password');
    // Tambahkan logika registrasi sesuai kebutuhan
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: const Color.fromARGB(255, 10, 31, 164), width: 2),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background putih bersih
      appBar: AppBar(
        title: const Text('Register User'),
        backgroundColor: const Color.fromARGB(255, 10, 31, 164),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/logoGajiNaik.png',
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40),

            // NIK
            TextField(
              controller: _nikController,
              decoration: _buildInputDecoration('NIP/NIK'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // Telepon
            TextField(
              controller: _teleponController,
              decoration: _buildInputDecoration('Nomor Telepon'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),

            // Email
            TextField(
              controller: _emailController,
              decoration: _buildInputDecoration('Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),

            // Password
            TextField(
              controller: _passwordController,
              decoration: _buildInputDecoration('Password'),
              obscureText: true,
            ),
            const SizedBox(height: 36),

            // Tombol Daftar dengan gradasi dan shadow
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _registerUser,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 6,
                  shadowColor: Colors.blue.shade200,
                  backgroundColor:const Color.fromARGB(255, 10, 31, 164), // fallback warna bila gradien tidak didukung
                ).copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (states) => null,
                  ),
                  elevation: MaterialStateProperty.all(0),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [const Color.fromARGB(255, 10, 31, 164), Color(0xFF42A5F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: const Text(
                      'Daftar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
