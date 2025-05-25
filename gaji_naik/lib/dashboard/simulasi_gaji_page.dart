import 'package:flutter/material.dart';

class SimulasiGajiPage extends StatefulWidget {
  const SimulasiGajiPage({super.key});

  @override
  _SimulasiGajiPageState createState() => _SimulasiGajiPageState();
}

class _SimulasiGajiPageState extends State<SimulasiGajiPage> {
  String? selectedInstansi;
  String? selectedPangkat;

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

  final TextEditingController sebelumGajiPokokController = TextEditingController();
  final TextEditingController sebelumTunjanganController = TextEditingController();
  final TextEditingController sesudahGajiPokokController = TextEditingController();
  final TextEditingController sesudahTunjanganController = TextEditingController();

  @override
  void dispose() {
    sebelumGajiPokokController.dispose();
    sebelumTunjanganController.dispose();
    sesudahGajiPokokController.dispose();
    sesudahTunjanganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(12));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulasi Gaji Baru'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Instansi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedInstansi,
                hint: const Text('Pilih Instansi'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: borderRadius),
                ),
                items: instansiOptions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedInstansi = val;
                  });
                },
              ),
              const SizedBox(height: 24),
              const Text('Pangkat',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedPangkat,
                hint: const Text('Pilih Pangkat'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: borderRadius),
                ),
                items: pangkatOptions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedPangkat = val;
                  });
                },
              ),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildSalaryCard(
                      title: 'Sebelum kenaikan',
                      gajiPokokController: sebelumGajiPokokController,
                      tunjanganController: sebelumTunjanganController,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildSalaryCard(
                      title: 'Sesudah kenaikan',
                      gajiPokokController: sesudahGajiPokokController,
                      tunjanganController: sesudahTunjanganController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement hitung logic
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 6,
                    shadowColor: Colors.amber.shade200,
                    backgroundColor: Colors.yellow[700],
                  ),
                  child: const Text(
                    'Hitung',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
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
    required TextEditingController gajiPokokController,
    required TextEditingController tunjanganController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: gajiPokokController,
                  decoration: InputDecoration(
                    labelText: 'Gaji pokok',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: tunjanganController,
                  decoration: InputDecoration(
                    labelText: 'Tunjangan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
