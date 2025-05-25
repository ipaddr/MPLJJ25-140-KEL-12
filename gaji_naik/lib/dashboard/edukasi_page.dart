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
              Navigator.pushNamed(context, '/home');
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
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
                    _buildFilterButton('Tentang gaji dan Tunjangan'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Regulasi ASN'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Tips karier ASN'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Pengelolaan keuangan'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari materi edukasi',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildFilteredContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String title) {
    final bool isSelected = _selectedFilter == title;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedFilter = title;
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? Colors.deepPurple.shade300 : Colors.transparent,
        side: BorderSide(
          color: isSelected ? Colors.deepPurple.shade300 : Colors.grey.shade400,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontSize: 14,
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
        return const SizedBox.shrink();
    }
  }

  Widget _buildGajiAndTunjanganContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Card(
          color: Colors.yellow[100],
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.info_outline, color: Colors.orange, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Materi baru : Panduan Gaji ASN 2025 telah tersedia!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Undang-Undang Nomor 5 Tahun 2014',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Tips dan Trik Lulus CPNS',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Perencanaan Keuangan Jangka Panjang untuk Pensiun',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
}
