import 'package:flutter/material.dart';
import 'laporan_masalah_sukses_page.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class LaporanMasalahPage extends StatefulWidget {
  const LaporanMasalahPage({Key? key}) : super(key: key);

  @override
  _LaporanMasalahPageState createState() => _LaporanMasalahPageState();
}

class _LaporanMasalahPageState extends State<LaporanMasalahPage> {
  String? selectedKategoriMasalah;
  final TextEditingController _deskripsiController = TextEditingController();
  PlatformFile? selectedFile;
  bool _isSubmitting = false;

  final List<String> kategoriMasalahOptions = [
    'Belum menerima kenaikan',
    'Kenaikan tidak sesuai',
    'Masalah data gaji',
    'Lainnya',
  ];

  @override
  void dispose() {
    _deskripsiController.dispose();
    super.dispose();
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
                              Icons.report_problem_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Laporan Masalah',
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
                      // Header Card
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
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.report_problem,
                                size: 48,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Laporkan Masalah Anda',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Kami akan membantu menyelesaikan masalah gaji Anda dengan cepat dan tepat.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Kategori Masalah
                      const Text(
                        'Kategori Masalah',
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
                          value: selectedKategoriMasalah,
                          hint: const Text('Pilih Kategori Masalah'),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.category_outlined,
                                color: Colors.orange),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                          items: kategoriMasalahOptions
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedKategoriMasalah = val;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Deskripsi
                      const Text(
                        'Deskripsi Masalah',
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
                        child: TextField(
                          controller: _deskripsiController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText:
                                'Jelaskan masalah yang Anda alami secara detail...',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 60),
                              child: Icon(Icons.description_outlined,
                                  color: Colors.orange),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Upload File
                      const Text(
                        'Unggah Bukti (Opsional)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(20),
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
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF1565C0),
                                        Color(0xFF0D47A1)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles();
                                      if (result != null) {
                                        setState(() {
                                          selectedFile = result.files.first;
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.attach_file,
                                        color: Colors.white),
                                    label: const Text(
                                      'Pilih File',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (selectedFile != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.green.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.green, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'File terpilih: ${selectedFile!.name}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.red, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          selectedFile = null;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Submit Button
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
                            onPressed: _isSubmitting
                                ? null
                                : () async {
                                    setState(() {
                                      _isSubmitting = true;
                                    });

                                    // Simulate submission
                                    await Future.delayed(
                                        const Duration(seconds: 1));

                                    setState(() {
                                      _isSubmitting = false;
                                    });

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LaporanMasalahKonfirmasiPage(),
                                      ),
                                    );
                                  },
                            icon: _isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF1565C0),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.send,
                                    color: Color(0xFF1565C0),
                                  ),
                            label: Text(
                              _isSubmitting ? 'Mengirim...' : 'Kirim Laporan',
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
}
