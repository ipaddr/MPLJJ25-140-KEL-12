import 'package:flutter/material.dart';

class SimulasiGajiAdminPage extends StatefulWidget {
  const SimulasiGajiAdminPage({Key? key}) : super(key: key);

  @override
  _SimulasiGajiAdminPageState createState() => _SimulasiGajiAdminPageState();
}

class _SimulasiGajiAdminPageState extends State<SimulasiGajiAdminPage> {
  String? _selectedInstansi; // For the dropdown
  final TextEditingController _golonganController = TextEditingController();
  final TextEditingController _jabatanController = TextEditingController();
  final TextEditingController _rumusController = TextEditingController();

  // Example data for dropdowns, replace with actual data source
  final List<String> _instansiOptions = ['Instansi A', 'Instansi B', 'Instansi C'];

  @override
  void dispose() {
    _golonganController.dispose();
    _jabatanController.dispose();
    _rumusController.dispose();
    super.dispose();
  }

  void _saveSimulasi() {
    // TODO: Implement save simulasi logic here
    String? instansi = _selectedInstansi;
    String golongan = _golonganController.text;
    String jabatan = _jabatanController.text;
    String rumus = _rumusController.text;

    print('Save Simulasi attempt with:');
    print('  Instansi: $instansi');
    print('  Golongan: $golongan');
    print('  Jabatan: $jabatan');
    print('  Rumus: $rumus');

    // Add your logic to save the data (e.g., call an API)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulasi Gaji Admin'),
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
              const SizedBox(height: 20),
              // Instansi Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Instansi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: _selectedInstansi,
                hint: const Text('Pilih Instansi'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedInstansi = newValue;
                  });
                },
                items: _instansiOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Golongan TextField
              TextField(
                controller: _golonganController,
                decoration: InputDecoration(
                  labelText: 'Golongan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Jabatan TextField
              TextField(
                controller: _jabatanController,
                decoration: InputDecoration(
                  labelText: 'Jabatan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Rumus TextField
              TextField(
                controller: _rumusController,
                decoration: InputDecoration(
                  labelText: 'Rumus',
                  alignLabelWithHint: true, // Align hint text at the top
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                maxLines: 5, // Allow multiple lines for rumus
                keyboardType: TextInputType.multiline, // Use multiline keyboard
              ),
              const SizedBox(height: 40),
              // Simpan Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveSimulasi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo, // Dark blue color
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(fontSize: 18, color: Colors.white),
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