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

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final XFile? pickedVideo =
        await _picker.pickVideo(source: ImageSource.gallery);
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

  void _saveEducationMaterial() {
    String title = _titleController.text;
    String description = _descriptionController.text;

    print('New Education Material:');
    print('Title: $title');
    print('Description: $description');
    print('Image Path: ${_imageFile?.path ?? "Tidak ada"}');
    print('Video Path: ${_videoFile?.path ?? "Tidak ada"}');

    // TODO: Upload image & video ke server/storage dan simpan metadata

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Materi Edukasi',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 2,
        backgroundColor: Colors.indigo.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Judul Materi',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.indigo.shade400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.indigo.shade400, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),

              // Deskripsi
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Materi',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.indigo.shade400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.indigo.shade400, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),

              // Tombol Upload Foto dan Preview
              Text(
                'Foto (opsional):',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo.shade700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo, color: Colors.black),
                    label: const Text(
                      'Pilih Foto',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _imageFile!,
                            width: 100,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Text('Belum ada foto dipilih'),
                ],
              ),
              const SizedBox(height: 30),

              // Tombol Upload Video dan Preview
              Text(
                'Video (opsional):',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo.shade700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickVideo,
                    icon: const Icon(Icons.videocam, color: Colors.black),
                    label: const Text(
                      'Pilih Video',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  _videoFile != null && _videoController != null
                      ? Container(
                          width: 150,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.indigo.shade400),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _videoController!.value.isInitialized
                                ? AspectRatio(
                                    aspectRatio:
                                        _videoController!.value.aspectRatio,
                                    child: VideoPlayer(_videoController!),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator()),
                          ),
                        )
                      : const Text('Belum ada video dipilih'),
                ],
              ),
              const SizedBox(height: 40),

              // Tombol Simpan
              Center(
                child: ElevatedButton(
                  onPressed: _saveEducationMaterial,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 90, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: Colors.amber.shade300,
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
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
