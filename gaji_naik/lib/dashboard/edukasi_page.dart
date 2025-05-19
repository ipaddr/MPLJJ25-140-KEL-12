import 'package:flutter/material.dart';

class EdukasiPage extends StatefulWidget {
  const EdukasiPage({Key? key}) : super(key: key);

  @override
  _EdukasiPageState createState() => _EdukasiPageState();
}

class _EdukasiPageState extends State<EdukasiPage> {
  String? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edukasi ASN'),
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
              // Implement navigate to home
              Navigator.pushNamed(context, '/home');
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show information dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Info'),
                    content: const Text('Informasi mengenai edukasi ASN'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = 'Tentang gaji dan Tunjangan';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedFilter == 'Tentang gaji dan Tunjangan' ? Colors.deepPurple[300] : Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Tentang gaji dan Tunjangan'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = 'Regulasi ASN';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedFilter == 'Regulasi ASN' ? Colors.deepPurple[300] : Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Regulasi ASN'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = 'Tips karier ASN';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedFilter == 'Tips karier ASN' ? Colors.deepPurple[300] : Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Tips karier ASN'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = 'Pengelolaan keuangan';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedFilter == 'Pengelolaan keuangan' ? Colors.deepPurple[300] : Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Pengelolaan keuangan'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari materi edukasi',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              _buildFilteredContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilteredContent() {
    switch (_selectedFilter) {
      case 'Tentang gaji dan Tunjangan':
      case null:
        return _buildGajiAndTunjanganContent();
      case 'Regulasi ASN':
        return _buildRegulasiContent();
      case 'Tips karier ASN':
        return _buildTipsKarierContent();
      case 'Pengelolaan keuangan':
        return _buildKeuanganContent();
      default:
        return _buildDefaultContent();
    }
  }

  Widget _buildGajiAndTunjanganContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Card(
          color: Colors.yellow[100],
          elevation: 2.0,
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.info_outline, color: Colors.orange),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Materi baru : Panduan Gaji ASN 2025 telah tersedia!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegulasiContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Undang-Undang Nomor 5 Tahun 2014',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Regulasi ASN diatur dalam Undang-Undang Nomor 5 Tahun 2014 tentang ASN.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipsKarierContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Tips dan Trik Lulus CPNS',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Peningkatan Karier ASN Jadi Fokus Utama BKN',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeuanganContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Perencanaan Keuangan Jangka Panjang untuk Pensiun',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Pelajari strategi perencanaan keuangan untuk pensiun yang nyaman.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultContent() {
    return const SizedBox.shrink(); // Default empty content
  }
}
