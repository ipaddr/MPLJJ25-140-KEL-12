import 'package:flutter/material.dart';

class LaporanMasalahKonfirmasiPage extends StatefulWidget {
  const LaporanMasalahKonfirmasiPage({super.key});

  @override
  State<LaporanMasalahKonfirmasiPage> createState() =>
      _LaporanMasalahKonfirmasiPageState();
}

class _LaporanMasalahKonfirmasiPageState
    extends State<LaporanMasalahKonfirmasiPage> {
  // Status proses laporan (true = masih proses, false = selesai)
  bool isProcessing = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Masalah'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              // TODO: Navigate to home
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // TODO: Show info
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Tampilkan logo sesuai status proses
              isProcessing
                  ? Column(
                      children: [
                        Image.asset(
                          'assets/waiting_icon.png', // Logo menunggu/proses
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Laporan Anda Sedang Di Proses',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Image.asset(
                          'assets/completed_icon.png', // Logo selesai
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Laporan Anda Telah Selesai',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
              const SizedBox(height: 48),
              Card(
                color: Colors.grey[300],
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Text(
                    isProcessing
                        ? 'TERIMA KASIH TELAH MELAPORKAN MASALAH ANDA'
                        : 'Masalah Anda Telah Ditangani dengan Baik',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[700],
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 180,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to home
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 6,
                    shadowColor: Colors.amber.shade200,
                    backgroundColor: Colors.yellow[700],
                  ),
                  child: const Text(
                    'HOME',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(isProcessing ? 'Tandai Selesai' : 'Tandai Proses'),
        icon: Icon(isProcessing ? Icons.check_circle : Icons.pending),
        onPressed: () {
          setState(() {
            isProcessing = !isProcessing;
          });
        },
      ),
    );
  }
}
