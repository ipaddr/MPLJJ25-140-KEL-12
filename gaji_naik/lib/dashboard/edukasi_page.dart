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
                              Icons.school_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Edukasi ASN',
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Card
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
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.school,
                                size: 40,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pusat Edukasi ASN',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Tingkatkan pengetahuan dan keterampilan Anda sebagai ASN',
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

                      // Search Bar
                      Container(
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
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari materi edukasi...',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon: const Icon(Icons.search,
                                color: Color(0xFF1565C0)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            fillColor: Colors.transparent,
                            filled: true,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Filter Buttons
                      const Text(
                        'Kategori Pembelajaran',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 16),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterButton(
                                'Tentang gaji dan Tunjangan', Icons.payment),
                            const SizedBox(width: 12),
                            _buildFilterButton('Regulasi ASN', Icons.gavel),
                            const SizedBox(width: 12),
                            _buildFilterButton(
                                'Tips karier ASN', Icons.trending_up),
                            const SizedBox(width: 12),
                            _buildFilterButton('Pengelolaan keuangan',
                                Icons.account_balance_wallet),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Content
                      _buildFilteredContent(),
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

  Widget _buildFilterButton(String title, IconData icon) {
    final bool isSelected = _selectedFilter == title;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _selectedFilter = isSelected ? null : title;
          });
        },
        icon: Icon(
          icon,
          size: 18,
          color: isSelected ? Colors.white : const Color(0xFF1565C0),
        ),
        label: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1565C0),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF1565C0) : Colors.white,
          foregroundColor: isSelected ? Colors.white : const Color(0xFF1565C0),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        const Text(
          'Gaji dan Tunjangan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _buildEducationCard(
          title: 'Panduan Gaji ASN 2025',
          description: 'Pelajari sistem gaji terbaru untuk ASN tahun 2025',
          icon: Icons.payments,
          color: Colors.blue,
          isNew: true,
        ),
        const SizedBox(height: 16),
        _buildEducationCard(
          title: 'Tunjangan Kinerja',
          description: 'Memahami mekanisme pemberian tunjangan kinerja',
          icon: Icons.trending_up,
          color: Colors.green,
        ),
        const SizedBox(height: 16),
        _buildEducationCard(
          title: 'Struktur Gaji PNS',
          description: 'Komponen-komponen dalam struktur gaji PNS',
          icon: Icons.account_balance,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildRegulasiContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Regulasi ASN',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _buildEducationCard(
          title: 'UU No. 5 Tahun 2014',
          description: 'Undang-Undang tentang Aparatur Sipil Negara',
          icon: Icons.gavel,
          color: Colors.purple,
        ),
        const SizedBox(height: 16),
        _buildEducationCard(
          title: 'PP Sistem Remunerasi',
          description: 'Peraturan Pemerintah tentang Sistem Remunerasi ASN',
          icon: Icons.description,
          color: Colors.indigo,
        ),
      ],
    );
  }

  Widget _buildTipsKarierContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tips Karier ASN',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _buildEducationCard(
          title: 'Tips Lulus CPNS',
          description: 'Strategi sukses menghadapi seleksi CPNS',
          icon: Icons.school,
          color: Colors.teal,
        ),
        const SizedBox(height: 16),
        _buildEducationCard(
          title: 'Pengembangan Kompetensi',
          description:
              'Meningkatkan kompetensi untuk jenjang karier yang lebih baik',
          icon: Icons.emoji_events,
          color: Colors.amber,
        ),
      ],
    );
  }

  Widget _buildKeuanganContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pengelolaan Keuangan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _buildEducationCard(
          title: 'Perencanaan Pensiun',
          description:
              'Strategi perencanaan keuangan untuk pensiun yang nyaman',
          icon: Icons.savings,
          color: Colors.green,
        ),
        const SizedBox(height: 16),
        _buildEducationCard(
          title: 'Investasi untuk ASN',
          description:
              'Panduan investasi yang aman dan menguntungkan untuk ASN',
          icon: Icons.show_chart,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildEducationCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    bool isNew = false,
  }) {
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (isNew)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'BARU',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
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
    );
  }
}
