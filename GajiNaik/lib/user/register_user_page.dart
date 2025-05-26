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
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nikController.dispose();
    _teleponController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (_nikController.text.isEmpty || _teleponController.text.isEmpty || 
        _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua field'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isLoading = false;
    });

    String nik = _nikController.text;
    String telepon = _teleponController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    print('User registration attempt with NIK: $nik, Telepon: $telepon, Email: $email, Password: $password');
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registrasi berhasil! Silakan login'),
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                              Icons.person_add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Registrasi Akun',
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
                        icon: const Icon(Icons.help_outline, color: Colors.white),
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
                      // Logo
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
                        child: Image.asset(
                          'assets/logoGajiNaik.png',
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
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
                              'Buat Akun Baru',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1565C0),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Silakan lengkapi data diri Anda untuk membuat akun',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                height: 1.3,
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // NIP/NIK Field
                            TextField(
                              controller: _nikController,
                              decoration: InputDecoration(
                                labelText: 'NIP/NIK',
                                labelStyle: const TextStyle(color: Color(0xFF1565C0)),
                                prefixIcon: const Icon(Icons.badge, color: Color(0xFF1565C0)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                fillColor: Colors.grey.withOpacity(0.05),
                                filled: true,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Nomor Telepon Field
                            TextField(
                              controller: _teleponController,
                              decoration: InputDecoration(
                                labelText: 'Nomor Telepon',
                                labelStyle: const TextStyle(color: Color(0xFF1565C0)),
                                prefixIcon: const Icon(Icons.phone, color: Color(0xFF1565C0)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                fillColor: Colors.grey.withOpacity(0.05),
                                filled: true,
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Email Field
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: const TextStyle(color: Color(0xFF1565C0)),
                                prefixIcon: const Icon(Icons.email, color: Color(0xFF1565C0)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                                labelStyle: const TextStyle(color: Color(0xFF1565C0)),
                                prefixIcon: const Icon(Icons.lock, color: Color(0xFF1565C0)),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
                                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                fillColor: Colors.grey.withOpacity(0.05),
                                filled: true,
                              ),
                            ),
                            
                            const SizedBox(height: 30),
                            
                            // Register Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _registerUser,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1565C0),
                                  foregroundColor: Colors.white,
                                  elevation: 5,
                                  shadowColor: Colors.blue.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      )
                                    : const Text(
                                        'Daftar',
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
                            'Sudah memiliki akun?',
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