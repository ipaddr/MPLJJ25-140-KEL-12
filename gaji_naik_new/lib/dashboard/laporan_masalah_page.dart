import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'laporan_masalah_sukses_page.dart';

class LaporanMasalahPage extends StatefulWidget {
  const LaporanMasalahPage({Key? key}) : super(key: key);

  @override
  _LaporanMasalahPageState createState() => _LaporanMasalahPageState();
}

class _LaporanMasalahPageState extends State<LaporanMasalahPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Data profil yang akan auto-fill dari Firebase
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _instansiController = TextEditingController();
  final TextEditingController _golonganController = TextEditingController();

  String? _selectedCategory;
  String? _selectedPriority = 'Medium';
  bool _isLoading = false;
  bool _isLoadingProfile = true;

  final List<String> _categoryOptions = [
    'Masalah Gaji',
    'Masalah Tunjangan',
    'Masalah Kenaikan Pangkat',
    'Masalah Administrasi',
    'Masalah Teknis Aplikasi',
    'Lainnya'
  ];

  final List<String> _priorityOptions = ['High', 'Medium', 'Low'];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Data user yang login
  Map<String, dynamic> _userData = {};
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _nameController.dispose();
    _nipController.dispose();
    _phoneController.dispose();
    _instansiController.dispose();
    _golonganController.dispose();
    super.dispose();
  }

  // Load data profil user yang sedang login
  Future<void> _loadUserProfile() async {
    try {
      setState(() {
        _isLoadingProfile = true;
      });

      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        _userId = currentUser.uid;

        // Ambil data user dari Firestore berdasarkan UID
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(_userId).get();

        if (userDoc.exists) {
          _userData = userDoc.data() as Map<String, dynamic>;

          // Auto-fill form dengan data user
          setState(() {
            _nameController.text = _userData['namaLengkap'] ?? '';
            _nipController.text = _userData['nip'] ?? '';
            _phoneController.text = _userData['noTelepon'] ?? '';
            // Instansi dan golongan bisa kosong jika belum diisi user
            _instansiController.text = _userData['instansi'] ?? '';
            _golonganController.text = _userData['golongan'] ?? '';
          });

          print('User profile loaded:');
          print('Name: ${_nameController.text}');
          print('NIP: ${_nipController.text}');
          print('Phone: ${_phoneController.text}');
          print('Instansi: ${_instansiController.text}');
          print('Golongan: ${_golonganController.text}');
        } else {
          _showErrorMessage(
              'Data profil tidak ditemukan. Silakan logout dan login kembali.');
        }
      } else {
        _showErrorMessage('User tidak terautentikasi. Silakan login kembali.');
      }

      setState(() {
        _isLoadingProfile = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingProfile = false;
      });

      print('Error loading user profile: $e');
      _showErrorMessage('Gagal memuat data profil: ${e.toString()}');
    }
  }

  // Submit laporan dengan data user yang sudah terisi otomatis
  Future<void> _submitReport() async {
    // Validasi form
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _selectedCategory == null) {
      _showErrorMessage(
          'Mohon lengkapi judul, deskripsi, dan kategori laporan');
      return;
    }

    // Validasi data profil (harus ada nama dan NIP minimal)
    if (_nameController.text.trim().isEmpty ||
        _nipController.text.trim().isEmpty) {
      _showErrorMessage(
          'Data profil tidak lengkap. Nama dan NIP harus terisi.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Data laporan yang akan disimpan
      Map<String, dynamic> reportData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory!,
        'priority': _selectedPriority!,
        'status': 'Pending', // Status default

        // Data user dari profil yang sudah auto-fill
        'user_id': _userId,
        'user_name': _nameController.text.trim(),
        'nip': _nipController.text.trim(),
        'phone': _phoneController.text.trim(),
        'instansi': _instansiController.text.trim(),
        'golongan': _golonganController.text.trim(),

        // Timestamp
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      };

      // Simpan laporan ke Firebase
      DocumentReference docRef =
          await _firestore.collection('reports').add(reportData);

      print('Report submitted successfully with ID: ${docRef.id}');
      print('Report data: $reportData');

      setState(() {
        _isLoading = false;
      });

      // Navigasi ke halaman sukses dengan data laporan
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LaporanMasalahKonfirmasiPage(
            reportId: docRef.id,
            reportData: reportData,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      print('Error submitting report: $e');
      _showErrorMessage('Gagal mengirim laporan: ${e.toString()}');
    }
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

  // Helper method untuk mendapatkan warna prioritas
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Helper method untuk mendapatkan icon prioritas
  IconData _getPriorityIcon(String priority) {
    switch (priority) {
      case 'High':
        return Icons.keyboard_double_arrow_up;
      case 'Medium':
        return Icons.keyboard_arrow_up;
      case 'Low':
        return Icons.keyboard_arrow_down;
      default:
        return Icons.priority_high;
    }
  }

  // Helper method untuk mendapatkan warna kategori
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Masalah Gaji':
        return Colors.green;
      case 'Masalah Tunjangan':
        return Colors.blue;
      case 'Masalah Kenaikan Pangkat':
        return Colors.purple;
      case 'Masalah Administrasi':
        return Colors.orange;
      case 'Masalah Teknis Aplikasi':
        return Colors.red;
      case 'Lainnya':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  // Helper method untuk mendapatkan icon kategori
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Masalah Gaji':
        return Icons.payments;
      case 'Masalah Tunjangan':
        return Icons.account_balance_wallet;
      case 'Masalah Kenaikan Pangkat':
        return Icons.trending_up;
      case 'Masalah Administrasi':
        return Icons.admin_panel_settings;
      case 'Masalah Teknis Aplikasi':
        return Icons.bug_report;
      case 'Lainnya':
        return Icons.help_outline;
      default:
        return Icons.category;
    }
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
                              Icons.report_problem,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Laporan Masalah',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_isLoadingProfile)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: _isLoadingProfile
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(height: 16),
                            Text(
                              'Memuat data profil...',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Card
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
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.support_agent,
                                      size: 40,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Laporkan Masalah Anda',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Sampaikan kendala atau masalah yang Anda alami',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                            height: 1.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Data Profil Section (Auto-filled, Read-only)
                            const Text(
                              'Data Profil Anda',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 16),

                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blue.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.info_outline,
                                          color: Colors.blue),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Data ini diambil dari profil akun Anda',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(Icons.refresh,
                                            color: Colors.blue),
                                        onPressed: _loadUserProfile,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Profile Info Cards
                                  _buildProfileInfoCard('Nama Lengkap',
                                      _nameController.text, Icons.person),
                                  const SizedBox(height: 12),
                                  _buildProfileInfoCard(
                                      'NIP', _nipController.text, Icons.badge),
                                  const SizedBox(height: 12),
                                  _buildProfileInfoCard('No. Telepon',
                                      _phoneController.text, Icons.phone),
                                  if (_instansiController.text.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    _buildProfileInfoCard(
                                        'Instansi',
                                        _instansiController.text,
                                        Icons.business),
                                  ],
                                  if (_golonganController.text.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    _buildProfileInfoCard('Golongan',
                                        _golonganController.text, Icons.star),
                                  ],
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Detail Laporan Section
                            const Text(
                              'Detail Laporan *',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Judul Laporan
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white.withOpacity(0.95),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                  labelText: 'Judul Laporan',
                                  labelStyle:
                                      const TextStyle(color: Colors.orange),
                                  prefixIcon: const Icon(Icons.title,
                                      color: Colors.orange),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Kategori Dropdown - PERBAIKAN UI
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white.withOpacity(0.95),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                decoration: InputDecoration(
                                  labelText: 'Kategori Masalah',
                                  labelStyle: TextStyle(
                                    color: _selectedCategory != null
                                        ? _getCategoryColor(_selectedCategory!)
                                        : Colors.orange,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon: Icon(
                                    _selectedCategory != null
                                        ? _getCategoryIcon(_selectedCategory!)
                                        : Icons.category,
                                    color: _selectedCategory != null
                                        ? _getCategoryColor(_selectedCategory!)
                                        : Colors.orange,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: _selectedCategory != null
                                          ? _getCategoryColor(
                                              _selectedCategory!)
                                          : Colors.orange,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                                hint: const Text(
                                  'Pilih Kategori Masalah',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey[600],
                                ),
                                isExpanded: true,
                                items: _categoryOptions.map((category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Row(
                                      children: [
                                        Icon(
                                          _getCategoryIcon(category),
                                          color: _getCategoryColor(category),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            category,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCategory = newValue;
                                  });
                                },
                                dropdownColor: Colors.white,
                                elevation: 8,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Priority Dropdown - PERBAIKAN UI
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white.withOpacity(0.95),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: DropdownButtonFormField<String>(
                                value: _selectedPriority,
                                decoration: InputDecoration(
                                  labelText: 'Tingkat Prioritas',
                                  labelStyle: TextStyle(
                                    color: _selectedPriority != null
                                        ? _getPriorityColor(_selectedPriority!)
                                        : Colors.orange,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon: Icon(
                                    _selectedPriority != null
                                        ? _getPriorityIcon(_selectedPriority!)
                                        : Icons.priority_high,
                                    color: _selectedPriority != null
                                        ? _getPriorityColor(_selectedPriority!)
                                        : Colors.orange,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: _selectedPriority != null
                                          ? _getPriorityColor(
                                              _selectedPriority!)
                                          : Colors.orange,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                                hint: const Text(
                                  'Pilih Tingkat Prioritas',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey[600],
                                ),
                                isExpanded: true,
                                items: _priorityOptions.map((priority) {
                                  return DropdownMenuItem<String>(
                                    value: priority,
                                    child: Row(
                                      children: [
                                        Icon(
                                          _getPriorityIcon(priority),
                                          color: _getPriorityColor(priority),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            priority,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _getPriorityColor(priority)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            priority == 'High'
                                                ? 'Tinggi'
                                                : priority == 'Medium'
                                                    ? 'Sedang'
                                                    : 'Rendah',
                                            style: TextStyle(
                                              color:
                                                  _getPriorityColor(priority),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedPriority = newValue;
                                  });
                                },
                                dropdownColor: Colors.white,
                                elevation: 8,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Deskripsi Masalah
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white.withOpacity(0.95),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _descriptionController,
                                maxLines: 6,
                                decoration: InputDecoration(
                                  labelText: 'Deskripsi Masalah',
                                  alignLabelWithHint: true,
                                  labelStyle:
                                      const TextStyle(color: Colors.orange),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(bottom: 80),
                                    child: Icon(Icons.description,
                                        color: Colors.orange),
                                  ),
                                  hintText:
                                      'Jelaskan masalah yang Anda alami secara detail...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            // Submit Button
                            Center(
                              child: Container(
                                width: double.infinity,
                                height: 56,
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
                                  onPressed: _isLoading ? null : _submitReport,
                                  icon: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Color(0xFF1565C0),
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.send,
                                          color: Color(0xFF1565C0),
                                        ),
                                  label: Text(
                                    _isLoading
                                        ? 'Mengirim Laporan...'
                                        : 'Kirim Laporan',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1565C0),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF1565C0),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
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

  Widget _buildProfileInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.8),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[700], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : 'Belum diisi',
                  style: TextStyle(
                    fontSize: 14,
                    color: value.isNotEmpty ? Colors.black87 : Colors.grey[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
