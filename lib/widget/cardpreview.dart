import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CardPreview extends StatelessWidget {
  final XFile? image;

  const CardPreview({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child:
          image == null
              ? const Center(child: Text("No Image Selected"))
              : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(image!.path), fit: BoxFit.cover),
              ),
    );
  }
}
