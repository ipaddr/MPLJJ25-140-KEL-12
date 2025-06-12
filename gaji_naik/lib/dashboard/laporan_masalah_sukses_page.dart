import 'package:flutter/material.dart';

class LaporanMasalahKonfirmasiPage extends StatefulWidget {
  const LaporanMasalahKonfirmasiPage({super.key});

  @override
  State<LaporanMasalahKonfirmasiPage> createState() =>
      _LaporanMasalahKonfirmasiPageState();
}

class _LaporanMasalahKonfirmasiPageState
    extends State<LaporanMasalahKonfirmasiPage> with TickerProviderStateMixin {
  // Status proses laporan (true = masih proses, false = selesai)
  bool isProcessing = true;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
                              isProcessing
                                  ? Icons.pending_actions
                                  : Icons.check_circle,
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
                                    color: isProcessing
                                        ? Colors.orange.withOpacity(0.1)
                                        : Colors.green.withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    isProcessing
                                        ? Icons.schedule
                                        : Icons.check_circle,
                                    size: 64,
                                    color: isProcessing
                                        ? Colors.orange
                                        : Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  isProcessing
                                      ? 'Laporan Sedang Diproses'
                                      : 'Laporan Telah Selesai',
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
                                  isProcessing
                                      ? 'Tim kami sedang meninjau masalah yang Anda laporkan'
                                      : 'Masalah Anda telah berhasil ditangani dengan baik',
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

                        // Information Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: isProcessing
                                ? Colors.orange.withOpacity(0.1)
                                : Colors.green.withOpacity(0.1),
                            border: Border.all(
                              color: isProcessing
                                  ? Colors.orange.withOpacity(0.3)
                                  : Colors.green.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                isProcessing
                                    ? Icons.info_outline
                                    : Icons.thumb_up,
                                color:
                                    isProcessing ? Colors.orange : Colors.green,
                                size: 32,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                isProcessing
                                    ? 'TERIMA KASIH TELAH MELAPORKAN MASALAH ANDA'
                                    : 'MASALAH ANDA TELAH DITANGANI DENGAN BAIK',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isProcessing
                                      ? Colors.orange[800]
                                      : Colors.green[800],
                                  letterSpacing: 0.5,
                                  height: 1.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (isProcessing) ...[
                                const SizedBox(height: 12),
                                Text(
                                  'Kami akan segera menindaklanjuti laporan Anda',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.orange[700],
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

      // Modern Floating Action Button
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: isProcessing ? Colors.green : Colors.orange,
          foregroundColor: Colors.white,
          elevation: 0,
          icon: Icon(isProcessing ? Icons.check_circle : Icons.pending),
          label: Text(
            isProcessing ? 'Tandai Selesai' : 'Tandai Proses',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          onPressed: () {
            setState(() {
              isProcessing = !isProcessing;
              _animationController.reset();
              _animationController.forward();
            });
          },
        ),
      ),
    );
  }
}
