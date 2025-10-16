import 'package:flutter/material.dart';
import 'package:newsd/homscreen/saveddatascreenview.dart';
import 'package:newsd/service/storagefileview.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, String> details;

  const ResultScreen({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Extracted Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...details.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  "${e.key}: ${e.value}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await StorageService.saveDetails(details);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Data stored successfully!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Save Details"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SavedDataScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("View Saved Data"),
            ),
          ],
        ),
      ),
    );
  }
}
