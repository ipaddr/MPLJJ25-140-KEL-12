import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gaji_naik/user/user_login_page.dart';

import 'change_password_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User data from Firebase
  Map<String, dynamic> _userData = {};
  bool _isLoading = true;
  bool _isUpdating = false;
  String _userId = '';

  // Controllers for edit mode
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _jabatanController = TextEditingController();

  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _jabatanController.dispose();
    super.dispose();
  }

  // Load user profile from Firebase
  Future<void> _loadUserProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        _userId = currentUser.uid;

        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(_userId).get();

        if (userDoc.exists) {
          setState(() {
            _userData = userDoc.data() as Map<String, dynamic>;

            // Initialize controllers with current data
            _nameController.text = _userData['namaLengkap'] ?? '';
            _phoneController.text = _userData['noTelepon'] ?? '';
            _jabatanController.text = _userData['jabatan'] ?? '';
          });

          print('User profile loaded: ${_userData['namaLengkap']}');
        } else {
          _showErrorMessage('Data profil tidak ditemukan');
        }
      } else {
        _showErrorMessage('User tidak terautentikasi');
        _navigateToLogin();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      print('Error loading user profile: $e');
      _showErrorMessage('Gagal memuat profil: ${e.toString()}');
    }
  }

  // Update user profile
  Future<void> _updateProfile() async {
    if (_nameController.text.trim().isEmpty) {
      _showErrorMessage('Nama lengkap tidak boleh kosong');
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      Map<String, dynamic> updateData = {
        'namaLengkap': _nameController.text.trim(),
        'noTelepon': _phoneController.text.trim(),
        'jabatan': _jabatanController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('users').doc(_userId).update(updateData);

      // Update local data
      setState(() {
        _userData.addAll(updateData);
        _isEditMode = false;
        _isUpdating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      print('Profile updated successfully');
    } catch (e) {
      setState(() {
        _isUpdating = false;
      });

      print('Error updating profile: $e');
      _showErrorMessage('Gagal memperbarui profil: ${e.toString()}');
    }
  }

  // Change password - navigate to new page
  void _navigateToChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
    );
  }

  // Logout with Firebase Auth
  Future<void> _logout() async {
    try {
      await _auth.signOut();
      _navigateToLogin();
    } catch (e) {
      _showErrorMessage('Gagal logout: ${e.toString()}');
    }
  }

  void _navigateToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const UserLoginPage()),
      (route) => false,
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Format date from Timestamp
  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Tidak diketahui';

    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  // Get last login info
  String get _lastLoginInfo {
    if (_userData['lastLoginAt'] != null) {
      return _formatDate(_userData['lastLoginAt']);
    }
    return 'Tidak diketahui';
  }

  // Get account created info
  String get _accountCreatedInfo {
    if (_userData['createdAt'] != null) {
      return _formatDate(_userData['createdAt']);
    }
    return 'Tidak diketahui';
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
              // AppBar section
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
                              Icons.person_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Profil Pengguna',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isEditMode ? Icons.close : Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (_isEditMode) {
                              // Cancel edit mode
                              setState(() {
                                _isEditMode = false;
                                // Reset controllers to original values
                                _nameController.text =
                                    _userData['namaLengkap'] ?? '';
                                _phoneController.text =
                                    _userData['noTelepon'] ?? '';
                                _jabatanController.text =
                                    _userData['jabatan'] ?? '';
                              });
                            } else {
                              setState(() {
                                _isEditMode = true;
                              });
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(height: 16),
                            Text(
                              'Memuat profil...',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Profile header with profile picture
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
                                children: [
                                  // Profile picture
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF1565C0),
                                        width: 4,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: const CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Color(0xFF1565C0),
                                      child: Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Name (editable)
                                  _isEditMode
                                      ? TextField(
                                          controller: _nameController,
                                          decoration: const InputDecoration(
                                            labelText: 'Nama Lengkap',
                                            border: OutlineInputBorder(),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      : Text(
                                          _userData['namaLengkap'] ??
                                              'Nama tidak diketahui',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1565C0),
                                          ),
                                        ),
                                  const SizedBox(height: 4),

                                  // Position (editable)
                                  if (_isEditMode) ...[
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: _jabatanController,
                                      decoration: const InputDecoration(
                                        labelText: 'Jabatan',
                                        border: OutlineInputBorder(),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ] else ...[
                                    Text(
                                      _userData['jabatan'] ??
                                          'Pegawai Negeri Sipil',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 20),

                                  // Quick stats
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color(0xFF1565C0)
                                          .withOpacity(0.08),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            const Text(
                                              'Last Login',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black45,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _lastLoginInfo,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF1565C0),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              'Member Since',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black45,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _accountCreatedInfo,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF1565C0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Save/Cancel buttons in edit mode
                                  if (_isEditMode) ...[
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: _isUpdating
                                                ? null
                                                : () {
                                                    setState(() {
                                                      _isEditMode = false;
                                                      // Reset to original values
                                                      _nameController
                                                          .text = _userData[
                                                              'namaLengkap'] ??
                                                          '';
                                                      _phoneController
                                                          .text = _userData[
                                                              'noTelepon'] ??
                                                          '';
                                                      _jabatanController.text =
                                                          _userData[
                                                                  'jabatan'] ??
                                                              '';
                                                    });
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey,
                                            ),
                                            child: const Text(
                                              'Batal',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: _isUpdating
                                                ? null
                                                : _updateProfile,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF1565C0),
                                            ),
                                            child: _isUpdating
                                                ? const SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : const Text(
                                                    'Simpan',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Personal Information
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
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.person_outline,
                                        color: Color(0xFF1565C0),
                                        size: 22,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Informasi Pribadi',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1565C0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // NIP (tidak bisa diubah)
                                  _buildInfoItem(
                                    icon: Icons.badge_outlined,
                                    title: 'NIP',
                                    value: _userData['nip'] ?? 'Belum diisi',
                                    isEditable: false,
                                  ),

                                  // Email (tidak bisa diubah)
                                  _buildInfoItem(
                                    icon: Icons.email_outlined,
                                    title: 'Email',
                                    value: _userData['email'] ?? 'Belum diisi',
                                    isEditable: false,
                                  ),

                                  // Phone (editable)
                                  _buildInfoItem(
                                    icon: Icons.phone_outlined,
                                    title: 'No. Telepon',
                                    value:
                                        _userData['noTelepon'] ?? 'Belum diisi',
                                    controller: _phoneController,
                                    isEditable: true,
                                    isLast: true,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Account Settings
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
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.settings_outlined,
                                        color: Color(0xFF1565C0),
                                        size: 22,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Pengaturan Akun',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1565C0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  _buildSettingItem(
                                    icon: Icons.lock_outline,
                                    title: 'Ubah Password',
                                    onTap: _navigateToChangePassword,
                                  ),
                                  _buildSettingItem(
                                    icon: Icons.refresh,
                                    title: 'Refresh Profil',
                                    onTap: _loadUserProfile,
                                  ),
                                  _buildSettingItem(
                                    icon: Icons.info_outline,
                                    title: 'Tentang Aplikasi',
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          title: const Text('Tentang Aplikasi'),
                                          content: const Text(
                                            'Gaji Naik v1.0\n\n'
                                            'Aplikasi untuk membantu ASN dalam:\n'
                                            '• Simulasi perhitungan gaji\n'
                                            '• Edukasi tentang kenaikan gaji\n'
                                            '• Laporan masalah dan dukungan\n\n'
                                            'Dikembangkan oleh Tim Gaji Naik',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Tutup'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    isLast: true,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Logout button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Show confirmation dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Konfirmasi Logout'),
                                      content: const Text(
                                          'Apakah Anda yakin ingin keluar dari akun?'),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _logout();
                                          },
                                          child: const Text(
                                            'Logout',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.logout,
                                    color: Colors.white),
                                label: const Text(
                                  'Keluar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),
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

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    TextEditingController? controller,
    bool isEditable = false,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.black54,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (_isEditMode && isEditable && controller != null)
                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    )
                  else
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Colors.black54,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}
