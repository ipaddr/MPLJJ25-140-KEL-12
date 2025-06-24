import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SimulasiGajiPage extends StatefulWidget {
  const SimulasiGajiPage({super.key});

  @override
  _SimulasiGajiPageState createState() => _SimulasiGajiPageState();
}

class _SimulasiGajiPageState extends State<SimulasiGajiPage> {
  String? selectedInstansi;
  String? selectedInstansiId;
  String? selectedPangkat;
  String? selectedGolongan;
  String? selectedTingkatan;
  bool _isCalculating = false;
  bool _showResult = false;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Dynamic list from Firestore (only instansi)
  List<Map<String, dynamic>> instansiOptions = [];

  // Static dropdown options
  final List<String> pangkatOptions = [
    'Juru Muda',
    'Juru Muda Tingkat I',
    'Juru',
    'Juru Tingkat I',
    'Pengatur Muda',
    'Pengatur Muda Tingkat I',
    'Pengatur',
    'Pengatur Tingkat I',
    'Penata Muda',
    'Penata Muda Tingkat I',
    'Penata',
    'Penata Tingkat I',
    'Pembina',
    'Pembina Tingkat I',
    'Pembina Utama Muda',
    'Pembina Utama Madya',
    'Pembina Utama',
  ];

  final List<String> golonganOptions = [
    'I/a',
    'I/b',
    'I/c',
    'I/d',
    'II/a',
    'II/b',
    'II/c',
    'II/d',
    'III/a',
    'III/b',
    'III/c',
    'III/d',
    'IV/a',
    'IV/b',
    'IV/c',
    'IV/d',
    'IV/e',
  ];

  final List<String> tingkatanOptions = [
    'Eselon I',
    'Eselon II',
    'Eselon III',
    'Eselon IV',
    'Eselon V',
    'Non Eselon',
  ];

  // Calculation results
  Map<String, dynamic>? calculationResult;
  double? activePercentage;

  final TextEditingController sebelumGajiPokokController =
      TextEditingController();
  final TextEditingController sebelumTunjanganController =
      TextEditingController();
  final TextEditingController sesudahGajiPokokController =
      TextEditingController();
  final TextEditingController sesudahTunjanganController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInstansiData();
    _loadActiveKenaikanRule();
  }

  @override
  void dispose() {
    sebelumGajiPokokController.dispose();
    sebelumTunjanganController.dispose();
    sesudahGajiPokokController.dispose();
    sesudahTunjanganController.dispose();
    super.dispose();
  }

  // Load instansi data from Firestore - Only instansi
  Future<void> _loadInstansiData() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('instansi')
          .where('status', isEqualTo: 'aktif')
          .get();

      List<Map<String, dynamic>> instansiList = snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();

      // Sort manually after fetching
      instansiList.sort((a, b) => a['nama_instansi']
          .toString()
          .compareTo(b['nama_instansi'].toString()));

      setState(() {
        instansiOptions = instansiList;
      });

      print('Loaded ${instansiList.length} instansi:');
      for (var instansi in instansiList) {
        print('  - ${instansi['nama_instansi']} (ID: ${instansi['id']})');
      }
    } catch (e) {
      print('Error loading instansi: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat data instansi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Load active salary increase rule
  Future<void> _loadActiveKenaikanRule() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('aturan_kenaikan')
          .where('status', isEqualTo: 'aktif')
          .get();

      // Filter and sort manually
      List<DocumentSnapshot> activeDocs = snapshot.docs.where((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data['tanggal_berakhir'] == null;
      }).toList();

      if (activeDocs.isNotEmpty) {
        // Sort by tanggal_berlaku descending manually
        activeDocs.sort((a, b) {
          Map<String, dynamic> dataA = a.data() as Map<String, dynamic>;
          Map<String, dynamic> dataB = b.data() as Map<String, dynamic>;

          Timestamp timestampA = dataA['tanggal_berlaku'] ?? Timestamp.now();
          Timestamp timestampB = dataB['tanggal_berlaku'] ?? Timestamp.now();

          return timestampB.compareTo(timestampA);
        });

        Map<String, dynamic> data =
            activeDocs.first.data() as Map<String, dynamic>;
        setState(() {
          activePercentage = data['persentase_kenaikan']?.toDouble() ?? 8.0;
        });
        print('Active percentage loaded: $activePercentage%');
      } else {
        setState(() {
          activePercentage = 8.0; // Default fallback
        });
        print('No active rules found, using default 8%');
      }
    } catch (e) {
      print('Error loading kenaikan rule: $e');
      setState(() {
        activePercentage = 8.0; // Default fallback
      });
    }
  }

  // Calculate salary increase
  Map<String, dynamic> _calculateSalaryIncrease({
    required double gajiPokokLama,
    required double tunjanganLama,
    required double persentaseKenaikan,
  }) {
    double multiplier = 1 + (persentaseKenaikan / 100);

    double gajiPokokBaru = gajiPokokLama * multiplier;
    double tunjanganBaru = tunjanganLama * multiplier;
    double totalLama = gajiPokokLama + tunjanganLama;
    double totalBaru = gajiPokokBaru + tunjanganBaru;

    return {
      'gaji_sebelum': {
        'gaji_pokok': gajiPokokLama,
        'tunjangan': tunjanganLama,
        'total': totalLama,
      },
      'gaji_sesudah': {
        'gaji_pokok': gajiPokokBaru,
        'tunjangan': tunjanganBaru,
        'total': totalBaru,
      },
      'selisih': {
        'gaji_pokok': gajiPokokBaru - gajiPokokLama,
        'tunjangan': tunjanganBaru - tunjanganLama,
        'total': totalBaru - totalLama,
        'persentase': persentaseKenaikan,
      }
    };
  }

  void _calculateSalary() async {
    if (selectedInstansiId == null ||
        selectedPangkat == null ||
        selectedGolongan == null ||
        selectedTingkatan == null ||
        sebelumGajiPokokController.text.isEmpty ||
        sebelumTunjanganController.text.isEmpty ||
        activePercentage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua field'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isCalculating = true;
    });

    try {
      double gajiPokok =
          double.parse(sebelumGajiPokokController.text.replaceAll(',', ''));
      double tunjangan =
          double.parse(sebelumTunjanganController.text.replaceAll(',', ''));

      // Calculate using active percentage
      Map<String, dynamic> result = _calculateSalaryIncrease(
        gajiPokokLama: gajiPokok,
        tunjanganLama: tunjangan,
        persentaseKenaikan: activePercentage!,
      );

      // Update form fields with formatted numbers
      sesudahGajiPokokController.text =
          _formatNumber(result['gaji_sesudah']['gaji_pokok']);
      sesudahTunjanganController.text =
          _formatNumber(result['gaji_sesudah']['tunjangan']);

      // Save simulation result to Firestore
      await _saveSimulationResult(result);

      setState(() {
        calculationResult = result;
        _isCalculating = false;
        _showResult = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Simulasi berhasil dihitung!'),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isCalculating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error dalam perhitungan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Format number with thousand separators
  String _formatNumber(double number) {
    return number.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  // Save simulation result to Firestore
  Future<void> _saveSimulationResult(Map<String, dynamic> hasil) async {
    try {
      await _firestore.collection('simulasi_hasil').add({
        'instansi_id': selectedInstansiId,
        'instansi_nama': selectedInstansi,
        'pangkat': selectedPangkat,
        'golongan': selectedGolongan,
        'tingkatan': selectedTingkatan,
        ...hasil,
        'tanggal_simulasi': FieldValue.serverTimestamp(),
      });
      print('Simulation result saved successfully');
    } catch (e) {
      print('Error saving simulation: $e');
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
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white.withOpacity(0.1),
                            ),
                            child: const Icon(Icons.calculate,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Simulasi Gaji',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
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
                      // Info Card
                      Container(
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
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFF1565C0).withOpacity(0.1),
                              ),
                              child: const Icon(Icons.info,
                                  color: Color(0xFF1565C0), size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Simulasi Kenaikan Gaji',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1565C0),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Kenaikan saat ini: ${activePercentage?.toStringAsFixed(0) ?? "8"}% (Sesuai aturan terbaru)',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Instansi Dropdown
                      _buildDropdownField(
                        title: 'Instansi',
                        hint: 'Pilih Instansi',
                        value: selectedInstansiId,
                        items: instansiOptions.map((instansi) {
                          return DropdownMenuItem<String>(
                            value: instansi['id'],
                            child: Text(instansi['nama_instansi']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedInstansiId = value;
                            selectedInstansi = instansiOptions.firstWhere(
                                (element) =>
                                    element['id'] == value)['nama_instansi'];
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      // Pangkat Dropdown
                      _buildDropdownField(
                        title: 'Pangkat',
                        hint: 'Pilih Pangkat',
                        value: selectedPangkat,
                        items: pangkatOptions.map((pangkat) {
                          return DropdownMenuItem<String>(
                            value: pangkat,
                            child: Text(pangkat),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPangkat = value;
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      // Golongan Dropdown
                      _buildDropdownField(
                        title: 'Golongan',
                        hint: 'Pilih Golongan',
                        value: selectedGolongan,
                        items: golonganOptions.map((golongan) {
                          return DropdownMenuItem<String>(
                            value: golongan,
                            child: Text(golongan),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedGolongan = value;
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      // Tingkatan Dropdown
                      _buildDropdownField(
                        title: 'Tingkatan',
                        hint: 'Pilih Tingkatan',
                        value: selectedTingkatan,
                        items: tingkatanOptions.map((tingkatan) {
                          return DropdownMenuItem<String>(
                            value: tingkatan,
                            child: Text(tingkatan),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedTingkatan = value;
                          });
                        },
                      ),

                      const SizedBox(height: 32),

                      // Salary Comparison Cards
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildSalaryCard(
                              title: 'Gaji Sebelum',
                              icon: Icons.trending_down,
                              color: Colors.orange,
                              gajiPokokController: sebelumGajiPokokController,
                              tunjanganController: sebelumTunjanganController,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSalaryCard(
                              title: 'Gaji Sesudah',
                              icon: Icons.trending_up,
                              color: Colors.green,
                              gajiPokokController: sesudahGajiPokokController,
                              tunjanganController: sesudahTunjanganController,
                              isReadOnly: true,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Calculate Button
                      Center(
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4CAF50).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: _isCalculating ? null : _calculateSalary,
                            child: _isCalculating
                                ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Menghitung...',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.calculate,
                                          color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        'Hitung Simulasi',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),

                      // Result Card
                      if (_showResult && calculationResult != null) ...[
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.all(24),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.green.withOpacity(0.1),
                                    ),
                                    child: const Icon(Icons.analytics,
                                        color: Colors.green, size: 24),
                                  ),
                                  const SizedBox(width: 16),
                                  const Text(
                                    'Hasil Simulasi',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1565C0),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _buildResultRow(
                                'Kenaikan Gaji Pokok:',
                                'Rp ${_formatNumber(calculationResult!['selisih']['gaji_pokok'])}',
                                Colors.blue,
                              ),
                              _buildResultRow(
                                'Kenaikan Tunjangan:',
                                'Rp ${_formatNumber(calculationResult!['selisih']['tunjangan'])}',
                                Colors.orange,
                              ),
                              const Divider(height: 24),
                              _buildResultRow(
                                'Total Kenaikan:',
                                'Rp ${_formatNumber(calculationResult!['selisih']['total'])}',
                                Colors.green,
                                isTotal: true,
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.green.withOpacity(0.1),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.trending_up,
                                        color: Colors.green, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Persentase Kenaikan: ${calculationResult!['selisih']['persentase'].toStringAsFixed(1)}%',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

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

  Widget _buildDropdownField({
    required String title,
    required String hint,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white.withOpacity(0.95),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            hint: Text(hint),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            items: items,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSalaryCard({
    required String title,
    required IconData icon,
    required Color color,
    required TextEditingController gajiPokokController,
    required TextEditingController tunjanganController,
    bool isReadOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
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
            children: [
              TextField(
                controller: gajiPokokController,
                readOnly: isReadOnly,
                decoration: InputDecoration(
                  labelText: 'Gaji Pokok',
                  prefixIcon: Icon(Icons.payments, color: color),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor:
                      isReadOnly ? Colors.grey.shade100 : Colors.grey.shade50,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tunjanganController,
                readOnly: isReadOnly,
                decoration: InputDecoration(
                  labelText: 'Tunjangan',
                  prefixIcon: Icon(Icons.monetization_on, color: color),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor:
                      isReadOnly ? Colors.grey.shade100 : Colors.grey.shade50,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultRow(String label, String value, Color color,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
