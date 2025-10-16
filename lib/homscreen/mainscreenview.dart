import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:newsd/service/validationfilehelper.dart';
import 'package:newsd/homscreen/allsaveddata.dart';
import 'package:newsd/service/storagefileview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? _image;
  Map<String, String> _extractedDetails = {};

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _image = pickedFile);
    }
  }

  Future<void> _extractText() async {
    if (_image == null) return;
    final details = await OcrService.extractText(File(_image!.path));
    setState(() => _extractedDetails = details);
  }

  Future<void> _saveDetails() async {
    if (_extractedDetails.isEmpty) return;
    await StorageService.saveDetails(_extractedDetails);
    setState(() => _extractedDetails = {});
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Details saved!")));
  }

  Widget _designButton(
    String text,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Visiting Card Scanner",
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child:
                  _image != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: PhotoView(
                          imageProvider: FileImage(File(_image!.path)),
                          backgroundDecoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          minScale: PhotoViewComputedScale.contained,
                          maxScale: PhotoViewComputedScale.covered * 3,
                        ),
                      )
                      : const Center(
                        child: Text(
                          "No image selected",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _designButton(
                        "Camera",
                        Colors.blue,
                        Icons.camera_alt,
                        () => _pickImage(ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _designButton(
                        "Gallery",
                        Colors.purple,
                        Icons.photo,
                        () => _pickImage(ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _designButton(
                  "Extract Text",
                  Colors.teal,
                  Icons.text_fields,
                  _extractText,
                ),
                const SizedBox(height: 16),
                if (_extractedDetails.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Extracted Details:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ..._extractedDetails.entries
                          .map((e) => Text("${e.key}: ${e.value}"))
                          .toList(),
                      const SizedBox(height: 12),
                      _designButton(
                        "Save Details",
                        Colors.green,
                        Icons.save,
                        _saveDetails,
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                _designButton(
                  "View All Saved Data",
                  Colors.orange,
                  Icons.folder,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AllSavedDataScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
