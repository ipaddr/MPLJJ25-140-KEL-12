import 'package:flutter/material.dart';

class AddInstansiPage extends StatefulWidget {
  const AddInstansiPage({Key? key}) : super(key: key);

  @override
  _AddInstansiPageState createState() => _AddInstansiPageState();
}

class _AddInstansiPageState extends State<AddInstansiPage> {
  final TextEditingController _namaInstansiController = TextEditingController();
  final TextEditingController _tingkatanController = TextEditingController();
  String? _selectedKategori;

  final List<String> _kategoriOptions = ['Pusat', 'Daerah'];

  @override
  void dispose() {
    _namaInstansiController.dispose();
    _tingkatanController.dispose();
    super.dispose();
  }

  void _saveInstansi() {
    String namaInstansi = _namaInstansiController.text;
    String tingkatan = _tingkatanController.text;
    String? kategori = _selectedKategori;

    print('Save Instansi attempt with:');
    print('  Nama Instansi: $namaInstansi');
    print('  Tingkatan: $tingkatan');
    print('  Kategori: $kategori');
    // Implementasi simpan data di sini
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Instansi',
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
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _namaInstansiController,
                decoration: InputDecoration(
                  labelText: 'Nama Instansi',
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent.shade400, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 22),
              TextField(
                controller: _tingkatanController,
                decoration: InputDecoration(
                  labelText: 'Tingkatan',
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent.shade400, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 22),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent.shade400, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                value: _selectedKategori,
                hint: const Text('Pilih Kategori'),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedKategori = newValue;
                  });
                },
                items: _kategoriOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(fontSize: 16)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: _saveInstansi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: Colors.amber.shade300,
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
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
