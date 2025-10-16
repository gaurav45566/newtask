import 'package:flutter/material.dart';
import 'package:newsd/service/storagefileview.dart';

class AllSavedDataScreen extends StatefulWidget {
  const AllSavedDataScreen({super.key});

  @override
  State<AllSavedDataScreen> createState() => _AllSavedDataScreenState();
}

class _AllSavedDataScreenState extends State<AllSavedDataScreen> {
  List<Map<String, String>> allDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    print("🔄 Loading all saved data...");
    setState(() => isLoading = true);

    try {
      List<Map<String, String>> data = await StorageService.loadDetails();
      print("✅ Loaded ${data.length} cards");
      setState(() {
        allDetails = data;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error loading: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteCard(int index) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Card"),
            content: const Text("Are you sure you want to delete this card?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text("Delete"),
              ),
            ],
          ),
    );

    if (confirm == true) {
      setState(() => allDetails.removeAt(index));

      // Save updated list
      await StorageService.clearAll();
      for (var card in allDetails) {
        await StorageService.saveDetails(card);
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Card deleted")));
    }
  }

  Future<void> _clearAllData() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Clear All Data"),
            content: const Text("This will delete all saved cards. Continue?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text("Clear All"),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await StorageService.clearAll();
      setState(() => allDetails = []);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("All data cleared")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Cards (${allDetails.length})"),
        actions: [
          if (allDetails.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearAllData,
              tooltip: "Clear All",
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: "Refresh",
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : allDetails.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.credit_card_off,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No saved cards yet",
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Scan a card to get started",
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: allDetails.length,
                itemBuilder: (context, index) {
                  Map<String, String> card = allDetails[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Card ${index + 1}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _deleteCard(index),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 8),

                          // Card Details
                          ...card.entries.map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      "${e.key}:",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.value,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
