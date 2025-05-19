import 'package:flutter/material.dart';
import 'package:gaji_naik/dashboard/berita_regulasi_page.dart';
import 'package:gaji_naik/chatbot_page.dart';
import 'package:gaji_naik/dashboard/edukasi_page.dart';
import 'package:gaji_naik/dashboard/laporan_masalah_page.dart';
import 'package:gaji_naik/user/user_login_page.dart';
import 'package:gaji_naik/dashboard/simulasi_gaji_page.dart';



class UserDashboardPage extends StatelessWidget {
  const UserDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 31, 164), // Dark blue background
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 10, 31, 164), // Dark blue AppBar
        title: const Text('Selamat Datang, Ijad !', style: TextStyle(color: Colors.white)), // Adjusted text color
        iconTheme: const IconThemeData(color: Colors.white), // Adjusted icon color
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy), // Atau ikon lain yang Anda suka
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GajiBotPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const UserLoginPage()), // Added const
                    (route) => false,

              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20), // Added space for the "Selamat Datang" text if needed below AppBar
            // You might want to add a greeting text here based on the image, but
            // it seems the AppBar already has the greeting.

            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.yellow[100], // Light yellow background
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total ASN Aktif',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87), // Adjusted text color
                          ),
                          SizedBox(height: 4),
                          Text(
                            '1.300.000', // Replace with actual data
                            style: TextStyle(fontSize: 20, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    color: Colors.yellow[100], // Light yellow background
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Persentase Kenaikan', // Adjusted text for wrapping
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87), // Adjusted text color
                          ),
                          SizedBox(height: 4),
                          Text(
                            '8,5%', // Replace with actual data
                            style: TextStyle(fontSize: 20, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Chart Card
            Card(
              color: Colors.white, // Chart card seems white in the image
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Grafik Progres Kenaikan',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87), // Adjusted text color
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 200,
                      // Replace with your actual chart widget
                      color: Colors.grey[300], // Placeholder for a chart
                      child: const Center(
                        child: Text('Chart Placeholder', style: TextStyle(color: Colors.black87)), // Adjusted text color
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Navigasi Fitur',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), // Adjusted text color
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Added const
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildFeatureCard(
                  icon: Icons.calculate,
                  title: 'Simulasi Gaji Baru', // Updated title based on image
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SimulasiGajiPage())); // Added const
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.article,
                  title: 'Berita dan Regulasi', // Updated title based on image
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const BeritaRegulasiPage())); // Added const
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.report_problem,
                  title: 'Lapor Masalah', // Updated title based on image
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LaporanMasalahPage())); // Added const
                  },
                ),
                _buildFeatureCard(
                  icon: Icons.school,
                  title: 'Edukasi ASN', // Updated title based on image
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EdukasiPage())); // Added const
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      color: Colors.yellow[100], // Light yellow background
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue), // Icon color
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87), // Adjusted text color and size
            ),
          ],
        ),
      ),
    );
  }
}