import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gaji_naik/dashboard/berita_regulasi_page.dart';
import 'package:gaji_naik/user/chatbot_page.dart';
import 'package:gaji_naik/dashboard/edukasi_page.dart';
import 'package:gaji_naik/dashboard/laporan_masalah_page.dart';
import 'package:gaji_naik/user/user_login_page.dart';
import 'package:gaji_naik/dashboard/simulasi_gaji_page.dart';
import 'package:gaji_naik/user/user_profile_page.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;
  bool isLoading = true;
  User? currentUser;

  // Variables to store counts from Firebase
  int newsCount = 0;
  int educationCount = 0;

  // Report status counts
  int totalReports = 0;
  int pendingReports = 0;
  int inProgressReports = 0;
  int completedReports = 0;
  List<Map<String, dynamic>> userReports = [];

  bool isLoadingCounts = true;
  bool isLoadingReports = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkAuthState();
    _loadContentCounts();
    _loadUserReports();
  }

  void _checkAuthState() {
    currentUser = _auth.currentUser;
    if (currentUser == null) {
      // If user is not logged in, redirect to login page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserLoginPage()),
        );
      });
    }
  }

  Future<void> _loadUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Listen to real-time updates from Firestore
        _firestore.collection('users').doc(user.uid).snapshots().listen(
          (DocumentSnapshot doc) {
            if (doc.exists && mounted) {
              setState(() {
                userData = doc.data() as Map<String, dynamic>;
                isLoading = false;
              });

              print('User data loaded:');
              print('Nama: ${userData?['namaLengkap']}');
              print('NIK: ${userData?['nip']}');
              print('Email: ${userData?['email']}');
              print('Telepon: ${userData?['noTelepon']}');
            }
          },
          onError: (error) {
            print('Error loading user data: $error');
            setState(() {
              isLoading = false;
            });
            _showErrorMessage('Gagal memuat data pengguna');
          },
        );
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error in _loadUserData: $e');
      setState(() {
        isLoading = false;
      });
      _showErrorMessage('Terjadi kesalahan saat memuat data');
    }
  }

  // Load content counts from Firebase
  Future<void> _loadContentCounts() async {
    try {
      setState(() {
        isLoadingCounts = true;
      });

      // Load news/regulations count from 'berita' collection (same as manage_new_page.dart)
      QuerySnapshot newsSnapshot = await _firestore
          .collection(
              'berita') // Changed to match manage_new_page.dart collection
          .where('status', isEqualTo: 'Aktif') // Only count active news
          .get();

      // Load education materials count
      QuerySnapshot educationSnapshot = await _firestore
          .collection('education_materials')
          .where('status', isEqualTo: 'Aktif') // Only count active materials
          .get();

      setState(() {
        newsCount = newsSnapshot.docs.length;
        educationCount = educationSnapshot.docs.length;
        isLoadingCounts = false;
      });

      print('Content counts loaded:');
      print('News/Regulations: $newsCount');
      print('Education Materials: $educationCount');
    } catch (e) {
      print('Error loading content counts: $e');
      setState(() {
        // Set default values if error occurs
        newsCount = 0;
        educationCount = 0;
        isLoadingCounts = false;
      });

      // Show error message but don't block the UI
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gagal memuat statistik konten'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  // Load user reports from Firebase
  Future<void> _loadUserReports() async {
    try {
      setState(() {
        isLoadingReports = true;
      });

      User? user = _auth.currentUser;
      if (user != null) {
        // Listen to real-time updates for user's reports
        _firestore
            .collection('reports')
            .where('user_id', isEqualTo: user.uid)
            .orderBy('created_at', descending: true)
            .snapshots()
            .listen(
          (QuerySnapshot snapshot) {
            if (mounted) {
              List<Map<String, dynamic>> reports = [];
              int pending = 0, inProgress = 0, completed = 0;

              for (var doc in snapshot.docs) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

                // Format date
                String formattedDate = '';
                if (data['created_at'] != null) {
                  Timestamp timestamp = data['created_at'] as Timestamp;
                  DateTime dateTime = timestamp.toDate();
                  formattedDate =
                      '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';
                }

                // Add report data
                Map<String, dynamic> reportData = {
                  'id': doc.id,
                  'title': data['title'] ?? 'Tanpa Judul',
                  'description': data['description'] ?? 'Tidak ada deskripsi',
                  'category': data['category'] ?? 'Umum',
                  'priority': data['priority'] ?? 'Medium',
                  'status': data['status'] ?? 'Pending',
                  'date': formattedDate,
                  'created_at': data['created_at'],
                };

                reports.add(reportData);

                // Count by status
                String status = data['status'] ?? 'Pending';
                switch (status) {
                  case 'Pending':
                    pending++;
                    break;
                  case 'Proses':
                    inProgress++;
                    break;
                  case 'Selesai':
                    completed++;
                    break;
                }
              }

              setState(() {
                userReports = reports;
                totalReports = reports.length;
                pendingReports = pending;
                inProgressReports = inProgress;
                completedReports = completed;
                isLoadingReports = false;
              });

              print('User reports loaded:');
              print('Total: $totalReports');
              print('Pending: $pendingReports');
              print('In Progress: $inProgressReports');
              print('Completed: $completedReports');
            }
          },
          onError: (error) {
            print('Error loading user reports: $error');
            setState(() {
              isLoadingReports = false;
            });
          },
        );
      } else {
        setState(() {
          isLoadingReports = false;
        });
      }
    } catch (e) {
      print('Error in _loadUserReports: $e');
      setState(() {
        isLoadingReports = false;
      });
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // Show reports detail dialog
  void _showReportsDetailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.assignment, color: Colors.blue[700]),
              const SizedBox(width: 8),
              const Text(
                'Laporan Saya',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: isLoadingReports
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : userReports.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Belum ada laporan',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: userReports.length,
                        itemBuilder: (context, index) {
                          final report = userReports[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _getStatusColor(report['status'])
                                    .withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        report['title'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(report['status'])
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        report['status'],
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _getStatusColor(report['status']),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  report['description'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.category,
                                        size: 12, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text(
                                      report['category'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(Icons.calendar_today,
                                        size: 12, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text(
                                      report['date'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LaporanMasalahPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Buat Laporan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green;
      case 'Proses':
        return Colors.blue;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text('Konfirmasi Logout'),
          ],
        ),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                // Update last logout timestamp
                if (currentUser != null) {
                  await _firestore
                      .collection('users')
                      .doc(currentUser!.uid)
                      .update({
                    'lastLogout': FieldValue.serverTimestamp(),
                    'updatedAt': FieldValue.serverTimestamp(),
                  });
                }

                // Sign out from Firebase
                await _auth.signOut();

                // Navigate to login page and remove all previous routes
                Navigator.pop(context); // Close dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserLoginPage(),
                  ),
                  (route) => false,
                );

                _showSuccessMessage('Logout berhasil');
              } catch (e) {
                print('Error during logout: $e');
                Navigator.pop(context);
                _showErrorMessage('Gagal logout. Silakan coba lagi.');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat pagi';
    } else if (hour < 15) {
      return 'Selamat siang';
    } else if (hour < 18) {
      return 'Selamat sore';
    } else {
      return 'Selamat malam';
    }
  }

  String _getUserDisplayName() {
    if (userData != null && userData!['namaLengkap'] != null) {
      return userData!['namaLengkap'];
    }
    if (currentUser?.displayName != null &&
        currentUser!.displayName!.isNotEmpty) {
      return currentUser!.displayName!;
    }
    if (currentUser?.email != null) {
      return currentUser!.email!.split('@')[0];
    }
    return 'Pengguna';
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while fetching data
    if (isLoading) {
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
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
                SizedBox(height: 16),
                Text(
                  'Memuat data pengguna...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
              // AppBar
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.dashboard,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Chat icon
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.1),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.chat_bubble_outline,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ChatbotPage(),
                                ),
                              );
                            },
                            tooltip: 'Chat Bot',
                          ),
                        ),
                        // Profile icon
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.1),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.person_outline,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserProfilePage(),
                                ),
                              );
                            },
                            tooltip: 'Profil Pengguna',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome section with Firebase data
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
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      const Color(0xFF1565C0).withOpacity(0.1),
                                  child: currentUser?.photoURL != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Image.network(
                                            currentUser!.photoURL!,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.person,
                                                color: Color(0xFF1565C0),
                                                size: 30,
                                              );
                                            },
                                          ),
                                        )
                                      : const Icon(
                                          Icons.person,
                                          color: Color(0xFF1565C0),
                                          size: 30,
                                        ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getGreeting(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _getUserDisplayName(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1565C0),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (userData != null &&
                                          userData!['nip'] != null) ...[
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1565C0)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'NIK: ${userData!['nip']}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF1565C0),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                // Email verification status
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (currentUser?.emailVerified ?? false)
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        (currentUser?.emailVerified ?? false)
                                            ? Icons.verified
                                            : Icons.warning,
                                        size: 16,
                                        color: (currentUser?.emailVerified ??
                                                false)
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        (currentUser?.emailVerified ?? false)
                                            ? 'Terverifikasi'
                                            : 'Belum Verifikasi',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: (currentUser?.emailVerified ??
                                                  false)
                                              ? Colors.green
                                              : Colors.orange,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // User info details
                            if (userData != null) ...[
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoItem(
                                      icon: Icons.email_outlined,
                                      label: 'Email',
                                      value: userData!['email'] ?? '-',
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildInfoItem(
                                      icon: Icons.phone_outlined,
                                      label: 'Telepon',
                                      value: userData!['noTelepon'] ?? '-',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Stats section with real Firebase data
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'Berita & Regulasi',
                              value: isLoadingCounts
                                  ? '...'
                                  : newsCount.toString(),
                              icon: Icons.description,
                              color: Colors.orange,
                              isLoading: isLoadingCounts,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Materi Edukasi',
                              value: isLoadingCounts
                                  ? '...'
                                  : educationCount.toString(),
                              icon: Icons.school,
                              color: Colors.purple,
                              isLoading: isLoadingCounts,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Report Status Section
                      Container(
                        padding: const EdgeInsets.all(20),
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
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.assignment,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Status Laporan Saya',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1565C0),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _showReportsDetailDialog,
                                  child: const Text('Lihat Detail'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (isLoadingReports)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            else
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildReportStatusCard(
                                      title: 'Total',
                                      value: totalReports.toString(),
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildReportStatusCard(
                                      title: 'Pending',
                                      value: pendingReports.toString(),
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildReportStatusCard(
                                      title: 'Proses',
                                      value: inProgressReports.toString(),
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildReportStatusCard(
                                      title: 'Selesai',
                                      value: completedReports.toString(),
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Features section
                      const Text(
                        'Fitur Utama',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Feature cards grid
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.2,
                        children: [
                          _buildFeatureCard(
                            icon: Icons.calculate,
                            title: 'Simulasi Gaji',
                            color: Colors.blue,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SimulasiGajiPage(),
                                ),
                              );
                            },
                          ),
                          _buildFeatureCard(
                            icon: Icons.article,
                            title: 'Berita & Regulasi',
                            color: Colors.orange,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BeritaRegulasiPage(),
                                ),
                              );
                            },
                          ),
                          _buildFeatureCard(
                            icon: Icons.school,
                            title: 'Edukasi',
                            color: Colors.purple,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EdukasiPage(),
                                ),
                              );
                            },
                          ),
                          _buildFeatureCard(
                            icon: Icons.report_problem_outlined,
                            title: 'Laporkan Masalah',
                            color: Colors.amber.shade800,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LaporanMasalahPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Account actions section
                      Container(
                        padding: const EdgeInsets.all(20),
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
                              'Akun',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1565C0),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Refresh data button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  _loadUserData();
                                  _loadContentCounts(); // Also refresh content counts
                                  _loadUserReports(); // Also refresh reports
                                },
                                icon: const Icon(Icons.refresh,
                                    color: Color(0xFF1565C0)),
                                label: const Text(
                                  'Refresh Data',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1565C0),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Color(0xFF1565C0)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Logout button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _logout,
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
                                  backgroundColor: Colors.red.shade600,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: const Color(0xFF1565C0),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isLoading = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          isLoading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                )
              : Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0),
                  ),
                ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportStatusCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1565C0),
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
