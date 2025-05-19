import 'package:flutter/material.dart';

class SimulasiGajiPage extends StatefulWidget {
  const SimulasiGajiPage({super.key});

  @override
  _SimulasiGajiPageState createState() => _SimulasiGajiPageState();
}

class _SimulasiGajiPageState extends State<SimulasiGajiPage> {
  String? selectedInstansi;
  String? selectedPangkat;

  final List<String> instansiOptions = ['Guru', 'Dosen', 'Dokter', 'TNI', 'POLRI', 'Lainnya'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulasi Gaji Baru'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Instansi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedInstansi,
                hint: const Text('Pilih Instansi'),
                items: instansiOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedInstansi = newValue;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pangkat',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedPangkat,
                hint: const Text('Pilih Pangkat'),
                items: pangkatOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedPangkat = newValue;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sebelum kenaikan',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Card(
                          elevation: 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Gaji pokok',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Tunjangan',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sesudah kenaikan',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Card(
                          elevation: 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Gaji pokok',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Tunjangan',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement hitung logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Hitung',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}