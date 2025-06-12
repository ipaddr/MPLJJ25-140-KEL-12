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
  bool _isLoading = false;

  final List<String> _instansiOptions = [
    'Instansi A',
    'Instansi B',
    'Instansi C'
  ];

  @override
  void dispose() {
    _golonganController.dispose();
    _jabatanController.dispose();
    _rumusController.dispose();
    super.dispose();
  }

  void _saveSimulasi() async {
    if (_selectedInstansi == null ||
        _golonganController.text.isEmpty ||
        _jabatanController.text.isEmpty ||
        _rumusController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua field'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate saving
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    String? instansi = _selectedInstansi;
    String golongan = _golonganController.text;
    String jabatan = _jabatanController.text;
    String rumus = _rumusController.text;

    print('Save Simulasi attempt with:');
    print('  Instansi: $instansi');
    print('  Golongan: $golongan');
    print('  Jabatan: $jabatan');
    print('  Rumus: $rumus');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulasi berhasil disimpan'),
        backgroundColor: Colors.green,
      ),
    );

    // Clear form
    setState(() {
      _selectedInstansi = null;
    });
    _golonganController.clear();
    _jabatanController.clear();
    _rumusController.clear();
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
                              Icons.calculate_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Simulasi Gaji Admin',
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
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.settings_applications,
                                size: 40,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Konfigurasi Simulasi',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Atur parameter perhitungan gaji untuk simulasi',
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

                      // Form Section
                      const Text(
                        'Parameter Simulasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Instansi Dropdown
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
                          value: _selectedInstansi,
                          hint: const Text('Pilih Instansi'),
                          decoration: InputDecoration(
                            labelText: 'Instansi',
                            labelStyle: const TextStyle(color: Colors.green),
                            prefixIcon:
                                const Icon(Icons.business, color: Colors.green),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                          items: _instansiOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedInstansi = newValue;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Golongan Field
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
                          controller: _golonganController,
                          decoration: InputDecoration(
                            labelText: 'Golongan',
                            labelStyle: const TextStyle(color: Colors.green),
                            prefixIcon:
                                const Icon(Icons.grade, color: Colors.green),
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

                      const SizedBox(height: 20),

                      // Jabatan Field
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
                          controller: _jabatanController,
                          decoration: InputDecoration(
                            labelText: 'Jabatan',
                            labelStyle: const TextStyle(color: Colors.green),
                            prefixIcon:
                                const Icon(Icons.work, color: Colors.green),
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

                      const SizedBox(height: 20),

                      // Rumus Field
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
                          controller: _rumusController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Rumus Perhitungan',
                            alignLabelWithHint: true,
                            labelStyle: const TextStyle(color: Colors.green),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 80),
                              child: Icon(Icons.functions, color: Colors.green),
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

                      const SizedBox(height: 30),

                      // Info Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue.withOpacity(0.1),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: Colors.blue, size: 24),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Rumus perhitungan akan digunakan untuk simulasi gaji ASN berdasarkan parameter yang ditentukan.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

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
                            onPressed: _isLoading ? null : _saveSimulasi,
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
                                    Icons.save,
                                    color: Color(0xFF1565C0),
                                  ),
                            label: Text(
                              _isLoading
                                  ? 'Menyimpan...'
                                  : 'Simpan Konfigurasi',
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
