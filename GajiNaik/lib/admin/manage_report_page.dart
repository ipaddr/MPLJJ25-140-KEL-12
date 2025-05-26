import 'package:flutter/material.dart';

class ManageReportsPage extends StatefulWidget {
  const ManageReportsPage({Key? key}) : super(key: key);

  @override
  _ManageReportsPageState createState() => _ManageReportsPageState();
}

class _ManageReportsPageState extends State<ManageReportsPage> {
  List<Map<String, dynamic>> _reports = [
    {
      'id': 1,
      'title': 'Belum Menerima Kenaikan Gaji',
      'description': 'Saya belum menerima kenaikan gaji sesuai PP terbaru',
      'user': 'Ahmad Budiman',
      'date': '2025-01-20',
      'status': 'Proses',
      'priority': 'High'
    },
    {
      'id': 2,
      'title': 'Kenaikan Tidak Sesuai Golongan',
      'description':
          'Kenaikan yang diterima tidak sesuai dengan golongan III/c',
      'user': 'Siti Nurhaliza',
      'date': '2025-01-19',
      'status': 'Proses',
      'priority': 'Medium'
    },
    {
      'id': 3,
      'title': 'Data Gaji Tidak Update',
      'description': 'Data gaji di sistem masih menampilkan nilai lama',
      'user': 'Budi Santoso',
      'date': '2025-01-18',
      'status': 'Selesai',
      'priority': 'Low'
    },
  ];

  final List<String> _statusOptions = ['Proses', 'Selesai'];

  void _updateStatus(int reportId, String newStatus) {
    setState(() {
      _reports.firstWhere((report) => report['id'] == reportId)['status'] =
          newStatus;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status laporan berhasil diupdate'),
        backgroundColor: Colors.green,
      ),
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
                              Icons.support_agent,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Kelola Laporan',
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
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.assignment,
                                size: 40,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Manajemen Laporan',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Kelola dan pantau laporan masalah ASN',
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

                      // Reports Section Header
                      const Text(
                        'Daftar Laporan Masalah',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Reports List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _reports.length,
                        itemBuilder: (context, index) {
                          final report = _reports[index];
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
                                  // Header Row
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: _getPriorityColor(
                                                  report['priority'])
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: _getPriorityColor(
                                                    report['priority'])
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          report['priority'],
                                          style: TextStyle(
                                            color: _getPriorityColor(
                                                report['priority']),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: report['status'] == 'Selesai'
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.orange.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: report['status'] == 'Selesai'
                                                ? Colors.green.withOpacity(0.3)
                                                : Colors.orange
                                                    .withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          report['status'],
                                          style: TextStyle(
                                            color: report['status'] == 'Selesai'
                                                ? Colors.green[700]
                                                : Colors.orange[700],
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // Title
                                  Text(
                                    report['title'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Description
                                  Text(
                                    report['description'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                      height: 1.3,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // User and Date Info
                                  Row(
                                    children: [
                                      Icon(Icons.person,
                                          size: 16, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Text(
                                        report['user'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Icon(Icons.calendar_today,
                                          size: 16, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Text(
                                        report['date'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // Status Update Section
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: report['status'],
                                              isExpanded: true,
                                              onChanged: (String? newStatus) {
                                                if (newStatus != null) {
                                                  _updateStatus(
                                                      report['id'], newStatus);
                                                }
                                              },
                                              items: _statusOptions.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12),
                                                    child: Text(
                                                      value,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      ElevatedButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Laporan ${report['title']} diproses'),
                                              backgroundColor: Colors.blue,
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                        ),
                                        child: const Text(
                                          'Detail',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
