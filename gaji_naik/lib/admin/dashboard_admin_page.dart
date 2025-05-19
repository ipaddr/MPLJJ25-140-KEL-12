import 'package:flutter/material.dart';
import 'package:gaji_naik/admin/manage_education_page.dart';
import 'package:gaji_naik/admin/manage_report_page.dart';
import 'package:gaji_naik/admin/simulasi_gaji_admin_page.dart';
import 'add_instansi_page.dart'; // Import AddInstansiPage

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Ringkasan
              Card(
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ringkasan',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        children: <Widget>[
                          _buildSummaryCard('78%', 'Realisasi kenaikan'),
                          _buildSummaryCard('124', 'Pengaduan'),
                          _buildSummaryCard('3,8M', 'Gaji Baru'),
                          _buildSummaryCard('18', 'Hari Kerja Efektif'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Menu Utama
              Card(
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Menu Utama',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildMenuItem('Tambah Instansi', Icons.arrow_forward_ios, () {
                        // Navigate to AddInstansiPage when tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddInstansiPage()),
                        );
                      }),
                      _buildMenuItem('Simulasi Gaji', Icons.arrow_forward_ios, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SimulasiGajiAdminPage()),
                          );
                        // TODO: Implement Simulasi Gaji navigation
                        
                      }),
                      _buildMenuItem('Laporan Masalah', Icons.arrow_forward_ios, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ManageReportsPage()),
                        );
                        // TODO: Implement Laporan Masalah navigation
                      }),
                      _buildMenuItem('Kelola Edukasi', Icons.arrow_forward_ios, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ManageEducationPage()),
                        );
                        // TODO: Implement Kelola Edukasi navigation
                      }),
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

  Widget _buildSummaryCard(String value, String label) {
    return Card(
      color: Colors.blue[50], // Light blue background for summary cards
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: Icon(icon, color: Colors.grey[600]),
      onTap: onTap, // Use onTap callback to handle navigation
    );
  }
}
