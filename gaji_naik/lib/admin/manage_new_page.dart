import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageNewsPage extends StatefulWidget {
  const ManageNewsPage({super.key});

  @override
  _ManageNewsPageState createState() => _ManageNewsPageState();
}

class _ManageNewsPageState extends State<ManageNewsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String _searchQuery = '';
  String _statusFilter = 'Semua';

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
              // AppBar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                              Icons.newspaper,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Kelola Berita',
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
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () => _showAddNewsDialog(),
                        tooltip: 'Tambah Berita',
                      ),
                    ),
                  ],
                ),
              ),

              // Search and Filter
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withOpacity(0.95),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari berita...',
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF1565C0)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Status Filter
                    Row(
                      children: [
                        const Text(
                          'Filter Status:',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white.withOpacity(0.95),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _statusFilter,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              items: ['Semua', 'Aktif', 'Draft', 'Arsip'].map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _statusFilter = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // News List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('berita').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return _buildErrorWidget('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingWidget();
                    }

                    // Filter dan sort secara manual di client side
                    List<DocumentSnapshot> allDocs = snapshot.data?.docs ?? [];
                    
                    // Filter by search query dan status
                    List<DocumentSnapshot> filteredDocs = allDocs.where((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      
                      // Filter by search query
                      bool matchesSearch = _searchQuery.isEmpty ||
                          data['judul']?.toString().toLowerCase().contains(_searchQuery) == true ||
                          data['konten']?.toString().toLowerCase().contains(_searchQuery) == true;
                      
                      // Filter by status
                      bool matchesStatus = _statusFilter == 'Semua' ||
                          data['status'] == _statusFilter;
                      
                      return matchesSearch && matchesStatus;
                    }).toList();

                    // Sort manual by tanggal_dibuat (descending)
                    filteredDocs.sort((a, b) {
                      Map<String, dynamic> dataA = a.data() as Map<String, dynamic>;
                      Map<String, dynamic> dataB = b.data() as Map<String, dynamic>;
                      
                      Timestamp timestampA = dataA['tanggal_dibuat'] ?? Timestamp.now();
                      Timestamp timestampB = dataB['tanggal_dibuat'] ?? Timestamp.now();
                      
                      return timestampB.compareTo(timestampA); // Descending
                    });

                    if (filteredDocs.isEmpty) {
                      return _buildEmptyWidget();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredDocs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = filteredDocs[index];
                        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                        
                        return _buildNewsCard(doc.id, data);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsCard(String docId, Map<String, dynamic> data) {
    Color statusColor = _getStatusColor(data['status'] ?? 'Draft');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              children: [
                Expanded(
                  child: Text(
                    data['judul'] ?? 'Tanpa Judul',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1565C0),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    data['status'] ?? 'Draft',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Content preview
            Text(
              data['konten'] ?? 'Tidak ada konten',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 16),
            
            // Metadata
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 6),
                Text(
                  _formatDate(data['tanggal_dibuat']),
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Icon(Icons.visibility, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 6),
                Text(
                  '${data['views'] ?? 0} views',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showEditNewsDialog(docId, data),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _toggleNewsStatus(docId, data),
                    icon: Icon(
                      data['status'] == 'Aktif' ? Icons.pause : Icons.play_arrow,
                      size: 16,
                    ),
                    label: Text(data['status'] == 'Aktif' ? 'Nonaktifkan' : 'Aktifkan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: data['status'] == 'Aktif' ? Colors.orange : Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _deleteNews(docId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  child: const Icon(Icons.delete, size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNewsDialog() {
    _showNewsDialog(isEdit: false);
  }

  void _showEditNewsDialog(String docId, Map<String, dynamic> data) {
    _showNewsDialog(isEdit: true, docId: docId, existingData: data);
  }

  void _showNewsDialog({
    bool isEdit = false,
    String? docId,
    Map<String, dynamic>? existingData,
  }) {
    final TextEditingController judulController = TextEditingController(
      text: existingData?['judul'] ?? '',
    );
    final TextEditingController kontenController = TextEditingController(
      text: existingData?['konten'] ?? '',
    );
    final TextEditingController linkController = TextEditingController(
      text: existingData?['link_eksternal'] ?? '',
    );
    
    String selectedStatus = existingData?['status'] ?? 'Draft';
    String selectedKategori = existingData?['kategori'] ?? 'Umum';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Edit Berita' : 'Tambah Berita Baru'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: judulController,
                    decoration: const InputDecoration(
                      labelText: 'Judul Berita *',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: kontenController,
                    decoration: const InputDecoration(
                      labelText: 'Konten Berita *',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: linkController,
                    decoration: const InputDecoration(
                      labelText: 'Link Eksternal (Opsional)',
                      border: OutlineInputBorder(),
                      hintText: 'https://...',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedKategori,
                          decoration: const InputDecoration(
                            labelText: 'Kategori',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Umum', 'Regulasi', 'Kenaikan Gaji', 'Tutorial', 'Pengumuman']
                              .map((kategori) => DropdownMenuItem(
                                    value: kategori,
                                    child: Text(kategori),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedKategori = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Draft', 'Aktif', 'Arsip']
                              .map((status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedStatus = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () => _saveNews(
                        isEdit: isEdit,
                        docId: docId,
                        judul: judulController.text,
                        konten: kontenController.text,
                        link: linkController.text,
                        kategori: selectedKategori,
                        status: selectedStatus,
                      ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEdit ? 'Update' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveNews({
    required bool isEdit,
    String? docId,
    required String judul,
    required String konten,
    required String link,
    required String kategori,
    required String status,
  }) async {
    if (judul.trim().isEmpty || konten.trim().isEmpty) {
      _showSnackBar('Judul dan konten harus diisi!', Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> data = {
        'judul': judul.trim(),
        'konten': konten.trim(),
        'link_eksternal': link.trim().isEmpty ? null : link.trim(),
        'kategori': kategori,
        'status': status,
        'tanggal_diperbarui': FieldValue.serverTimestamp(),
      };

      if (isEdit && docId != null) {
        await _firestore.collection('berita').doc(docId).update(data);
        _showSnackBar('Berita berhasil diperbarui!', Colors.green);
      } else {
        data['views'] = 0;
        data['tanggal_dibuat'] = FieldValue.serverTimestamp();
        data['created_by'] = _auth.currentUser?.uid;
        await _firestore.collection('berita').add(data);
        _showSnackBar('Berita berhasil ditambahkan!', Colors.green);
      }

      Navigator.pop(context);
    } catch (e) {
      _showSnackBar('Error: $e', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleNewsStatus(String docId, Map<String, dynamic> data) async {
    String currentStatus = data['status'] ?? 'Draft';
    String newStatus = currentStatus == 'Aktif' ? 'Draft' : 'Aktif';

    try {
      await _firestore.collection('berita').doc(docId).update({
        'status': newStatus,
        'tanggal_diperbarui': FieldValue.serverTimestamp(),
      });

      _showSnackBar(
        'Status berita berhasil diubah menjadi $newStatus',
        Colors.green,
      );
    } catch (e) {
      _showSnackBar('Error: $e', Colors.red);
    }
  }

  Future<void> _deleteNews(String docId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus berita ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _firestore.collection('berita').doc(docId).delete();
                _showSnackBar('Berita berhasil dihapus!', Colors.green);
              } catch (e) {
                _showSnackBar('Error: $e', Colors.red);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Aktif':
        return Colors.green;
      case 'Draft':
        return Colors.orange;
      case 'Arsip':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Tanggal tidak tersedia';
    
    try {
      DateTime date = (timestamp as Timestamp).toDate();
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Tanggal tidak valid';
    }
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Memuat berita...',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.white, size: 64),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.newspaper, color: Colors.white, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Belum ada berita',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty || _statusFilter != 'Semua'
                ? 'Tidak ada berita yang sesuai dengan filter'
                : 'Tambahkan berita pertama Anda',
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}