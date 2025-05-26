import 'package:flutter/material.dart';
import 'package:gaji_naik/admin/admin_login_page.dart';
import 'user/user_login_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1565C0),
              Color(0xFF0D47A1),
              Color(0xFF0A1F64),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 60),
                  // Logo with glassmorphism effect
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/logoGajiNaik.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // App title with modern typography
                  const Text(
                    'GajiNaik',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.15),
                    ),
                    child: const Text(
                      'Transparansi Gaji ASN dan Aparat Negara',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xE6FFFFFF),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  // Modern buttons with better spacing
                  Column(
                    children: [
                      _buildModernButton(
                        context,
                        'Admin',
                        Icons.admin_panel_settings_outlined,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminLoginPage(),
                            ),
                          );
                        },
                        isPrimary: true,
                      ),
                      const SizedBox(height: 16),
                      _buildModernButton(
                        context,
                        'User',
                        Icons.person_outline,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserLoginPage(),
                            ),
                          );
                        },
                        isPrimary: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Removed the registration button that was here
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed, {
    required bool isPrimary,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 22,
          color: isPrimary ? const Color(0xFF0D47A1) : Colors.white,
        ),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isPrimary ? const Color(0xFF0D47A1) : Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.white : Colors.transparent,
          foregroundColor: isPrimary ? const Color(0xFF0D47A1) : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(
                    color: Colors.white.withOpacity(0.3), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }
}