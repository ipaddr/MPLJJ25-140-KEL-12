import 'package:flutter/material.dart';
import 'package:gaji_naik/admin/admin_login_page.dart';
import 'user_login_page.dart';
import 'register_user_page.dart'; // Pastikan Anda memiliki halaman RegisterUserPage

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 31, 164),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logoGajiNaik.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'GajiNaik',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Transparansi Gaji ASN dan Aparat Negara',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const Expanded(child: SizedBox()), // Takes up remaining space
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminLoginPage(),
                      ),
                    );
                    // TODO: Navigate to Admin login page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Admin',
                    style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserLoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'User',
                    style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Add the "Belum punya akun" button here
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserRegisterPage(), // Navigate to Register page
                  ),
                );
              },
              child: const Text(
                'Belum punya akun? Daftar di sini',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 40), // Space at the bottom
          ],
        ),
      ),
    );
  }
}
