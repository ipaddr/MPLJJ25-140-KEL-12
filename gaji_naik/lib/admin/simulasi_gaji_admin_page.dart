import 'package:flutter/material.dart';

class SimulasiGajiAdminPage extends StatefulWidget {
  const SimulasiGajiAdminPage({Key? key}) : super(key: key);

  @override
  _SimulasiGajiAdminPageState createState() => _SimulasiGajiAdminPageState();
}

class _SimulasiGajiAdminPageState extends State<SimulasiGajiAdminPage> {
  String? _selectedInstansi;
  final TextEditingController _golonganController = TextEditingController();
  final TextEditingController _jabatanController = TextEditingController();
  final TextEditingController _rumusController = TextEditingController();

  final List<String> _instansiOptions = ['Instansi A', 'Instansi B', 'Instansi C'];

  @override
  void dispose() {
    _golonganController.dispose();
    _jabatanController.dispose();
    _rumusController.dispose();
    super.dispose();
  }

  void _saveSimulasi() {
    String? instansi = _selectedInstansi;
    String golongan = _golonganController.text;
    String jabatan = _jabatanController.text;
    String rumus = _rumusController.text;

    print('Save Simulasi attempt with:');
    print('  Instansi: $instansi');
    print('  Golongan: $golongan');
    print('  Jabatan: $jabatan');
    print('  Rumus: $rumus');
    // Implementasi simpan data di sini
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Simulasi Gaji Admin',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () {
              // TODO: Navigate to home
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // TODO: Info action
            },
          ),
        ],
        elevation: 2,
        backgroundColor: Colors.indigo.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Instansi',
                  labelStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.indigo.shade400),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo.shade400, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                value: _selectedInstansi,
                hint: const Text('Pilih Instansi'),
                icon: Icon(Icons.arrow_drop_down, color: Colors.indigo.shade400),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedInstansi = newValue;
                  });
                },
                items: _instansiOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(fontSize: 16)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),
              TextField(
                controller: _golonganController,
                decoration: InputDecoration(
                  labelText: 'Golongan',
                  labelStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.indigo.shade400),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo.shade400, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 22),
              TextField(
                controller: _jabatanController,
                decoration: InputDecoration(
                  labelText: 'Jabatan',
                  labelStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.indigo.shade400),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo.shade400, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 22),
              TextField(
                controller: _rumusController,
                decoration: InputDecoration(
                  labelText: 'Rumus',
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.indigo.shade400),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo.shade400, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: _saveSimulasi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    shadowColor: Colors.indigo.shade300,
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
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
}
