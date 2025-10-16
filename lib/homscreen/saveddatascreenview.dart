import 'package:flutter/material.dart';
import 'package:newsd/service/storagefileview.dart';

class SavedDataScreen extends StatefulWidget {
  const SavedDataScreen({super.key});

  @override
  State<SavedDataScreen> createState() => _SavedDataScreenState();
}

class _SavedDataScreenState extends State<SavedDataScreen> {
  List<Map<String, String>> savedCards = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Load all saved cards from StorageService
    List<Map<String, String>> cards = await StorageService.loadDetails();
    setState(() => savedCards = cards);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Card Details")),
      body:
          savedCards.isEmpty
              ? const Center(child: Text("No saved cards yet."))
              : ListView.builder(
                itemCount: savedCards.length,
                itemBuilder: (context, index) {
                  Map<String, String> card = savedCards[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            card.entries
                                .map((e) => Text("${e.key}: ${e.value}"))
                                .toList(),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
