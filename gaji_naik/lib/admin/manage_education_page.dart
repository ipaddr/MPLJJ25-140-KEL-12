import 'package:flutter/material.dart';
import 'add_education_page.dart'; // Import AddEducationPage

class ManageEducationPage extends StatefulWidget {
  const ManageEducationPage({Key? key}) : super(key: key);

  @override
  _ManageEducationPageState createState() => _ManageEducationPageState();
}

class _ManageEducationPageState extends State<ManageEducationPage> {
  // TODO: Fetch list of education materials from data source

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Edukasi'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Materi Edukasi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to AddEducationPage when pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddEducationPage()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Baru'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // TODO: Implement a ListView or other widget to display the list of education materials
            Expanded(
              child: Center(
                child: Text('Daftar materi edukasi akan ditampilkan di sini.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
