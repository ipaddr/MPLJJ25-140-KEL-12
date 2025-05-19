import 'package:flutter/material.dart';

class ManageReportsPage extends StatefulWidget {
  const ManageReportsPage({Key? key}) : super(key: key);

  @override
  _ManageReportsPageState createState() => _ManageReportsPageState();
}

class _ManageReportsPageState extends State<ManageReportsPage> {
  // Example data for reports, replace with actual data source
  List<Map<String, dynamic>> _reports = [
    {'id': 1, 'title': 'Laporan 1', 'status': 'Proses'},
    {'id': 2, 'title': 'Laporan 2', 'status': 'Proses'},
    {'id': 3, 'title': 'Laporan 3', 'status': 'Proses'},
  ];

  // Available status options
  final List<String> _statusOptions = ['Proses', 'Selesai'];

  void _updateStatus(int reportId, String newStatus) {
    setState(() {
      // Find the report by ID and update its status
      _reports.firstWhere((report) => report['id'] == reportId)['status'] = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Laporan Masalah'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Daftar Laporan Masalah',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Display the list of reports
            Expanded(
              child: ListView.builder(
                itemCount: _reports.length,
                itemBuilder: (context, index) {
                  var report = _reports[index];
                  return Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            report['title'],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          // Dropdown for status
                          DropdownButton<String>(
                            value: report['status'],
                            onChanged: (String? newStatus) {
                              if (newStatus != null) {
                                _updateStatus(report['id'], newStatus);
                              }
                            },
                            items: _statusOptions.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          // Update button
                          ElevatedButton(
                            onPressed: () {
                              // Optionally, you can add additional logic when the update button is pressed.
                              print('Laporan ${report['title']} status updated to: ${report['status']}');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ), // Button color
                            ),
                            child: const Text('Update Status'),
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
