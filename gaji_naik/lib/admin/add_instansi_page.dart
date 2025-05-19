import 'package:flutter/material.dart';

class AddInstansiPage extends StatefulWidget {
  const AddInstansiPage({Key? key}) : super(key: key);

  @override
  _AddInstansiPageState createState() => _AddInstansiPageState();
}

class _AddInstansiPageState extends State<AddInstansiPage> {
  final TextEditingController _namaInstansiController = TextEditingController();
  final TextEditingController _tingkatanController = TextEditingController();
  String? _selectedKategori; // For the dropdown

  final List<String> _kategoriOptions = ['Pusat', 'Daerah']; // Example categories, you can change this

  @override
  void dispose() {
    _namaInstansiController.dispose();
    _tingkatanController.dispose();
    super.dispose();
  }

  void _saveInstansi() {
    // TODO: Implement save instansi logic here
    String namaInstansi = _namaInstansiController.text;
    String tingkatan = _tingkatanController.text;
    String? kategori = _selectedKategori;

    print('Save Instansi attempt with:');
    print('  Nama Instansi: $namaInstansi');
    print('  Tingkatan: $tingkatan');
    print('  Kategori: $kategori');

    // Add your logic to save the data (e.g., call an API)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Instansi'),
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
              TextField(
                controller: _namaInstansiController,
                decoration: InputDecoration(
                  labelText: 'Nama Instansi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _tingkatanController,
                decoration: InputDecoration(
                  labelText: 'Tingkatan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: _selectedKategori,
                hint: const Text('Pilih Kategori'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedKategori = newValue;
                  });
                },
                items: _kategoriOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
              Center( // Center the button
                child: ElevatedButton(
                  onPressed: _saveInstansi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, // Yellow color
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
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