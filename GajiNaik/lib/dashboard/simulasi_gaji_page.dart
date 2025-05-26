import 'package:flutter/material.dart';

class SimulasiGajiPage extends StatefulWidget {
  const SimulasiGajiPage({super.key});

  @override
  _SimulasiGajiPageState createState() => _SimulasiGajiPageState();
}

class _SimulasiGajiPageState extends State<SimulasiGajiPage> {
  String? selectedInstansi;
  String? selectedPangkat;
  bool _isCalculating = false;
  bool _showResult = false;

  final List<String> instansiOptions = [
    'Guru',
    'Dosen',
    'Dokter',
    'TNI',
    'POLRI',
    'Lainnya'
  ];

  final List<String> pangkatOptions = [
    'Penata muda (III/a)',
    'Penata muda tingkat I (III/b)',
    'Penata (III/c)',
    'Penata tingkat I (III/d)',
    'Pembina (IV/a)',
    'Pembina tingkat I (IV/b)',
    'Pembina utama muda (IV/c)',
    'Pembina utama madya (IV/d)',
    'Pembina utama (IV/e)',
  ];

  final TextEditingController sebelumGajiPokokController =
      TextEditingController();
  final TextEditingController sebelumTunjanganController =
      TextEditingController();
  final TextEditingController sesudahGajiPokokController =
      TextEditingController();
  final TextEditingController sesudahTunjanganController =
      TextEditingController();

  @override
  void dispose() {
    sebelumGajiPokokController.dispose();
    sebelumTunjanganController.dispose();
    sesudahGajiPokokController.dispose();
    sesudahTunjanganController.dispose();
    super.dispose();
  }

  void _calculateSalary() async {
    setState(() {
      _isCalculating = true;
    });

    // Simulate calculation
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isCalculating = false;
      _showResult = true;
    });
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
                            child: const Icon(
                              Icons.calculate_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Simulasi Gaji',
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
                                color: const Color(0xFF1565C0).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: Color(0xFF1565C0),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'Simulasi perhitungan gaji berdasarkan PP terbaru mengenai kenaikan gaji ASN',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Instansi Dropdown
                      const Text(
                        'Instansi',
                        style: TextStyle(
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
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedInstansi,
                          hint: const Text('Pilih Instansi'),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                          items: instansiOptions
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedInstansi = val;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Pangkat Dropdown
                      const Text(
                        'Pangkat',
                        style: TextStyle(
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
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedPangkat,
                          hint: const Text('Pilih Pangkat'),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                          items: pangkatOptions
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedPangkat = val;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Salary Comparison Cards
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildSalaryCard(
                              title: 'Sebelum Kenaikan',
                              icon: Icons.remove_circle_outline,
                              color: Colors.red,
                              gajiPokokController: sebelumGajiPokokController,
                              tunjanganController: sebelumTunjanganController,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSalaryCard(
                              title: 'Sesudah Kenaikan',
                              icon: Icons.add_circle_outline,
                              color: Colors.green,
                              gajiPokokController: sesudahGajiPokokController,
                              tunjanganController: sesudahTunjanganController,
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
                            onPressed: _isCalculating ? null : _calculateSalary,
                            icon: _isCalculating
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF1565C0),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.calculate,
                                    color: Color(0xFF1565C0),
                                  ),
                            label: Text(
                              _isCalculating
                                  ? 'Menghitung...'
                                  : 'Hitung Simulasi',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1565C0),
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
                      ),

                      // Result Card
                      if (_showResult) ...[
                        const SizedBox(height: 30),
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
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Icon(
                                      Icons.trending_up,
                                      color: Colors.green,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Text(
                                    'Hasil Simulasi',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Kenaikan Gaji:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'Rp 500.000',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Persentase:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    '8.5%',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
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

  Widget _buildSalaryCard({
    required String title,
    required IconData icon,
    required Color color,
    required TextEditingController gajiPokokController,
    required TextEditingController tunjanganController,
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
                decoration: InputDecoration(
                  labelText: 'Gaji Pokok',
                  prefixIcon: Icon(Icons.payments, color: color),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tunjanganController,
                decoration: InputDecoration(
                  labelText: 'Tunjangan',
                  prefixIcon: Icon(Icons.monetization_on, color: color),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
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
}
