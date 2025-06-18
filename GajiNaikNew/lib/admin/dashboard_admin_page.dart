import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gaji_naik/admin/manage_education_page.dart';
import 'package:gaji_naik/admin/manage_report_page.dart';
import 'add_instansi_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Statistics data for cards
  int _totalReports = 0;
  int _totalEducationMaterials = 0;
  int _totalInstansi = 0;
  int _pendingReports = 0;
  int _activeEducationMaterials = 0;
  double _averageViews = 0.0;

  bool _isLoadingCards = true;

  @override
  void initState() {
    super.initState();
    _loadCardData();
  }

  // Load data untuk cards saja
  void _loadCardData() async {
    try {
      setState(() {
        _isLoadingCards = true;
      });

      // Load data secara parallel untuk performa lebih baik
      await Future.wait([
        _loadReportsData(),
        _loadEducationData(),
        _loadInstansiData(),
      ]);

      setState(() {
        _isLoadingCards = false;
      });

      print('Dashboard cards data loaded successfully');
    } catch (e) {
      setState(() {
        _isLoadingCards = false;
      });

      print('Error loading cards data: $e');
    }
  }

  // Load Reports statistics untuk card
  Future<void> _loadReportsData() async {
    try {
      QuerySnapshot reportsSnapshot =
          await _firestore.collection('reports').get();

      int total = reportsSnapshot.docs.length;
      int pending = 0;

      for (var doc in reportsSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String status = data['status'] ?? 'Pending';

        if (status == 'Pending') {
          pending++;
        }
      }

      setState(() {
        _totalReports = total;
        _pendingReports = pending;
      });
    } catch (e) {
      print('Error loading reports data: $e');
    }
  }

  // Load Education Materials statistics untuk card
  Future<void> _loadEducationData() async {
    try {
      QuerySnapshot educationSnapshot =
          await _firestore.collection('education_materials').get();

      int total = educationSnapshot.docs.length;
      int active = 0;
      int totalViews = 0;

      for (var doc in educationSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String status = data['status'] ?? 'Draft';
        int views = data['views'] ?? 0;

        if (status == 'Aktif') {
          active++;
        }
        totalViews += views;
      }

      double averageViews = total > 0 ? totalViews / total : 0.0;

      setState(() {
        _totalEducationMaterials = total;
        _activeEducationMaterials = active;
        _averageViews = averageViews;
      });
    } catch (e) {
      print('Error loading education data: $e');
    }
  }

  // Load Instansi statistics untuk card
  Future<void> _loadInstansiData() async {
    try {
      QuerySnapshot instansiSnapshot =
          await _firestore.collection('instansi').get();

      int activeInstansi = 0;
      for (var doc in instansiSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String status = data['status'] ?? 'aktif';

        if (status == 'aktif') {
          activeInstansi++;
        }
      }

      setState(() {
        _totalInstansi = activeInstansi;
      });
    } catch (e) {
      print('Error loading instansi data: $e');
    }
  }

  // Calculate completion percentage
  double get _completionPercentage {
    if (_totalReports == 0) return 0.0;
    return ((_totalReports - _pendingReports) / _totalReports) * 100;
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
                            'Dashboard Admin',
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
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: _loadCardData, // Refresh hanya data cards
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Welcome Card
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
                                color: const Color(0xFF1565C0).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.dashboard,
                                size: 40,
                                color: Color(0xFF1565C0),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selamat datang Admin',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Kelola sistem dan pantau aktivitas pengguna',
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

                      // Statistics Section dengan data Firebase
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Statistik Real-Time',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          if (_isLoadingCards)
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

                      const SizedBox(height: 16),

                      // Statistics Cards dengan data Firebase
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 1.2,
                        children: <Widget>[
                          _buildSummaryCard(
                            _isLoadingCards ? '...' : '$_totalReports',
                            'Total Laporan',
                            Icons.report_problem,
                            Colors.blue,
                            subtitle: _isLoadingCards
                                ? 'Loading...'
                                : 'Semua laporan masuk',
                          ),
                          _buildSummaryCard(
                            _isLoadingCards ? '...' : '$_pendingReports',
                            'Laporan Pending',
                            Icons.pending_actions,
                            Colors.orange,
                            subtitle: _isLoadingCards
                                ? 'Loading...'
                                : 'Perlu ditindaklanjuti',
                          ),
                          _buildSummaryCard(
                            _isLoadingCards
                                ? '...'
                                : '${_completionPercentage.toStringAsFixed(1)}%',
                            'Laporan Selesai',
                            Icons.check_circle,
                            Colors.green,
                            subtitle: _isLoadingCards
                                ? 'Loading...'
                                : 'Tingkat penyelesaian',
                          ),
                          _buildSummaryCard(
                            _isLoadingCards
                                ? '...'
                                : '$_activeEducationMaterials',
                            'Materi Aktif',
                            Icons.school,
                            Colors.purple,
                            subtitle: _isLoadingCards
                                ? 'Loading...'
                                : 'dari $_totalEducationMaterials total',
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Additional Statistics Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildSmallSummaryCard(
                              _isLoadingCards ? '...' : '$_totalInstansi',
                              'Instansi Aktif',
                              Icons.business,
                              Colors.teal,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSmallSummaryCard(
                              _isLoadingCards
                                  ? '...'
                                  : '${_averageViews.toStringAsFixed(0)}',
                              'Avg Views',
                              Icons.visibility,
                              Colors.indigo,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Menu Section (tetap seperti sebelumnya)
                      const Text(
                        'Menu Pengelolaan',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Menu Items
                      Column(
                        children: [
                          _buildMenuItem(
                            'Tambah Instansi',
                            'Kelola data instansi dan jabatan',
                            Icons.business,
                            Colors.blue,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddInstansiPage()),
                              ).then((_) =>
                                  _loadCardData()); // Refresh cards setelah kembali
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildMenuItem(
                            'Laporan Masalah',
                            'Pantau dan kelola laporan pengguna',
                            Icons.support_agent,
                            Colors.orange,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ManageReportsPage()),
                              ).then((_) => _loadCardData());
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildMenuItem(
                            'Kelola Edukasi',
                            'Manage konten edukasi dan pembelajaran',
                            Icons.school,
                            Colors.purple,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ManageEducationPage()),
                              ).then((_) => _loadCardData());
                            },
                          ),
                        ],
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

  Widget _buildSummaryCard(
      String value, String label, IconData icon, Color color,
      {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
                height: 1.1,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSmallSummaryCard(
      String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, String description, IconData icon,
      Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
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
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: color,
                    size: 16,
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
