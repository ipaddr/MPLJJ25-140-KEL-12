import 'package:flutter/material.dart';

class ManageReportsPage extends StatefulWidget {
  const ManageReportsPage({Key? key}) : super(key: key);

  @override
  _ManageReportsPageState createState() => _ManageReportsPageState();
}

class _ManageReportsPageState extends State<ManageReportsPage> {
  List<Map<String, dynamic>> _reports = [
    {'id': 1, 'title': 'Laporan 1', 'status': 'Proses'},
    {'id': 2, 'title': 'Laporan 2', 'status': 'Proses'},
    {'id': 3, 'title': 'Laporan 3', 'status': 'Proses'},
  ];

  final List<String> _statusOptions = ['Proses', 'Selesai'];

  void _updateStatus(int reportId, String newStatus) {
    setState(() {
      _reports.firstWhere((report) => report['id'] == reportId)['status'] = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Laporan Masalah', style: TextStyle(fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
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
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Daftar Laporan Masalah',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _reports.length,
                itemBuilder: (context, index) {
                  var report = _reports[index];
                  return Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 18),
                    shadowColor: Colors.blueAccent.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            report['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: report['status'],
                              icon: const Icon(Icons.arrow_drop_down, size: 28, color: Colors.blueAccent),
                              isExpanded: true,
                              dropdownColor: Colors.white,
                              onChanged: (String? newStatus) {
                                if (newStatus != null) {
                                  _updateStatus(report['id'], newStatus);
                                }
                              },
                              items: _statusOptions.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                print('Laporan ${report['title']} status updated to: ${report['status']}');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 3,
                                shadowColor: Colors.blueAccent.shade100,
                              ),
                              child: const Text(
                                'Update Status',
                                style: TextStyle(
                                  fontSize: 16,
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
