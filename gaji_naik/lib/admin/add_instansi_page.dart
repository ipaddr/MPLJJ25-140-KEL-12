import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddInstansiPage extends StatefulWidget {
  const AddInstansiPage({Key? key}) : super(key: key);

  @override
  _AddInstansiPageState createState() => _AddInstansiPageState();
}

class _AddInstansiPageState extends State<AddInstansiPage> {
  final TextEditingController _namaInstansiController = TextEditingController();
  final TextEditingController _tingkatanController = TextEditingController();
  String? _selectedKategori;
  bool _isLoading = false;

  // Pangkat management
  final List<Map<String, String>> _pangkatList = [];
  final TextEditingController _namaPangkatController = TextEditingController();
  final TextEditingController _kodePangkatController = TextEditingController();

  final List<String> _kategoriOptions = ['Pusat', 'Daerah'];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _namaInstansiController.dispose();
    _tingkatanController.dispose();
    _namaPangkatController.dispose();
    _kodePangkatController.dispose();
    super.dispose();
  }

  void _addPangkat() {
    if (_namaPangkatController.text.isEmpty ||
        _kodePangkatController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi nama pangkat dan kode pangkat'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Parse kode pangkat untuk mendapatkan golongan dan ruang
    String kodePangkat = _kodePangkatController.text.trim().toUpperCase();
    String golongan = '';
    String ruang = '';

    // Format yang diharapkan: III/a, IV/b, I/c, dll
    if (kodePangkat.contains('/') && kodePangkat.length >= 3) {
      List<String> parts = kodePangkat.split('/');
      if (parts.length == 2) {
        golongan = parts[0].trim();
        ruang = parts[1].trim();
      }
    }

    setState(() {
      _pangkatList.add({
        'nama_pangkat': _namaPangkatController.text.trim(),
        'kode_pangkat': kodePangkat,
        'golongan': golongan,
        'ruang': ruang,
      });
    });

    // Clear form
    _namaPangkatController.clear();
    _kodePangkatController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Pangkat berhasil ditambahkan ke list'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _removePangkat(int index) {
    setState(() {
      _pangkatList.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pangkat dihapus dari list'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _saveInstansi() async {
    if (_namaInstansiController.text.isEmpty ||
        _tingkatanController.text.isEmpty ||
        _selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua field instansi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_pangkatList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimal tambahkan 1 pangkat untuk instansi ini'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String namaInstansi = _namaInstansiController.text.trim();
      String tingkatan = _tingkatanController.text.trim();
      String kategori = _selectedKategori!;

      // Check if instansi with same name already exists
      QuerySnapshot existingInstansi = await _firestore
          .collection('instansi')
          .where('nama_instansi', isEqualTo: namaInstansi)
          .limit(1)
          .get();

      if (existingInstansi.docs.isNotEmpty) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Instansi dengan nama tersebut sudah ada'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Create instansi document first
      Map<String, dynamic> instansiData = {
        'nama_instansi': namaInstansi,
        'tingkatan': tingkatan,
        'kategori': kategori,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
        'status': 'aktif',
      };

      // Save instansi to Firebase Firestore
      DocumentReference instansiRef =
          await _firestore.collection('instansi').add(instansiData);
      String instansiId = instansiRef.id;

      print('Instansi saved successfully with ID: $instansiId');

      // Save all pangkat for this instansi
      WriteBatch batch = _firestore.batch();

      for (int i = 0; i < _pangkatList.length; i++) {
        Map<String, String> pangkat = _pangkatList[i];

        Map<String, dynamic> pangkatData = {
          'instansi_id': instansiId,
          'nama_pangkat': pangkat['nama_pangkat'],
          'kode_pangkat': pangkat['kode_pangkat'],
          'golongan': pangkat['golongan'],
          'ruang': pangkat['ruang'],
          'urutan': i + 1, // untuk sorting
          'status': 'aktif',
          'created_at': FieldValue.serverTimestamp(),
        };

        DocumentReference pangkatRef = _firestore.collection('pangkat').doc();
        batch.set(pangkatRef, pangkatData);
      }

      // Execute batch write for all pangkat
      await batch.commit();

      print('All pangkat saved successfully');
      print('Instansi data:');
      print('  Nama Instansi: $namaInstansi');
      print('  Tingkatan: $tingkatan');
      print('  Kategori: $kategori');
      print('  Total Pangkat: ${_pangkatList.length}');

      setState(() {
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Instansi "$namaInstansi" dan ${_pangkatList.length} pangkat berhasil ditambahkan',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );

      // Clear form
      _namaInstansiController.clear();
      _tingkatanController.clear();
      setState(() {
        _selectedKategori = null;
        _pangkatList.clear();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      print('Error saving instansi and pangkat: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Gagal menambahkan instansi: ${e.toString()}'),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<bool> _checkInternetConnection() async {
    try {
      await _firestore.doc('test/connection').get();
      return true;
    } catch (e) {
      return false;
    }
  }

  void _showConnectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.red),
              SizedBox(width: 8),
              Text('Tidak Ada Koneksi'),
            ],
          ),
          content: const Text(
            'Pastikan perangkat terhubung ke internet untuk menyimpan data instansi.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
                              Icons.business,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Tambah Instansi',
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
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.add_business,
                                size: 40,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tambah Instansi Baru',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Lengkapi informasi instansi dan daftar pangkat yang akan ditambahkan',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Form Section - Instansi
                      const Text(
                        'Informasi Instansi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Nama Instansi Field
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
                          controller: _namaInstansiController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: 'Nama Instansi',
                            labelStyle: const TextStyle(color: Colors.blue),
                            prefixIcon:
                                const Icon(Icons.business, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            hintText: 'Contoh: Kementerian Pendidikan',
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Tingkatan Field
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
                          controller: _tingkatanController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: 'Tingkatan',
                            labelStyle: const TextStyle(color: Colors.blue),
                            prefixIcon:
                                const Icon(Icons.stairs, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            hintText: 'Contoh: Pendidik, ASN, TNI, Polri',
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Kategori Dropdown
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
                          value: _selectedKategori,
                          hint: const Text('Pilih Kategori Instansi'),
                          decoration: InputDecoration(
                            labelText: 'Kategori',
                            labelStyle: const TextStyle(color: Colors.blue),
                            prefixIcon:
                                const Icon(Icons.category, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                          items: _kategoriOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(
                                    value == 'Pusat'
                                        ? Icons.account_balance
                                        : Icons.location_city,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(value),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedKategori = newValue;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Pangkat Section
                      const Text(
                        'Daftar Pangkat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Add Pangkat Form
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.badge, color: Colors.green),
                                const SizedBox(width: 8),
                                const Text(
                                  'Tambah Pangkat',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Nama Pangkat Field
                            TextField(
                              controller: _namaPangkatController,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                labelText: 'Nama Pangkat',
                                hintText: 'Contoh: Penata Muda',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Kode Pangkat Field dengan tombol Add
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _kodePangkatController,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: InputDecoration(
                                      labelText: 'Kode Pangkat',
                                      hintText: 'Format: III/a, IV/b, I/c',
                                      helperText:
                                          'Contoh: III/a (Golongan III, Ruang a)',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 12),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: _addPangkat,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                  ),
                                  child: const Icon(Icons.add),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Info text
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.3),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.blue,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Format kode: Golongan/Ruang (contoh: III/a, IV/b)',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Pangkat List
                      if (_pangkatList.isNotEmpty) ...[
                        Container(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    const Icon(Icons.list, color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Daftar Pangkat (${_pangkatList.length})',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ...List.generate(_pangkatList.length, (index) {
                                Map<String, String> pangkat =
                                    _pangkatList[index];
                                return Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade50,
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              pangkat['nama_pangkat']!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              pangkat['kode_pangkat']!,
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            if (pangkat['golongan']!
                                                    .isNotEmpty &&
                                                pangkat['ruang']!
                                                    .isNotEmpty) ...[
                                              const SizedBox(height: 2),
                                              Text(
                                                'Golongan ${pangkat['golongan']}, Ruang ${pangkat['ruang']}',
                                                style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => _removePangkat(index),
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red, size: 20),
                                        style: IconButton.styleFrom(
                                          backgroundColor:
                                              Colors.red.withOpacity(0.1),
                                          padding: const EdgeInsets.all(8),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 40),

                      // Save Button
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
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    // Check internet connection first
                                    bool hasConnection =
                                        await _checkInternetConnection();
                                    if (!hasConnection) {
                                      _showConnectionDialog();
                                      return;
                                    }
                                    _saveInstansi();
                                  },
                            icon: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF1565C0),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.cloud_upload,
                                    color: Color(0xFF1565C0),
                                  ),
                            label: Text(
                              _isLoading
                                  ? 'Menyimpan ke Database...'
                                  : 'Simpan ke Database',
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

                      // Info Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.1),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.white70,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Data instansi dan pangkat akan disimpan ke Firebase Firestore dan dapat digunakan untuk simulasi gaji.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
