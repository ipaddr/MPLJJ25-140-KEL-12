import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class AddEducationPage extends StatefulWidget {
  const AddEducationPage({Key? key}) : super(key: key);

  @override
  _AddEducationPageState createState() => _AddEducationPageState();
}

class _AddEducationPageState extends State<AddEducationPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _imageFile;
  File? _videoFile;
  VideoPlayerController? _videoController;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final XFile? pickedVideo = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(File(pickedVideo.path))
        ..initialize().then((_) {
          setState(() {});
          _videoController?.setLooping(true);
          _videoController?.play();
        });
      setState(() {
        _videoFile = File(pickedVideo.path);
      });
    }
  }

  void _saveEducationMaterial() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi judul dan deskripsi'),
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

    String title = _titleController.text;
    String description = _descriptionController.text;

    print('New Education Material:');
    print('Title: $title');
    print('Description: $description');
    print('Image Path: ${_imageFile?.path ?? "Tidak ada"}');
    print('Video Path: ${_videoFile?.path ?? "Tidak ada"}');

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Materi edukasi berhasil ditambahkan'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
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
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Tambah Materi Edukasi',
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
                        onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
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
                                color: Colors.purple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.school,
                                size: 40,
                                color: Colors.purple,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Buat Materi Edukasi',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Tambahkan konten edukatif untuk ASN',
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
                        'Informasi Materi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Title Field
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
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Judul Materi',
                            labelStyle: const TextStyle(color: Colors.purple),
                            prefixIcon: const Icon(Icons.title, color: Colors.purple),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Description Field
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
                          controller: _descriptionController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Deskripsi Materi',
                            alignLabelWithHint: true,
                            labelStyle: const TextStyle(color: Colors.purple),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 80),
                              child: Icon(Icons.description, color: Colors.purple),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Media Section
                      const Text(
                        'Media Pendukung',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Image Upload Section
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.photo, color: Colors.orange, size: 24),
                                const SizedBox(width: 8),
                                const Text(
                                  'Foto (Opsional)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton.icon(
                                  onPressed: _pickImage,
                                  icon: const Icon(Icons.upload, color: Colors.white),
                                  label: const Text(
                                    'Pilih Foto',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (_imageFile != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _imageFile!,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Video Upload Section
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.videocam, color: Colors.red, size: 24),
                                const SizedBox(width: 8),
                                const Text(
                                  'Video (Opsional)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton.icon(
                                  onPressed: _pickVideo,
                                  icon: const Icon(Icons.upload, color: Colors.white),
                                  label: const Text(
                                    'Pilih Video',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (_videoFile != null && _videoController != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: _videoController!.value.isInitialized
                                      ? AspectRatio(
                                          aspectRatio: _videoController!.value.aspectRatio,
                                          child: VideoPlayer(_videoController!),
                                        )
                                      : const Center(child: CircularProgressIndicator()),
                                ),
                              ),
                            ],
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
                            onPressed: _isLoading ? null : _saveEducationMaterial,
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
                              _isLoading ? 'Menyimpan...' : 'Simpan Materi',
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
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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