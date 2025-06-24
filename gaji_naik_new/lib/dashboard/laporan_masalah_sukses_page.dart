import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LaporanMasalahKonfirmasiPage extends StatefulWidget {
  final String? reportId;
  final Map<String, dynamic>? reportData;

  const LaporanMasalahKonfirmasiPage({
    super.key,
    this.reportId,
    this.reportData,
  });

  @override
  State<LaporanMasalahKonfirmasiPage> createState() =>
      _LaporanMasalahKonfirmasiPageState();
}

class _LaporanMasalahKonfirmasiPageState
    extends State<LaporanMasalahKonfirmasiPage> with TickerProviderStateMixin {
  String currentStatus = 'Pending'; // Status default
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.reportData?['status'] ?? 'Pending';

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _animationController.forward();

    // Load status terbaru dari Firebase jika ada reportId
    if (widget.reportId != null) {
      _loadCurrentStatus();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentStatus() async {
    if (widget.reportId == null) return;

    try {
      DocumentSnapshot doc =
          await _firestore.collection('reports').doc(widget.reportId).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          currentStatus = data['status'] ?? 'Pending';
        });
      }
    } catch (e) {
      print('Error loading status: $e');
    }
  }

  bool get isProcessing =>
      currentStatus == 'Pending' || currentStatus == 'Proses';
  bool get isCompleted => currentStatus == 'Selesai';

  Color get statusColor {
    switch (currentStatus) {
      case 'Selesai':
        return Colors.green;
      case 'Proses':
        return Colors.blue;
      case 'Pending':
      default:
        return Colors.orange;
    }
  }

  IconData get statusIcon {
    switch (currentStatus) {
      case 'Selesai':
        return Icons.check_circle;
      case 'Proses':
        return Icons.pending_actions;
      case 'Pending':
      default:
        return Icons.schedule;
    }
  }

  String get statusTitle {
    switch (currentStatus) {
      case 'Selesai':
        return 'Laporan Telah Selesai';
      case 'Proses':
        return 'Laporan Sedang Diproses';
      case 'Pending':
      default:
        return 'Laporan Sedang Ditinjau';
    }
  }

  String get statusDescription {
    switch (currentStatus) {
      case 'Selesai':
        return 'Masalah Anda telah berhasil ditangani dengan baik';
      case 'Proses':
        return 'Tim kami sedang aktif menangani masalah yang Anda laporkan';
      case 'Pending':
      default:
        return 'Tim kami sedang meninjau masalah yang Anda laporkan';
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
                            child: Icon(
                              statusIcon,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Status Laporan',
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
                        onPressed: _loadCurrentStatus,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.home, color: Colors.white),
                        onPressed: () => Navigator.popUntil(
                            context, (route) => route.isFirst),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Status Icon and Title
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white.withOpacity(0.95),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: statusColor.withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    statusIcon,
                                    size: 64,
                                    color: statusColor,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  statusTitle,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                    height: 1.3,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  statusDescription,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Report Info Card
                        if (widget.reportData != null) ...[
                          Container(
                            width: double.infinity,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.info_outline,
                                        color: Colors.blue, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Detail Laporan',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                if (widget.reportData!['title']?.isNotEmpty ==
                                    true)
                                  Text(
                                    'Judul: ${widget.reportData!['title']}',
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                if (widget
                                        .reportData!['category']?.isNotEmpty ==
                                    true)
                                  Text(
                                    'Kategori: ${widget.reportData!['category']}',
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                if (widget.reportId != null)
                                  Text(
                                    'ID Laporan: ${widget.reportId}',
                                    style: const TextStyle(
                                        color: Colors.blue, fontSize: 12),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],

                        // Status Information Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: statusColor.withOpacity(0.1),
                            border: Border.all(
                              color: statusColor.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                isCompleted
                                    ? Icons.thumb_up
                                    : Icons.info_outline,
                                color: statusColor,
                                size: 32,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                isCompleted
                                    ? 'MASALAH ANDA TELAH DITANGANI DENGAN BAIK'
                                    : 'TERIMA KASIH TELAH MELAPORKAN MASALAH ANDA',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: statusColor.withOpacity(0.8),
                                  letterSpacing: 0.5,
                                  height: 1.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (!isCompleted) ...[
                                const SizedBox(height: 12),
                                Text(
                                  currentStatus == 'Proses'
                                      ? 'Kami sedang menangani masalah Anda'
                                      : 'Kami akan segera menindaklanjuti laporan Anda',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: statusColor.withOpacity(0.7),
                                    height: 1.3,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Home Button
                        Container(
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
                            onPressed: () => Navigator.popUntil(
                                context, (route) => route.isFirst),
                            icon: const Icon(
                              Icons.home,
                              color: Color(0xFF1565C0),
                              size: 24,
                            ),
                            label: const Text(
                              'Kembali ke Beranda',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1565C0),
                                letterSpacing: 0.5,
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
                      ],
                    ),
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
