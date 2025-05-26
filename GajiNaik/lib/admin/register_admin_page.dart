import 'package:flutter/material.dart';

class AdminRegisterPage extends StatefulWidget {
  const AdminRegisterPage({Key? key}) : super(key: key);

  @override
  _AdminRegisterPageState createState() => _AdminRegisterPageState();
}

class _AdminRegisterPageState extends State<AdminRegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  // Admin code field and variable removed

  @override
  void dispose() {
    _nameController.dispose();
    _nipController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    // Admin code controller removed
    super.dispose();
  }

  Future<void> _registerAdmin() async {
    if (_nameController.text.isEmpty ||
        _nipController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua field'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Admin code validation removed

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    String name = _nameController.text;
    String nip = _nipController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    print('Admin registration attempt with:');
    print('Name: $name');
    print('NIP: $nip');
    print('Email: $email');
    print('Password: $password');
    print('Role: Super Admin'); // Default role is now Super Admin

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registrasi admin berhasil! Silakan login'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to login page or other appropriate action
    Navigator.pop(context);
  }

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
          child: Column(
            children: [
              // Modern AppBar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.admin_panel_settings,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Registrasi Admin',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: IconButton(
                        icon:
                            const Icon(Icons.help_outline, color: Colors.white),
                        onPressed: () {
                          // Show help information
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Admin Logo
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.95),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.admin_panel_settings,
                          size: 80,
                          color: Color(0xFF1565C0),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Form Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.95),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Buat Akun Admin',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1565C0),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Lengkapi data untuk registrasi akun admin',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                height: 1.3,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Nama Lengkap Field
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Nama Lengkap',
                                labelStyle:
                                    const TextStyle(color: Color(0xFF1565C0)),
                                prefixIcon: const Icon(Icons.person,
                                    color: Color(0xFF1565C0)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF1565C0), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                fillColor: Colors.grey.withOpacity(0.05),
                                filled: true,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // NIP Field
                            TextField(
                              controller: _nipController,
                              decoration: InputDecoration(
                                labelText: 'NIP',
                                labelStyle:
                                    const TextStyle(color: Color(0xFF1565C0)),
                                prefixIcon: const Icon(Icons.badge,
                                    color: Color(0xFF1565C0)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF1565C0), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                fillColor: Colors.grey.withOpacity(0.05),
                                filled: true,
                              ),
                              keyboardType: TextInputType.number,
                            ),

                            const SizedBox(height: 20),

                            // Email Field
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle:
                                    const TextStyle(color: Color(0xFF1565C0)),
                                prefixIcon: const Icon(Icons.email,
                                    color: Color(0xFF1565C0)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF1565C0), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                fillColor: Colors.grey.withOpacity(0.05),
                                filled: true,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 20),

                            // Password Field
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle:
                                    const TextStyle(color: Color(0xFF1565C0)),
                                prefixIcon: const Icon(Icons.lock,
                                    color: Color(0xFF1565C0)),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF1565C0), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                fillColor: Colors.grey.withOpacity(0.05),
                                filled: true,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Admin role notice
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blue.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    color: Color(0xFF1565C0),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'Akun ini akan memiliki akses penuh sebagai Super Admin',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF1565C0),
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Register Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _registerAdmin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1565C0),
                                  foregroundColor: Colors.white,
                                  elevation: 5,
                                  shadowColor: Colors.blue.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      )
                                    : const Text(
                                        'Daftar Admin',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sudah memiliki akun admin?',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Masuk',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
