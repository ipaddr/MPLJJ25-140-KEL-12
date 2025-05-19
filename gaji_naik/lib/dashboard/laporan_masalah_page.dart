import 'package:flutter/material.dart';
import 'laporan_masalah_sukses_page.dart'; // Import the success page
import 'package:file_picker/file_picker.dart';
import 'dart:io'; // Import for PlatformFile

class LaporanMasalahPage extends StatefulWidget {
  const LaporanMasalahPage({Key? key}) : super(key: key);

  @override
  _LaporanMasalahPageState createState() => _LaporanMasalahPageState();
}

class _LaporanMasalahPageState extends State<LaporanMasalahPage> {
  String? selectedKategoriMasalah;

  final List<String> kategoriMasalahOptions = [
    'Belum menerima kenaikan',
    'Kenaikan tidak sesuai',
    'Masalah data gaji',
    'Lainnya',
  ];
  PlatformFile? selectedFile; // Variable to store the selected file

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Masalah'),
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
              const Center(
                child: Icon(
                  Icons.warning,
                  size: 80,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Laporan Masalah',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Kategori Masalah',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedKategoriMasalah,
                hint: const Text('Pilih Kategori Masalah'),
                items: kategoriMasalahOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedKategoriMasalah = newValue;
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
                'Deskripsi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Tuliskan deskripsi masalah Anda...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Unggah Bukti (Opsional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();

                  if (result != null) {
                    setState(() {
                      selectedFile = result.files.first;
                    });
                    // You can now use selectedFile.path to access the file path
                    print('Selected file: ${selectedFile!.name}');
                  } else {
                    // User canceled the picker
                  }
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('Pilih File'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              if (selectedFile != null) // Display selected file name if available
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('File terpilih: ${selectedFile!.name}'),
                ),
              const SizedBox(height: 30),

             Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to success page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LaporanMasalahKonfirmasiPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Kirim',
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