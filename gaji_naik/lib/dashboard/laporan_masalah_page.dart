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
        title: const Text(
          'Laporan Masalah',
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
        elevation: 2,
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 80,
                  color: Colors.amber.shade700,
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Laporan Masalah',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Kategori Masalah',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedKategoriMasalah,
                hint: const Text('Pilih Kategori Masalah'),
                items: kategoriMasalahOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(
                          fontSize: 16,
                        )),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedKategoriMasalah = newValue;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Deskripsi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Tuliskan deskripsi masalah Anda...',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                'Unggah Bukti (Opsional)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles();

                      if (result != null) {
                        setState(() {
                          selectedFile = result.files.first;
                        });
                        print('Selected file: ${selectedFile!.name}');
                      }
                    },
                    icon: const Icon(Icons.attach_file, color: Colors.black),
                    label: const Text(
                      'Pilih File',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: selectedFile != null
                        ? Text(
                            'File terpilih: ${selectedFile!.name}',
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          )
                        : const Text(
                            'Belum ada file dipilih',
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to success page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LaporanMasalahKonfirmasiPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 5,
                    shadowColor: Colors.blue.shade300,
                  ),
                  child: const Text(
                    'Kirim',
                    style: TextStyle(fontSize: 20, color: Colors.white),
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
