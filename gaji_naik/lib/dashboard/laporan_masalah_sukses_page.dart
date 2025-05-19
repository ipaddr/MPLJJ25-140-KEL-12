import 'package:flutter/material.dart';

class LaporanMasalahKonfirmasiPage extends StatelessWidget {
  const LaporanMasalahKonfirmasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Masalah'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              // TODO: Implement navigate to home
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // TODO: Implement info action
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Placeholder for clock icon - you might need a custom asset or a different approach for an animated clock
              Image.asset(
                'assets/clock_icon.png', // Replace with your clock icon asset path
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Laporan Anda Sedang Di Proses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Card(
                color: Colors.grey[300],
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'TERIMA KASIH TELAH MELAPORKAN MASALAH ANDA',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement navigate to home
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'HOME',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}