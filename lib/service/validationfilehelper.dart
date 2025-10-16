import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  static Future<Map<String, String>> extractText(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = TextRecognizer();
      final recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      String fullText = recognizedText.text.trim();
      if (fullText.isEmpty) {
        return {
          'Name': 'Not found',
          'Phone': 'Not found',
          'Email': 'Not found',
        };
      }

      return _parseText(fullText);
    } catch (e) {
      return {'Name': 'Error', 'Phone': 'Error', 'Email': 'Error'};
    }
  }

  static Map<String, String> _parseText(String text) {
    String name = '';
    String phone = '';
    String email = '';

    List<String> lines =
        text
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

    // Email
    RegExp emailRegex = RegExp(
      r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
    );
    for (String line in lines) {
      if (emailRegex.hasMatch(line)) {
        email = emailRegex.firstMatch(line)?.group(0) ?? '';
        break;
      }
    }

    // Phone
    RegExp phoneRegex = RegExp(r'(\+91[\s-]?)?[6-9]\d{9}');
    for (String line in lines) {
      if (phoneRegex.hasMatch(line)) {
        phone = phoneRegex.firstMatch(line)?.group(0)?.trim() ?? '';
        break;
      }
    }

    // ✅ Name only if keyword like “name” found
    RegExp nameKeyword = RegExp(
      r'(name[:\-]?\s*)([A-Za-z\s]+)',
      caseSensitive: false,
    );
    for (String line in lines) {
      if (nameKeyword.hasMatch(line)) {
        name = nameKeyword.firstMatch(line)?.group(2)?.trim() ?? '';
        break;
      }
    }

    // fallback if not found explicitly
    if (name.isEmpty) name = 'Not found';

    return {
      'Name': name,
      'Phone': phone.isNotEmpty ? phone : 'Not found',
      'Email': email.isNotEmpty ? email : 'Not found',
    };
  }
}
