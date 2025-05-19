import 'package:flutter/material.dart';

class AddEducationPage extends StatefulWidget {
  const AddEducationPage({Key? key}) : super(key: key);

  @override
  _AddEducationPageState createState() => _AddEducationPageState();
}

class _AddEducationPageState extends State<AddEducationPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveEducationMaterial() {
    // Implement the save logic here (e.g., call an API to save data)
    String title = _titleController.text;
    String description = _descriptionController.text;

    print('New Education Material:');
    print('Title: $title');
    print('Description: $description');

    // After saving, you can pop the page and return to the previous page
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Materi Edukasi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Materi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Materi',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: _saveEducationMaterial,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
