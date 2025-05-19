import 'package:flutter/material.dart';
import 'dashboard_user.dart'; // Import the dashboard file
import 'onboarding_page.dart';

class UserLoginPage extends StatelessWidget {
  const UserLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 31, 164),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigasi kembali ke halaman onboarding
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingPage()),
            );
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logoGajiNaik.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'GajiNaik',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Image.asset(
                  'assets/logoASN.png',
                  width: 200,
                  height: 150,
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'NIP/NIK/Email',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  // Navigate to the dashboard page after login (simulated)
                  onPressed: () {
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserDashboardPage()));
                    // TODO: Implement login logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}