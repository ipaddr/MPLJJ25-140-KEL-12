import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({Key? key}) : super(key: key);

  @override
  _UserRegisterPageState createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final TextEditingController _nameController = TextEditingController(); // ✅ TAMBAHAN FIELD NAMA
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose(); // ✅ DISPOSE NAMA CONTROLLER
    _nikController.dispose();
    _teleponController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    // ✅ VALIDASI TERMASUK NAMA LENGKAP
    if (_nameController.text.isEmpty ||
        _nikController.text.isEmpty || 
        _teleponController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passwordController.text.isEmpty) {
      _showErrorMessage('Mohon lengkapi semua field');
      return;
    }

    // ✅ VALIDASI NAMA LENGKAP (minimal 2 kata)
    if (_nameController.text.trim().split(' ').length < 2) {
      _showErrorMessage('Nama lengkap harus minimal 2 kata');
      return;
    }

    // Email validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text)) {
      _showErrorMessage('Format email tidak valid');
      return;
    }

    // Password validation (minimum 6 characters)
    if (_passwordController.text.length < 6) {
      _showErrorMessage('Password minimal 6 karakter');
      return;
    }

    // Phone validation
    if (!RegExp(r'^(\+62|62|0)[0-9]{9,13}$')
        .hasMatch(_teleponController.text)) {
      _showErrorMessage('Format nomor telepon tidak valid');
      return;
    }

    // NIK validation (should be 16 digits)
    if (_nikController.text.length != 16 || 
        !RegExp(r'^[0-9]+$').hasMatch(_nikController.text)) {
      _showErrorMessage('NIK harus 16 digit angka');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Check if NIK already exists
      final nikQuery = await _firestore
          .collection('users')
          .where('nip', isEqualTo: _nikController.text)
          .get();

      if (nikQuery.docs.isNotEmpty) {
        _showErrorMessage('NIK sudah terdaftar');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Check if phone number already exists
      final phoneQuery = await _firestore
          .collection('users')
          .where('noTelepon', isEqualTo: _teleponController.text)
          .get();

      if (phoneQuery.docs.isNotEmpty) {
        _showErrorMessage('Nomor telepon sudah terdaftar');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Create user with Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        // ✅ UPDATE DISPLAY NAME DENGAN NAMA LENGKAP
        await user.updateDisplayName(_nameController.text.trim());

        // ✅ SAVE USER DATA TO FIRESTORE (TERMASUK NAMA LENGKAP)
        await _firestore.collection('users').doc(user.uid).set({
          'namaLengkap': _nameController.text.trim(), // ✅ FIELD NAMA LENGKAP
          'noTelepon': _teleponController.text.trim(),
          'nip': _nikController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text, // Note: Consider removing this for security
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'uid': user.uid,
          'role': 'User',
          'isEmailVerified': false,
        });

        // Wait a moment before sending verification email
        await Future.delayed(const Duration(seconds: 1));

        // Send email verification with retry mechanism
        await _sendEmailVerificationWithRetry(user);

        print('User registration successful:');
        print('Nama Lengkap: ${_nameController.text}'); // ✅ LOG NAMA LENGKAP
        print('NIK: ${_nikController.text}');
        print('Phone: ${_teleponController.text}');
        print('Email: ${_emailController.text}');
        print('UID: ${user.uid}');
        print('Role: User');

        // Show success message
        _showSuccessMessage(
          'Registrasi berhasil! Email verifikasi telah dikirim ke ${_emailController.text}. Silakan cek email dan folder spam.',
        );

        // Show dialog for email verification
        _showEmailVerificationDialog();
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getFirebaseErrorMessage(e.code);
      _showErrorMessage(errorMessage);
    } catch (e) {
      print('Error during registration: $e');
      _showErrorMessage('Terjadi kesalahan. Silakan coba lagi.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _sendEmailVerificationWithRetry(User user, {int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        await user.sendEmailVerification();
        print('Email verification sent successfully (attempt ${i + 1})');
        return;
      } catch (e) {
        print('Email verification failed (attempt ${i + 1}): $e');
        if (i == maxRetries - 1) {
          throw e;
        }
        await Future.delayed(Duration(seconds: (i + 1) * 2));
      }
    }
  }

  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password terlalu lemah';
      case 'email-already-in-use':
        return 'Email sudah terdaftar';
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'operation-not-allowed':
        return 'Operasi tidak diizinkan';
      default:
        return 'Terjadi kesalahan saat registrasi';
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _showEmailVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.mark_email_read, color: Color(0xFF1565C0)),
              SizedBox(width: 8),
              Text('Verifikasi Email'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email verifikasi telah dikirim ke:',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Text(
                  _emailController.text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '📧 Silakan cek email Anda dan klik link verifikasi untuk mengaktifkan akun.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              const Text(
                '⚠️ Jika tidak ada di inbox, cek folder spam/junk.',
                style: TextStyle(fontSize: 12, color: Colors.orange),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                User? user = _auth.currentUser;
                if (user != null && !user.emailVerified) {
                  try {
                    await _sendEmailVerificationWithRetry(user);
                    _showSuccessMessage('Email verifikasi telah dikirim ulang');
                  } catch (e) {
                    _showErrorMessage('Gagal mengirim email verifikasi');
                  }
                }
              },
              child: const Text('📤 Kirim Ulang'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to login page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
                            'Registrasi User',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
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
                          height: 80,
                          width: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person_add,
                              size: 80,
                              color: Color(0xFF1565C0),
                            );
                          },
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
                            
                            // ✅ FIELD NAMA LENGKAP (POSISI PERTAMA)
                            _buildTextField(
                              controller: _nameController,
                              labelText: 'Nama Lengkap',
                              icon: Icons.person,
                              keyboardType: TextInputType.name,
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // NIK Field
                            _buildTextField(
                              controller: _nikController,
                              labelText: 'NIK (16 digit)',
                              icon: Icons.badge,
                              keyboardType: TextInputType.number,
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Nomor Telepon Field
                            _buildTextField(
                              controller: _teleponController,
                              labelText: 'Nomor Telepon',
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Email Field
                            _buildTextField(
                              controller: _emailController,
                              labelText: 'Email',
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Password Field
                            _buildTextField(
                              controller: _passwordController,
                              labelText: 'Password',
                              icon: Icons.lock,
                              obscureText: _obscurePassword,
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
                            ),
                            
                            const SizedBox(height: 20),

                            // Info notice
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
                                      'Email verifikasi akan dikirim setelah registrasi. Pastikan data yang dimasukkan sudah benar.',
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
                                        'Daftar Sekarang',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Color(0xFF1565C0)),
        prefixIcon: Icon(icon, color: Color(0xFF1565C0)),
        suffixIcon: suffixIcon,
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
    );
  }
}