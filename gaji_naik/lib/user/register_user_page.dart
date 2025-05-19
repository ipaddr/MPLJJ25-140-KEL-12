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
    // TODO: Implement user registration logic here
    String nik = _nikController.text;
    String telepon = _teleponController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    print('User registration attempt with NIK: $nik, Telepon: $telepon, Email: $email, Password: $password');
    // Add your registration logic (e.g., call an API)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 31, 164),
      appBar: AppBar(
        title: const Text('Register User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/logoGajiNaik.png', height: 100),
              const SizedBox(height: 40),
              // NIP/NIK TextField
              TextField(
                controller: _nikController,
                decoration: InputDecoration(
                  labelText: 'NIP/NIK',
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8), // Slightly transparent background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Nomor Telepon TextField
              TextField(
                controller: _teleponController,
                decoration: InputDecoration(
                  labelText: 'Nomor Telepon',
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8), // Slightly transparent background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                keyboardType: TextInputType.phone, // Set keyboard type to phone
              ),
              const SizedBox(height: 20),
              // Email TextField
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8), // Slightly transparent background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                keyboardType: TextInputType.emailAddress, // Set keyboard type to email
              ),
              const SizedBox(height: 20),
              // Password TextField
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8), // Slightly transparent background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
